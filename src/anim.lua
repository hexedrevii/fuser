---@class anim
---@field private spriteSheet love.Image
---@field private quads love.Quad[]
---@field private duration number
---@field private time number
---@field flipH boolean
---@field w number
---@field h number
local anim = {}
anim.__index = anim

---@param img love.Image
---@param w integer
---@param h integer
---@param duration number
function anim:new(img, w, h, duration)
  local a = {
    spriteSheet = img,
    quads = {},

    duration = duration or 1,
    time = 0,

    flipH = false,
    w = w, h = h
  }

  for y = 0, a.spriteSheet:getHeight() - h, h do
    for x = 0, a.spriteSheet:getWidth() - w, w do
      table.insert(a.quads, love.graphics.newQuad(x, y, w, h, a.spriteSheet:getDimensions()))
    end
  end

  return setmetatable(a, anim)
end

function anim:reset()
  self.time = 0
end

function anim:update(delta)
  self.time = self.time + delta
  if self.time >= self.duration then
    self.time = 0
  end
end

function anim:draw(x, y)
  local spriteIndex = math.floor(self.time / self.duration * #self.quads) + 1

  local scaleX = self.flipH and -1 or 1
  local offsetX = self.flipH and self.w or 0

  love.graphics.draw(
    self.spriteSheet, self.quads[spriteIndex],
    x + offsetX, y,
    0, scaleX, 1
  )
end

return anim
