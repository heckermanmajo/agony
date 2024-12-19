

function load_all_resources()

  do
    local atlas = Atlas.new("mp_soldier", "assets/soldiers_gray.png")
    atlas:add_quad("mp_soldier", 0, 0, 64, 64)
    atlas:replace_color_in_atlas("green", Utils.color(0, 255, 0))
    atlas:replace_color_in_atlas("blue", Utils.color(0, 0, 255))
    atlas:replace_color_in_atlas("red", Utils.color(255, 0, 0))
  end

  do
    local atlas = Atlas.new("map_tiles", "assets/Tileset.png")
    atlas:add_quad("gras", 5*64, 2*64, 64, 64)
  end

end