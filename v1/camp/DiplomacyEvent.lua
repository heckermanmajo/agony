local DiplomacyEvent = {}


function DiplomacyEvent.is(x) return getmetatable(x) == DiplomacyEvent end
function DiplomacyEvent.assert(x) assert(DiplomacyEvent.is(x), "Expected DiplomacyEvent. Got " .. type(x)) end

return DiplomacyEvent