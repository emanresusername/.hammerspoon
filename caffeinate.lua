function hs.caffeinate.sleepScreen()
  return hs.execute("pmset displaysleepnow")
end

function hs.caffeinate.sleepScreenAt(time)
  return hs.timer.doAt(time, sleepScreen)
end

function hs.caffeinate.sleepScreenIn(seconds)
  return hs.timer.doAfter(seconds, sleepScreen)
end

return hs.caffeinate
