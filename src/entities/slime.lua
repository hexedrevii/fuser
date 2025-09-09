local mapped = require "src.entities.mapped"
local timer  = require "src.timer"
local mathf  = require "src.mathf"
local slimeFuse = require "src.fusions.slimeFuse"
local anim      = require "src.anim"

---@class slime : mapped
---@field player player
local slime = {}
slime.__index = slime
setmetatable(slime, { __index = mapped })

function slime.new(x, y, player, map)
  ---@class slime
  local s = mapped.new(7, 7, map)
  s:pushLayer(map.layers.solids)

  s.sprite = anim:new(
    love.graphics.newImage('assets/entities/slime.png'),
    8, 8, 0.25
  )

  s.hp = 3

  s.player = player
  s.x = x
  s.y = y

  s.dir = 0
  s.moveTime = nil

  s.spd = 50
  s.acc = 600

  s.gravity = 200
  s.gravitational_pull = 800

  s.fuse = slimeFuse

  s.state = 'wandering'

  s.moveTimer = timer:new(1.5, function ()
    -- Frog has a 1/2 chance to move
    if math.random(2) == 2 then
      -- It picks a direction
      local dirChance = math.random(1, 2)
      if dirChance == 1 then
        s.sprite.flipH = false
        s.dir = 1
      else
        s.sprite.flipH = true
        s.dir = -1
      end

      -- It also picks a random amount of time to move
      -- Between 1.5 and 2 seconds
      s.moveTime = mathf.random(1.5, 2)
    end
  end, false)

  return setmetatable(s, slime)
end

function slime:update(delta)
  if self.state == 'wandering' then
    self.moveTimer:update(delta)

    if self.moveTime then
      self.moveTime = self.moveTime - delta
      if self.moveTime <= 0 then
        self.moveTime = nil
      end

      self.vx = mathf.moveTowards(self.vx, self.spd * self.dir, self.acc * delta)
    else
      self.vx = 0
    end
  end

  if not self:isOnFloor() then
    self.vy = mathf.moveTowards(self.vy, self.gravity, self.gravitational_pull * delta)
  end

  if self.vx ~= 0 then
    self.sprite:update(delta)
  else
    self.sprite:reset()
  end

  self:moveAndSlide(delta)
end

function slime:draw()
  self.sprite:draw(math.floor(self.x), math.floor(self.y))
end

return slime
