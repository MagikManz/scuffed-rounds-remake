local Direction: Direction = { } :: Direction

export type Direction = {
  Right: (pixels: number) -> Vector2,
  Left: (pixels: number) -> Vector2,

  Up: (pixels: number) -> Vector2,
  Down: (pixels: number) -> Vector2,

  Angle: (angle: number, pixels: number) -> Vector2,
}

function Direction.Right(pixels: number): Vector2
  assert(typeof(pixels) == "number", "number expected got "..typeof(pixels))
  return Vector2.new(pixels, 0)
end

function Direction.Left(pixels: number): Vector2
  assert(typeof(pixels) == "number", "number expected got "..typeof(pixels))
  return Vector2.new(-pixels, 0)
end

function Direction.Up(pixels: number): Vector2
  assert(typeof(pixels) == "number", "number expected got "..typeof(pixels))
  return Vector2.new(0, -pixels)
end

function Direction.Down(pixels: number): Vector2
  assert(typeof(pixels) == "number", "number expected got "..typeof(pixels))
  return Vector2.new(0, pixels)
end

function Direction.Angle(angle: number, pixels: number): Vector2
  assert(typeof(angle) == "number", "number expected got "..typeof(angle))
  assert(typeof(pixels) == "number", "number expected got "..typeof(pixels))

	local radians = math.rad(angle)
  local dx = math.cos(radians) * pixels
  local dy = math.sin(radians) * pixels

  return Vector2.new(dx, dy)
end

return table.freeze(Direction) :: Direction
