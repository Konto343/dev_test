--!strict

local module = {}
local config = require(script.Parent.config)

local players = game:GetService('Players')
local teams = game:GetService('Teams')

local top = script.Parent.Parent
local attach = top.attach
local client = top.client

module.ensure_object = function(object_name : string, object_class : string, path : any)
	local object = path:FindFirstChild(object_name)
	
	if not object then 
		object = Instance.new(object_class)
		object.Name = object_name
		object.Parent = path
	end
	
	return object
end

module.get_admin = function(user_id : number) : config.admin | nil
	for _, data in config.admins do
		if data.user_id == user_id then
			return data
		end
	end
	return nil
end

module.is_admin = function(user_id : number) : boolean
	local admin = module.get_admin(user_id)

	if not admin then
		return false
	end

	return admin.rank >= config.system.admin_level
end

module.process_admin = function(player : Player)
	if module.is_admin(player.UserId) then
		local player_gui = player:FindFirstChild('PlayerGui')

		local clone = client:Clone()
		clone.Parent = player_gui
		clone:SetAttribute('system_name', config.name)
		clone._init.Enabled = true
	end
end

module.update_admin = function(user_id : number, target_rank : number)
	local existing = module.get_admin(user_id)

	if not existing then
		config.admins[#config.admins+1] = {
			user_id = user_id, 
			rank = target_rank or 1
		}
		return
	end

	existing.rank = target_rank
end

module.get_player_rank = function(user_id : number)
	local admin = module.get_admin(user_id)

	if not admin then
		return -1
	end
	return admin.rank
end

module.message = function(player : Player, message : string, color : Color3 | nil)
	config.remote:InvokeClient(player, 'message', message, color)	
end

module.give_vanish = function(player : Player, admin_id : number)
	local clone = attach.vanish:Clone()
	clone:SetAttribute('user', admin_id)
	clone.Parent = player:FindFirstChild('PlayerGui')
	clone.Enabled = true
end

module.give_unvanish = function(player : Player, admin_id : number)
	local clone = attach.unvanish:Clone()
	clone:SetAttribute('user', admin_id)
	clone.Parent = player:FindFirstChild('PlayerGui')
	clone.Enabled = true
end

module.seek_player = function(input : string) : Player | nil
	for _, player in pairs(players:GetPlayers()) do
		local IsDisplay = player.DisplayName:lower():sub(1, #input) == input:lower()
		local IsName = player.Name:lower():sub(1, #input) == input:lower()

		if IsDisplay or IsName then
			return player
		end
	end
	return nil
end

module.seek_object = function(source : Folder, input : string) : Instance | nil
	for _, object in pairs(source:GetChildren()) do
		local match = object.Name:lower():sub(1, #input) == input:lower()
		if match then
			return object
		end
	end
	return nil
end

module.get_players = function(player : Player, input : string) : {Player}
	local list = {}
	local args = input:lower():split(',')

	for _, arg in args do
		if arg:sub(1,1) == '@' then
			local team_name = arg:sub(2)
			local team = teams:FindFirstChild(team_name) :: Team

			if team then
				for _, plr in team:GetPlayers() do
					table.insert(list, plr)
				end
			end
		end

		if arg == "me" or arg == "self" then
			table.insert(list, player)

		elseif arg == "others" then
			for _, plr in pairs(players:GetPlayers()) do
				if plr ~= player then
					table.insert(list, plr)
				end
			end

		elseif arg == "all" or arg == "everyone" or arg == "*" then
			for _, plr in pairs(players:GetPlayers()) do
				table.insert(list, plr)
			end

		elseif arg == "admins" then
			for _, plr in pairs(players:GetPlayers()) do
				if module.is_admin(plr.UserId) then
					table.insert(list, plr)
				end
			end

		elseif arg == "nonadmins" then
			for _, plr in pairs(players:GetPlayers()) do
				if not module.is_admin(plr.UserId) then
					table.insert(list, plr)
				end
			end
		else
			local seek = module.seek_player(arg)

			if seek then
				table.insert(list, seek)
			end
		end
	end

	return list
end

module.announce = function(player : Player, speaker_name : string, message : string)
	local msg = config.resources.ui.msg:Clone()
	msg.Parent = player:FindFirstChild('PlayerGui')
	msg.main.message.Text = message
	msg.main.speaker.Text = "From: "..speaker_name 
	msg.handle.Enabled = true
end

module.chat_message = function(player : Player, message, color : Color3 | nil)
	local msg : LocalScript = attach.chat_message:Clone()
	msg:SetAttribute('message', message)
	msg:SetAttribute('color', color or Color3.fromRGB(255, 119, 0))
	msg.Parent = player:FindFirstChild('PlayerGui')
	msg.Enabled = true
end

return module