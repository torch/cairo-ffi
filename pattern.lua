local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local Pattern = class.new('cairo.Pattern')
cairo.Pattern = class.constructor(Pattern)

Pattern.__init =
   argcheck(
   {{name="self", type="cairo.Pattern"},
    {name="cdata", type="cdata"},
    {name="incref", type="boolean", default=false}},
   function(self, cdata, incref)
      self.C = cdata
      if incref then
         C.cairo_pattern_reference(self.C)
      end
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end
)

Pattern.setMatrix =
   argcheck(
   {{name="self", type="cairo.Pattern"},
    {name="matrix", type="cairo.Matrix"}},
   function(self, matrix)
      C.cairo_pattern_set_matrix(self.C, matrix.C)
   end
)

Pattern.getMatrix =
   argcheck(
   {{name="self", type="cairo.Pattern"}},
   function(self)
      local matrix = cairo.Matrix()
      C.cairo_pattern_get_matrix(self.C, matrix.C)
      return matrix
   end
)

Pattern.status =
   argcheck(
   {{name="self", type="cairo.Pattern"}},
   function(self)
      return cairo.enums.Status[ tonumber(C.cairo_pattern_status(self.C)) ]
   end
)

Pattern.getType =
   argcheck(
   {{name="self", type="cairo.Pattern"}},
   function(self)
      return cairo.enum

Pattern.getUserData =
   argcheck(
   {{name="self", type="cairo.Pattern"},
    {name="key", type="cairo_user_data_key_t*"}},
   function(self, key)
      return C.cairo_pattern_get_user_data(self.C, key)
   end
)

Pattern.setUserData =
   argcheck(
   {{name="self", type="cairo.Pattern"},
    {name="key", type="cairo_user_data_key_t*"},
    {name="user_data", type="void*"},
    {name="destroy", type="cairo_destroy_func_t"}},
   function(self, key, user_data, destroy)
      return C.cairo_pattern_set_user_data(self.C, key, user_data, destroy)
   end
)

-------------------

local SolidPattern = class.new('cairo.SolidPattern', 'cairo.Pattern')

SolidPattern.__init =
   argcheck(
   {{name="self", type="cairo.SolidPattern"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"}},
   function(self, red, green, blue)
      self.C = C.cairo_pattern_create_rgb(red, green, blue)
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end,

   {{name="self", type="cairo.SolidPattern"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"},
    {name="alpha", type="number"}},
   function(self, red, green, blue, alpha)
      self.C = C.cairo_pattern_create_rgba(red, green, blue, alpha)
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end
)

SolidPattern.getRGBA =
   argcheck(
   {{name="self", type="cairo.Pattern"}},
   function(self)
      local red = ffi.new('double[1]')
      local green = ffi.new('double[1]')
      local blue = ffi.new('double[1]')
      local alpha = ffi.new('double[1]')
      C.cairo_pattern_get_rgba(self.C, red, green, blue, alpha)
      return red[0], green[0], blue[0], alpha[0]
   end
)

cairo.SolidPattern = class.constructor(SolidPattern)

-------------------

local SurfacePattern = class.new('cairo.SurfacePattern', 'cairo.Pattern')

SurfacePattern.__init =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"},
    {name="surface", type="cairo.Surface"}},
   function(self, surface)
      self.C = C.cairo_pattern_create_for_surface(surface.C)
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end
)

SurfacePattern.setExtend =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"},
    {name="extend", type="string"}},
   function(self, extend)
      C.cairo_pattern_set_extend(self.C, cairo.enums.Extend[extend])
   end
)

SurfacePattern.getExtend =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"}},
   function(self)
      return cairo.enums.Extend[ tonumber(C.cairo_pattern_get_extend(self.C)) ]
   end
)

SurfacePattern.setFilter =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"},
    {name="filter", type="string"}},
   function(self, filter)
      C.cairo_pattern_set_filter(self.C, cairo.enums.Filter[filter])
   end
)

SurfacePattern.getFilter =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"}},
   function(self)
      return cairo.enums.Filter[ tonumber(C.cairo_pattern_get_filter(self.C)) ]
   end
)

SurfacePattern.getSurface =
   argcheck(
   {{name="self", type="cairo.SurfacePattern"}},
   function(self)
      local surface_p = ffi.new('cairo_surface_p*[1]')
      C.cairo_pattern_get_surface(self.C, surface_p)
      return cairo.Surface(surface_p[0])
   end
)

cairo.SurfacePattern = class.constructor(SurfacePattern)

-------------------

local GradientPattern = class.new('cairo.GradientPattern', 'cairo.Pattern')

GradientPattern.addColorStopRGB =
   argcheck(
   {{name="self", type="cairo.GradientPattern"},
    {name="offset", type="number"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"}},
   function(self, offset, red, green, blue)
      C.cairo_pattern_add_color_stop_rgb(self.C, offset, red, green, blue)
   end
)

GradientPattern.addColorStopRGBA =
   argcheck(
   {{name="self", type="cairo.GradientPattern"},
    {name="offset", type="number"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"},
    {name="alpha", type="number"}},
   function(self, offset, red, green, blue, alpha)
      C.cairo_pattern_add_color_stop_rgba(self.C, offset, red, green, blue, alpha)
   end
)

GradientPattern.getColorStopCount =
   argcheck(
   {{name="self", type="cairo.GradientPattern"}},
   function(self)
      local count = ffi.new('double[1]')
      C.cairo_pattern_get_color_stop_count(self.C, count)
      return count[0]
   end
)

GradientPattern.getColorStopRGBA =
   argcheck(
   {{name="self", type="cairo.GradientPattern"},
    {name="index", type="number"}},
   function(self, index, offset, red, green, blue, alpha)
      local offset = ffi.new('double[1]')
      local red = ffi.new('double[1]')
      local green = ffi.new('double[1]')
      local blue = ffi.new('double[1]')
      local alpha = ffi.new('double[1]')
      local count = ffi.new('double[1]')
      index = index-1
      C.cairo_pattern_get_color_stop_count(self.C, count)
      assert(index >= 0 and index < count[0], 'index out of range')
      C.cairo_pattern_get_color_stop_rgba(self.C, index, offset, red, green, blue, alpha)
      return offset[0], red[0], green[0], blue[0], alpha[0]
   end
)

-------------------

local LinearGradientPattern = class.new('cairo.LinearGradientPattern', 'cairo.GradientPattern')

LinearGradientPattern.__init =
   argcheck(
   {{name="self", type="cairo.LinearGradientPattern"},
    {name="x0", type="number"},
    {name="y0", type="number"},
    {name="x1", type="number"},
    {name="y1", type="number"}},
   function(self, x0, y0, x1, y1)
      self.C = C.cairo_pattern_create_linear(x0, y0, x1, y1)
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end
)

LinearGradientPattern.getLinearPoints =
   argcheck(
   {{name="self", type="cairo.LinearGradientPattern"}},
   function(self)
      local x0 = ffi.new('double[1]')
      local y0 = ffi.new('double[1]')
      local x1 = ffi.new('double[1]')
      local y1 = ffi.new('double[1]')
      C.cairo_pattern_get_linear_points(self.C, x0, y0, x1, y1)
      return x0[0], y0[1], x1[0], y1[0]
   end
)

cairo.LinearGradientPattern = class.constructor(LinearGradientPattern)

-------------------

local RadialGradientPattern = class.new('cairo.RadialGradientPattern', 'cairo.GradientPattern')

RadialGradientPattern.__init =
   argcheck(
   {{name="self", type="cairo.RadialGradientPattern"},
    {name="cx0", type="number"},
    {name="cy0", type="number"},
    {name="radius0", type="number"},
    {name="cx1", type="number"},
    {name="cy1", type="number"},
    {name="radius1", type="number"}},
   function(self, cx0, cy0, radius0, cx1, cy1, radius1)
      self.C = C.cairo_pattern_create_radial(cx0, cy0, radius0, cx1, cy1, radius1)
      ffi.gc(self.C, C.cairo_pattern_destroy)
      return self
   end
)

RadialGradientPattern.getRadialCircles =
   argcheck(
   {{name="self", type="cairo.RadialGradientPattern"}},
   function(self)
      local x0 = ffi.new('double[1]')
      local y0 = ffi.new('double[1]')
      local r0 = ffi.new('double[1]')
      local x1 = ffi.new('double[1]')
      local y1 = ffi.new('double[1]')
      local r1 = ffi.new('double[1]')
      C.cairo_pattern_get_radial_circles(self.C, x0, y0, r0, x1, y1, r1)
      return x0[0], y0[1], r0[0], x1[0], y1[0], y1[0]
   end
)

cairo.RadialGradientPattern = class.constructor(RadialGradientPattern)

-------------------

local MeshPattern = class.new('cairo.MeshPattern', 'cairo.Pattern')

MeshPattern.__init =
   argcheck(
   {{name="self", type="cairo.MeshPattern"}},
   function(self)
      self.C = C.cairo_pattern_create_mesh()
      ffi.gc(self.C, C.cairo_pattern_destroy)
   end
)

MeshPattern.beginPatch =
   argcheck(
   {{name="self", type="cairo.MeshPattern"}},
   function(self)
      C.cairo_mesh_pattern_begin_patch(self.C)
   end
)

MeshPattern.endPatch =
   argcheck(
   {{name="self", type="cairo.MeshPattern"}},
   function(self)
      C.cairo_mesh_pattern_end_patch(self.C)
   end
)

MeshPattern.curveTo =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="x1", type="number"},
    {name="y1", type="number"},
    {name="x2", type="number"},
    {name="y2", type="number"},
    {name="x3", type="number"},
    {name="y3", type="number"}},
   function(self, x1, y1, x2, y2, x3, y3)
      C.cairo_mesh_pattern_curve_to(self.C, x1, y1, x2, y2, x3, y3)
   end
)

MeshPattern.lineTo =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="x", type="number"},
    {name="y", type="number"}},
   function(self, x, y)
      C.cairo_mesh_pattern_line_to(self.C, x, y)
   end
)

MeshPattern.moveTo =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="x", type="number"},
    {name="y", type="number"}},
   function(self, x, y)
      C.cairo_mesh_pattern_move_to(self.C, x, y)
   end
)

MeshPattern.setControlPoint =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="point_num", type="number"},
    {name="x", type="number"},
    {name="y", type="number"}},
   function(self, point_num, x, y)
      C.cairo_mesh_pattern_set_control_point(self.C, point_num, x, y)
   end
)

MeshPattern.setCornerColorRGB =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="corner_num", type="number"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"}},
   function(self, corner_num, red, green, blue)
      C.cairo_mesh_pattern_set_corner_color_rgb(self.C, corner_num, red, green, blue)
   end
)

MeshPattern.setCornerColorRgba =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="corner_num", type="number"},
    {name="red", type="number"},
    {name="green", type="number"},
    {name="blue", type="number"},
    {name="alpha", type="number"}},
   function(self, corner_num, red, green, blue, alpha)
      C.cairo_mesh_pattern_set_corner_color_rgba(self.C, corner_num, red, green, blue, alpha)
   end
)

MeshPattern.getPatchCount =
   argcheck(
   {{name="self", type="cairo.MeshPattern"}},
   function(self)
      local count = ffi.new('unsigned int[1]')
      C.cairo_mesh_pattern_get_patch_count(self.C, count)
      return count[0]
   end
)

MeshPattern.getPath =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="patch_num", type="number"}},
   function(self, patch_num)
      return cairo.Path( C.cairo_mesh_pattern_get_path(self.C, patch_num) )
   end
)

MeshPattern.getCornerColorRGBA =
   argcheck(
   {{name="self", type="cairo.MeshPattern"},
    {name="patch_num", type="number"},
    {name="corner_num", type="number"}},
   function(self, patch_num, corner_num)
      local red = ffi.new('double[1]')
      local green = ffi.new('double[1]')
      local blue = ffi.new('double[1]')
      local alpha = ffi.new('double[1]')
      if C.cairo_mesh_pattern_get_corner_color_rgba(self.C, patch_num, corner_num, red, green, blue, alpha) == ffi.C.CAIRO_STATUS_SUCCESS then
         return red[0], green[0], blue[0], alpha[0]
      end
   end
)

MeshPattern.getControlPoint =
   argcheck(
   {{name="self", type="cairo.Pattern"},
    {name="patch_num", type="number"},
    {name="point_num", type="number"}},
   function(self, patch_num, point_num)
      local x = ffi.new('double[1]')
      local y = ffi.new('double[1]')
      if C.cairo_mesh_pattern_get_control_point(self.C, patch_num, point_num, x, y) == ffi.C.CAIRO_STATUS_SUCCESS then
         return x[0], y[0]
      end
   end
)

cairo.MeshPattern = class.constructor(MeshPattern)
