

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)
local Character = ReplicatedStorage.Character.character

local MatterTypes = require(ReplicatedStorage.Shared.MatterTypes)

local function spawnCharacter(world: MatterTypes.World)
    for 
        id,
        client: Components.Client,
        _character: Components.Character
    in world:query(Components.Client, Components.Character):without(Components.Renderable) do

        local playerCharacter = Character:Clone()
        playerCharacter:SetAttribute("playerId", client.player.UserId)
        playerCharacter.Parent = workspace

        world:insert(id,
            Components.Renderable({
                model = playerCharacter,
                root = playerCharacter.PrimaryPart,
            }),
            Components.Transform({
                moveForce = Vector3.new(0, 0, 0)
            })
        )
    end
end

return spawnCharacter