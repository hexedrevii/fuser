---@class fusion
---@field spd number
---@field acc number
---@field jmp number
---@field gravity number
---@field gravitational_pull number
---@field player player
---@field id string
local fusion = {}
fusion.__index = fusion

---@param spd number
---@param acc number
---@param jmp number
---@param grav number
---@param gpull number
---@param id string
---@return fusion
function fusion:new(spd, acc, jmp, grav, gpull, id)
  local f = {
    spd = spd,
    acc = acc,

    jmp = jmp,

    gravity = grav,
    gravitational_pull = gpull,

    id = id
  }

  return setmetatable(f, fusion)
end

function fusion:set(player)
  self.player = player

  player.spd = self.spd
  player.acc = self.acc
  player.jmp = self.jmp
  player.gravity = self.gravity
  player.gravitational_pull = self.gravitational_pull

  return self
end

function fusion:update(delta)end
function fusion:draw()end

return fusion
