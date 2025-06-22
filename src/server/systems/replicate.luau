--[[
    Responsible for replicating components to clients.

    @module replicate
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = require(ReplicatedStorage.shared.Remotes)

local Matter = require(ReplicatedStorage.Packages.matter)
local Components = require(ReplicatedStorage.shared.Components)

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local MatterServerRemote = Remotes.Server:Get("MatterServer")
print("MatterServerRemote", MatterServerRemote)

local REPLICATED_COMPONENTS = {
    "Client",
    "Character"
}

local replicatedComponents = { }
for _, name in ipairs(REPLICATED_COMPONENTS) do
    replicatedComponents[Components[name]] = true
end

local function replicate(world: MatterTypes.World)
    local changes = {}

    for component in replicatedComponents do
        for entityId, record in world:queryChanged(component) do

            local key = tostring(entityId)

            local name = tostring(component)

            if changes[key] == nil then
                changes[key] = {}
            end

            if world:contains(entityId) then
                changes[key][name] = { data = record.new }
            end
        end
    end

    if next(changes) then
        MatterServerRemote:SendToAllPlayers(changes)
    end

    for _, player in Matter.useEvent(Players, "PlayerAdded") do
        local payload = {}

        for entityId, entityData in world do
            local entityPayload = {}

            for component, componentData in entityData do
                if replicatedComponents[component] then
                    entityPayload[tostring(component)] = { data = componentData }
                end
            end

            payload[tostring(entityId)] = entityPayload
        end

        MatterServerRemote:SendToPlayer(player, payload)
    end
end

return {
    system = replicate,
    priority = math.huge
}