
--- @class Army
--- @field command_points number
--- @field campaign_tile CampTile
--- @field moved_this_turn boolean
--- @field owner FactionState
--- @field spawn_queue table<SquadTemplate> used in the battle to spawn units
Army = {
  instances = {},
}
Army.__index = Army

function Army.new(command_points, ct)
  local self = setmetatable({}, Army)
  self.command_points = command_points
  self.campaign_tile = ct
  self.spawn_queue = {}
  self.owner = ct.owner
  self.moved_this_turn = false
  table.insert(Army.instances, self)
  return self
end

function Army:draw()
  local tile = self.campaign_tile
  -- draw the command_points and in faction color
  local owner_of_tile = tile.owner

  -- draw a colored rect behind the command points
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", tile.x * 128, tile.y * 128, 50, 40)
  if owner_of_tile then
    love.graphics.setColor(owner_of_tile.faction.color)
  else
    love.graphics.setColor(0.5, 0.5, 0.5)
  end
  love.graphics.print(self.command_points, tile.x * 128+10, tile.y * 128+10)
end

-- todo: army movement
-- todo: get user input for army movement

function Army.is(x) return getmetatable(x) == Army end
function Army.assert(x) assert(Army.is(x), "Expected Army. Got " .. type(x)) end
