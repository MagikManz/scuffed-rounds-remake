local ReplicatedStorage = game:GetService("ReplicatedStorage")

local characterEnums = require(ReplicatedStorage.Client.character.enums)

export type Controls = {
    keysDown: { []: boolean }
}

local Controls: Controls = { } :: Controls




return table.freeze(Controls) :: Controls