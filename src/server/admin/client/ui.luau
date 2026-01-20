--!strict

local module = {}

local ui_lib = require(script.Parent.depend.ui_lib)
local root = ui_lib.new('admin')

------------------------- main
local main = ui_lib.window(0, 0, root, true)
main.item.ClipsDescendants = false
main.item.BackgroundTransparency = .3
main:anchor(ui_lib.directions.center)
main:pad(50)
main:list_layout(0)
main:fill()
module.main = main

local logs = ui_lib.item('ScrollingFrame', main.item)
logs.item.LayoutOrder = 2
logs.item.BackgroundTransparency = .3
logs.item.Size = UDim2.fromScale(1, .85)
logs.item.LayoutOrder = 0
logs:list_layout()
logs:pad(10)
logs:canvas_adapt()
module.logs = logs

local bar = ui_lib.item('TextBox', main.item)
bar.item.LayoutOrder = 3
bar.item.Size = UDim2.fromScale(1,.05)
bar.item.Text = ''
bar.item.TextScaled = true
bar.item.PlaceholderText = 'Command Bar'
bar.item.TextXAlignment = Enum.TextXAlignment.Left
bar.item.BackgroundColor3 = ui_lib.config.bg4
bar.item.BackgroundTransparency = .3
bar.item.LayoutOrder = 1
bar:pad(10)
module.bar = bar

local preview = ui_lib.item('Frame', main.item)
preview.item.Visible = false
preview.item.BackgroundColor3 = ui_lib.config.bg4
preview.item.Size = UDim2.fromScale(1,.1)
preview.item.BackgroundTransparency = .3
preview.item.LayoutOrder = 2
preview:anchor(ui_lib.directions.center)
preview:pad(10)
preview:list_layout(3)

local preview_header = ui_lib.header(preview.item, 'Header', 30)
preview_header.item.RichText = true
preview_header.item.FontFace.Bold = true
preview_header.item.TextScaled = true
preview_header.item.TextXAlignment = Enum.TextXAlignment.Left

local preview_details = ui_lib.header(preview.item, 'Details...', 15)
preview_details.item.FontFace.Bold = true
preview_details.item.TextColor3 = ui_lib.config.accent
preview_details.item.TextScaled = true
preview_details.item.TextXAlignment = Enum.TextXAlignment.Left

local preview_desc = ui_lib.header(preview.item, 'Description', 15)
preview_desc.item.FontFace.Bold = true
preview_desc.item.TextScaled = true
preview_desc.item.TextXAlignment = Enum.TextXAlignment.Left

module.preview_header = preview_header
module.preview_details = preview_details
module.preview_desc = preview_desc
module.preview = preview

main:bind(Enum.KeyCode.F2, function()
	local state = not main.item.Visible
	main.item.Visible = state
	
	if state then
		bar.item:CaptureFocus()
	else
		bar.item:ReleaseFocus()
	end
end)

return module
