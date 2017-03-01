local log = hs.logger.new("itunes", "info")

local itunes = hs.itunes

function itunes.fade(interval, whenSilent)
  initialVolume = itunes.getVolume()
  volume = initialVolume
  silent = function() return volume <= 0 end
  lowerVolume = function()
    volume = volume - 1
    log.i("fade: " .. volume)
    if volume <= 0 then
      itunes.pause()
      itunes.setVolume(initialVolume)
      if whenSilent then
        whenSilent()
      end
    else
      itunes.setVolume(volume)
    end
  end
  return hs.timer.doUntil(silent, lowerVolume, interval)
end

local function app()
  return hs.application.get("com.apple.iTunes")
end
itunes.app = app

local function selectMenuItem(path)
  return app():selectMenuItem(path)
end

local concat = hs.fnutils.concat

local function controlsMenuItemPath(path)
  return concat({"Controls"}, path)
end

local function selectShuffleMenuItem(name)
  return selectMenuItem(controlsMenuItemPath({"Shuffle", name}))
end

local function shuffleOn()
  return selectShuffleMenuItem("On")
end
itunes.shuffleOn = shuffleOn

local function shuffleOff()
  return selectShuffleMenuItem("Off")
end
itunes.shuffleOff = shuffleOff

function itunes.reshuffle()
  return shuffleOff() and shuffleOn()
end

local function selectRepeatMenuItem(name)
  return selectMenuItem(controlsMenuItemPath({"Repeat", name}))
end

local function repeatOff()
  return selectRepeatMenuItem("Off")
end
itunes.repeatOff = repeatOff

local function repeatAll()
  return selectRepeatMenuItem("All")
end
itunes.repeatAll = repeatAll

local function repeatOne()
  return selectRepeatMenuItem("One")
end
itunes.repeatOne = repeatOne

local function playLater()
  selectMenuItem({"Song", "Play Later"})
end

local playLaterHotkey = hs.hotkey.new({"cmd"}, ";", playLater)
local watcher = hs.application.watcher.new(function(name, event, application)
    if application == app() then
      if event == hs.application.watcher.activated then
        playLaterHotkey:enable()
      end
      if event == hs.application.watcher.deactivated then
        playLaterHotkey:disable()
      end
    end
end)
watcher:start()
itunes.watcher = watcher

return itunes
