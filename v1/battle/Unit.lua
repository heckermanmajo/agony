-------------------------------------------------------------------------
--- @class Unit soldiers, tanks, turrets, defensive positions, etc.
--- @field target Unit The current target of this unit.
--- @field walk_queue table<{x: number, y: number}> a list of positions to walk to
--- @field owner FactionState the faction that owns this unit
--- @field cls UnitClass the class of this unit
--- @field x number the current x position
--- @field y number the current y position
--- @field hp number the current health points
--- @field shooting_cooldown number the time until the next shot can be fired
--- @field rotation number the current rotation of the unit
--- @field chunk_i_am_on Chunk the chunk this unit is currently on
--- @field turrets Unit[] a list of my turrets
--- @field passengers Unit[] a list of units that are in this unit
--- @field time_til_next_look_for_target number the time until the next target search
--- @field chunk_conquer_target Chunk the chunk this unit is currently trying to conquer; used by ai-units only
---
-- todo: implement passengers
-- todo: implement turrets, turrets need to know their parent unit
-- todo: implement fleeing mode
-- todo: implement fallback
------------------------------------------------------------------------
Unit = {
  --- @type Unit[]
  instances = {}
}

Unit.__index = Unit

------------------------------------------------------------------------
--- Create a unit on the battle-field.
--- @param x number
--- @param y number
--- @param unit_class UnitClass
--- @param owner FactionState
--- @return Unit
------------------------------------------------------------------------
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
  self.rotation = 0
  self.turrets = {}
  self.passengers = {} -- some units can carry other units: lkw, tanks, etc.
  self.time_til_next_look_for_target = math.random(0, 3)
  self.chunk_conquer_target = nil -- see battle/functions/ai_management.lua

  -- todo: if this unitclass has other units as turrets: create those turrets here
  self:update_my_chunk()

  table.insert(Unit.instances, self)
  return self

end -- new


------------------------------------------------------------------------
--- Draw the unit on the battle-field.
------------------------------------------------------------------------
function Unit:draw()

  Unit.assert(self)

  -- called in draw_the_battle_field.lua
  -- draw a circle at the unit's position in the color of the faction
  -- filled
  love.graphics.setColor(self.owner.faction.color)
  --love.graphics.circle("fill", self.x, self.y, 10)
  --local x, y, w, h = Atlas.all[self.cls.atlas].quads[self.cls.quad]:getViewport()
  ---local w_half = w / 2
  --local h_half = h / 2
  assert(Atlas.all[self.cls.atlas] ~= nil)
  assert(Atlas.all[self.cls.atlas].quads[self.cls.quad] ~= nil)
  Atlas.all[self.cls.atlas]:draw_quad(
    self.cls.quad,
    self.x,
    self.y,
    self.owner.faction.color_name,
    self.rotation,
    1,
    1,
    true
  )

  -- draw a purple circle around the unit with the radius of the weapon range
  --local weapon_range = self.cls.weapon_range
  --love.graphics.setColor(self.owner.faction.color)
  --love.graphics.circle("line", self.x, self.y, weapon_range)

end -- draw


------------------------------------------------------------------------
--- Check the neighbour chunks and my chunk for a target
--- in range to shoot at.
--- @param dt number
-- todo: make this smarter...
-------------------------------------------------------------------------
function Unit:look_for_target(dt)

  if self.chunk_i_am_on == nil then
    print("Unit is not on a chunk. This should not happen: " .. self.x .. " " .. self.y .. " HP: " .. self.hp)
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

    self.time_til_next_look_for_target = math.random(0, 2)

  end
end -- look_for_target


--------------------------------------------------------------------
--- Move the unit if not in range of target.
--- @param dt number
--------------------------------------------------------------------
function Unit:move(dt)

  Unit.assert(self)

  if #self.walk_queue > 0 and self.target == nil then
    local next_pos = self.walk_queue[1]
    local distance = math.sqrt((next_pos.x - self.x) ^ 2 + (next_pos.y - self.y) ^ 2)
    if distance < 10 then
      table.remove(self.walk_queue, 1)
    else
      local angle = math.atan2(next_pos.y - self.y, next_pos.x - self.x)
      self.x = self.x + math.cos(angle) * 100 * dt
      self.y = self.y + math.sin(angle) * 100 * dt
      self.rotation = angle - math.pi / 2
    end
  end

end -- move


--------------------------------------------------------------------
--- Fight the target if in range.
--- Currently: shoot if you can.
--- @param dt number
--------------------------------------------------------------------
function Unit:fight(dt)

  Unit.assert(self)

  -- if i have a target
  -- if my shooting_cooldown is 0
  -- create a projectile
  self.shooting_cooldown = self.shooting_cooldown - dt
  if self.target == nil then return end
  if self.shooting_cooldown > 0 then return end
  --rotate towards target
  self.rotation = math.atan2(self.target.y - self.y, self.target.x - self.x) - math.pi / 2

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

end -- fight

function Unit:think(dt)

  if self.owner.is_player then return end

  if self.chunk_conquer_target ~= nil then

    if self.target == nil then

      if #self.walk_queue == 0 then

        local x = self.chunk_conquer_target.x * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)
        local y = self.chunk_conquer_target.y * Battle.CHUNK_SIZE_IN_PIXELS + math.random(0, Battle.CHUNK_SIZE_IN_PIXELS)

        self.walk_queue = {
          {x = x, y = y}
        }

      end

    end

  end

end


-----------------------------------------------------------------------
--- Update the chunk the unit is registered on.
--- This is used to keep track of the units on the map.
-----------------------------------------------------------------------
function Unit:update_my_chunk()

  Unit.assert(self)

  if self:is_out_of_world() then return end

  local chunk = Chunk.get(self.x, self.y)

  if chunk == nil then
    print("Unit is not on a chunk. This should not happen.")
    return
  end

  if chunk == self.chunk_i_am_on then return end

  if self.chunk_i_am_on ~= nil then
    -- this can be nil at the start; after unit creation
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

end -- update_my_chunk


-----------------------------------------------------------------------
--- Delete the unit after it has died; called by unit killing game logic.
--- For example: projectile-hit logic.
--- @param reason_of_death string
--- @see Projectile
-----------------------------------------------------------------------
function Unit:delete_after_death(reason_of_death)

  -- todo: create remains and blood based on the reason of death

  -- create remains and blood based on the reason of death
  do
    if reason_of_death == "explosion" then

    elseif reason_of_death == "rifle" then

    elseif reason_of_death == "fire" then

    end
  end

  -- remove from Unit.instances -> this is the list of all units
  do
    local index = nil
    for i, unit in ipairs(Unit.instances) do
      if unit == self then
        index = i
        break
      end
    end

    table.remove(Unit.instances, index)
  end

  -- remove from the chunk-list of units
  do
    local index = nil
    for i, unit in ipairs(self.chunk_i_am_on.units) do
      if unit == self then
        index = i
        break
      end
    end
    table.remove(self.chunk_i_am_on.units, index)
  end

  -- remove from other units that have me as target
  for _, u in ipairs(Unit.instances) do
    if u.target == self then u.target = nil end
  end

  -- remove my turrets if i have any
  for _, u in ipairs(self.turrets) do
    u:delete_after_death(reason_of_death)
  end

  -- this can be used to find bugs in state checks
  self.dead = true

end -- delete_after_death



-----------------------------------------------------------------------
--- Update all units.
--- @param dt number
-----------------------------------------------------------------------
function Unit.update_all(dt)

  for _, unit in ipairs(Unit.instances) do
    --if unit.__collision_timer == nil then
    --  unit.__collision_timer = 0
    --end
    --unit.__collision_timer = unit.__collision_timer - dt
    unit:look_for_target(dt)
    unit:move(dt)
    unit:fight(dt)
    -- check collision with other units
    --if unit.chunk_i_am_on ~= nil and unit.__collision_timer < 0 then
    --  for _, other_unit in ipairs(unit.chunk_i_am_on.units) do
    --    if other_unit ~= unit then
    --     local distance = math.sqrt((unit.x - other_unit.x) ^ 2 + (unit.y - other_unit.y) ^ 2)
    --      if distance < 10 then
    --        -- push the other unit away
    --        local angle = math.atan2(other_unit.y - unit.y, other_unit.x - unit.x)
    --        other_unit.x = other_unit.x + math.cos(angle) * 20
    --      end
    --    end
    --  end
    --  unit.__collision_timer = math.random(0, 1)
    --end

  end

end -- update_all


------------------------------------------------------------------------
--- Returns true if the unit is out of this world.
--- @return boolean
------------------------------------------------------------------------
function Unit:is_out_of_world()
  local world_size = Battle.WORLD_SIZE_IN_CHUNKS * Battle.CHUNK_SIZE_IN_PIXELS
  return (
    self.x > world_size
      or self.x < 0
      or self.y > world_size
      or self.y < 0
  )
end

------------------------------------------------------------------------
--- Determine if given instance is Unit.
--- @param x table
--- @return boolean
------------------------------------------------------------------------
function Unit.is(x) return getmetatable(x) == Unit end

------------------------------------------------------------------------
--- Asserts that the given instance is a instance of Unit.
--- @param x table
--- @see Unit.is
------------------------------------------------------------------------
function Unit.assert(x) assert(Unit.is(x), "Expected Unit. Got " .. type(x)) end