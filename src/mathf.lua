local mathf = {}

---@param from number
---@param to number
---@param delta number
---@return number
function mathf.moveTowards(from, to, delta)
  if math.abs(to - from) <= delta then
    return to
  end

  return from + mathf.sign(to - from) * delta
end

---@param x number
function mathf.sign(x)
  if x < 0 then
    return -1
  elseif x > 0 then
    return 1
  else
    return 0
  end
end

function mathf.colRect(rect1, rect2)
  return rect1.x < rect2.x + rect2.w and
    rect1.x + rect1.w > rect2.x and
    rect1.y < rect2.y + rect2.h and
    rect1.y + rect1.h > rect2.y
end

---Returns a float between two numbers
---@param min number
---@param max number
---@return number
function mathf.random(min, max)
  return min + (max - min) * math.random()
end

return mathf
