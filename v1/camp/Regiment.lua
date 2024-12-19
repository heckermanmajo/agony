local Army = {}
Army.__index = Army

function Army.new()
  local self = setmetatable({}, Army)
  self.squads = {}
  return self
end

function Army.is(x) return getmetatable(x) == Army end
function Army.assert(x) assert(Army.is(x), "Expected Army. Got " .. type(x)) end


return Army