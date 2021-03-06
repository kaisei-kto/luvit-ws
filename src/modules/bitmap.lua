local _ = require('bit')
local a = {}
a.__index = function(e, f) return rawget(e, f) or e.bits[f] or 0 end
a.__newindex = function(e, f, g)
    if tonumber(f) then
        e:set(f, g)
    else
        rawset(e, f, g)
    end
end
local function b(e)
    local f = {}
    f.bits = e or {}
    f.isSet = function(g, h) return g.bits[h] == 1 end
    f.set = function(g, h, i)
        g.bits[h] = i
        return g
    end
    f.toNumber = function(g) return tonumber(table.concat(g.bits, ""), 2) end
    f.areSet = function(g, ...)
        for h, i in pairs {...} do if not g.bits[i] then return false end end
        return true
    end
    f.areNotSet = function(g, ...)
        for h, i in pairs {...} do if g.bits[i] then return false end end
        return true
    end
    f.copy = function(g) return b(g.bits) end
    setmetatable(f, a)
    return f
end
local function c(e)
    local f = {}
    while e > 0 do
        local g = math.fmod(e, 2)
        f[#f + 1] = g
        e = (e - g) / 2
    end
    return b(f)
end
local function d(e, f)
    f = f or 1
    return _.band(_.rshift(e, f - 1), 1)
end
return {['new'] = b, ['fromNumber'] = c, ['isBitSet'] = d}
