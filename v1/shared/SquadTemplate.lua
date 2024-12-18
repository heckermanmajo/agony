local SquadTemplate = {}


function SquadTemplate.new()

end

function SquadTemplate.is(x) return getmetatable(x) == SquadTemplate end
function SquadTemplate.assert(x) assert(SquadTemplate.is(x), "Expected Unit. Got " .. type(x)) end


return SquadTemplate