--!strict

local module = {}

local config = require(script.Parent.config)
local ui = require(script.Parent.ui)
local ui_lib = require(script.Parent.depend.ui_lib)

local players = game:GetService('Players')

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

module.decimal_limit = function(value : number, places : number)
	return math.floor(value*(places^10))/(places^10)
end

module.color_richtext = function(text : string, color : Color3)
	return '<font color="#'..color:ToHex()..'">'..text..'</font>'
end

module.log = function(message : string, color : Color3 | nil)
	local label = ui_lib.item('TextBox', ui.logs.item)
	label.item.Size = UDim2.new(2, 0, 0, 15)
	label.item.Text = message
	label.item.TextColor3 = color or config.colors.blue
	label.item.TextXAlignment = Enum.TextXAlignment.Left
	label.item.BackgroundTransparency = 1
	label.item.TextSize = 20
	label.item.ClearTextOnFocus = false

	return label.item
end

return module