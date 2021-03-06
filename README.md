# **luvit-ws**

#### TODO
- Add a support for luvit's module system
- Request to get this posted onto luvit's package list

#### WebSocket Server Example
```lua
local ws = require('luvit-ws')

local server = ws.server:new()

function server:onListen()
    print('[SERVER] Waiting for client connections...')

    print(#server:getClients())
end

function server:onConnect(client)
    print('Client Connected - ' .. client.uid)
end

function server:onDisconnect(client)
    print('Client Disconnected - ' .. client.uid)
end

function server:onMessage(client, message)
    print(client, message)
end

server:listen(3000)

--[=[
    server:listen(port)
    server:sendAll(string)
    server:exit()

    server<client>:send(string)
    server<client>:disconnect(void)
]=]--
```

#### WebSocket Client Example
```lua
local ws = require('luvit-ws')

local client = ws.client:connect('ws://host:port') -- supports wss too

function client:onConnect()
    print('[CLIENT] Connected')
end

function client:onMessage(message)
    print(message)
end

function client:onError(message)
    print(message)
end

function client:onDisconnect()
    print('[CLIENT] Disconnected')
    require('timer').setTimeout(1000, function()
        coroutine.wrap(client.reconnect)()
    end)
end

--[=[
    client:send(string)
    client:reconnect(void)
    client:disconnect(void)
]=]--
```