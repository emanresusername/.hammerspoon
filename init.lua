inspect = hs.inspect
fnutils = hs.fnutils

log = hs.logger.new("main", "info")

require("reloader"):start()

-- command line interface
require("hs.ipc")
hs.ipc.cliInstall()

require("windowhotkeys")
require("polluri")

doc = require("hs.doc").fromRegisteredFiles()

application = require("application")
caffeinate = require("caffeinate")
itunes = require("itunes")
timer = require("timer")
dirhttpserver = require("dirhttpserver")
mouse = require("mouse")
history = require("history")
audiodevice = require("audiodevice")

console = require("console")
console.alpha = 0.25

factchick = require("factchick")

function fadeItunesThenSleepScreen(interval)
  return itunes.fade(interval, caffeinate.sleepScreen)
end

-- cause sometimes 1 just isn't enough
function logAlertNotifySpeak(message)
  message = inspect(message)
  log.i(message)
  hs.alert(message)
  hs.notify.show(message, message, message)
  hs.speech.new():speak(message)
end

-- for a flash button or something that i can't click with vimperator/vimfx (fwp)
application.hotkey(
  application.get("org.mozilla.firefox"),
  {"cmd"},
  ";",
  function(app)
    hs.eventtap.leftClick(
      app:mainWindow():frame().xy + hs.geometry.point(264.5546875,328.390625)
    )
  end
)

-- auto focus on password input
application.hotkey(
  application.get("com.google.Chrome"),
  {"cmd"},
  ",",
  function(app)
    hs.eventtap.leftClick(
      app:findWindow("Authy"):frame().xy + hs.geometry.point(175.54296875,258.7734375)
    )
  end
)

-- inspired by _ getting last returned value in ruby console
-- and/or !# getting a certain command number in various shells
function _(index, substring)
  if type(index) == "string" then
    -- use last command in history matching substring
    substring = index
    index = 0
  else
    -- use last command in history
    index = index or 0
  end

  local list
  if substring then
    list = history.search(substring)
  else
    list = history.get()
  end

  local last = #list

  if index < 1 then
    -- fix for non-negative index in the command list
    index = last + index
  end

  if index < 1 then
    -- use first if before the first
    index = 1
  elseif index > last then
      -- use last if after the last
      index = last
  end
  console.keyStrokes(list[index])
end

history.load()
hs.shutdownCallback = history.persist
