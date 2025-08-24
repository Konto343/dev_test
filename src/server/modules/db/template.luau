--!strict

local module = {}

export type type = {
    level : number,
    world : string | nil,

    config : {
        volume : number,
        invisible : boolean,
    }
}

module.template = {
    level = 0,
    config = {
        invisible = true
    }
} :: type

return module