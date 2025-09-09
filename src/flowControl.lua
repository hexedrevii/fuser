local global = require 'src.globals'

local flowControl = {
  name = "FlowControl"
}

function flowControl.onDialogueEnd(dialogue, pluginData)
  global.dialogue = nil
  love.graphics.setFont(global.font)
end

return flowControl
