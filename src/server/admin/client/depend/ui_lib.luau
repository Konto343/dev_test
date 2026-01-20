--!strict

local uis = game:GetService('UserInputService')
local players = game:GetService('Players')

local local_player = players.LocalPlayer
	
local module = {}
module.__index = module

module.directions = {
	['center'] = Vector2.new(.5, .5),
	['right'] = Vector2.new(1, .5),
	['left'] = Vector2.new(0, .5),
	['bottom'] = Vector2.new(.5, 1),
	['top'] = Vector2.new(.5, 0),
}

module.config = {} :: {
	bg1 : Color3,
	bg2 : Color3,
	bg3 : Color3,
	bg4 : Color3,
	fg1 : Color3,
	border : Color3,
	accent : Color3,
	font : Enum.Font
}

function module:pad(pad_amount : number)
	local pad = Instance.new('UIPadding')
	pad.PaddingTop = UDim.new(0, pad_amount)
	pad.PaddingLeft = UDim.new(0, pad_amount)
	pad.PaddingRight = UDim.new(0, pad_amount)
	pad.PaddingBottom = UDim.new(0, pad_amount)
	pad.Parent = self.item
end

function module:pad_horz(pad_amount : number)
	local pad = Instance.new('UIPadding')
	pad.PaddingLeft = UDim.new(0, pad_amount)
	pad.PaddingRight = UDim.new(0, pad_amount)
	pad.Parent = self.item
end

function module:pad_fix(pad_amount : number)
	local x = self.item.Size.X :: UDim
	local y = self.item.Size.Y :: UDim
	self.item.Size = UDim2.new(x.Scale, x.Offset, y.Scale, y.Offset - pad_amount)
end

function module:anchor(direction : Vector2)
	self.item.Position = UDim2.fromScale(direction.X, direction.Y)
	self.item.AnchorPoint = direction
end

function module:containerize(pad_amount : number | nil)
	local container = Instance.new('Frame')
	container.LayoutOrder = self.item.LayoutOrder
	container.Size = self.item.Size
	container.Parent = self.item.Parent
	container.BackgroundTransparency = 1
	
	local pad = Instance.new('UIPadding')
	pad.PaddingTop = UDim.new(0, pad_amount)
	pad.Parent = container
	
	self.item.Size = UDim2.fromScale(1, 1) --fill old space + padding
	self.item.Parent = container
end

function module:bind(key : Enum.KeyCode, run : () -> ())
	uis.InputBegan:Connect(function(input, _)
		if input.KeyCode == key then
			run()
		end
	end)
end

function module:draggable()
	local frame = self.item :: Frame

	local drag_toggle : boolean
	local drag_input : InputObject
	local drag_start : Vector3
	local start_position : UDim2

	local function update_drag(input : InputObject)
		local delta = input.Position - drag_start
		local pos = UDim2.new(
			start_position.X.Scale, 
			start_position.X.Offset + delta.X, 
			start_position.Y.Scale, start_position.Y.Offset + delta.Y)

		frame.Position = pos
	end

	frame.InputBegan:Connect(function(input)
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

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch then
			drag_input = input
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input == drag_input and drag_toggle then
			update_drag(input)
		end
	end)
end

function module:list_layout(amount : number | nil)
	local list = Instance.new('UIListLayout')
	list.Padding = UDim.new(0, amount or 10)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = self.item
	return list
end

function module:corner(amount : number | nil)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, amount or 10)
	corner.Parent = self.item
	return corner
end

function module:fill()
	self.item.Size = UDim2.fromScale(1,1)
end

function module:canvas_adapt()
	local canvas = self.item :: ScrollingFrame
	local layout = self.item:FindFirstChildWhichIsA('UIListLayout', true) or self.item:FindFirstChildWhichIsA('UIGridLayout', true) :: UILayout & UIGridLayout
	
	canvas.DescendantAdded:Connect(function()
		canvas.CanvasSize = UDim2.fromOffset(
			layout.AbsoluteContentSize.X, layout.AbsoluteContentSize.Y + 20
		)
	end)
end

------------------------------------------------------

function module.new(ui_name : string)
	local ui = Instance.new('ScreenGui')
	ui.Name = ui_name
	ui.ResetOnSpawn = false
	ui.Parent = local_player:FindFirstChild('PlayerGui')

	return ui
end

function module.window(x_px : number, y_px : number, parent : ScreenGui, hide : boolean)
	local item = Instance.new('Frame')
	item.BackgroundColor3 = module.config.bg1
	item.BorderColor3 = module.config.border
	item.BorderSizePixel = 4
	item.Size = UDim2.fromOffset(x_px, y_px)
	item.ClipsDescendants = true
	item.Parent = parent
	item.Visible = not hide

	local self = setmetatable({}, module)
	self.item = item :: Frame

	return self
end

function module.header(parent : BasePlayerGui, text : string, height : number | nil)
	local item = Instance.new('TextLabel')
	item.BackgroundTransparency = 1
	item.Size = UDim2.new(1, 0, 0, height or 20)
	item.TextColor3 = module.config.fg1
	item.Font = module.config.font
	item.Text = text
	item.Parent = parent
	
	local self = setmetatable({}, module)
	self.item = item :: TextLabel
	
	return self
end

function module.item(class_name : string, parent : BasePlayerGui, height : number | nil)

	-- fix this type issue, should be OR OR OR for all playergui's types, 
	-- or use BASE to ignore if cant fix
	local item = Instance.new(class_name) :: Frame|TextLabel
	item.Size = UDim2.new(1, 0, 0, height or 20)
	
	item.BackgroundColor3 = module.config.bg2
	item.BorderColor3 = module.config.border
	item.Parent = parent
	
	if table.find({'TextLabel', 'TextBox'}, class_name) then
		item.TextColor3 = module.config.fg1
		item.Font = module.config.font
	end

	local self = setmetatable({}, module)
	self.item = item :: TextLabel & TextBox & Frame & TextButton & ScrollingFrame & ImageLabel
	
	return self
end

return module
