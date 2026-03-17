///|
/// Cache entry combining a key with a value and access time for LRU eviction.
pub(all) struct CacheEntry[V] {
  key : UInt64
  value : V
  mut access_time : Int
} derive(Show)

///|
/// Cached glyph data: outline, metrics, and advance width.
pub(all) struct CachedGlyph {
  outline : @types.Outline
  metrics : @types.GlyphMetrics
  advance_width : Int64
} derive(Show)

///|
/// LRU glyph cache mapping (face_id, glyph_index) -> CachedGlyph.
pub(all) struct GlyphCache {
  mut entries : Map[UInt64, CacheEntry[CachedGlyph]]
  max_entries : Int
  mut current_time : Int
} derive(Show)

///|
/// Character map cache mapping (face_id, charcode) -> glyph_index.
pub(all) struct CmapCache {
  mut entries : Map[UInt64, UInt]
  max_entries : Int
} derive(Show)

///|
/// Create a new glyph cache with the given maximum number of entries.
pub fn GlyphCache::new(max_entries? : Int = 1024) -> GlyphCache {
  { entries: {}, max_entries, current_time: 0 }
}

///|
/// Combine face_id and glyph_index into a single cache key.
fn make_glyph_key(face_id : UInt, glyph_index : UInt) -> UInt64 {
  (face_id.to_uint64() << 32) | glyph_index.to_uint64()
}

///|
/// Look up a cached glyph by face_id and glyph_index.
/// Returns None on cache miss.
pub fn GlyphCache::lookup(
  self : GlyphCache,
  face_id : UInt,
  glyph_index : UInt,
) -> CachedGlyph? {
  let key = make_glyph_key(face_id, glyph_index)
  match self.entries.get(key) {
    Some(entry) => {
      self.current_time += 1
      entry.access_time = self.current_time
      Some(entry.value)
    }
    None => None
  }
}

///|
/// Insert a glyph into the cache. If the cache is full, evict the
/// least-recently-used entry first.
pub fn GlyphCache::insert(
  self : GlyphCache,
  face_id : UInt,
  glyph_index : UInt,
  glyph : CachedGlyph,
) -> Unit {
  let key = make_glyph_key(face_id, glyph_index)
  // Evict LRU entry if at capacity
  if self.entries.length() >= self.max_entries &&
    not(self.entries.contains(key)) {
    let mut oldest_key : UInt64 = 0UL
    let mut oldest_time = @int.max_value
    self.entries.each(fn(k, entry) {
      if entry.access_time < oldest_time {
        oldest_time = entry.access_time
        oldest_key = k
      }
    })
    self.entries.remove(oldest_key)
  }
  self.current_time += 1
  self.entries[key] = { key, value: glyph, access_time: self.current_time }
}

///|
/// Create a new charmap cache with the given maximum number of entries.
pub fn CmapCache::new(max_entries? : Int = 4096) -> CmapCache {
  { entries: {}, max_entries }
}

///|
/// Look up a glyph index by face_id and charcode.
/// Returns None on cache miss.
pub fn CmapCache::lookup(
  self : CmapCache,
  face_id : UInt,
  charcode : UInt,
) -> UInt? {
  let key = make_glyph_key(face_id, charcode)
  self.entries.get(key)
}

///|
/// Insert a charcode-to-glyph mapping into the cache.
/// Evicts an arbitrary entry when full (simple eviction for cmap).
pub fn CmapCache::insert(
  self : CmapCache,
  face_id : UInt,
  charcode : UInt,
  glyph_index : UInt,
) -> Unit {
  let key = make_glyph_key(face_id, charcode)
  if self.entries.length() >= self.max_entries &&
    not(self.entries.contains(key)) {
    // Evict first entry found
    let mut evict_key : UInt64 = 0UL
    let mut found = false
    self.entries.each(fn(k, _v) {
      if not(found) {
        evict_key = k
        found = true
      }
    })
    if found {
      self.entries.remove(evict_key)
    }
  }
  self.entries[key] = glyph_index
}
