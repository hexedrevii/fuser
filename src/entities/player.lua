local mapped = require "src.entities.mapped"
local input  = require "src.input"
local mathf  = require "src.mathf"
local playerFuse = require "src.fusions.playerFuse"
local anim       = require "src.anim"
local fuseData   = require "src.fusions.fuseData"

---@class player : mapped
---@field sprite anim
---@field private __getAxis function
---@field private __input function
local player = {}
player.__index = player
setmetatable(player, { __index = mapped })

function player.new(map)
  ---@class player
  local plr = mapped.new(7, 7, map)

  plr.spd = 128
  plr.acc = 700

  plr.jmp = 200

  plr.gravity = 200
  plr.gravitational_pull = 800

  plr.knownFusions = {}
  plr.activeFusion = playerFuse:set(plr)
  plr.sprite = anim:new(love.graphics.newImage(fuseData[plr.activeFusion.id].spritePath), 8, 8, 1)

  plr.interactionBounds = {
    x = plr.x - 8, y = plr.y - 8, w = 24, h = 24
  }

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

  if input:isPressed(input.left) then
    self.sprite.flipH = true
  elseif input:isPressed(input.right) then
    self.sprite.flipH = false
  end
end

function player:fuse(fusion)
  self.activeFusion = fusion:set(self)
  self.sprite =  anim:new(love.graphics.newImage(fuseData[self.activeFusion.id].spritePath), 8, 8, fuseData[self.activeFusion.id].spd)
end

function player:update(delta)
  self.interactionBounds.x = math.floor(self.x - 8)
  self.interactionBounds.y = math.floor(self.y - 8)

  self:__input(delta)
  if not self:isOnFloor() then
    self.vy = mathf.moveTowards(self.vy, self.gravity, self.gravitational_pull * delta)
  else
    if input:isPressed(input.jump) then
      self.vy = -self.jmp
    end
  end

  if input:isPressed(input.unfuse) then
    if self.activeFusion ~= playerFuse then
      self:fuse(playerFuse)
    end
  end

  if self.vx ~= 0 or self.vy ~= 0 then
    self.sprite:update(delta)
  else
    self.sprite:reset()
  end

  self.activeFusion:update(delta)

  self:moveAndSlide(delta)
end

function player:draw()
  self.sprite:draw(math.floor(self.x), math.floor(self.y))

  self.activeFusion:draw()
end

return player
