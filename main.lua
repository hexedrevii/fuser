local world = require "src.world.world"
local game  = require "src.world.game"

function love.load()
  world:set(game)
end

function love.update(delta)
  world:update(delta)
end

function love.draw()
  world:draw()
end
