REM

REM $Id: check_interchange_us_mf.sql 17 2016-10-25 15:22:05Z bjones $

select distinct
    mf.card_scheme crd,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END Card,
    mf.mas_code,
    CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
                                         mc.mas_desc end Description,
    trunc(mf.EFFECTIVE_DATE) effective,
    mf.fee_status sts,
    mcg.mas_code_grp_id mcg_id,
    mcg.mas_code tier,
    mf.RATE_PERCENT,
    mf.RATE_PER_ITEM,
    mf.PER_TRANS_MAX
from mas_fees mf
left outer join card_scheme cs
on mf.CARD_SCHEME = cs.CARD_SCHEME
left outer join mas_code mc
on mf.MAS_CODE = mc.MAS_CODE
left outer join tid t
on mf.TID_FEE = t.tid
left outer join mas_code_grp mcg
on mf.INSTITUTION_ID = mcg.INSTITUTION_ID
AND mf.MAS_CODE = mcg.qualify_MAS_CODE
and mcg.mas_code_grp_id = 9
where mf.institution_id in ('101', '107', '105', '121')
and mf.FEE_PKG_ID = 33
and mf.fee_status != 'O'
and not regexp_like(mf.mas_code, '010[3458]CN')
--and not regexp_like(mf.mas_code, '08CN')
--and mf.mas_code like '%EIRF%'
order by mf.card_scheme, mf.mas_code;
