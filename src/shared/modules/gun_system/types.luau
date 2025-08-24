local module = {}

export type weapon = {
    name : string,
    is_locked : boolean,
    config : {
        recoil_strength : number,
        raycast_max_distance : number,
        raycast_bounces : number | nil,
        fire_multitude : number, --bullets per "shot"
        fire_spread : number,
        firerate_seconds : number,
        reload_time : number,
        max_ammo : number,
        max_ammo_round : number
    },
    animations : {
        equip : Animation,
        unequip : Animation,
        reload : Animation,
        fire : Animation,
    }
}

return module