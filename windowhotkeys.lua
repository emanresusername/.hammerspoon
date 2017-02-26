--
-- Key defs
--
local cmdCtrl = {"cmd", "ctrl"}
local cmdAltCtrl = {"cmd", "alt", "ctrl"}

-- Window hints
hs.hotkey.bind(cmdCtrl, "E", hs.hints.windowHints)

-- Grid setup

local marginX = 0
local marginY = 0
local gridWidth = 8
local gridHeight = 4
hs.grid.MARGINX = marginX
hs.grid.MARGINY = marginY
hs.grid.GRIDWIDTH = gridWidth
hs.grid.GRIDHEIGHT = gridHeight

local focusedWindow = function()
   return hs.window.focusedWindow()
end

-- Maximize window
hs.hotkey.bind(cmdAltCtrl, "M", function()
                  hs.grid.maximizeWindow(focusedWindow())
end)
-- center window
hs.hotkey.bind(cmdAltCtrl, "C", function()
                  focusedWindow():centerOnScreen()
end)
-- left 1/2
hs.hotkey.bind(cmdAltCtrl, "Left", function()
                  focusedWindow():moveToUnit'[0,0,50,100]'
end)
-- right 1/2
hs.hotkey.bind(cmdAltCtrl, "Right", function()
                  focusedWindow():moveToUnit'[50,0,100,100]'
end)
-- top 1/2
hs.hotkey.bind(cmdAltCtrl, "Up", function()
                  focusedWindow():moveToUnit'[0,0,100,50]'
end)
-- bottom 1/2
hs.hotkey.bind(cmdAltCtrl, "Down", function()
                  focusedWindow():moveToUnit'[0,50,100,100]'
end)
-- top left
hs.hotkey.bind(cmdAltCtrl, "1", function()
                  focusedWindow():moveToUnit'[0,0,50,50]'
end)
-- top right
hs.hotkey.bind(cmdAltCtrl, "2", function()
                  focusedWindow():moveToUnit'[50,0,100,50]'
end)
-- bottom left
hs.hotkey.bind(cmdAltCtrl, "3", function()
                  focusedWindow():moveToUnit'[0,50,50,100]'
end)
-- bottom right
hs.hotkey.bind(cmdAltCtrl, "4", function()
                  focusedWindow():moveToUnit'[50,50,100,100]'
end)
-- move to previous screen
hs.hotkey.bind(cmdAltCtrl, "P", function()
                  local win = focusedWindow()
                  win:moveToScreen(win:screen():previous())
end)
-- move to next screen
hs.hotkey.bind(cmdAltCtrl, "N", function()
                  local win = focusedWindow()
                  win:moveToScreen(win:screen():next())
end)

-- resize by grid hints
hs.hotkey.bind(cmdCtrl, "W", hs.grid.toggleShow)

local resizeFocusedWindow = function(increment)
   local win = focusedWindow()
   local f = win:frame()
   f.x = f.x - increment
   f.y = f.y - increment
   f.w = f.w + increment * 2
   f.h = f.h + increment * 2
   win:setFrameInScreenBounds(f)
end
local resizeIncrement = 20

-- increase size
hs.hotkey.bind(cmdAltCtrl, "=", function()
                  resizeFocusedWindow(resizeIncrement)
end)

-- decrease size
hs.hotkey.bind(cmdAltCtrl, "-", function()
                  resizeFocusedWindow(-resizeIncrement)
end)
