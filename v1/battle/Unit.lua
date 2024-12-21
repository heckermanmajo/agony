--- @class Unit
--- @field target Unit
--- @field walk_queue table<{x: number, y: number}>
--- @field owner FactionState
--- @field cls UnitClass
--- @field x number
--- @field y number
--- @field hp number
--- @field shooting_cooldown number
--- @field chunk_i_am_on Chunk
--- @field turrets Unit[] a list of my turrets
Unit = {
  instances = {}
}
Unit.__index = Unit

--- Create a unit on the battle-field.
--- @param x number
--- @param y number
--- @param unit_class UnitClass
--- @param owner FactionState
--- @return Unit
function Unit.new(x, y, unit_class, owner)
  local self = setmetatable({}, Unit)
  self.cls = unit_class
  self.owner = owner
  self.x = x
  self.y = y
  self.hp = unit_class.hp
  self.shooting_target = nil
  self.walk_queue = {}
  self.chunk_i_am_on = nil
  self.shooting_cooldown = 0
  self.turrets = {}
  self.passengers = {} -- some units can carry other units: lkw, tanks, etc.
  self.time_til_next_look_for_target = math.random(0, 3)
  -- todo: if this unitclass has other units as turrets: create those turrets here
  self:update_my_chunk()
  table.insert(Unit.instances, self)
  return self
end

function Unit:draw()
  -- called in draw_the_battle_field.lua
  -- draw a circle at the unit's position in the color of the faction
  -- filled
  love.graphics.setColor(self.owner.faction.color)
  love.graphics.circle("fill", self.x, self.y, 10)

  -- draw a purple circle around the unit with the radius of the weapon range
  local weapon_range = self.cls.weapon_range
  love.graphics.setColor(0.5, 0, 0.5)
  love.graphics.circle("line", self.x, self.y, weapon_range)

end

--- Check the neighbour chunks and my chunk for a target
--- in range to shoot at.
--- @param dt number
function Unit:look_for_target(dt)

  if self.chunk_i_am_on == nil then
    print("Unit is not on a chunk. This should not happen.")
    return
  end

  self.time_til_next_look_for_target = self.time_til_next_look_for_target - dt

  if self.target == nil and self.time_til_next_look_for_target <= 0 then

    for _, unit in ipairs(Unit.instances) do
      if unit.owner ~= self.owner then
        local distance = math.sqrt((unit.x - self.x) ^ 2 + (unit.y - self.y) ^ 2)
        if distance < self.cls.weapon_range then
          self.target = unit
          return
        end
      end
    end

    self.time_til_next_look_for_target = math.random(0, 0.2)

  end
end

--- Move the unit if not in range of target.
--- @param dt number
function Unit:move(dt)

  if #self.walk_queue > 0 and self.target == nil then
    local next_pos = self.walk_queue[1]
    local distance = math.sqrt((next_pos.x - self.x) ^ 2 + (next_pos.y - self.y) ^ 2)
    if distance < 10 then
      table.remove(self.walk_queue, 1)
    else
      local angle = math.atan2(next_pos.y - self.y, next_pos.x - self.x)
      self.x = self.x + math.cos(angle) * 100 * dt
      self.y = self.y + math.sin(angle) * 100 * dt
    end
  end

  self:update_my_chunk()

end

--- Fight: shoot if you can.
function Unit:fight(dt)

  -- if i have a target
  -- if my shooting_cooldown is 0
  -- create a projectile
  self.shooting_cooldown = self.shooting_cooldown - dt
  if self.target == nil then return end
  if self.shooting_cooldown > 0 then return end

  Unit.assert(self.target)

  local direction = math.atan2(self.target.y - self.y, self.target.x - self.x)

  Projectile.new(
    self.x,
    self.y,
    direction,
    self
  )

  self.shooting_cooldown = self.cls.shooting_cooldown
  assert(type(self.shooting_cooldown) == "number", "Expected number, got " .. type(self.shooting_cooldown))

end

function Unit:update_my_chunk()

  local chunk = Chunk.get(self.x, self.y)

  if chunk == nil then
    print("Unit is not on a chunk. This should not happen.")
    return
  end

  if chunk == self.chunk_i_am_on then return end

  if self.chunk_i_am_on ~= nil then
    -- this can be nil at the start
    local index = nil
    for i, unit in ipairs(self.chunk_i_am_on.units) do
      if unit == self then
        index = i
        break
      end
    end
    table.remove(self.chunk_i_am_on.units, index)
  end

  self.chunk_i_am_on = chunk
  table.insert(chunk.units, self)

end

function Unit:delete_after_death(reason_of_death)

  -- todo: create remains and blood
  -- todo: remove from chunk
  -- todo: remove from owner
  -- todo: remove from instances

  if reason_of_death == "explosion" then

  elseif reason_of_death == "rifle" then

  elseif reason_of_death == "fire" then

  end

  local index = nil
  for i, unit in ipairs(Unit.instances) do
    if unit == self then
      index = i
      break
    end
  end

  table.remove(Unit.instances, index)

  local index = nil
  for i, unit in ipairs(self.chunk_i_am_on.units) do
    if unit == self then
      index = i
      break
    end
  end
  table.remove(self.chunk_i_am_on.units, index)

  for _, u in ipairs(Unit.instances) do
    if u.target == self then u.target = nil end
  end

  for _, u in ipairs(self.turrets) do
    u:delete_after_death(reason_of_death)
  end

end

function Unit.update_all(dt)

  for _, unit in ipairs(Unit.instances) do
    unit:look_for_target(dt)
    unit:move(dt)
    unit:fight(dt)
    -- todo: this collision sucks ass
    -- check collision with other units
    for _, other_unit in ipairs(Unit.instances) do
      if other_unit ~= unit then
        local distance = math.sqrt((unit.x - other_unit.x) ^ 2 + (unit.y - other_unit.y) ^ 2)
        if distance < 10 then
          -- push the other unit away
          local angle = math.atan2(other_unit.y - unit.y, other_unit.x - unit.x)
          other_unit.x = other_unit.x + math.cos(angle) * 100 * dt
        end
      end
    end
  end

end

function Unit.is(x) return getmetatable(x) == Unit end
function Unit.assert(x) assert(Unit.is(x), "Expected Unit. Got " .. type(x)) end