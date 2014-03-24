local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C
local doc = require 'argcheck.doc'

local FontOptions = class.new('cairo.FontOptions')

FontOptions.__init = argcheck{
   doc = [[
<a name="FontOptions.new">
#### FontOptions.new(@ARGP)

@ARGT

Allocates a new font options object with all options initialized
to default values.

_Return value_: a newly allocated [`FontOptions`](#FontOptions). Free with
[`FontOptions.destroy()`](#FontOptions.destroy). This function always returns a
valid pointer; if memory cannot be allocated, then a special
error object is returned where all operations on the object do nothing.
You can check for this with [`FontOptions.status()`](#FontOptions.status).

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         self.C = C.cairo_font_options_create()      
         ffi.gc(self.C, C.cairo_font_options_destroy)
         return self
      end
}

argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="other", type="cairo.FontOptions"},
   chain = FontOptions.__init,
   call =
      function(self, other)
         self.C = C.cairo_font_options_copy(other.C)
         ffi.gc(self.C, C.cairo_font_options_destroy)
         return self      
      end
}

FontOptions.status = argcheck{
   doc = [[
<a name="FontOptions.status">
#### FontOptions.status(@ARGP)

@ARGT

Checks whether an error has previously occurred for this
font options object

_Return value_: [`"success"`](enums.md#Status) or [`"no-memory"`](enums.md#Status)

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.Status[ tonumber(C.cairo_font_options_status(self.C)) ]
      end
}

FontOptions.merge = argcheck{
   doc = [[
<a name="FontOptions.merge">
#### FontOptions.merge(@ARGP)

@ARGT

Merges non-default options from `other` into `options`, replacing
existing values. This operation can be thought of as somewhat
similar to compositing `other` onto `options` with the operation
of [`"over"`](enums.md#Operator).

]],
   {name="self", type="cairo.FontOptions"},
   {name="other", type="cairo.FontOptions", doc="another [`FontOptions`](#FontOptions)"},
   call =
      function(self, other)
         C.cairo_font_options_merge(self.C, other.C)
      end
}

FontOptions.equal = argcheck{
   doc = [[
<a name="FontOptions.equal">
#### FontOptions.equal(@ARGP)

@ARGT

Compares two font options objects for equality.

_Return value_: [`"true"`](enums.md#) if all fields of the two font options objects match.
Note that this function will return [`"false"`](enums.md#) if either object is in
error.

]],
   {name="self", type="cairo.FontOptions"},
   {name="other", type="cairo.FontOptions", doc="another [`FontOptions`](#FontOptions)"},
   call =
      function(self, other)
         return (C.cairo_font_options_equal(self.C, other.C) == 1)
      end
}

FontOptions.setAntialias = argcheck{
   doc = [[
<a name="FontOptions.setAntialias">
#### FontOptions.setAntialias(@ARGP)

@ARGT

Sets the antialiasing mode for the font options object. This
specifies the type of antialiasing to do when rendering text.

]],
   {name="self", type="cairo.FontOptions"},
   {name="antialias", type="string", doc="the new antialiasing mode"},
   call =
      function(self, antialias)
         C.cairo_font_options_set_antialias(self.C, cairo.enums.AntiAlias[antialias])
      end
}

FontOptions.getAntialias = argcheck{
   doc = [[
<a name="FontOptions.getAntialias">
#### FontOptions.getAntialias(@ARGP)

@ARGT

Gets the antialiasing mode for the font options object.

_Return value_: the antialiasing mode

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.AntiAlias[ tonumber(C.cairo_font_options_get_antialias(self.C)) ]
      end
}

FontOptions.setSubpixelOrder = argcheck{
   doc = [[
<a name="FontOptions.setSubpixelOrder">
#### FontOptions.setSubpixelOrder(@ARGP)

@ARGT

Sets the subpixel order for the font options object. The subpixel
order specifies the order of color elements within each pixel on
the display device when rendering with an antialiasing mode of
[`"subpixel"`](enums.md#Antialias). See the documentation for
[`SubpixelOrder`](enums.md#SubpixelOrder) for full details.

]],
   {name="self", type="cairo.FontOptions"},
   {name="subpixel_order", type="string", doc="the new subpixel order"},
   call =
      function(self, subpixel_order)
         C.cairo_font_options_set_subpixel_order(self.C, cairo.enums.SubpixelOrder[subpixel_order])
      end
}

FontOptions.getSubpixelOrder = argcheck{
   doc = [[
<a name="FontOptions.getSubpixelOrder">
#### FontOptions.getSubpixelOrder(@ARGP)

@ARGT

Gets the subpixel order for the font options object.
See the documentation for [`SubpixelOrder`](enums.md#SubpixelOrder) for full details.

_Return value_: the subpixel order for the font options object

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.SubpixelOrder[ tonumber(C.cairo_font_options_get_subpixel_order(self.C)) ]
      end
}

FontOptions.setHintStyle = argcheck{
   doc = [[
<a name="FontOptions.setHintStyle">
#### FontOptions.setHintStyle(@ARGP)

@ARGT

Sets the hint style for font outlines for the font options object.
This controls whether to fit font outlines to the pixel grid,
and if so, whether to optimize for fidelity or contrast.
See the documentation for [`HintStyle`](enums.md#HintStyle) for full details.

]],
   {name="self", type="cairo.FontOptions"},
   {name="hint_style", type="string", doc="the new hint style"},
   call =
      function(self, hint_style)
         C.cairo_font_options_set_hint_style(self.C, cairo.enums.HintStyle[hint_style])
      end
}

FontOptions.getHintStyle = argcheck{
   doc = [[
<a name="FontOptions.getHintStyle">
#### FontOptions.getHintStyle(@ARGP)

@ARGT

Gets the hint style for font outlines for the font options object.
See the documentation for [`HintStyle`](enums.md#HintStyle) for full details.

_Return value_: the hint style for the font options object

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.HintStyle[ tonumber(C.cairo_font_options_get_hint_style(self.C)) ]
      end
}

FontOptions.setHintMetrics = argcheck{
   doc = [[
<a name="FontOptions.setHintMetrics">
#### FontOptions.setHintMetrics(@ARGP)

@ARGT

Sets the metrics hinting mode for the font options object. This
controls whether metrics are quantized to integer values in
device units.
See the documentation for [`HintMetrics`](enums.md#HintMetrics) for full details.

]],
   {name="self", type="cairo.FontOptions"},
   {name="hint_metrics", type="string", doc="the new metrics hinting mode"},
   call =
      function(self, hint_metrics)
         C.cairo_font_options_set_hint_metrics(self.C, cairo.enums.HintMetrics[hint_metrics])
      end
}

FontOptions.getHintMetrics = argcheck{
   doc = [[
<a name="FontOptions.getHintMetrics">
#### FontOptions.getHintMetrics(@ARGP)

@ARGT

Gets the metrics hinting mode for the font options object.
See the documentation for [`HintMetrics`](enums.md#HintMetrics) for full details.

_Return value_: the metrics hinting mode for the font options object

]],
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.HintMetrics[ tonumber(C.cairo_font_options_get_hint_metrics(self.C)) ]
      end
}

