print[[
-- Do not change this file manually
-- Generated with dev/create-matrix-mt.lua

local ffi = require 'ffi'

local matrix_mt = {__index={}}

local function matrix_create_mt(cairo)

   local function register(funcname)
      matrix_mt.__index[funcname] = cairo['matrix_' .. funcname]
   end

]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_matrix_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_matrix_t%s') do
   if funcname and not defined[funcname] then
      print(string.format("  register('%s')", funcname))
      defined[funcname] = true
   end
end

print()

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_matrix_init_([^%=,%.%;<%s%(%)]+)%s*%(%s*cairo_matrix_t%s') do
   print(string.format([[
  function cairo.matrix_create_%s(...)
     local mtx = ffi.new('cairo_matrix_t')
     cairo.C.cairo_matrix_init_%s(mtx, ...)
     return mtx
  end
]], funcname, funcname))
end

print[[

  ffi.metatype('cairo_matrix_t', matrix_mt)

end

return matrix_create_mt

]]
