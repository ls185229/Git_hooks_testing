REM Check interchange rates in flmgr_interchange_rates

REM $Id: check_interchange_us_fir.sql 38 2019-10-16 02:43:28Z bjones $

set linesize 1000
set pagesize 100

select distinct
    fir.card_scheme crd,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END Card,
    fir.mas_code,
    --CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
    --                                     mc.mas_desc end Description,
    fir.mas_desc,
    mc.mas_desc mc_desc,
    --mcg.mas_code_grp_id mcg_id ,
    --mcg.mas_code tier,
    fir.region,
    mf.fee_status sts,
    to_char(fir.association_updated, 'YYYY/MM/DD') assoc,
    to_char(trunc(mf.EFFECTIVE_DATE), 'YYYY/MM/DD') effective,
    to_char(fir.DATABASE_UPDATED, 'YYYY/MM/DD') db,
    fir.tier          ,
    fir.RATE_PERCENT  ,
    fir.RATE_PER_ITEM ,
    fir.PER_TRANS_MAX ,
    mf.RATE_PERCENT   mf_pct  ,
    mf.RATE_PER_ITEM  mf_itm  ,
    mf.PER_TRANS_MAX  mf_max  ,

    nvl(fir.RATE_PERCENT, 0)  - nvl(mf.RATE_PERCENT, 0)   d_p,
    nvl(fir.RATE_PER_ITEM, 0) - nvl(mf.RATE_PER_ITEM, 0)  d_i,
    nvl(fir.PER_TRANS_MAX, 0) - nvl(mf.PER_TRANS_MAX, 0)  d_m
    --,
    --min(mf.institution_id) min_i,
    --max(mf.institution_id) max_i,
    --min(mf.TID_ACTIVITY) min_t,
    --max(mf.TID_ACTIVITY) max_t


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

left outer join mas_fees mf
on fir.MAS_CODE = mf.mas_code
and fir.usage in (
    'INTERCHANGE', 'NETWORK', 'PRE_AUTH', 'SWITCH_COMPLETION', 'ACTIVITY_ADMIN',
    'INFRASTRUCT_SECURITY', 'VISA_SWITCH', 'DEFAULT_DISCOUNT'
)

and mf.fee_status != 'O'
and mf.FEE_PKG_ID = 33
and mf.institution_id in ('101', '105', '107', '121')

where

    --fir.institution_id in ('101', '107', '105', '121')
--and fir.FEE_PKG_ID = 33
--and fir.fee_status != 'O'
--and
--    not regexp_like(fir.mas_code, '010[3458]CN')
--and not regexp_like(fir.mas_code, '08CN')
--and fir.mas_code like '%EIRF%'
--and
    fir.usage = 'INTERCHANGE'
---and (fir.region in ('CAN', 'ALL') )
and (fir.region in ('USA', 'ALL') or fir.region is null)
and fir.RATE_PERCENT is not null
and fir.tier is not null


        /*
        and fir.mas_code in (
            '0104CPSAFDDB', '0104CPSRTL2DB', '0104INTLNKFUEL', '0104INTLNKFUELPP',
            '0104INTLNKSPMKTPP', '0104PADBFUEL', '0104PAPPFUEL', '0104PAPPSMKT', '0104PS2AF',
            '0104UCPSRTL2PP', '0104UEIRFDB', '0104UEIRFPP', '0104USMKTPP', '0104USVCSTNCR',
            '0104USVCSTNDB', '0104USVCSTNPP', '0104USVSPSTD', '0105DUCWHC', '0105DUCWHCT1',
            '0105DUCWHCT2', '0105DUCWHCT3', '0105DUSERVST', '0105DUSUP', '0105DUSUPT1',
            '0105DUSUPT2', '0105DUSUPT3', '0105HPETBASE', '0105UENHPETR', '0105UPETR',
            '0105UWEMCPETR', '0105UWMCPETR', '08SUPCDNXFP'
        )
        */



/*
and (
    fir.RATE_PERCENT  != mf.RATE_PERCENT
or  fir.RATE_PER_ITEM != mf.RATE_PER_ITEM
or  fir.PER_TRANS_MAX != mf.PER_TRANS_MAX
or  (fir.PER_TRANS_MAX is null     and mf.PER_TRANS_MAX is not null )
or  (fir.PER_TRANS_MAX is not null and mf.PER_TRANS_MAX is null )
)
*/

--and

--    fir.mas_code like '08DAVP%' and fir.usage = 'INTERCHANGE'

group by
    fir.card_scheme ,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END ,
    fir.mas_code,
    --CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
    --                                     mc.mas_desc end Description,
    fir.mas_desc,
    mc.mas_desc ,
    --mcg.mas_code_grp_id mcg_id ,
    --mcg.mas_code tier,
    fir.region,
    mf.fee_status ,
    to_char(fir.association_updated, 'YYYY/MM/DD') ,
    to_char(trunc(mf.EFFECTIVE_DATE), 'YYYY/MM/DD') ,
    to_char(fir.DATABASE_UPDATED, 'YYYY/MM/DD') ,
    fir.tier          ,
    fir.RATE_PERCENT  ,
    fir.RATE_PER_ITEM ,
    fir.PER_TRANS_MAX ,
    mf.RATE_PERCENT   ,
    mf.RATE_PER_ITEM  ,
    mf.PER_TRANS_MAX  

order by fir.card_scheme, fir.mas_code
;
