--- @class Sector
--- @field x number
--- @field y number
--- @field chunks Chunk[]
--- @field public instances Sector[]
--- @field public instances_as_xy_map table<number, table<number, Sector>>
Sector = {
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

  table.insert(Sector.instances, self)
  Sector.instances_as_xy_map[x] = Sector.instances_as_xy_map[x] or {}
  Sector.instances_as_xy_map[x][y] = self

  return self

end

--- Get all the chunks of that sector, which border the end of the map.
--- @return Chunk[]
function Sector:get_map_border_chunks() end

--- Get the sector at the given pixel coordinates or nil if it doesn't exist
function Sector.get(x_pixel, y_pixel, throw) end

function Sector.is(x) return getmetatable(x) == Sector end

function Sector.assert(x) assert(Sector.is(x), "Expected Sector. Got " .. type(x)) end
