local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C
local doc = require 'argcheck.doc'

doc[[

### Transformation matrices

]]

local Matrix = class.new('cairo.Matrix')
cairo.Matrix = Matrix

Matrix.__init = argcheck{
   nonamed = true,
   {name="self", type="cairo.Matrix"},
   call =
      function(self)
         self.C = ffi.new('cairo_matrix_t')
         return self
      end
}

Matrix.__init = argcheck{
   {name="self", type="cairo.Matrix"},
   {name="xx", type="number"},
   {name="yx", type="number"},
   {name="xy", type="number"},
   {name="yy", type="number"},
   {name="x0", type="number"},
   {name="y0", type="number"},
   overload = Matrix.__init,
   call =
      function(self, xx, yx, xy, yy, x0, y0)
         self.C = ffi.new('cairo_matrix_t')
         self:set(xx, yx, xy, yy, x0, y0)
         return self
      end
}

Matrix.__init = argcheck{
   {name="self", type="cairo.Matrix"},
   {name="values", type="table"},
   overload = Matrix.__init,
   call =
      function(self, values)
         self.C = ffi.new('cairo_matrix_t')
         self:set(values)
         return self
      end   
}

Matrix.totable = argcheck{
   {name="self", type="cairo.Matrix"},
   call =
      function(self)
         return {xx=self.C.xx, yx=self.C.yx, yy=self.C.xy, yy=self.C.yy, x0=self.C.x0, y0=self.C.y0}
      end
}

Matrix.set = argcheck{
   {name="self", type="cairo.Matrix"},
   {name="xx", type="number"},
   {name="yx", type="number"},
   {name="xy", type="number"},
   {name="yy", type="number"},
   {name="x0", type="number"},
   {name="y0", type="number"},
   call =
      function(self, xx, yx, xy, yy, x0, y0)
         cairo.C.cairo_matrix_init(self.C, xx, yx, xy, yy, x0, y0)
      end
}

Matrix.set = argcheck{
   {name="self", type="cairo.Matrix"},
   {name="values", type="table"},
   overload = Matrix.set,
   call =
      function(self, values)
         assert(values.xx and values.yx and values.xy and values.yy and values.x0 and values.y0, 'missing table fields')
         cairo.C.cairo_matrix_init(self.C, values.xx, values.yx, values.xy, values.yy, values.x0, values.y0)
      end
}

local IdentityMatrix = class.new('cairo.IdentityMatrix', 'cairo.Matrix')
cairo.IdentityMatrix = IdentityMatrix

IdentityMatrix.__init = argcheck{
   {name="self", type="cairo.IdentityMatrix"},
   call =
      function(self)
         self.C = ffi.new('cairo_matrix_t')
         cairo.C.cairo_matrix_init_identity(self.C)
         return self
      end
}

local TranslateMatrix = class.new('cairo.TranslateMatrix', 'cairo.Matrix')
cairo.TranslateMatrix = TranslateMatrix

TranslateMatrix.__init = argcheck{
   {name="self", type="cairo.TranslateMatrix"},
   {name="tx", type="number"},
   {name="ty", type="number"},
   call =
      function(self, tx, ty)
         self.C = ffi.new('cairo_matrix_t')
         cairo.C.cairo_matrix_init_translate(self.C, tx, ty)
         return self
      end
}

local ScaleMatrix = class.new('cairo.ScaleMatrix', 'cairo.Matrix')
cairo.ScaleMatrix = ScaleMatrix

ScaleMatrix.__init = argcheck{
   {name="self", type="cairo.ScaleMatrix"},
   {name="sx", type="number"},
   {name="sy", type="number"},
   call =
      function(self, sx, sy)
         self.C = ffi.new('cairo_matrix_t')
         cairo.C.cairo_matrix_init_scale(self.C, sx, sy)
         return self
      end
}

local RotateMatrix = class.new('cairo.RotateMatrix', 'cairo.Matrix')
cairo.RotateMatrix = RotateMatrix

RotateMatrix.__init = argcheck{
   {name="self", type="cairo.RotateMatrix"},
   {name="radians", type="number"},
   call =
      function(self, radians)
         self.C = ffi.new('cairo_matrix_t')
         cairo.C.cairo_matrix_init_rotate(self.C, radians)
         return self
      end
}

Matrix.translate = argcheck{
   doc = [[
<a name="Matrix.translate">
#### Matrix.translate(@ARGP)

@ARGT

Applies a translation by `tx`, `ty` to the transformation in
`matrix`. The effect of the new transformation is to first translate
the coordinates by `tx` and `ty`, then apply the original transformation
to the coordinates.

]],
   {name="self", type="cairo.Matrix"},
   {name="tx", type="number", doc="amount to translate in the X direction"},
   {name="ty", type="number", doc="amount to translate in the Y direction"},
   call =
      function(self, tx, ty)
         cairo.C.cairo_matrix_translate(self.C, tx, ty)
      end
}

Matrix.scale = argcheck{
   doc = [[
<a name="Matrix.scale">
#### Matrix.scale(@ARGP)

@ARGT

Applies scaling by `sx`, `sy` to the transformation in `matrix`. The
effect of the new transformation is to first scale the coordinates
by `sx` and `sy`, then apply the original transformation to the coordinates.

]],
   {name="self", type="cairo.Matrix"},
   {name="sx", type="number", doc="scale factor in the X direction"},
   {name="sy", type="number", doc="scale factor in the Y direction"},
   call =
      function(self, sx, sy)
         cairo.C.cairo_matrix_scale(self.C, sx, sy)
      end
}

Matrix.rotate = argcheck{
   doc = [[
<a name="Matrix.rotate">
#### Matrix.rotate(@ARGP)

@ARGT

Applies rotation by `radians` to the transformation in
`matrix`. The effect of the new transformation is to first rotate the
coordinates by `radians`, then apply the original transformation
to the coordinates.

]],
   {name="self", type="cairo.Matrix"},
   {name="radians", type="number", doc="angle of rotation, in radians. The direction of rotation is defined such that positive angles rotate in the direction from the positive X axis toward the positive Y axis. With the default axis orientation of cairo, positive angles rotate in a clockwise direction."},
   call =
      function(self, radians)
         cairo.C.cairo_matrix_rotate(self.C, radians)
      end
}

Matrix.invert = argcheck{
   doc = [[
<a name="Matrix.invert">
#### Matrix.invert(@ARGP)

@ARGT

Changes `matrix` to be the inverse of its original value. Not
all transformation matrices have inverses; if the matrix
collapses points together (it is degenerate),
then it has no inverse and this function will fail.

_Returns_: If `matrix` has an inverse, modifies `matrix` to
be the inverse matrix and returns [`"success"`](enums.md#Status). Otherwise,
returns [`"invalid-matrix"`](enums.md#Status).

]],
   {name="self", type="cairo.Matrix"},
   call =
      function(self)
         return cairo.C.cairo_matrix_invert(self.C)
      end
}

Matrix.multiply = argcheck{
   doc = [[
<a name="Matrix.multiply">
#### Matrix.multiply(@ARGP)

@ARGT

Multiplies the affine transformations in `a` and `b` together
and stores the result in `result`. The effect of the resulting
transformation is to first apply the transformation in `a` to the
coordinates and then apply the transformation in `b` to the
coordinates.

It is allowable for `result` to be identical to either `a` or `b`.

]],
   {name="self", type="cairo.Matrix"},
   {name="a", type="cairo.Matrix", doc="a [`Matrix`](#Matrix)"},
   {name="b", type="cairo.Matrix", doc="a [`Matrix`](#Matrix)"},
   call =
      function(self, a, b)
         cairo.C.cairo_matrix_multiply(self.C, a.C, b.C)
      end
}

Matrix.transformDistance = argcheck{
   doc = [[
<a name="Matrix.transformDistance">
#### Matrix.transformDistance(@ARGP)

@ARGT

Transforms the distance vector (`dx`,`dy`) by `matrix`. This is
similar to [`Matrix.transformPoint()`](#Matrix.transformPoint) except that the translation
components of the transformation are ignored. The calculation of
the returned vector is as follows:

```lua
dx2 = dx1 * a + dy1 * c;
dy2 = dx1 * b + dy1 * d;
```

Affine transformations are position invariant, so the same vector
always transforms to the same vector. If (`x1`,`y1`) transforms
to (`x2`,`y2`) then (`x1`+`dx1`,`y1`+`dy1`) will transform to
(`x1`+`dx2`,`y1`+`dy2`) for all values of `x1` and `x2`.

]],
   {name="self", type="cairo.Matrix"},
   {name="dx", type="number", doc="X component of a distance vector. An in/out parameter"},
   {name="dy", type="number", doc="Y component of a distance vector. An in/out parameter"},
   call =
      function(self, dx, dy)
         local dx_p = ffi.new('double[1]', dx)
         local dy_p = ffi.new('double[1]', dy)
         cairo.C.cairo_matrix_transform_distance(self.C, dx_p, dy_p)
         return dx_p[0], dy_p[0]
      end
}

Matrix.transformPoint = argcheck{
   doc = [[
<a name="Matrix.transformPoint">
#### Matrix.transformPoint(@ARGP)

@ARGT

Transforms the point (`x`, `y`) by `matrix`.

]],
   {name="self", type="cairo.Matrix"},
   {name="x", type="number", doc="X position. An in/out parameter"},
   {name="y", type="number", doc="Y position. An in/out parameter"},
   call =
      function(self, x, y)
         local x_p = ffi.new('double[1]', x)
         local y_p = ffi.new('double[1]', y)
         cairo.C.cairo_matrix_transform_point(self.C, x_p, y_p)
         return x_p[0], y_p[0]
      end
}
