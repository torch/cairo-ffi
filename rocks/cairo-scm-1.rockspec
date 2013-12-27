package = "cairo"
version = "scm-1"

source = {
   url = "git://github.com/torch/cairo-ffi.git"
}

description = {
   summary = "A FFI interface to Cairo Graphics",
   detailed = [[
   See http://cairographics.org for more details.
   ]],
   homepage = "https://github.com/torch/cairo-ffi",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
   "argcheck >= 1",
}

build = {
   type = "builtin",
   modules = {
      ["cairo.env"] = "env.lua",
      ["cairo.init"] = "init.lua",
      ["cairo.utils"] = "utils.lua",
      ["cairo.cdefs"] = "cdefs.lua",
      ["cairo.context"] = "context.lua"
   }
}
