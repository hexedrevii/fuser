local global = require 'src.globals'

local endingControl = {
  name = "EndingControl"
}

function endingControl.onDialogueEnd(dialogue, pluginData)
  global.gameEnded = true
end

return endingControl
