-- Do not change this file manually
-- Generated with dev/create-pattern-mt.lua

local ffi = require 'ffi'

local pattern_mt = {__index={}}

local function cairo_create_pattern_mt(cairo)

   local function register(funcname, prefix)
      prefix = prefix or 'cairo_pattern_'

      local status, sym = pcall(function()
                                   return cairo.C[prefix .. funcname]
                                end)

      if status then
         pattern_mt.__index[funcname] = sym
         return true
      end

      print('warning: method not found: ', prefix .. funcname, sym)

      return false
   end

  register('reference')
  register('destroy')
  register('get_reference_count')
  register('status')
  register('get_user_data')
  register('set_user_data')
  register('get_type')
  register('add_color_stop_rgb')
  register('add_color_stop_rgba')
  register('set_matrix')
  register('get_matrix')
  register('set_extend')
  register('get_extend')
  register('set_filter')
  register('get_filter')
  register('get_rgba')
  register('get_surface')
  register('get_color_stop_rgba')
  register('get_color_stop_count')
  register('get_linear_points')
  register('get_radial_circles')

  function cairo.pattern_create_rgb(...)
     local surf = cairo.C.cairo_pattern_create_rgb(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end

  function cairo.pattern_create_rgba(...)
     local surf = cairo.C.cairo_pattern_create_rgba(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end

  function cairo.pattern_create_for_surface(...)
     local surf = cairo.C.cairo_pattern_create_for_surface(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end

  function cairo.pattern_create_radial(...)
     local surf = cairo.C.cairo_pattern_create_radial(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end

  function cairo.pattern_create_mesh(...)
     local surf = cairo.C.cairo_pattern_create_mesh(...)
     ffi.gc(surf, cairo.C.cairo_pattern_destroy)
     return surf
  end


  ffi.metatype('cairo_pattern_t', pattern_mt)

end

return cairo_create_pattern_mt


