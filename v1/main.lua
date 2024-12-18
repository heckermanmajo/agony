
function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.print("Hello World!", 400, 300)
end