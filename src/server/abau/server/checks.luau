local module = {}

local config = {
    mininum_creation_days = 30 :: number | nil,
    blacklist_friends = true :: boolean | nil,

    blacklist = {

    } :: {[number] : string},

    blacklist_groups = {

    } :: {[number] : string},
}

module.check = function(player : Player)
    if config.mininum_creation_days and (player.AccountAge < config.mininum_creation_days) then
        player:Kick(`Your account must be older than {config.mininum_creation_days} days to play this game.`)
    end

    if config.blacklist[player.UserId] then
        local reason = config.blacklist[player.UserId] or 'N/A'
        player:Kick(`You are blacklisted from this game. Reason: {reason}`)
    end

    for group, kick_reason in config.blacklist_groups do
        if player:IsInGroup(group) then
            kick_reason = kick_reason or 'N/A'
            player:Kick(`Your account is inside of group that has been blacklisted from this game. Reason: {kick_reason}`)
        end
    end

    for user, kick_reason in config.blacklist do
        if player:IsFriendsWith(user) then
            player:Kick(`Your account is friends with another account whose been blacklisted from this game. (With => {user})`)
        end
    end
end

return module