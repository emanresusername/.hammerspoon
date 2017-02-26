return function(directory, password)
  return function(port)
    local hsminweb = hs.httpserver.hsminweb

    local httpserver = hsminweb.new(directory)
    httpserver:port(port)
    httpserver:password(password)
    httpserver:allowDirectory(true)
    return httpserver
  end
end
