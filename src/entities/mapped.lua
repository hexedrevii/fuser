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

function mapped.new(width, height, map)
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

function mapped:isOnFloor()
  for _, layer in ipairs(self.layers) do
    if self:isTileSolid(self.x + self.w - 1, self.y + self.h + 1, layer) or
    self:isTileSolid(self.x, self.y + self.h + 1, layer) then
      return true
    end
  end

  return false
end

function mapped:moveAndSlide(dt)
  local steps = math.ceil(math.max(math.abs(self.vx * dt), math.abs(self.vy * dt)) / 4)
  local stepX = (self.vx * dt) / steps
  local stepY = (self.vy * dt) / steps

  for _ = 1, steps do
    -- Horizontal
    local blockedX = false
    for _, layer in ipairs(self.layers) do
      if self:isSolidRect(self.x + stepX, self.y, layer) then
        blockedX = true
        break
      end
    end

    if not blockedX then
      self.x = self.x + stepX
    else
      self.vx = 0
    end

    -- Vertical
    local blockedY = false
    for _, layer in ipairs(self.layers) do
      if self:isSolidRect(self.x, self.y + stepY, layer) then
        blockedY = true
        break
      end
    end

    if not blockedY then
      self.y = self.y + stepY
    else
      self.vy = 0
    end
  end
end

return mapped
