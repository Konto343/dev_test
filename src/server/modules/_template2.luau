local module = {}

type self = {
    value : string,
}
export type class = typeof(setmetatable({} :: self, module))

module.__index = module

function module.new(value : string) : class
    local self = setmetatable({} :: self, module)
    self.value = value
    return self
end

function module:cut()
    self.value = string.sub(self.value, 2, -1)
    return self --chain methods, possible
end

--as key is absent, it will only return the value, aka a string.
--we can mess with the string as its methods are inherited into our metaclass
--allow for extra methods to an object's existing ones

local test = module.new('apple')
test:cut()

--goal: make __index both get methods and if __index to return the VALUE of the metatable along with methods.


return module

