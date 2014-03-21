local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local ImageSurface = class.new('cairo.ImageSurface', 'cairo.Surface')
cairo.ImageSurface = ImageSurface

ImageSurface.__init = argcheck{
   {name="self", type="cairo.ImageSurface"},
   {name="format", type="string"},
   {name="width", type="number"},
   {name="height", type="number"},
   call =
      function(self, format, width, height)
         self.C = C.cairo_image_surface_create(cairo.enums.Format[format], width, height)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}

argcheck{
   {name="self", type="cairo.ImageSurface"},
   {name="other", type="cairo.Surface"},
   {name="format", type="string"},
   {name="width", type="number"},
   {name="height", type="number"},
   chain = ImageSurface.__init,
   call =
      function(self, other, format, width, height)
         self.C = C.cairo_surface_create_similar_image(other.C, cairo.enums.Format[format], width, height)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}

argcheck{
   {name="self", type="cairo.ImageSurface"},
   {name="other", type="cairo.Surface"},
   {name="extents", type="table"},
   chain = ImageSurface.__init,
   call =
      function(self, other, extents)
         local extents_p = ffi.new('cairo_rectangle_int_t', extents)
         self.C = C.cairo_surface_map_to_image(other.C, extents_p)
         ffi.gc(self.C, C.cairo_surface_unmap_image)
         return self
      end
}

argcheck{
   {name="self", type="cairo.ImageSurface"},
   {name="data", type="cdata"},
   {name="format", type="string"},
   {name="width", type="number"},
   {name="height", type="number"},
   {name="stride", type="number"},
   chain = ImageSurface.__init,
   call =
      function(self, data, format, width, height, stride)
         self.C = C.cairo_image_surface_create_for_data(data, cairo.enums.Format[format], width, height, stride)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}


ImageSurface.getData = argcheck{
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_data(self.C)
      end
}

ImageSurface.getFormat = argcheck{
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return cairo.enums.Format[ tonumber(C.cairo_image_surface_get_format(self.C)) ]
      end
}

ImageSurface.getWidth = argcheck{
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_width(self.C)
      end
}

ImageSurface.getHeight = argcheck{
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_height(self.C)
      end
}

ImageSurface.getStride = argcheck{
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_stride(self.C)
      end
}
