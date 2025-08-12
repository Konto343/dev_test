--!strict
-- Place in StarterPlayerScripts
local sounds_folder = Instance.new('Folder', script)
sounds_folder.Name = 'sounds'

local ts = game:GetService("TweenService")
local collection = game:GetService('CollectionService')

local sound_tween_time = 1.5
local default_volume = .4
local update_speed = 1/3
local checking_speed = 1
local zones = {}

function sub_find(t, key, search)
	for _,set in t do
		if set[key] == search then
			return set
		end
	end
	return false
end

function setup(part : Sound)
	if part:IsA('Sound') then
		local table_data = sub_find(zones, 'name', part.Name) --returns pointer for table set

		if table_data then 
			return 
		end --already loaded
		
		if not part:HasTag('sound_zone') then 
			return 
		end --no tag

		local clone = part:Clone()
		clone.Parent = sounds_folder

		table.insert(zones, {
			zone=part.Parent, 
			sound=clone,
			source_sound = part,
			name=part.Name
		})

		part.Changed:Connect(function(property)
			if property == 'Parent' then
				return
			end
			
			pcall(function()
				clone[property] = part[property]
			end)
		end)	
	end
end

collection:GetInstanceAddedSignal('sound_zone'):Connect(function(obj)
	setup(obj)
end)

while task.wait(update_speed) do
	local in_zones = {}

	for _, zone_data in zones do
		local zone : BasePart = zone_data['zone']
		
		if not zone then
			continue
		end

		local region = Region3.new(
			zone.Position-(zone.Size/2),
			zone.Position+(zone.Size/2)
		)
		local local_player = game.Players.LocalPlayer
		local character = local_player.Character or local_player.CharacterAdded:Wait()
		local hrp = character:FindFirstChild('HumanoidRootPart')
		
		if not hrp then
			continue 
		end
		
		local parts = workspace:FindPartsInRegion3WithWhiteList(
			region, {hrp} --character:GetDescendants()
		)

		local in_zone = #parts ~= 0
		local sound : Sound = zone_data['sound']

		if in_zone then
			local priority = 1
			
			local prior : NumberValue = sound:FindFirstChild('priority')
			
			if prior then
				priority = prior.Value
			end
			
			table.insert(in_zones, {
				zone=zone,
				sound=sound,
				source_sound = zone_data.source_sound,
				priority = priority
			})
		else
			local fade_out = ts:Create(
				sound,
				TweenInfo.new(sound_tween_time),
				{['Volume'] = 0}
			)
			fade_out:Play()
		end
	end

	if #in_zones >= 2 then --if in 2 or more
		table.sort(in_zones, function(a,b)
			return a.priority > b.priority
		end)
	end

	local active_zone = in_zones[1]

	if active_zone ~= nil then

		if not active_zone.sound.Playing then
			active_zone.sound:Play()
		end

		local fade_in = ts:Create(
			active_zone.sound,
			TweenInfo.new(sound_tween_time),
			{['Volume'] = active_zone.source_sound.Volume or default_volume}
		)
		fade_in:Play()
	end

	--print(in_zones)
	table.remove(in_zones, 1) --remove currently playin

	for _,zone in in_zones do
		local fade_out = ts:Create(
			zone.sound,
			TweenInfo.new(sound_tween_time),
			{['Volume'] = 0}
		)
		fade_out:Play()
	end
end