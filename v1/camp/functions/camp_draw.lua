-- region Camp:draw()
function Camp:draw()

  if Camp.button_cooldown < 0 then
    Camp.mouse_click_consumed_this_frame = false
  end

  self.cam:attach()

  for _, ct in ipairs(CampTile.instances) do

    local absolute_x = ct.x * 128
    local absolute_y = ct.y * 128

    if ct.type == "gras" then
      -- draw rectangle lines around the tile
      love.graphics.rectangle("fill", absolute_x, absolute_y, 128, 128)
      love.graphics.setColor(1, 1, 1)
      Atlas.all["map_tiles"]:draw_quad("gras", absolute_x, absolute_y, "unchanged", 0, 2, 2)
      love.graphics.setColor(unpack(ct.owner.faction.color))
      love.graphics.rectangle("line", absolute_x, absolute_y, 128, 128)
      love.graphics.rectangle("line", absolute_x - 1, absolute_y - 1, 128 + 2, 128 + 2)
      love.graphics.rectangle("line", absolute_x - 2, absolute_y - 2, 128 + 4, 128 + 4)
    else
      love.graphics.setColor(1, 1, 1)
      Atlas.all["map_tiles"]:draw_quad("water", absolute_x, absolute_y, "unchanged", 0, 2, 2)
    end

    if ct.army then
      Army.assert(ct.army)
      ct.army:draw()
    end

    local mouse_hovers = Utils.mouse_is_over(absolute_x, absolute_y, 128, 128, self.cam)

    if mouse_hovers then
      love.graphics.setColor(1, 1, 1, 0.1)
      love.graphics.rectangle("fill", absolute_x, absolute_y, 128, 128)
      love.graphics.setColor(1, 1, 1)
    end
  end


  -- draw a green overlay or a red overlay over the currently_selected_tile
  -- based on if the tile is owned by the player or not
  if self.currently_selected_tile then

    if self.currently_selected_tile.owner == FactionState.get_current_player_faction() then
      love.graphics.setColor(0, 1, 0, 0.1)
    elseif self.currently_selected_tile.owner then
      love.graphics.setColor(1, 0, 0, 0.1)
    else
      love.graphics.setColor(1, 1, 0, 0.1)
    end
    love.graphics.rectangle("fill", self.currently_selected_tile.x * 128, self.currently_selected_tile.y * 128, 128, 128)
  end

  self.cam:detach()

  -- if right click: deselect tile
  if love.mouse.isDown(2) then self.currently_selected_tile = nil end


  -- draw the ui

  if self.currently_selected_tile then
    local x = love.graphics.getWidth() - 360
    self.currently_selected_tile:render_and_handle_ui(x)
  end

  -- draw header bar
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() - 360, 50)

  -- start with the next round button
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Next Round", 10, 10)
  -- draw a red rectangle around the next round button if the mouse is over it
  if Utils.mouse_is_over(10, 10, 100, 30) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", 10, 10, 100, 30)
    if love.mouse.isDown(1) and Camp.button_cooldown < 0 and not Camp.mouse_click_consumed_this_frame then
      Camp.mouse_click_consumed_this_frame = true
      Camp.button_cooldown = 0.5
      next_round_progression()
    end
  end

  -- todo: next round on enter ...

  local mouse_is_over_header_bar = Utils.mouse_is_over(0, 0, love.graphics.getWidth() - 360, 50)
  local mouse_is_over_right_side = Utils.mouse_is_over(love.graphics.getWidth() - 360, 0, 360, love.graphics.getHeight())

  local mouse_is_over_ui = false
  if self.currently_selected_tile == nil then
    mouse_is_over_ui = mouse_is_over_header_bar
  else
    mouse_is_over_ui = mouse_is_over_header_bar or mouse_is_over_right_side
  end

  for _, ct in ipairs(CampTile.instances) do

    local absolute_x = ct.x * 128
    local absolute_y = ct.y * 128
    local mouse_hovers = Utils.mouse_is_over(absolute_x, absolute_y, 128, 128, self.cam)
    local valid_click = (
      mouse_hovers
        and love.mouse.isDown(1)
        and not Camp.mouse_click_consumed_this_frame
        and Camp.button_cooldown < 0
        and not mouse_is_over_ui
    )

    if valid_click then
      Camp.mouse_click_consumed_this_frame = true
      self.currently_selected_tile = ct
      --print(Utils.str_table(ct.army.campaign_tile))
      Camp.button_cooldown = 0.5
    end
  end

  love.graphics.setColor(1, 1, 1)
  -- then the currents-faction money
  local player_faction = FactionState.get_current_player_faction()
  love.graphics.print("Money: " .. player_faction.money, 200, 10)

  -- draw the fps counter
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 70)
  self.cam:print_camera_info_on_screen(10, 100)

  if Camp.current_debug_view == 1 then
    -- draw a transparent gray rectangle on the right side of the screen
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("fill", 0, 0, 200, love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Debug view 1", 10, 120)
    love.graphics.print("Number of CampTiles: " .. #CampTile.instances, 10, 140)
    love.graphics.print("Number of Armies: " .. #Army.instances, 10, 160)
    love.graphics.print("Number of FactionStates: " .. #FactionState.instances, 10, 180)

    -- number of player_faction tiles
    local player_faction = FactionState.get_current_player_faction()
    local player_faction_tiles = 0
    for _, ct in ipairs(CampTile.instances) do
      if ct.owner == player_faction then player_faction_tiles = player_faction_tiles + 1 end
    end
    love.graphics.print("Number of player faction tiles: " .. player_faction_tiles, 10, 200)
  end

end