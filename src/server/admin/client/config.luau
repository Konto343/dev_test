--!strict

local module = {}

local types = require(script.Parent.types)

module.remote = nil :: RemoteFunction | nil
module.commands = {} :: {types.command}

module.colors = {
    blue = Color3.fromRGB(97, 124, 204),
    green = Color3.fromRGB(149, 172, 76),
    orange = Color3.fromRGB(216, 138, 99)
}

module.ui_config = {
    bg1 = Color3.fromRGB(25, 25, 25),
	bg2 = Color3.fromRGB(38, 38, 38),
	bg3 = Color3.fromRGB(51, 51, 51),
	bg4 = Color3.fromRGB(64, 64, 64),
	fg1 = Color3.fromRGB(255, 255, 255),
	border = Color3.fromRGB(35, 35, 35),
	accent = Color3.fromRGB(255, 169, 20),
	font = Enum.Font.RobotoMono
}

module.config = {
    debug_update_speed = 1,
}

return module