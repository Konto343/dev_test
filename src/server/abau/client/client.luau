--!strict

local module = {}

local replicated_storage = game:GetService('ReplicatedStorage')
local host = script.Parent:GetAttribute('host')

module.remote = replicated_storage:WaitForChild(host, 10) :: RemoteFunction
module.debug_update_speed = 1
module.commands = {} :: {any}

print(`{host} client init`)

return module
