
--- @class Squad a collection of units, that are controlled together.
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