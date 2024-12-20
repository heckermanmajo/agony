


function draw_the_battle_field()

  Battle.current.ui.cam:attach()

  for _, sector in ipairs(Sector.instances) do

    if (
      not Battle.current.ui.cam:rectInView(
        sector.x * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        sector.y * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS)
    ) then
      goto continue_sector_loop
    end

    for _, chunk in ipairs(sector.chunks) do

      if (
        not Battle.current.ui.cam:rectInView(
          chunk.x * Battle.CHUNK_SIZE_IN_PIXELS,
          chunk.y * Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS)
      ) then
        goto continue_chunk_loop
      end

      if not Battle.current.ui.cam.minimap then

        for _, tile in ipairs(chunk.tiles) do
          -- draw a rect around te sector
          love.graphics.setColor(1, 1, 0)

          love.graphics.rectangle("line",
           tile.x * Battle.TILE_SIZE_IN_PIXELS,
            tile.y * Battle.TILE_SIZE_IN_PIXELS,
            Battle.TILE_SIZE_IN_PIXELS,
            Battle.TILE_SIZE_IN_PIXELS
           )

          -- draw the tile-texture
          local tile_x_pixel = tile.x * Battle.TILE_SIZE_IN_PIXELS
          local tile_y_pixel = tile.y * Battle.TILE_SIZE_IN_PIXELS
          Atlas.all["map_tiles"]:draw_quad("gras", tile_x_pixel, tile_y_pixel)

        end

      end

      -- draw a rect around te sector
      love.graphics.setColor(1, 0, 1)

      love.graphics.rectangle("line",
        chunk.x * Battle.CHUNK_SIZE_IN_PIXELS,
       chunk.y * Battle.CHUNK_SIZE_IN_PIXELS,
        Battle.CHUNK_SIZE_IN_PIXELS,
        Battle.CHUNK_SIZE_IN_PIXELS
      )

      :: continue_chunk_loop ::

    end

    -- draw a rect around te sector
    love.graphics.setColor(0, 1, 1)

    love.graphics.rectangle("line",
     sector.x * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
     sector.y * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
     Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
      Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS
   )

    :: continue_sector_loop ::

  end

  Battle.current.ui.cam:detach()

  Battle.current.ui.cam:print_camera_info_on_screen(10,10)

  -- draw the fps on the screen
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 90)

end