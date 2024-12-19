--- @class Atlas manages a sprite atlas and its quads; also used to replace colors (units of different factions).
--- @field public image love.ImageData
--- @field public quads table<string, love.Quad>
--- @field public color_replacements table<string, love.Image>
--- @field public REPLACE_COLOR table<number, number, number, number> The default color to replace (magenta)
Atlas = {
  REPLACE_COLOR = Utils.color(255, 0, 255, 1),
  instances = {},
  all = {},
}
Atlas.__index = Atlas

--- Creates a new Atlas object: loads the atlas as image data.
--- @param name string The name of the atlas
--- @param path_to_image string The file path to the image
--- @return Atlas The newly created Atlas object
function Atlas.new(name, path_to_image)
  if type(name) ~= "string" then
    error("Expected 'name' to be a string, got " .. type(name))
  end
  if type(path_to_image) ~= "string" then
    error("Expected 'path_to_image' to be a string, got " .. type(path_to_image))
  end

  local self = {}
  setmetatable(self, Atlas)

  self.image = love.image.newImageData(path_to_image)
  self.quads = {}
  self.color_replacements = {
    unchanged = love.graphics.newImage(self.image),
  }
  self.color_replacements["unchanged"]:setFilter("nearest", "nearest")

  table.insert(Atlas.instances, self)
  Atlas.all[name] = self

  return self
end

--- Replaces a color in the atlas with the specified replacement color.
--- @param color_name string The name of the color replacement
--- @param color table<number, number, number> The RGB values of the color to replace
function Atlas:replace_color_in_atlas(color_name, color)
  if type(color_name) ~= "string" then
    error("Expected 'color_name' to be a string, got " .. type(color_name))
  end
  if type(color) ~= "table" then
    error("Expected 'color' to be a table, got " .. type(color))
  end
  if #color ~= 3 and #color ~= 4 then
    error("Expected 'color' to be a table with 3 or 4 elements (RGB), got " .. #color)
  end
  for i, v in ipairs(color) do
    if type(v) ~= "number" then
      error("Expected color[" .. i .. "] to be a number, got " .. type(v))
    end
  end

  --- Replaces a pixel with the replacement color if it matches the specified color
  --- @param x number The x-coordinate of the pixel
  --- @param y number The y-coordinate of the pixel
  --- @param r number The red component of the pixel's color
  --- @param g number The green component of the pixel's color
  --- @param b number The blue component of the pixel's color
  --- @param a number The alpha component of the pixel's color
  --- @return number The new red, green, blue, and alpha values for the pixel
  local function replace_pixel(x, y, r, g, b, a)
    local _ = x, y
    if r == color[1] and g == color[2] and b == color[3] then
      return Atlas.REPLACE_COLOR[1], Atlas.REPLACE_COLOR[2], Atlas.REPLACE_COLOR[3], Atlas.REPLACE_COLOR[4]
    end
    return r, g, b, a
  end

  local new_image = love.image.newImageData(self.image:getWidth(), self.image:getHeight())
  new_image:mapPixel(replace_pixel)

  self.color_replacements[color_name] = love.graphics.newImage(new_image)
end

--- Registers a new quad (a region from the atlas) for rendering.
--- @param quad_name string The name of the quad
--- @param x number The x-coordinate of the top-left corner of the quad
--- @param y number The y-coordinate of the top-left corner of the quad
--- @param w number The width of the quad
--- @param h number The height of the quad
function Atlas:add_quad(quad_name, x, y, w, h)
  if type(quad_name) ~= "string" then
    error("Expected 'quad_name' to be a string, got " .. type(quad_name))
  end
  if type(x) ~= "number" then
    error("Expected 'x' to be a number, got " .. type(x))
  end
  if type(y) ~= "number" then
    error("Expected 'y' to be a number, got " .. type(y))
  end
  if type(w) ~= "number" then
    error("Expected 'w' to be a number, got " .. type(w))
  end
  if type(h) ~= "number" then
    error("Expected 'h' to be a number, got " .. type(h))
  end

  self.quads[quad_name] = love.graphics.newQuad(x, y, w, h, self.image:getWidth(), self.image:getHeight())
end

--- Draws a quad from the atlas with the specified color replacement.
--- @param quad_name string The name of the quad to draw
--- @param x number The x-coordinate to draw the quad at
--- @param y number The y-coordinate to draw the quad at
--- @param color_name string The name of the color replacement; defaults to 'unchanged'
--- @param rotation number The rotation of the quad (in radians); defaults to 0
--- @param scale_x number The horizontal scale factor; defaults to 1
--- @param scale_y number The vertical scale factor; defaults to 1
function Atlas:draw_quad(quad_name, x, y, color_name, rotation, scale_x, scale_y)
  -- todo: we might need to optimize this function later
  color_name = color_name or "unchanged"
  rotation = rotation or 0
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  if type(quad_name) ~= "string" then
    error("Expected 'quad_name' to be a string, got " .. type(quad_name))
  end
  if type(x) ~= "number" then
    error("Expected 'x' to be a number, got " .. type(x))
  end
  if type(y) ~= "number" then
    error("Expected 'y' to be a number, got " .. type(y))
  end
  if type(color_name) ~= "string" then
    error("Expected 'color_name' to be a string, got " .. type(color_name))
  end
  if type(rotation) ~= "number" then
    error("Expected 'rotation' to be a number, got " .. type(rotation))
  end
  if type(scale_x) ~= "number" then
    error("Expected 'scale_x' to be a number, got " .. type(scale_x))
  end
  if type(scale_y) ~= "number" then
    error("Expected 'scale_y' to be a number, got " .. type(scale_y))
  end

  -- Ensure the quad exists
  local quad = self.quads[quad_name]
  if not quad then
    error("Quad not found: " .. quad_name)
  end

  -- Ensure the color replacement exists, fallback to 'unchanged' if not found
  local color_image = self.color_replacements[color_name]
  if not color_image then
    error("Color replacement not found: " .. color_name)
  end

  -- Draw the quad with the appropriate color replacement
  love.graphics.setColor(1, 1, 1)  -- Reset color to white for the drawing
  love.graphics.draw(color_image, quad, x, y, rotation, scale_x, scale_y)
end


function Atlas.is(x) return getmetatable(x) == Atlas end
function Atlas.assert(x) assert(Atlas.is(x), "Expected Atlas. Got " .. type(x)) end
