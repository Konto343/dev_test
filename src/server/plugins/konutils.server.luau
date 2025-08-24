local plugin_name = 'KonUtils'
local plugin_desc = 'Cool Stuff.'
local plugin_icon = "rbxassetid://13029433539"
local toolbar_name = 'Konto\'s Utilities'

local selection = game:GetService('Selection')

local config = {} :: {any}

local commands = {
	['Camera At Part'] = function()
		local part = Instance.new('Part', workspace)
		part.CFrame = workspace.Camera.CFrame
		part.FrontSurface = Enum.SurfaceType.Motor
	end,
	
	['Make Bounds (Model)'] = function()
		local sel : Model = selection:Get()[1]
		
		if not sel:IsA('Model') then
			warn('Selection is not a Model!')
		end
		
		local bounds = sel:GetExtentsSize()
		local bound = Instance.new('Part')
		bound.Name = 'bounds'
		bound.Size = bounds
		bound.Color = Color3.fromRGB(255,0,0)
		bound.Transparency = .6
		bound.CFrame = sel:GetPivot()
		bound.Parent = sel
	end,
	
	['Instance Info'] = function()
		local sel : Model = selection:Get()[1]
		
		print(string.rep('-',20))
		
		local infos = {
			['objects count'] = #sel:GetDescendants()
		}
		
		for name, data in infos do
			print(('%s: %s'):format(name, data))
		end
		
		local instances = {}
		
		for _, obj in sel:GetDescendants() do
			if not instances[obj.ClassName] then
				instances[obj.ClassName] = 0
			end
			instances[obj.ClassName] += 1
		end

		for int, value in instances do
			print(('	+ %s: %s'):format(int, value))
		end
	end,
	
	['Clear Scripts'] = function()
		local sel : Model = selection:Get()[1]
		
		local counters = {
			Script = 0,
			LocalScript = 0,
			ModuleScript = 0
		}
		
		for _, obj in sel:GetDescendants() do
			if counters[obj.ClassName] then
				obj:Destroy()
				counters[obj.ClassName] += 1
			end
		end
		
		print(string.rep('-',20), 'cleared:')
		
		for int, value in counters do
			print(('	- %s: %s'):format(int, value))
		end
	end,
	
	['Anchor all (Selection)'] = function()
		local sel : Model = selection:Get()[1]
		
		for _, obj in sel:GetDescendants() do
			if obj:IsA('BasePart') then
				obj.Anchored = true
			end
		end
	end,
	
	['Weld all to PrimePart (Model)'] = function()
		local sel : Model = selection:Get()[1]
		
		local prime = sel.PrimaryPart
		
		if not prime then
			warn('Selection does not have a PrimePart!')
			return
		end

		for _, obj in sel:GetDescendants() do
			if obj:IsA('BasePart') then
				obj.Anchored = false
				local weld = Instance.new('WeldConstraint')
				weld.Part0 = obj
				weld.Part1 = prime
				weld.Parent = obj
			end
		end
	end,

	['Property-Copy (Part)'] = function()
		local obj : BasePart = selection:Get()[1]

		if not obj:IsA('BasePart') then
			warn('Selection is not part!')
		end

		config['mat'] = obj.Material
		config['color'] = obj.Color

		print('Copied material and color.')
	end,

	['Property-Paste (Selection)'] = function()
		for _, obj : Model | BasePart in selection:Get() do
			if obj:IsA('Model') then
				for _, part in obj:GetDescendants() do
					if part:IsA('BasePart') then
						part.Material = config['mat']
						part.Color = config['color']
					end
				end
			end

			if obj:IsA('BasePart') then
				obj.Material = config['mat']
				obj.Color = config['color']
			end
		end
	end,
}

function init()
	local plugin = plugin or {}
	local toolbar = plugin:CreateToolbar(toolbar_name)

	local widget_info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left)
	local dock  = plugin:CreateDockWidgetPluginGui("LeftDock", widget_info)
	return toolbar, dock
end

function make_plugin_button(toolbar, button_name, button_desc, button_icon)
	local button = toolbar:CreateButton(
		plugin_name, 
		plugin_desc,
		plugin_icon
	)
	return button
end

function ui_init(dock)	
	local root = Instance.new("Frame")
	root.Parent = dock
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	
	local ui_list = Instance.new('UIListLayout')
	ui_list.SortOrder = Enum.SortOrder.Name
	ui_list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ui_list.Parent = root
	ui_list.Padding = UDim.new(0, 10)
	
	local padding = Instance.new('UIPadding')
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = root

	for name, func in commands do
		local button = Instance.new('TextButton')
		button.Size = UDim2.new(1,0,0,30)
		button.Text = name
		button.Name = name
		button.TextScaled = true
		button.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Parent = root
		
		local button_padding = Instance.new('UIPadding')
		button_padding.PaddingTop = UDim.new(0,5)
		button_padding.PaddingBottom = UDim.new(0,5)
		button_padding.PaddingLeft = UDim.new(0,5)
		button_padding.PaddingRight = UDim.new(0,5)
		button_padding.Parent = button

		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0,5)
		corner.Parent = button
		
		button.MouseButton1Down:Connect(func)
	end
end

local toolbar, dock = init()
local button = make_plugin_button(toolbar, 'Open', 'Open/close Gui', plugin_icon)
button.Click:Connect(function()
	dock.Enabled = not dock.Enabled
end)

ui_init(dock)
