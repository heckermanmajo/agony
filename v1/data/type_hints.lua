--- @class UnitClass a type of unit.
--- @field speed number the speed of the unit in pixels per second
--- @field hp number the health points of the unit
--- @field attack number the attack power of the unit
--- @field pierce number the pierce power of the unit
--- @field explosion_radius number the explosion radius of the unit
--- @field explosion_type string the type of explosion of the: fire, granate
--- @field can_throw_granate boolean if the unit can throw granates
--- @field turrets table<UnitClass> the turrets of the unit; turrets are "units" that are attached to the unit
--- @field is_infantry boolean if the unit is infantry or a vehicle
--- @field armor_level number the armor level of the unit; 0 is no armor, 1 is light armor, 2 is medium armor, 3 is heavy armor, 4 is super heavy armor
--- @field accuracy number the accuracy of the unit; 0 is no accuracy, 1 is low accuracy, 2 is medium accuracy, 3 is high accuracy, 4 is super high accuracy
--- @field weapon_range number the range of the weapon of the unit in pixels

UnitClass = {}
UnitClass.__index = UnitClass
--- Checks a unit-class for validity.
--- @param x any
function UnitClass.assert(x)
  assert(type(x) == "table", "Expected UnitClass. Got " .. type(x))
  assert(type(x.speed) == "number", "Expected number for speed. Got " .. type(x.speed))
  assert(type(x.hp) == "number", "Expected number for hp. Got " .. type(x.hp))
  assert(type(x.attack) == "number", "Expected number for attack. Got " .. type(x.attack))
  assert(type(x.pierce) == "number", "Expected number for pierce. Got " .. type(x.pierce))
  assert(type(x.explosion_radius) == "number", "Expected number for explosion_radius. Got " .. type(x.explosion_radius))
  assert(type(x.explosion_type) == "string", "Expected string for explosion_type. Got " .. type(x.explosion_type))
  assert(type(x.can_throw_granate) == "boolean", "Expected boolean for can_throw_granate. Got " .. type(x.can_throw_granate))
  assert(type(x.turrets) == "table", "Expected table for turrets. Got " .. type(x.turrets))
  for _, turret in ipairs(x.turrets) do
    UnitClass.assert(turret)
  end
  assert(type(x.is_infantry) == "boolean", "Expected boolean for is_infantry. Got " .. type(x.is_infantry))
  assert(type(x.armor_level) == "number", "Expected number for armor_level. Got " .. type(x.armor_level))
  assert(type(x.accuracy) == "number", "Expected number for accuracy. Got " .. type(x.accuracy))
  assert(type(x.weapon_range) == "number", "Expected number for weapon_range. Got " .. type(x.weapon_range))
end

--- @class Faction


--- @class SquadTemplate
--- @field icon string the icon of the squad
--- @field name string the name of the squad
--- @field description string the description of the squad
--- @field units table<UnitClass, number> the units of the squad


--- @class Technology

--- @class SupportCall Calls out of the map