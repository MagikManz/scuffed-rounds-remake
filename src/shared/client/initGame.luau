--[[
    Filename: initGame.luau
    Author: @MagikManz (MagikTheWizard)
--]]

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local function InitGameScene()
  warn("Initializing Game Scene...")
  local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui
  warn("PlayerGui found:", PlayerGui)
  local GameScene = StarterGui:WaitForChild("Game") :: ScreenGui
  warn("GameScene found:", GameScene)

  GameScene.Parent = PlayerGui

  StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end

return InitGameScene
