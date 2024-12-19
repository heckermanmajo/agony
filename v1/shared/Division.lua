--- @class Division 100-200 soldiers + equipment;
--- @field units table<UnitClass, number> the units in the battle; if unit dies it is removed from the table
--- @field template DivisionTemplate

Division = {
  instances = {}
}
Division.__index = Division

function Division.new(template)
  DivisionTemplate.assert(template)
  local self = setmetatable({}, Division)
  self.template = template
  self.units = {}
  return self
end


function Division:spawn(sector)

end