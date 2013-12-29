local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local SVGImageSurface = class.new('cairo.SVGImageSurface', 'cairo.ImageSurface')
cairo.SVGImageSurface = class.constructor(SVGImageSurface)

SVGImageSurface.__init =
   argcheck(
   {{name="self", type="cairo.SVGImageSurface"},
    {name="filename", type="string"},
    {name="width_in_points", type="number"},
    {name="height_in_points", type="number"}},
   function(self, filename, width_in_points, height_in_points)
      self.C = C.cairo_svg_surface_create(filename, width_in_points, height_in_points)
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end
)

SVGImageSurface.restrictToVersion =
   argcheck(
   {{name="self", type="cairo.SVGImageSurface"},
    {name="version", type="string"}},
   function(self, version)
      C.cairo_svg_surface_restrict_to_version(self.C, cairo.enums.SVGVersion[version])
   end
)

SVGImageSurface.getVersions =
   argcheck(
   {{name="self", type="cairo.SVGImageSurface"}},
   function(self, version)
      local versions_p = ffi.new('cairo_svg_version_t*[1]')
      local num_versions_p = ffi.new('int[1]')
      local versions = {}
      C.cairo_svg_get_versions(versions_p, num_versions_p)
      for i=1,num_versions_p[0] do
         table.insert(versions, ffi.string(versions_p[i-1]))
      end
      return versions
   end
)
