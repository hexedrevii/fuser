local anim = require "src.anim"
local fusion = require "src.fusions.fusion"

local playerFuse = fusion:new(128, 700, 200, 200, 800, 'player')

function playerFuse:update(delta)
end

function playerFuse:draw()

end

return playerFuse
