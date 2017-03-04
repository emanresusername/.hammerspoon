local application = require("application")

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

function itunes.playwake(at, interval)
  return hs.timer.doAt(
    at,
    function()
      itunes.setVolume(0)
      itunes.play()
      hs.timer.doUntil(
        function()
          return itunes.getVolume() >= 100
        end,
        function()
          local volume = itunes.getVolume() + 1
          log.i("playwake: " .. volume)
          itunes.setVolume(volume)
        end,
        interval
      )
  end)
end

local function app()
  return application.get("com.apple.iTunes")
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

application.hotkey(app(), {"cmd"}, ";", playLater)

return itunes
