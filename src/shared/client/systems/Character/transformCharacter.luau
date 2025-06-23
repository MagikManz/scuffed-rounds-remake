local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local Raycast2D = require(ReplicatedStorage.shared.modules.Raycast2D)

local GUI_INSET_CONSTANT = Raycast2D.Direction.Down(GuiService:GetGuiInset().Y).Y

local function transformCharacters(world: MatterTypes.World)
    for 
        id,
        transformRecord: { old: Components.Transform?, new: Components.Transform }
    in world:queryChanged(Components.Transform) do
        local transform = transformRecord.new
        if transform == nil then
            continue
        end

        local renderable = world:get(id, Components.Renderable)
        if renderable == nil then
            continue
        end

        local character = world:get(id, Components.Character)
        if character == nil then
            continue
        end

        local health = character.health
        if health <= 0 then
            world:remove(id, Components.Character, Components.Renderable, Components.Transform)
            continue
        end

        local characterObject = renderable.model
        local characterPosition = characterObject.AbsolutePosition

        local moveForce = transform.moveForce
        local downwardForce = transform.downwardForce
        print(transformRecord)
        if moveForce.Magnitude > 0 then
            characterPosition += moveForce
        end

        if downwardForce.Magnitude > 0 then
            characterPosition += downwardForce
        end

        characterObject.Position = UDim2.fromOffset(characterPosition.X, characterPosition.Y + GUI_INSET_CONSTANT)
    end
end

return transformCharacters