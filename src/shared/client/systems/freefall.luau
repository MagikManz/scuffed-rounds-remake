local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local Engine = require(ReplicatedStorage.shared.modules.Engine)

local Raycast2D = require(ReplicatedStorage.shared.modules.Raycast2D)

local function freefall(world: MatterTypes.World)
    for 
      id,
      renderable: Components.Renderable,
      transform: Components.Transform
    in world:query(Components.Renderable, Components.Transform) do
      local object = renderable.model
      local objectPosition = object.AbsolutePosition
      local moveForce = transform.moveForce

      local hit, hitPosition = Engine.Workspace:Raycast(objectPosition, Raycast2D.Direction.Down(object.AbsoluteSize.Y * 1.5), {
          FilterDescendantsInstances = { object },
          FilterType = Enum.RaycastFilterType.Exclude,
          RespectVisibility = true,
          BruteForce = false
      })

      if hit ~= nil and hit:IsA("GuiObject") then
        if moveForce.Y ~= 0 then
          continue
        end
  
        object.Position = UDim2.fromOffset(objectPosition.X, hitPosition.Y + hit.AbsoluteSize.Y / 2)
        world:insert(id, transform:patch({
            downwardForce = Vector2.zero,
        }))

        continue
      end

      world:insert(id, transform:patch({
          downwardForce = Raycast2D.Direction.Down(1),
      }))
  end
end

return freefall