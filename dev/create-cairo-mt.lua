print[[
-- Do not change this file manually
-- Generated with dev/create-cairo-mt.lua

local ffi = require 'ffi'

local cairo_mt = {__index={}}

local function cairo_create_mt(cairo)

   local function register(funcname, prefix)
      prefix = prefix or 'cairo_'

      local status, sym = pcall(function()
                                   return cairo.C[prefix .. funcname]
                                end)
      if status then
         cairo_mt.__index[funcname] = sym
         return true
      end

      print('warning: method not found: ', prefix .. funcname, sym)

      return false
   end
]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s')", funcname))
      defined[funcname] = true
   end
end

print[[

  function cairo.create(...)
     local cr = cairo.C.cairo_create(...)
     ffi.gc(cr, cairo.C.cairo_destroy)
     return cr
  end

  ffi.metatype('cairo_t', cairo_mt)

end

return cairo_create_mt

]]
