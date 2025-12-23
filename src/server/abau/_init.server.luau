local system = script.Parent

local server_storage = game:GetService('ServerStorage')
local rep = game:GetService('ReplicatedStorage')

local config = require(script.Parent.server.config)
local _version = require(script.Parent._version)

config.remote = Instance.new('RemoteFunction')
config.remote.Name = _version._NAME
config.remote.Parent = rep 

config.spawned_items = Instance.new('Folder')
config.spawned_items.Name = 'spawned_items'
config.spawned_items.Parent = workspace

config.resources = server_storage:FindFirstChild('resources')
config.system_folder = script.Parent

for _, mod in system.server:GetChildren() do
    if mod:IsA('ModuleScript') then
        require(mod)
    end
end

print(`{_version._NAME} init`)

script:Destroy()