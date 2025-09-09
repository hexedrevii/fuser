local mapped = require "src.entities.mapped"
local anim   = require "src.anim"
local timer  = require "src.timer"
local mathf  = require "src.mathf"
local frogFuse = require "src.fusions.frogFuse"

---@class frog : mapped
---@field sprite anim
---@field spd number
---@field acc number
---@field dir number
---@field moveTime number|nil
---@field moveTImer timer
local frog = {}
frog.__index = frog
setmetatable(frog, { __index = mapped })

function frog.new(x, y, map)
  ---@class frog
  local f = mapped.new(7, 7, map)
  f.sprite = anim:new(
    love.graphics.newImage('assets/entities/frog.png'),
    8, 8, 0.35
  )

  f:pushLayer(f.map.layers.solids)

  f.x = x
  f.y = y

  f.dir = 0
  f.moveTime = nil

  f.spd = 20
  f.acc = 600

  f.fuse = frogFuse

  -- Every 1.5 seconds
  f.moveTimer = timer:new(1.5, function ()
    -- Frog has a 1/3 chance to move
    if math.random(3) == 3 then
      -- It picks a direction
      local dirChance = math.random(1, 2)
      if dirChance == 1 then
        f.sprite.flipH = false
        f.dir = 1
      else
        f.sprite.flipH = true
        f.dir = -1
      end

      -- It also picks a random amount of time to move
      -- Between 0.5 and 2 seconds
      f.moveTime = mathf.random(0.5, 2)
    end
  end, false)

  return setmetatable(f, frog)
end

function frog:update(delta)
  if self.moveTime then
    self.moveTime = self.moveTime - delta
    if self.moveTime <= 0 then
      self.moveTime = nil
    end

    self.vx = mathf.moveTowards(self.vx, self.spd * self.dir, self.acc * delta)
  else
    self.vx = 0
  end

  if self.vx ~= 0 then
    self.sprite:update(delta)
  else
    self.sprite:reset()
  end

  self.moveTimer:update(delta)

  self:moveAndSlide(delta)
end

function frog:draw()
  self.sprite:draw(math.floor(self.x), math.floor(self.y))
end

return frog
