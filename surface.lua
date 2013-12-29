local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local Surface = class.new('cairo.Surface')

Surface.__init =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="surface", type="cairo.Surface"},
    {name="content", type="string"},
    {name="width", type="number"},
    {name="height", type="number"}},
   function(self, surface, content, width, height)
      self.C = C.cairo_surface_create_similar(surface.C, cairo.enums.Content[content], width, height)
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end,

   {{name="self", type="cairo.Surface"},
    {name="surface", type="cairo.Surface"},
    {name="x", type="number"},
    {name="y", type="number"},
    {name="width", type="number"},
    {name="height", type="number"}},
   function(self, surface, x, y, width, height)
      self.C = C.cairo_surface_create_for_rectangle(surface.C, x, y, width, height)
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end,

  {{name="self", type="cairo.Surface"},
    {name="cdata", type="cdata"},
    {name="incref", type="boolean", default=false}},
   function(self, cdata, incref)
      self.C = cdata
      if incref then
         C.cairo_surface_reference(self.C)
      end
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end
)

Surface.finish =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      C.cairo_surface_finish(self.C)
   end
)

Surface.getDevice =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      return cairo.Device(C.cairo_surface_get_device(self.C))
   end
)

Surface.status =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      return cairo.enums.Status[ tonumber(C.cairo_surface_status(self.C)) ]
   end
)

Surface.getType =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      return cairo.enums.SurfaceType[ tonumber(C.cairo_surface_get_type(self.C)) ]
   end
)

Surface.getContent =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      return cairo.enums.Content[ tonumber(C.cairo_surface_get_content(self.C)) ]
   end
)

Surface.getUserData =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="key", type="cairo_user_data_key_t*"}},
   function(self, key)
      return C.cairo_surface_get_user_data(self.C, key)
   end
)

Surface.setUserData =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="key", type="cairo_user_data_key_t*"},
    {name="user_data", type="void*"},
    {name="destroy", type="cairo_destroy_func_t"}},
   function(self, key, user_data, destroy)
      return C.cairo_surface_set_user_data(self.C, key, user_data, destroy)
   end
)

Surface.getMimeData =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="mime_type", type="string"},
    {name="data", type="unsigned char**"},
    {name="length", type="unsigned long*"}},
   function(self, mime_type, data, length)
      C.cairo_surface_get_mime_data(self.C, mime_type, data, length)
   end
)

Surface.setMimeData =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="mime_type", type="string"},
    {name="data", type="unsigned char*"},
    {name="length", type="number"},
    {name="destroy", type="cairo_destroy_func_t"},
    {name="closure", type="void*"}},
   function(self, mime_type, data, length, destroy, closure)
      return C.cairo_surface_set_mime_data(self.C, mime_type, data, length, destroy, closure)
   end
)

Surface.supportsMimeType =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="mime_type", type="string"}},
   function(self, mime_type)
      return C.cairo_surface_supports_mime_type(self.C, mime_type)
   end
)

Surface.getFontOptions =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="options", type="cairo.FontOptions"}},
   function(self, options)
      cairo.FontOptions( C.cairo_surface_get_font_options(self.C, options.C) )
   end
)

Surface.flush =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      C.cairo_surface_flush(self.C)
   end
)

Surface.markDirty =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      C.cairo_surface_mark_dirty(self.C)
   end
)

Surface.markDirtyRectangle =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="x", type="number"},
    {name="y", type="number"},
    {name="width", type="number"},
    {name="height", type="number"}},
   function(self, x, y, width, height)
      C.cairo_surface_mark_dirty_rectangle(self.C, x, y, width, height)
   end
)

Surface.setDeviceOffset =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="x_offset", type="number"},
    {name="y_offset", type="number"}},
   function(self, x_offset, y_offset)
      C.cairo_surface_set_device_offset(self.C, x_offset, y_offset)
   end
)

Surface.getDeviceOffset =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      local x_offset = ffi.new('double[1]')
      local y_offset = ffi.new('double[1]')
      C.cairo_surface_get_device_offset(self.C, x_offset, y_offset)
      return x_offset[0], y_offset[0]
   end
)

Surface.setFallbackResolution =
   argcheck(
   {{name="self", type="cairo.Surface"},
    {name="x_pixels_per_inch", type="number"},
    {name="y_pixels_per_inch", type="number"}},
   function(self, x_pixels_per_inch, y_pixels_per_inch)
      C.cairo_surface_set_fallback_resolution(self.C, x_pixels_per_inch, y_pixels_per_inch)
   end
)

Surface.getFallbackResolution =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      local x_pixels_per_inch = ffi.new('double[1]')
      local y_pixels_per_inch = ffi.new('double[1]')
      C.cairo_surface_get_fallback_resolution(self.C, x_pixels_per_inch, y_pixels_per_inch)
      return x_pixels_per_inch[0], y_pixels_per_inch[0]
   end
)

Surface.copyPage =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      C.cairo_surface_copy_page(self.C)
   end
)

Surface.showPage =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      C.cairo_surface_show_page(self.C)
   end
)

Surface.hasShowTextGlyphs =
   argcheck(
   {{name="self", type="cairo.Surface"}},
   function(self)
      return (C.cairo_surface_has_show_text_glyphs(self.C) == 1)
   end
)

cairo.Surface = class.constructor(Surface)
