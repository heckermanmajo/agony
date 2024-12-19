--- @class DivisionTemplate Template for creating divisions.
--- @field units table<UnitClass, number>

local DivisionTemplate = {}


function DivisionTemplate.new()

end

function DivisionTemplate.is(x) return getmetatable(x) == DivisionTemplate end
function DivisionTemplate.assert(x) assert(DivisionTemplate.is(x), "Expected Unit. Got " .. type(x)) end


return DivisionTemplate