
--- @type table<FactionState, table<string, number>> list of cooldowns for each factions ai management
local cooldowns = {}

----------------------------------------------------------------
--- Simple helper function to calculate the distance between two points
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
----------------------------------------------------------------
local function get_distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

----------------------------------------------------------------
--- AI Management: Get Closest Player Owned Chunk
--- Used to determine the next chunk a unit should attack.
--- @param my_current_chunk Chunk
--- @return Chunk
----------------------------------------------------------------
local function get_closest_player_owned_chunk(my_current_chunk)
  local player_owned_chunk = nil
  local distance = 999999999

  for _, chunk in ipairs(Chunk.instances) do
    if chunk.current_owner == Battle.current.player_army.owner then
      local d = get_distance(my_current_chunk.x, my_current_chunk.y, chunk.x, chunk.y)
      if d < distance then
        player_owned_chunk = chunk
        distance = d
      end
    end
  end

  return player_owned_chunk

end


----------------------------------------------------------------
--- AI Management: Spawning + Chunk Conquer Commands
--- @param dt number
----------------------------------------------------------------
function ai_management(dt)

  for _, army in ipairs(Battle.current.armies) do
    local bf = army.owner

    -- todo we should get those from the difficulty settings
    local NEXT_CHUNK_CONQUER_COMMANDS_COOLDOWN = 5
    local NEXT_SPAWN_COOLDOWN = 20

    if not bf.is_player then

      if not cooldowns[bf] then
        cooldowns[bf] = {
          spawn = 0,
          chunk_conquer_commands = 0,
        }
      end

      cooldowns[bf].spawn = cooldowns[bf].spawn - dt
      cooldowns[bf].chunk_conquer_commands = cooldowns[bf].chunk_conquer_commands - dt

      -- Spawn-Management: add units to spawn queue
      do

        local function spawn_squad(_army, squad)
          Army.assert(_army)
          -- todo: type check for squad
          local costs = squad.costs
          local faction_has_enough_command_points = _army.command_points >= costs
          if faction_has_enough_command_points then
            _army.command_points = _army.command_points - costs
            table.insert(_army.owner.spawn_queue, squad)
            return true
          end
          return false
        end

        if cooldowns[bf].spawn <= 0 then
          local squad = GermanEmpire.inf_squads[1]
          spawn_squad(army, squad)
          bf.time_til_next_spawn = squad.time_til_deployment
          cooldowns[bf].spawn = squad.time_til_deployment + NEXT_SPAWN_COOLDOWN
        end

      end -- Spawn-Management


      -- manage chunk conquer targets
      do

        if cooldowns[bf].chunk_conquer_commands <= 0 then

          -- we just set the next chunk to conquer for all units of the ai
          -- so ai units will try to go to the enemy chunk that is closest to them
          for _, unit in ipairs(Unit.instances) do
            if unit.owner == bf then
              local my_current_chunk = Chunk.get(unit.x, unit.y)
              if unit.target == nil then
                local target_chunk = get_closest_player_owned_chunk(my_current_chunk)
                unit.chunk_conquer_target = target_chunk
              end
            end
          end

          cooldowns[bf].chunk_conquer_commands = NEXT_CHUNK_CONQUER_COMMANDS_COOLDOWN

        end

      end -- manage chunk conquer targets


    end -- if not player

  end -- for armies

end -- ai_management