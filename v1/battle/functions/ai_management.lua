local cooldowns = {}


local function get_distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

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



function ai_management(dt)

  for _, army in ipairs(Battle.current.armies) do
    local bf = army.owner

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

        if cooldowns[bf].spawn <= 0 then
          local squad = GermanEmpire.inf_squads[1]
          table.insert(bf.spawn_queue, squad)
          bf.time_til_next_spawn = squad.time_til_deployment
          cooldowns[bf].spawn = squad.time_til_deployment + 20
        end

      end -- Spawn-Management


      -- manage chunk conquer targets
      do

        if cooldowns[bf].chunk_conquer_commands <= 0 then

          -- todo loop over all units and check what chunk to conquer
          -- todo: choose the next unconquered chunk
          -- todo: prefer the player owner chunks
          -- todo: if no player owned chunk is there, choose the closest to a player owned chunk

          for _, unit in ipairs(Unit.instances) do
            if unit.owner == bf then
              local my_current_chunk = Chunk.get(unit.x, unit.y)
              if unit.target == nil then
                local target_chunk = get_closest_player_owned_chunk(my_current_chunk)
                unit.chunk_conquer_target = target_chunk
              end
            end
          end

        end

      end -- manage chunk conquer targets


    end -- if not player

  end -- for armies

end -- ai_management