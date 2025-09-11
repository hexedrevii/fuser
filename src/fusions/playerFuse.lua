local fusion = require "src.fusions.fusion"
local input  = require "src.input"
local mathf  = require "src.mathf"
local globals= require "src.globals"

local playerFuse = fusion:new(128, 700, 200, 200, 800, 'player')

function playerFuse:update(delta)
  if self.player.hasSword then
    local slasher = self.player.slasher

    slasher.x = self.player.x + 10 * (self.player.sprite.flipH and -1 or 1)
    slasher.y = self.player.y

    slasher.sprite.flipH = self.player.sprite.flipH

    if not slasher.sprite.stopped then
      self.player.vx = mathf.moveTowards(self.player.vx, 0, self.player.acc * delta)
      slasher.sprite:update(delta)
    else
      if input:isPressed(input.slash) then
        mathf.playRandomPitch(globals.sounds.swing)

        slasher.sprite:reset()
        self.player.inputLocked = true

        for idx, entity in ipairs(self.player.game.entities) do
          if entity ~= self.player then
            if entity.hp ~= nil then
              if mathf.colRectR(slasher.x, slasher.y, 7, 7, entity.x, entity.y, entity.w, entity.h) then
                entity.hp = entity.hp - 1

                mathf.applyKnockback(entity, self.player.x, self.player.y, 100)

                if entity.hp < 1 then
                  globals.sounds.death:play()

                  self.player:fuse(entity.fuse)
                  self.player.inputLocked = false

                  table.remove(self.player.game.entities, idx)
                end
              end
            end
          end
        end
      end
    end
  end
end

function playerFuse:draw()
  if self.player.hasSword then
    local slasher = self.player.slasher
    if not slasher.sprite.stopped then
      slasher.sprite:draw(math.floor(slasher.x), math.floor(slasher.y))
    end
  end
end

return playerFuse
