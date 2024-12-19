
--- @class BattleFaction
--- @field enemies BattleFaction[]
--- @field spawn_sector Sector
--- @field culture Culture
--- @field divisions_in_reserve Division[]
--- @field divisions_in_battle Division[]
BattleFaction = {}

function BattleFaction.new(army, campaign_faction)

end

function BattleFaction.is(x) return x.__index == BattleFaction end
function BattleFaction.assert(x) assert(BattleFaction.is(x), "Expected BattleFaction, got " .. type(x)) end