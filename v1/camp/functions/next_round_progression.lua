

function next_round_progression()


  for _, tile in ipairs(CampTile.instances) do

    -- collect the money and apply this to the factions
    if tile.owner then
      -- note: for now a tile gives 1 money per round
      tile.owner.money = tile.owner.money + 0.2
    end
    -- reset all armies
    if tile.army then tile.army.moved_this_turn = false end
  end

  for _, faction in ipairs(FactionState.instances) do
    faction.money = math.floor(faction.money)
  end

  -- todo: ai movement here



end