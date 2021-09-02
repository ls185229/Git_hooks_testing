REM

REM $Id: 2_0_flmgr_firt_merge_fir.sql 38 2019-10-16 02:43:28Z bjones $


--select * from
/*
delete flmgr_interchange_rates
where card_scheme != '02'
and usage in ('ACTIVITY_ADMIN', 'INFRASTRUCT_SECURITY', 'NETWORK', 'PRE_AUTH', 'VISA_SWITCH', 'SWITCH_COMPLETION')
;
*/


merge into flmgr_interchange_rates fir
using flmgr_ichg_rates_template firt
on
(
    fir.mas_code         = firt.mas_code
and fir.usage            = firt.usage
)

when matched then

update
set
    MAS_DESC            = firt.MAS_DESC,
    TIER                = firt.TIER,
    RATE_PERCENT        = firt.RATE_PERCENT,
    RATE_PER_ITEM       = firt.RATE_PER_ITEM,
    PER_TRANS_MAX       = firt.PER_TRANS_MAX,
    FPI_IRD             = firt.FPI_IRD,
    PROGRAM             = firt.PROGRAM,
    PROGRAM_DESC        = firt.PROGRAM_DESC,
    ASSOCIATION_UPDATED = trunc(sysdate),
    RETIRE              = firt.RETIRE,
    DATABASE_UPDATED    = firt.DATABASE_UPDATED,
    CARD_SCHEME         = firt.CARD_SCHEME,
    TEMPLATE_MAS_CODE   = firt.TEMPLATE_MAS_CODE,
    NOTES               = firt.NOTES,
    PER_TRANS_MIN       = firt.PER_TRANS_MIN,
    REGION              = firt.REGION

when not matched then

Insert
    (MAS_CODE,
    MAS_DESC,
    TIER,
    RATE_PERCENT,
    RATE_PER_ITEM,
    PER_TRANS_MAX,
    FPI_IRD,
    PROGRAM,
    PROGRAM_DESC,
    ASSOCIATION_UPDATED,
    RETIRE,
    DATABASE_UPDATED,
    CARD_SCHEME,
    TEMPLATE_MAS_CODE,
    NOTES,
    PER_TRANS_MIN,
    USAGE,
    REGION,
    CNTRY_CODE
    )
values
    (firt.MAS_CODE,
    firt.MAS_DESC,
    firt.TIER,
    firt.RATE_PERCENT,
    firt.RATE_PER_ITEM,
    firt.PER_TRANS_MAX,
    firt.FPI_IRD,
    firt.PROGRAM,
    firt.PROGRAM_DESC,
    trunc(sysdate),
    firt.RETIRE,
    null ,
    firt.CARD_SCHEME,
    firt.TEMPLATE_MAS_CODE,
    firt.NOTES,
    firt.PER_TRANS_MIN,
    firt.USAGE,
    firt.REGION,
    firt.CNTRY_CODE
    )

;

commit;
