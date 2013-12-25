print[[
-- Do not change this file manually
-- Generated with dev/create-region-mt.lua

local ffi = require 'ffi'

local region_mt = {__index={}}

local function cairo_create_region_mt(cairo)

   local function register(funcname)
      region_mt.__index[funcname] = cairo['region_' .. funcname]
   end

]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_region_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_region_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s')", funcname))
      defined[funcname] = true
   end
end

print()

for _, funcname in ipairs{
   'region_create',
   'region_create_rectangle',
   'region_create_rectangles',
   'image_region_copy'} do

   print(string.format([[
  function cairo.%s(...)
     local surf = cairo.C.cairo_%s(...)
     ffi.gc(surf, cairo.C.cairo_region_destroy)
     return surf
  end
]], funcname, funcname))

end

print[[

  ffi.metatype('cairo_region_t', region_mt)

end

return cairo_create_region_mt

]]
