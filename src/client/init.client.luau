--[[
    Client initialization script for the Matter framework, and Util frameworks.

    @module init
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local start = require(ReplicatedStorage.Shared.startMatter)
local receiveReplication = require(ReplicatedStorage.Client.receiveReplication)

local world, state = start({
	ReplicatedStorage.Shared.systems,
	ReplicatedStorage.Client.systems,
})

receiveReplication(world, state)
