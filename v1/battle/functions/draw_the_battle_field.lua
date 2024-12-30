function draw_the_battle_field()

  love.graphics.setColor(1, 1, 1)

  Battle.current.ui.cam:attach()


  -- for each sector
  for _, sector in ipairs(Sector.instances) do

    -- ignore the sector if it is not in the view of the camera
    if (
      not Battle.current.ui.cam:rectInView(
        sector.x * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        sector.y * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
        Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS)
    ) then
      goto continue_sector_loop
    end

    -- for each chunk in the sector
    for _, chunk in ipairs(sector.chunks) do

      -- ignore the chunk if it is not in the view of the camera
      if (
        not Battle.current.ui.cam:rectInView(
          chunk.x * Battle.CHUNK_SIZE_IN_PIXELS,
          chunk.y * Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS)
      ) then
        goto continue_chunk_loop
      end

      -- draw the tile-textures if we are not in minimap-mode
      if not Battle.current.ui.cam.minimap then

        -- draw the tile-textures
        for _, tile in ipairs(chunk.tiles) do
          local tile_x_pixel = tile.x * Battle.TILE_SIZE_IN_PIXELS
          local tile_y_pixel = tile.y * Battle.TILE_SIZE_IN_PIXELS
          Atlas.all["map_tiles"]:draw_quad("gras", tile_x_pixel, tile_y_pixel)
        end

      end -- end if not Battle.current.ui.cam.min

      -- draw an overlay over the chunk in the color of the owner-faction
      if chunk.current_owner ~= nil then
        local color = chunk.current_owner.faction.color
        local alpha = 0.1
        if Battle.current.ui.cam.minimap then alpha = 0.6 end
        love.graphics.setColor(color[1], color[2], color[3], alpha)
        love.graphics.rectangle("fill",
          chunk.x * Battle.CHUNK_SIZE_IN_PIXELS,
          chunk.y * Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS,
          Battle.CHUNK_SIZE_IN_PIXELS
        )
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

    end -- end chunk-loop

    -- draw a rect around te sector
    love.graphics.setColor(0, 1, 1)

    love.graphics.rectangle("line",
      sector.x * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
      sector.y * Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
      Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS,
      Battle.SECTOR_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS
    )

    :: continue_sector_loop ::

  end -- end sector-loop


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

      -- draw the units of the chunk
      for _, unit in ipairs(chunk.units) do unit:draw() end
      for _, po in ipairs(chunk.passive_objects) do po:draw() end

      :: continue_chunk_loop ::

    end -- end chunk-loop

    :: continue_sector_loop ::

  end -- end sector-loop


  for _, unit in ipairs(Battle.current.ui.currently_selected_units) do
    -- draw circle around the unit
    love.graphics.setColor(1, 1, 1)
    local radius = unit.cls.collision_radius + 4
    love.graphics.circle("line", unit.x, unit.y, radius)
  end

  Projectile.draw_all()

  Battle.current.ui.cam:detach()

  --Battle.current.ui.cam:print_camera_info_on_screen(10, 10)
  love.graphics.print("Selected: " .. #Battle.current.ui.currently_selected_units, 10, 50)
  love.graphics.print("Units: " .. #Unit.instances, 10, 70)
  -- draw the fps on the screen
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 90)

end -- end draw_the_battle_field