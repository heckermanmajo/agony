
--- @class Battle
--- @field ui UiState
Battle = {
  current = nil,
}
Battle.__index = Battle

Battle.SECTOR_SIZE_IN_CHUNKS = 4
Battle.CHUNK_SIZE_IN_TILES = 10
Battle.TILE_SIZE_IN_PIXELS = 64
Battle.CHUNK_SIZE_IN_PIXELS = Battle.CHUNK_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS
Battle.SECTOR_SIZE_IN_TILES = Battle.SECTOR_SIZE_IN_CHUNKS * Battle.CHUNK_SIZE_IN_TILES
Battle.WORLD_SIZE_IN_SECTORS = 4

function Battle.new(
  battle_factions
)
  local self = {}
  setmetatable(self, Battle)

  self.ui = UiState.new()

  Battle.current = self

  load_all_resources()
  initialize_the_battle_field()

  return self
end

function Battle:update(dt)
  local isMiddleMousePressed = love.mouse.isDown(3) -- Middle mouse button
  local mouseX, mouseY = love.mouse.getPosition()

  self.ui.cam:handleMouseDrag(isMiddleMousePressed, mouseX, mouseY)
  self.ui:apply_wasd_movement(dt)
end


function Battle:draw()
  draw_the_battle_field()
  self.ui:draw_and_handle_unit_selection_with_mouse()
end

function Battle.is(x) return getmetatable(x) == Battle end
function Battle.assert(x) assert(Battle.is(x), "Expected Battle. Got " .. type(x)) end
