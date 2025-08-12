--!strict

local module = {}

-- Place in StarterPlayerScripts
-- Not by 343, but modified

local state = false

local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid",10)

function in_first_person()
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:WaitForChild("Head", 10)
	if not head then return false end

	return (head.CFrame.p - camera.CFrame.p).magnitude <= 2
end

for _, child in pairs(character:GetChildren()) do
	if child:IsA("BasePart") and child.Name ~= "Head" then
		child:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			child.LocalTransparencyModifier = child.Transparency
		end)

		child.LocalTransparencyModifier = child.Transparency
	end
end

camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
	if camera.CameraSubject:IsA("VehicleSeat") then
		camera.CameraSubject = humanoid
	end
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if not state then
		return
	end
	
	if in_first_person() then
		humanoid.CameraOffset = Vector3.new(0, 0, -.75)
	else
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end
end)

module.toggle_state = function(override)
	state = override or not state
end

return module