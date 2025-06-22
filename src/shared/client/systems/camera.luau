--[[
    Handles camera movement and zooming in/out based on user input and well the main 2D camera system.

    @module Components
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatterTypes = require(ReplicatedStorage.shared.MatterTypes)

local currentStage = workspace:WaitForChild("Stage")

local function camera(_world: MatterTypes.World)
    local worldCamera = workspace.CurrentCamera
    worldCamera.CameraType = Enum.CameraType.Scriptable

    local stageCFrame, stageSize = currentStage:GetPivot(), currentStage.Size

    local viewportSize = worldCamera.ViewportSize
    local aspectRatio = viewportSize.X / viewportSize.Y

    local maxDimension = math.max(stageSize.X / aspectRatio, stageSize.Y)
    local distance = (maxDimension / 2) / math.tan(math.rad(worldCamera.FieldOfView / 2))

    local cameraPosition = stageCFrame.Position + stageCFrame.LookVector * -distance
    worldCamera.CFrame = CFrame.new(cameraPosition, stageCFrame.Position)
end

return camera
