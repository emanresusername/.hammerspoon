-- auto reload when config changes
hammerspoonHomeWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()

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

inspect = hs.inspect
fnutils = hs.fnutils

function fadeItunesThenSleepScreen(interval)
  return itunes.fade(interval, caffeinate.sleepScreen)
end

function alertSayNotify(message)
  message = tostring(message)
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
      app:mainWindow():frame().xy + hs.geometry.point(294.5546875,298.390625)
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
