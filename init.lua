-- auto reload when config changes
local hammerspoonHomeWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()

-- command line interface
require("hs.ipc")
hs.ipc.cliInstall()

require("windowhotkeys")
require("polluri")

doc = require("hs.doc").fromRegisteredFiles()

caffeinate = require("caffeinate")
itunes = require("itunes")
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
