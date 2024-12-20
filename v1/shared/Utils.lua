Utils = {}

function Utils.color(r, g, b, a)
  return {r/255, g/255, b/255, a or 1}
end

--- Checks if the mouse is over a rectangle.
--- @param x number The x-coordinate of the rectangle
--- @param y number The y-coordinate of the rectangle
--- @param width number The width of the rectangle
--- @param height number The height of the rectangle
--- @param cam Camera|nil The camera to use for the transformation from screen to world coordinates
function Utils.mouse_is_over(x, y, width, height, cam)
  local mx, my
  if cam ~= nil then mx, my = cam:transform_screen_xy_to_world_xy(love.mouse.getPosition())
  else mx, my = love.mouse.getPosition() end
  return mx >= x and mx <= x + width and my >= y and my <= y + height
end