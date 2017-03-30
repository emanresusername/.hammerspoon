local promise = require("promise")
local log = hs.logger.new("factandchick", "info")
local factchick = {
  log = log,
  copySource = true,
  openSource = false
}

local baseUrl = "http://factsandchicks.com"
local imageSelector = "div.photo-panel>a>img"
local sourceSelector = ".copy>p>a"
local partial = hs.fnutils.partial

local webview

local function isWebviewLoading()
  return webview:loading()
end

local function mainFrame()
  return hs.screen.mainScreen():frame()
end

local function clickCallback(fade, drawing, sourceUrl)
  if factchick.copySource then
    hs.pasteboard.setContents(sourceUrl)
  end
  if factchick.openSource then
    hs.execute("open " .. sourceUrl)
  end
  drawing:hide(fade)
  hs.timer.doAfter(
    fade,
    function()
      drawing:delete()
    end
  )
end

local function showImage(fade, image, redirectUrl)
  log.d(hs.inspect(image))
  log.d(redirectUrl)
  local sourceUrl = hs.http.urlParts(redirectUrl).queryItems[1].z
  log.d(sourceUrl)
  local drawing = hs.drawing.image(mainFrame(), image)
  drawing:show(fade)
  drawing:setClickCallback(
    partial(clickCallback, fade, drawing, sourceUrl)
  )
  return drawing
end

local function imageUrlPromise()
  local urlPromise = promise.new()
  webview:evaluateJavaScript(
    'document.querySelector("' .. imageSelector .. '").getAttribute("src")',
    urlPromise.succeed
  )
  return urlPromise
end

local function sourceUrlPromise()
  local urlPromise = promise.new()
  webview:evaluateJavaScript(
    'document.querySelector("' .. sourceSelector .. '").getAttribute("href")',
    urlPromise.succeed
  )
  return urlPromise
end

function factchick.educateTitillate(fade)
  fade = fade or 0
  webview = webview or hs.webview.new(mainFrame())
  webview:url(baseUrl .. "/random")
  local drawingPromise = promise.new()
  hs.timer.waitWhile(
    isWebviewLoading,
    function()
      -- TODO: make these chainable
      imageUrlPromise().onSuccess(
        function(imageUrl)
          log.d(imageUrl)
          local image = hs.image.imageFromURL(imageUrl)
          sourceUrlPromise().onSuccess(
            function(sourceRedirectUrl)
              drawingPromise.succeed(showImage(fade, image, sourceRedirectUrl))
            end
                                      )
        end
                              )
    end,
    0.1
  )
  return drawingPromise
end

return factchick
