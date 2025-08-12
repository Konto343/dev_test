--!strict

local module = {}

local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local debris = game:GetService('Debris')

--[[
	Play a sound from a sound id and parent
]]
module.play_sound = function(id : number, parent, volume, speed, off_max, off_min) : Sound
	local clone = Instance.new('Sound')
	clone.SoundId = 'rbxassetid://'..id

	clone.Volume = volume or 1
	clone.PlaybackSpeed = speed or 1

	clone.RollOffMaxDistance = off_max or 20000
	clone.RollOffMinDistance = off_min or 1
	
	clone.Parent = parent or workspace
	
	clone:Play()

	clone.Ended:Connect(function()
		clone:Destroy()
	end)
	
	return clone
end

--[[
	Draw a raycast from a start to end point.
	Returns a list of objects intersecting the raycast.
	Will return the first collidable object if break_at_hit is True.
	Returns all hits in a list.
]]
module.raycast = function(start_point : BasePart, end_point : BasePart, ignore_invisible : boolean, break_at_hit : boolean) : {BasePart}
	local origin = start_point.Position
	local direction = (end_point.Position - origin).Unit * (end_point.Position - origin).Magnitude
	
	local filter_list = {start_point, end_point}
	local hit_points = {}
	
	local raycast_param = RaycastParams.new()
	raycast_param.IgnoreWater = true
	raycast_param.FilterType = Enum.RaycastFilterType.Exclude

	while task.wait() do
		raycast_param.FilterDescendantsInstances = filter_list --update list (this must be here bruh)
		local ray = workspace:Raycast(origin, direction, raycast_param)

		if ray then
			local hit : BasePart = ray.Instance
			
			if hit.Transparency ~= 0 and ignore_invisible then
				table.insert(filter_list, hit)
				continue
			end
			
			table.insert(filter_list, hit)
		
			if hit.CanCollide == true then
				table.insert(hit_points, hit)
				if break_at_hit then
					break
				end
			end
		end

		if not ray then
			break
		end
	end

	return hit_points
end

--[[
	Apply a dragging interaction to UI that uses tweens.
	Returns all the connections used to handle the dragging in a list.
]]
module.apply_ui_smooth_drag = function(frame : Frame, drag_speed : number, enable_dt_rotation : boolean) : {RBXScriptConnection}
	local drag_speed = drag_speed or .1

	local drag_toggle
	local drag_input
	local drag_start
	local start_position

	local function update_drag(Input)
		local delta = Input.Position - drag_start

		local pos = UDim2.new(
			start_position.X.Scale, 
			start_position.X.Offset + delta.X, 
			start_position.Y.Scale, start_position.Y.Offset + delta.Y)

		if enable_dt_rotation then
			local rot = ((delta.X + delta.Y) / 2) / 10
			ts:Create(frame, TweenInfo.new(drag_speed), {Rotation = rot}):Play()
		end

		ts:Create(frame, TweenInfo.new(drag_speed), {Position = pos}):Play()
	end

	local began_connection = frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch) 
			and uis:GetFocusedTextBox() == nil then

			drag_toggle = true
			drag_start = input.Position
			start_position = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					drag_toggle = false
				end
			end)
		end
	end)

	local changed_connection = frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch then
			drag_input = input
		end
	end)

	local user_connection = uis.InputChanged:Connect(function(Input)
		if Input == drag_input and drag_toggle then
			update_drag(Input)
		end
	end)

	return {began_connection, changed_connection, user_connection}
end

--[[
	Dies a spherical calualtion to check if a object is in proximity relative to another part given a set distance.
]]
module.in_radius = function(part : BasePart, within : BasePart, radius : number) : boolean
	local distance = (part.Position - within.Position).Magnitude
	return distance <= radius
end

--[[
	Make a part or "line" that goes from a start to end point.
	This is used for debug.
	Returns the line made.
]]
module.draw_3d_line = function(from : Vector3, to : Vector3, line_thickness : number, auto_remove : boolean) : BasePart
	line_thickness = line_thickness or .1
	
	local center = (from + to) / 2
	local distance = (from - to).Magnitude 	

	local line = Instance.new("Part")
	line.Size = Vector3.new(
		1 or line_thickness,
		1 or line_thickness,
		distance
	)
	line.CFrame = CFrame.new(center, to)
	line.Anchored = true
	line.Transparency = 0.8
	line.Parent = workspace
	
	line.CanQuery = false
	line.CanCollide = false
	line.CanTouch = false
	
	if auto_remove then
		debris:AddItem(line, .1)
	end
	
	return debris
end

--[[
	A recursive raycast that fires from a source part's LookVector. 
	Each ray will "bounce" off of surfaces with a set max bounce limit.
	Returns the positions of all the hits, including the very start as the first element in the list.
]]
module.raycast_bounce = function(source_part : BasePart, max_bounces : number, max_cast_distance : number) : {Vector3}
	local hits = {}
	table.insert(hits, source_part.Position)
	
	local function cast(direction : Vector3, position : Vector3)
		if #hits >= max_bounces then
			return
		end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {source_part}
		
		local draw_distance = max_cast_distance or 1000

		local raycast = workspace:Raycast(
			position, 
			(direction * draw_distance), --make a ray with 
			params
		)

		if raycast then
			if raycast.Position then
				table.insert(hits, raycast.Position)
				
				local cast_normal = raycast.Normal
				local new_direction = (direction - (2 * direction:Dot(cast_normal) * cast_normal))
				
				cast(new_direction, raycast.Position)
			else
				return
			end
		end
	end

	cast(source_part.CFrame.LookVector, source_part.Position) --start
	
	return hits
end

--[[
	Determines if a part is facing in the nearly same direction as another part
	Returns a boolean if the direction angle is met or not
	Angle = 0 to 1 ; float number. (e.g .5, .25, 0.001) | Default: 0.5
]]
module.is_looking = function(source : BasePart, at_part : BasePart, angle)
	local center_unit = (
		(at_part.Position - source.Position) * Vector3.new(1,0,1)
	).Unit
	local head_look_vector = source.CFrame.LookVector * Vector3.new(1,0,1)
	local doc_product = head_look_vector:Dot(center_unit)
	
	return doc_product > (angle or .5)
end

--[[
	Returns a two booleans if the object's viewport point is in the local player's screen
]]
module.is_in_view = function(object : BasePart) : Vector3 | boolean
	local camera = workspace.CurrentCamera
	local vector, in_view = camera:WorldToViewportPoint(object.Position)
	return vector, in_view
end

return module