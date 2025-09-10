local mapped = require "src.entities.mapped"
local anim   = require "src.anim"
local globals= require "src.globals"

---@class bullet : mapped
local bullet = {}
bullet.__index = bullet
setmetatable(bullet, { __index = mapped })

function bullet.new(x, y, dir, map)
  ---@class bullet
  local b = mapped.new(6, 6, map)

  b.sprite = anim:new(
    globals.bulletSprite, 8, 8, 0.25
  )

  if dir == -1 then b.sprite.flipH = true else b.sprite.flipH = false end

  b.x = x
  b.y = y

  b.spd = 130

  b.dir = dir

  return setmetatable(b, bullet)
end

function bullet:isTileProperty(x, y, layer, property)
  local tile = layer:getTileAtPixelPosition(x, y)
  if tile then
    return self.map:getTileProperty(tile, property)
  end

  return nil
end

function bullet:isPropertyRect(x, y, layer, property)
  return
    self:isTileProperty(x, y, layer, property) or
    self:isTileProperty(x + self.w, y, layer, property) or
    self:isTileProperty(x + self.w, y + self.h, layer, property) or
    self:isTileProperty(x, y + self.h, layer, property)
end


function bullet:update(delta)
  self.sprite:update(delta)
  self.x = self.x + self.spd * self.dir * delta
end

function bullet:draw()
  self.sprite:draw(math.floor(self.x), math.floor(self.y))
end

return bullet
