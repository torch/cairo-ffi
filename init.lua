local cairo = require 'cairo.env'
local ffi = require 'ffi'

cairo.C = ffi.load('cairo')

require 'cairo.cdefs'
require 'cairo.enums'
require 'cairo.context'
require 'cairo.surface'
require 'cairo.imagesurface'
require 'cairo.pattern'

return cairo
