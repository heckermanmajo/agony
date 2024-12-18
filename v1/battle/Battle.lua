--- @class Battle
local Battle = {
  current = nil,
}
Battle.__index = Battle

function Battle.new()
  local self = {}
  setmetatable(self, Battle)
  return self
end

return Battle