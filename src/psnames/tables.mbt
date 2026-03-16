///|
/// PostScript glyph name tables for the psnames module.
/// Ported from FreeType's pstables.h / psmodule.c.

///|
/// Standard SID names (0..390) for CFF fonts.
/// Index in this array = SID value.
let sid_names : FixedArray[String] = [
  // SID 0-9
  ".notdef", "space", "exclam", "quotedbl", "numbersign", "dollar", "percent", "ampersand",
  "quoteright", "parenleft",
  // SID 10-19
   "parenright", "asterisk", "plus", "comma", "hyphen", "period", "slash", "zero",
  "one", "two",
  // SID 20-29
   "three", "four", "five", "six", "seven", "eight", "nine", "colon", "semicolon",
  "less",
  // SID 30-39
   "equal", "greater", "question", "at", "A", "B", "C", "D", "E", "F",
  // SID 40-49
   "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  // SID 50-59
   "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
  // SID 60-69
   "bracketleft", "backslash", "bracketright", "asciicircum", "underscore", "quoteleft",
  "a", "b", "c", "d",
  // SID 70-79
   "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
  // SID 80-89
   "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
  // SID 90-99
   "y", "z", "braceleft", "bar", "braceright", "asciitilde", "exclamdown", "cent",
  "sterling", "fraction",
  // SID 100-109
   "yen", "florin", "section", "currency", "quotesingle", "quotedblleft", "guillemotleft",
  "guilsinglleft", "guilsinglright", "fi",
  // SID 110-119
   "fl", "endash", "dagger", "daggerdbl", "periodcentered", "paragraph", "bullet",
  "quotesinglbase", "quotedblbase", "quotedblright",
  // SID 120-129
   "guillemotright", "ellipsis", "perthousand", "questiondown", "grave", "acute",
  "circumflex", "tilde", "macron", "breve",
  // SID 130-139
   "dotaccent", "dieresis", "ring", "cedilla", "hungarumlaut", "ogonek", "caron",
  "emdash", "AE", "ordfeminine",
  // SID 140-149
   "Lslash", "Oslash", "OE", "ordmasculine", "ae", "dotlessi", "lslash", "oslash",
  "oe", "germandbls",
  // SID 150-159
   "onesuperior", "logicalnot", "mu", "trademark", "Eth", "onehalf", "plusminus",
  "Thorn", "onequarter", "divide",
  // SID 160-169
   "brokenbar", "degree", "thorn", "threequarters", "twosuperior", "registered",
  "minus", "eth", "multiply", "threesuperior",
  // SID 170-179
   "copyright", "Aacute", "Acircumflex", "Adieresis", "Agrave", "Aring", "Atilde",
  "Ccedilla", "Eacute", "Ecircumflex",
  // SID 180-189
   "Edieresis", "Egrave", "Iacute", "Icircumflex", "Idieresis", "Igrave", "Ntilde",
  "Oacute", "Oacircumflex", "Odieresis",
  // SID 190-199
   "Ograve", "Otilde", "Scaron", "Uacute", "Ucircumflex", "Udieresis", "Ugrave",
  "Yacute", "Ydieresis", "Zcaron",
  // SID 200-209
   "aacute", "acircumflex", "adieresis", "agrave", "aring", "atilde", "ccedilla",
  "eacute", "ecircumflex", "edieresis",
  // SID 210-219
   "egrave", "iacute", "icircumflex", "idieresis", "igrave", "ntilde", "oacute",
  "ocircumflex", "odieresis", "ograve",
  // SID 220-229
   "otilde", "scaron", "uacute", "ucircumflex", "udieresis", "ugrave", "yacute",
  "ydieresis", "zcaron", "exclamsmall",
  // SID 230-239
   "Hungarumlautsmall", "dollaroldstyle", "dollarsuperior", "ampersandsmall", "Acutesmall",
  "parenleftsuperior", "parenrightsuperior", "twodotenleader", "onedotenleader",
  "zerooldstyle",
  // SID 240-249
   "oneoldstyle", "twooldstyle", "threeoldstyle", "fouroldstyle", "fiveoldstyle",
  "sixoldstyle", "sevenoldstyle", "eightoldstyle", "nineoldstyle", "commasuperior",
  // SID 250-259
   "threequartersemdash", "periodsuperior", "questionsmall", "asuperior", "bsuperior",
  "centsuperior", "dsuperior", "esuperior", "isuperior", "lsuperior",
  // SID 260-269
   "msuperior", "nsuperior", "osuperior", "rsuperior", "ssuperior", "tsuperior",
  "ff", "ffi", "ffl", "parenleftinferior",
  // SID 270-279
   "parenrightinferior", "Circumflexsmall", "hyphensuperior", "Gravesmall", "Asmall",
  "Bsmall", "Csmall", "Dsmall", "Esmall", "Fsmall",
  // SID 280-289
   "Gsmall", "Hsmall", "Ismall", "Jsmall", "Ksmall", "Lsmall", "Msmall", "Nsmall",
  "Osmall", "Psmall",
  // SID 290-299
   "Qsmall", "Rsmall", "Ssmall", "Tsmall", "Usmall", "Vsmall", "Wsmall", "Xsmall",
  "Ysmall", "Zsmall",
  // SID 300-309
   "colonmonetary", "onefitted", "rupiah", "Tildesmall", "exclamdownsmall", "centoldstyle",
  "Lslashsmall", "Scaronsmall", "Zcaronsmall", "Dieresissmall",
  // SID 310-319
   "Brevesmall", "Caronsmall", "Dotaccentsmall", "Macronsmall", "figuredash", "hypheninferior",
  "Ogoneksmall", "Ringsmall", "Cedillasmall", "questiondownsmall",
  // SID 320-329
   "oneeighth", "threeeighths", "fiveeighths", "seveneighths", "onethird", "twothirds",
  "zerosuperior", "foursuperior", "fivesuperior", "sixsuperior",
  // SID 330-339
   "sevensuperior", "eightsuperior", "ninesuperior", "zeroinferior", "oneinferior",
  "twoinferior", "threeinferior", "fourinferior", "fiveinferior", "sixinferior",
  // SID 340-349
   "seveninferior", "eightinferior", "nineinferior", "centinferior", "dollarinferior",
  "periodinferior", "commainferior", "Agravesmall", "Aacutesmall", "Acircumflexsmall",
  // SID 350-359
   "Atildesmall", "Adieresissmall", "Aringsmall", "AEsmall", "Ccedillasmall", "Egravesmall",
  "Eacutesmall", "Ecircumflexsmall", "Edieresissmall", "Igravesmall",
  // SID 360-369
   "Iacutesmall", "Icircumflexsmall", "Idieresissmall", "Ethsmall", "Ntildesmall",
  "Ogravesmall", "Oacutesmall", "Ocircumflexsmall", "Otildesmall", "Odieresissmall",
  // SID 370-379
   "OEsmall", "Oslashsmall", "Ugravesmall", "Uacutesmall", "Ucircumflexsmall", "Udieresissmall",
  "Yacutesmall", "Thornsmall", "Ydieresissmall", "001.000",
  // SID 380-389
   "001.001", "001.002", "001.003", "Black", "Bold", "Book", "Light", "Medium", "Regular",
  "Roman",
  // SID 390
   "Semibold",
]

///|
/// Macintosh standard glyph names (indices 0..257).
let mac_names : FixedArray[String] = [
  // 0-9
  ".notdef", ".null", "nonmarkingreturn", "space", "exclam", "quotedbl", "numbersign",
  "dollar", "percent", "ampersand",
  // 10-19
   "quoteright", "parenleft", "parenright", "asterisk", "plus", "comma", "hyphen",
  "period", "slash", "zero",
  // 20-29
   "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "colon",
  // 30-39
   "semicolon", "less", "equal", "greater", "question", "at", "A", "B", "C", "D",
  // 40-49
   "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
  // 50-59
   "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
  // 60-69
   "Y", "Z", "bracketleft", "backslash", "bracketright", "asciicircum", "underscore",
  "quoteleft", "a", "b",
  // 70-79
   "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
  // 80-89
   "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
  // 90-99
   "w", "x", "y", "z", "braceleft", "bar", "braceright", "asciitilde", "Adieresis",
  "Aring",
  // 100-109
   "Ccedilla", "Eacute", "Ntilde", "Odieresis", "Udieresis", "aacute", "agrave",
  "acircumflex", "adieresis", "atilde",
  // 110-119
   "aring", "ccedilla", "eacute", "egrave", "ecircumflex", "edieresis", "iacute",
  "igrave", "icircumflex", "idieresis",
  // 120-129
   "ntilde", "oacute", "ograve", "ocircumflex", "odieresis", "otilde", "uacute",
  "ugrave", "ucircumflex", "udieresis",
  // 130-139
   "dagger", "degree", "cent", "sterling", "section", "bullet", "paragraph", "germandbls",
  "registered", "copyright",
  // 140-149
   "trademark", "acute", "dieresis", "notequal", "AE", "Oslash", "infinity", "plusminus",
  "lessequal", "greaterequal",
  // 150-159
   "yen", "mu", "partialdiff", "summation", "product", "pi", "integral", "ordfeminine",
  "ordmasculine", "Omega",
  // 160-169
   "ae", "oslash", "questiondown", "exclamdown", "logicalnot", "radical", "florin",
  "approxequal", "Delta", "guillemotleft",
  // 170-179
   "guillemotright", "ellipsis", "nonbreakingspace", "Agrave", "Atilde", "Otilde",
  "OE", "oe", "endash", "emdash",
  // 180-189
   "quotedblleft", "quotedblright", "quoteleft", "quoteright", "divide", "lozenge",
  "ydieresis", "Ydieresis", "fraction", "currency",
  // 190-199
   "guilsinglleft", "guilsinglright", "fi", "fl", "daggerdbl", "periodcentered",
  "quotesinglbase", "quotedblbase", "perthousand", "Acircumflex",
  // 200-209
   "Ecircumflex", "Aacute", "Edieresis", "Egrave", "Iacute", "Icircumflex", "Idieresis",
  "Igrave", "Oacute", "Ocircumflex",
  // 210-219
   "apple", "Ograve", "Uacute", "Ucircumflex", "Ugrave", "dotlessi", "circumflex",
  "tilde", "macron", "breve",
  // 220-229
   "dotaccent", "ring", "cedilla", "hungarumlaut", "ogonek", "caron", "Lslash", "lslash",
  "Scaron", "scaron",
  // 230-239
   "Zcaron", "zcaron", "brokenbar", "Eth", "eth", "Yacute", "yacute", "Thorn", "thorn",
  "minus",
  // 240-249
   "multiply", "onesuperior", "twosuperior", "threesuperior", "onehalf", "onequarter",
  "threequarters", "franc", "Gbreve", "gbreve",
  // 250-257
   "Idotaccent", "Scedilla", "scedilla", "Cacute", "cacute", "Ccaron", "ccaron",
  "dcroat",
]

///|
/// Standard encoding: maps character code (0-255) to SID.
/// 0 means .notdef (unmapped).
let standard_encoding : FixedArray[Int] = [
  // 0x00-0x0F
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x10-0x1F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x20-0x2F
   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
  // 0x30-0x3F
   17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  // 0x40-0x4F
   33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
  // 0x50-0x5F
   49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
  // 0x60-0x6F
   65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
  // 0x70-0x7F
   81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 0,
  // 0x80-0x8F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x90-0x9F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0xA0-0xAF
   0, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
  // 0xB0-0xBF
   0, 111, 112, 113, 114, 0, 115, 116, 117, 118, 119, 120, 121, 122, 0, 123,
  // 0xC0-0xCF
   0, 124, 125, 126, 127, 128, 129, 130, 131, 0, 132, 133, 0, 134, 135, 136,
  // 0xD0-0xDF
   137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0xE0-0xEF
   0, 138, 0, 139, 0, 0, 0, 0, 140, 141, 142, 143, 0, 0, 0, 0,
  // 0xF0-0xFF
   0, 144, 0, 0, 0, 145, 0, 0, 146, 147, 148, 149, 0, 0, 0, 0,
]

///|
/// Expert encoding: maps character code (0-255) to SID.
let expert_encoding : FixedArray[Int] = [
  // 0x00-0x0F
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x10-0x1F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x20-0x2F
   1, 229, 230, 0, 231, 232, 233, 234, 235, 236, 237, 238, 13, 14, 15, 99,
  // 0x30-0x3F
   239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 27, 28, 249, 250, 251, 252,
  // 0x40-0x4F
   0, 253, 254, 255, 256, 257, 0, 0, 0, 258, 0, 0, 259, 260, 261, 262,
  // 0x50-0x5F
   0, 0, 263, 264, 265, 0, 266, 109, 110, 267, 268, 269, 0, 270, 271, 272,
  // 0x60-0x6F
   273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288,
  // 0x70-0x7F
   289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 0,
  // 0x80-0x8F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0x90-0x9F
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  // 0xA0-0xAF
   0, 304, 305, 306, 0, 0, 307, 308, 309, 310, 311, 0, 312, 0, 0, 313,
  // 0xB0-0xBF
   0, 0, 314, 315, 0, 0, 316, 317, 318, 0, 0, 0, 158, 155, 163, 319,
  // 0xC0-0xCF
   320, 321, 322, 323, 324, 325, 0, 0, 326, 150, 164, 169, 327, 328, 329, 330,
  // 0xD0-0xDF
   331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346,
  // 0xE0-0xEF
   347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362,
  // 0xF0-0xFF
   363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378,
]

///|
/// Glyph name → Unicode value map for standard PostScript glyph names.
/// Covers the SID names and Mac names that have defined Unicode values.
fn build_glyph_unicode_map() -> Map[String, UInt] {
  let m : Map[String, UInt] = {}
  // Basic Latin
  m["space"] = 0x0020U
  m["exclam"] = 0x0021U
  m["quotedbl"] = 0x0022U
  m["numbersign"] = 0x0023U
  m["dollar"] = 0x0024U
  m["percent"] = 0x0025U
  m["ampersand"] = 0x0026U
  m["quoteright"] = 0x2019U
  m["parenleft"] = 0x0028U
  m["parenright"] = 0x0029U
  m["asterisk"] = 0x002AU
  m["plus"] = 0x002BU
  m["comma"] = 0x002CU
  m["hyphen"] = 0x002DU
  m["period"] = 0x002EU
  m["slash"] = 0x002FU
  m["zero"] = 0x0030U
  m["one"] = 0x0031U
  m["two"] = 0x0032U
  m["three"] = 0x0033U
  m["four"] = 0x0034U
  m["five"] = 0x0035U
  m["six"] = 0x0036U
  m["seven"] = 0x0037U
  m["eight"] = 0x0038U
  m["nine"] = 0x0039U
  m["colon"] = 0x003AU
  m["semicolon"] = 0x003BU
  m["less"] = 0x003CU
  m["equal"] = 0x003DU
  m["greater"] = 0x003EU
  m["question"] = 0x003FU
  m["at"] = 0x0040U
  m["A"] = 0x0041U
  m["B"] = 0x0042U
  m["C"] = 0x0043U
  m["D"] = 0x0044U
  m["E"] = 0x0045U
  m["F"] = 0x0046U
  m["G"] = 0x0047U
  m["H"] = 0x0048U
  m["I"] = 0x0049U
  m["J"] = 0x004AU
  m["K"] = 0x004BU
  m["L"] = 0x004CU
  m["M"] = 0x004DU
  m["N"] = 0x004EU
  m["O"] = 0x004FU
  m["P"] = 0x0050U
  m["Q"] = 0x0051U
  m["R"] = 0x0052U
  m["S"] = 0x0053U
  m["T"] = 0x0054U
  m["U"] = 0x0055U
  m["V"] = 0x0056U
  m["W"] = 0x0057U
  m["X"] = 0x0058U
  m["Y"] = 0x0059U
  m["Z"] = 0x005AU
  m["bracketleft"] = 0x005BU
  m["backslash"] = 0x005CU
  m["bracketright"] = 0x005DU
  m["asciicircum"] = 0x005EU
  m["underscore"] = 0x005FU
  m["quoteleft"] = 0x2018U
  m["a"] = 0x0061U
  m["b"] = 0x0062U
  m["c"] = 0x0063U
  m["d"] = 0x0064U
  m["e"] = 0x0065U
  m["f"] = 0x0066U
  m["g"] = 0x0067U
  m["h"] = 0x0068U
  m["i"] = 0x0069U
  m["j"] = 0x006AU
  m["k"] = 0x006BU
  m["l"] = 0x006CU
  m["m"] = 0x006DU
  m["n"] = 0x006EU
  m["o"] = 0x006FU
  m["p"] = 0x0070U
  m["q"] = 0x0071U
  m["r"] = 0x0072U
  m["s"] = 0x0073U
  m["t"] = 0x0074U
  m["u"] = 0x0075U
  m["v"] = 0x0076U
  m["w"] = 0x0077U
  m["x"] = 0x0078U
  m["y"] = 0x0079U
  m["z"] = 0x007AU
  m["braceleft"] = 0x007BU
  m["bar"] = 0x007CU
  m["braceright"] = 0x007DU
  m["asciitilde"] = 0x007EU
  // Latin-1 Supplement and Extended
  m["exclamdown"] = 0x00A1U
  m["cent"] = 0x00A2U
  m["sterling"] = 0x00A3U
  m["fraction"] = 0x2044U
  m["yen"] = 0x00A5U
  m["florin"] = 0x0192U
  m["section"] = 0x00A7U
  m["currency"] = 0x00A4U
  m["quotesingle"] = 0x0027U
  m["quotedblleft"] = 0x201CU
  m["guillemotleft"] = 0x00ABU
  m["guilsinglleft"] = 0x2039U
  m["guilsinglright"] = 0x203AU
  m["fi"] = 0xFB01U
  m["fl"] = 0xFB02U
  m["endash"] = 0x2013U
  m["dagger"] = 0x2020U
  m["daggerdbl"] = 0x2021U
  m["periodcentered"] = 0x00B7U
  m["paragraph"] = 0x00B6U
  m["bullet"] = 0x2022U
  m["quotesinglbase"] = 0x201AU
  m["quotedblbase"] = 0x201EU
  m["quotedblright"] = 0x201DU
  m["guillemotright"] = 0x00BBU
  m["ellipsis"] = 0x2026U
  m["perthousand"] = 0x2030U
  m["questiondown"] = 0x00BFU
  m["grave"] = 0x0060U
  m["acute"] = 0x00B4U
  m["circumflex"] = 0x02C6U
  m["tilde"] = 0x02DCU
  m["macron"] = 0x00AFU
  m["breve"] = 0x02D8U
  m["dotaccent"] = 0x02D9U
  m["dieresis"] = 0x00A8U
  m["ring"] = 0x02DAU
  m["cedilla"] = 0x00B8U
  m["hungarumlaut"] = 0x02DDU
  m["ogonek"] = 0x02DBU
  m["caron"] = 0x02C7U
  m["emdash"] = 0x2014U
  m["AE"] = 0x00C6U
  m["ordfeminine"] = 0x00AAU
  m["Lslash"] = 0x0141U
  m["Oslash"] = 0x00D8U
  m["OE"] = 0x0152U
  m["ordmasculine"] = 0x00BAU
  m["ae"] = 0x00E6U
  m["dotlessi"] = 0x0131U
  m["lslash"] = 0x0142U
  m["oslash"] = 0x00F8U
  m["oe"] = 0x0153U
  m["germandbls"] = 0x00DFU
  m["onesuperior"] = 0x00B9U
  m["logicalnot"] = 0x00ACU
  m["mu"] = 0x00B5U
  m["trademark"] = 0x2122U
  m["Eth"] = 0x00D0U
  m["onehalf"] = 0x00BDU
  m["plusminus"] = 0x00B1U
  m["Thorn"] = 0x00DEU
  m["onequarter"] = 0x00BCU
  m["divide"] = 0x00F7U
  m["brokenbar"] = 0x00A6U
  m["degree"] = 0x00B0U
  m["thorn"] = 0x00FEU
  m["threequarters"] = 0x00BEU
  m["twosuperior"] = 0x00B2U
  m["registered"] = 0x00AEU
  m["minus"] = 0x2212U
  m["eth"] = 0x00F0U
  m["multiply"] = 0x00D7U
  m["threesuperior"] = 0x00B3U
  m["copyright"] = 0x00A9U
  m["Aacute"] = 0x00C1U
  m["Acircumflex"] = 0x00C2U
  m["Adieresis"] = 0x00C4U
  m["Agrave"] = 0x00C0U
  m["Aring"] = 0x00C5U
  m["Atilde"] = 0x00C3U
  m["Ccedilla"] = 0x00C7U
  m["Eacute"] = 0x00C9U
  m["Ecircumflex"] = 0x00CAU
  m["Edieresis"] = 0x00CBU
  m["Egrave"] = 0x00C8U
  m["Iacute"] = 0x00CDU
  m["Icircumflex"] = 0x00CEU
  m["Idieresis"] = 0x00CFU
  m["Igrave"] = 0x00CCU
  m["Ntilde"] = 0x00D1U
  m["Oacute"] = 0x00D3U
  m["Oacircumflex"] = 0x00D4U
  m["Odieresis"] = 0x00D6U
  m["Ograve"] = 0x00D2U
  m["Otilde"] = 0x00D5U
  m["Scaron"] = 0x0160U
  m["Uacute"] = 0x00DAU
  m["Ucircumflex"] = 0x00DBU
  m["Udieresis"] = 0x00DCU
  m["Ugrave"] = 0x00D9U
  m["Yacute"] = 0x00DDU
  m["Ydieresis"] = 0x0178U
  m["Zcaron"] = 0x017DU
  m["aacute"] = 0x00E1U
  m["acircumflex"] = 0x00E2U
  m["adieresis"] = 0x00E4U
  m["agrave"] = 0x00E0U
  m["aring"] = 0x00E5U
  m["atilde"] = 0x00E3U
  m["ccedilla"] = 0x00E7U
  m["eacute"] = 0x00E9U
  m["ecircumflex"] = 0x00EAU
  m["edieresis"] = 0x00EBU
  m["egrave"] = 0x00E8U
  m["iacute"] = 0x00EDU
  m["icircumflex"] = 0x00EEU
  m["idieresis"] = 0x00EFU
  m["igrave"] = 0x00ECU
  m["ntilde"] = 0x00F1U
  m["oacute"] = 0x00F3U
  m["ocircumflex"] = 0x00F4U
  m["odieresis"] = 0x00F6U
  m["ograve"] = 0x00F2U
  m["otilde"] = 0x00F5U
  m["scaron"] = 0x0161U
  m["uacute"] = 0x00FAU
  m["ucircumflex"] = 0x00FBU
  m["udieresis"] = 0x00FCU
  m["ugrave"] = 0x00F9U
  m["yacute"] = 0x00FDU
  m["ydieresis"] = 0x00FFU
  m["zcaron"] = 0x017EU
  // Ligatures
  m["ff"] = 0xFB00U
  m["ffi"] = 0xFB03U
  m["ffl"] = 0xFB04U
  // Mac extras
  m["notequal"] = 0x2260U
  m["infinity"] = 0x221EU
  m["lessequal"] = 0x2264U
  m["greaterequal"] = 0x2265U
  m["partialdiff"] = 0x2202U
  m["summation"] = 0x2211U
  m["product"] = 0x220FU
  m["pi"] = 0x03C0U
  m["integral"] = 0x222BU
  m["Omega"] = 0x2126U
  m["radical"] = 0x221AU
  m["approxequal"] = 0x2248U
  m["Delta"] = 0x0394U
  m["nonbreakingspace"] = 0x00A0U
  m["lozenge"] = 0x25CAU
  m["apple"] = 0xF8FFU
  m["franc"] = 0x20A3U
  m["Gbreve"] = 0x011EU
  m["gbreve"] = 0x011FU
  m["Idotaccent"] = 0x0130U
  m["Scedilla"] = 0x015EU
  m["scedilla"] = 0x015FU
  m["Cacute"] = 0x0106U
  m["cacute"] = 0x0107U
  m["Ccaron"] = 0x010CU
  m["ccaron"] = 0x010DU
  m["dcroat"] = 0x0111U
  // Additional common names from SID table
  m["figuredash"] = 0x2012U
  m["oneeighth"] = 0x215BU
  m["threeeighths"] = 0x215CU
  m["fiveeighths"] = 0x215DU
  m["seveneighths"] = 0x215EU
  m["onethird"] = 0x2153U
  m["twothirds"] = 0x2154U
  m["colonmonetary"] = 0x20A1U
  m["rupiah"] = 0x0DBU // no standard Unicode, use 0
  m["threequartersemdash"] = 0x2014U // approximate
  // Superiors/inferiors mapped to their standard Unicode forms
  m["zerosuperior"] = 0x2070U
  m["foursuperior"] = 0x2074U
  m["fivesuperior"] = 0x2075U
  m["sixsuperior"] = 0x2076U
  m["sevensuperior"] = 0x2077U
  m["eightsuperior"] = 0x2078U
  m["ninesuperior"] = 0x2079U
  m["zeroinferior"] = 0x2080U
  m["oneinferior"] = 0x2081U
  m["twoinferior"] = 0x2082U
  m["threeinferior"] = 0x2083U
  m["fourinferior"] = 0x2084U
  m["fiveinferior"] = 0x2085U
  m["sixinferior"] = 0x2086U
  m["seveninferior"] = 0x2087U
  m["eightinferior"] = 0x2088U
  m["nineinferior"] = 0x2089U
  m
}

///|
/// Lazily initialized glyph name → Unicode map.
let glyph_unicode_map : Map[String, UInt] = build_glyph_unicode_map()

///|
/// Look up a glyph name in the Adobe Glyph List (standard subset).
/// Returns the Unicode value or 0 if not found.
pub fn adobe_glyph_index(name : String) -> UInt {
  match glyph_unicode_map.get(name) {
    Some(v) => v
    None => 0U
  }
}
