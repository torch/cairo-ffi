local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C
local doc = require 'argcheck.doc'

doc[[

### Cairo Fonts

]]

local FontFace = class.new('cairo.FontFace')
cairo.FontFace = FontFace

FontFace.__init = argcheck{
   {name="self", type="cairo.FontFace"},
   {name="cdata", type="cdata"},
   {name="incref", type="boolean", default=false},
   call =
      function(self, cdata, incref)
         self.C = cdata
         if incref then
            C.cairo_font_face_reference(self.C)
         end
         ffi.gc(self.C, C.cairo_font_face_destroy)
         return self
      end
}

FontFace.status = argcheck{
   doc = [[
<a name="FontFace.status">
#### FontFace.status(@ARGP)

@ARGT

Checks whether an error has previously occurred for this
font face

_Return value_: [`"success"`](enums.md#Status) or another error such as
[`"no-memory"`](enums.md#Status).

]],
   {name="self", type="cairo.FontFace"},
   call =
      function(self)
         return cairo.enums.Status[ tonumber(C.cairo_font_face_status(self.C)) ]
      end
}

FontFace.getType = argcheck{
   doc = [[
<a name="FontFace.getType">
#### FontFace.getType(@ARGP)

@ARGT

This function returns the type of the backend used to create
a font face. See [`FontType`](enums.md#FontType) for available types.

_Return value_: The type of `font_face`.

]],
   {name="self", type="cairo.FontFace"},
   call =
      function(self)
         return cairo.enums.FontType[ tonumber(C.cairo_font_face_get_type(self.C)) ]
      end
}

local ScaledFontFace = class.new('cairo.ScaledFontFace', 'cairo.FontFace')
cairo.ScaledFontFace = ScaledFontFace

ScaledFontFace.__init = argcheck{
   doc = [[
<a name="ScaledFontFace.new">
#### ScaledFontFace.new(@ARGP)

@ARGT

Creates a [`ScaledFontFace`](#ScaledFontFace) object from a font face and matrices that
describe the size of the font and the environment in which it will
be used.

_Return value_: a newly created [`ScaledFontFace`](#ScaledFontFace). Destroy with
[`ScaledFontFace.destroy()`](#ScaledFontFace.destroy)

]],
   {name="self", type="cairo.ScaledFontFace"},
   {name="font_matrix", type="cairo.Matrix", doc="font space to user space transformation matrix for the font. In the simplest case of a N point font, this matrix is just a scale by N, but it can also be used to shear the font or stretch it unequally along the two axes. See [`Context.setFontMatrix()`](context.md#Context.setFontMatrix)."},
   {name="ctm", type="cairo.Matrix", doc="user to device transformation matrix with which the font will be used."},
   {name="options", type="cairo.FontOptions", doc="options to use when getting metrics for the font and rendering with it."},
   call =
      function(self, font_matrix, ctm, options)
         self.C = C.cairo_scaled_font_create(self.C, font_matrix.C, ctm.C, options.C)
         ffi.gc(self.C, C.cairo_scaled_font_destroy)
         return self
      end
}

local ToyFontFace = class.new('cairo.ToyFontFace', 'cairo.FontFace')
cairo.ToyFontFace = ToyFontFace

ToyFontFace.__init = argcheck{
   doc = [[
<a name="ToyFontFace.new">
#### ToyFontFace.new(@ARGP)

@ARGT

Creates a font face from a triplet of family, slant, and weight.
These font faces are used in implementation of the the [`Context`](context.md#Context) "toy"
font API.

If `family` is the zero-length string "", the platform-specific default
family is assumed.  The default family then can be queried using
[`ToyFontFace.getFamily()`](#ToyFontFace.getFamily).

The [`Context.selectFontFace()`](context.md#Context.selectFontFace) function uses this to create font faces.
See that function for limitations and other details of toy font faces.

_Return value_: a newly created [`FontFace`](#FontFace). Free with
[`FontFace.destroy()`](#FontFace.destroy) when you are done using it.

]],
   {name="self", type="cairo.ToyFontFace"},
   {name="family", type="string", doc="a font family name, encoded in UTF-8"},
   {name="slant", type="string", doc="the slant for the font"},
   {name="weight", type="string", doc="the weight for the font"},
   call =
      function(self, family, slant, weight)
         self.C = C.cairo_toy_font_face_create(family, cairo.enums.FontSlant[slant], cairo.enums.FontWeight[weight])
         ffi.gc(self.C, C.cairo_font_face_destroy)
         return self
      end
}

ToyFontFace.getFamily = argcheck{
   doc = [[
<a name="ToyFontFace.getFamily">
#### ToyFontFace.getFamily(@ARGP)

@ARGT

Gets the familly name of a toy font.

_Return value_: The family name.  This string is owned by the font face
and remains valid as long as the font face is alive (referenced).

]],
   {name="self", type="cairo.ToyFontFace"},
   call =
      function(self)
         return ffi.string(C.cairo_toy_font_face_get_family(self.C))
      end
}

ToyFontFace.getSlant = argcheck{
   doc = [[
<a name="ToyFontFace.getSlant">
#### ToyFontFace.getSlant(@ARGP)

@ARGT

Gets the slant a toy font.

_Return value_: The slant value

]],
   {name="self", type="cairo.FontFace"},
   call =
      function(self)
         return cairo.enums.FontSlant[ tonumber(C.cairo_toy_font_face_get_slant(self.C)) ]
      end
}

ToyFontFace.getWeight = argcheck{
   doc = [[
<a name="ToyFontFace.getWeight">
#### ToyFontFace.getWeight(@ARGP)

@ARGT

Gets the weight a toy font.

_Return value_: The weight value

]],
   {name="self", type="cairo.FontFace"},
   call =
      function(self)
         return cairo.enums.FontWeight[ tonumber(C.cairo_toy_font_face_get_weight(self.C)) ]
      end
}

