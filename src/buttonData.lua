-- First is Y
-- Second is X
-- This is the position the button is found at.
local buttonData = {
  [5] = {
    [86] = function(map)
      local layer = map.layers.solids
      layer:setTileAtGridPosition(86, 5, 17)

      layer:setTileAtGridPosition(97, 4, 0)
      layer:setTileAtGridPosition(97, 5, 0)
      layer:setTileAtGridPosition(97, 6, 0)
    end
  },

  [9] = {
    [144] = function (map)
      local layer = map.layers.solids
      layer:setTileAtGridPosition(144, 9, 17)

      layer:setTileAtGridPosition(155, 7, 0)
      layer:setTileAtGridPosition(155, 8, 0)
      layer:setTileAtGridPosition(155, 9, 0)
      layer:setTileAtGridPosition(155, 10, 0)
    end
  }
}

return buttonData
