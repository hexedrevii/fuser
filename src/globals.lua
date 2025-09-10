local LoveDialogue = require "lib.LoveDialogue.LoveDialogue"
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

  bulletSprite = love.graphics.newImage('assets/entities/bullet.png'),

  ---@class palette
  ---@field orange number[]
  ---@field lightYellow number[]
  ---@field lightGreen number[]
  ---@field brown number[]
  palette = {
    orange = {0.93,0.61,0.36},
    lighYellow = {0.99,1.00,0.75},
    lightGreen = {0.43,0.72,0.66},
    brown = {0.47,0.27,0.28}
  },

  font = love.graphics.newFont('assets/pico-8.otf', 6),

  ---@class dialogue
  ---@field update function
  ---@field draw function
  ---@field play function
  ---@field keypressed function
  dialogue = nil,
  dialogueConfig = {
    boxHeight = 150,
    boxColor  = {0.93,0.61,0.36, 1},
    textColor = {0.99,1.00,0.75, 1},
    typingSpeed = 0.05,
    padding = 20,
    autoLayoutEnabled = true,
    skipKey = "f",
    textSpeeds = {
      slow = 0.08,
      normal = 0.05,
      fast = 0.02
    },

    letterSpacingLatin = 2,

    initialSpeedSetting = "normal",
    autoAdvance = false,
    autoAdvanceDelay = 3.0,

    plugins = {"FlowControl"},

    -- NO FADES IT LOOKS UGLY
    fadeInDuration = 0,
    fadeOutDuration = 0,
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

---@param text string
function globals:play(text)
  self.dialogue = LoveDialogue.play(text, self.dialogueConfig)
end

return globals
