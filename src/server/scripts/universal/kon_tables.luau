--!strict

local template = {}
template.__index = template

---------------------------

function template:get(key : number)
	local index = key or 1
	local item = self[index]
	return item
end

function template:items()
	local items = {}
	for _, value in self do
		items[#items+1] = value
	end
	return items
end

function template:keys()
	local items = {}
	for index, _ in self do
		items[#items+1] = index
	end
	return items
end

function template:pop(key : number)
	local index = key or 1
	local current_item = self[index]
	self[index] = nil
	return current_item 
end

function template:copy() --deept copy
	local clone = {}
	for i,v in pairs(self) do
		clone[i] = v
	end
	return clone
end

function template:append(data)
	self[#self+1] = data
end

function template:set(data : any, index)
	self[index] = data
end

function template:extend(data, index) --data : table
	for i, v in data do
		self[#self+i] = v
	end
end

function template:clear()
	for i,_ in self do
		self[i] = nil
	end
end

function template:reverse()
	local new = {}
	for i = #self, 1, -1 do
		new[#new+1] = self[i]
	end
	self = new
end

function template:remove(index)
	self[index or 1] = nil
end

function template.new()
	return setmetatable({}, template)	
end

return template