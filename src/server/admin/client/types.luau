--!strict

local module = {}

export type command = {
	name : string,
	requirement : number | any,
	args : {{string}} | nil,
	info : string,
	run : (client : Player, args : {any}, ...any) -> ()
}

return module