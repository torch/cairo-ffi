local argcheck = require 'argcheck'
local class = require 'class'
local ffi = require 'ffi'
local cairo = require 'cairo.env'
local C = cairo.C
local doc = require 'argcheck.doc'

local ImageSurface = class.new('cairo.ImageSurface', 'cairo.Surface')
cairo.ImageSurface = ImageSurface

ImageSurface.__init = argcheck{
   doc = [[
<a name="ImageSurface.new">
#### ImageSurface.new()

##### ImageSurface.new(@ARGP)

@ARGT

Creates an image surface of the specified format and
dimensions. Initially the surface contents are all
0. (Specifically, within each pixel, each color or alpha channel
belonging to format will be 0. The contents of bits within a pixel,
but not belonging to the given format are undefined).

_Return value_: a pointer to the newly created surface. The caller
owns the surface and should call [`Surface.destroy()`](surface.md#Surface.destroy) when done
with it.

This function always returns a valid pointer, but it will return a
pointer to a "nil" surface if an error such as out of memory
occurs. You can use [`Surface.status()`](surface.md#Surface.status) to check for this.

]],
   {name="self", type="cairo.ImageSurface"},
   {name="format", type="string", doc="format of pixels in the surface to create"},
   {name="width", type="number", doc="width of the surface, in pixels"},
   {name="height", type="number", doc="height of the surface, in pixels"},
   call =
      function(self, format, width, height)
         self.C = C.cairo_image_surface_create(cairo.enums.Format[format], width, height)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}

ImageSurface.__init = argcheck{
   doc = [[

##### ImageSurface.new(@ARGP)

@ARGT

Create a new image surface that is as compatible as possible for uploading
to and the use in conjunction with an existing surface. However, this surface
can still be used like any normal image surface.

Initially the surface contents are all 0 (transparent if contents
have transparency, black otherwise.)

Use it if you don't need an image surface.

_Return value_: a pointer to the newly allocated image surface. The caller
owns the surface and should call [`Surface.destroy()`](surface.md#Surface.destroy) when done
with it.

This function always returns a valid pointer, but it will return a
pointer to a "nil" surface if `other` is already in an error state
or any other error occurs.

]],
   {name="self", type="cairo.ImageSurface"},
   {name="other", type="cairo.Surface", doc="an existing surface used to select the preference of the new surface"},
   {name="format", type="string", doc="the format for the new surface"},
   {name="width", type="number", doc="width  --  width of the new surface, (in device-space units)"},
   {name="height", type="number", doc="height of the new surface (in device-space units)"},
   overload = ImageSurface.__init,
   call =
      function(self, other, format, width, height)
         self.C = C.cairo_surface_create_similar_image(other.C, cairo.enums.Format[format], width, height)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}

ImageSurface.__init = argcheck{
   doc = [[

##### ImageSurface.new(@ARGP)

@ARGT

Returns an image surface that is the most efficient mechanism for
modifying the backing store of the target surface. The region retrieved
may be limited to the `extents` or `nil` for the whole surface

Note, the use of the original surface as a target or source whilst
it is mapped is undefined. The result of mapping the surface
multiple times is undefined. Calling [`Surface.destroy()`](surface.md#Surface.destroy) or
[`Surface.finish()`](surface.md#Surface.finish) on the resulting image surface results in
undefined behavior. Changing the device transform of the image
surface or of `surface` before the image surface is unmapped results
in undefined behavior.

_Return value_: a pointer to the newly allocated image surface.

This function always returns a valid pointer, but it will return a
pointer to a "nil" surface if `other` is already in an error state
or any other error occurs. If the returned pointer does not have an
error status, it is guaranteed to be an image surface whose format
is not [`"invalid"`](enums.md#Format).

]],
   {name="self", type="cairo.ImageSurface"},
   {name="other", type="cairo.Surface", doc="an existing surface used to extract the image from"},
   {name="extents", type="table", doc="limit the extraction to an rectangular region"},
   overload = ImageSurface.__init,
   call =
      function(self, other, extents)
         local extents_p = ffi.new('cairo_rectangle_int_t', extents)
         self.C = C.cairo_surface_map_to_image(other.C, extents_p)
         ffi.gc(self.C, C.cairo_surface_unmap_image)
         return self
      end
}

ImageSurface.__init = argcheck{
   doc = [[

##### ImageSurface.new(@ARGP)

@ARGT

Creates an image surface for the provided pixel data. The output
buffer must be kept around until the [`Surface`](surface.md#Surface) is destroyed
or [`Surface.finish()`](surface.md#Surface.finish) is called on the surface.  The initial
contents of `data` will be used as the initial image contents; you
must explicitly clear the buffer, using, for example,
[`Context.rectangle()`](context.md#Context.rectangle) and [`Context.fill()`](context.md#Context.fill) if you want it cleared.

Note that the stride may be larger than
width*bytes_per_pixel to provide proper alignment for each pixel
and row. This alignment is required to allow high-performance rendering
within cairo. The correct way to obtain a legal stride value is to
call [`Context.formatStrideForWidth()`](context.md#Context.formatStrideForWidth) with the desired format and
maximum image width value, and then use the resulting stride value
to allocate the data and to create the image surface. See
[`Context.formatStrideForWidth()`](context.md#Context.formatStrideForWidth) for example code.

_Return value_: a pointer to the newly created surface.

This function always returns a valid pointer, but it will return a
pointer to a "nil" surface in the case of an error such as out of
memory or an invalid stride value. In case of invalid stride value
the error status of the returned surface will be
[`"invalid-stride"`](enums.md#Status).  You can use
[`Surface.status()`](surface.md#Surface.status) to check for this.

See [`Surface.setUserData()`](surface.md#Surface.setUserData) for a means of attaching a
destroy-notification fallback to the surface if necessary.

]],
   {name="self", type="cairo.ImageSurface"},
   {name="data", type="cdata", doc="a pointer to a buffer supplied by the application in which to write contents. This pointer must be suitably aligned for any kind of variable, (for example, a pointer returned by malloc)"},
   {name="format", type="string", doc="the format of pixels in the buffer"},
   {name="width", type="number", doc="the width of the image to be stored in the buffer"},
   {name="height", type="number", doc="the height of the image to be stored in the buffer"},
   {name="stride", type="number", doc="the number of bytes between the start of rows in the buffer as allocated. This value should always be computed by [`Context.formatStrideForWidth()`](context.md#Context.formatStrideForWidth) before allocating the data buffer"},
   overload = ImageSurface.__init,
   call =
      function(self, data, format, width, height, stride)
         self.C = C.cairo_image_surface_create_for_data(data, cairo.enums.Format[format], width, height, stride)
         ffi.gc(self.C, C.cairo_surface_destroy)
         return self
      end
}


ImageSurface.getData = argcheck{
   doc = [[
<a name="ImageSurface.getData">
#### ImageSurface.getData(@ARGP)

@ARGT

Get a pointer to the data of the image surface, for direct
inspection or modification.

A call to [`Surface.flush()`](surface.md#Surface.flush) is required before accessing the
pixel data to ensure that all pending drawing operations are
finished. A call to [`Surface.markDirty()`](surface.md#Surface.markDirty) is required after
the data is modified.

_Return value_: a pointer to the image data of this surface or `nil`
if `surface` is not an image surface, or if [`Surface.finish()`](surface.md#Surface.finish)
has been called.

]],
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_data(self.C)
      end
}

ImageSurface.getFormat = argcheck{
   doc = [[
<a name="ImageSurface.getFormat">
#### ImageSurface.getFormat(@ARGP)

@ARGT

Get the format of the surface.

_Return value_: the format of the surface

]],
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return cairo.enums.Format[ tonumber(C.cairo_image_surface_get_format(self.C)) ]
      end
}

ImageSurface.getWidth = argcheck{
   doc = [[
<a name="ImageSurface.getWidth">
#### ImageSurface.getWidth(@ARGP)

@ARGT

Get the width of the image surface in pixels.

_Return value_: the width of the surface in pixels.

]],
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_width(self.C)
      end
}

ImageSurface.getHeight = argcheck{
   doc = [[
<a name="ImageSurface.getHeight">
#### ImageSurface.getHeight(@ARGP)

@ARGT

Get the height of the image surface in pixels.

_Return value_: the height of the surface in pixels.

]],
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_height(self.C)
      end
}

ImageSurface.getStride = argcheck{
   doc = [[
<a name="ImageSurface.getStride">
#### ImageSurface.getStride(@ARGP)

@ARGT

Get the stride of the image surface in bytes

_Return value_: the stride of the image surface in bytes (or 0 if
`surface` is not an image surface). The stride is the distance in
bytes from the beginning of one row of the image data to the
beginning of the next row.

]],
   {name="self", type="cairo.Surface"},
   call =
      function(self)
         return C.cairo_image_surface_get_stride(self.C)
      end
}
