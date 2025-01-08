--- @class PassiveObject body parts, bullet-strain, blood-splatter, debris, crators, fire, smoke
PassiveObject = {
  instances = {},
}
PassiveObject.__index = PassiveObject

--- Called for example when a unit dies or an explosion happens.
--- @param object_type string
--- @return PassiveObject
function PassiveObject.new(object_type, x, y)

  local self = {}
  setmetatable(self, PassiveObject)

  self.x = x
  self.y = y

  if (
    object_type == "bone" or
    object_type == "blood" or
    object_type == "gore" or
    object_type == "burnt_remains"
  ) then
    self.w = 16
    self.h = 16
    local BASE_TIMER = 10
    self.timer_til_removal = BASE_TIMER + math.random(-BASE_TIMER * 0.2, BASE_TIMER * 0.2)
    self.rotation = math.random(0, 360)
    self.on_ground = true
    self.atlas = "blood_and_gore"
    self.sprite = object_type .. "_" .. math.random(1, 4)
  end

  if object_type == "explosion" then
    self.on_ground = false -- an explosion should hide the stuff beneath
    self.atlas = "explosion_and_fire"
    -- todo: implement the explosion
  end

  if object_type == "smoke" then
    self.on_ground = false -- smoke should hide stuff beneath
    self.atlas = "smoke"
    -- todo: implement the smoke
  end

  if object_type == "fire" then
    self.on_ground = false -- fire should hide stuff beneath
    -- todo: implement the fire
    -- todo: fire needs animations
    -- we can use the dynamic nature of lue to fix the need for animations in this fire case ...
  end

  if object_type == "debris" then
    self.on_ground = true
    self.atlas = "debris"
    -- todo: implement the debris
  end

  if object_type == "crater" then
    self.on_ground = true
    self.atlas = "crater"
    -- todo: implement the crater
  end

  assert(self.atlas, "Bad input to PassiveObject.new: " .. object_type)
  assert(self.timer_til_removal, "Bad input to PassiveObject.new: " .. object_type)
  assert(self.sprite, "Bad input to PassiveObject.new: " .. object_type)
  assert(type(self.rotation) == "number", "Bad input to PassiveObject.new: " .. object_type)
  assert(type(self.w) == "number", "Bad input to PassiveObject.new: " .. object_type)
  assert(type(self.h) == "number", "Bad input to PassiveObject.new: " .. object_type)

  self.object_type = object_type

  table.insert(PassiveObject.instances, self)

  return self

end

function PassiveObject.update_all(dt)
  local indexes_to_remove = {}
  for index, passive_object in ipairs(PassiveObject.instances) do
    -- todo: if smoke-claude move a little bit around

    -- progress the timer and maybe remove the passive object
    do
      passive_object.timer_til_removal = passive_object.timer_til_removal - dt
      if passive_object.timer_til_removal < 0 then
        table.insert(indexes_to_remove, index)
        passive_object.dead = true
      end
    end


  end

  for i = #indexes_to_remove, 1, -1 do
    table.remove(PassiveObject.instances, indexes_to_remove[i])
  end

end

function PassiveObject:draw()
  -- todo: draw sprite based on type, if fire, draw animation...
  local is_in_view = Battle.current.ui.cam:rectInView(self.x, self.y, self.w, self.h)
  if not is_in_view then return end
  love.graphics.setColor(1, 1, 1)
  local replace_color = "unchanged"
  local scale_x = 1
  local scale_y = 1
  Atlas.all[self.atlas]:draw_quad(self.sprite, self.x, self.y, replace_color, self.rotation, scale_x, scale_y)
end

