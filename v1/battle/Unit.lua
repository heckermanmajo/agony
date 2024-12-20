--- @class Unit
--- @field target Unit
--- @field walk_queue table<{x: number, y: number}>
--- @field owner FactionState
--- @field cls UnitClass
--- @field x number
--- @field y number
--- @field hp number
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
  self.turrets = {}
  self.passengers = {} -- some units can carry other units: lkw, tanks, etc.
  self.time_til_next_look_for_target = math.random(0, 3)
  -- todo: if this unitclass has other units as turrets: create those turrets here
  self:update_my_chunk()
  table.insert(Unit.instances, self)
  return self
end

function Unit:draw()

  -- dra a circle at the unit's position in the color of the faction
  -- filled
  love.graphics.setColor(self.owner.faction.color)
  love.graphics.circle("fill", self.x, self.y, 10)

end

--- Check the neighbour chunks and my chunk for a target
--- in range to shoot at.
--- @param dt number
function Unit:look_for_target(dt)

  self.time_til_next_look_for_target = self.time_til_next_look_for_target - dt

  if self.target == nil and self.time_til_next_look_for_target <= 0 then

    local not_diagonal = false
    -- todo: check if this unpack works correctly...
    local chunks = {self.chunk_i_am_on, unpack(self.chunk_i_am_on:get_neighbours(not_diagonal))}
    for _, chunk in ipairs(chunks) do
      for _, unit in ipairs(chunk.units) do
        if unit.owner ~= self.owner then
          local distance = math.sqrt((unit.x - self.x) ^ 2 + (unit.y - self.y) ^ 2)
          if distance < self.cls.weapon_range then
            self.target = unit
            return
          end
        end
      end
    end

    self.time_til_next_look_for_target = math.random(0, 3)

  end
end

--- Move the unit if not in range of target.
--- @param dt number
function Unit:move(dt)

  if #self.walk_queue > 0 then
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
function Unit:fight(dt) end

function Unit:update_my_chunk()

  local chunk = Chunk.get(self.x, self.y)

  if chunk == nil then
    print("Unit is not on a chunk. This should not happen.")
    return
  end

  if chunk == self.chunk_i_am_on then return end

  table.remove(self.chunk_i_am_on.units, self)
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

end

function Unit.update_all(dt)

  for _, unit in ipairs(Unit.instances) do
    unit:look_for_target(dt)
    unit:move(dt)
    unit:fight(dt)
  end

end

function Unit.is(x) return getmetatable(x) == Unit end
function Unit.assert(x) assert(Unit.is(x), "Expected Unit. Got " .. type(x)) end