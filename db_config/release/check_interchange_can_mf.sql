REM Check interchange rates in mas_fees

REM $Id: check_interchange_can_mf.sql 28 2017-05-16 16:24:40Z bjones $

/*
    select
        mas_code
        --, CARD_SCHEME
        --, region
        --, ASSOCIATION_UPDATED
    from FLMGR_INTERCHANGE_RATES
    where USAGE = 'INTERCHANGE'
    --and (region in ( 'CAN', 'ALL') and region is not null)
    and region != 'USA'
    and ASSOCIATION_UPDATED > trunc(sysdate, 'MM')

    minus

select mas_code
from (
*/

select distinct
    mf.card_scheme crd,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END Card,
    mf.mas_code,
    CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
                                         mc.mas_desc end Description,
    --to_char((mf.EFFECTIVE_DATE), 'YYYY/MM/DD HH24:MI:SS') effective,
    to_char(trunc(mf.EFFECTIVE_DATE), 'YYYY/MM/DD') effective,
    mf.fee_status sts,
    mcg.mas_code_grp_id mcg_id,
    mcg.mas_code tier,
    fir.region,
    mf.RATE_PERCENT,
    mf.RATE_PER_ITEM,
    mf.PER_TRANS_MAX,
    fir.tier fir_tier,
    fir.RATE_PERCENT fir_pct,
    fir.RATE_PER_ITEM fir_itm,
    fir.PER_TRANS_MAX fir_max,
    --fir.tier               - mcg.mas_code          d_t,
    nvl(fir.RATE_PERCENT, 0)  - nvl(mf.RATE_PERCENT, 0)   d_p,
    nvl(fir.RATE_PER_ITEM, 0) - nvl(mf.RATE_PER_ITEM, 0)  d_i,
    nvl(fir.PER_TRANS_MAX, 0) - nvl(mf.PER_TRANS_MAX, 0)  d_m,
    min(mf.institution_id) min_i,
    max(mf.institution_id) max_i,
    min(mf.TID_ACTIVITY) min_t,
    max(mf.TID_ACTIVITY) max_t,
    count(*) cnt

from mas_fees mf
left outer join FLMGR_INTERCHANGE_RATES fir
on fir.MAS_CODE = mf.mas_code
and fir.usage = 'INTERCHANGE'
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
where
    (
    mf.institution_id between '127'and '135'
    --or
    --mf.institution_id in ('101', '105', '107', '121', '122')
    )
and mf.FEE_PKG_ID in (33, 34)
and mf.fee_status != 'O'
--and mf.fee_status = 'F'
and mf.card_scheme != '02'
--and not regexp_like(mf.mas_code, '010[3458]CN')
--and not regexp_like(mf.mas_code, '08CN')
--and mf.mas_code like '%EIRF%'

/*
and (
    fir.RATE_PERCENT  != mf.RATE_PERCENT
or  fir.RATE_PER_ITEM != mf.RATE_PER_ITEM
or  fir.PER_TRANS_MAX != mf.PER_TRANS_MAX
or  (fir.PER_TRANS_MAX is null     and mf.PER_TRANS_MAX is not null )
or  (fir.PER_TRANS_MAX is not null and mf.PER_TRANS_MAX is null )
)
*/

--/*
and mf.mas_code in (
    select
        mas_code
        --, CARD_SCHEME
        --, region
        --, ASSOCIATION_UPDATED
    from FLMGR_INTERCHANGE_RATES
    where USAGE = 'INTERCHANGE'
    --and (region in ( 'CAN', 'ALL') and region is not null)
    and region != 'USA'
    and ASSOCIATION_UPDATED > trunc(sysdate, 'MM')
)
--*/

/*
and mf.mas_code in (

    '0104CNCONCRT1', '0104CNCONCRT1INTLSTL', '0104CNCONCRT2', '0104CNCONCRT2INTLSTL',
    '0104CNINFCRT1', '0104CNINFCRT1INTLSTL', '0104CNINFCRT2', '0104CNINFCRT2INTLSTL',
    '0104CNPPT1', '0104CNPPT1INTLSTL', '0104CNPPT2', '0104CNPPT2INTLSTL',
    '0105CNCHVSUPMKT', '0105CNCPHSRB'
)
*/
--and mf.TID_ACTIVITY like '%2'

group by
    mf.card_scheme  ,
    CASE WHEN cs.CARD_SCHEME = '02' THEN 'PIN DEBIT' ELSE cs.CARD_SCHEME_NAME END  ,
    mf.mas_code,
    CASE WHEN cs.CARD_SCHEME = '02' THEN mc.mas_desc || ' - ' || t.description else
                                         mc.mas_desc end  ,
    trunc(mf.EFFECTIVE_DATE)  ,
    mf.fee_status  ,
    mcg.mas_code_grp_id  ,
    mcg.mas_code  ,
    fir.region,
    mf.RATE_PERCENT,
    mf.RATE_PER_ITEM,
    mf.PER_TRANS_MAX,
    fir.tier          ,
    fir.RATE_PERCENT  ,
    fir.RATE_PER_ITEM ,
    fir.PER_TRANS_MAX ,
    --fir.tier          - mcg.mas_code    ,
    fir.RATE_PERCENT  - mf.RATE_PERCENT   ,
    fir.RATE_PER_ITEM - mf.RATE_PER_ITEM  ,
    fir.PER_TRANS_MAX - mf.PER_TRANS_MAX

/*
having
    nvl(fir.RATE_PERCENT, 0)  - nvl(mf.RATE_PERCENT, 0)   != 0
or  nvl(fir.RATE_PER_ITEM, 0) - nvl(mf.RATE_PER_ITEM, 0)  != 0
or  nvl(fir.PER_TRANS_MAX, 0) - nvl(mf.PER_TRANS_MAX, 0)  != 0
*/

order by mf.card_scheme, mf.mas_code
    ,
    to_char(trunc(mf.EFFECTIVE_DATE), 'YYYY/MM/DD') desc

/*
)
*/
;
