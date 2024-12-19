
--- @class Tile
--- @field public x number
--- @field public y number
Tile = {
  instances = {},
  instances_on_xy = {},
}

Tile.__index = Tile

function Tile.new(x,y)

  local self = {}
  setmetatable(self, Tile)

  self.x = x
  self.y = y

  table.insert(Tile.instances, self)
  Tile.instances_on_xy[x] = Tile.instances_on_xy[x] or {}
  Tile.instances_on_xy[x][y] = self

  return self

end


function Tile.is(x) return getmetatable(x) == Tile end
function Tile.assert(x) assert(Tile.is(x), "Expected Tile. Got " .. type(x)) end
