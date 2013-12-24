local function cairo_path(cairo)

  function cairo.copy_path(...)
     local path = cairo.C.cairo_copy_path(...)
     ffi.gc(path, cairo.C.cairo_path_destroy)
     return path
  end

  function cairo.copy_path_flat(...)
     local path = cairo.C.cairo_copy_path_flat(...)
     ffi.gc(path, cairo.C.cairo_path_destroy)
     return path
  end

end

return cairo_path
