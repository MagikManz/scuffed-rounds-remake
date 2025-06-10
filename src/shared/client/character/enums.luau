export type Enums = {
    movement: MovementEnum,
}

export type GameEnums = MovementEnum

local Enums: Enums = { } :: Enums

local MOVEMENT_ENUMS: MovementEnum = {
    Forward = "FORWARD",
    Backwards = "BACKWARDS",
    Jump = "JUMP",
    Crouch = "CROUCH",
}

export type MovementEnum = {
    Forward: "FORWARD",
    Backwards: "BACKWARDS",
    Jump: "JUMP",
    Crouch: "CROUCH",
}



Enums.movement = table.freeze(MOVEMENT_ENUMS) :: MovementEnum

return table.freeze(Enums) :: Enums