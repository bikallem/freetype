///|
test "GlyphCache insert and lookup" {
  let cache = @cache.GlyphCache::new(max_entries=10)
  let glyph : @cache.CachedGlyph = {
    outline: @types.Outline::new(),
    metrics: @types.GlyphMetrics::new(),
    advance_width: 600L,
  }
  cache.insert(1U, 42U, glyph)
  let result = cache.lookup(1U, 42U)
  inspect(result is Some(_), content="true")
  inspect(result.unwrap().advance_width, content="600")
}

///|
test "GlyphCache miss returns None" {
  let cache = @cache.GlyphCache::new(max_entries=10)
  let result = cache.lookup(1U, 99U)
  inspect(result is None, content="true")
}

///|
test "GlyphCache LRU eviction" {
  let cache = @cache.GlyphCache::new(max_entries=2)
  let glyph_a : @cache.CachedGlyph = {
    outline: @types.Outline::new(),
    metrics: @types.GlyphMetrics::new(),
    advance_width: 100L,
  }
  let glyph_b : @cache.CachedGlyph = {
    outline: @types.Outline::new(),
    metrics: @types.GlyphMetrics::new(),
    advance_width: 200L,
  }
  let glyph_c : @cache.CachedGlyph = {
    outline: @types.Outline::new(),
    metrics: @types.GlyphMetrics::new(),
    advance_width: 300L,
  }
  cache.insert(1U, 1U, glyph_a)
  cache.insert(1U, 2U, glyph_b)
  // Access glyph_a to make it more recently used
  let _ = cache.lookup(1U, 1U)
  // Insert glyph_c — should evict glyph_b (least recently used)
  cache.insert(1U, 3U, glyph_c)
  inspect(cache.lookup(1U, 1U) is Some(_), content="true")
  inspect(cache.lookup(1U, 2U) is None, content="true")
  inspect(cache.lookup(1U, 3U) is Some(_), content="true")
}

///|
test "CmapCache insert and lookup" {
  let cache = @cache.CmapCache::new(max_entries=100)
  cache.insert(1U, 65U, 10U)
  let result = cache.lookup(1U, 65U)
  inspect(result, content="Some(10)")
}

///|
test "CmapCache miss returns None" {
  let cache = @cache.CmapCache::new(max_entries=100)
  let result = cache.lookup(1U, 65U)
  inspect(result, content="None")
}

///|
test "CmapCache eviction when full" {
  let cache = @cache.CmapCache::new(max_entries=2)
  cache.insert(1U, 65U, 10U)
  cache.insert(1U, 66U, 11U)
  cache.insert(1U, 67U, 12U)
  // One of the first two should have been evicted
  let count = (if cache.lookup(1U, 65U) is Some(_) { 1 } else { 0 }) +
    (if cache.lookup(1U, 66U) is Some(_) { 1 } else { 0 }) +
    (if cache.lookup(1U, 67U) is Some(_) { 1 } else { 0 })
  inspect(count, content="2")
}
