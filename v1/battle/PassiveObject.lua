
--- @class PassiveObject body parts, bullets, blood-splatter, debris, crators, fire, smoke
PassiveObject = {
  instances = {},
}

function PassiveObject.update_all(dt)
  for _, passive_object in ipairs(PassiveObject.instances) do
    -- todo: if smoke-claude move a little bit around
    -- todo: progress the timer and maybe remove the passive object
  end
end


function PassiveObject:draw()
  -- todo: draw sprite based on type, if fire, draw animation...
end

