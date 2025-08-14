local module = {}

local ui = require('./k_ui')
local config = require('./config_ui')

local root = ui.new('abau')

------------------------- main
local main = ui.window(900, 500, root, true)
main:draggable()
main:anchor(ui.directions.center)
main:list_layout(0)
main:pad(20)
main:corner(10)
main:bind(Enum.KeyCode.F2, function()
	main.item.Visible = not main.item.Visible
end)
module.main = main

local header = ui.header(main.item, 'ABAU')
header.item.Size = UDim2.fromScale(1, .05)
header.item.LayoutOrder = 1
header.item.TextXAlignment = Enum.TextXAlignment.Left
header.item.TextScaled = true
header.item.FontFace.Bold = true
header:anchor(ui.directions.top)

local logs = ui.item('ScrollingFrame', main.item)
logs.item.LayoutOrder = 2
logs.item.Size = UDim2.fromScale(1, .85)
logs:list_layout()
logs:corner(10)
logs:pad(10)
logs:containerize(10)
logs:canvas_adapt()
module.logs = logs

local bar = ui.item('TextBox', main.item)
bar.item.LayoutOrder = 3
bar.item.Size = UDim2.fromScale(1, .1)
bar.item.Text = ''
bar.item.TextScaled = true
bar.item.PlaceholderText = 'Command Bar'
bar.item.TextXAlignment = Enum.TextXAlignment.Left
bar.item.BackgroundColor3 = config.bg3
bar:corner(10)
bar:pad(10)
bar:containerize(10)
bar:bind(Enum.KeyCode.F2, function()
	bar.item:CaptureFocus()
end)
module.bar = bar

------------------------- players
local players = ui.window(300, 600, root, true)
players:draggable()
players:anchor(ui.directions.center)
players:list_layout(10)
players:pad(20)
players:corner(10)
players:bind(Enum.KeyCode.Semicolon, function()
	players.item.Visible = not players.item.Visible
end)

local header = ui.header(players.item, 'Players')
header.item.Size = UDim2.fromScale(1, .05)
header.item.LayoutOrder = 1
header.item.TextXAlignment = Enum.TextXAlignment.Left
header.item.TextScaled = true
header.item.FontFace.Bold = true
header:anchor(ui.directions.top)

local body = ui.item('ScrollingFrame', players.item)
body.item.LayoutOrder = 2
body.item.Size = UDim2.fromScale(1, .95)
body.item.ScrollBarThickness = 2
body:list_layout(10)
body:corner(10)
body:pad(10)
body:pad_fix(10)
module.players_container = body

for i=1,5 do
	local listing = ui.item('Frame', body.item, 50)
	listing.item.BackgroundColor3 = config.bg3
	listing:corner(10)
end

------------------------- notepad
local notepad = ui.window(400, 300, root, true)
notepad:draggable()
notepad:anchor(ui.directions.left)
notepad:list_layout(10)
notepad:pad(20)
notepad:corner(10)
notepad:bind(Enum.KeyCode.Quote, function()
	notepad.item.Visible = not notepad.item.Visible
end)

local header = ui.header(notepad.item, 'Notepad')
header.item.Size = UDim2.fromScale(1, .1)
header.item.LayoutOrder = 1
header.item.TextXAlignment = Enum.TextXAlignment.Left
header.item.TextScaled = true
header.item.FontFace.Bold = true
header:anchor(ui.directions.top)

local body = ui.item('TextBox', notepad.item)
body.item.LayoutOrder = 2
body.item.Size = UDim2.fromScale(1, .9)
body.item.TextXAlignment = Enum.TextXAlignment.Left
body.item.TextScaled = true
body.item.MultiLine = true
body:corner(10)
body:pad(10)
body:pad_fix(10)

return module
