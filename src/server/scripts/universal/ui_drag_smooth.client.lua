--!strict

local ts = game:GetService('TweenService')
local uis = game:GetService('UserInputService')

local drag_speed = .1
local frame = script.Parent

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