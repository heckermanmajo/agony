

--- @return Chunk[]
local function get_top_chunks()
  local chunks = {}
  for _, chunk in ipairs(Chunk.instances) do
    if chunk.y == 0 then
      table.insert(chunks, chunk)
    end
  end
  return chunks
end

--- @return Chunk[]
local function get_bottom_chunks()
  local chunks = {}
  for _, chunk in ipairs(Chunk.instances) do
    if chunk.y == Battle.WORLD_SIZE_IN_CHUNKS - 1 then
      table.insert(chunks, chunk)
    end
  end
  return chunks
end


--- Spawn a squad of units based on the given squad template and faction.
---
--- The units will spawn at the bottom of the map if the faction is the player,
--- else they will spawn at the top of the map.
---
--- @param squad SquadTemplate
--- @param faction Faction
function spawn_squad_of_units(squad, faction)

  local chunks
  if faction.is_player then chunks = get_bottom_chunks()
  else chunks = get_top_chunks() end
  assert(#chunks > 0, "No chunks found for spawning units.")

  local chunk = chunks[math.random(1, #chunks)]

  for _, unit_class in ipairs(squad.units) do
    UnitClass.assert(unit_class)
    local x = chunk.x * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)
    local y = chunk.y * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)
    Unit.new(x, y, unit_class, faction) -- unit registers itself...
  end

end