
--- @class Squad a collection of units with experiences.
--- A army consists of multiple squads.
--- A squad can be upgraded to fit a specific role in the army.
--- For example you can add vehicles to infantry to make it motorized.
--- Or you can add tanks to a squad.
--- Also squads can received special training to increase their effectiveness.
local Squad = {}
Squad.__index = Squad

function Squad.new()
  local self = setmetatable({}, Squad)
  self.units = {}
  return self
end

function Squad.is(x) return getmetatable(x) == Squad end
function Squad.assert(x) assert(Squad.is(x), "Expected Squad. Got " .. type(x)) end


return Squad