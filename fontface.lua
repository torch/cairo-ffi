local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local FontFace = class.new('cairo.FontFace')
cairo.FontFace = class.constructor(FontFace)

FontFace.__init =
   argcheck(
   {{name="self", type="cairo.FontFace"},
    {name="cdata", type="cdata"},
    {name="incref", type="boolean", default=false}},
   function(self, cdata, incref)
      self.C = cdata
      if incref then
         C.cairo_font_face_reference(self.C)
      end
      ffi.gc(self.C, C.cairo_font_face_destroy)
      return self
   end
)

FontFace.status =
   argcheck(
   {{name="self", type="cairo.FontFace"}},
   function(self)
      return cairo.enums.Status[ tonumber(C.cairo_font_face_status(self.C)) ]
   end
)

FontFace.getType =
   argcheck(
   {{name="self", type="cairo.FontFace"}},
   function(self)
      return cairo.enums.FontType[ tonumber(C.cairo_font_face_get_type(self.C)) ]
   end
)

local ScaledFontFace = class.new('cairo.ScaledFontFace', 'cairo.FontFace')
cairo.ScaledFontFace = class.constructor(ScaledFontFace)

ScaledFontFace.__init =
   argcheck(
   {{name="self", type="cairo.ScaledFontFace"},
    {name="font_matrix", type="cairo.Matrix"},
    {name="ctm", type="cairo.Matrix"},
    {name="options", type="cairo.FontOptions"}},
   function(self, font_matrix, ctm, options)
      self.C = C.cairo_scaled_font_create(self.C, font_matrix.C, ctm.C, options.C)
      ffi.gc(self.C, C.cairo_scaled_font_destroy)
      return self
   end
)

local ToyFontFace = class.new('cairo.ToyFontFace', 'cairo.FontFace')
cairo.ToyFontFace = class.constructor(ToyFontFace)

ToyFontFace.__init =
   argcheck(
   {{name="self", type="cairo.ToyFontFace"},
    {name="family", type="string"},
    {name="slant", type="string"},
    {name="weight", type="string"}},
   function(self, family, slant, weight)
      self.C = C.cairo_toy_font_face_create(family, cairo.enums.FontSlant[slant], cairo.enums.FontWeight[weight])
      ffi.gc(self.C, C.cairo_font_face_destroy)
      return self
   end
)

ToyFontFace.getFamily =
   argcheck(
   {{name="self", type="cairo.ToyFontFace"}},
   function(self)
      return ffi.string(C.cairo_toy_font_face_get_family(self.C))
   end
)

ToyFontFace.getSlant =
   argcheck(
   {{name="self", type="cairo.FontFace"}},
   function(self)
      return cairo.enums.FontSlant[ tonumber(C.cairo_toy_font_face_get_slant(self.C)) ]
   end
)

ToyFontFace.getWeight =
   argcheck(
   {{name="self", type="cairo.FontFace"}},
   function(self)
      return cairo.enums.FontWeight[ tonumber(C.cairo_toy_font_face_get_weight(self.C)) ]
   end
)

