----------------------------------------
--- @class Camp
--- @field cam Camera
--- @field mouse_click_consumed_this_frame boolean
--- @field currently_selected_tile CampTile
--- @field ai_army_movement_queue table<{from:CampTile, to:CampTile, from_army: Army, to_army: Army|nil}> the armies needed to be added, so we can identify an invalid move
--- since all ais create their movements at once: so ai movement can invalidate other later planned ai movements
--- @field working_on_ai_moves boolean if this is true, we are currently processing ai movements and disable the
--- player from moving his armies and interacting with ui
-------------------------------------------
Camp = {
  --- @type Camp
  current = nil,
  button_cooldown = 0,
  mouse_click_consumed_this_frame = false,
  current_debug_view = 0,
  key_cooldown = 0,
}
Camp.__index = Camp


----------------------------------------
-- region Camp.new()
--- Creates a new Camp instance
--- @return Camp
----------------------------------------
function Camp.new()

  local self = {}
  setmetatable(self, Camp)

  self.cam = Camera.new(0, 0, 1, 0)
  self.currently_selected_tile = nil
  self.ai_army_movement_queue = {}
  self.working_on_ai_moves = false

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
    :: continue ::
  end

  Camp.current = self

  return self

end -- end of function Camp.new()

local next_ai_movement_cooldown = 0

----------------------------------------
--region Camp:update()
--- Updates the Camp instance each frame
----------------------------------------
function Camp:update(dt)
  Camp.button_cooldown = Camp.button_cooldown - dt
  Camp.key_cooldown = Camp.key_cooldown - dt
  next_ai_movement_cooldown = next_ai_movement_cooldown - dt

  CampTile.update_cool_down(dt)

  self.working_on_ai_moves = false

  -- handle working on ai moves
  do
    if #self.ai_army_movement_queue > 0 then

      self.working_on_ai_moves = true

      if next_ai_movement_cooldown < 0 then

        local movement = self.ai_army_movement_queue[1]
        table.remove(self.ai_army_movement_queue, 1)

        Army.assert(movement.from_army)
        CampTile.assert(movement.from)
        CampTile.assert(movement.to)
        -- the army where we move to can be nil
        if movement.to_army then Army.assert(movement.to_army) end

        local still_valid =
          movement.from.army == movement.from_army and
          movement.to.army == movement.to_army

        if still_valid then
          movement.from_army:move(movement.to)
          next_ai_movement_cooldown = 1
        else
          --ignore the movement since the assumed state has changed
        end

      end

    end

  end

  -- handle camera movement
  do
    local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
    local mouseX, mouseY = love.mouse.getPosition()
    self.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
    self.cam:apply_wasd_movement(dt)
  end

  -- if f1 button set debug view to 1
  if love.keyboard.isDown("f1") and Camp.key_cooldown < 0 then
    if Camp.current_debug_view == 1 then Camp.current_debug_view = 0
    else Camp.current_debug_view = 1 end
    Camp.key_cooldown = 0.5
  end

  -- use the arrow keys to move the army
  if self.currently_selected_tile and not self.working_on_ai_moves then

    if self.currently_selected_tile.army then

      if self.currently_selected_tile.owner == FactionState.get_current_player_faction() then

        if Camp.key_cooldown < 0 and not self.currently_selected_tile.army.moved_this_turn then

          if love.keyboard.isDown("up") then
            self.currently_selected_tile.army:move("up")
            Camp.key_cooldown = 0.2
          end

          if love.keyboard.isDown("down") then
            self.currently_selected_tile.army:move("down")
            Camp.key_cooldown = 0.2
          end

          if love.keyboard.isDown("left") then
            self.currently_selected_tile.army:move("left")
            Camp.key_cooldown = 0.2
          end

          if love.keyboard.isDown("right") then
            self.currently_selected_tile.army:move("right")
            Camp.key_cooldown = 0.2
          end

        end -- end of if Camp.key_cooldown < 0 and not self.currently_selected_tile.army.moved_this_turn then

      end -- end of if self.currently_selected_tile.owner == FactionState.get_current_player_faction() then

    end -- end of if self.currently_selected_tile.army then

  end -- end of if self.currently_selected_tile then

end -- end of function Camp:update()