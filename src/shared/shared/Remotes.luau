local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Packages.Net)
--local t = require(ReplicatedStorage.Packages.t)

local Remotes = Net.CreateDefinitions({
    MatterServer = Net.Definitions.ServerToClientEvent(),
    MatterClient = Net.Definitions.ClientToServerEvent(),
})

return Remotes
