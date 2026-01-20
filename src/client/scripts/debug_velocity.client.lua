--!strict

function cube()
	local part = Instance.new('Part')
	part.Size = Vector3.new(2,2,2)
	part.CanCollide = false
	part.Anchored = true
	part.Transparency = .5
	part.Parent = workspace
	return part
end

local normal = cube()
normal.BrickColor = BrickColor.Red()

local x_y = cube()
x_y.BrickColor = BrickColor.Blue()

local inverse = cube()
inverse.BrickColor = BrickColor.Blue()

while task.wait() do
	local plr = game.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hrp : BasePart = char:FindFirstChild('HumanoidRootPart')
	
	if not hrp then
		continue
	end
	
	local velocity = hrp.AssemblyLinearVelocity
	
	normal.Position = hrp.Position + velocity
	x_y.Position = hrp.Position + Vector3.new(velocity.X, 0, velocity.Z)
	inverse.Position = hrp.Position - velocity
end