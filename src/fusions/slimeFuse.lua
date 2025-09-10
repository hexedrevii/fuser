local fusion = require "src.fusions.fusion"
local input  = require "src.input"
local bullet = require "src.entities.bullet"
local buttonData = require "src.buttonData"

local slimeFuse = fusion:new(80, 600, 200, 200, 800, 'slime')

function slimeFuse:update(delta)
  if input:isPressed(input.slash) then
    table.insert(
      self.player.bullets,
      bullet.new(
        self.player.x, self.player.y,
        self.player.sprite.flipH and -1 or 1,
        self.player.map
      )
    )
  end

  for idx,b in ipairs(self.player.bullets) do
    b:update(delta)
    -- Erase
    if b:isSolidRect(b.x, b.y, self.player.map.layers.solids) then
      table.remove(self.player.bullets, idx)
    end

    -- Is Button ( check the middle of the bullet ONLY!!!!)
    if b:isTileProperty(b.x + 4, b.y + 4, self.player.map.layers.solids, 'button') then
      local gx = math.floor((b.x + 4) / 8)
      local gy = math.floor((b.y + 4) / 8)

      print(gx, gy)
      if buttonData[gy] and buttonData[gy][gx] then
        buttonData[gy][gx](self.player.map)
      end
    end
  end
end

function slimeFuse:draw()
  for _, b in ipairs(self.player.bullets) do
    b:draw()
  end
end

return slimeFuse
