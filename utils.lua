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

function utils.clusters_C2lua(tbl)
   local num_clusters = #tbl
   local clusters = ffi.new('cairo_cluster_t[?]', num_clusters)
   for i=1,num_clusters do
      assert(tbl[i].num_bytes and tbl[i].num_glyphs and 'invalid cluster')
      glyhs[i-1].num_bytes = tbl[i].num_bytes
      glyhs[i-1].num_glyphs = tbl[i].num_glyphs
   end
   return clusters, num_clusters
end

return utils
