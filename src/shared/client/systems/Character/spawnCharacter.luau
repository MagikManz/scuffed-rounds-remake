local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local Engine = require(ReplicatedStorage.shared.modules.Engine)

local EngineCharacter = Engine.Classes.Character

local function spawnCharacter(world: MatterTypes.World)
    for 
        id,
        client: Components.Client,
        _character: Components.Character
    in world:query(Components.Client, Components.Character):without(Components.Renderable) do
        local character2D = EngineCharacter.new(client.player.Name)

        world:insert(id,
            Components.Gravity({
                gravityForce = 9.81
            }),
            Components.Renderable({
                model = character2D.Object,
                ref = character2D
            }),
            Components.Transform({
                moveForce = Vector2.zero,
            })
        )
    end
end

return spawnCharacter