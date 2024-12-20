

--- @class Camp
--- @field cam Camera
--- @field mouse_click_consumed_this_frame boolean
Camp = {
  current = nil,
}
Camp.__index = Camp




-- region Camp.new()
--- Creates a new Camp instance
--- @return Camp
function Camp.new()

  local self = {}
  setmetatable(self, Camp)

  self.cam = Camera.new(0, 0, 1, 0)
  self.mouse_click_consumed_this_frame = false
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

  Camp.current = self

  return self

end


-- region Camp:draw()
function Camp:draw()

  self.mouse_click_consumed_this_frame = false

  self.cam:attach()

  for _, ct in ipairs(CampTile.instances) do
    local absolute_x = ct.x * 128
    local absolute_y = ct.y * 128
    if ct.type == "gras" then
      love.graphics.setColor(0.2, 0.6, 0.2)
      -- draw rectangle lines around the tile
      love.graphics.rectangle("fill", absolute_x, absolute_y, 128, 128)
      love.graphics.setColor(unpack(ct.owner.faction.color))
      love.graphics.rectangle("line", absolute_x, absolute_y, 128, 128)
    else
      love.graphics.setColor(0, 0, 1)
      love.graphics.rectangle("fill", absolute_x, absolute_y, 128, 128)
    end

  end

  self.cam:detach()

end


--region Camp:update()
--- Updates the Camp instance each frame
function Camp:update(dt)

  -- handle camera movement
  do
    local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
    local mouseX, mouseY = love.mouse.getPosition()
    self.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
    self.cam:apply_wasd_movement(dt)
  end

end