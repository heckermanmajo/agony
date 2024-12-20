--- @class UiState
--- @field cam Camera
--- @field zoom_level string
--- @field currently_selected_units table
--- @field currently_selected_squads table
--- @field selection_start {x: number, y: number} | nil
--- @field selection_end {x: number, y: number} | nil
--- @field is_selecting boolean
UiState = {}
UiState.__index = UiState

--- Creates a new UiState instance
--- @return UiState
function UiState.new()
  local self = setmetatable({}, UiState)

  self.cam = Camera.new()  --- @type Camera
  self.zoom_level = "default"  --- @type string
  self.currently_selected_units = {}  --- @type table
  self.currently_selected_squads = {}  --- @type table

  -- Track mouse position and selection box
  self.selection_start = nil  --- @type {x: number, y: number}? | nil
  self.selection_end = nil  --- @type {x: number, y: number}? | nil
  self.is_selecting = false  --- @type boolean
  self.select_squad_mode = false  --- @type boolean

  return self
end

--- Draws and handles unit selection using mouse input
function UiState:draw_and_handle_unit_selection_with_mouse()
  -- Check for mouse input
  if love.mouse.isDown(1) then
    -- Start selecting when mouse is first clicked
    if not self.is_selecting then
      self.is_selecting = true
      self.selection_start = {x = love.mouse.getX(), y = love.mouse.getY()}  --- @type {x: number, y: number}
    end

    -- Update the selection box end position
    self.selection_end = {x = love.mouse.getX(), y = love.mouse.getY()}  --- @type {x: number, y: number}
  elseif self.is_selecting then
    -- Finalize the selection when mouse is released
    self.is_selecting = false
    self.selection_end = {x = love.mouse.getX(), y = love.mouse.getY()}  --- @type {x: number, y: number}
    self:finalize_unit_selection()
  end

  -- Draw the selection box if selecting
  if self.is_selecting then
    love.graphics.setColor(0, 0, 1, 0.3)  -- semi-transparent blue
    love.graphics.rectangle("fill",
      math.min(self.selection_start.x, self.selection_end.x),
      math.min(self.selection_start.y, self.selection_end.y),
      math.abs(self.selection_end.x - self.selection_start.x),
      math.abs(self.selection_end.y - self.selection_start.y))
  end
end

--- Finalizes the selection of units within the selection box
function UiState:finalize_unit_selection()
  --- @type number, number
  local x1, y1 = self.selection_start.x, self.selection_start.y
  --- @type number, number
  local x2, y2 = self.selection_end.x, self.selection_end.y

  -- Reset the selected units
  self.currently_selected_units = {}

  -- Iterate over all units and check if they are inside the selection box
  for _, unit in ipairs(Unit.instances) do
    --- @type Unit
    local unit_x, unit_y = unit.x, unit.y

    -- Check if the unit is inside the selection box
    if unit_x >= math.min(x1, x2) and unit_x <= math.max(x1, x2) and
       unit_y >= math.min(y1, y2) and unit_y <= math.max(y1, y2) then
      -- Add unit to selected list
      table.insert(self.currently_selected_units, unit)
    end
  end
end

--- Type check for UiState objects
--- @param x any
--- @return boolean
function UiState.is(x)
  return getmetatable(x) == UiState
end

--- Asserts that the object is an instance of UiState
--- @param x any
function UiState.assert(x)
  assert(UiState.is(x), "Expected UiState. Got " .. type(x))
end
