local module = {}

state = false
connection = nil

rs = game:GetService("RunService")
uis = game:GetService("UserInputService")

local_player = game.Players.LocalPlayer
camera = workspace.CurrentCamera

module._turn = 0
module.sway_strength = 10
module.delta_boost = 4

function lerp(a, b, t)
	return a + (b - a) * t
end

module.toggle_state = function(override)
	state = override or not state
	
	if state then
		connection = rs:BindToRenderStep("camera_sway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)

			local delta = uis:GetMouseDelta()

			module.turn = lerp(module.turn, math.clamp(delta.X, - module.sway_strength, module.sway_strength), (module.delta_boost * deltaTime))
			camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.rad(module.turn))
		end)
	else
		if connection then
			connection:Disconnect()
		end
	end
end

return module
