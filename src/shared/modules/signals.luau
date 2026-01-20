--!strict

local module = {}
module.__index = module

---------------------------

function module:wait()
	return self.event:Wait()
end

function module:once()
	return self.event:Once()
end

function module:connect(func)
	local conn = self.event:Connect(func)
	table.insert(self.connections, conn)
	return conn
end

function module:clear_connections()
	task.wait() --because :wait() no likey when clear
	for _, conn : RBXScriptConnection in self.connections do
		conn:Disconnect()
	end
end

function module:fire(...)
	self._e:Fire(...)
end

function module.new()
	local self = setmetatable({}, module)
	
	self._e = Instance.new('BindableEvent')
	self._e.Parent = script.Parent
	self.connections = {}
	
	self.event = self._e.Event

	return self	
end

return module