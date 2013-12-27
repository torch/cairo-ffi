local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local PNGImageSurface = class.new('cairo.PNGImageSurface', 'cairo.ImageSurface')
local Surface = class.metatable('cairo.Surface')

PNGImageSurface.__init =
   argcheck(
   {{name="self", type="cairo.PNGImageSurface"},
    {name="filename", type="string"}},
   function(self, filename)
      self.C = C.cairo_image_surface_create_from_png(filename)
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end
)

cairo.PNGImageSurface = class.constructor(PNGImageSurface)

Surface.writeToPNG =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="filename", type="string"}},
   function(self, filename)
      return C.cairo_surface_write_to_png(self.C, filename)
   end
)

Surface.writeToPNGStream =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="write_func", type="function"},
    {name="closure", type="void*"}},
   function(self, write_func, closure)
      return C.cairo_surface_write_to_png_stream(self.C, write_func, closure)
   end
)

