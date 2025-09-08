local globals = require "src.globals"
local game = {}

function game:init()
end

function game:update(delta)
end

function game:draw()
  love.graphics.clear(0, 0, 0)
  globals.canvas:set()

  local r,g,b = love.math.colorFromBytes(145, 185, 250);
  love.graphics.clear(r, g, b)

  globals.canvas:renderWorld()
end

return game
