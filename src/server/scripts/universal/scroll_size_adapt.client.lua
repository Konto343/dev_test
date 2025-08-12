local ui_object = script.Parent
local listing = script.Parent:FindFirstChildWhichIsA('UIListLayout') or script.Parent:FindFirstChildWhichIsA('UIGridLayout') 

local function update()
	ui_object.CanvasSize = UDim2.fromOffset(listing.AbsoluteContentSize.X, listing.AbsoluteContentSize.Y+20)
end

ui_object.DescendantAdded:Connect(function()
	update()
end)