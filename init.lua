local ffi = require 'ffi'
local C = ffi.load('cairo')
local cairo = {C=C}

require 'cairo.cdefs'

local cairo_create_shorthand = require 'cairo.shorthand'
local cairo_path = require 'cairo.path'
local cairo_create_mt = require 'cairo.cairo'
local cairo_create_surface_mt = require 'cairo.surface'
local cairo_create_pattern_mt = require 'cairo.pattern'
local cairo_create_matrix_mt = require 'cairo.matrix'

cairo_create_shorthand(cairo)
cairo_path(cairo)
cairo_create_mt(cairo)
cairo_create_surface_mt(cairo)
cairo_create_pattern_mt(cairo)
cairo_create_matrix_mt(cairo)

return cairo
