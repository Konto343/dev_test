local server_storage = game:GetService('ServerStorage')
local rep = game:GetService('ReplicatedStorage')

local config = require(script.Parent.config)

config.remote = Instance.new('RemoteFunction')
config.remote.Name = config.name
config.remote.Parent = rep 

config.spawned_items = Instance.new('Folder')
config.spawned_items.Name = 'spawned_items'
config.spawned_items.Parent = workspace

config.resources = server_storage:FindFirstChild('resources')

for _, mod in script.Parent:GetChildren() do
    if mod:IsA('ModuleScript') then
        require(mod)
    end
end

print('admin server init.')
print(`system name: {config.name}`)

script:Destroy()
