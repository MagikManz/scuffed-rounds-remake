--[[
    Spawning player entities when they join the game.

    @module player
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Matter = require(ReplicatedStorage.Packages.matter)
local MatterTypes = require(ReplicatedStorage.Shared.MatterTypes)

local Components = require(ReplicatedStorage.Shared.Components)

local function playerAdded(world: MatterTypes.World)
    for _, player: Player in Matter.useEvent(Players, "PlayerAdded") do
        world:spawn(
            Components.Client({
                player = player
            }),
            Components.Character({
                walkspeed = 16,
                health = 100,
                maxHealth = 100,
                regen = 1,
            })
        )
    end
end

return playerAdded
