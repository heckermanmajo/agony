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

  -- ai movements
  do

    for _, faction in ipairs(FactionState.instances) do

      -- todo: those values can be derived from the faction
      --       this way we can make them subject to science OR faction boni
      local create_army_price = 10
      local initial_army_size = 100
      local reinforcement_price = 10
      local reinforcement_capacity = 100
      local total_reinforcements = 3 -- todo: apply
      local total_attacks = 3 -- todo: make subject of difficulty

      if not faction.is_player then

        -- we shuffle the tiles to make the ai movements less predictable
        -- also we dont want an ai to reinforce always the same tile first
        -- since the money is limited
        local tiles_in_random_order = {}

        -- create a new table with all tiles in random order
        do
          local function shuffle (arr)
            for i = 1, #arr - 1 do
              local j = math.random(i, #arr)
              arr[i], arr[j] = arr[j], arr[i]
            end
          end

          for _, tile in ipairs(CampTile.instances) do
            table.insert(tiles_in_random_order, tile)
          end
          shuffle(tiles_in_random_order)
        end

        -- create armies if there is a exposed tile
        for _, tile in ipairs(tiles_in_random_order) do
          if tile.owner == faction and tile.army == nil then
            local neighbours = tile:get_neighbours()
            local has_other_faction_on_border = false
            for _, n in ipairs(neighbours) do
              if n.owner ~= nil and n.owner ~= faction then
                has_other_faction_on_border = true
                break
              end
            end
            if has_other_faction_on_border then
              if faction.money >= create_army_price then
                faction.money = faction.money - create_army_price
                tile.army = Army.new(initial_army_size, tile)
              end
            end
          end
        end -- create armies on exposed tiles

        -- reinforce the tiles that are exposed to enemy armies if possible
        for _, tile in ipairs(tiles_in_random_order) do
          if tile.owner == faction and tile.army then
            local neighbours = tile:get_neighbours()
            local has_other_faction_on_border = false
            for _, n in ipairs(neighbours) do
              if n.owner ~= nil and n.owner ~= faction then
                has_other_faction_on_border = true
                break
              end
            end
            if has_other_faction_on_border then
              local command_points_of_biggest_neighbour = 0
              for _, n in ipairs(neighbours) do
                if n.army and n.owner ~= faction then
                  if n.army.command_points > command_points_of_biggest_neighbour then
                    command_points_of_biggest_neighbour = n.army.command_points
                  end
                end
              end
              if command_points_of_biggest_neighbour > tile.army.command_points then
                -- add one reinforcement
                if faction.money >= reinforcement_price then
                  faction.money = faction.money - reinforcement_price
                  tile.army.command_points = tile.army.command_points + reinforcement_capacity
                end
              end
            end
          end
        end -- reinforce armies on tiles

        -- Attack n times (based on difficulty); attack a less defended tile
        for _, tile in ipairs(tiles_in_random_order) do
          if tile.owner == faction and tile.army then
            local neighbours = tile:get_neighbours()
            local has_other_faction_on_border = false
            for _, n in ipairs(neighbours) do
              if n.owner ~= nil and n.owner ~= faction then
                has_other_faction_on_border = true
                break
              end
            end

            if has_other_faction_on_border then
              local weakest_neighbour = nil
              local command_points_of_weakest_neighbour = 1000000
              for _, n in ipairs(neighbours) do
                if n.army and n.owner ~= faction then
                  if n.army.command_points < command_points_of_weakest_neighbour then
                    weakest_neighbour = n
                    command_points_of_weakest_neighbour = n.army.command_points
                  end
                end
              end

              -- this can be the case when the neighbour field has not army...
              if weakest_neighbour == nil then
                goto continue
              end

              -- attack the weakest neighbour if possible
              local makes_sense = weakest_neighbour.army.command_points < tile.army.command_points
              if makes_sense and total_attacks > 0 then
                local movement = {
                  from = tile,
                  to = weakest_neighbour,
                  from_army = tile.army,
                  to_army = weakest_neighbour.army,
                }
                table.insert(Camp.current.ai_army_movement_queue, movement)

                total_attacks = total_attacks - 1
              end

            end -- if has other faction on border

          end -- if tile.owner == faction

          :: continue ::

        end -- attack other tiles

        -- todo: some useful movment...
        --for _, tile in ipairs(tiles_in_random_order) do
        --  if tile.owner == faction and tile.army then
        --    local neighbours = tile:get_neighbours()
        --  end
       -- end


      end -- if not player
    end -- for each faction

  end  -- ai movements

end