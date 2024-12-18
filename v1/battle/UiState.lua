local UiState = {}
UiState.__index = UiState


function UiState.new()

  local self = setmetatable({}, UiState)

  self.target_x = 0
  self.target_y = 0
  self.zoom = 1
  self.zoom_level = "default" -- "mini", "micro", "macro", "minimap"

  return self

end

function UiState:draw_ui()

end

function UiState:draw_world()

end

function UiState:draw_world() end
function UiState:draw_ui() end

function UiState.is(x) return getmetatable(x) == UiState end
function UiState.assert(x) assert(UiState.is(x), "Expected UiState. Got " .. type(x)) end


return UiState