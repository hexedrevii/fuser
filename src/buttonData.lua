local globals = require "src.globals"
-- First is Y
-- Second is X
-- This is the position the button is found at.
local buttonData = {
  [0] = {
    [377] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(377, 0, 17)

      layer:setTileAtGridPosition(396, 3, 0)
      layer:setTileAtGridPosition(397, 3, 0)
      layer:setTileAtGridPosition(398, 3, 0)

      layer:setTileAtGridPosition(396, 13, 15)
      layer:setTileAtGridPosition(397, 13, 15)
      layer:setTileAtGridPosition(398, 13, 15)
    end
  },

  [1] = {
    [534] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(534, 1, 20)

      layer:setTileAtGridPosition(535, 12, 0)
      layer:setTileAtGridPosition(536, 12, 0)
      layer:setTileAtGridPosition(537, 12, 0)
    end
  },

  [4] = {
    [332] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(332, 4, 20)

      layer:setTileAtGridPosition(336, 7, 0)
      layer:setTileAtGridPosition(336, 8, 0)
      layer:setTileAtGridPosition(336, 9, 0)
    end
  },

  [5] = {
    [86] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(86, 5, 17)

      layer:setTileAtGridPosition(97, 4, 0)
      layer:setTileAtGridPosition(97, 5, 0)
      layer:setTileAtGridPosition(97, 6, 0)
    end
  },

  [9] = {
    [144] = function (map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(144, 9, 17)

      layer:setTileAtGridPosition(155, 7, 0)
      layer:setTileAtGridPosition(155, 8, 0)
      layer:setTileAtGridPosition(155, 9, 0)
      layer:setTileAtGridPosition(155, 10, 0)
    end,

    [389] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(389, 9, 20)

      layer:setTileAtGridPosition(383, 10, 15)
      layer:setTileAtGridPosition(384, 10, 15)
    end
  },

  [8] = {
    [309] = function (map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(309, 8, 20)

      layer:setTileAtGridPosition(303, 14, 15)
      layer:setTileAtGridPosition(304, 14, 15)
      layer:setTileAtGridPosition(305, 14, 15)
      layer:setTileAtGridPosition(306, 14, 15)
      layer:setTileAtGridPosition(307, 14, 15)
      layer:setTileAtGridPosition(308, 14, 15)
      layer:setTileAtGridPosition(309, 14, 15)
    end,

    [325] = function(map)
      globals.sounds.click:play()

      local layer = map.layers.solids
      layer:setTileAtGridPosition(325, 8, 17)

      layer:setTileAtGridPosition(329, 9, 15)
      layer:setTileAtGridPosition(330, 9, 15)
    end
  },
}

return buttonData
