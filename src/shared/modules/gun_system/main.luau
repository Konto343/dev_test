local module = {}
module.__index = module

local types = require(script.Parent.types)

type self = {
	tool : Tool,
    config : types.weapon
}
export type class = typeof(setmetatable({} :: self, module))

function module.new(tool : Tool, config : types.weapon) : class
    local self = setmetatable({} :: self, module)
    self.tool = tool
    self.config = config

    return self
end

function module.fire(self : self)
    task.wait(self.config.config.firerate_seconds)
end

return module