---@class mapped
---@field layers table
---@field x number
---@field y number
---@field vx number
---@field vy number
---@field map table
---@field w number
---@field h number
local mapped = {}
mapped.__index = mapped

function mapped:new(width, height, map)
  local r = {
    x = 0, y = 0,
    vx = 0, vy = 0,

    w = width, h = height,
    map = map,

    layers = {},
  }

  return setmetatable(r, mapped)
end

function mapped:setMap(new)
  self.map = new
end

function mapped:pushLayer(l)
  table.insert(self.layers, l)
end

function mapped:isTileSolid(x, y, layer)
  local tile = layer:getTileAtPixelPosition(x, y)
  if tile then
    return self.map:getTileProperty(tile, "solid")
  end

  return false
end

function mapped:isSolidRect(x, y, layer)
  return
    self:isTileSolid(x, y, layer) or
    self:isTileSolid(x + self.w, y, layer) or
    self:isTileSolid(x + self.w, y + self.h, layer) or
    self:isTileSolid(x, y + self.h, layer)
end

function mapped:moveAndSlide(dt)
  local l = false
  local r = false

  for _, layer in ipairs(self.layers) do
    if self:isSolidRect(self.x + self.vx * dt, self.y, layer) then
      l = true
    end
    if self:isSolidRect(self.x, self.y + self.vy * dt, layer) then
      r = true
    end
  end

  -- Left and Right
  if not l then
    self.x = self.x + self.vx * dt
  else
    if self.vx * dt < 0 then
      self.x  = (math.floor(self.x / 8)) * 8
      self.vx = 0
    elseif self.vx * dt > 0 then
      self.x  = (math.floor((self.x + self.w) / 8)) * 8
      self.vx = 0
    end
  end

  -- Up and Down
  if not r then
    self.y = self.y + self.vy * dt
  else
    if self.vy < 0 then
      self.y = (math.floor(self.y / 8)) * 8
      self.vy = 0
    elseif self.vy > 0 then
      self.y = (math.floor((self.y + self.h) / 8)) * 8
      self.vy = 0
    end
  end
end

return mapped
