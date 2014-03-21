local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local utils = require 'cairo.utils'
local C = cairo.C

local Region = class.new('cairo.Region')
cairo.Region = Region

Region.__init = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         self.C = C.cairo_region_create()
         ffi.gc(self.C, C.cairo_region_destroy)
         return self
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   chain = Region.__init,
   call =
      function(self, rectangle)
         if type(rectangle[1]) == 'table' then
            local nrectangle = #rectangle
            local rectangles = ffi.new('cairo_rectangle_int_t[?]', nrectangle)
            for i=1,nrectangle do
               utils.intrectangle_lua2C(rectangle[i], rectangles[i-1])
            end
            self.C = C.cairo_region_create_rectangles(rectangles, nrectangle)
         else
            rectangle = utils.intrectangle_lua2C(rectangle)
            self.C = C.cairo_region_create_rectangle(rectangle)         
         end
         ffi.gc(self.C, C.cairo_region_destroy)
         return self
      end   
}

Region.totable = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         local rectangles = {}
         local nrectangle = C.cairo_region_num_rectangles(self.C)
         local rectangle = ffi.new('cairo_rectangle_int_t')
         for i=1,nrectangle do
            C.cairo_region_get_rectangle(self.C, i-1, rectangle)
            table.insert(rectangles, utils.intrectangle_C2lua(rectangle))
         end
         return rectangles
      end
}

Region.copy = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         return C.cairo_region_copy(self.C)
      end
}

Region.equal = argcheck{
   {name="self", type="cairo.Region"},
   {name="other", type="cairo.Region"},
   call =
      function(self, other)
         return C.cairo_region_equal(self.C, other.C)
      end
}

Region.status = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         return cairo.enums.Status[ tonumber(C.cairo_region_status(self.C)) ]
      end
}

Region.getExtents = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self, extents)
         local extents = ffi.new('cairo_rectangle_int_t')
         C.cairo_region_get_extents(self.C, extents)
         return utils.intrectangle_C2lua(extents)
      end
}

Region.numRectangles = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         return C.cairo_region_num_rectangles(self.C)
      end
}

Region.getRectangle = argcheck{
   {name="self", type="cairo.Region"},
   {name="nth", type="number"},
   call =
      function(self, nth)
         nth = nth - 1
         local nrectangle = C.cairo_region_num_rectangles(rectangle)
         assert(nth >= 0 and nth < nrectangle, 'index out of range')
         local rectangle = ffi.new('cairo_rectangle_int_t')
         C.cairo_region_get_rectangle(self.C, nth, rectangle.C)
         return utils.intrectangle_C2lua(rectangle)
      end
}

Region.isEmpty = argcheck{
   {name="self", type="cairo.Region"},
   call =
      function(self)
         return (C.cairo_region_is_empty(self.C) == 1)
      end
}

Region.contains = argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   call =
      function(self, rectangle)
         rectangle = utils.intrectangle_lua2C(rectangle)
         return (C.cairo_region_contains_rectangle(self.C, rectangle) == 1)      
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="x", type="number"},
   {name="y", type="number"},
   chain = Region.contains,
   call =
      function(self, x, y)
         return (C.cairo_region_contains_point(self.C) == 1)
      end
}

Region.translate = argcheck{
   {name="self", type="cairo.Region"},
   {name="dx", type="number"},
   {name="dy", type="number"},
   call =
      function(self, dx, dy)
         C.cairo_region_translate(self.C, dx, dy)
      end
}

Region.subtract = argcheck{
   {name="self", type="cairo.Region"},
   {name="other", type="cairo.Region"},
   call =
      function(self, other)
         return C.cairo_region_subtract(self.C, other.C)
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   chain = Region.substract,
   call =
      function(self, rectangle)
         rectangle = utils.intrectangle_lua2C(rectangle)
         return C.cairo_region_subtract_rectangle(self.C, rectangle)
      end
}

Region.intersect = argcheck{
   {name="self", type="cairo.Region"},
   {name="other", type="cairo.Region"},
   call =
      function(self, other)
         return (C.cairo_region_intersect(self.C, other.C) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   chain = Region.intersect,
   call =
      function(self, rectangle)
         rectangle = utils.intrectangle_lua2C(rectangle)
         return (C.cairo_region_intersect_rectangle(self.C, rectangle) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

Region.union = argcheck{
   {name="self", type="cairo.Region"},
   {name="other", type="cairo.Region"},
   call =
      function(self, other)
         return (C.cairo_region_union(self.C, other.C) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   chain = Region.union,
   call =
      function(self, rectangle)
         rectangle = utils.intrectangle_lua2C(rectangle)
         return (C.cairo_region_union_rectangle(self.C, rectangle) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

Region.xor = argcheck{
   {name="self", type="cairo.Region"},
   {name="other", type="cairo.Region"},
   call =
      function(self, other)
         return (C.cairo_region_xor(self.C, other.C) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

argcheck{
   {name="self", type="cairo.Region"},
   {name="rectangle", type="table"},
   chain = Region.xor,
   call =
      function(self, rectangle)
         rectangle = utils.intrectangle_lua2C(rectangle)
         return (C.cairo_region_xor_rectangle(self.C, rectangle) == ffi.C.CAIRO_STATUS_SUCCESS)
      end
}

