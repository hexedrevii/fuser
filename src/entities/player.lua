local mapped = require "src.entities.mapped"
local input  = require "src.input"
local mathf  = require "src.mathf"

---@class player : mapped
---@field sprites love.Image[]
---@field sprite love.Image
local player = {}
player.__index = player
setmetatable(player, { __index = mapped })

function player.new(map)
  ---@class player
  local plr = mapped.new(7, 7, map)

  plr.sprites = {
    love.graphics.newImage('assets/player/player_one.png')
  }

  plr.spd = 100
  plr.acc = 700

  plr.jmp = 200

  plr.gravity = 200
  plr.gravitational_pull = 800

  plr.sprite = plr.sprites[1]

  if plr.map then
    plr:pushLayer(plr.map.layers.solids)
  end

  return setmetatable(plr, player)
end

function player:__getAxis(negative, positive)
  if love.keyboard.isDown(negative) and love.keyboard.isDown(positive) then
    return 0
  end

  if love.keyboard.isDown(negative)     then return -1
  elseif love.keyboard.isDown(positive) then return  1 end

  return 0
end

function player:__input(delta)
  local dir = self:__getAxis(input.left, input.right)
  self.vx = mathf.moveTowards(self.vx, dir * self.spd, self.acc * delta)
end

function player:update(delta)
  self:__input(delta)
  if not self:isOnFloor() then
    self.vy = mathf.moveTowards(self.vy, self.gravity, self.gravitational_pull * delta)
  else
    if input:isPressed(input.jump) then
      self.vy = -self.jmp
    end
  end

  self:moveAndSlide(delta)
end

function player:draw()
  love.graphics.draw(self.sprite, math.floor(self.x), math.floor(self.y))
end

return player
