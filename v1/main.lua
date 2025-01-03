--- @type boolean Allows to enable or disable debug mode; state checks, type checks, etc.
DEBUG = true

require "shared/Utils"
require "shared/Atlas"
require "shared/Camera"

require "battle/Battle"
require "battle/Chunk"
require "battle/Sector"
require "battle/Tile"
require "battle/UiState"
require "battle/Unit"
require "battle/Projectile"
require "battle/PassiveObject"

require "battle/functions/initialize_the_battle_field"
require "battle/functions/load_all_resources"
require "battle/functions/draw_the_battle_field"
--require "battle/functions/create_formation"
require "battle/functions/spawn_management"
require "battle/functions/ai_management"
require "battle/functions/end_battle_condition_check"

require "camp/Army"
require "camp/Camp"
require "camp/CampTile"
require "camp/FactionState"

require "camp/functions/next_round_progression"
require "camp/functions/handle_ai_movements"
require "camp/functions/camp_draw"

require "data/type_hints" -- also contains check functions that are used for checking

require "data/factions/french_republic/FrenchRepublic"

require "data/factions/russian_empire/RussianEmpire"

-- note: squads need to be loaded before the faction, and soldiers need to be loaded before the squads
require "data/factions/german_empire/GermanLightSoldier"
require "data/factions/german_empire/GermanEmpire_Squad1_LightInfantry"
require "data/factions/german_empire/GermanEmpire_Squad2_MotorizedInfantry"
require "data/factions/german_empire/GermanEmpire"


Camp.new()
-- temporary test battle
Battle.new({
  Army.new(100, CampTile.new(-1,-1,"water",FactionState.instances[1])),
  Army.new(100, CampTile.new(-1,-2,"water",FactionState.instances[2]))
})

MODE = "camp"

function love.keypressed(key)
  if key == "tab" then
    if MODE == "camp" then
      MODE = "battle"
    else
      MODE = "camp"
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("escape") then love.event.quit() end
  if MODE == "camp" then Camp.current:update(dt)
  else Battle.current:update(dt) end
end

local canvas = love.graphics.newCanvas()
function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  if MODE == "camp" then
    Camp.current:draw()
  else
    Battle.current:draw()
  end
  -- Draw everything here
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0, zoom, zoom)
end

-- apply zoom in and out
function love.wheelmoved(x, y)
  if MODE == "camp" then
    if y > 0 then
      Camp.current.cam:zoomBy(0.06)
    elseif y < 0 then
      if Camp.current.cam.zoom > 0.1 then
        Camp.current.cam:zoomBy(-(Camp.current.cam.zoom / 10))
      end
      Camp.current.cam:zoomBy(-0.06)
    end
  else
    if y > 0 then
      Battle.current.ui.cam:zoomBy(0.06)
    elseif y < 0 then
      if Battle.current.ui.cam.zoom > 0.1 then
        Battle.current.ui.cam:zoomBy(-(Battle.current.ui.cam.zoom / 10))
      end
      Battle.current.ui.cam:zoomBy(-0.06)
    end
  end
end