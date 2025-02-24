----------------------------------------
--- Main class for the battle.
--- Each rts battle creates a new instance of this class.
--- This instance is then saved in Battle.current.
--- @class Battle
--- @field ui UiState
--- @field armies Army[]
--- @field player_army Army
--- @field current Battle
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
--- Create a new battle. This function is called if on the campaign map
--- two armies meet and a battle is started.
--- @param armies Army[]
--- @return Battle
----------------------------------------
function Battle.new(armies)

  for _, army in ipairs(armies) do Army.assert(army) end

  -- reset the global battle state
  do
    Projectile.instances = {}
    Unit.instances = {}
    PassiveObject.instances = {}
    Sector.instances = {}
    Chunk.instances = {}
    Tile.instances = {}
    Battle.current = nil
    collectgarbage()
  end

  -- if this is true all units flee and the faction is defeated
  -- if more than two factions are fighting against each other, it is possible that
  -- the fight continues after one faction is defeated
  for _, faction_state in  ipairs(FactionState.instances) do
    faction_state.defeated_in_this_current_battle = false
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
  
  initialize_the_battle_field()

  return self
end


function Battle:get_non_player_armies()
  local non_player_armies = {}
  for _, army in ipairs(self.armies) do
    if not army.owner.is_player then
      table.insert(non_player_armies, army)
    end
  end
  return non_player_armies
end

function handle_units(dt)
  for _, u in ipairs(Unit.instances) do
    u:update_my_chunk(dt)
    u:think(dt)
  end
end

function update_owner_of_chunk(dt)
    for _, c in ipairs(Chunk.instances) do c:update_owner_of_chunk() end
end

----------------------------------------
--- Update the battle.
--- @param dt number
----------------------------------------
function Battle:update(dt)

  Battle.assert(self)

  local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
  local mouseX, mouseY = love.mouse.getPosition()

  self.ui.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
  self.ui.cam:apply_wasd_movement(dt)
  self.ui:send_selected_units_to_mouse_click_target()

  if UiState.key_press_cooldown > 0 then
    UiState.key_press_cooldown = UiState.key_press_cooldown - dt
  end

  Projectile.update_all(dt)
  Unit.update_all(dt)
  PassiveObject.update_all(dt)
  spawn_management(dt)
  ai_management(dt)
  end_battle_condition_check(dt)
  handle_units(dt)


  if DEBUG then for _, c in ipairs(Chunk.instances) do c:check_chunk_state() end end
  update_owner_of_chunk(dt)

end

----------------------------------------
--- Draw the battle.
----------------------------------------
function Battle:draw()
  draw_the_battle_field()

  self.ui:draw_and_handle_unit_selection_with_mouse()
  self.ui:display_and_handle_select_squad_mode()

  -- draw the current players army command points
  if not PROFILING then -- collides with the profiling text
    local command_points = Battle.current.player_army.command_points
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Command Points: " .. command_points, 10, 10)

    local non_player_armies = self:get_non_player_armies()
    for i, army in ipairs(non_player_armies) do
      local color = army.owner.faction.color
      love.graphics.setColor(color)
      love.graphics.print("Command Points: " .. army.command_points, 10, 10 + i * 20)
      love.graphics.setColor(1, 1, 1)
    end
  end

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
