///|
fn load_uvs_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/uvs.ttf")
}

///|
test "UVS: charmaps include base Unicode and format 14 selector table" {
  let f = @freetype.from_bytes(load_uvs_ttf())
  inspect(f.charmaps().length(), content="2")
  inspect(f.charmaps()[0].platform_id(), content="3")
  inspect(f.charmaps()[0].encoding_id(), content="1")
  inspect(f.charmaps()[1].platform_id(), content="0")
  inspect(f.charmaps()[1].encoding_id(), content="5")
}

///|
test "UVS: char variant APIs match expected format 14 behavior" {
  let f = @freetype.from_bytes(load_uvs_ttf())
  let selectors = @freetype.get_variant_selectors(f)
  inspect(selectors.length(), content="1")
  inspect(selectors[0], content="65039")

  let space_variants = @freetype.get_variants_of_char(f, 32U)
  inspect(space_variants.length(), content="1")
  inspect(space_variants[0], content="65039")

  let a_variants = @freetype.get_variants_of_char(f, 65U)
  inspect(a_variants.length(), content="1")
  inspect(a_variants[0], content="65039")

  let chars = @freetype.get_chars_of_variant(f, 0xFE0FU)
  inspect(chars.length(), content="2")
  inspect(chars[0], content="32")
  inspect(chars[1], content="65")

  inspect(@freetype.get_char_variant_is_default(f, 32U, 0xFE0FU), content="1")
  inspect(@freetype.get_char_variant_index(f, 32U, 0xFE0FU), content="1")
  inspect(@freetype.get_char_variant_is_default(f, 65U, 0xFE0FU), content="0")
  inspect(@freetype.get_char_variant_index(f, 65U, 0xFE0FU), content="3")
  inspect(@freetype.get_char_variant_is_default(f, 66U, 0xFE0FU), content="-1")
  inspect(@freetype.get_char_variant_index(f, 66U, 0xFE0FU), content="0")
}

///|
test "UVS: default-variant glyph lookup depends on the active Unicode charmap" {
  let f = @freetype.from_bytes(load_uvs_ttf())
  inspect(@freetype.get_char_variant_index(f, 32U, 0xFE0FU), content="1")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 32U), content="0")
  inspect(@freetype.get_char_variant_is_default(f, 32U, 0xFE0FU), content="1")
  inspect(@freetype.get_char_variant_index(f, 32U, 0xFE0FU), content="0")
}
