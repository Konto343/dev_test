local module = {}

module.ragdoll = function(player : Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid : Humanoid = char:WaitForChild('Humanoid', 10)
	
	for _, obj in char:GetDescendants() do
		if obj:IsA('Motor6D') then
			local socket = Instance.new('BallSocketConstraint')
			
			local a1 = Instance.new('Attachment')
			local a2 = Instance.new('Attachment')
			
			a1.Parent = obj.Part0
			a2.Parent = obj.Part1
			
			socket.Parent = obj.Parent
			socket.Attachment0 = a1
			socket.Attachment1 = a2
			
			a1.CFrame = obj.C0
			a2.CFrame = obj.C1
			
			socket.LimitsEnabled = true
			socket.TwistLimitsEnabled = true
			
			obj.Enabled = false
		end
	end
	
	local root_joint = char:FindFirstChild('HumanoidRootPart').RootJoint
	if not root_joint.Enabled then
		root_joint.Enabled = true
	end
	
	humanoid.UseJumpPower = true
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0
	humanoid.PlatformStand = true
	humanoid.AutoRotate = false
end

module.unragdoll = function(player : Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid : Humanoid = char:WaitForChild('Humanoid', 10)
	humanoid.PlatformStand = false

	for _, obj in char:GetDescendants() do
		if obj:IsA('BallSocketConstraint') then
			obj:Destroy()
		end
		
		if obj:IsA('Motor6D') then
			obj.Enabled = true
		end
	end
	
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid.UseJumpPower = true
	humanoid.WalkSpeed = 16
	humanoid.JumpHeight = 50
	humanoid.AutoRotate = true
end

return module
