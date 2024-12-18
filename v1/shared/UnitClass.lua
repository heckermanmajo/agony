
local UnitClass = {}
UnitClass.__index = UnitClass

function UnitClass.new()

end

function UnitClass:add_color_variation_to_atlas(color)

end

function UnitClass:draw(unit, color)

end

function UnitClass.is(x) return getmetatable(x) == UnitClass end
function UnitClass.assert(x) assert(UnitClass.is(x), "Expected UnitClass. Got " .. type(x)) end

return UnitClass