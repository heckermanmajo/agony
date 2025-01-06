--- @class Army
--- @field command_points number
--- @field campaign_tile CampTile
--- @field moved_this_turn boolean
--- @field owner FactionState
--- @field spawn_queue table<SquadTemplate> used in the battle to spawn units
--- @field _dead_ boolean if this is true, the army is not in the campaign anymore; used for debug state checks
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
  self._dead_ = false
  table.insert(Army.instances, self)
  return self
end

function Army:draw()
  local tile = self.campaign_tile
  -- draw the command_points and in faction color
  local owner_of_tile = tile.owner

  -- draw a colored rect behind the command points
  love.graphics.setColor(0.6, 0.6, 0.6, 1)
  love.graphics.rectangle("fill", tile.x * 128, tile.y * 128, 70, 40)
  if owner_of_tile then
    love.graphics.setColor(owner_of_tile.faction.color)
    if owner_of_tile.faction.color_name == "red" then
      love.graphics.setColor(0.4, 0, 0)
    end
  else
    love.graphics.setColor(0.5, 0.5, 0.5)
  end
  love.graphics.print(self.command_points, tile.x * 128 + 10, tile.y * 128 + 10)

  if not self.moved_this_turn then
    love.graphics.setColor(0, 1, 0)
  else
    love.graphics.setColor(0.3, 0.3, 0.3)
  end
  love.graphics.rectangle("line", tile.x * 128, tile.y * 128, 70, 40)


end

--- Move the army to a new tile.
function Army:move(direction)
  Army.assert(self)

  if type(direction) == "string" then
    assert(direction == "up" or direction == "down" or direction == "left" or direction == "right")
  else
    assert(CampTile.is(direction))
    local neighbours = self.campaign_tile:get_neighbours()
    local found = false
    for _, n in ipairs(neighbours) do
      if n == direction then
        found = true
        break
      end
    end
    assert(found, "The direction is not a neighbour of the current tile")
    -- find the direction
    if direction.y < self.campaign_tile.y then direction = "up"
    elseif direction.y > self.campaign_tile.y then direction = "down"
    elseif direction.x < self.campaign_tile.x then direction = "left"
    elseif direction.x > self.campaign_tile.x then direction = "right"
    end
  end

  local target = nil
  do
    if direction == "up" then target = self.campaign_tile:get_top_neighbour() end
    if direction == "down" then target = self.campaign_tile:get_bottom_neighbour() end
    if direction == "left" then target = self.campaign_tile:get_left_neighbour() end
    if direction == "right" then target = self.campaign_tile:get_right_neighbour() end
    if target == nil then
      print("No target found; returning")
      return end
  end

  -- if the target tile is my army: merge
  -- if the target tile is an enemy army: fight
  -- if the target tile is empty: move (also change owner)

  if target.army then

    if target.army.owner == self.owner then
      -- merge and then move

      self.command_points = self.command_points + target.army.command_points
      local other_army = target.army
      self.campaign_tile.army = nil
      target.owner = self.owner
      assert(self)
      print(Utils.str_table(self))
      target.army = self
      other_army.campaign_tile = nil
      self.campaign_tile = target
      -- NOTE: we dont do this within an army loop
      for i, a in ipairs(Army.instances) do
        if a == other_army then
          table.remove(Army.instances, i)
          break
        end
      end


    else
      -- fight

      local is_some_faction_player = target.army.owner.is_player or self.owner.is_player
      if is_some_faction_player then

        -- start a battle
        Battle.new({
          self,
          target.army,
        })

        MODE = "battle" -- next frame will be in battle mode

      else
        -- auto-fight
        do

          -- auto calc: just simple minus
          local my_command_points = self.command_points
          local other_command_points = target.army.command_points
          local diff = my_command_points - other_command_points
          local armies_to_remove = {}
          if diff > 0 then
            -- i win; other army is removed
            self.command_points = diff
            table.insert(armies_to_remove, target.army)
          elseif diff < 0 then
            -- i lose; my army is removed
            target.army.command_points = -diff
            table.insert(armies_to_remove, self)
          else
            table.insert(armies_to_remove, self)
            table.insert(armies_to_remove, target.army)
          end

          for _, a in ipairs(armies_to_remove) do
            a.campaign_tile.army = nil
            a.campaign_tile = nil
            for i, a2 in ipairs(Army.instances) do
              if a2 == a then
                table.remove(Army.instances, i)
                break
              end
            end
          end

        end -- auto calc

      end

    end -- fight

  else
    -- move (and conquer) if tile is not occupied by another army
    self.campaign_tile.army = nil
    target.army = self
    self.campaign_tile = target
    target.owner = self.owner
  end

  self.moved_this_turn = true

end -- of move


function Army:delete_me_from_campaign()
  Army.assert(self)
  self.campaign_tile.army = nil
  self.campaign_tile = nil
  self.owner = nil
  self._dead_ = true
  for i, a in ipairs(Army.instances) do
    if a == self then
      table.remove(Army.instances, i)
      break
    end
  end
end

function Army.is(x) return getmetatable(x) == Army end
function Army.assert(x) assert(Army.is(x), "Expected Army. Got " .. type(x)) end
