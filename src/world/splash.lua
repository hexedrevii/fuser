local globals = require "src.globals"
local graphics = love.graphics
local splash = {
  alpha = 0,
  fade_speed = nil,
  reverse = false,

  holding = {
    enabled = false,

    time = 0,
    timeout = nil
  },

  text = {},
  screen_size = nil,

  callback = nil
}

--- Set the bare intro data.
--- Run this at the beginning of your love.load()
---@param screen_size { x: number, y: number }
---@param font love.Font
---@param callback function
---@param timeout? number
---@param fade_speed? number
function splash:set(screen_size, font, callback, timeout, fade_speed)
  self.holding.timeout = timeout or 0.5
  self.fade_speed = fade_speed or 2
  self.screen_size = screen_size

  self.callback = callback

  local first = graphics.newText(font, "hexed")
  local first_x, first_y = first:getDimensions()
  local first_pos = {
    x = ((self.screen_size.x - first_x) / 2) - 10,
    y = ((self.screen_size.y - first_y) / 2) - first_y
  }

  local second = graphics.newText(font, "revii")
  local second_x, second_y = second:getDimensions()
  local second_pos = {
    x = ((self.screen_size.x - second_x) / 2),
    y = ((self.screen_size.y - second_y) / 2)
  }

  table.insert(self.text, { text = first,  pos = first_pos  })
  table.insert(self.text, { text = second, pos = second_pos })
end

---@param dt number
function splash:update(dt)
  local holding = self.holding
  if holding.enabled then
    holding.time = holding.time + dt
    if holding.time >= holding.timeout then
      self.reverse = true
      holding.enabled = false
    end

    return
  end

  if not self.reverse then
    self.alpha = self.alpha + (self.fade_speed * dt)
    if self.alpha >= 1 then
      holding.enabled = true
    end
  else
    self.alpha = self.alpha - (self.fade_speed * dt)
    if self.alpha <= 0 then
      -- Finished
      graphics.reset()

      self.callback()
    end
  end
end

function splash:draw()
  globals.canvas:set()
  graphics.clear(globals.palette.darkPurple[1], globals.palette.darkPurple[2], globals.palette.darkPurple[3], 1)

  graphics.setColor(globals.palette.lighYellow[1], globals.palette.lighYellow[2], globals.palette.lighYellow[3], self.alpha)
  for _,v in pairs(self.text) do
    graphics.draw(v.text, math.floor(v.pos.x), math.floor(v.pos.y))
  end
  graphics.setColor(1,1,1,1)

  globals.canvas:renderWorld()
end

return splash
