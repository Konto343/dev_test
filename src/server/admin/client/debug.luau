--!strict

local module = {}

local config = require(script.Parent.config)
local helper = require(script.Parent.helper)

local local_player = game:GetService('Players').LocalPlayer

module.data = {
    players_overhead = {} :: {BillboardGui},
    players_line = {} :: {Beam},
}

module.add_track = function(player : Player)
    if module.data.players_overhead[player.UserId] then
        return
    end

    local track = Instance.new('BillboardGui')
    track.Name = 'track'
    track.ExtentsOffsetWorldSpace = Vector3.new(0, 3, 0)
    track.LightInfluence = 1
    track.AlwaysOnTop = true
    track.Size = UDim2.fromOffset(200, 25)
    track.Enabled = false

    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = .5
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.RichText = true
    label.FontFace.Bold = true
    label.Parent = track

    label.Text = `{player.DisplayName} (@{player.Name})`

    local update_loop = task.spawn(function()
        while true do
            local char = player.Character or player.CharacterAdded:Wait()
            track.Parent = char:FindFirstChild('Head')

            local from_hrp = char:FindFirstChild('HumanoidRootPart') :: BasePart
            local to_hrp = local_player.Character:FindFirstChild('HumanoidRootPart') :: BasePart

            if not from_hrp or not to_hrp then
                break
            end

            local from : Vector3 = from_hrp.Position
            local to : Vector3 = to_hrp.Position
            local distance = helper.decimal_limit((from - to).Magnitude, 1)
            local dis = helper.color_richtext(`[{distance}]`, config.colors.orange)
            label.Text = `{player.DisplayName} (@{player.Name}) {dis}`

            task.wait(config.config.debug_update_speed)
        end
    end)

    track.Destroying:Once(function()
        task.cancel(update_loop)
    end)

    module.data.players_overhead[player.UserId] = track
end

module.remove_track = function(player : Player)
    local track = module.data.players_overhead[player.UserId]
    track:Destroy()
    module.data.players_overhead[player.UserId] = nil
end

module.add_line = function(player : Player)
    local line_beam = Instance.new('Beam')
    line_beam.Segments = 10
    line_beam.Width0 = 0.1
    line_beam.Width1 = 1
    line_beam.FaceCamera = true
    line_beam.Color = ColorSequence.new(
        Color3.fromRGB(206, 141, 108),
        config.colors.orange
    )
    line_beam.Brightness = 3
    line_beam.LightEmission = 0
    line_beam.LightInfluence = 0
    line_beam.TextureMode = Enum.TextureMode.Static
    line_beam.Enabled = false

    local char = player.Character or player.CharacterAdded:Wait()
    line_beam.Parent = char

    local from_hrp = char:WaitForChild('HumanoidRootPart', 10^9)
    local to_hrp = local_player.Character:WaitForChild('HumanoidRootPart', 10^9)

    line_beam.Attachment0 = to_hrp:FindFirstChild('RootAttachment', true)
    line_beam.Attachment1 = from_hrp:FindFirstChild('RootAttachment', true)

    module.data.players_line[player.UserId] = line_beam
end

module.remove_line = function(player : Player)
    local line = module.data.players_line[player.UserId]
    line:Destroy()
end

return module