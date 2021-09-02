REM

REM $Id: check_interchange_us_fir_002.sql 17 2016-10-25 15:22:05Z bjones $

select distinct
    fir.card_scheme crd,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END Card,
    fir.mas_code,
    --CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
    --                                     mc.mas_desc end Description,
    fir.mas_desc,
    --mcg.mas_code_grp_id mcg_id ,
    --mcg.mas_code tier,
    fir.region,
    fir.association_updated assoc,
    fir.DATABASE_UPDATED db,
    fir.tier,
    fir.RATE_PERCENT,
    fir.RATE_PER_ITEM,
    fir.PER_TRANS_MAX
    --,
    --fir.usage
from flmgr_interchange_rates fir
left outer join card_scheme cs
on fir.CARD_SCHEME = cs.CARD_SCHEME
left outer join mas_code mc
on fir.MAS_CODE = mc.MAS_CODE
--join tid t
--on fir.TID_FEE = t.tid
--left outer join mas_code_grp mcg
--on fir.INSTITUTION_ID = mcg.INSTITUTION_ID
--AND fir.MAS_CODE = mcg.qualify_MAS_CODE
--and mcg.mas_code_grp_id = 9
where
    --fir.institution_id in ('101', '107', '105', '121')
--and fir.FEE_PKG_ID = 33
--and fir.fee_status != 'O'
--and
    not regexp_like(fir.mas_code, '010[3458]CN')
and not regexp_like(fir.mas_code, '08CN')
--and fir.mas_code like '%EIRF%'
and fir.usage = 'INTERCHANGE'
and (fir.region in ('USA', 'ALL') or fir.region is null)
and fir.RATE_PERCENT is not null
and fir.tier is not null
--and fir.mas_code like '08AVP1%'

order by fir.card_scheme, fir.mas_code
;
