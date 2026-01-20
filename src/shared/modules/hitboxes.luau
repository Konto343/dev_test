--!strict

local module = {}

local folders = require(script.Parent.folders)
local debug_folder = folders.get('debug')

local players = game:GetService("Players")
local run = game:GetService('RunService')
local ts = game:GetService("TweenService")

local debug = false

function hitrun(cframe : CFrame, size : Vector3, radial : boolean) : {Player}
    local results = {}
    local parts = radial and workspace:GetPartBoundsInRadius(cframe.Position, size.X) or workspace:GetPartBoundsInBox(cframe, size)

    for _, obj in parts do
        if not obj.Parent:IsA('Model') then
            continue
        end

        local player = players:GetPlayerFromCharacter(obj.Parent)

        if not player then
            continue
        end

        results[#results+1] = player
    end
    
    return results
end

function module.new(cframe : CFrame|nil, size : Vector3|nil, part_type : Enum.PartType, func : ({Player}) -> (), loop_count : number|nil)
    local part = Instance.new('Part')
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Anchored = true
    part.Transparency = 1
    part.Material = Enum.Material.Neon
    part.Shape = part_type
    part.Size = size or Vector3.new(5,5,5)
    part.CFrame = cframe or CFrame.new()
    part.Parent = debug_folder

    for _=1, (loop_count or math.huge) do
        local hits = hitrun(part.CFrame, part.Size, part_type == Enum.PartType.Ball)
        func(hits)
    end
end

function module:toggle_debug(state_override)
    debug = state_override or (not debug)
end

if run:IsClient() then
    debug_folder.ChildAdded:Connect(function(obj : Part)
        if not debug then
            obj:Destroy()
        end

        obj.Transparency = 0

        local fade = ts:Create(obj, TweenInfo.new(1), {
            Transparency = 1
        })
        fade:Play()
        fade.Completed:Once(function()  
            obj:Destroy()
        end)
    end)
end

return module