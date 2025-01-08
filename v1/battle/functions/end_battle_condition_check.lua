--- @type number The cooldown for the end battle condition check; this is to prevent it from being called too often.
local cooldown = 0
----------------------------------------------------------------------------------
--- Set a factions defeated_in_this_current_battle to true if it has less than 10% of the chunks.
--- @param dt number
----------------------------------------------------------------------------------
function end_battle_condition_check(dt)

  cooldown = cooldown - dt

  if cooldown <= 0 then


    -- map all chunks on factions, so we know how many chunks each faction has
    local chunks_on_faction = {}

    for _, c in ipairs(Chunk.instances) do
      if c.current_owner ~= nil then
        if not chunks_on_faction[c.current_owner] then
          chunks_on_faction[c.current_owner] = 1
        else
          chunks_on_faction[c.current_owner] = chunks_on_faction[c.current_owner] + 1
        end
      end
    end

    -- check if a faction has less than 10% of the chunks
    local defeated_factions_number = 0
    local defeated_factions = {}
    for faction, count in pairs(chunks_on_faction) do
      local percentage = count / #Chunk.instances
      if percentage < 0.1 then
        print("INFO: Faction " .. faction.faction.name .. " was defeated.")
        faction.defeated_in_this_current_battle = true
        defeated_factions_number = defeated_factions_number + 1
        defeated_factions[faction] = true
      end
    end

    -- check here if all factions are defeated except one
    local factions_in_battle = #Battle.current.armies
    if defeated_factions_number >= factions_in_battle - 1 then
      print("INFO: All factions except one were defeated.")
      -- set the command points of all defeated factions to 0
      for _, army in ipairs(Battle.current.armies) do
        if defeated_factions[army.owner] then
          army.command_points = 0
          army:delete_me_from_campaign()
        end
      end

      TOGGLE_GAME_MODE() -- back to campaign mode

    end

        -- special check if no units are left and no command points are left
    if #Unit.instances == 0 then
      local there_are_command_points_left = false
      for _, army in ipairs(Battle.current.armies) do
        if army.command_points > 0 then
          there_are_command_points_left = true
          break
        end
      end
      if not there_are_command_points_left then
        print("INFO: All units are dead and no command points left.")
        for _, army in ipairs(Battle.current.armies) do
          if defeated_factions[army.owner] then
            army.command_points = 0
            army:delete_me_from_campaign()
          end
        end
        TOGGLE_GAME_MODE() -- back to campaign mode
      end
    end

    cooldown = math.random(4, 8)

  end

end