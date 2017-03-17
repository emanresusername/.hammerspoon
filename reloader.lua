local inspect = hs.inspect
local fnutils = hs.fnutils

local log = hs.logger.new("reloader", "info")

local function shouldReloadFor(path)
  log.d(path)
  local file = path:match("[^/]+%.lua$")
  -- non lua files
  if not file then
    return false
  end

  -- emacs tmp files
  if file:sub(1,2) == ".#" then
    return false
  end

  return true
end

-- auto reload when config changes
return hs.pathwatcher.new(
  os.getenv("HOME") .. "/.hammerspoon/",
  function(paths)
    log.d(inspect(paths))
    local reloadFor = fnutils.filter(paths, shouldReloadFor)
    if #reloadFor > 0 then
      log.i("reloading lua changes: " .. inspect(reloadFor))
      hs.reload()
    end
  end
)
