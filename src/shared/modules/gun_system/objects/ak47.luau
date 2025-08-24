local types = require(script.Parent.Parent.types)

return {
    name = 'AK-47',
    config = {
        fire_multitude = 1,
        fire_spread = .5,
        firerate_seconds = .3,
        raycast_bounces = 0,
        raycast_max_distance = 500,
        recoil_strength = 3,
        reload_time = 4
    }
} :: types.weapon