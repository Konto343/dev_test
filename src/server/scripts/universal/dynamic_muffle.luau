--!strict

local module = {}

-- Place in StarterPlayerScripts
local state = false

local local_player = game.Players.LocalPlayer
local char = local_player.Character or local_player.CharacterAdded:Wait()

local hrp = char:WaitForChild("HumanoidRootPart",4)
local ts = game:GetService("TweenService")

local tracking = {}
local loop = nil

local muffle = Instance.new('EqualizerSoundEffect')
muffle.Name = 'muffle_eq'
muffle.HighGain = 0
muffle.LowGain = 0
muffle.MidGain = 0
muffle.Parent = script

function raycast_collision(from, to_part:BasePart, more_filters, break_at_first_hit : boolean, ignore_invisible : boolean) : {BasePart} --more_filters : table
	if not to_part then
		return {}
	end

	local origin = from.Position
	local direction = (to_part.Position - origin).Unit * (to_part.Position - origin).Magnitude

	local raycast_param = RaycastParams.new()
	local filter_list = {from, to_part}

	if more_filters then
		table.insert(filter_list, more_filters)
	end

	raycast_param.IgnoreWater = true
	raycast_param.FilterType = Enum.RaycastFilterType.Exclude

	local hit_points = {}

	while task.wait() do
		raycast_param.FilterDescendantsInstances = filter_list
		local ray_result = workspace:Raycast(origin, direction, raycast_param)

		if ray_result then
			local hit = ray_result.Instance

			if ignore_invisible and hit.Transparency == 1 then
				table.insert(filter_list, hit)
				continue
			end

			table.insert(hit_points, hit)

			if break_at_first_hit then --if soild part add hit
				break
			end

			table.insert(filter_list, hit)
		else --if finished
			break
		end
	end

	return hit_points
end

function setup(sound_object : Instance)
	if not sound_object or not sound_object.Parent then
		return
	end
	
	if not sound_object:IsA("Sound") or sound_object:HasTag('cant_muffle') then
		return
	end

	if sound_object.Parent:IsA("BasePart") then --if the sound not playing globally
		if sound_object:HasTag('sound_zone') then --ignore sound zones
			return
		end

		for _, player in pairs(game.Players:GetPlayers()) do --if not apart of a player character
			if sound_object:IsDescendantOf(player.Character) then
				return
			end
		end

		local clone = muffle:Clone()
		clone.Parent = sound_object

		table.insert(tracking, sound_object)
	end
end

function sound_loop()
	local tween_speed = .25
	local time_between_parts = 1/20

	local from : BasePart = Instance.new('Part', workspace) --temp for calulation
	from.CanCollide = false
	from.CanQuery = false
	from.Anchored = true
	from.Transparency = 1
	from.Position = workspace.CurrentCamera.CFrame.Position

	local camera = game.Workspace.CurrentCamera
	local char_parts = char:GetDescendants()

	local is_visible = false
	local conn

	--while task.wait() do
	conn = game:GetService('RunService').Heartbeat:Connect(function()
		if not state then
			conn:Disconnect()
		end

		for index, sound_object in tracking do 
			local to_part : BasePart = sound_object.Parent
			from.CFrame = camera.CFrame

			if not sound_object or not to_part then
				table.remove(tracking, index) --remove item if no longer exists
			end

			local collisions = raycast_collision(from, to_part, char_parts, true, true)
			local muffle = sound_object:FindFirstChildWhichIsA('EqualizerSoundEffect')

			if not collisions then
				continue
			end
			
			if muffle then
				if #collisions >= 1 then --then being blocked
					local distance = (from.Position - to_part.Position).Magnitude
					muffle.HighGain = -50 * (math.sqrt(distance)/5)
					muffle.MidGain = -30 * (math.sqrt(distance)/5)
				else
					muffle.HighGain = 0
					muffle.MidGain = 0
				end
			end
		end
	end)
end

for _,obj in workspace:GetDescendants() do
	setup(obj)
end

workspace.DescendantAdded:Connect(function(obj)
	setup(obj)
end)

module.toggle_state = function(override)
	state = override or not state

	if state then
		local coro = coroutine.create(sound_loop)
		loop = coro
		coroutine.resume(loop)
	else
		if loop then
			coroutine.close(loop)
		end
	end
end

return module
