function pollUri(uri, check, interval)
  interval = interval or 5
  return hs.timer.doEvery(
    interval,
    function()
      hs.http.asyncGet(uri, {}, check)
    end
  )
end

function pollUriStatusCode(uri, check, interval)
  return pollUri(
    uri,
    function(code, body, headers)
      check(code)
    end,
    interval
  )
end

function pollUri200(uri, when200, interval)
  return pollUriStatusCode(
    uri,
    function(code)
      if code == 200 then
        when200()
      end
    end,
    interval
  )
end

function pollUriBody(uri, check, interval)
  return pollUri(
    uri,
    function(code, body, headers)
      check(body)
    end,
    interval
  )
end

function pollUriBodyJson(uri, check, interval)
  return pollUriBody(
    uri,
    function(body)
      check(hs.json.decode(body))
    end,
    interval
  )
end
