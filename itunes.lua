local application = require("application")

local log = hs.logger.new("itunes", "info")

local itunes = hs.itunes
local timer = hs.timer
local partial = hs.fnutils.partial

local function fade(interval, whenSilent)
  local function volume() return itunes.getVolume() end
  initialVolume = volume()
  local function silent() return volume() <= 0 end
  lowerVolume = function(timer)
    itunes.setVolume(volume() - 1)
    log.i("fade: " .. volume())
    if volume() <= 0 then
      timer:stop()
      itunes.pause()
      itunes.setVolume(initialVolume)
      if whenSilent then
        whenSilent()
      end
    end
  end
  return timer.doUntil(silent, lowerVolume, interval)
end
itunes.fade = fade

function itunes.fadeAt(at, interval, whenSilent)
  return timer.doAt(at, partial(fade, interval, whenSilent))
end

function itunes.fadeIn(seconds, interval, whenSilent)
  return timer.doAfter(seconds, partial(fade, interval, whenSilent))
end

local function playwake(interval)
  itunes.setVolume(0)
  itunes.play()
  timer.doUntil(
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
end
itunes.playwake = playwake

function itunes.playwakeIn(seconds, interval)
  return timer.doAfter(seconds, partial(playwake, interval))
end

function itunes.playwakeAt(at, interval)
  return timer.doAt(at, partial(playwake, interval))
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
