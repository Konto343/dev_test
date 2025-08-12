local module = {}

local debug = require(script.Parent.debug)
local handler = require(script.Parent.handler)

local players = game:GetService('Players')

module.events = {
    players.PlayerAdded:Connect(function(player: Player)
        debug.add_track(player)
        debug.add_line(player)
        handler.add_player_listing(player)
    end),

    players.PlayerRemoving:Connect(function(player: Player)
        debug.remove_track(player)
        debug.remove_line(player)
        handler.remove_player_listing(player)
    end)
}

for _, player in players:GetPlayers() do
    debug.add_track(player)
    debug.add_line(player)
    handler.add_player_listing(player)
end

return module