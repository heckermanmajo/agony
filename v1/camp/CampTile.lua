
--- @class CampTile
--- @field x number
--- @field y number
--- @field type string
--- @field owner FactionState
--- @field settlement boolean does this tile have a settlement?
--- @field factory boolean does this tile have a factory?
--- @field logistics_camp boolean does this tile have an army camp?
CampTile = {
  instances = {},
}

CampTile.__index = CampTile

---
function CampTile.new(x,y, type, owner)
  if owner ~= nil then FactionState.assert(owner) end
  local self = {}
  setmetatable(self, CampTile)

  self.x = x
  self.y = y
  self.type = type
  self.owner = owner

  table.insert(CampTile.instances, self)

  return self
end


function CampTile:render_and_handle_ui()

  -- render and handle ui of tile
  -- only if te tile is selected ...

end



function CampTile.is(x) return getmetatable(x) == CampTile end
function CampTile.assert(x) assert(CampTile.is(x), "Expected CampTile. Got " .. type(x)) end
