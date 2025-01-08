

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
    atlas:add_quad("water", 5*64, 1*64, 64, 64)
    atlas:add_quad("gras", 5*64, 2*64, 64, 64)
  end

  do
    local atlas = Atlas.new("blood_and_gore", "assets/blood_and_gore.png")
    atlas:add_quad("bone_1", 16*0, 16*0, 16, 16)
    atlas:add_quad("bone_2", 16*1, 16*0, 16, 16)
    atlas:add_quad("bone_3", 16*2, 16*0, 16, 16)
    atlas:add_quad("bone_4", 16*3, 16*0, 16, 16)
    atlas:add_quad("bone_5", 16*4, 16*0, 16, 16)
    atlas:add_quad("bone_6", 16*5, 16*0, 16, 16)
    atlas:add_quad("bone_7", 16*6, 16*0, 16, 16)
    atlas:add_quad("bone_8", 16*7, 16*0, 16, 16)

    atlas:add_quad("blood_1", 16*0, 16*1, 16, 16)
    atlas:add_quad("blood_2", 16*1, 16*1, 16, 16)
    atlas:add_quad("blood_3", 16*2, 16*1, 16, 16)
    atlas:add_quad("blood_4", 16*3, 16*1, 16, 16)
    atlas:add_quad("blood_5", 16*4, 16*1, 16, 16)
    atlas:add_quad("blood_6", 16*5, 16*1, 16, 16)
    atlas:add_quad("blood_7", 16*6, 16*1, 16, 16)
    atlas:add_quad("blood_8", 16*7, 16*1, 16, 16)

    atlas:add_quad("gore_1", 16*0, 16*2, 16, 16)
    atlas:add_quad("gore_2", 16*1, 16*2, 16, 16)
    atlas:add_quad("gore_3", 16*2, 16*2, 16, 16)
    atlas:add_quad("gore_4", 16*3, 16*2, 16, 16)
    atlas:add_quad("gore_5", 16*4, 16*2, 16, 16)
    atlas:add_quad("gore_6", 16*5, 16*2, 16, 16)
    atlas:add_quad("gore_7", 16*6, 16*2, 16, 16)
    atlas:add_quad("gore_8", 16*7, 16*2, 16, 16)

    atlas:add_quad("burnt_remains_1", 16*0, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_2", 16*1, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_3", 16*2, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_4", 16*3, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_5", 16*4, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_6", 16*5, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_7", 16*6, 16*3, 16, 16)
    atlas:add_quad("burnt_remains_8", 16*7, 16*3, 16, 16)
  end

  -- fire and smoke
  do
    local atlas = Atlas.new("fire_and_smoke", "assets/FireAndSmoke.png")
    atlas:add_quad("smoke_1", 32*0, 32*0, 32, 32)
    atlas:add_quad("fire_1", 32*0, 32*1, 32, 32)
  end

end