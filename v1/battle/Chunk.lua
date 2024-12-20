--- @class Chunk
--- @field x number
--- @field y number
--- @field tiles Tile[]
--- @field public instances Chunk[] STATIC
--- @field public units Unit[] STATIC
--- @field public passive_objects PassiveObject[] STATIC
--- @field public instances_on_xy table<number, table<number, Chunk>> STATIC
Chunk = {
  instances = {},
  instances_on_xy = {},
}
Chunk.__index = Chunk

function Chunk.new(x,y)
  local self = {}
  setmetatable(self, Chunk)

  self.x = x
  self.y = y
  self.tiles = {}
  self.units = {}
  self.passive_objects = {}

  table.insert(Chunk.instances, self)
  Chunk.instances_on_xy[x] = Chunk.instances_on_xy[x] or {}
  Chunk.instances_on_xy[x][y] = self

  return self

end

function Chunk:remove_unit(unit)
  for i, u in ipairs(self.units) do
    if u == unit then
      table.remove(self.units, i)
      return
    end
  end
end

function Chunk:draw()

  -- draw a rect around te sector
  love.graphics.setColor(1, 1, 1)

  local x, y = Battle.current.ui:transform(
    self.x * Battle.CHUNK_SIZE_IN_PIXELS,
    self.y * Battle.CHUNK_SIZE_IN_PIXELS)

  love.graphics.rectangle("line", x, y,
    Battle.CHUNK_SIZE_IN_PIXELS,
    Battle.CHUNK_SIZE_IN_PIXELS
  )

  -- draw all the tiles
  for _, tile in ipairs(self.tiles) do
    tile:draw()
  end

end

--- Returns the chunk at the given pixel coordinates or nil if it doesn't exist
--- @param x_pixel number the x pixel coordinate, does not need to be a multiple of CHUNK_SIZE_IN_PIXELS
--- @param y_pixel number the y pixel coordinate, does not need to be a multiple of CHUNK_SIZE_IN_PIXELS
--- @param throw boolean if true, throws an error if the chunk doesn't exist; on default false, so returns nil if the chunk doesn't exist
--- @return Chunk|nil
function Chunk.get(x_pixel, y_pixel, throw)
  throw = throw or false
  assert(type(x_pixel) == "number", "Expected x_pixel to be a number, got " .. type(x_pixel))
  assert(type(y_pixel) == "number", "Expected y_pixel to be a number, got " .. type(y_pixel))
  assert(type(throw) == "boolean", "Expected throw to be a boolean, got " .. type(throw))
  local x = math.floor(x_pixel / Battle.CHUNK_SIZE_IN_PIXELS)
  local y = math.floor(y_pixel / Battle.CHUNK_SIZE_IN_PIXELS)
  local exists = Chunk.instances_on_xy[x] and Chunk.instances_on_xy[x][y]
  if exists then return Chunk.instances_on_xy[x][y] end
  if throw then error("Chunk not found at " .. x .. ", " .. y) end
  return nil
end

--- @return Chunk[]
function Chunk:get_neighbours(not_diagonal)
  local directions = {{1,0}, {0,1}, {-1,0}, {0,-1}, {1,1}, {-1,1}, {1,-1}, {-1,-1}}
  if not_diagonal then directions = {{1,0}, {0,1}, {-1,0}, {0,-1}} end
  local neighbours = {}
  for _, direction in ipairs(  ) do
    local x = self.x + direction[1]
    local y = self.y + direction[2]
    local neighbour = Chunk.get(x, y)
    if neighbour then table.insert(neighbours, neighbour) end
  end
  return neighbours
end

function Chunk:check_chunk_state()
  -- todo: check all the units are on the correct chunk...
end

function Chunk.is(x) return getmetatable(x) == Chunk end
function Chunk.assert(x) assert(Chunk.is(x), "Expected Chunk. Got " .. type(x)) end