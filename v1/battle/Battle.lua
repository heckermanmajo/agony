----------------------------------------
--- @class Battle
--- @field ui UiState
----------------------------------------
Battle = {
  --- @type Battle
  current = nil, -- @type Battle
}
Battle.__index = Battle

Battle.SECTOR_SIZE_IN_CHUNKS = 3
Battle.CHUNK_SIZE_IN_TILES = 10
Battle.TILE_SIZE_IN_PIXELS = 64
Battle.CHUNK_SIZE_IN_PIXELS = Battle.CHUNK_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS
Battle.SECTOR_SIZE_IN_TILES = Battle.SECTOR_SIZE_IN_CHUNKS * Battle.CHUNK_SIZE_IN_TILES
Battle.WORLD_SIZE_IN_SECTORS = 2
Battle.WORLD_SIZE_IN_CHUNKS = Battle.WORLD_SIZE_IN_SECTORS * Battle.SECTOR_SIZE_IN_CHUNKS

----------------------------------------
--- Create a new battle.
--- @param armies Army[]
--- @return Battle
----------------------------------------
function Battle.new(
  armies
)
  -- reset the global battle state
  do
    Projectile.instances = {}
    Unit.instances = {}
    PassiveObject.instances = {}
    Sector.instances = {}
    Chunk.instances = {}
    Tile.instances = {}
    Battle.current = nil
  end

  local self = {}
  setmetatable(self, Battle)

  self.ui = UiState.new()
  self.armies = armies
  self.player_army = nil
  for _, army in ipairs(armies) do
    Army.assert(army)
    if army.owner.is_player then
      self.player_army = army
    end
  end
  assert(self.player_army, "No player army found in the list of armies")

  Battle.current = self

  load_all_resources()
  initialize_the_battle_field()

  return self
end


----------------------------------------
--- Update the battle.
--- @param dt number
----------------------------------------
function Battle:update(dt)

  local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
  local mouseX, mouseY = love.mouse.getPosition()

  self.ui.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
  self.ui.cam:apply_wasd_movement(dt)

  if UiState.key_press_cooldown > 0 then
    UiState.key_press_cooldown = UiState.key_press_cooldown - dt
  end

  Projectile.update_all(dt)
  Unit.update_all(dt)
    --Unit.update_all(dt)
  PassiveObject.update_all(dt)
  spawn_management(dt)
  ai_management(dt)

  -- command units to walk to the mouse position
  do
    if #self.ui.currently_selected_units > 0 then

      local rightMouseButtonPressed = love.mouse.isDown(2)

      if rightMouseButtonPressed then

        local x, y = self.ui.cam:transform_screen_xy_to_world_xy(love.mouse.getPosition())
        -- random radius in which to place the unit-target position based on the mouse position;
        local max_random_radius = {
          {n=10, r = 120},
          {n=20, r = 180},
          -- todo:  more values can be added here
        }
        local max_random_radius_max = 120

        local radius_to_use = 0
        for _, value in ipairs(max_random_radius) do
          local n, r = value.n, value.r
          if n <= #self.ui.currently_selected_units then
            radius_to_use = r
          end
        end

        if radius_to_use == 0 then radius_to_use = max_random_radius_max end

        for _, unit in ipairs(self.ui.currently_selected_units) do
          local u = unit --- @type Unit
          local random_radius = math.random(0, radius_to_use)
          local random_angle = math.random(0, 360)
          local x = x + random_radius * math.cos(random_angle)
          local y = y + random_radius * math.sin(random_angle)
          u.walk_queue = { { x = x, y = y } }
        end -- for _, unit in ipairs(self.ui.currently_selected_units) do

      end -- if rightMouseButtonPressed then

    end -- if #self.ui.currently_selected_units > 0 then

  end -- end command units to walk to the mouse position

end


----------------------------------------
--- Draw the battle.
----------------------------------------
function Battle:draw()
  draw_the_battle_field()

  self.ui:draw_and_handle_unit_selection_with_mouse()
  self.ui:display_and_handle_select_squad_mode()
  love.graphics.setColor(1, 1, 1)
end


----------------------------------------
--- Check if the given object is a Battle.
--- @param x table
--- @return boolean
----------------------------------------
function Battle.is(x) return getmetatable(x) == Battle end

----------------------------------------
--- Assert that the given object is a Battle.
----------------------------------------
function Battle.assert(x) assert(Battle.is(x), "Expected Battle. Got " .. type(x)) end
