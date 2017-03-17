local console = hs.console

local application = require("application")

local _alpha = console.alpha
console.alpha = _alpha()
local useAlpha = _alpha() < 1

local function app()
  return console.hswindow():application()
end

function console.keyStrokes(text)
  hs.eventtap.keyStrokes(text, app())
end

application.hotkey(
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

return console
