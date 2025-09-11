local globals  = require "src.globals"
local input    = require "src.input"
local world    = require "src.world.world"

local final = {
  deaths = 0,
}

function final:setData(deaths, startTime, endTime)
  local diff = endTime - startTime

  local minutes = math.floor(diff / 60)
  local seconds = math.floor(diff % 60)

  self.time = string.format("%02d:%02d", minutes, seconds)
  self.deaths = deaths
end

function final:init()
  love.graphics.setFont(globals.font)
end

function final:update(delta)
  if input:isPressed(input.jump) then
    -- LAZY LOADING RAAAAAAAAAAAAAAAAH
    local mainMenu = require "src.world.mainMenu"
    world:set(mainMenu)
  end
end

function final:draw()
  love.graphics.clear(0,0,0)

  globals.canvas:set()
  love.graphics.clear(globals.palette.darkPurple)

  love.graphics.setColor(globals.palette.lighYellow)
    love.graphics.print('congrats!', 50, 10)
    love.graphics.print('you found your sister!', 23, 20)

    love.graphics.print('deaths: ' .. self.deaths, 5, 50)
    love.graphics.print('time: ' .. self.time, 5, 60)
    love.graphics.print(input.jump .. ' to return to menu', 2, 120)
  love.graphics.setColor(1,1,1)

  globals.canvas:renderWorld()
end

return final
