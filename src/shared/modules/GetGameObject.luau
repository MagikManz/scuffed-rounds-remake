local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function checkObjectParent(object: Instance): boolean
  return object:IsDescendantOf(ReplicatedStorage) or object:IsDescendantOf(Players)
end

local function getObject(objectClass: string): Instance?
  for _, object in ipairs(CollectionService:GetTagged(objectClass)) do
    if checkObjectParent(object) then
      return object :: Instance?
    end
  end

  return nil
end

return function(objectClass: string): Instance?
  local object = getObject(objectClass)
  local timeOut = 10 
  while object == nil and timeOut > 0 do
    object = getObject(objectClass)
    timeOut -= task.wait(1)
  end

  return object
end
