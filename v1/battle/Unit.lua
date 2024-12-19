
--- @class Unit
--- @field target Unit
--- @field squad Squad
--- @field walk_queue table<{x: number, y: number}>
--- @field owner BattleFaction
--- @field cls UnitClass
--- @field x number
--- @field y number
--- @field hp number
--- @field is_turret boolean a turret cannot move; at turret dies if its owner dies
--- @field turrets Unit[] a list of my turrets
Unit = {
  instances = {}
}
Unit.__index = Unit

function Unit.new(x, y, unit_class)
  local self = setmetatable({}, Unit)
  self.cls = unit_class
  return self
end

function Unit:draw() end

function Unit:think() end

function Unit:look_for_target() end

function Unit:move() end

function Unit:delete_after_death(reason_of_death)

  if reason_of_death == "explosion" then

  elseif reason_of_death == "rifle" then

  elseif reason_of_death == "fire" then

  end

end

function Unit.is(x) return getmetatable(x) == Unit end
function Unit.assert(x) assert(Unit.is(x), "Expected Unit. Got " .. type(x)) end