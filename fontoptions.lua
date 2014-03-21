local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local FontOptions = class.new('cairo.FontOptions')

FontOptions.__init = argcheck{
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
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.Status[ tonumber(C.cairo_font_options_status(self.C)) ]
      end
}

FontOptions.merge = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="other", type="cairo.FontOptions"},
   call =
      function(self, other)
         C.cairo_font_options_merge(self.C, other.C)
      end
}

FontOptions.equal = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="other", type="cairo.FontOptions"},
   call =
      function(self, other)
         return (C.cairo_font_options_equal(self.C, other.C) == 1)
      end
}

FontOptions.setAntialias = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="antialias", type="string"},
   call =
      function(self, antialias)
         C.cairo_font_options_set_antialias(self.C, cairo.enums.AntiAlias[antialias])
      end
}

FontOptions.getAntialias = argcheck{
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.AntiAlias[ tonumber(C.cairo_font_options_get_antialias(self.C)) ]
      end
}

FontOptions.setSubpixelOrder = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="subpixel_order", type="string"},
   call =
      function(self, subpixel_order)
         C.cairo_font_options_set_subpixel_order(self.C, cairo.enums.SubpixelOrder[subpixel_order])
      end
}

FontOptions.getSubpixelOrder = argcheck{
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.SubpixelOrder[ tonumber(C.cairo_font_options_get_subpixel_order(self.C)) ]
      end
}

FontOptions.setHintStyle = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="hint_style", type="string"},
   call =
      function(self, hint_style)
         C.cairo_font_options_set_hint_style(self.C, cairo.enums.HintStyle[hint_style])
      end
}

FontOptions.getHintStyle = argcheck{
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.HintStyle[ tonumber(C.cairo_font_options_get_hint_style(self.C)) ]
      end
}

FontOptions.setHintMetrics = argcheck{
   {name="self", type="cairo.FontOptions"},
   {name="hint_metrics", type="string"},
   call =
      function(self, hint_metrics)
         C.cairo_font_options_set_hint_metrics(self.C, cairo.enums.HintMetrics[hint_metrics])
      end
}

FontOptions.getHintMetrics = argcheck{
   {name="self", type="cairo.FontOptions"},
   call =
      function(self)
         return cairo.enums.HintMetrics[ tonumber(C.cairo_font_options_get_hint_metrics(self.C)) ]
      end
}

