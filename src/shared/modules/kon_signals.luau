--!strict

local signals = {}
signals.__index = signals

---------------------------

function signals:wait()
	return self.event:Wait()
end

function signals:once()
	return self.event:Once()
end

function signals:connect(func)
	local conn = self.event:Connect(func)
	table.insert(self.connections, conn)
	return conn
end

function signals:clear_connections()
	task.wait() --because :wait() no likey when clear
	for _, conn : RBXScriptConnection in self.connections do
		conn:Disconnect()
	end
end

function signals:fire(...)
	self._e:Fire(...)
end

function signals.new()
	local self = setmetatable({}, signals)
	
	self._e = Instance.new('BindableEvent')
	self._e.Parent = script.Parent
	self.connections = {}
	
	self.event = self._e.Event

	return self	
end

return signals