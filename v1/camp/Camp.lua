--- @class Camp
--- @field cam Camera
--- @field mouse_click_consumed_this_frame boolean
--- @field currently_selected_tile CampTile
Camp = {
  current = nil,
  button_cooldown = 0,
  mouse_click_consumed_this_frame = false,
}
Camp.__index = Camp


-- region Camp.new()
--- Creates a new Camp instance
--- @return Camp
function Camp.new()

  local self = {}
  setmetatable(self, Camp)

  self.cam = Camera.new(0, 0, 1, 0)
  self.currently_selected_tile = nil

  -- load the campaign png that contains the map structure

  local image = love.image.newImageData("assets/map.png")

  function pixel_at_position_is_white(x, y)
    local r, g, b, a = image:getPixel(x, y)
    return r == 1 and g == 1 and b == 1
  end

  local germany = FactionState.new(GermanEmpire)
  local russia = FactionState.new(RussianEmpire)
  local france = FactionState.new(FrenchRepublic)
  germany.is_player = true
  germany.money = 200

  for x = 0, image:getWidth() - 1 do
    for y = 0, image:getHeight() - 1 do
      local r, g, b, a = image:getPixel(x, y)
      if r == 0 and g == 1 and b == 0 then
        CampTile.new(x, y, "gras", russia)
      elseif r == 1 and g == 0 and b == 0 then
        CampTile.new(x, y, "gras", germany)
      elseif r == 0 and g == 0 and b == 1 then
        CampTile.new(x, y, "gras", france)
      else
        CampTile.new(x, y, "water")
      end
    end
  end

  for _, ct in ipairs(CampTile.instances) do
    if ct.type == "water" then goto continue end
    local neighbours = ct:get_neighbours()
    local has_other_faction_on_border = false
    for _, n in ipairs(neighbours) do
      if n.owner ~= nil and n.owner ~= ct.owner then
        has_other_faction_on_border = true
        break
      end
    end
    if has_other_faction_on_border then
      ct.army = Army.new(math.floor(100 + math.random() * 30), ct)
    end
    ::continue::
  end

  Camp.current = self

  return self

end


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
      ct.army:draw()
    end

    local mouse_hovers = Utils.mouse_is_over(absolute_x, absolute_y, 128, 128, self.cam)

    if mouse_hovers then
      Atlas.all["map_tiles"]:draw_quad("water", absolute_x, absolute_y, "unchanged", 0, 2, 2)
    end
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
      print("Next Round")
      -- todo: next round calculations
    end
  end

  -- todo: next round on enter ...


  for _, ct in ipairs(CampTile.instances) do
    local absolute_x = ct.x * 128
    local absolute_y = ct.y * 128
    local mouse_hovers = Utils.mouse_is_over(absolute_x, absolute_y, 128, 128, self.cam)

    if mouse_hovers and love.mouse.isDown(1) and not Camp.mouse_click_consumed_this_frame then
      Camp.mouse_click_consumed_this_frame = true
      self.currently_selected_tile = ct
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

end


--region Camp:update()
--- Updates the Camp instance each frame
function Camp:update(dt)
  Camp.button_cooldown = Camp.button_cooldown - dt

  -- handle camera movement
  do
    local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
    local mouseX, mouseY = love.mouse.getPosition()
    self.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
    self.cam:apply_wasd_movement(dt)
  end

end