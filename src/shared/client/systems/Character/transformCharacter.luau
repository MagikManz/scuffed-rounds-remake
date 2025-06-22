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
        transform: Components.Transform
    in world:query(Components.Character, Components.Renderable, Components.Transform) do
        local health = character.health
        if health <= 0 then
            world:remove(id, Components.Character, Components.Renderable, Components.Transform)
            continue
        end

        local characterObject = renderable.model
        local characterPosition = characterObject.AbsolutePosition

        local moveForce = transform.moveForce

        local hit, hitPosition = Engine.Workspace:Raycast(characterObject.AbsolutePosition, Raycast2D.Direction.Down(1000), {
            FilterDescendantsInstances = { characterObject },
            FilterType = Enum.RaycastFilterType.Exclude,
            RespectVisibility = true,
            BruteForce = false
        })

        if hit then
            characterPosition = Vector2.new(characterPosition.X, hitPosition.Y) - Vector2.yAxis * hit.AbsoluteSize.Y / 2 
        else
            warn("No ground detected for character: " .. characterObject.Name)
        end

        if moveForce.Magnitude > 0 then
            characterPosition += moveForce
        end

        characterObject.Position = UDim2.fromOffset(characterPosition.X, characterPosition.Y)
    end
end

return transformCharacters