Utils = {}

function Utils.color(r, g, b, a)
  return { r / 255, g / 255, b / 255, a or 1 }
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

function Utils.find(table, value)
  for i, v in ipairs(table) do if v == value then return i end end
  return nil
end

--- Returns a string representation of a table.
--- @param tbl table The table to convert to a string
--- @param visited table|nil A table to keep track of visited tables
function Utils.str_table(tbl, visited)

  if type(tbl) ~= "table" then
    return tostring(tbl)
  end

  visited = visited or {}

  if visited[tbl] then
    return '"recursive"'
  end

  visited[tbl] = true

  -- Check if the table has a metatable with a name
  local mt = getmetatable(tbl)
  if mt and mt.__name then
    return string.format('"%s"', mt.__name or "unknown-meta-table")
  end

  local result = "{"
  for k, v in pairs(tbl) do
    local keyStr = tostring(k)
    local valueStr = Utils.str_table(v, visited)
    result = result .. string.format("[%s] = %s, ", keyStr, valueStr)
  end

  result = result .. "}"
  visited[tbl] = nil

  return result
end