
--- @class FactionState all data of a faction that are changed over time
--- @field done_technologies table<string> this way we can save and restore the state of the faction
--- @field money number
--- @field enemy_factions FactionState[]
--- @field spawn_queue table<SquadTemplate>
--- @field time_til_next_spawn number
FactionState = {
  --- @type FactionState[]
  instances = {},
}
FactionState.__index = FactionState

--- @param faction Faction
function FactionState.new(faction)
  local self = {}
  setmetatable(self, FactionState)
  self.done_technologies = {}
  self.money = 123
  self.enemy_factions = {}
  self.faction = faction
  self.is_player = false
  self.spawn_queue = {}
  self.time_til_next_spawn = 0
  table.insert(FactionState.instances, self)
  return self
end


--- @return FactionState
function FactionState.get_current_player_faction()
  for _, faction_state in ipairs(FactionState.instances) do
    if faction_state.is_player then
      return faction_state
    end
  end
  assert(false, "No player faction found")
end


function FactionState.is(x) return getmetatable(x) == FactionState end
function FactionState.assert(x) assert(FactionState.is(x), "Expected CampaignFaction. Got " .. type(x)) end
