local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages

local Matter = require(Packages.matter)
local Plasma = require(Packages.plasma)
local Rewire = require(Packages.rewire)

local Components = require(ReplicatedStorage.shared.Components)

local HotReloader = Rewire.HotReloader

local function start(containers)
	local world = Matter.World.new()
	local state = {
		serverClientEntityMap = {},
		clientServerEntityMap = {},
	}

	local debugger = Matter.Debugger.new(Plasma)

	debugger.findInstanceFromEntity = function(id)
		if not world:contains(id) then
			return
		end

		local model = world:get(id, Components.Renderable)

		return model and model.model or nil
	end

	local loop = Matter.Loop.new(world, state, debugger:getWidgets())

	local hotReloader = HotReloader.new()

	local firstRunSystems: nil | { any } = {}
	local systemsByModule = {}

	local function loadModule(module, context)
		local originalModule = context.originalModule

		local ok, system = pcall(require, module)

		if not ok then
			warn("Error when hot-reloading system", module.name, system)
			return
		end

		if firstRunSystems then
			table.insert(firstRunSystems, system)
		elseif systemsByModule[originalModule] then
			loop:replaceSystem(systemsByModule[originalModule], system)
			debugger:replaceSystem(systemsByModule[originalModule], system)
		else
			loop:scheduleSystem(system)
		end

		systemsByModule[originalModule] = system
	end

	local function unloadModule(_, context)
		if context.isReloading then
			return
		end

		local originalModule = context.originalModule
		if systemsByModule[originalModule] then
			loop:evictSystem(systemsByModule[originalModule])
			systemsByModule[originalModule] = nil
		end
	end

	for _, container in containers do
		hotReloader:scan(container, loadModule, unloadModule)
	end

	loop:scheduleSystems(firstRunSystems)
	firstRunSystems = nil

	debugger:autoInitialize(loop)

	loop:begin({
		default = RunService.Heartbeat,
		Stepped = RunService.Stepped,
	})

	if RunService:IsClient() then
        if Players.LocalPlayer.UserId == 241384097 then
			warn("Debugging is enabled for the server creator.")
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.F4 then
					print("Toggling debugger")
                    debugger:toggle()
                    state.debugEnabled = debugger.enabled
                end
            end)
        end
	end

	debugger.authorize = function(player: Player)
        return player.UserId ~= 241384097
	end

	return world, state
end

return start