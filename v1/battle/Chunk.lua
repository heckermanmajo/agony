----------------------------------------
--- @class Chunk
--- @field x number
--- @field y number
--- @field tiles Tile[]
--- @field public instances Chunk[] STATIC
--- @field public units Unit[] STATIC
--- @field public passive_objects PassiveObject[] STATIC
--- @field public current_owner FactionState
--- @field public instances_on_xy table<number, table<number, Chunk>> STATIC
---
--- @see Unit:update_my_chunk
----------------------------------------
Chunk = {
  instances = {},
  instances_on_xy = {},
}
Chunk.__index = Chunk

----------------------------------------
--- Create a new chunk.
--- @param x number
--- @param y number
----------------------------------------
function Chunk.new(x, y)

  assert(type(x) == "number", "Expected number, got " .. type(x))
  assert(type(y) == "number", "Expected number, got " .. type(y))

  local self = {}
  setmetatable(self, Chunk)

  self.x = x
  self.y = y
  self.tiles = {}
  self.units = {}
  self.passive_objects = {}
  self.current_owner = nil

  table.insert(Chunk.instances, self)
  Chunk.instances_on_xy[x] = Chunk.instances_on_xy[x] or {}
  Chunk.instances_on_xy[x][y] = self

  return self

end

----------------------------------------
--- Returns the chunk at the given pixel coordinates or nil if it doesn't exist
--- @param x_pixel number the x pixel coordinate, does not need to be a multiple of CHUNK_SIZE_IN_PIXELS
--- @param y_pixel number the y pixel coordinate, does not need to be a multiple of CHUNK_SIZE_IN_PIXELS
--- @param throw boolean if true, throws an error if the chunk doesn't exist; on default false, so returns nil if the chunk doesn't exist
--- @return Chunk|nil
----------------------------------------
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

----------------------------------------
--- @return Chunk[]
----------------------------------------
function Chunk:get_neighbours(not_diagonal)
  Chunk.assert(self)
  local directions = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 }, { 1, 1 }, { -1, 1 }, { 1, -1 }, { -1, -1 } }
  if not_diagonal then directions = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } } end
  local neighbours = {}
  for _, direction in ipairs(directions) do
    local x = self.x + direction[1]
    local y = self.y + direction[2]
    local neighbour = Chunk.get(x, y)
    if neighbour then table.insert(neighbours, neighbour) end
  end
  return neighbours
end

----------------------------------------
--- Checks the state of the chunk.
--- F.e. if all units are on the correct chunk.
--- @see Unit:update_my_chunk
----------------------------------------
function Chunk:check_chunk_state()
  Chunk.assert(self)
  return;
  -- todo: we accept a small lag here for performance reasons
  --for _, u in ipairs(self.units) do
  --  if not u:is_out_of_world() then
  --    if u.x < self.x * Battle.CHUNK_SIZE_IN_PIXELS or u.x >= (self.x + 1) * Battle.CHUNK_SIZE_IN_PIXELS then
  --      error("Unit is not on the correct chunk: " .. u.x .. " not in " .. self.x * Battle.CHUNK_SIZE_IN_PIXELS .. " - " .. (self.x + 1) * Battle.CHUNK_SIZE_IN_PIXELS)
  --    end
  --    if u.y < self.y * Battle.CHUNK_SIZE_IN_PIXELS or u.y >= (self.y + 1) * Battle.CHUNK_SIZE_IN_PIXELS then
  --      error("Unit is not on the correct chunk: " .. u.y .. " not in " .. self.y * Battle.CHUNK_SIZE_IN_PIXELS .. " - " .. (self.y + 1) * Battle.CHUNK_SIZE_IN_PIXELS)
  --    end
  --  end
  --end
end

----------------------------------------
--- Updates the owner of the chunk: used to determine map control.
----------------------------------------
function Chunk:update_owner_of_chunk()
  local different_owner = false
  for _, u in ipairs(self.units) do
    if self.current_owner == nil then
      self.current_owner = u.owner
    elseif u.owner ~= self.current_owner then
      different_owner = true
      break
    end
  end
  if different_owner then self.current_owner = nil end
end

function Chunk.is(x) return getmetatable(x) == Chunk end
function Chunk.assert(x) assert(Chunk.is(x), "Expected Chunk. Got " .. type(x)) end