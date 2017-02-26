local mouse = hs.mouse

local geometry = hs.geometry
local event = hs.eventtap.event
local eventTypes = event.types
local size = geometry.size
local point = geometry.point

function mouse.point()
  return point(mouse.getAbsolutePosition())
end


local function swipe(from, to, window, seconds, tickDistance)
  seconds = seconds or 0.2
  tickDistance = tickDistance or 20
  from = point(from)
  to = point(to)
  ticks = from:distance(to) / tickDistance
  local vector = from:vector(to)
  local xPerTick = vector.x / ticks
  local yPerTick = vector.y / ticks
  local secondsPerTick = seconds / ticks

  local currentPoint = from:copy()

  -- TODO: posting events to the app doesn't seem to work as expected
  window:focus()
  event.newMouseEvent(eventTypes.leftMouseDown, currentPoint):post()
  local dragger = hs.timer.doWhile(
    function()
      return geometry.inside(
        currentPoint,
        geometry.rect({x1 = from.x, y1 = from.y, x2 = to.x, y2 = to.y})
      )
    end,
    function()
      currentPoint:move(xPerTick, yPerTick)
      event.newMouseEvent(eventTypes.leftMouseDragged, currentPoint):post()
    end,
    secondsPerTick
  )

  hs.timer.waitWhile(
    function()
      return dragger:running()
    end,
    function()
      event.newMouseEvent(eventTypes.leftMouseUp, currentPoint):post()
    end,
    secondsPerTick
  )
  return dragger
end

local function window(applicationHint)
  local app = hs.application.open(applicationHint)
  return app:focusedWindow()
end

function mouse.swipeRight(applicationHint, relativeStart, swipeDistance, seconds, tickDistance)
  local window = window(applicationHint)
  local frame = window:frame()
  local sections = 5
  local sectionDistance = frame.w / sections
  swipeDistance = swipeDistance or sectionDistance * (sections - 2)
  relativeStart = relativeStart or {}
  local x = relativeStart.x or frame.x + sectionDistance
  local y = relativeStart.y or frame.center.y
  local absoluteStart = point(x, y)
  local absoluteEnd = absoluteStart + point(swipeDistance, 0)
  return swipe(absoluteStart, absoluteEnd, window, seconds, tickDistance)
end

function mouse.swipeLeft(applicationHint, relativeStart, swipeDistance, seconds, tickDistance)
  local window = window(applicationHint)
  local frame = window:frame()
  local sections = 5
  local sectionDistance = frame.w / sections
  swipeDistance = swipeDistance or sectionDistance * (sections - 2)
  relativeStart = relativeStart or {}
  local x = relativeStart.x or frame.x2 - sectionDistance
  local y = relativeStart.y or frame.center.y
  local absoluteStart = point(x, y)
  local absoluteEnd = absoluteStart + point(-swipeDistance, 0)
  return swipe(absoluteStart, absoluteEnd, window, seconds, tickDistance)
end

function mouse.swipeUp(applicationHint, relativeStart, swipeDistance, seconds, tickDistance)
  local window = window(applicationHint)
  local frame = window:frame()
  local sections = 4
  local sectionDistance = frame.h / sections
  swipeDistance = swipeDistance or sectionDistance * (sections - 2)
  relativeStart = relativeStart or {}
  local x = relativeStart.x or frame.center.x
  local y = relativeStart.y or frame.y2 - sectionDistance
  local absoluteStart = point(x, y)
  local absoluteEnd = absoluteStart + point(0, -swipeDistance)
  return swipe(absoluteStart, absoluteEnd, window, seconds, tickDistance)
end

function mouse.swipeDown(applicationHint, relativeStart, swipeDistance, seconds, tickDistance)
  local window = window(applicationHint)
  local frame = window:frame()
  local sections = 4
  local sectionDistance = frame.h / sections
  swipeDistance = swipeDistance or sectionDistance * (sections - 2)
  relativeStart = relativeStart or {}
  local x = relativeStart.x or frame.center.x
  local y = relativeStart.y or frame.y + sectionDistance
  local absoluteStart = point(x, y)
  local absoluteEnd = absoluteStart + point(0, swipeDistance)
  return swipe(absoluteStart, absoluteEnd, window, seconds, tickDistance)
end

return mouse
