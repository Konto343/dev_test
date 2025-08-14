--!strict

local module = {}

local commands = require('./commands')
local helper = require('./helper')
local colors = require('./colors')
local client = require('./client')

module.init = function()
	for _, data in commands.data do
		client.commands[#client.commands+1] = data
	end

	local server_commands = client.remote:InvokeServer('commands')
	if server_commands then
		for _, obj in server_commands do
			obj['is_server'] = true
			client.commands[#client.commands+1] = obj
		end
	end	
end

module.get_command = function(cmd_name : string) : commands.command  | nil
	for _, obj in client.commands do
		if obj.name == cmd_name then
			return obj
		end
	end
	return nil
end

module.process_command = function(player : Player, cmd_string : string)
	local args = string.split(cmd_string, " ")
	local command_name =  args[1]
	table.remove(args, 1)

	local command = module.get_command(command_name)

	if not command then
		helper.log('Invalid Command', colors.orange)
		return
	end

	local success, err = pcall(function()
		command.run(player, args)
	end)

	if not success then
		local errorMessage = "Command ran with an error: " .. err
		warn('Command error:', errorMessage)
		helper.log(errorMessage, colors.orange)
	end
end

module.init()

return module
