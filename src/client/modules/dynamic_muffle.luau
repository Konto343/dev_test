--!strict

local module = {}

local local_player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera :: Camera
local char = local_player.Character or local_player.CharacterAdded:Wait() :: Model
local char_parts = char:GetDescendants()

local tracking = {}

local muffle = Instance.new('EqualizerSoundEffect')
muffle.Name = 'muffle_eq'
muffle.HighGain = 0
muffle.LowGain = 0
muffle.MidGain = 0
muffle.Parent = script

function raycast_inview(origin : Vector3, to : Vector3, filter : {Instance}) : boolean
	local difference = (to - origin)
	local direction = difference.Unit * difference.Magnitude

	local raycast_param = RaycastParams.new()
	local filter_list = filter
	raycast_param.IgnoreWater = true
	raycast_param.FilterType = Enum.RaycastFilterType.Exclude

	while true do
		raycast_param.FilterDescendantsInstances = filter_list
		local ray_result = workspace:Raycast(origin, direction, raycast_param)
		local hit = ray_result.Instance

		if ray_result then
			if hit.Transparency == 1 then
				table.insert(filter_list, hit)
				continue
			end

			return false
		else 
			break
		end
	end
	return true
end

function setup(sound : Sound)
	if not sound.Parent then
		return
	end
	
	if sound:HasTag('cant_muffle') or sound:HasTag('sound_zone') then
		return
	end
	
	--if playing globally
	if not sound.Parent:IsA("BasePart") then
		return
	end

	--if not apart of an player character
	for _, player in pairs(game.Players:GetPlayers()) do
		if sound:IsDescendantOf(player.Character) then
			return
		end
	end

	local clone = muffle:Clone()
	clone.Parent = sound
	table.insert(tracking, sound)
end

game:GetService('RunService').Heartbeat:Connect(function()
	for index, sound in tracking do 
		local parent = sound.Parent :: BasePart

		--remove item if no longer exists
		if not sound or not parent then
			table.remove(tracking, index)
		end

		local collisions = raycast_inview(camera.CFrame.Position, parent.Position, char_parts)
		local muffle = sound:FindFirstChildWhichIsA('EqualizerSoundEffect')
		
		if not muffle then
			continue
		end

		if not collisions then
			muffle.HighGain = -50 --* (math.sqrt(distance)/5)
			muffle.MidGain = -30 --* (math.sqrt(distance)/5)
		else
			muffle.HighGain = 0
			muffle.MidGain = 0
		end
	end
end)

for _,obj in workspace:GetDescendants() do
	if not obj:IsA('Sound') then
		continue
	end
	setup(obj)
end

workspace.DescendantAdded:Connect(function(obj)
	if not obj:IsA('Sound') then
		return
	end
	setup(obj)
end)

return module
