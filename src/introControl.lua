local global = require 'src.globals'
local world  = require 'src.world.world'
local game   = require 'src.world.game'

local introControl = {
  name = "IntroControl"
}

function introControl.onDialogueEnd(dialogue, pluginData)
  world:set(game)
  global.introPlayed = true
end

return introControl
