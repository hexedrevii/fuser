local globals = require "src.globals"
local player  = require "src.entities.player"
local cartographer = require "lib.cartographer"
local game = {
}

function game:init()
  self.entities = {}
  self.map = cartographer.load('assets/maps/world.lua')
  table.insert(self.entities, player.new(self.map))
end

function game:update(delta)
  for _, entity in ipairs(self.entities) do
    entity:update(delta)
  end
end

function game:draw()
  love.graphics.clear(0, 0, 0)
  globals.canvas:set()

  local r,g,b = love.math.colorFromBytes(145, 185, 250);
  love.graphics.clear(r, g, b)

  self.map:draw()

  for _, entity in ipairs(self.entities) do
    entity:draw()
  end

  globals.canvas:renderWorld()
end

return game
