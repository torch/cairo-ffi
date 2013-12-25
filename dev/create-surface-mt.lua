print[[
-- Do not change this file manually
-- Generated with dev/create-surface-mt.lua

local ffi = require 'ffi'

local surface_mt = {__index={}}

local function cairo_create_surface_mt(cairo)

   local function register(funcname, prefix)
      prefix = prefix or 'surface_'

      local status, sym = pcall(function()
                                   return cairo.C['cairo_' .. prefix .. funcname]
                                end)
      if status then
         surface_mt.__index[funcname] = sym
         return true
      end

      print('warning: method not found: ', prefix .. funcname, sym)

      return false
   end
]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_surface_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_surface_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s')", funcname))
      defined[funcname] = true
   end
end

print()

for funcname in txt:gmatch('cairo_image_surface_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_surface_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s', 'image_surface_')", funcname))
      defined[funcname] = true
   end
end

print()

for _, funcname in ipairs{
   'surface_create_similar',
   'surface_create_similar_image',
   'surface_create_for_rectangle',
   'image_surface_create'} do

   print(string.format([[
  function cairo.%s(...)
     local surf = cairo.C.cairo_%s(...)
     ffi.gc(surf, cairo.C.cairo_surface_destroy)
     return surf
  end
]], funcname, funcname))

end

print[[

  ffi.metatype('cairo_surface_t', surface_mt)

end

return cairo_create_surface_mt

]]
