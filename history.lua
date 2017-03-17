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

-- inspired by zsh HIST_IGNORE_SPACE http://zsh.sourceforge.net/Doc/Release/Options.html
-- NOTE: changing this could cause removal of entries persisted in previous sessions
local function shouldPersist(text)
  local firstChar = text:sub(1,1)
  return firstChar ~= " " and
    firstChar ~= "_" and
    not text:match("hs%.reload%(%)")
end
history.shouldPersist = shouldPersist

local console = hs.console
local getHistory = console.getHistory
history.get = getHistory
local fnutils = hs.fnutils

function history.persist()
  local file = file("w+")
  fnutils.ieach(getHistory(), function(item)
                  if shouldPersist(item) then
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
