function pollUri(uri, check, interval)
  interval = interval or 5
  local timer
  timer = hs.timer.new(
    interval,
    function()
      hs.http.asyncGet(uri, {}, function(code, body, headers)
                         check(code, body, headers, timer)
      end)
    end
  )
  return timer:start()
end

function pollUriStatusCode(uri, check, interval)
  return pollUri(
    uri,
    function(code, body, headers, timer)
      check(code, timer)
    end,
    interval
  )
end

function pollUri200(uri, when200, interval)
  return pollUriStatusCode(
    uri,
    function(code, timer)
      if code == 200 then
        when200(timer)
      end
    end,
    interval
  )
end

function pollUriBody(uri, check, interval)
  return pollUri(
    uri,
    function(code, body, headers, timer)
      check(body, timer)
    end,
    interval
  )
end

function pollUriBodyJson(uri, check, interval)
  return pollUriBody(
    uri,
    function(body, timer)
      check(hs.json.decode(body), timer)
    end,
    interval
  )
end
