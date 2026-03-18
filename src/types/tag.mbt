///|
/// Construct a 4-byte tag from four characters (big-endian).
pub fn make_tag(c1 : Byte, c2 : Byte, c3 : Byte, c4 : Byte) -> UInt {
  (c1.to_uint() << 24) |
  (c2.to_uint() << 16) |
  (c3.to_uint() << 8) |
  c4.to_uint()
}

// SFNT table tags from tttags.h

///|
pub const TAG_AVAR : UInt = 0x61766172U // 'avar'

///|
pub const TAG_BASE : UInt = 0x42415345U // 'BASE'

///|
pub const TAG_BDAT : UInt = 0x62646174U // 'bdat'

///|
pub const TAG_BDF : UInt = 0x42444620U // 'BDF '

///|
pub const TAG_BHED : UInt = 0x62686564U // 'bhed'

///|
pub const TAG_BLOC : UInt = 0x626C6F63U // 'bloc'

///|
pub const TAG_BSLN : UInt = 0x62736C6EU // 'bsln'

///|
pub const TAG_CBDT : UInt = 0x43424454U // 'CBDT'

///|
pub const TAG_CBLC : UInt = 0x43424C43U // 'CBLC'

///|
pub const TAG_CFF : UInt = 0x43464620U // 'CFF '

///|
pub const TAG_CFF2 : UInt = 0x43464632U // 'CFF2'

///|
pub const TAG_CID : UInt = 0x43494420U // 'CID '

///|
pub const TAG_CMAP : UInt = 0x636D6170U // 'cmap'

///|
pub const TAG_COLR : UInt = 0x434F4C52U // 'COLR'

///|
pub const TAG_CPAL : UInt = 0x4350414CU // 'CPAL'

///|
pub const TAG_CVAR : UInt = 0x63766172U // 'cvar'

///|
pub const TAG_CVT : UInt = 0x63767420U // 'cvt '

///|
pub const TAG_DSIG : UInt = 0x44534947U // 'DSIG'

///|
pub const TAG_EBDT : UInt = 0x45424454U // 'EBDT'

///|
pub const TAG_EBLC : UInt = 0x45424C43U // 'EBLC'

///|
pub const TAG_EBSC : UInt = 0x45425343U // 'EBSC'

///|
pub const TAG_FEAT : UInt = 0x66656174U // 'feat'

///|
pub const TAG_FOND : UInt = 0x464F4E44U // 'FOND'

///|
pub const TAG_FPGM : UInt = 0x6670676DU // 'fpgm'

///|
pub const TAG_FVAR : UInt = 0x66766172U // 'fvar'

///|
pub const TAG_GASP : UInt = 0x67617370U // 'gasp'

///|
pub const TAG_GDEF : UInt = 0x47444546U // 'GDEF'

///|
pub const TAG_GLYF : UInt = 0x676C7966U // 'glyf'

///|
pub const TAG_GPOS : UInt = 0x47504F53U // 'GPOS'

///|
pub const TAG_GSUB : UInt = 0x47535542U // 'GSUB'

///|
pub const TAG_GVAR : UInt = 0x67766172U // 'gvar'

///|
pub const TAG_HVAR : UInt = 0x48564152U // 'HVAR'

///|
pub const TAG_HDMX : UInt = 0x68646D78U // 'hdmx'

///|
pub const TAG_HEAD : UInt = 0x68656164U // 'head'

///|
pub const TAG_HHEA : UInt = 0x68686561U // 'hhea'

///|
pub const TAG_HMTX : UInt = 0x686D7478U // 'hmtx'

///|
pub const TAG_JSTF : UInt = 0x4A535446U // 'JSTF'

///|
pub const TAG_JUST : UInt = 0x6A757374U // 'just'

///|
pub const TAG_KERN : UInt = 0x6B65726EU // 'kern'

///|
pub const TAG_LCAR : UInt = 0x6C636172U // 'lcar'

///|
pub const TAG_LOCA : UInt = 0x6C6F6361U // 'loca'

///|
pub const TAG_LTSH : UInt = 0x4C545348U // 'LTSH'

///|
pub const TAG_LWFN : UInt = 0x4C57464EU // 'LWFN'

///|
pub const TAG_MATH : UInt = 0x4D415448U // 'MATH'

///|
pub const TAG_MAXP : UInt = 0x6D617870U // 'maxp'

///|
pub const TAG_META : UInt = 0x4D455441U // 'META'

///|
pub const TAG_MMFX : UInt = 0x4D4D4658U // 'MMFX'

///|
pub const TAG_MMSD : UInt = 0x4D4D5344U // 'MMSD'

///|
pub const TAG_MORT : UInt = 0x6D6F7274U // 'mort'

///|
pub const TAG_MORX : UInt = 0x6D6F7278U // 'morx'

///|
pub const TAG_MVAR : UInt = 0x4D564152U // 'MVAR'

///|
pub const TAG_NAME : UInt = 0x6E616D65U // 'name'

///|
pub const TAG_OPBD : UInt = 0x6F706264U // 'opbd'

///|
pub const TAG_OS2 : UInt = 0x4F532F32U // 'OS/2'

///|
pub const TAG_OTTO : UInt = 0x4F54544FU // 'OTTO'

///|
pub const TAG_PCLT : UInt = 0x50434C54U // 'PCLT'

///|
pub const TAG_POST : UInt = 0x504F5354U // 'POST'

///|
pub const TAG_POST_LC : UInt = 0x706F7374U // 'post'

///|
pub const TAG_PREP : UInt = 0x70726570U // 'prep'

///|
pub const TAG_PROP : UInt = 0x70726F70U // 'prop'

///|
pub const TAG_SBIX : UInt = 0x73626978U // 'sbix'

///|
pub const TAG_SFNT : UInt = 0x73666E74U // 'sfnt'

///|
pub const TAG_SING : UInt = 0x53494E47U // 'SING'

///|
pub const TAG_SVG : UInt = 0x53564720U // 'SVG '

///|
pub const TAG_TRAK : UInt = 0x7472616BU // 'trak'

///|
pub const TAG_TRUE : UInt = 0x74727565U // 'true'

///|
pub const TAG_TTC : UInt = 0x74746320U // 'ttc '

///|
pub const TAG_TTCF : UInt = 0x74746366U // 'ttcf'

///|
pub const TAG_TYP1 : UInt = 0x54595031U // 'TYP1'

///|
pub const TAG_TYP1_LC : UInt = 0x74797031U // 'typ1'

///|
pub const TAG_VDMX : UInt = 0x56444D58U // 'VDMX'

///|
pub const TAG_VHEA : UInt = 0x76686561U // 'vhea'

///|
pub const TAG_VMTX : UInt = 0x766D7478U // 'vmtx'

///|
pub const TAG_VVAR : UInt = 0x56564152U // 'VVAR'

///|
pub const TAG_WOFF : UInt = 0x774F4646U // 'wOFF'

///|
pub const TAG_WOF2 : UInt = 0x774F4632U // 'wOF2'
