local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C

local Path = class.new('cairo.Path')
cairo.Path = class.constructor(Path)

Path.__init =
   argcheck(
   {{name="self", type="cairo.Path"},
    {name="cdata", type="cdata"}},
   function(self, cdata)
      self.C = cdata
      ffi.gc(self.C, C.cairo_path_destroy)
      return self
   end
)
