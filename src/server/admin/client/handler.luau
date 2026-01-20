--!strict

local module = {}

local input = game:GetService("UserInputService")
local players = game:GetService('Players')

local local_player = players.LocalPlayer

local config = require(script.Parent.config)
local cmd = require(script.Parent.cmd)
local helper = require(script.Parent.helper)
local ui = require(script.Parent.ui)

local bar = ui.bar.item
local logs = ui.logs.item

local command_history = {}
local pointer_pos = 0

module.get_predictions = function(user_input : string) : {string}
	local predictions = {}
	
	for _, data in config.commands do
		if user_input:sub(1,#user_input) == data.name:sub(1,#user_input) then
			predictions[#predictions+1] = data.name
		end
	end
	return predictions
end

module.set_history = function()
	pcall(function()
		pointer_pos = math.clamp(pointer_pos, 1, #command_history)
		bar.Text = command_history[(#command_history+1) - pointer_pos] 
		task.wait()
		bar.CursorPosition = 999
	end)
end

config.remote.OnClientInvoke = function(task, msg : string, color : Color3 | nil)
	if task == 'message' then
		helper.log(msg, color)
	end
end

module.events = {
	bar:GetPropertyChangedSignal('Text'):Connect(function()
		local user_input = bar.Text:split(' ')[1]
		local command = cmd.get_command(user_input)
		local predictions = module.get_predictions(user_input)

		if command then
			bar.TextColor3 = Color3.fromRGB(255,255,255)
		else
			bar.TextColor3 = Color3.fromRGB(255,0,0)
		end

		if #predictions ~= 0 then
			local first = predictions[1]
			local prediction = command or cmd.get_command(first)
			local args = {}
			
			if not prediction then
				return
			end

			table.remove(predictions, table.find(predictions, prediction.name))
			
			if prediction.args then
				for _, data in prediction.args do
					table.insert(args, `<{data[1]} : {data[2]}>`)
				end
			end

			ui.preview_header.item.Text = helper.color_richtext(prediction.name, config.colors.blue) .. ' ' .. table.concat(predictions, ' ')
			ui.preview_details.item.Text = table.concat(args, ' ')
			ui.preview_desc.item.Text = prediction.info
			ui.preview.item.Visible = true
		else
			ui.preview.item.Visible = false
		end
	end),

	input.InputBegan:Connect(function(pressed)
		if pressed.KeyCode == Enum.KeyCode.Tab then
			local predictions = module.get_predictions(
				bar.Text:split(' ')[1]
			)
			
			if #predictions >= 1 then
				task.wait()
				bar.Text = predictions[1]..' '
				bar.CursorPosition = 999
			end
		end

		if pressed.KeyCode == Enum.KeyCode.Up then
			pointer_pos += 1
			module.set_history()
		end

		if pressed.KeyCode == Enum.KeyCode.Down then
			pointer_pos -= 1
			module.set_history()
		end
	end),

	bar.FocusLost:Connect(function(key)
		if not key then --when without pressing enter
			return
		end

		if bar.Text ~= "" then
			local user_input = bar.Text
			local target_command = user_input:split(' ')[1]
			local command_data = cmd.get_command(target_command)
			helper.log(`> {user_input}`, config.colors.orange)
			
			if command_data and not command_data['is_server'] then
				cmd.process_command(local_player, user_input)
			else
				local result = config.remote:InvokeServer('command', user_input)
				if not result then
					helper.log(`Invalid command => "{target_command}"`, config.colors.orange)
				end
			end
			
			table.insert(command_history, user_input)
			bar.Text = ''
			task.wait()
			bar:CaptureFocus()

			for _=1, 10 do --if you see this, then uh... This code is Perfect.
				logs.CanvasPosition = Vector2.new(0, 10^6)
				task.wait()
			end
		else
			ui.main.item.Visible = false
			bar:ReleaseFocus()
		end
	
		pointer_pos = -1
	end)
}

return module