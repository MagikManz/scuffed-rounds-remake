local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local Player = Players.LocalPlayer

local function characterInputs(world: MatterTypes.World)
    for
        _id,
        client: Components.Client,
        transform: Components.Transform,
        _renderable: Components.Renderable,
        _character: Components.Character
    in world:query(Components.Client, Components.Transform, Components.Renderable, Components.Character) do
      if client.player ~= Player then
        continue
      end

      
    end
end

return characterInputs