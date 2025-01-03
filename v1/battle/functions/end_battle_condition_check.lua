
--- @type number The cooldown for the end battle condition check; this is to prevent it from being called too often.
local cooldown = 0
--local only_start_after = 10

--- Set a factions defeated_in_this_current_battle to true if it has less than 10% of the chunks.
--- @param dt number
function end_battle_condition_check(dt)

  cooldown = cooldown - dt

  if cooldown <= 0 then

    if #Unit.instances == 0 then
      print("All units are defeated.")
      -- todo: handle this special case
      -- todo: only after 100 seconds or so enable this check
    end

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

    local defeated_factions = 0
    for faction, count in pairs(chunks_on_faction) do
      local percentage = count / #Chunk.instances
      if percentage < 0.1 then
        print("Faction " .. faction.faction.name .. " was defeated.")
        faction.defeated_in_this_current_battle = true
        defeated_factions = defeated_factions + 1
      end
    end

    -- check here if all factions are defeated except one
    if defeated_factions >= #FactionState.instances - 1 then
      print("All factions except one were defeated.")
      -- todo: end the battle here ...
    end

    cooldown = 1

  end

end