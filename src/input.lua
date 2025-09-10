local input = {
  left     = "a", right = "d",
  jump     = "space",
  interact = 'e',
  unfuse   = 'q',
  slash    = 'f',

  up = 'w',
  down = 's',

  --! Internal! No touchies :3
  __pressed = {}
}

function input:keypressed(key) self.__pressed[key] = true end
function input:keyreleased(key) self.__pressed[key] = nil end

function input:isPressed(key)
  if self.__pressed[key] then
    self.__pressed[key] = nil
    return true
  end

  return false
end

return input
