local module = {}
module.__index = module

local http = game:GetService('HttpService')

type embed_field = {
    name : string,
    value : string,
    inline : boolean
}

type embed = {
    author : {
        name : string,
        url : string,
        icon : string
    },
    title : string,
    url : string,
    description : string,
    color : string,
    fields : {embed_field},
    thumbnail : {
        url : string
    },
    image : {
        url : string
    },
    footer : {
        text : string,
        icon_url : string
    }
}

export type webhook = {
    content : string,
    username : string,
    avatar_url : string, 
    embeds : {embed}
}

function module.new(webhook_url : string)
    local self = setmetatable({}, module)
    self.data = {} :: webhook
    self.url = webhook_url

    return self
end

function module:send()
    local data = http:JSONEncode({
        self.data
    })
    http:PostAsync(self.url, data)
end

return module