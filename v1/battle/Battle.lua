--- @class Battle
local Battle = {
  current = nil,
}
Battle.__index = Battle

Battle.SECTOR_SIZE_IN_CHUNKS = 16
Battle.CHUNK_SIZE_IN_TILES = 16
Battle.TILE_SIZE_IN_PIXELS = 64
Battle.CHUNK_SIZE_IN_PIXELS = Battle.CHUNK_SIZE_IN_TILES * Battle.TILE_SIZE_IN_PIXELS
Battle.SECTOR_SIZE_IN_TILES = Battle.SECTOR_SIZE_IN_CHUNKS * Battle.CHUNK_SIZE_IN_TILES

function Battle.new(
  battle_factions,
  world_size_in_sectors
)
  local self = {}
  setmetatable(self, Battle)

  self.ui = UiState.new()

  for sector_x = 1, world_size_in_sectors do
    for sector_y = 1, world_size_in_sectors do
      Sector.new(sector_x, sector_y)
    end
  end

  return self
end

function Battle.is(x) return getmetatable(x) == Battle end
function Battle.assert(x) assert(Battle.is(x), "Expected Battle. Got " .. type(x)) end

return Battle