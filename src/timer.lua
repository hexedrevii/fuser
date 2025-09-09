---@class timer
---@field timeout number
---@field callback function
---@field oneshot boolean
---@field private __time number
---@field private __stopped boolean
local timer = {}
timer.__index = timer

---@param timeout number
---@param callback function
---@param oneshot boolean
---@return timer
function timer:new(timeout, callback, oneshot)
  local t = {
    timeout = timeout,
    callback = callback,
    oneshot = oneshot,

    __time = 0,
    __stopped = false,
  }

  return setmetatable(t, timer)
end

function timer:stop()
  self.__stopped = true
  self.__time = 0
end

function timer:start()
  self.__stopped = false
end

---@param delta number
function timer:update(delta)
  if self.__stopped then return end

  self.__time = self.__time + delta
  if self.__time >= self.timeout then
    if self.oneshot then
      self.__stopped = true
    end

    self.__time = 0
    self.callback()
  end
end

return timer
