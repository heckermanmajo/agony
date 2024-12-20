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

--- @class Faction


--- @class SquadTemplate
--- @field icon string the icon of the squad
--- @field name string the name of the squad
--- @field description string the description of the squad


--- @class Technology