

local BattleFaction = {}

function BattleFaction.new(army, campaign_faction)

end

function BattleFaction.is(x) return x.__index == BattleFaction end
function BattleFaction.assert(x) assert(BattleFaction.is(x), "Expected BattleFaction, got " .. type(x)) end

return BattleFaction