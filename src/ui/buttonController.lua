local button = require "src.ui.button"
local input  = require "src.input"
local globals= require "src.globals"

---@class buttonController
---@field elements button[]
---@field activeIdx number
local buttonController = {}
buttonController.__index = buttonController

function buttonController:new()
  local controller = {
    elements = {},
    activeIdx = 1,
  }

  return setmetatable(controller, buttonController)
end

function buttonController:pushNewButton(x, y, text, callback)
  table.insert(self.elements, button:new(x, y, text, callback))
end

function buttonController:update(delta)
  if #self.elements == 0 then return end

  if input:isPressed(input.up) then
    self.activeIdx = self.activeIdx - 1
    if self.activeIdx < 1 then
      self.activeIdx = 1
    end
  end

  if input:isPressed(input.down) then
    self.activeIdx = self.activeIdx + 1
    if self.activeIdx > #self.elements then
      self.activeIdx = #self.elements
    end
  end

  if input:isPressed(input.jump) then
    local btn = self.elements[self.activeIdx]

    btn:callback()
  end
end

function buttonController:draw()
  for idx, btn in ipairs(self.elements) do
    if idx == self.activeIdx then
      love.graphics.setColor(globals.palette.orange)
    else
      love.graphics.setColor(globals.palette.lighYellow)
    end

    love.graphics.print(btn.text, btn.x, btn.y)

    love.graphics.setColor(1,1,1)
  end
end

return buttonController
