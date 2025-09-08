local world = {
  active = nil
}

function world:set(new)
  self.active = new

  if new.init ~= nil then
    new:init()
  end
end

function world:update(delta)
  if self.active ~= nil then
    self.active:update(delta)
  end
end

function world:draw()
  if self.active ~= nil then
    self.active:draw()
  end
end

return world
