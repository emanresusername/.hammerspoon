local promise = {}

local successKey = "success"
promise.successKey = successKey
local failureKey = "failure"
promise.failureKey = failureKey

function promise.new()
  local callbackTable = {}
  local watchedPath = hs.execute("echo $RANDOM$RANDOM$RANDOM$RANDOM$RANDOM")
  local state = hs.watchable.new(watchedPath)

  hs.watchable.watch(
    watchedPath, "*",
    function(watchable, _path, key, _old, new)
      local isSuccess = key == successKey
      local isFailure = key == failureKey

      if isSuccess or isFailure then
        local onSuccess = callbackTable[successKey]
        local onFailure = callbackTable[failureKey]

        if isSuccess and callbackTable[successKey] then
          onSuccess(new)
        elseif isFailure and callbackTable[failureKey] then
          onFailure(new)
        end

        watchable:release()
      end
    end
  )

  local _promise = {}
  function _promise.onSuccess(onSuccess)
    callbackTable[successKey] = onSuccess
  end

  function _promise.onFailure(onFailure)
    callbackTable[failureKey] = onFailure
  end

  function _promise.succeed(value)
    state[successKey] = value
  end

  function _promise.fail(value)
    state[failureKey] = value
  end

  function _promise.success()
    return state[successKey]
  end

  function _promise.failure()
    return state[failureKey]
  end

  return _promise
end

return promise
