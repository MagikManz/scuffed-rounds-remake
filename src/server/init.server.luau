--[[
    Server initialization script for the Matter framework, and Util frameworks.

    @module init
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startMatter = require(ReplicatedStorage.Shared.startMatter)

startMatter({ script.systems, ReplicatedStorage.Shared.systems })
