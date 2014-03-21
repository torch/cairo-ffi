local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local utils = require 'cairo.utils'
local C = cairo.C

local Context = class.new('cairo.Context')
cairo.Context = Context

Context.__init = argcheck{
   {name="self", type="cairo.Context"},
   {name="surface", type="cairo.Surface"},
   call =
      function(self, surface)
         self.C = C.cairo_create(surface.C)
         ffi.gc(self.C, C.cairo_destroy)
         return self
      end
}

Context.save = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_save(self.C)
      end
}

Context.restore = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_restore(self.C)
      end
}

Context.pushGroup = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_push_group(self.C)
      end
}

Context.pushGroupWithContent = argcheck{
   {name="self", type="cairo.Context"},
   {name="content", type="string"},
   call =
      function(self, content)
         C.cairo_push_group_with_content(self.C, cairo.enums.Content[content])
      end
}

Context.popGroup = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Pattern(C.cairo_pop_group(self.C))
      end
}

Context.popGroupToSource = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_pop_group_to_source(self.C)
      end
}

Context.setOperator = argcheck{
   {name="self", type="cairo.Context"},
   {name="op", type="string"},
   call =
      function(self, op)
         C.cairo_set_operator(self.C, cairo.enums.Operator[op])
      end
}

Context.setSource = argcheck{
   {name="self", type="cairo.Context"},
   {name="source", type="cairo.Pattern"},
   call =
      function(self, source)
         C.cairo_set_source(self.C, source.C)
      end
}

Context.setSourceRGB = argcheck{
   {name="self", type="cairo.Context"},
   {name="red", type="number"},
   {name="green", type="number"},
   {name="blue", type="number"},
   call =
      function(self, red, green, blue)
         C.cairo_set_source_rgb(self.C, red, green, blue)
      end
}

Context.setSourceRGBA = argcheck{
   {name="self", type="cairo.Context"},
   {name="red", type="number"},
   {name="green", type="number"},
   {name="blue", type="number"},
   {name="alpha", type="number"},
   call =
      function(self, red, green, blue, alpha)
         C.cairo_set_source_rgba(self.C, red, green, blue, alpha)
      end
}

Context.setSourceSurface = argcheck{
   {name="self", type="cairo.Context"},
   {name="surface", type="cairo.Surface"},
   {name="x", type="number", default=0},
   {name="y", type="number", default=0},
   call =
      function(self, surface, x, y)
         C.cairo_set_source_surface(self.C, surface.C, x, y)
      end
}

Context.setTolerance = argcheck{
   {name="self", type="cairo.Context"},
   {name="tolerance", type="number"},
   call =
      function(self, tolerance)
         C.cairo_set_tolerance(self.C, tolerance)
      end
}

Context.setAntialias = argcheck{
   {name="self", type="cairo.Context"},
   {name="antialias", type="string"},
   call =
      function(self, antialias)
         C.cairo_set_antialias(self.C, cairo.enums.AntiAlias[antialias])
      end
}

Context.setFillRule = argcheck{
   {name="self", type="cairo.Context"},
   {name="fill_rule", type="string"},
   call =
      function(self, fill_rule)
         C.cairo_set_fill_rule(self.C, cairo.enums.FillRule[fill_rule])
      end
}

Context.setLineWidth = argcheck{
   {name="self", type="cairo.Context"},
   {name="width", type="number"},
   call =
      function(self, width)
         C.cairo_set_line_width(self.C, width)
      end
}

Context.setLineCap = argcheck{
   {name="self", type="cairo.Context"},
   {name="line_cap", type="string"},
   call =
      function(self, line_cap)
         C.cairo_set_line_cap(self.C, cairo.enums.LineCap[line_cap])
      end
}

Context.setLineJoin = argcheck{
   {name="self", type="cairo.Context"},
   {name="line_join", type="string"},
   call =
      function(self, line_join)
         C.cairo_set_line_join(self.C, cairo.enums.LineJoin[line_join])
      end
}

Context.setDash = argcheck{
   {name="self", type="cairo.Context"},
   {name="dashes", type="table"},
   {name="offset", type="number"},
   call =
      function(self, dashes, offset)
         local num_dashes = #dashes
         local dashes_p = ffi.new('double[?]', num_dashes, dashes)
         C.cairo_set_dash(self.C, dashes_p, num_dashes, offset)
      end
}

Context.setMiterLimit = argcheck{
   {name="self", type="cairo.Context"},
   {name="limit", type="number"},
   call =
      function(self, limit)
         C.cairo_set_miter_limit(self.C, limit)
      end
}

Context.translate = argcheck{
   {name="self", type="cairo.Context"},
   {name="tx", type="number"},
   {name="ty", type="number"},
   call =
      function(self, tx, ty)
         C.cairo_translate(self.C, tx, ty)
      end
}

Context.scale = argcheck{
   {name="self", type="cairo.Context"},
   {name="sx", type="number"},
   {name="sy", type="number"},
   call =
      function(self, sx, sy)
         C.cairo_scale(self.C, sx, sy)
      end
}

Context.rotate = argcheck{
   {name="self", type="cairo.Context"},
   {name="angle", type="number"},
   call =
      function(self, angle)
         C.cairo_rotate(self.C, angle)
      end
}

Context.transform = argcheck{
   {name="self", type="cairo.Context"},
   {name="matrix", type="cairo.Matrix"},
   call =
      function(self, matrix)
         C.cairo_transform(self.C, matrix.C)
      end
}

Context.setMatrix = argcheck{
   {name="self", type="cairo.Context"},
   {name="matrix", type="cairo.Matrix"},
   call =
      function(self, matrix)
         C.cairo_set_matrix(self.C, matrix.C)
      end
}

Context.identityMatrix = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_identity_matrix(self.C)
      end
}

Context.userToDevice = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self, x, y)
         local x = ffi.new('double[1]')
         local y = ffi.new('double[1]')
         C.cairo_user_to_device(self.C, x, y)
         return x[0], y[0]
      end
}

Context.userToDeviceDistance = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local dx = ffi.new('double[1]')
         local dy = ffi.new('double[1]')
         C.cairo_user_to_device_distance(self.C, dx, dy)
         return dx[0], dy[0]
      end
}

Context.deviceToUser = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x = ffi.new('double[1]')
         local y = ffi.new('double[1]')
         C.cairo_device_to_user(self.C, x, y)
         return x[0], y[0]
      end
}

Context.deviceToUserDistance = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local dx = ffi.new('double[1]')
         local dy = ffi.new('double[1]')
         C.cairo_device_to_user_distance(self.C, dx, dy)
         return dx[0], dy[0]
      end
}

Context.newPath = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_new_path(self.C)
      end
}

Context.moveTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   call =
      function(self, x, y)
         C.cairo_move_to(self.C, x, y)
      end
}

Context.newSubPath = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_new_sub_path(self.C)
      end
}

Context.lineTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   call =
      function(self, x, y)
         C.cairo_line_to(self.C, x, y)
      end
}

Context.curveTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="x1", type="number"},
   {name="y1", type="number"},
   {name="x2", type="number"},
   {name="y2", type="number"},
   {name="x3", type="number"},
   {name="y3", type="number"},
   call =
      function(self, x1, y1, x2, y2, x3, y3)
         C.cairo_curve_to(self.C, x1, y1, x2, y2, x3, y3)
      end
}

Context.arc = argcheck{
   {name="self", type="cairo.Context"},
   {name="xc", type="number"},
   {name="yc", type="number"},
   {name="radius", type="number"},
   {name="angle1", type="number"},
   {name="angle2", type="number"},
   call =
      function(self, xc, yc, radius, angle1, angle2)
         C.cairo_arc(self.C, xc, yc, radius, angle1, angle2)
      end
}

Context.arcNegative = argcheck{
   {name="self", type="cairo.Context"},
   {name="xc", type="number"},
   {name="yc", type="number"},
   {name="radius", type="number"},
   {name="angle1", type="number"},
   {name="angle2", type="number"},
   call =
      function(self, xc, yc, radius, angle1, angle2)
         C.cairo_arc_negative(self.C, xc, yc, radius, angle1, angle2)
      end
}

Context.relMoveTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="dx", type="number"},
   {name="dy", type="number"},
   call =
      function(self, dx, dy)
         C.cairo_rel_move_to(self.C, dx, dy)
      end
}

Context.relLineTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="dx", type="number"},
   {name="dy", type="number"},
   call =
      function(self, dx, dy)
         C.cairo_rel_line_to(self.C, dx, dy)
      end
}

Context.relCurveTo = argcheck{
   {name="self", type="cairo.Context"},
   {name="dx1", type="number"},
   {name="dy1", type="number"},
   {name="dx2", type="number"},
   {name="dy2", type="number"},
   {name="dx3", type="number"},
   {name="dy3", type="number"},
   call =
      function(self, dx1, dy1, dx2, dy2, dx3, dy3)
         C.cairo_rel_curve_to(self.C, dx1, dy1, dx2, dy2, dx3, dy3)
      end
}

Context.rectangle = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   {name="width", type="number"},
   {name="height", type="number"},
   call =
      function(self, x, y, width, height)
         C.cairo_rectangle(self.C, x, y, width, height)
      end
}

Context.closePath = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_close_path(self.C)
      end
}

Context.pathExtents = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x1 = ffi.new('double[1]')
         local y1 = ffi.new('double[1]')
         local x2 = ffi.new('double[1]')
         local y2 = ffi.new('double[1]')
         C.cairo_path_extents(self.C, x1, y1, x2, y2)
         return x1[0], y1[0], x2[0], y2[0]
      end
}

Context.paint = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_paint(self.C)
      end
}

Context.paintWithAlpha = argcheck{
   {name="self", type="cairo.Context"},
   {name="alpha", type="number"},
   call =
      function(self, alpha)
         C.cairo_paint_with_alpha(self.C, alpha)
      end
}

Context.mask = argcheck{
   {name="self", type="cairo.Context"},
   {name="pattern", type="cairo.Pattern"},
   call =
      function(self, pattern)
         C.cairo_mask(self.C, pattern.C)
      end
}

Context.maskSurface = argcheck{
   {name="self", type="cairo.Context"},
   {name="surface", type="cairo.Surface"},
   {name="surface_x", type="number"},
   {name="surface_y", type="number"},
   call =
      function(self, surface, surface_x, surface_y)
         C.cairo_mask_surface(self.C, surface.C, surface_x, surface_y)
      end
}

Context.stroke = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_stroke(self.C)
      end
}

Context.strokePreserve = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_stroke_preserve(self.C)
      end
}

Context.fill = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_fill(self.C)
      end
}

Context.fillPreserve = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_fill_preserve(self.C)
      end
}

Context.copyPage = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_copy_page(self.C)
      end
}

Context.showPage = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_show_page(self.C)
      end
}

Context.inStroke = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   call =
      function(self, x, y)
         return (C.cairo_in_stroke(self.C, x, y) == 1)
      end
}

Context.inFill = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   call =
      function(self, x, y)
         return (C.cairo_in_fill(self.C, x, y) == 1)
      end
}

Context.inClip = argcheck{
   {name="self", type="cairo.Context"},
   {name="x", type="number"},
   {name="y", type="number"},
   call =
      function(self, x, y)
         return (C.cairo_in_clip(self.C, x, y) == 1)
      end
}

Context.strokeExtents = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x1 = ffi.new('double[1]')
         local y1 = ffi.new('double[1]')
         local x2 = ffi.new('double[1]')
         local y2 = ffi.new('double[1]')
         C.cairo_stroke_extents(self.C, x1, y1, x2, y2)
         return x1[0], y1[0], x2[0], y2[0]
      end
}

Context.fillExtents = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x1 = ffi.new('double[1]')
         local y1 = ffi.new('double[1]')
         local x2 = ffi.new('double[1]')
         local y2 = ffi.new('double[1]')
         C.cairo_fill_extents(self.C, x1, y1, x2, y2)
         return x1[0], y1[0], x2[0], y2[0]
      end
}

Context.resetClip = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_reset_clip(self.C)
      end
}

Context.clip = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_clip(self.C)
      end
}

Context.clipPreserve = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         C.cairo_clip_preserve(self.C)
      end
}

Context.clipExtents = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x1 = ffi.new('double[1]')
         local y1 = ffi.new('double[1]')
         local x2 = ffi.new('double[1]')
         local y2 = ffi.new('double[1]')
         C.cairo_clip_extents(self.C, x1, y1, x2, y2)
         return x1[0], y1[0], x2[0], y2[0]
      end
}

Context.copyClipRectangleList = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local list_p = C.cairo_copy_clip_rectangle_list(self.C)
         if list_p.status == ffi.CAIRO_STATUS_SUCCESS then
            local list = {}
            for i=1,list_p.num_rectangles do
               table.insert(list, {
                               x=list_p.rectangles[i-1].x, y=list_p.rectangles[i-1].y,
                               width=list_p.rectangles[i-1].width, height=list_p.rectangles[i-1].height,
                            })
            end
            return list
         end
      end
}

Context.selectFontFace = argcheck{
   {name="self", type="cairo.Context"},
   {name="family", type="string"},
   {name="slant", type="string"},
   {name="weight", type="string"},
   call =
      function(self, family, slant, weight)
         C.cairo_select_font_face(self.C, family, cairo.enums.FontSlant[slant], cairo.enums.FontWeight[weight])
      end
}

Context.setFontSize = argcheck{
   {name="self", type="cairo.Context"},
   {name="size", type="number"},
   call =
      function(self, size)
         C.cairo_set_font_size(self.C, size)
      end
}

Context.setFontMatrix = argcheck{
   {name="self", type="cairo.Context"},
   {name="matrix", type="cairo.Matrix"},
   call =
      function(self, matrix)
         C.cairo_set_font_matrix(self.C, matrix.C)
      end
}

Context.getFontMatrix = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local matrix = cairo.Matrix()
         C.cairo_get_font_matrix(self.C, matrix.C)
         return matrix
      end
}

Context.setFontOptions = argcheck{
   {name="self", type="cairo.Context"},
   {name="options", type="cairo.FontOptions"},
   call =
      function(self, options)
         C.cairo_set_font_options(self.C, options.C)
      end
}

Context.getFontOptions = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local options = cairo.FontOptions()
         cairo.FontOptions(C.cairo_get_font_options(self.C, options.C))
         return options
      end
}

Context.setFontFace = argcheck{
   {name="self", type="cairo.Context"},
   {name="font_face", type="cairo.FontFace"},
   call =
      function(self, font_face)
         C.cairo_set_font_face(self.C, font_face.C)
      end
}

Context.getFontFace = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.FontFace(C.cairo_get_font_face(self.C), true)
      end
}

Context.setScaledFont = argcheck{
   {name="self", type="cairo.Context"},
   {name="scaled_font", type="cairo.ScaledFont"},
   call =
      function(self, scaled_font)
         C.cairo_set_scaled_font(self.C, scaled_font.C)
      end
}

Context.getScaledFont = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.ScaledFont(C.cairo_get_scaled_font(self.C), true)
      end
}

Context.showText = argcheck{
   {name="self", type="cairo.Context"},
   {name="utf8", type="string"},
   call =
      function(self, utf8)
         C.cairo_show_text(self.C, utf8)
      end
}

Context.showGlyphs = argcheck{
   {name="self", type="cairo.Context"},
   {name="glyphs", type="table"},
   call =
      function(self, glyphs)
         local glyphs_p, num_glyphs = utils.glyphs_lua2C(glyphs)
         C.cairo_show_glyphs(self.C, glyphs_p, num_glyphs)
      end
}

Context.showTextGlyphs = argcheck{
   {name="self", type="cairo.Context"},
   {name="utf8", type="string"},    
   {name="glyphs", type="table"},
   {name="clusters", type="table"},
   {name="cluster_flags", type="string"},
   call =
      function(self, utf8, glyphs, clusters, cluster_flags)
         local utf8_len = #utf8
         local glyphs_p, num_glyphs = utils.glyphs_lua2C(glyphs)
         local clusters_p, num_clusters = utils.clusters_lua2C(clusters)
         C.cairo_show_text_glyphs(self.C, utf8, utf8_len, glyphs_p, num_glyphs, clusters_p, num_clusters, cairo.enums.TextClusterFlags[cluster_flags])
      end
}

Context.textPath = argcheck{
   {name="self", type="cairo.Context"},
   {name="utf8", type="string"},
   call =
      function(self, utf8)
         C.cairo_text_path(self.C, utf8)
      end
}

Context.glyphPath = argcheck{
   {name="self", type="cairo.Context"},
   {name="glyphs", type="table"},
   call =
      function(self, glyphs)
         local glyphs_p, num_glyphs = utils.glyphs_lua2C(glyphs)
         C.cairo_glyph_path(self.C, glyphs_p, num_glyphs)
      end
}

Context.textExtents = argcheck{
   {name="self", type="cairo.Context"},
   {name="utf8", type="string"},
   call =
      function(self, utf8)
         local extents = ffi.new('cairo_text_extents_t')
         C.cairo_text_extents(self.C, utf8, extents)
         return {
            x_bearing=extents.x_bearing, y_bearing=extents.y_bearing,
            width=extents.width, height=extents.height,
            x_advance=extents.x_advance, y_advance=extents.y_advance
         }
      end
}

Context.glyphExtents = argcheck{
   {name="self", type="cairo.Context"},
   {name="glyphs", type="table"},
   call =
      function(self, glyphs)
         local glyphs_p, num_glyphs = utils.glyphs_lua2C(glyphs)
         local extents = ffi.new('cairo_text_extents_t')
         C.cairo_glyph_extents(self.C, glyphs_p, num_glyphs, extents)
         return {
            x_bearing=extents.x_bearing, y_bearing=extents.y_bearing,
            width=extents.width, height=extents.height,
            x_advance=extents.x_advance, y_advance=extents.y_advance
         }
      end
}

Context.fontExtents = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local extents = ffi.new('cairo_font_extents_t')
         C.cairo_font_extents(self.C, extents)
         return {
            ascent=extents.ascent, descent=extents.descent,
            height=extents.height,
            max_x_advance=extents.max_x_advance, max_y_advance=extents.max_y_advance
         }
      end
}

Context.getOperator = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.Operator[ tonumber(C.cairo_get_operator(self.C)) ]
      end
}

Context.getSource = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Pattern(C.cairo_get_source(self.C), true)
      end
}

Context.getTolerance = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return C.cairo_get_tolerance(self.C)
      end
}

Context.getAntialias = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.Antialias[ tonumber(C.cairo_get_antialias(self.C)) ]
      end
}

Context.hasCurrentPoint = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return (C.cairo_has_current_point(self.C) == 1)
      end
}

Context.getCurrentPoint = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local x = ffi.new('double[1]')
         local y = ffi.new('double[1]')
         C.cairo_get_current_point(self.C, x, y)
         return x[0], y[0]
      end
}

Context.getFillRule = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.FillRule[ tonumber(C.cairo_get_fill_rule(self.C)) ]
      end
}

Context.getLineWidth = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return C.cairo_get_line_width(self.C)
      end
}

Context.getLineCap = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.LineCap[ tonumber(C.cairo_get_line_cap(self.C)) ]
      end
}

Context.getLineJoin = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.LineJoin[ tonumber(C.cairo_get_line_join(self.C)) ]
      end
}

Context.getMiterLimit = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return C.cairo_get_miter_limit(self.C)
      end
}

Context.getDashCount = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return C.cairo_get_dash_count(self.C)
      end
}

Context.getDash = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self, dashes, offset)
         local n_dash = self:getDashCount()
         local dashes_p = ffi.new('double[?]', n_dash)
         local offset_p = ffi.new('double[1]')
         C.cairo_get_dash(self.C, dashes_p, offset)
         local dashes = {}
         for i=0,n_dash-1 do
            table.insert(dashes, dashes_p[i])
         end
         return dashes, offset
      end
}

Context.getMatrix = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         local matrix = cairo.Matrix()
         C.cairo_get_matrix(self.C, matrix.C)
         return matrix
      end
}

Context.getTarget = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Surface(C.cairo_get_target(self.C), true)
      end
}

Context.getGroupTarget = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Surface(C.cairo_get_group_target(self.C), true)
      end
}

Context.copyPath = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Path(C.cairo_copy_path(self.C))
      end
}

Context.copyPathFlat = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.Path(C.cairo_copy_path_flat(self.C))
      end
}

Context.appendPath = argcheck{
   {name="self", type="cairo.Context"},
   {name="path", type="cairo.Path"},
   call =
      function(self, path)
         C.cairo_append_path(self.C, path.C)
      end
}

Context.status = argcheck{
   {name="self", type="cairo.Context"},
   call =
      function(self)
         return cairo.enums.Status[ tonumber(C.cairo_status(self.C)) ]
      end
}
