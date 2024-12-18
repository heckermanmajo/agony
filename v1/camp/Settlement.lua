local Settlement = {}

function Settlement.is(x) return getmetatable(x) == Settlement end
function Settlement.assert(x) assert(Settlement.is(x), "Expected Settlement. Got " .. type(x)) end


return Settlement