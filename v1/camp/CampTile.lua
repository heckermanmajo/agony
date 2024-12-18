local CampTile = {}



function CampTile.is(x) return getmetatable(x) == CampTile end
function CampTile.assert(x) assert(CampTile.is(x), "Expected CampTile. Got " .. type(x)) end

return CampTile