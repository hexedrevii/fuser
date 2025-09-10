local globals      = require "src.globals"
local player       = require "src.entities.player"
local cartographer = require "lib.cartographer"
local hcamera      = require "lib.hump.camera"
local mathf        = require "src.mathf"
local rawWorld     = require "assets.maps.world"
local entityIds    = require "src.entities.entityIds"
local frog         = require "src.entities.frog"
local input        = require "src.input"
local slime        = require "src.entities.slime"
local playerFuse   = require "src.fusions.playerFuse"
local buttonController = require "src.ui.buttonController"

local game = {}

local __gameStates = {
  paused = 'inpauseWAWAKUWAuwuharder',
  unpaused = 'notpauseLMAO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
}

local function __lerp(x, y, t)
  return x + (y - x) * t
end

function game:__debug_setPlayerPosition(x, y)
  self.player.x = x * 8
  self.player.y = y * 8

  self.player.hasSword = true
end

function game:__handleDeath()
  local newEntities = {self.player }
  self.entities = newEntities

  for _, location in ipairs(self.entityLocations) do
    self:__spawnEntityAt(location.x, location.y, location.id)
  end

  self.player.hp = self.player.maxHp
  self.player:fuse(playerFuse)

  self.player.vx = 0
  self.player.vy = 0

  self.player.x = self.player.checkpoint.x * 8
  self.player.y = self.player.checkpoint.y * 8

  self.player.iframesActive = false
  if self.player.iframeTimer then
    self.player.iframeTimer:stop()
  end
end

function game:__spawnEntityAt(wx, wy, id)
  if id == entityIds.frog then
    table.insert(self.entities, frog.new(wx * 8, wy * 8, self.map))
  elseif id == entityIds.slime then
    table.insert(self.entities, slime.new(wx * 8, wy * 8, self.player, self.map))
  end
end

function game:__spawnEntites()
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

            self:__spawnEntityAt(wx, wy, tileProp)
            table.insert(self.entityLocations, {x = wx, y = wy, id = tileProp})

            entityLayer:setTileAtGridPosition(wx, wy, 0)
          end
        end
      end
    end
  end
end

function game:init()
  self.entities = {}

  self.map = cartographer.load('assets/maps/world.lua')
  self.player = player.new(self.map, self)
  self.player.x = 6 * 8
  self.player.y = 11 * 8

  self.state = __gameStates.unpaused

  self:__debug_setPlayerPosition(314, 11)

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

  self.pauseButtons = buttonController:new()
  self.pauseButtons:pushNewButton(50, 50, 'unpause', function()
    self.state = __gameStates.unpaused
  end)

  self.pauseButtons:pushNewButton(54, 60, 'reset', function()
    self.state = __gameStates.unpaused
    self:__handleDeath()
  end)

  self.pauseButtons:pushNewButton(46, 70, 'main menu', function()
  end)

  self.heart = love.graphics.newImage('assets/player/hp.png')
  self.heartEmpty = love.graphics.newImage('assets/player/hpEmpty.png')

  self.msg = nil

  self.entityLocations = {}

  self:__spawnEntites()
end

function game:update(delta)
  if self.state == __gameStates.unpaused then
    if input:isPressed('escape') then
      self.state = __gameStates.paused
    end

    for _, entity in ipairs(self.entities) do
      entity:update(delta)
    end

    self.msg = nil
    for _,entity in ipairs(self.entities) do
      if entity ~= self.player then
        local rect = {
          x = math.floor(entity.x), y = math.floor(entity.y), w = entity.w, h = entity.h
        }

        if entity.hp == nil then -- We are seeing an innocent animal.
          if mathf.colRect(self.player.interactionBounds, rect) then
            self.msg = input.interact .. ' to fuse'
            if input:isPressed(input.interact) then
              self.player:fuse(entity.fuse)
            end
          end
        else -- We are seeing an enemy
          if mathf.colRect({
            x = self.player.x, y = self.player.y, w = self.player.w, h = self.player.h
          }, rect) then
            if not self.player.iframesActive then
              self.player.hp = self.player.hp - 1

              mathf.applyKnockback(self.player, entity.x, entity.y, 160)

              self.player.iframeTimer:start()
              self.player.iframesActive = true

              if self.player.hp < 1 then
                self:__handleDeath()
              end
            end
          end
        end
      end
    end

    -- Player fall off map check like Mario LOL
    if self.player.y > 136 then
      self:__handleDeath()
    end

    -- Camera movement
    local targetX = math.floor(self.player.x)
    local targetY = math.floor(self.player.y)

    targetX = math.max(self.cameraBounds.minX, math.min(targetX, self.cameraBounds.maxX))
    targetY = math.max(self.cameraBounds.minY, math.min(targetY, self.cameraBounds.maxY))

    local camX = __lerp(self.camera.x, targetX, delta * self.cameraSmoothness)
    local camY = __lerp(self.camera.y, targetY, delta * self.cameraSmoothness)

    self.camera:lookAt(camX, camY)

    if globals.dialogue then
      globals.dialogue:update(delta)
    end
  elseif self.state == __gameStates.paused then
    if input:isPressed('escape') then
      self.state = __gameStates.unpaused
    end

    self.pauseButtons:update(delta)
  end
end

function game:draw()
  love.graphics.setColor(1,1,1)

  love.graphics.clear(0, 0, 0)

  globals.canvas:set()
  if self.state == __gameStates.unpaused then
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

    -- UI (outside camera)
    local hpOffset = 2
    local hpOffsetRect = 1

    love.graphics.setColor(globals.palette.brown)
    love.graphics.rectangle('fill', hpOffsetRect, hpOffsetRect, 8 * self.player.maxHp + hpOffsetRect, 8 + hpOffsetRect)
    love.graphics.setColor(1,1,1)

    for i=0, self.player.maxHp - 1 do
      if self.player.hp > i then
        love.graphics.draw(self.heart, hpOffset + 8 * i, 2)
      else
        love.graphics.draw(self.heartEmpty, hpOffset + 8 * i, 2)
      end
    end
  elseif self.state == __gameStates.paused then
    love.graphics.setColor(globals.palette.darkPurple)
    love.graphics.rectangle('fill', 0, 0, globals.canvas.x, globals.canvas.y)
    love.graphics.setColor(1,1,1)

    love.graphics.setColor(globals.palette.lighYellow)
    love.graphics.print('paused!', 52, 10)
    love.graphics.setColor(1,1,1)

    self.pauseButtons:draw()
  end

  globals.canvas:renderWorld()

  if globals.dialogue then
    globals.dialogue:draw()
  end
end

return game
