local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)
local Raycast2D = require(ReplicatedStorage.shared.modules.Raycast2D)

local Player = Players.LocalPlayer

local KEY_MAP = {
    [Enum.KeyCode.W] = Raycast2D.Direction.Up(1),
    [Enum.KeyCode.S] = Raycast2D.Direction.Down(1),

    [Enum.KeyCode.A] = Raycast2D.Direction.Left(1),
    [Enum.KeyCode.D] = Raycast2D.Direction.Right(1),
  
    [Enum.KeyCode.Space] = Raycast2D.Direction.Up(1),
}

local function characterInputs(world: MatterTypes.World)
    for
        id,
        client: Components.Client,
        transform: Components.Transform,
        _renderable: Components.Renderable,
        _character: Components.Character
    in world:query(Components.Client, Components.Transform, Components.Renderable, Components.Character) do
      if client.player ~= Player then
        continue
      end

      local moveForce = Vector2.zero
      for keyCode, direction in pairs(KEY_MAP) do
        if UserInputService:IsKeyDown(keyCode) then
          moveForce += direction
        end
      end

      world:insert(id, transform:patch({
        moveForce = moveForce,
      }))

    end
end

return characterInputs