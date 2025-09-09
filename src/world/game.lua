local globals      = require "src.globals"
local player       = require "src.entities.player"
local cartographer = require "lib.cartographer"
local hcamera      = require "lib.hump.camera"
local mathf        = require "src.mathf"
local rawWorld     = require "assets.maps.world"
local entityIds    = require "src.entities.entityIds"
local frog         = require "src.entities.frog"
local input        = require "src.input"

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

  self.mapX = rawWorld.width
  self.mapY = rawWorld.height

  table.insert(self.entities, self.player)

  self.camera = hcamera(0, 0)
  self.cameraSmoothness = 10
  self.cameraBounds = {
    minX = 64,
    maxX = 9999,

    minY = 64,
    maxY = 64,
  }

  self.msg = nil

  -- Find entities
  local entityLayer = self.map.layers.spawners
  for _, chunk in ipairs(entityLayer.chunks) do
    for cy = 0, chunk.height - 1 do
      for cx = 0, chunk.width - 1 do
        local idx = cy * chunk.width + cx + 1
        local tileIdx = chunk.data[idx]

        if tileIdx ~= 0 then
          local tileProp = self.map:getTileProperty(tileIdx, 'entityId')
          if tileProp then
            local wx = chunk.x + cx
            local wy = chunk.y + cy

            if tileProp == entityIds.frog then
              table.insert(self.entities, frog.new(wx * 8, wy * 8, self.map))
            end

            entityLayer:setTileAtGridPosition(wx, wy, 0)
          end
        end
      end
    end
  end
end

function game:update(delta)
  for _, entity in ipairs(self.entities) do
    entity:update(delta)
  end

  self.msg = nil
  for _,entity in ipairs(self.entities) do
    if entity ~= self.player then
      local rect = {
        x = math.floor(entity.x), y = math.floor(entity.y), w = entity.w, h = entity.h
      }

      if mathf.colRect(self.player.interactionBounds, rect) then
        self.msg = input.interact .. ' to fuse'
        if input:isPressed(input.interact) then
          self.player:fuse(entity.fuse)
        end
      end
    end
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

  if self.msg then
    love.graphics.setColor(globals.palette.lighYellow)
    love.graphics.print(self.msg, math.floor(self.player.x - 15), math.floor(self.player.y + 10))
    love.graphics.setColor(1,1,1)
  end

  self.camera:detach()
  globals.canvas:renderWorld()
end

return game
