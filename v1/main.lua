
require "shared/Culture"
require "shared/UnitClass"
require "shared/Division"
require "shared/DivisionTemplate"
require "shared/Utils"
require "shared/Atlas"

require "battle/Battle"
require "battle/BattleFaction"
require "battle/Camera"
require "battle/Chunk"
require "battle/Sector"
require "battle/Squad"
require "battle/Tile"
require "battle/UiState"
require "battle/Unit"

require "battle/functions/initialize_the_battle_field"
require "battle/functions/load_all_resources"
require "battle/functions/draw_the_battle_field"


Battle.new({}, 4)

function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  Battle.current:update(dt)
end

function love.draw()
  Battle.current:draw()
end

-- apply zoom in and out
function love.wheelmoved(x, y)
  if y > 0 then
    Battle.current.ui.cam:zoomBy(0.06)
  elseif y < 0 then
    if Battle.current.ui.cam.zoom > 0.1 then
      Battle.current.ui.cam:zoomBy(-(Battle.current.ui.cam.zoom/10))
    end
    Battle.current.ui.cam:zoomBy(-0.06)
  end
end