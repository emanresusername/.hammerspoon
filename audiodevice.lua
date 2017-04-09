local audiodevice = hs.audiodevice

local function default()
  return audiodevice.defaultOutputDevice()
end
audiodevice.default = default

function audiodevice.setVolume(volume)
  return default():setOutputVolume(volume)
end

function audiodevice.getVolume()
  return default():outputVolume()
end

return audiodevice
