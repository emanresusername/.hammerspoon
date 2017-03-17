local history = {}

local log = hs.logger.new("history", "info")

history.path = os.getenv("HOME") .. "/.hammerspoon/.history"
local function path()
  return history.path
end

local function file(mode)
  local path = path()
  log.i("open(" .. path .. ", " .. mode .. ")")
  return io.open(path, mode)
end
history.file = file

-- don't persist lines with leading spaces to history
-- inspired by zsh HIST_IGNORE_SPACE http://zsh.sourceforge.net/Doc/Release/Options.html
-- NOTE: could remove entries from previous sessions where this was false
history.ignoreSpace = true
local function ignoreSpace()
  return history.ignoreSpace
end

local console = hs.console
local getHistory = console.getHistory
history.get = getHistory
local fnutils = hs.fnutils

function history.persist()
  local file = file("w+")
  fnutils.ieach(getHistory(), function(item)
                  if not ignoreSpace() or item:sub(1,1) ~= " " then
                    io.output(file):write(item .. "\n")
                  end
  end)
  file:close()
end

function history.load()
  local file = file("r")
  if file then
    local persisted = {}
    for line in file:lines() do
      table.insert(persisted, line)
    end
    console.setHistory(persisted)
    file:close()
  end
end

function history.search(substring)
  return fnutils.ifilter(getHistory(), function(item)
                              return item:match(substring)
  end)
end

return history
