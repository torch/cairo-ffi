print[[
-- Do not change this file manually
-- Generated with dev/create-shorthand.lua

local function cairo_create_shorthand(cairo)

   local function register(luafuncname, funcname)
      local symexists, msg = pcall(function()
                                      local sym = cairo.C[funcname]
                                   end)
      if symexists then
         cairo[luafuncname] = cairo.C[funcname]
         return true
      end
      
      print('failed:', funcname, msg)
      return false
   end
]]

local defined = {}

local txt = io.open('cdefs.lua'):read('*all')
for funcname in txt:gmatch('cairo_([^%=,%.%;<%s%(%)]+)%s*%(') do
   if funcname and not defined[funcname] and not funcname:match('_t$') then
      print(string.format("  register('%s', 'cairo_%s')", funcname, funcname))
      defined[funcname] = true
   end
end

print()

for defname in txt:gmatch('CAIRO_([^%=,%.%;<%s%(%)|%[%]]+)') do
   if not defined[defname] and defname == string.upper(defname) then
      print(string.format("  register('%s', 'CAIRO_%s')", defname, defname))
   end
end

print[[

end

return cairo_create_shorthand

]]
