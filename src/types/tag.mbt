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
pub let tag_avar : UInt = 0x61766172U // 'avar'

///|
pub let tag_BASE : UInt = 0x42415345U // 'BASE'

///|
pub let tag_bdat : UInt = 0x62646174U // 'bdat'

///|
pub let tag_BDF : UInt = 0x42444620U // 'BDF '

///|
pub let tag_bhed : UInt = 0x62686564U // 'bhed'

///|
pub let tag_bloc : UInt = 0x626C6F63U // 'bloc'

///|
pub let tag_bsln : UInt = 0x62736C6EU // 'bsln'

///|
pub let tag_CBDT : UInt = 0x43424454U // 'CBDT'

///|
pub let tag_CBLC : UInt = 0x43424C43U // 'CBLC'

///|
pub let tag_CFF : UInt = 0x43464620U // 'CFF '

///|
pub let tag_CFF2 : UInt = 0x43464632U // 'CFF2'

///|
pub let tag_CID : UInt = 0x43494420U // 'CID '

///|
pub let tag_cmap : UInt = 0x636D6170U // 'cmap'

///|
pub let tag_COLR : UInt = 0x434F4C52U // 'COLR'

///|
pub let tag_CPAL : UInt = 0x4350414CU // 'CPAL'

///|
pub let tag_cvar : UInt = 0x63766172U // 'cvar'

///|
pub let tag_cvt : UInt = 0x63767420U // 'cvt '

///|
pub let tag_DSIG : UInt = 0x44534947U // 'DSIG'

///|
pub let tag_EBDT : UInt = 0x45424454U // 'EBDT'

///|
pub let tag_EBLC : UInt = 0x45424C43U // 'EBLC'

///|
pub let tag_EBSC : UInt = 0x45425343U // 'EBSC'

///|
pub let tag_feat : UInt = 0x66656174U // 'feat'

///|
pub let tag_FOND : UInt = 0x464F4E44U // 'FOND'

///|
pub let tag_fpgm : UInt = 0x6670676DU // 'fpgm'

///|
pub let tag_fvar : UInt = 0x66766172U // 'fvar'

///|
pub let tag_gasp : UInt = 0x67617370U // 'gasp'

///|
pub let tag_GDEF : UInt = 0x47444546U // 'GDEF'

///|
pub let tag_glyf : UInt = 0x676C7966U // 'glyf'

///|
pub let tag_GPOS : UInt = 0x47504F53U // 'GPOS'

///|
pub let tag_GSUB : UInt = 0x47535542U // 'GSUB'

///|
pub let tag_gvar : UInt = 0x67766172U // 'gvar'

///|
pub let tag_HVAR : UInt = 0x48564152U // 'HVAR'

///|
pub let tag_hdmx : UInt = 0x68646D78U // 'hdmx'

///|
pub let tag_head : UInt = 0x68656164U // 'head'

///|
pub let tag_hhea : UInt = 0x68686561U // 'hhea'

///|
pub let tag_hmtx : UInt = 0x686D7478U // 'hmtx'

///|
pub let tag_JSTF : UInt = 0x4A535446U // 'JSTF'

///|
pub let tag_just : UInt = 0x6A757374U // 'just'

///|
pub let tag_kern : UInt = 0x6B65726EU // 'kern'

///|
pub let tag_lcar : UInt = 0x6C636172U // 'lcar'

///|
pub let tag_loca : UInt = 0x6C6F6361U // 'loca'

///|
pub let tag_LTSH : UInt = 0x4C545348U // 'LTSH'

///|
pub let tag_LWFN : UInt = 0x4C57464EU // 'LWFN'

///|
pub let tag_MATH : UInt = 0x4D415448U // 'MATH'

///|
pub let tag_maxp : UInt = 0x6D617870U // 'maxp'

///|
pub let tag_META : UInt = 0x4D455441U // 'META'

///|
pub let tag_MMFX : UInt = 0x4D4D4658U // 'MMFX'

///|
pub let tag_MMSD : UInt = 0x4D4D5344U // 'MMSD'

///|
pub let tag_mort : UInt = 0x6D6F7274U // 'mort'

///|
pub let tag_morx : UInt = 0x6D6F7278U // 'morx'

///|
pub let tag_MVAR : UInt = 0x4D564152U // 'MVAR'

///|
pub let tag_name : UInt = 0x6E616D65U // 'name'

///|
pub let tag_opbd : UInt = 0x6F706264U // 'opbd'

///|
pub let tag_OS2 : UInt = 0x4F532F32U // 'OS/2'

///|
pub let tag_OTTO : UInt = 0x4F54544FU // 'OTTO'

///|
pub let tag_PCLT : UInt = 0x50434C54U // 'PCLT'

///|
pub let tag_POST : UInt = 0x504F5354U // 'POST'

///|
pub let tag_post : UInt = 0x706F7374U // 'post'

///|
pub let tag_prep : UInt = 0x70726570U // 'prep'

///|
pub let tag_prop : UInt = 0x70726F70U // 'prop'

///|
pub let tag_sbix : UInt = 0x73626978U // 'sbix'

///|
pub let tag_sfnt : UInt = 0x73666E74U // 'sfnt'

///|
pub let tag_SING : UInt = 0x53494E47U // 'SING'

///|
pub let tag_SVG : UInt = 0x53564720U // 'SVG '

///|
pub let tag_trak : UInt = 0x7472616BU // 'trak'

///|
pub let tag_true : UInt = 0x74727565U // 'true'

///|
pub let tag_ttc : UInt = 0x74746320U // 'ttc '

///|
pub let tag_ttcf : UInt = 0x74746366U // 'ttcf'

///|
pub let tag_TYP1 : UInt = 0x54595031U // 'TYP1'

///|
pub let tag_typ1 : UInt = 0x74797031U // 'typ1'

///|
pub let tag_VDMX : UInt = 0x56444D58U // 'VDMX'

///|
pub let tag_vhea : UInt = 0x76686561U // 'vhea'

///|
pub let tag_vmtx : UInt = 0x766D7478U // 'vmtx'

///|
pub let tag_VVAR : UInt = 0x56564152U // 'VVAR'

///|
pub let tag_wOFF : UInt = 0x774F4646U // 'wOFF'

///|
pub let tag_wOF2 : UInt = 0x774F4632U // 'wOF2'
