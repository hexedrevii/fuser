local world   = require "src.world.world"
local game    = require "src.world.game"
local input   = require "src.input"
local flow    = require 'src.flowControl'
local manager = require 'lib.LoveDialogue.PluginManager'
local globals = require 'src.globals'
local mainMenu= require 'src.world.mainMenu'
local introControl = require 'src.introControl'

function love.load()
  -- Better randomness
  math.randomseed(os.time())

  -- Pixel art game
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- Set font for drawing
  love.graphics.setNewFont('assets/pico-8.otf', 6)

  -- Set plugins for dialogue
  manager:register(flow)
  manager:register(introControl)

  world:set(game)
  --world:set(mainMenu)
end

function love.update(delta)
  world:update(delta)
end

function love.draw()
  world:draw()
end

function love.keypressed(key)
  input:keypressed(key)

  if globals.dialogue then
    globals.dialogue:keypressed(key)
  end
end

function love.keyreleased(key)
  input:keyreleased(key)
end
