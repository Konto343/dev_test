--!strict

local module = {}

local replicated_storage = game:GetService('ReplicatedStorage')

module.remote = replicated_storage:WaitForChild('basic_admin', 10) :: RemoteFunction
module.debug_update_speed = 1
module.commands = {} :: {any}

return module
