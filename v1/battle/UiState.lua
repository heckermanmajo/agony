------------------------------------------------------------------------
--- @class UiState contains all the state for the battle ui and manages the ui display logic.
--- @field cam Camera
--- @field zoom_level string
--- @field currently_selected_units table<Unit>
--- @field selection_start {x: number, y: number} | nil
--- @field selection_end {x: number, y: number} | nil
--- @field is_selecting boolean
--- @field select_squad_mode string
---------------------------------------------------------------------------
UiState = {
  key_press_cooldown = 0.5, --- @type number
}
UiState.__index = UiState

------------------------------------------------------------------------
--- Creates a new UiState instance
--- @return UiState
------------------------------------------------------------------------
function UiState.new()
  local self = setmetatable({}, UiState)

  self.cam = Camera.new()  --- @type Camera
  self.zoom_level = "default"  --- @type string
  self.currently_selected_units = {}  --- @type table<Unit>

  -- Track mouse position and selection box
  self.selection_start = nil  --- @type {x: number, y: number}? | nil
  self.selection_end = nil  --- @type {x: number, y: number}? | nil
  self.is_selecting = false  --- @type boolean
  self.select_squad_mode = "infantry"  --- @type string

  return self
end

------------------------------------------------------------------------
--- Draws and handles unit selection using mouse input.
------------------------------------------------------------------------
function UiState:draw_and_handle_unit_selection_with_mouse()
  -- Check for mouse input
  if love.mouse.isDown(1) then
    -- Start selecting when mouse is first clicked
    if not self.is_selecting then
      self.is_selecting = true
      self.selection_start = { x = love.mouse.getX(), y = love.mouse.getY() }  --- @type {x: number, y: number}
    end

    -- Update the selection box end position
    self.selection_end = { x = love.mouse.getX(), y = love.mouse.getY() }  --- @type {x: number, y: number}
  elseif self.is_selecting then
    -- Finalize the selection when mouse is released
    self.is_selecting = false
    self.selection_end = { x = love.mouse.getX(), y = love.mouse.getY() }  --- @type {x: number, y: number}
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

------------------------------------------------------------------------
--- Finalizes the selection of units within the selection box
------------------------------------------------------------------------
function UiState:finalize_unit_selection()

  --print("finalize_unit_selection")
  --Camera:transform_screen_xy_to_world_xy(screen_x, screen_y)
  --- @type number, number
  local x1, y1 = self.cam:transform_screen_xy_to_world_xy(self.selection_start.x, self.selection_start.y)
  --- @type number, number
  local x2, y2 = self.cam:transform_screen_xy_to_world_xy(self.selection_end.x, self.selection_end.y)

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

------------------------------------------------------------------------
--- Displays and handles the squad spawn selection mode for the player.
------------------------------------------------------------------------
function UiState:display_and_handle_select_squad_mode()

  -- toggle the select squad menu with the return key
  do
    if love.keyboard.isDown("return") and UiState.key_press_cooldown <= 0 then

      if self.select_squad_mode == "none" then self.select_squad_mode = "infantry"
      else self.select_squad_mode = "none" end

      UiState.key_press_cooldown = 0.1
    end
  end

  -- if the select squad menu is not open, return: no need to draw anything and no need to handle input
  if self.select_squad_mode == "none" then return end

  -- the different squad modes: what kind of squads/ out of map support the player can spawn into the battle
  local select_squad_modes = { "infantry", "armor", "support" }

  -- draw a gray rect at the left side of the screen
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", 0, 100, 160, love.graphics.getHeight())

  -- print the current select squad mode
  love.graphics.setColor(1, 1, 1)

  -- buttons for switch the select squad mode
  for i, mode in ipairs(select_squad_modes) do

    if mode == self.select_squad_mode then
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.rectangle("fill", 10 + (i - 1) * 50, 120, 50, 30)
    end

    -- draw 3 buttons each 50 px wide 30 px high in one line
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10 + (i - 1) * 50, 120, 50, 30)
    love.graphics.print(mode, 10 + (i - 1) * 50, 120)

    if Utils.mouse_is_over(10 + (i - 1) * 50, 120, 50, 30) then
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("line", 10 + (i - 1) * 50, 120, 50, 30)
      -- make cursor a hand
      -- love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
      if love.mouse.isDown(1) and UiState.key_press_cooldown <= 0 then
        self.select_squad_mode = mode
        UiState.key_press_cooldown = 0.1
      end
    end

  end

  love.graphics.setColor(1, 1, 1)

  -- draw the spawn menu on the left side of the ui-window
  do

    local icon_x = 10
    local icon_y = 200

    local squads = {}
    -- data from the /data/factions/**/*.lua files
    if self.select_squad_mode == "infantry" then
      squads = FactionState.get_current_player_faction().faction.inf_squads
    elseif self.select_squad_mode == "armor" then
      squads = FactionState.get_current_player_faction().faction.armor_squads
    elseif self.select_squad_mode == "support" then
      squads = FactionState.get_current_player_faction().faction.support_squads
    end

    -- draw one button for each squad: 2 columns
    for index, squad_template in ipairs(squads) do

      local icon = squad_template.icon
      love.graphics.draw(icon, icon_x, icon_y, 0, 1, 1)

      local costs_in_command_points = squad_template.costs

      -- print the costs at the right bottom
      love.graphics.setColor(0, 1, 0)
      love.graphics.print(costs_in_command_points .. "$", icon_x + 36, icon_y + 45)
      love.graphics.setColor(1, 1, 1)

      -- get the spawn duration
      local duration = squad_template.time_til_deployment
      -- print the duration at the right top
      love.graphics.setColor(1, 1, 0)
      love.graphics.print(duration .. "s", icon_x + 6, icon_y + 45)
      love.graphics.setColor(1, 1, 1)

      -- mouse over and mouse interaction
      if Utils.mouse_is_over(icon_x, icon_y, 64, 64) then

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", icon_x, icon_y, 64, 64)

        local i_have_enough_money = FactionState.get_current_player_faction().money >= costs_in_command_points

        -- if button is clicked: add this squad to the spawn queue
        if love.mouse.isDown(1) and UiState.key_press_cooldown <= 0 and i_have_enough_money then
          print("selected squad " .. index)
          -- apply the money costs
          FactionState.get_current_player_faction().money = FactionState.get_current_player_faction().money - costs_in_command_points
          local squad = FactionState.get_current_player_faction().faction.inf_squads[index]
          UiState.key_press_cooldown = 0.3
          -- todo: insert squad into spawn queue -> of army
          local player_faction = FactionState.get_current_player_faction()
          table.insert(player_faction.spawn_queue, squad)
          if player_faction.time_til_next_spawn <= 0 then
            player_faction.time_til_next_spawn = squad.time_til_deployment
          end
        end

        love.graphics.setColor(1, 1, 1)

      end

      -- 2 columns
      if index % 2 == 0 then
        icon_x = 10
        icon_y = icon_y + 64 + 10
      else
        icon_x = icon_x + 64 + 10
      end

    end -- each squad

  end -- end drawing squad-spawn

  -- render spawn queue: list of all squads that will spawn in the future + a timer
  do

    local player_faction = FactionState.get_current_player_faction()

    local start_x = 200
    local y = 10
    local sum_of_spawn_durations = 0

    for index, squad_template in ipairs(player_faction.spawn_queue) do
      -- update the timer for this squad-spawn
      if index == 1 then sum_of_spawn_durations = player_faction.time_til_next_spawn
      else sum_of_spawn_durations = sum_of_spawn_durations + squad_template.time_til_deployment end

      local icon = squad_template.icon
      love.graphics.draw(icon, start_x, y, 0, 1, 1)
      -- get the spawn duration
      -- print the duration at the right top
      love.graphics.setColor(1, 1, 0)
      love.graphics.print(math.floor(sum_of_spawn_durations) .. "s", start_x + 6, y + 45)
      love.graphics.setColor(1, 1, 1)

      -- todo: add a cancel option if clicked on this squad-queue button

      start_x = start_x + 64 + 10
    end -- each squad in spawn queue

  end -- end drawing spawn queue

end -- end display_and_handle_select_squad_mode


function UiState:send_selected_units_to_mouse_click_target()

  if #self.currently_selected_units > 0 then

    local rightMouseButtonPressed = love.mouse.isDown(2)

    if rightMouseButtonPressed then

      local x, y = self.cam:transform_screen_xy_to_world_xy(love.mouse.getPosition())
      -- do not allow to send units out of the map
      do
        local world_size = Battle.CHUNK_SIZE_IN_PIXELS * Battle.WORLD_SIZE_IN_CHUNKS
        local out_of_bounds = x < 0 or x > world_size or y < 0 or y > world_size
        if out_of_bounds then return end
      end
      -- random radius in which to place the unit-target position based on the mouse position;
      local max_random_radius = {
        { n = 10, r = 120 },
        { n = 20, r = 180 },
        -- todo:  more values can be added here
      }
      local max_random_radius_max = 120

      local radius_to_use = 0
      for _, value in ipairs(max_random_radius) do
        local n, r = value.n, value.r
        if n <= #self.currently_selected_units then
          radius_to_use = r
        end
      end

      if radius_to_use == 0 then radius_to_use = max_random_radius_max end

      for _, unit in ipairs(self.currently_selected_units) do
        local u = unit --- @type Unit
        local random_radius = math.random(0, radius_to_use)
        local random_angle = math.random(0, 360)
        local x = x + random_radius * math.cos(random_angle)
        local y = y + random_radius * math.sin(random_angle)
        u.walk_queue = { { x = x, y = y } }
      end -- for _, unit in ipairs(self.currently_selected_units) do

    end -- if rightMouseButtonPressed then

  end -- if #self.currently_selected_units > 0 then

end -- end command units to walk to the mouse position


------------------------------------------------------------------------
--- Type check for UiState objects
--- @param x any
--- @return boolean
------------------------------------------------------------------------
function UiState.is(x)
  return getmetatable(x) == UiState
end

------------------------------------------------------------------------
--- Asserts that the object is an instance of UiState
--- @param x any
------------------------------------------------------------------------
function UiState.assert(x)
  assert(UiState.is(x), "Expected UiState. Got " .. type(x))
end
