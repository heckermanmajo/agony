
local spawn_cooldown = 0

function ai_management(dt)

  -- add units to spawn queue...
  -- todo: kinda buggy, needs more cooldowns one for each faction
  for _, bf in ipairs(FactionState.instances) do
    if not bf.is_player then
      if spawn_cooldown == 0 then
        local squad = GermanEmpire.inf_squads[1]
        table.insert(bf.spawn_queue, squad)
        spawn_cooldown = squad.time_til_deployment + 20
      end
    end
  end

end