local Unit = {}
Unit.__index = Unit

function Unit.new(x, y, unit_class)
  local self = setmetatable({}, Unit)
  self.cls = unit_class
  return self
end

function Unit.is(x) return getmetatable(x) == Unit end
function Unit.assert(x) assert(Unit.is(x), "Expected Unit. Got " .. type(x)) end

return Unit