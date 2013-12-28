local utils = {}

function utils.glyphs_lua2C(tbl)
   local num_glyphs = #tbl
   local glyphs = ffi.new('cairo_glyph_t[?]', num_glyphs)
   for i=1,num_glyphs do
      assert(tbl[i].index and tbl[i].x and tbl[i].y, 'invalid glyph')
      glyhs[i-1].index = tbl[i].index
      glyhs[i-1].x = tbl[i].x
      glyhs[i-1].y = tbl[i].y
   end
   return glyphs, num_glyphs
end

function utils.clusters_lua2C(tbl)
   local num_clusters = #tbl
   local clusters = ffi.new('cairo_cluster_t[?]', num_clusters)
   for i=1,num_clusters do
      assert(tbl[i].num_bytes and tbl[i].num_glyphs and 'invalid cluster')
      glyhs[i-1].num_bytes = tbl[i].num_bytes
      glyhs[i-1].num_glyphs = tbl[i].num_glyphs
   end
   return clusters, num_clusters
end

function utils.intrectangle_lua2C(tbl, rectangle)
   assert(tbl.x and tbl.y and tbl.width and tbl.height, 'invalid rectangle: x, y width or height field missing')
   if rectangle then
      rectangle.x = tbl.x
      rectangle.y = tbl.y
      rectangle.width = tbl.width
      rectangle.height = tbl.height
   else
      rectangle = ffi.new('cairo_rectangle_int_t', tbl)
   end
   return rectangle
end

function utils.intrectangle_C2lua(rectangle)
   return {x=rectangle.x, y=rectangle.y, width=rectangle.width, height=rectangle.height}
end

return utils
