local socket = require'socket'
local async = require'websocket.async'
local tools = require'websocket.tools'

local new = function(ws)
  ws = ws or {}
  local copas = require'copas'
  
  local self = {}
  
  self.sock_connect = function(self,host,port)
    self.sock = socket.tcp()
    if ws.timeout ~= nil then
      self.sock:settimeout(ws.timeout)
    end
    local _,err = copas.connect(self.sock,host,port)
    if err and err ~= 'already connected' then
      self.sock:close()
      return nil,err
    end
  end
  
  self.sock_send = function(self,...)
    return copas.send(self.sock,...)
  end
  
  self.sock_receive = function(self,...)
    return copas.receive(self.sock,...)
  end
  
  self.sock_close = function(self)
    if self.sock.shutdown then
      self.sock:shutdown()
    end
    self.sock:close()
  end
  
  self = async.extend(self)
  return self
end

return new
