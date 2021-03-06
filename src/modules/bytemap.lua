local _ = require('string')
local a = require('table')
local b = {}
b.__index = function(e, f) return rawget(e, f) or e.bytes[f] end
b.__newindex = function(e, f, g)
    if tonumber(f) and tonumber(g) then
        e.bytes[f] = g
    else
        rawset(e, f, g)
    end
end
local function c(e)
    local f = {}
    f.bytes = e or {}
    f.split = function(g, h)
        if h < 0 then h = a.getn(g.bytes) - ((h >= 0) and h or (h * -1)) end
        local i = {}
        for j, k in pairs(g.bytes) do
            if j > h then
                a.insert(i, k)
                g.bytes[j] = nil
            end
        end
        return g, c(i)
    end
    f.cut = function(g, h)
        if h < 0 then h = a.getn(g.bytes) - ((h >= 0) and h or (h * -1)) end
        local i = {}
        for j, k in pairs(g.bytes) do
            if j > h then
                i[j] = k
                g.bytes[j] = nil
            end
        end
        return g, c(i)
    end
    f.popStart = function(g, h)
        local i = {}
        h = h or 1
        for j = 1, h do
            local k, l = g:split(1)
            g.bytes = l.bytes
            a.insert(i, k.bytes[1])
        end
        return unpack(i)
    end
    f.popEnd = function(g)
        local h, i = g:split(-1)
        return i.bytes[1]
    end
    f.toString = function(g)
        local h = ""
        for i, j in pairs(g) do h = h .. _.char(j) end
        return h
    end
    f.toNumber = function(g, ...)
        local h = {...}
        local i = {}
        local j = #h
        if j == 0 then
            i = g.bytes
            j = #i
        else
            for l, m in pairs(h) do a.insert(i, g.bytes[m]) end
        end
        local k = ""
        for l = 1, j do k = k .. "%x" end
        return tonumber(_.format(k, unpack(i)), 16)
    end
    f.get = function(g, ...)
        local h = {}
        for i, j in pairs({...}) do a.insert(h, g.bytes[i]) end
        return unpack(h)
    end
    f.push = function(g, h)
        a.insert(g.bytes, h)
        return g
    end
    f.forEach = function(g, h)
        local i = {}
        for j, k in pairs(g.bytes) do
            local l = h(j, k)
            if l then a.insert(i, l) end
        end
        return i
    end
    f.copy = function(g) return c(g.bytes) end
    setmetatable(f, b)
    return f
end
local function d(e)
    local f = {}
    for g = 1, #e do f[g] = _.byte(e:sub(g, g)) end
    return c(f)
end
return {['new'] = c, ['fromString'] = d}
