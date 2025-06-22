local camera = workspace.CurrentCamera
local IDEAL_SCREEN_SIZE = Vector2.new(1920, 1080)

local function sortObjectsByPriority(objects: { Instance }): { Instance }
    table.sort(objects, function(a, b)
        local priorityA = a:GetAttribute("Priority") or 0
        local priorityB = b:GetAttribute("Priority") or 0

        return priorityA > priorityB
    end)
  
    return objects
end

return function(screenGui: ScreenGui)
  local lastViewportSize = Vector2.zero
  local positionCache = { } :: { [Instance]: UDim2 }

  local function scalePosition(position: UDim2): UDim2
      local screenSize = camera.ViewportSize
      local scaleX = math.ceil(screenSize.X / IDEAL_SCREEN_SIZE.X)
      local scaleY = math.ceil(screenSize.Y / IDEAL_SCREEN_SIZE.Y)

      return UDim2.new(
          position.X.Scale,
          position.X.Offset * scaleX,
          position.Y.Scale,
          position.Y.Offset * scaleY
      )
  end

  local function updatePosition(descendant)
    local position = positionCache[descendant] or descendant.Position
    positionCache[descendant] = descendant.Position

    descendant.Position = scalePosition(position)
  end

  local function updatePositionByPriority()
    if camera.ViewportSize == lastViewportSize then
      return
    end

    lastViewportSize = camera.ViewportSize

    for _, child in ipairs(sortObjectsByPriority(screenGui:GetChildren())) do
      if child:GetAttribute("Static") ~= true then
        continue
      end

      for _, descendant in ipairs(child:GetDescendants()) do
        if descendant:IsA("GuiObject") == false then
          continue
        end

        updatePosition(descendant)
      end
    end
  end

  updatePositionByPriority()

  task.spawn(function()
    while true do
      updatePositionByPriority()
      
      task.wait()
    end
  end)
end
