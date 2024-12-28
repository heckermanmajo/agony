-----------------------------------------------------------------------
--- @class Projectile
--- @field start_x number
--- @field start_y number
--- @field x number
--- @field y number
--- @field direction number
--- @field shooter Unit
-----------------------------------------------------------------------
Projectile = {
  --- @type Projectile[]
  instances = {},
}

-- todo: we have a BUG: if a unit dies that has a projectile in the air
--       -> what happens to the projectile? is the unit removed? bla??

-----------------------------------------------------------------------
--- Create a new projectile.
--- @param start_x number
--- @param start_y number
--- @param direction number
--- @param shooter Unit
-----------------------------------------------------------------------
function Projectile.new(start_x, start_y, direction, shooter)

  assert(type(start_x) == "number", "Expected number, got " .. type(start_x))
  assert(type(start_y) == "number", "Expected number, got " .. type(start_y))
  assert(type(direction) == "number", "Expected number, got " .. type(direction))
  Unit.assert(shooter)

  local self = {}
  setmetatable(self, Projectile)

  self.start_x = start_x
  self.start_y = start_y
  self.direction = direction
  self.x = start_x
  self.y = start_y
  self.shooter = shooter

  table.insert(Projectile.instances, self)

  return self

end

-----------------------------------------------------------------------
--- Draw all projectiles.
-----------------------------------------------------------------------
function Projectile.draw_all()

  for _, projectile in ipairs(Projectile.instances) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", projectile.x, projectile.y, 3)
  end

end

-----------------------------------------------------------------------
--- @param dt number
-----------------------------------------------------------------------
function Projectile.update_all(dt)

  --- @type Projectile[]
  local projectiles_to_remove = {}

  for _, projectile in ipairs(Projectile.instances) do

    projectile.x = projectile.x + math.cos(projectile.direction) * 100 * dt
    projectile.y = projectile.y + math.sin(projectile.direction) * 100 * dt

    -- todo: check if i have exeeded the range; if so delete me: explosion, crator or smoke


    -- todo: do we need to do this each frame?
    -- todo: search for a better way to do this
    local my_chunk = Chunk.get(projectile.x, projectile.y)
    if my_chunk == nil then -- i am outside the map;delete me
      table.insert(projectiles_to_remove, projectile)
      goto continue_next_projectile
    end
    for _, unit in ipairs(my_chunk.units) do

      if unit == projectile.shooter or unit.owner == projectile.shooter.owner then -- do not hit the shooter
        goto continue
      end

      local unit_pos = { x = unit.x, y = unit.y }
      local distance = math.sqrt((unit_pos.x - projectile.x) ^ 2 + (unit_pos.y - projectile.y) ^ 2)

      if distance < 10 then

        -- apply unit hit
        do
          print("HIT")

          -- todo: maybe create explosion

          unit.hp = unit.hp - projectile.shooter.cls.attack
          if unit.hp <= 0 then
            local reason_of_death = "rifle"
            unit:delete_after_death(reason_of_death)
          end

          table.insert(projectiles_to_remove, projectile)

        end -- apply unit hit

        break -- break the loop over units

      end -- if distance < 10: unit hit
      ::continue::

    end -- loop over units
    ::continue_next_projectile::

  end -- loop over projectiles

  -- remove the projectiles that hit a unit
  for _, projectile in ipairs(projectiles_to_remove) do
    for i, p in ipairs(Projectile.instances) do
      if p == projectile then
        table.remove(Projectile.instances, i)
        break
      end
    end
  end

end -- update_all


function Projectile.is(x) return getmetatable(x) == Projectile end

function Projectile.assert(x)
  if Projectile.is(x) then return end
  error("Expected Projectile, got " .. type(x))
end