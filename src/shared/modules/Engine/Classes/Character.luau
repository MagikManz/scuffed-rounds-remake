local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character: Character = { } :: Character
Character.__index = Character

local GetGameObject = require(ReplicatedStorage.Shared.modules.GetGameObject)

export type Character = {
  Object: Frame & {
    UICorner: UICorner,
    UIStroke: UIStroke
  },
  
  name: string,

  new: (name: string) -> Character,

  __index: Character,
  __tostring: () -> string,
}

function Character:__tostring(): string
  return "Character: " .. self.name
end

function Character.new(name: string): Character
  assert(typeof(name) == "string", "string expected got "..typeof(name))
  assert(name ~= "", "name cannot be an empty string")
  assert(name:match("^[%w_]+$"), "name can only contain alphanumeric characters and underscores")

  local characterObject = GetGameObject("CharacterTemplate")
  assert(characterObject, "CharacterTemplate not found in ReplicatedStorage")

  local characterDataModel = characterObject:Clone()
  characterDataModel.Name = name
  characterDataModel.Parent = GetGameObject("Characters") :: Frame

  local character = setmetatable({
    name = name,
    Object = characterDataModel
  }, Character)

  return character
end

return table.freeze(Character) :: Character
