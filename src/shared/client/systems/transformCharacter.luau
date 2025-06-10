local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Components = require(ReplicatedStorage.Shared.Components)

local LocalPlayer = Players.LocalPlayer

local MatterTypes = require(ReplicatedStorage.Shared.MatterTypes)

local function transformCharacters(world: MatterTypes.World)
    for 
        id,
        character: Components.Character,
        renderable: Components.Renderable,
        transform: Components.Transform
    in world:query(Components.Character, Components.Renderable, Components.Transform) do
        local health = character.health
        if health <= 0 then
            world:remove(id, Components.Character, Components.Renderable, Components.Transform)
            continue
        end

        local root = renderable.root

        local linearVelocity = root.LinearVelocity

        linearVelocity.VectorVelocity = transform.moveForce
    end
end

return transformCharacters