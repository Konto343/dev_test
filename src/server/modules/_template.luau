local module = {}
module.__index = module

type self = {
    value : number
}
export type class = typeof(setmetatable({} :: self, module))

function module.new(input) : class
    local self = setmetatable({} :: self, module)
    self.value = input
    return self
end

function module.get(self : self)
    self.value += 2
    return self.value
end

function module.add(self : self, x : number)
    self.value += x
end

return module