local buttonController = require "src.ui.buttonController"
local globals          = require "src.globals"
local cartographer     = require "lib.cartographer"
local intro            = require "src.world.intro"
local world            = require "src.world.world"
local game             = require "src.world.game"

local mainMenu = {}

function mainMenu:init()
  self.map = cartographer.load('assets/maps/background.lua')

  self.buttons = buttonController:new()

  self.buttons:pushNewButton(54, 70, 'play', function()
    if not globals.introPlayed then
      world:set(intro)
    else
      world:set(game)
    end
  end)

  self.buttons:pushNewButton(54, 80, 'quit', function()
    love.event.quit(0)
  end)
end

function mainMenu:update(delta)
  self.buttons:update(delta)
end

function mainMenu:draw()
  love.graphics.setColor(1,1,1)

  love.graphics.clear(0, 0, 0)
  globals.canvas:set()

  love.graphics.clear(globals.palette.lightGreen)

  self.map:draw()

  self.buttons:draw()

  love.graphics.setColor(globals.palette.lighYellow)
  love.graphics.setFont(globals.fontHuge)
  love.graphics.print('fuser', 44, 20)
  love.graphics.setFont(globals.font)
  love.graphics.setColor(1,1,1)

  love.graphics.setColor(globals.palette.lighYellow[1], globals.palette.lighYellow[2], globals.palette.lighYellow[3], 0.3)
  love.graphics.print('navigate: w/s accept: space', 1, 120)
  love.graphics.setColor(1,1,1)

  globals.canvas:renderWorld()
end

return mainMenu
