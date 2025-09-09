local world = require "src.world.world"
local game  = require "src.world.game"
local input = require "src.input"

function love.load()
  -- Better randomness
  math.randomseed(os.time())

  -- Pixel art game
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.graphics.setNewFont('assets/pico-8.otf', 6)

  world:set(game)
end

function love.update(delta)
  world:update(delta)
end

function love.draw()
  world:draw()
end

function love.keypressed(key)
  input:keypressed(key)
end

function love.keyreleased(key)
  input:keyreleased(key)
end
