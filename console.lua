local console = hs.console

local application = require("application")
local timer = require("timer")

local _alpha = console.alpha
console.alpha = _alpha()
local useAlpha = _alpha() < 1
local hswindow = console.hswindow

local function app()
  return hswindow():application()
end

function console.keyStrokes(text)
  hs.eventtap.keyStrokes(text, app())
end

timer.waitUntil(
  function()
    return hswindow()
  end,
  function()
    local hotkey, watcher = application.hotkey(
      app(),
      {"cmd"},
      "u",
      function(app)
        useAlpha = not useAlpha
        if useAlpha then
          _alpha(console.alpha)
        else
          _alpha(1)
        end
      end
    )
    if app():isFrontmost() then
      hotkey:enable()
    end
  end,
  0.1
)

return console
