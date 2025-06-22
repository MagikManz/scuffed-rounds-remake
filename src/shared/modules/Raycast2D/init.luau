--[[
    Raycast2D - A 2D raycast system for Roblox UIs
    Author: @MagikManz (MagikTheWizard)
    Version: 1.0.0
    
]]

local Raycast2D: Raycast2D = {
  _Debug = true
} :: Raycast2D
Raycast2D.__index = Raycast2D

local Direction = require(script.Direction)

local INCLUDE_FILTER = Enum.RaycastFilterType.Include
local EXCLUDE_FILTER = Enum.RaycastFilterType.Exclude

Raycast2D.Direction = Direction

export type Raycast2D = {
  Cast: (self: Raycast2D, dataModel: ScreenGui, origin: Vector2, direction: Vector2, raycastParams: RaySettings) -> (Instance?, Vector2?),

  RaySettings: RaySettings,
  Direction: Direction.Direction,

  _Debug: boolean,

  __index: Raycast2D,
}

export type RaySettings = {
    FilterDescendantsInstances: { GuiObject },
    FilterType: Enum.RaycastFilterType,
    RespectVisibility: boolean,
    BruteForce: boolean,
}

local _debugFrames = { } :: { Frame }

local function filterInstance(guiInstance: GuiObject, raycastParams: RaySettings): boolean
  if 
    guiInstance:IsA("GuiObject") == false
    or guiInstance.Visible == false and raycastParams.RespectVisibility ~= true and raycastParams.BruteForce ~= true
    or guiInstance:GetAttribute("CanQuery") == false and raycastParams.BruteForce ~= true
    or guiInstance.AbsoluteSize == Vector2.new(0, 0)
    or table.find(_debugFrames, guiInstance) ~= nil
  then
    return false
  end

  for _, instance in ipairs(raycastParams.FilterDescendantsInstances) do
    if guiInstance == instance then
      return 
        raycastParams.FilterType == INCLUDE_FILTER
        or raycastParams.FilterType == EXCLUDE_FILTER and table.find(raycastParams.FilterDescendantsInstances, guiInstance) == nil
    end
  end

  return true
end

local function lineIntersection(p1, p2, p3, p4)
    local s1 = p2 - p1
    local s2 = p4 - p3

    local denominator = (-s2.X * s1.Y + s1.X * s2.Y)
    if denominator == 0 then
        return false, nil
    end

    local s = (-s1.Y * (p1.X - p3.X) + s1.X * (p1.Y - p3.Y)) / denominator
    local t = ( s2.X * (p1.Y - p3.Y) - s2.Y * (p1.X - p3.X)) / denominator

    if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
        local intersection = p1 + (s1 * t)
        return true, intersection
    end

    return false, nil
end

local function intersectsRayRect(origin: Vector2, direction: Vector2, rectPos: Vector2, rectSize: Vector2): (boolean, Vector2?)
    local rayEnd = origin + direction

    local topLeft = rectPos
    local topRight = rectPos + Vector2.new(rectSize.X, 0)
    local bottomLeft = rectPos + Vector2.new(0, rectSize.Y)
    local bottomRight = rectPos + rectSize

    local sides = {
        {topLeft, topRight},
        {topRight, bottomRight},
        {bottomRight, bottomLeft},
        {bottomLeft, topLeft},
    }

    for _, side in pairs(sides) do
        local hit, intersection = lineIntersection(origin, rayEnd, side[1], side[2])
        if hit then
            return true, intersection
        end
    end

    return false, nil
end

function Raycast2D:Cast(dataModel: ScreenGui, origin: Vector2, direction: Vector2, raycastParams: RaySettings): (Instance?, Vector2?)
  assert(typeof(dataModel) == "Instance" and dataModel:IsA("ScreenGui"), "ScreenGui expected got " .. typeof(dataModel))
  assert(typeof(origin) == "Vector2", "Vector2 expected got " .. typeof(origin))
  assert(typeof(direction) == "Vector2", "Vector2 expected got " .. typeof(direction))
  assert(type(raycastParams) == "table", "RaycastParams expected got " .. typeof(raycastParams))

  for _, guiInstance in ipairs(dataModel:GetDescendants()) do
    if filterInstance(guiInstance :: GuiObject, raycastParams) == false then
      continue
    end

    local absolutePosition = (guiInstance :: GuiObject).AbsolutePosition
    local absoluteSize = (guiInstance :: GuiObject).AbsoluteSize

    local hit, hitPosition = intersectsRayRect(origin, direction, absolutePosition, absoluteSize)
    if hit then
      return guiInstance :: GuiObject, hitPosition
    end
  end

  return nil
end

return Raycast2D 
