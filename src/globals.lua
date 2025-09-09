local globals = {
  ---@class canvas
  ---@field getScale function
  ---@field set function
  ---@field renderWorld function
  canvas = {
    x = 128, y = 128,
    cx = 8, cy = 8,
    body = love.graphics.newCanvas(128, 128)
  },

  ---@class palette
  ---@field orange number[]
  ---@field lightYellow number[]
  ---@field lightGreen number[]
  palette = {
    orange = {0.93,0.61,0.36},
    lighYellow = {0.99,1.00,0.75},
    lightGreen = {0.43,0.72,0.66}
  }
}

globals.canvas.body:setFilter("nearest", "nearest")

function globals.canvas:getScale()
  local screen_x, screen_y = love.graphics.getDimensions()
  return math.min(screen_x / self.x, screen_y / self.y)
end

function globals.canvas:set()
  love.graphics.setCanvas(self.body)
end

function globals.canvas:renderWorld()
  love.graphics.setCanvas()

  local scale = self:getScale()

  local screen_x, screen_y = love.graphics.getDimensions()
  local scale_x,  scale_y  = self.x * scale, self.y * scale
  local x, y = (screen_x - scale_x) * 0.5, (screen_y - scale_y) * 0.5

  -- Black
  love.graphics.clear(0, 0, 0)
  love.graphics.draw(self.body, x, y, 0, scale, scale)
end

return globals
