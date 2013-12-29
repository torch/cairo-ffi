local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local PDFImageSurface = class.new('cairo.PDFImageSurface', 'cairo.ImageSurface')
cairo.PDFImageSurface = class.constructor(PDFImageSurface)

PDFImageSurface.__init =
   argcheck(
   {{name="self", type="cairo.PDFImageSurface"},
    {name="filename", type="string"},
    {name="width_in_points", type="number"},
    {name="height_in_points", type="number"}},
   function(self, filename, width_in_points, height_in_points)
      self.C = C.cairo_pdf_surface_create(filename, width_in_points, height_in_points)
      ffi.gc(self.C, C.cairo_surface_destroy)
      return self
   end
)

PDFImageSurface.restrictToVersion =
   argcheck(
   {{name="self", type="cairo.PDFImageSurface"},
    {name="version", type="string"}},
   function(self, version)
      C.cairo_pdf_surface_restrict_to_version(self.C, cairo.enums.PDFVersion[version])
   end
)

PDFImageSurface.getVersions =
   argcheck(
   {{name="self", type="cairo.PDFImageSurface"}},
   function(self, version)
      local versions_p = ffi.new('cairo_pdf_version_t*[1]')
      local num_versions_p = ffi.new('int[1]')
      local versions = {}
      C.cairo_pdf_get_versions(versions_p, num_versions_p)
      for i=1,num_versions_p[0] do
         table.insert(versions, ffi.string(versions_p[i-1]))
      end
      return versions
   end
)
