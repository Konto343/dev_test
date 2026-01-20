--!strict

local system_name = script.Parent:GetAttribute('system_name')

local config = require(script.Parent.config)
config.remote = game.ReplicatedStorage:FindFirstChild(system_name, true)

local ui_lib = require(script.Parent.depend.ui_lib)
ui_lib.config = config.ui_config

for _, obj in script.Parent:GetDescendants() do
	if obj:IsA('ModuleScript') then
		require(obj)
	end
end

print('admin client init.')
print('system name:', system_name)

script:Destroy()