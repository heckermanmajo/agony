--- @class Culture A culture is a collection of settings and unit types.
---
local Culture = {}
Culture.__index = Culture

function Culture.new()

end

function Culture.is(x) return getmetatable(x) == Culture end
function Culture.assert(x) assert(Culture.is(x), "Expected Culture. Got " .. type(x)) end


return Culture