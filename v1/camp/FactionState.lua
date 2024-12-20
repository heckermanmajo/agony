
--- @class FactionState all data of a faction that are changed over time
--- @field done_technologies table<string> this way we can save and restore the state of the faction
--- @field resource_order number
--- @field resource_manpower number
--- @field resource_resources number
--- @field entropy number
--- @field enemy_factions FactionState[]
--- @field spawn_sector Sector reset ech time a battle starts
FactionState = {

}
FactionState.__index = FactionState

--- @param faction Faction
function FactionState.new(faction)
  local self = {}
  setmetatable(self, FactionState)
  self.done_technologies = {}
  self.resource_order = 0
  self.resource_manpower = 0
  self.resource_resources = 0
  self.entropy = 0
  self.enemy_factions = {}
  self.spawn_sector = nil
  self.faction = faction
  return self
end


function FactionState.is(x) return getmetatable(x) == FactionState end
function FactionState.assert(x) assert(FactionState.is(x), "Expected CampaignFaction. Got " .. type(x)) end
