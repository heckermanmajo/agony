--- @class Sector
local Sector = {
  instances = {},
  instances_as_xy_map = {},
}
Sector.__index = Sector

function Sector.new(x,y)

  local self = {}
  setmetatable(self, Sector)

  self.x = x
  self.y = y
  self.chunks = {}
  self.chunks_as_xy_map = {}

  for chunk_x = 1, Battle.SECTOR_SIZE_IN_CHUNKS do
    for chunk_y = 1, Battle.SECTOR_SIZE_IN_CHUNKS do
      local chunk = Chunk.new(self, chunk_x, chunk_y)
      table.insert(self.chunks, chunk)
      self.chunks_as_xy_map[chunk_x] = self.chunks_as_xy_map[chunk_x] or {}
      self.chunks_as_xy_map[chunk_x][chunk_y] = chunk
    end
  end

  table.insert(Sector.instances, self)
  Sector.instances_as_xy_map[x] = Sector.instances_as_xy_map[x] or {}
  Sector.instances_as_xy_map[x][y] = self

  return self

end

function Sector.is(x) return getmetatable(x) == Sector end
function Sector.assert(x) assert(Sector.is(x), "Expected Sector. Got " .. type(x)) end

return Sector