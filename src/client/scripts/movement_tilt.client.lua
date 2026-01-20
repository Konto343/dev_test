--!strict

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp : BasePart = char:FindFirstChild('HumanoidRootPart')

local rootjoint : JointInstance = game.Players.LocalPlayer.Character.HumanoidRootPart.RootJoint
local og_c0 = rootjoint.C0

local tilt_speed = 0.2 --lower number is faster tiliting
local tilt_boost = .1 --around .1 is normal

game:GetService('RunService').Stepped:Connect(function()
	if not char then --reset if player dies
		char = plr.Character or plr.CharacterAdded:Wait()
	end

	local x_angle = hrp.CFrame.RightVector:Dot(char.Humanoid.MoveDirection)
	local y_angle = hrp.CFrame.LookVector:Dot(char.Humanoid.MoveDirection)
	local cur_c0 = rootjoint.C0

	local goal = og_c0 * CFrame.Angles(y_angle * tilt_boost, -x_angle * tilt_boost, 0)

	rootjoint.C0 = cur_c0:Lerp(goal, tilt_speed)
end)