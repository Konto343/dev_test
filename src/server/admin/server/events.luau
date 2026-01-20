--!strict

local module = {}

local messaging = game:GetService('MessagingService')
local players = game:GetService('Players')

local cmd = require(script.Parent.cmd)
local logs = require(script.Parent.logs)
local helper = require(script.Parent.helper)
local config = require(script.Parent.config)
local types = require(script.Parent.types)
local tasks = require(script.Parent.tasks)

config.remote.OnServerInvoke = function(player : types.player, task, ...) : any | boolean
	if task == 'command' then
		local result = cmd.process_command(player, ...)
		
		local current_time = os.date('%c')
		logs.actions[#logs.actions+1] = `[{current_time}] {player.DisplayName} | {player.UserId} => {...}`

		return result
	end

	if task == 'commands' then
		return cmd.commands
	end

	if task == 'version' then
		return config.version
	end

	return false
end

module.events = {
	players.PlayerAdded:Connect(function(player)
		if not logs.player_cache[player.UserId] then
			logs.player_cache[player.UserId] = `{player.DisplayName} (@{player.Name})`
		end

		logs.join_leaves[#logs.join_leaves+1] = `[{os.date('%c')}] JOIN => {player.DisplayName} | {player.UserId}`

		for _, admin in config.admins do
			if admin.user_id == player.UserId then
				continue 
			end
			if admin.auto_vanish then
				helper.give_vanish(player, admin.user_id)
			end
		end

		if config.system.slock and not helper.is_admin(player.UserId) then
			player:Kick('This server has a Server Lock set by a Admin. Please join another server or wait -_-')
		end
		
		player.CharacterAdded:Once(function()
			task.wait(5)
			helper.chat_message(player, 'Admin system working.', Color3.fromRGB(0, 221, 255))

			if helper.is_admin(player.UserId) then
				helper.chat_message(player, "You're an Admin. Press F2 or the Toggle button (Mobile) to open the Console.", Color3.fromRGB(73, 154, 201))
			
				if not config.resources then
					helper.chat_message(player, 'Warning: Resources folder not found, extra fuctionality not available.', config.colors.orange)
				else
					helper.chat_message(player, 'Resources folder found!', config.colors.green)
				end
			end
		end)
		
		local chat_connection = player.Chatted:Connect(function(msg)
			local current_time = os.date('%c')
			local target_chat = logs.chats[player.UserId]

			if not target_chat then
				logs.chats[player.UserId] = {}
				target_chat = logs.chats[player.UserId]
			end

			target_chat[#target_chat+1] = `[{current_time}] {player.Name} | {msg}`
			logs.chat[#logs.chat+1] = `[{current_time}] {player.Name} | {msg}`
		end)

		player.AncestryChanged:Connect(function()
			chat_connection:Disconnect()
		end)

		helper.process_admin(player)
	end),

	players.PlayerRemoving:Connect(function(player : Player)
		logs.join_leaves[#logs.join_leaves+1] = `[{os.date('%c')}] LEAVE => {player.DisplayName} | {player.UserId}`
		
		if config.system.chats_expire_seconds then
			task.delay(config.system.chats_expire_seconds, function()
				logs.chats[player.UserId] = nil
			end)
		end
	end),

	messaging:SubscribeAsync(config.name, function(message)  
		local data = message.Data :: {}
		local time_sent = message.Sent :: string
		
		print(`[{config.name}] Server task recieved => {data[1]} at {time_sent}`)

		local task_name = data[1]
		local task_data = tasks.get_task(task_name)
		table.remove(data, 1)

		if task_data then
			task_data.run(data)
		end
	end)
}

return module
