local globals      = require "src.globals"
local player       = require "src.entities.player"
local cartographer = require "lib.cartographer"
local hcamera      = require "lib.hump.camera"
local mathf        = require "src.mathf"

local game = {}

local function __lerp(x, y, t)
  return x + (y - x) * t
end

function game:init()
  self.entities = {}

  self.map = cartographer.load('assets/maps/world.lua')
  self.player = player.new(self.map)
  self.player.x = 6 * 8
  self.player.y = 11 * 8

  table.insert(self.entities, self.player)

  self.camera = hcamera(0, 0)
  self.cameraSmoothness = 10
  self.cameraBounds = {
    minX = 64,
    maxX = 9999,

    minY = 64,
    maxY = 64,
  }

end

function game:update(delta)
  for _, entity in ipairs(self.entities) do
    entity:update(delta)
  end

  local targetX = math.floor(self.player.x)
  local targetY = math.floor(self.player.y)

  targetX = math.max(self.cameraBounds.minX, math.min(targetX, self.cameraBounds.maxX))
  targetY = math.max(self.cameraBounds.minY, math.min(targetY, self.cameraBounds.maxY))

  local camX = __lerp(self.camera.x, targetX, delta * self.cameraSmoothness)
  local camY = __lerp(self.camera.y, targetY, delta * self.cameraSmoothness)

  self.camera:lookAt(camX, camY)
end

function game:draw()
  love.graphics.clear(0, 0, 0)

  globals.canvas:set()
  self.camera:attach(0, 0, globals.canvas.x, globals.canvas.y)

  love.graphics.clear(globals.palette.lightGreen)

  self.map:draw()

  for _, entity in ipairs(self.entities) do
    entity:draw()
  end

  self.camera:detach()
  globals.canvas:renderWorld()
end

return game
