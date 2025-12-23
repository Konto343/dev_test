local client = script.Parent

for _, obj in client:GetDescendants() do
	if obj:IsA('ModuleScript') then
		require(obj)
	end
end

script:Destroy()