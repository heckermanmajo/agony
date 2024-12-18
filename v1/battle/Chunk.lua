local Chunk = {
  instances = {},
  instances_on_xy = {},
}
Chunk.__index = Chunk

function Chunk.new(x,y)
  local self = {}
  setmetatable(self, Chunk)

  self.x = x
  self.y = y

  table.insert(Chunk.instances, self)
  Chunk.instances_on_xy[x] = Chunk.instances_on_xy[x] or {}
  Chunk.instances_on_xy[x][y] = self

  for tile_x = 1, Battle.CHUNK_SIZE_IN_TILES do
    for tile_y = 1, Battle.CHUNK_SIZE_IN_TILES do
      local tile = Tile.new(self, tile_x, tile_y)
    end
  end

  return self

end

function Chunk.is(x) return getmetatable(x) == Chunk end
function Chunk.assert(x) assert(Chunk.is(x), "Expected Chunk. Got " .. type(x)) end


return Chunk