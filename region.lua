-- Do not change this file manually
-- Generated with dev/create-region-mt.lua

local ffi = require 'ffi'

local region_mt = {__index={}}

local function region_create_mt(cairo)

   local function register(funcname)
      region_mt.__index[funcname] = cairo['region_' .. funcname]
   end


  register('reference')
  register('destroy')
  register('translate')
  register('subtract')
  register('subtract_rectangle')
  register('intersect')
  register('intersect_rectangle')
  register('union')
  register('union_rectangle')
  register('xor')
  register('xor_rectangle')

  function cairo.region_create(...)
     local surf = cairo.C.cairo_region_create(...)
     ffi.gc(surf, cairo.C.cairo_region_destroy)
     return surf
  end

  function cairo.region_create_rectangle(...)
     local surf = cairo.C.cairo_region_create_rectangle(...)
     ffi.gc(surf, cairo.C.cairo_region_destroy)
     return surf
  end

  function cairo.region_create_rectangles(...)
     local surf = cairo.C.cairo_region_create_rectangles(...)
     ffi.gc(surf, cairo.C.cairo_region_destroy)
     return surf
  end

  function cairo.image_region_copy(...)
     local surf = cairo.C.cairo_image_region_copy(...)
     ffi.gc(surf, cairo.C.cairo_region_destroy)
     return surf
  end


  ffi.metatype('cairo_region_t', region_mt)

end

return region_create_mt

