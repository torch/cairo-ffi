print[[
-- Do not change this file manually
-- Generated with dev/create-pattern-mt.lua

local ffi = require 'ffi'

local pattern_mt = {__index={}}

local function cairo_create_pattern_mt(cairo)

   local function register(funcname)
      pattern_mt.__index[funcname] = cairo['pattern_' .. funcname]
   end

]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_pattern_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_pattern_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s')", funcname))
      defined[funcname] = true
   end
end

print()

for _, funcname in ipairs{
   'pattern_create_rgb',
   'pattern_create_rgba',
   'pattern_create_for_surface',
   'pattern_create_radial',
   'pattern_create_mesh'} do

   print(string.format([[
  function cairo.%s(...)
     local surf = cairo.C.cairo_%s(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end
]], funcname, funcname))

end

print[[

  ffi.metatype('cairo_pattern_t', pattern_mt)

end

return cairo_create_pattern_mt

]]
