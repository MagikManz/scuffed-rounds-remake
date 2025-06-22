--[[
    Client initialization script for the Matter framework, and Util frameworks.

    @module init
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local start = require(ReplicatedStorage.shared.startMatter)
local receiveReplication = require(ReplicatedStorage.client.receiveReplication)
local initGame = require(ReplicatedStorage.client.initGame)

print("starting World...")
initGame()

local world, state = start({
	ReplicatedStorage.shared.systems,
	ReplicatedStorage.client.systems,
})

print("setting up replication...")
receiveReplication(world, state)

print("finished loading world!")