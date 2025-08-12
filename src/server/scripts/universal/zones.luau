--!strict
local module = {}

local insert = table.insert
local find = table.find
local remove = table.remove

function debug_cube()
	local cube = Instance.new("Part")
	cube.Name = 'debug_cube'
	cube.Anchored = true
	cube.CanCollide = false
	cube.CanQuery = false
	cube.CanTouch = false
	cube.CastShadow = false
	cube.Size = Vector3.new(4,4,4)
	cube.Transparency = 0.6
	cube.Color = Color3.new(1, 0, 0)
	cube.Parent = workspace
	return cube
end

function module.new_zone(source_part : BasePart)
	local self = {}
	self.zone = source_part

	self.current_players = {}
	self.last = 0

	--add functions to table run if the event happens

	-----------------------------------------

	local debug_folder = workspace:FindFirstChild('debug')
	
	if not debug_folder then
		debug_folder = Instance.new('Folder')
		debug_folder.Parent = workspace
		debug_folder.Name = 'debug'
	end
	
	local test = debug_cube()
	test.CFrame = source_part.CFrame
	test.Size = source_part.Size
	test.Parent = debug_folder
	test.Transparency = 1

	-----------------------------------------

	self._leave_connections = {}
	self._on_leave = function(player)
		if not player then
			return
		end
		for _, func in self._leave_connections do
			func(player)
		end
	end
	function self:connect_at_leave(func)
		insert(self._leave_connections, func)
	end

	-----------------------------------------

	self._enter_connections = {}
	self._on_enter = function(player)
		if not player then
			return
		end
		for _, func in self._enter_connections do
			func(player)
		end
	end
	function self:connect_at_enter(func)
		insert(self._enter_connections, func)
	end

	-----------------------------------------

	self._at_difference = function(objects)
		local players = game.Players:GetPlayers()
		
		for _, plr in players do
			local hrp = plr.Character:FindFirstChild('HumanoidRootPart')
			if find(self.current_players, plr) and not find(objects, hrp) then --on list but not in zone
				remove(self.current_players, find(self.current_players, plr))
				self._on_leave(plr)
			end
		end

		for _, root_part in objects do
			local player = game.Players:GetPlayerFromCharacter(root_part.Parent)
			
			if not find(self.current_players, player) then --if not in current then must be entering
				insert(self.current_players, player)
				self._on_enter(player)
			end
		end
	end

	self._main_loop = game:GetService('RunService').Heartbeat:Connect(function()
		local objects = {}
		
		for _, part in workspace:GetPartsInPart(self.zone) do
			if part.Name == 'HumanoidRootPart' then
				insert(objects, part)
			end
		end

		if self.last ~= #objects then --if difference happened
			self.last = #objects
			self._at_difference(objects)
		end
	end)

	self.kill = function()
		self._main_loop:Disconnect()
	end

	return self
end

return module