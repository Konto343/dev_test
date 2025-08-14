local module = {}

local colors = require('./colors')
local ui = require('./ui')
local k_ui = require('./k_ui')

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
	local label = k_ui.item('TextBox', ui.logs.item, 15)
	label.item.Text = message
	label.item.TextColor3 = color or colors.green
	label.item.TextXAlignment = Enum.TextXAlignment.Left
	label.item.BackgroundTransparency = 1
	label.item.TextScaled = true
	label.item.ClearTextOnFocus = false

	return label.item
end

return module