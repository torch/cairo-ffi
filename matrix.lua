local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local Matrix = class.new('cairo.Matrix')
cairo.Matrix = class.constructor(Matrix)

Matrix.__init =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="xx", type="number"},
    {name="yx", type="number"},
    {name="xy", type="number"},
    {name="yy", type="number"},
    {name="x0", type="number"},
    {name="y0", type="number"}},
   function(self, xx, yx, xy, yy, x0, y0)
      self.C = ffi.new('cairo_matrix_t')
      self:set(xx, yx, xy, yy, x0, y0)
      return self
   end,

   {{name="self", type="cairo.Matrix"},
    {name="values", type="table"}},
   function(self, values)
      self.C = ffi.new('cairo_matrix_t')
      self:set(values)
      return self
   end   
)

Matrix.set =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="xx", type="number"},
    {name="yx", type="number"},
    {name="xy", type="number"},
    {name="yy", type="number"},
    {name="x0", type="number"},
    {name="y0", type="number"}},
   function(self, xx, yx, xy, yy, x0, y0)
      cairo.C.cairo_matrix_init(self.C, xx, yx, xy, yy, x0, y0)
   end,

   {{name="self", type="cairo.Matrix"},
    {name="values", type="table"}},
   function(self, values)
      assert(values.xx and values.yx and values.xy and values.yy and values.x0 and values.y0, 'missing table fields')
      cairo.C.cairo_matrix_init(self.C, values.xx, values.yx, values.xy, values.yy, values.x0, values.y0)
   end

)

local IdentityMatrix = class.new('cairo.IdentityMatrix', 'cairo.Matrix')
cairo.IdentityMatrix = class.constructor(IdentityMatrix)

IdentityMatrix.__init =
   argcheck(
   {{name="self", type="cairo.IdentityMatrix"}},
   function(self)
      self.C = ffi.new('cairo_matrix_t')
      cairo.C.cairo_matrix_init_identity(self.C)
      return self
   end
)

local TranslateMatrix = class.new('cairo.TranslateMatrix', 'cairo.Matrix')
cairo.TranslateMatrix = class.constructor(TranslateMatrix)

TranslateMatrix.__init =
   argcheck(
   {{name="self", type="cairo.TranslateMatrix"},
    {name="tx", type="number"},
    {name="ty", type="number"}},
   function(self, tx, ty)
      self.C = ffi.new('cairo_matrix_t')
      cairo.C.cairo_matrix_init_translate(self.C, tx, ty)
      return self
   end
)

local ScaleMatrix = class.new('cairo.ScaleMatrix', 'cairo.Matrix')
cairo.ScaleMatrix = class.constructor(ScaleMatrix)

ScaleMatrix.__init =
   argcheck(
   {{name="self", type="cairo.ScaleMatrix"},
    {name="sx", type="number"},
    {name="sy", type="number"}},
   function(self, sx, sy)
      self.C = ffi.new('cairo_matrix_t')
      cairo.C.cairo_matrix_init_scale(self.C, sx, sy)
      return self
   end
)

local RotateMatrix = class.new('cairo.RotateMatrix', 'cairo.Matrix')
cairo.RotateMatrix = class.constructor(RotateMatrix)

RotateMatrix.__init =
   argcheck(
   {{name="self", type="cairo.RotateMatrix"},
    {name="radians", type="number"}},
   function(self, radians)
      self.C = ffi.new('cairo_matrix_t')
      cairo.C.cairo_matrix_init_rotate(self.C, radians)
      return self
   end
)

Matrix.translate =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="tx", type="number"},
    {name="ty", type="number"}},
   function(self, tx, ty)
      cairo.C.cairo_matrix_translate(self.C, tx, ty)
   end
)

Matrix.scale =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="sx", type="number"},
    {name="sy", type="number"}},
   function(self, sx, sy)
      cairo.C.cairo_matrix_scale(self.C, sx, sy)
   end
)

Matrix.rotate =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="radians", type="number"}},
   function(self, radians)
      cairo.C.cairo_matrix_rotate(self.C, radians)
   end
)

Matrix.invert =
   argcheck(
   {{name="self", type="cairo.Matrix"}},
   function(self)
      return cairo.C.cairo_matrix_invert(self.C)
   end
)

Matrix.multiply =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="a", type="cairo.Matrix"},
    {name="b", type="cairo.Matrix"}},
   function(self, a, b)
      cairo.C.cairo_matrix_multiply(self.C, a.C, b.C)
   end
)

Matrix.transformDistance =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="dx", type="number"},
    {name="dy", type="number"}},
   function(self, dx, dy)
      local dx_p = ffi.new('double[1]', dx)
      local dy_p = ffi.new('double[1]', dy)
      cairo.C.cairo_matrix_transform_distance(self.C, dx_p, dy_p)
      return dx_p[0], dy_p[0]
   end
)

Matrix.transformPoint =
   argcheck(
   {{name="self", type="cairo.Matrix"},
    {name="x", type="number"},
    {name="y", type="number"}},
   function(self, x, y)
      local x_p = ffi.new('double[1]', x)
      local y_p = ffi.new('double[1]', y)
      cairo.C.cairo_matrix_transform_point(self.C, x_p, y_p)
      return x_p[0], y_p[0]
   end
)

