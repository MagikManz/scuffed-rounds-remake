local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Game: Game = { } :: Game
Game.__index = Game

local Workspace = require(ReplicatedStorage.Shared.modules.Engine.Workspace)

export type Game = {
  DataModel: ScreenGui,

  Workspace: Workspace.Workspace,
  workspace: Workspace.Workspace,

  __index: Game,
}

local function Init()
  local GetGameObject = require(ReplicatedStorage.Shared.modules.GetGameObject)
  local ScaleWithScreen = require(ReplicatedStorage.Shared.modules.ScaleWithScreen)

  Game.DataModel = GetGameObject("DataModel") :: ScreenGui

  Game.Workspace = Workspace
  Game.workspace = Workspace

  ScaleWithScreen(Game.DataModel)
end

Init()

return table.freeze(Game) :: Game
