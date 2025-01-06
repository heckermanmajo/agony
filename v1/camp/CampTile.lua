--- @class CampTile
--- @field x number
--- @field y number
--- @field type string
--- @field owner FactionState
--- @field army Army
CampTile = {
  --- @type CampTile[]
  instances = {},
}

CampTile.__index = CampTile

----------------------------------------
--- @param x number
--- @param y number
--- @param type string
--- @param owner FactionState
--- @return CampTile
----------------------------------------
function CampTile.new(x, y, type, owner)
  if owner ~= nil then FactionState.assert(owner) end
  assert(type == "gras" or type == "water")
  --assert(x >= 0 and y >= 0)
  assert(not CampTile.instances[x] or not CampTile.instances[x][y], "Tile already exists at " .. x .. ", " .. y)

  local self = {}
  setmetatable(self, CampTile)

  self.x = x
  self.y = y
  self.type = type
  self.owner = owner
  -- DONT INTRODUCE TO MUCH COMPLEXITY BEFORE THE BASIC GAMEPLAY EVEN WORKS
  --self.settlement = false
  --self.factory = false
  --self.logistics_camp = false
  self.army = nil

  table.insert(CampTile.instances, self)

  return self
end

local cooldown = 0

function CampTile.update_cool_down(dt)
  cooldown = cooldown - dt
end

function CampTile:render_and_handle_ui(x)

  -- render and handle ui of tile
  -- only if te tile is selected ...

  -- draw a rect at the right left side of the screen in gray with some transparency
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", x, 0, 350, love.graphics.getHeight())

  local owner = "none"
  if self.owner then owner = self.owner.faction.name end

  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Tile: " .. self.x .. ", " .. self.y, x + 10, 10)
  love.graphics.print("Type: " .. self.type, x + 10, 30)
  love.graphics.print("Owner: " .. owner, x + 10, 50)
  local is_player = "no"
  if self.owner and self.owner.is_player then is_player = "yes" end
  love.graphics.print("Is player: " .. is_player, x + 10, 70)

  local army = "none"
  if self.army then army = "yes" end
  love.graphics.print("Has army: " .. army, x + 10, 90)
  if self.army then
    love.graphics.print("Command points: " .. self.army.command_points, x + 10, 110)
  end

  if self.owner == FactionState.get_current_player_faction() then
    if self.army then
      -- buy command points for this army-button
      local costs = 10
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("Buy 100 command points for " .. costs .. " money", x + 10, 150)
      if Utils.mouse_is_over(x + 10, 150, 300, 20) and love.mouse.isDown(1) and cooldown <= 0 then
        Camp.mouse_click_consumed_this_frame = true
        if FactionState.get_current_player_faction().money >= costs then
          FactionState.get_current_player_faction().money = FactionState.get_current_player_faction().money - costs
          self.army.command_points = self.army.command_points + 100
          cooldown = 0.5
        end
      end
    else
      -- buy army-button
      local costs = 10
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("Buy army (100) for " .. costs .. " money", x + 10, 150)
      if Utils.mouse_is_over(x + 10, 150, 300, 20) and love.mouse.isDown(1) and cooldown <= 0  then
        Camp.mouse_click_consumed_this_frame = true
        if FactionState.get_current_player_faction().money >= costs then
          FactionState.get_current_player_faction().money = FactionState.get_current_player_faction().money - costs
          self.army = Army.new(100, self)
          cooldown = 0.5
        end
      end
    end

  end

end

--- @return CampTile[]
function CampTile:get_neighbours()
  local neighbours = {}
  for _, ct in ipairs(CampTile.instances) do
    if (ct.x == self.x and ct.y == self.y - 1) or
      (ct.x == self.x and ct.y == self.y + 1) or
      (ct.x == self.x - 1 and ct.y == self.y) or
      (ct.x == self.x + 1 and ct.y == self.y) then
      table.insert(neighbours, ct)
    end
  end
  return neighbours
end

function CampTile:get_top_neighbour()
  for _, ct in ipairs(CampTile.instances) do
    if ct.x == self.x and ct.y == self.y - 1 then
      return ct
    end
  end
  return nil
end

function CampTile:get_bottom_neighbour()
  for _, ct in ipairs(CampTile.instances) do
    if ct.x == self.x and ct.y == self.y + 1 then
      return ct
    end
  end
  return nil
end

function CampTile:get_left_neighbour()
  for _, ct in ipairs(CampTile.instances) do
    if ct.x == self.x - 1 and ct.y == self.y then
      return ct
    end
  end
  return nil
end

function CampTile:get_right_neighbour()
  for _, ct in ipairs(CampTile.instances) do
    if ct.x == self.x + 1 and ct.y == self.y then
      return ct
    end
  end
  return nil
end

function CampTile.is(x) return getmetatable(x) == CampTile end
function CampTile.assert(x) assert(CampTile.is(x), "Expected CampTile. Got " .. type(x)) end
