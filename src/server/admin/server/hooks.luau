--!strict

local module = {}

local config = require(script.Parent.config)

local server = game:GetService('ServerScriptService')
local modules = server:FindFirstChild('modules', true)

pcall(function() -- chat_tags
    local chat_tags = modules:FindFirstChild('chat_tags')
    
    if chat_tags then
        chat_tags = require(chat_tags)
    
        for _, admin in config.admins do
            if not admin.tag_name and not admin.tag_color then
                continue
            end
            chat_tags.add_tag(admin.user_id, admin.tag_name, admin.tag_color)
        end
        chat_tags.init()
    end
end)

return module