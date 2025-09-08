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

return mathf
