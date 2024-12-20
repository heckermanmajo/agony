
require "shared/Utils"
require "shared/Atlas"

require "battle/Battle"
require "battle/Camera"
require "battle/Chunk"
require "battle/Sector"
require "battle/Tile"
require "battle/UiState"
require "battle/Unit"

require "battle/functions/initialize_the_battle_field"
require "battle/functions/load_all_resources"
require "battle/functions/draw_the_battle_field"

require "camp/Army"
require "camp/Camp"
require "camp/CampTile"
require "camp/FactionState"

require "data/factions/french_republic/FrenchRepublic"

require "data/factions/russian_empire/RussianEmpire"

require "data/factions/german_empire/GermanEmpire"
require "data/factions/german_empire/GermanLightSoldier"
require "data/factions/german_empire/GermanEmpire_Squad1_LightInfantry"
require "data/factions/german_empire/GermanEmpire_Squad2_MotorizedInfantry"

Battle.new({}, 4)
Camp.new()

local mode = "camp"

function love.keypressed(key)
  if key == "tab" then
    if mode == "camp" then
      mode = "battle"
    else
      mode = "camp"
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("escape") then love.event.quit() end
  if mode == "camp" then Camp.current:update(dt)
  else Battle.current:update(dt) end
end

function love.draw()
  if mode == "camp" then
    Camp.current:draw()
  else
    Battle.current:draw()
  end
end

-- apply zoom in and out
function love.wheelmoved(x, y)
  if mode == "camp" then
    if y > 0 then
      Camp.current.cam:zoomBy(0.06)
    elseif y < 0 then
      if Camp.current.cam.zoom > 0.1 then
        Camp.current.cam:zoomBy(-(Camp.current.cam.zoom/10))
      end
      Camp.current.cam:zoomBy(-0.06)
    end
  else
    if y > 0 then
      Battle.current.ui.cam:zoomBy(0.06)
    elseif y < 0 then
      if Battle.current.ui.cam.zoom > 0.1 then
        Battle.current.ui.cam:zoomBy(-(Battle.current.ui.cam.zoom/10))
      end
      Battle.current.ui.cam:zoomBy(-0.06)
    end
  end
end