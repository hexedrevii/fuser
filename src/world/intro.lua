local globals = require "src.globals"
local LoveDialogue = require "lib.LoveDialogue.LoveDialogue"
local intro = {}

function intro:init()
  globals.dialogue = LoveDialogue.play('assets/dialogues/intro.ld', globals.dialogueIntroConfig)
end

function intro:update(delta)
  if globals.dialogue then
    globals.dialogue:update(delta)
  end
end

function intro:draw()
  love.graphics.setColor(1,1,1)

  love.graphics.clear(globals.palette.darkPurple)

  if globals.dialogue then
    globals.dialogue:draw()
  end
end

return intro
