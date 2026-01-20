--!strict

local config = {}

export type admin = {
	user_id : number,
	rank : number,
	auto_vanish : boolean | nil,

	tag_name : string | nil,
	tag_color : Color3 | nil,
}

config.version = '3.4.2'
config.name = game:GetService("HttpService"):GenerateGUID(false)

config.remote = nil :: any
config.resources = nil :: any
config.spawned_items = nil :: any

config.discord_webhook = nil

config.colors = {
	blue = Color3.fromRGB(63, 111 ,255),
    green = Color3.fromRGB(201, 255, 22),
    orange = Color3.fromRGB(255, 87, 3)
}

config.admins = {
	-- { --template
	-- 	user_id = 00000,
	-- 	rank = 3,
	-- }, 

	{ --studio
		user_id = -1,
		rank = 10,
		auto_vanish = true,
	},

	{ --konto343
		user_id = 3705633866,
		rank = 11,
		auto_vanish = true,
		tag_name = 'Fish',
		tag_color = Color3.fromRGB(0, 102, 255)
	}, 
} :: {admin}

config.system = {
	--the admin UI will only be given those whose ranks are higher than this. (At join)
	admin_level = 5 :: number,
	--command prefix for chat. 
	command_prefix = "$" :: string,
	slock = false :: boolean,
	chats_expire_seconds = (60 * 30) :: number | nil,
}

return config
