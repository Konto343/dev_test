--!strict

local template = {}
template.__index = template

---------------------------

function template:append(data)
	self.t[#self.t + 1] = data
end

function template.new()
	local self = setmetatable({}, template)

	self.t = {}

	return self	
end

return template