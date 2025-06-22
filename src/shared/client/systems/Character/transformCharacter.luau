local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local Engine = require(ReplicatedStorage.shared.modules.Engine)

local Raycast2D = require(ReplicatedStorage.shared.modules.Raycast2D)

local function transformCharacters(world: MatterTypes.World)
    for 
        id,
        character: Components.Character,
        renderable: Components.Renderable,
        _transform: Components.Transform
    in world:query(Components.Character, Components.Renderable, Components.Transform) do
        local health = character.health
        if health <= 0 then
            world:remove(id, Components.Character, Components.Renderable, Components.Transform)
            continue
        end

        local map = Engine.GetGameObject("Map")
        if not map then
            warn("Map not found in Engine")
            continue
        end

        local characterObject = renderable.model
      
        local hit, hitPosition = Engine.Workspace:Raycast(characterObject.AbsolutePosition, Raycast2D.Direction.Down(1000), {
            FilterDescendantsInstances = { characterObject },
            FilterType = Enum.RaycastFilterType.Exclude,
            RespectVisibility = true,
            BruteForce = false
        })

        if hit then
            characterObject.Position = 
                UDim2.fromOffset(characterObject.AbsolutePosition.X, hitPosition.Y)
                - UDim2.fromOffset(0, hit.AbsoluteSize.Y / 2)
        else
            warn("No ground detected for character: " .. characterObject.Name)
        end
    end
end

return transformCharacters