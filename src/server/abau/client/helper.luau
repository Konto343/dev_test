local module = {}

local colors = require(script.Parent.colors)
local ui = require(script.Parent.ui)
local k_ui = require(script.Parent.depend.ui_lib)

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
	local label = k_ui.item('TextBox', ui.logs.item)
	label.item.Size = UDim2.new(2, 0, 0, 15)
	label.item.Text = message
	label.item.TextColor3 = color or colors.blue
	label.item.TextXAlignment = Enum.TextXAlignment.Left
	label.item.BackgroundTransparency = 1
	label.item.TextSize = 20
	label.item.ClearTextOnFocus = false

	return label.item
end

module.add_player_listing = function(player : Player)
	local listing = k_ui.item('Frame', ui.players_container.item)
	listing.item.BackgroundColor3 = k_ui.config.bg3
	listing.item.Size = UDim2.new(1, 0, 0, 75)
	listing:corner(10)

	local image = k_ui.item('ImageLabel', listing.item)
	image.item.BackgroundColor3 = k_ui.config.bg3
	image.item.Size = UDim2.fromScale(.25, 1)
	image.item.ScaleType = Enum.ScaleType.Fit
	image.item.BorderSizePixel = 0
	image:anchor(k_ui.directions.left)

	local text_label = k_ui.item('TextLabel', listing.item)
	text_label.item.BackgroundTransparency = 1
	text_label.item.Size = UDim2.fromScale(.75, 1)
	text_label.item.TextScaled = true
	text_label.item.Text = `{player.Name}\n@{player.DisplayName}\n{player.UserId}`
	text_label:anchor(k_ui.directions.right)
	text_label:corner(10)
	text_label:pad(5)

	local thumb_size = Enum.ThumbnailSize.Size420x420
	local thumb_type = Enum.ThumbnailType.HeadShot
	local content, is_ready = players:GetUserThumbnailAsync(
		player.UserId, 
		thumb_type, 
		thumb_size
	)

	if is_ready then
		image.item.Image = content
	end
end

return module