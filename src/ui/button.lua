---@class button
---@field x number
---@field y number
---@field text string
---@field callback function
local button = {}
button.__index = button

function button:new(x, y, text, callback)
  local btn = {
    x = x,
    y = y,
    text = text,
    callback = callback
  }

  return setmetatable(btn, button)
end

return button
