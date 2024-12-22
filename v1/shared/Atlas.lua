--- @class Atlas manages a sprite atlas and its quads; also used to replace colors (units of different factions).
--- @field public image love.ImageData
--- @field public quads table<string, love.Quad>
--- @field public color_replacements table<string, love.Image>
--- @field public REPLACE_COLOR table<number, number, number, number> The default color to replace (magenta)
Atlas = {
  REPLACE_COLOR = Utils.color(255, 255, 255, 1),
  instances = {},
  --- @type table<string, Atlas>
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

  self.path_to_image = path_to_image
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
--- @param color table<number, number, number> The RGB (or RGBA) values of the color to replace
function Atlas:replace_color_in_atlas(color_name, color)
  -- Check input types
  if type(color_name) ~= "string" then
    error("Expected 'color_name' to be a string, got " .. type(color_name))
  end
  if type(color) ~= "table" then
    error("Expected 'color' to be a table, got " .. type(color))
  end
  if #color ~= 3 and #color ~= 4 then
    error("Expected 'color' to be a table with 3 (RGB) or 4 (RGBA) elements, got " .. #color)
  end
  for i, v in ipairs(color) do
    if type(v) ~= "number" then
      error("Expected color[" .. i .. "] to be a number, got " .. type(v))
    end
  end

  -- Check that the color replacement value is defined
  if not Atlas.REPLACE_COLOR then
    error("Atlas.REPLACE_COLOR is not defined")
  end

  local replace_r, replace_g, replace_b = Atlas.REPLACE_COLOR[1], Atlas.REPLACE_COLOR[2], Atlas.REPLACE_COLOR[3]
  local replace_a = Atlas.REPLACE_COLOR[4] or 1  -- If Atlas.REPLACE_COLOR doesn't have an alpha, assume it's 1.

  -- Function to replace the pixel color if it matches the target color
  local function replace_pixel(x, y, r, g, b, a)
    local _ = x, y
    -- Check if the pixel color matches the color to replace
    if r == replace_r and g == replace_g and b == replace_b and (a == replace_a or replace_a == 1) then
      -- Replace color, preserving alpha (if RGBA)
      if #color == 4 then
        return color[1], color[2], color[3], color[4]
      else
        return color[1], color[2], color[3], a  -- Preserve original alpha if RGB
      end
    end
    return r, g, b, a
  end

  -- Create a new image to store the replaced pixels
  local new_image_data = love.image.newImageData(self.path_to_image)
  new_image_data:mapPixel(replace_pixel)

  -- Store the replaced image under the given color_name
  self.color_replacements[color_name] = love.graphics.newImage(new_image_data)
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
--- @param center boolean Whether to center the quad; defaults to false
function Atlas:draw_quad(quad_name, x, y, color_name, rotation, scale_x, scale_y, center)
  -- todo: we might need to optimize this function later
  color_name = color_name or "unchanged"
  ignore_centering = ignore_centering or false
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
  if type(color_name) ~= "string" or type(color_name) == "table" then
    error("Expected 'color_name' to be a string or a table, got " .. type(color_name))
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
  local _y,_y,w,h = quad:getViewport()
  if not center then
    love.graphics.draw(color_image, quad, x, y, rotation, scale_x, scale_y)
  else
    love.graphics.draw(color_image, quad, x, y, rotation, scale_x, scale_y, w/2, h/2)
  end
end


function Atlas.is(x) return getmetatable(x) == Atlas end
function Atlas.assert(x) assert(Atlas.is(x), "Expected Atlas. Got " .. type(x)) end
