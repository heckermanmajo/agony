-----------------------------------------------------------------------
--- Helper function to get all chunks at the top of the map.
--- @return Chunk[]
-----------------------------------------------------------------------
local function get_top_chunks()
  local chunks = {}
  for _, chunk in ipairs(Chunk.instances) do
    if chunk.y == 0 then
      table.insert(chunks, chunk)
    end
  end
  return chunks
end

-----------------------------------------------------------------------
--- Helper function to get all chunks at the bottom of the map.
--- @return Chunk[]
-----------------------------------------------------------------------
local function get_bottom_chunks()
  local chunks = {}
  for _, chunk in ipairs(Chunk.instances) do
    if chunk.y == Battle.WORLD_SIZE_IN_CHUNKS - 1 then
      table.insert(chunks, chunk)
    end
  end
  return chunks
end


-----------------------------------------------------------------------
--- Spawn a squad of units based on the given squad template and faction.
---
--- The units will spawn at the bottom of the map if the faction is the player,
--- else they will spawn at the top of the map.
---
--- @param squad SquadTemplate
--- @param faction Faction
-----------------------------------------------------------------------
local function spawn_squad_of_units(squad, faction)

  local chunks
  if faction.is_player then chunks = get_bottom_chunks()
  else chunks = get_top_chunks() end
  assert(#chunks > 0, "No chunks found for spawning units.")

  local chunk = chunks[math.random(1, #chunks)]

  for unit_class, number in pairs(squad.units) do
    for _ = 1, number do
      UnitClass.assert(unit_class)
      local x = chunk.x * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)
      local y = chunk.y * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)
      Unit.new(x, y, unit_class, faction) -- unit registers itself...
    end
  end

end


-----------------------------------------------------------------------
--- Spawn based on the spawn queue of each faction.
---
--- This function is called every frame and checks if it is time to spawn
--- a squad of units for each faction.
---
--- @param dt number the time since the last frame in seconds
-----------------------------------------------------------------------
function spawn_management(dt)

  -- all factions can spawn
  for _, bf in ipairs(FactionState.instances) do

    local we_got_stuff_in_the_queue = #bf.spawn_queue > 0
    if we_got_stuff_in_the_queue then

      bf.time_til_next_spawn = bf.time_til_next_spawn - dt -- progress the time

      local is_time_to_spawn = bf.time_til_next_spawn <= 0
      if is_time_to_spawn then

        local squad = table.remove(bf.spawn_queue, 1)
        -- SquadTemplate.assert(squad) -  todo: check this type ...
        spawn_squad_of_units(squad, bf)

        if #bf.spawn_queue > 0 then
          bf.time_til_next_spawn = bf.spawn_queue[1].time_til_deployment
        end

      end -- is_time_to_spawn

    end -- we_got_stuff_in_the_queue

  end -- for factions

end