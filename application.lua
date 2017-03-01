local application = hs.application

application.enableSpotlightForNameSearches(true)

function application.hotkey(app, mods, key, pressedfn)
  local hotkey = hs.hotkey.new(mods, key, function()
                                 pressedfn(app)
  end)
  local watcher = hs.application.watcher.new(function(name, event, application)
      if application == app then
        if event == hs.application.watcher.activated then
          hotkey:enable()
        end
        if event == hs.application.watcher.deactivated then
          hotkey:disable()
        end
      end
  end)
  watcher:start()
  return hotkey, watcher
end

return application
