-- Do not change this file manually
-- Generated with dev/create-matrix-mt.lua

local ffi = require 'ffi'

local matrix_mt = {__index={}}

local function cairo_create_matrix_mt(cairo)

   local function register(funcname)

      local status, sym = pcall(function()
                                   return cairo.C['cairo_matrix_' .. funcname]
                                end)

      if status then
         matrix_mt.__index[funcname] = sym
         return true
      end

      print('warning: method not found: ', prefix .. funcname, sym)

      return false
   end

  register('init')
  register('init_identity')
  register('init_translate')
  register('init_scale')
  register('init_rotate')
  register('translate')
  register('scale')
  register('rotate')
  register('invert')
  register('multiply')

  function cairo.matrix_create_identity(...)
     local mtx = ffi.new('cairo_matrix_t')
     cairo.C.cairo_matrix_init_identity(mtx, ...)
     return mtx
  end

  function cairo.matrix_create_translate(...)
     local mtx = ffi.new('cairo_matrix_t')
     cairo.C.cairo_matrix_init_translate(mtx, ...)
     return mtx
  end

  function cairo.matrix_create_scale(...)
     local mtx = ffi.new('cairo_matrix_t')
     cairo.C.cairo_matrix_init_scale(mtx, ...)
     return mtx
  end

  function cairo.matrix_create_rotate(...)
     local mtx = ffi.new('cairo_matrix_t')
     cairo.C.cairo_matrix_init_rotate(mtx, ...)
     return mtx
  end


  ffi.metatype('cairo_matrix_t', matrix_mt)

end

return cairo_create_matrix_mt


