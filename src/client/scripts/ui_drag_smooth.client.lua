-- --!strict

-- local ts = game:GetService('TweenService')
-- local uis = game:GetService('UserInputService')

-- local drag_speed = .1
-- local frame = script.Parent

-- local drag_toggle : boolean
-- local drag_input : InputObject
-- local drag_start : Vector3
-- local start_position : UDim2

-- if not frame then
-- 	return
-- end

-- function update_drag(Input : InputObject)
-- 	local delta = Input.Position - drag_start
-- 	local pos = UDim2.new(
-- 		start_position.X.Scale, 
-- 		start_position.X.Offset + delta.X, 
-- 		start_position.Y.Scale, start_position.Y.Offset + delta.Y)

-- 	ts:Create(frame, TweenInfo.new(drag_speed), {Position = pos}):Play()
-- end

-- frame.InputBegan:Connect(function(input)
-- 	if (input.UserInputType == Enum.UserInputType.MouseButton1 
-- 		or input.UserInputType == Enum.UserInputType.Touch) 
-- 		and uis:GetFocusedTextBox() == nil then
-- 		drag_toggle = true
-- 		drag_start = input.Position
-- 		start_position = frame.Position
-- 		input.Changed:Connect(function()
-- 			if input.UserInputState == Enum.UserInputState.End then
-- 				drag_toggle = false
-- 			end
-- 		end)
-- 	end
-- end)

-- frame.InputChanged:Connect(function(input)
-- 	if input.UserInputType == Enum.UserInputType.MouseMovement 
-- 		or input.UserInputType == Enum.UserInputType.Touch then
-- 		drag_input = input
-- 	end
-- end)

-- uis.InputChanged:Connect(function(input)
-- 	if input.UserInputType == drag_input.UserInputType and drag_toggle then
-- 		update_drag(input)
-- 	end
-- end)