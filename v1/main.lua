
local Battle = require("v1/battle/Battle")

Battle.new({}, 4)

function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.print("Hello World!", 400, 300)
end