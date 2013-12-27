local cairo = require 'cairo.env'
local ffi = require 'ffi'
local enums = {}

cairo.enums = enums

local function protect(tbl, name)
   setmetatable(tbl, {__index=function()
                                error(string.format('invalid key/value for enum %s', name))
                             end})
end

local function register(tbl, luaname, ffiname)
   local status, value = pcall(function()
                                  return ffi.C[ffiname]
                               end)

   if status then
      tbl[luaname] = value
      tbl[value] = luaname
   end
end



enums.Status = {}
protect(enums.Status, 'Status')
register(enums.Status, 'success', 'CAIRO_STATUS_SUCCESS')
register(enums.Status, 'no-memory', 'CAIRO_STATUS_NO_MEMORY')
register(enums.Status, 'invalid-restore', 'CAIRO_STATUS_INVALID_RESTORE')
register(enums.Status, 'invalid-pop-group', 'CAIRO_STATUS_INVALID_POP_GROUP')
register(enums.Status, 'no-current-point', 'CAIRO_STATUS_NO_CURRENT_POINT')
register(enums.Status, 'invalid-matrix', 'CAIRO_STATUS_INVALID_MATRIX')
register(enums.Status, 'invalid-status', 'CAIRO_STATUS_INVALID_STATUS')
register(enums.Status, 'null-pointer', 'CAIRO_STATUS_NULL_POINTER')
register(enums.Status, 'invalid-string', 'CAIRO_STATUS_INVALID_STRING')
register(enums.Status, 'invalid-path-data', 'CAIRO_STATUS_INVALID_PATH_DATA')
register(enums.Status, 'read-error', 'CAIRO_STATUS_READ_ERROR')
register(enums.Status, 'write-error', 'CAIRO_STATUS_WRITE_ERROR')
register(enums.Status, 'surface-finished', 'CAIRO_STATUS_SURFACE_FINISHED')
register(enums.Status, 'surface-type-mismatch', 'CAIRO_STATUS_SURFACE_TYPE_MISMATCH')
register(enums.Status, 'pattern-type-mismatch', 'CAIRO_STATUS_PATTERN_TYPE_MISMATCH')
register(enums.Status, 'invalid-content', 'CAIRO_STATUS_INVALID_CONTENT')
register(enums.Status, 'invalid-format', 'CAIRO_STATUS_INVALID_FORMAT')
register(enums.Status, 'invalid-visual', 'CAIRO_STATUS_INVALID_VISUAL')
register(enums.Status, 'file-not-found', 'CAIRO_STATUS_FILE_NOT_FOUND')
register(enums.Status, 'invalid-dash', 'CAIRO_STATUS_INVALID_DASH')
register(enums.Status, 'invalid-dsc-comment', 'CAIRO_STATUS_INVALID_DSC_COMMENT')
register(enums.Status, 'invalid-index', 'CAIRO_STATUS_INVALID_INDEX')
register(enums.Status, 'clip-not-representable', 'CAIRO_STATUS_CLIP_NOT_REPRESENTABLE')
register(enums.Status, 'temp-file-error', 'CAIRO_STATUS_TEMP_FILE_ERROR')
register(enums.Status, 'invalid-stride', 'CAIRO_STATUS_INVALID_STRIDE')
register(enums.Status, 'font-type-mismatch', 'CAIRO_STATUS_FONT_TYPE_MISMATCH')
register(enums.Status, 'user-font-immutable', 'CAIRO_STATUS_USER_FONT_IMMUTABLE')
register(enums.Status, 'user-font-error', 'CAIRO_STATUS_USER_FONT_ERROR')
register(enums.Status, 'negative-count', 'CAIRO_STATUS_NEGATIVE_COUNT')
register(enums.Status, 'invalid-clusters', 'CAIRO_STATUS_INVALID_CLUSTERS')
register(enums.Status, 'invalid-slant', 'CAIRO_STATUS_INVALID_SLANT')
register(enums.Status, 'invalid-weight', 'CAIRO_STATUS_INVALID_WEIGHT')
register(enums.Status, 'invalid-size', 'CAIRO_STATUS_INVALID_SIZE')
register(enums.Status, 'user-font-not-implemented', 'CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED')
register(enums.Status, 'device-type-mismatch', 'CAIRO_STATUS_DEVICE_TYPE_MISMATCH')
register(enums.Status, 'device-error', 'CAIRO_STATUS_DEVICE_ERROR')
register(enums.Status, 'invalid-mesh-construction', 'CAIRO_STATUS_INVALID_MESH_CONSTRUCTION')
register(enums.Status, 'device-finished', 'CAIRO_STATUS_DEVICE_FINISHED')
register(enums.Status, 'last-status', 'CAIRO_STATUS_LAST_STATUS')
enums.Content = {}
protect(enums.Content, 'Content')
register(enums.Content, 'color', 'CAIRO_CONTENT_COLOR')
register(enums.Content, 'alpha', 'CAIRO_CONTENT_ALPHA')
register(enums.Content, 'color-alpha', 'CAIRO_CONTENT_COLOR_ALPHA')
enums.Format = {}
protect(enums.Format, 'Format')
register(enums.Format, 'invalid', 'CAIRO_FORMAT_INVALID')
register(enums.Format, 'argb32', 'CAIRO_FORMAT_ARGB32')
register(enums.Format, 'rgb24', 'CAIRO_FORMAT_RGB24')
register(enums.Format, 'a8', 'CAIRO_FORMAT_A8')
register(enums.Format, 'a1', 'CAIRO_FORMAT_A1')
register(enums.Format, 'rgb16-565', 'CAIRO_FORMAT_RGB16_565')
register(enums.Format, 'rgb30', 'CAIRO_FORMAT_RGB30')
enums.Operator = {}
protect(enums.Operator, 'Operator')
register(enums.Operator, 'clear', 'CAIRO_OPERATOR_CLEAR')
register(enums.Operator, 'source', 'CAIRO_OPERATOR_SOURCE')
register(enums.Operator, 'over', 'CAIRO_OPERATOR_OVER')
register(enums.Operator, 'in', 'CAIRO_OPERATOR_IN')
register(enums.Operator, 'out', 'CAIRO_OPERATOR_OUT')
register(enums.Operator, 'atop', 'CAIRO_OPERATOR_ATOP')
register(enums.Operator, 'dest', 'CAIRO_OPERATOR_DEST')
register(enums.Operator, 'dest-over', 'CAIRO_OPERATOR_DEST_OVER')
register(enums.Operator, 'dest-in', 'CAIRO_OPERATOR_DEST_IN')
register(enums.Operator, 'dest-out', 'CAIRO_OPERATOR_DEST_OUT')
register(enums.Operator, 'dest-atop', 'CAIRO_OPERATOR_DEST_ATOP')
register(enums.Operator, 'xor', 'CAIRO_OPERATOR_XOR')
register(enums.Operator, 'add', 'CAIRO_OPERATOR_ADD')
register(enums.Operator, 'saturate', 'CAIRO_OPERATOR_SATURATE')
register(enums.Operator, 'multiply', 'CAIRO_OPERATOR_MULTIPLY')
register(enums.Operator, 'screen', 'CAIRO_OPERATOR_SCREEN')
register(enums.Operator, 'overlay', 'CAIRO_OPERATOR_OVERLAY')
register(enums.Operator, 'darken', 'CAIRO_OPERATOR_DARKEN')
register(enums.Operator, 'lighten', 'CAIRO_OPERATOR_LIGHTEN')
register(enums.Operator, 'color-dodge', 'CAIRO_OPERATOR_COLOR_DODGE')
register(enums.Operator, 'color-burn', 'CAIRO_OPERATOR_COLOR_BURN')
register(enums.Operator, 'hard-light', 'CAIRO_OPERATOR_HARD_LIGHT')
register(enums.Operator, 'soft-light', 'CAIRO_OPERATOR_SOFT_LIGHT')
register(enums.Operator, 'difference', 'CAIRO_OPERATOR_DIFFERENCE')
register(enums.Operator, 'exclusion', 'CAIRO_OPERATOR_EXCLUSION')
register(enums.Operator, 'hsl-hue', 'CAIRO_OPERATOR_HSL_HUE')
register(enums.Operator, 'hsl-saturation', 'CAIRO_OPERATOR_HSL_SATURATION')
register(enums.Operator, 'hsl-color', 'CAIRO_OPERATOR_HSL_COLOR')
register(enums.Operator, 'hsl-luminosity', 'CAIRO_OPERATOR_HSL_LUMINOSITY')
enums.Antialias = {}
protect(enums.Antialias, 'Antialias')
register(enums.Antialias, 'default', 'CAIRO_ANTIALIAS_DEFAULT')
register(enums.Antialias, 'none', 'CAIRO_ANTIALIAS_NONE')
register(enums.Antialias, 'gray', 'CAIRO_ANTIALIAS_GRAY')
register(enums.Antialias, 'subpixel', 'CAIRO_ANTIALIAS_SUBPIXEL')
register(enums.Antialias, 'fast', 'CAIRO_ANTIALIAS_FAST')
register(enums.Antialias, 'good', 'CAIRO_ANTIALIAS_GOOD')
register(enums.Antialias, 'best', 'CAIRO_ANTIALIAS_BEST')
enums.FillRule = {}
protect(enums.FillRule, 'FillRule')
register(enums.FillRule, 'winding', 'CAIRO_FILL_RULE_WINDING')
register(enums.FillRule, 'even-odd', 'CAIRO_FILL_RULE_EVEN_ODD')
enums.LineCap = {}
protect(enums.LineCap, 'LineCap')
register(enums.LineCap, 'butt', 'CAIRO_LINE_CAP_BUTT')
register(enums.LineCap, 'round', 'CAIRO_LINE_CAP_ROUND')
register(enums.LineCap, 'square', 'CAIRO_LINE_CAP_SQUARE')
enums.LineJoin = {}
protect(enums.LineJoin, 'LineJoin')
register(enums.LineJoin, 'miter', 'CAIRO_LINE_JOIN_MITER')
register(enums.LineJoin, 'round', 'CAIRO_LINE_JOIN_ROUND')
register(enums.LineJoin, 'bevel', 'CAIRO_LINE_JOIN_BEVEL')
enums.TextClusterFlags = {}
protect(enums.TextClusterFlags, 'TextClusterFlags')
enums.FontSlant = {}
protect(enums.FontSlant, 'FontSlant')
register(enums.FontSlant, 'normal', 'CAIRO_FONT_SLANT_NORMAL')
register(enums.FontSlant, 'italic', 'CAIRO_FONT_SLANT_ITALIC')
register(enums.FontSlant, 'oblique', 'CAIRO_FONT_SLANT_OBLIQUE')
enums.FontWeight = {}
protect(enums.FontWeight, 'FontWeight')
register(enums.FontWeight, 'normal', 'CAIRO_FONT_WEIGHT_NORMAL')
register(enums.FontWeight, 'bold', 'CAIRO_FONT_WEIGHT_BOLD')
enums.SubpixelOrder = {}
protect(enums.SubpixelOrder, 'SubpixelOrder')
register(enums.SubpixelOrder, 'default', 'CAIRO_SUBPIXEL_ORDER_DEFAULT')
register(enums.SubpixelOrder, 'rgb', 'CAIRO_SUBPIXEL_ORDER_RGB')
register(enums.SubpixelOrder, 'bgr', 'CAIRO_SUBPIXEL_ORDER_BGR')
register(enums.SubpixelOrder, 'vrgb', 'CAIRO_SUBPIXEL_ORDER_VRGB')
register(enums.SubpixelOrder, 'vbgr', 'CAIRO_SUBPIXEL_ORDER_VBGR')
enums.HintStyle = {}
protect(enums.HintStyle, 'HintStyle')
register(enums.HintStyle, 'default', 'CAIRO_HINT_STYLE_DEFAULT')
register(enums.HintStyle, 'none', 'CAIRO_HINT_STYLE_NONE')
register(enums.HintStyle, 'slight', 'CAIRO_HINT_STYLE_SLIGHT')
register(enums.HintStyle, 'medium', 'CAIRO_HINT_STYLE_MEDIUM')
register(enums.HintStyle, 'full', 'CAIRO_HINT_STYLE_FULL')
enums.HintMetrics = {}
protect(enums.HintMetrics, 'HintMetrics')
register(enums.HintMetrics, 'default', 'CAIRO_HINT_METRICS_DEFAULT')
register(enums.HintMetrics, 'off', 'CAIRO_HINT_METRICS_OFF')
register(enums.HintMetrics, 'on', 'CAIRO_HINT_METRICS_ON')
enums.FontType = {}
protect(enums.FontType, 'FontType')
register(enums.FontType, 'toy', 'CAIRO_FONT_TYPE_TOY')
register(enums.FontType, 'ft', 'CAIRO_FONT_TYPE_FT')
register(enums.FontType, 'win32', 'CAIRO_FONT_TYPE_WIN32')
register(enums.FontType, 'quartz', 'CAIRO_FONT_TYPE_QUARTZ')
register(enums.FontType, 'user', 'CAIRO_FONT_TYPE_USER')
enums.PathDataType = {}
protect(enums.PathDataType, 'PathDataType')
enums.DeviceType = {}
protect(enums.DeviceType, 'DeviceType')
register(enums.DeviceType, 'drm', 'CAIRO_DEVICE_TYPE_DRM')
register(enums.DeviceType, 'gl', 'CAIRO_DEVICE_TYPE_GL')
register(enums.DeviceType, 'script', 'CAIRO_DEVICE_TYPE_SCRIPT')
register(enums.DeviceType, 'xcb', 'CAIRO_DEVICE_TYPE_XCB')
register(enums.DeviceType, 'xlib', 'CAIRO_DEVICE_TYPE_XLIB')
register(enums.DeviceType, 'xml', 'CAIRO_DEVICE_TYPE_XML')
register(enums.DeviceType, 'cogl', 'CAIRO_DEVICE_TYPE_COGL')
register(enums.DeviceType, 'win32', 'CAIRO_DEVICE_TYPE_WIN32')
register(enums.DeviceType, 'invalid', 'CAIRO_DEVICE_TYPE_INVALID')
enums.SurfaceType = {}
protect(enums.SurfaceType, 'SurfaceType')
register(enums.SurfaceType, 'image', 'CAIRO_SURFACE_TYPE_IMAGE')
register(enums.SurfaceType, 'pdf', 'CAIRO_SURFACE_TYPE_PDF')
register(enums.SurfaceType, 'ps', 'CAIRO_SURFACE_TYPE_PS')
register(enums.SurfaceType, 'xlib', 'CAIRO_SURFACE_TYPE_XLIB')
register(enums.SurfaceType, 'xcb', 'CAIRO_SURFACE_TYPE_XCB')
register(enums.SurfaceType, 'glitz', 'CAIRO_SURFACE_TYPE_GLITZ')
register(enums.SurfaceType, 'quartz', 'CAIRO_SURFACE_TYPE_QUARTZ')
register(enums.SurfaceType, 'win32', 'CAIRO_SURFACE_TYPE_WIN32')
register(enums.SurfaceType, 'beos', 'CAIRO_SURFACE_TYPE_BEOS')
register(enums.SurfaceType, 'directfb', 'CAIRO_SURFACE_TYPE_DIRECTFB')
register(enums.SurfaceType, 'svg', 'CAIRO_SURFACE_TYPE_SVG')
register(enums.SurfaceType, 'os2', 'CAIRO_SURFACE_TYPE_OS2')
register(enums.SurfaceType, 'win32-printing', 'CAIRO_SURFACE_TYPE_WIN32_PRINTING')
register(enums.SurfaceType, 'quartz-image', 'CAIRO_SURFACE_TYPE_QUARTZ_IMAGE')
register(enums.SurfaceType, 'script', 'CAIRO_SURFACE_TYPE_SCRIPT')
register(enums.SurfaceType, 'qt', 'CAIRO_SURFACE_TYPE_QT')
register(enums.SurfaceType, 'recording', 'CAIRO_SURFACE_TYPE_RECORDING')
register(enums.SurfaceType, 'vg', 'CAIRO_SURFACE_TYPE_VG')
register(enums.SurfaceType, 'gl', 'CAIRO_SURFACE_TYPE_GL')
register(enums.SurfaceType, 'drm', 'CAIRO_SURFACE_TYPE_DRM')
register(enums.SurfaceType, 'tee', 'CAIRO_SURFACE_TYPE_TEE')
register(enums.SurfaceType, 'xml', 'CAIRO_SURFACE_TYPE_XML')
register(enums.SurfaceType, 'skia', 'CAIRO_SURFACE_TYPE_SKIA')
register(enums.SurfaceType, 'subsurface', 'CAIRO_SURFACE_TYPE_SUBSURFACE')
register(enums.SurfaceType, 'cogl', 'CAIRO_SURFACE_TYPE_COGL')
enums.PatternType = {}
protect(enums.PatternType, 'PatternType')
register(enums.PatternType, 'solid', 'CAIRO_PATTERN_TYPE_SOLID')
register(enums.PatternType, 'surface', 'CAIRO_PATTERN_TYPE_SURFACE')
register(enums.PatternType, 'linear', 'CAIRO_PATTERN_TYPE_LINEAR')
register(enums.PatternType, 'radial', 'CAIRO_PATTERN_TYPE_RADIAL')
register(enums.PatternType, 'mesh', 'CAIRO_PATTERN_TYPE_MESH')
register(enums.PatternType, 'raster-source', 'CAIRO_PATTERN_TYPE_RASTER_SOURCE')
enums.Extend = {}
protect(enums.Extend, 'Extend')
register(enums.Extend, 'none', 'CAIRO_EXTEND_NONE')
register(enums.Extend, 'repeat', 'CAIRO_EXTEND_REPEAT')
register(enums.Extend, 'reflect', 'CAIRO_EXTEND_REFLECT')
register(enums.Extend, 'pad', 'CAIRO_EXTEND_PAD')
enums.Filter = {}
protect(enums.Filter, 'Filter')
register(enums.Filter, 'fast', 'CAIRO_FILTER_FAST')
register(enums.Filter, 'good', 'CAIRO_FILTER_GOOD')
register(enums.Filter, 'best', 'CAIRO_FILTER_BEST')
register(enums.Filter, 'nearest', 'CAIRO_FILTER_NEAREST')
register(enums.Filter, 'bilinear', 'CAIRO_FILTER_BILINEAR')
register(enums.Filter, 'gaussian', 'CAIRO_FILTER_GAUSSIAN')
enums.RegionOverlap = {}
protect(enums.RegionOverlap, 'RegionOverlap')
register(enums.RegionOverlap, 'in', 'CAIRO_REGION_OVERLAP_IN')
register(enums.RegionOverlap, 'out', 'CAIRO_REGION_OVERLAP_OUT')
register(enums.RegionOverlap, 'part', 'CAIRO_REGION_OVERLAP_PART')
