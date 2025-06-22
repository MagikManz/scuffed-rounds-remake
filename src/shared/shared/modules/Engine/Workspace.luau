local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace: Workspace = { } :: Workspace
Workspace.__index = Workspace

export type Workspace = {
  Raycast: (self: Workspace, origin: Vector2, direction: Vector2, raycastParams: RaySettings) -> (Instance?, Vector2?),

  Object: Frame,
  
  __index: Workspace,
}

local Raycast2D = require(ReplicatedStorage.shared.modules.Raycast2D)
local GetGameObject = require(ReplicatedStorage.shared.modules.GetGameObject)

type Raycast2D = Raycast2D.Raycast2D
type RaySettings = Raycast2D.RaySettings

local function Init()

  Workspace.Object = GetGameObject("Workspace") :: Frame
  print("Workspace initialized with Object:", Workspace.Object)
end

function Workspace:Raycast(origin: Vector2 | UDim2, direction: Vector2, raycastParams: RaySettings): (Instance?, Vector2?)
  assert(typeof(origin) == "Vector2" or typeof(origin) == "UDim2", "Vector2 | UDim2 expected got "..typeof(origin))
  assert(typeof(direction) == "Vector2", "Vector2 expected got "..typeof(direction))
  assert(type(raycastParams) == "table", "RaycastParams expected got "..typeof(raycastParams))

  local hit, hitPosition = Raycast2D:Cast(GetGameObject("DataModel") :: ScreenGui, origin :: Vector2, direction, raycastParams)

  return hit, hitPosition
end

Init()

return table.freeze(Workspace) :: Workspace
