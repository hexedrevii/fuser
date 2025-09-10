local cartographer = require "lib.cartographer"
local globals      = require "src.globals"
local cover = {}

function cover:init()
  self.bg = cartographer.load('assets/maps/background.lua')

  love.graphics.setNewFont('assets/pico-8.otf', 18)
end

function cover:update(delta)

end

function cover:draw()
  love.graphics.setColor(1,1,1)
  love.graphics.clear(0,0,0)

  globals.canvas:set()
  love.graphics.clear(globals.palette.lighYellow)

  self.bg:draw()

  love.graphics.setColor(globals.palette.darkPurple)
  love.graphics.print('fuser', 36 ,30)
  love.graphics.setColor(1,1,1)

  globals.canvas:renderWorld()
end

return cover
