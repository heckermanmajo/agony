----------------------------------------
--- Called when a battle is created.
--- @see Battle.new
----------------------------------------
function initialize_the_battle_field()


  -- initialize the sectors, chunks, tiles
  do

    for sector_x = 0, Battle.WORLD_SIZE_IN_SECTORS-1 do
      for sector_y = 0, Battle.WORLD_SIZE_IN_SECTORS-1 do

        local sector = Sector.new(sector_x, sector_y)

        for chunk_x = 0, Battle.SECTOR_SIZE_IN_CHUNKS-1 do
          for chunk_y = 0, Battle.SECTOR_SIZE_IN_CHUNKS-1 do

            local absolute_chunk_index_x = sector_x * Battle.SECTOR_SIZE_IN_CHUNKS + chunk_x
            local absolute_chunk_index_y = sector_y * Battle.SECTOR_SIZE_IN_CHUNKS + chunk_y
            local chunk = Chunk.new(absolute_chunk_index_x, absolute_chunk_index_y)
            table.insert(sector.chunks, chunk)

            for tile_x = 0, Battle.CHUNK_SIZE_IN_TILES-1 do
              for tile_y = 0, Battle.CHUNK_SIZE_IN_TILES-1 do

                local absolute_tile_index_x = absolute_chunk_index_x * Battle.CHUNK_SIZE_IN_TILES + tile_x
                local absolute_tile_index_y = absolute_chunk_index_y * Battle.CHUNK_SIZE_IN_TILES + tile_y
                local tile = Tile.new(absolute_tile_index_x, absolute_tile_index_y)
                table.insert(chunk.tiles, tile)

              end
            end -- end tile-loop

          end
        end -- end chunk-loop

      end
    end -- end sector-loop

  end -- end initialize the sectors, chunks, tiles


  -- make the bottom chunks be owned by the player
  -- make the top chunks be owned by the enemy

  local player_army = Battle.current.player_army
  local enemy_army = nil
  for _, army in ipairs(Battle.current.armies) do
    if not army.owner.is_player then
      enemy_army = army
    end
  end

  for _, chunk in ipairs(Chunk.instances) do
    if chunk.y == 0 then
      chunk.current_owner = enemy_army.owner
    elseif chunk.y == Battle.WORLD_SIZE_IN_CHUNKS - 1 then
      chunk.current_owner = player_army.owner
    end
  end



  -- todo: create objects on the map


end -- end initialize_the_battle_field
