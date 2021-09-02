select distinct *
--from fee_pkg_tid
from mas_fees
where
    fee_status in ( 'C', 'F')
-- and tid_activity in ('010003005101', '010003005102')
--and EFFECTIVE_DATE > sysdate - 2
and
    (institution_id, fee_pkg_id) in (
    select inst, fee_pkg_id
      --, percent, (percent - 3 ) ref_pct
    from (

    select distinct
        efp.INSTITUTION_ID INST,
    --    efp.ENTITY_ID ENTITY_ID,
        efp.FEE_PKG_ID FEE_PKG_ID,
    --    efp.START_DATE START_DATE,
    --    efp.FEE_PKG_TYPE FP_TYPE,
    --    efp.END_DATE END_DATE,
        efp.MAS_CODE_GRP_ID MCG,
    --    efp.SKIP_PARENT SKIP_PARENT,
    --    fp.INSTITUTION_ID INSTITUTION_ID_0,
    --    fp.FEE_PKG_ID FEE_PKG_ID_1,
    --    fp.FEE_PKG_TYPE FEE_PKG_TYPE_2,
    --    fp.FEE_START_DATE FEE_START_DATE,
    --    fp.FEE_END_DATE FEE_END_DATE,
    --    fp.LAST_EVAL_DATE LAST_EVAL_DATE,
        fp.FEE_PKG_NAME FEE_PKG_NAME,
    --    mf.INSTITUTION_ID INSTITUTION_ID_3,
    --    mf.FEE_PKG_ID FEE_PKG_ID_4,
    --    mf.TID_ACTIVITY TID_ACTIVITY,
        mf.MAS_CODE MAS_CODE,
        mf.TID_FEE TID_FEE,
        --t.tid_settl_method "Trans D/C",
        t2.tid_settl_method "Fee D/C",
        mf.FEE_STATUS STS,
        mf.RATE_PER_ITEM PER_ITEM,
        mf.RATE_PERCENT PERCENT
        --,
    --    mf.FEE_CURR FEE_CURR,
    --    mf.FEE_GRP_ID FEE_GRP_ID,
    --    mf.ITEM_CNT_PLAN_ID ITEM_CNT_PLAN_ID
    from entity_fee_pkg efp
    join fee_pkg fp
    on fp.FEE_PKG_ID = efp.FEE_PKG_ID AND fp.INSTITUTION_ID = efp.INSTITUTION_ID
    join mas_fees mf
    on mf.FEE_PKG_ID = efp.FEE_PKG_ID AND mf.INSTITUTION_ID = efp.INSTITUTION_ID
    join tid t
    on t.tid = mf.TID_ACTIVITY
    join tid t2
    on t2.tid = mf.TID_FEE
    where efp.entity_id like '_______2166%'
    and
        (fp.fee_pkg_name like '%\_T1~%' escape '\'
         or
         fp.fee_pkg_name like '%\_DISCOUNT~%' escape '\'
        )
    and mf.FEE_STATUS != 'O'
    and efp.END_DATE is null
    and mf.RATE_PERCENT  > 5
    order by fp.fee_pkg_name, mf.RATE_PERCENT
    )
    --order by 1, 2
)
order by 1, 2, 3
;

select * from mas_fees where EFFECTIVE_DATE = '20-APR-16'
and tid_fee = '010004010005' order by 1,2,3,4,5
;

select * from mas_fees where EFFECTIVE_DATE = '21-APR-16'
and tid_fee = '010004010005' order by 1,2,3,4,5
;
/*
delete mas_fees where EFFECTIVE_DATE = '21-APR-16'
and tid_fee = '010004010005'
;
*/

update mas_fees
set fee_status = 'O'
where
    fee_status in ( 'C', 'F')
--and tid_activity not in ('010003005101', '010003005102', '010003005201')
and tid_activity not in ('010003005101')
and EFFECTIVE_DATE < sysdate - 2
and
    (institution_id, fee_pkg_id) in (
    select inst, fee_pkg_id
      --, percent, (percent - 3 ) ref_pct
    from (

    select distinct
        efp.INSTITUTION_ID INST,
    --    efp.ENTITY_ID ENTITY_ID,
        efp.FEE_PKG_ID FEE_PKG_ID,
    --    efp.START_DATE START_DATE,
    --    efp.FEE_PKG_TYPE FP_TYPE,
    --    efp.END_DATE END_DATE,
        efp.MAS_CODE_GRP_ID MCG,
    --    efp.SKIP_PARENT SKIP_PARENT,
    --    fp.INSTITUTION_ID INSTITUTION_ID_0,
    --    fp.FEE_PKG_ID FEE_PKG_ID_1,
    --    fp.FEE_PKG_TYPE FEE_PKG_TYPE_2,
    --    fp.FEE_START_DATE FEE_START_DATE,
    --    fp.FEE_END_DATE FEE_END_DATE,
    --    fp.LAST_EVAL_DATE LAST_EVAL_DATE,
        fp.FEE_PKG_NAME FEE_PKG_NAME,
    --    mf.INSTITUTION_ID INSTITUTION_ID_3,
    --    mf.FEE_PKG_ID FEE_PKG_ID_4,
    --    mf.TID_ACTIVITY TID_ACTIVITY,
        mf.MAS_CODE MAS_CODE,
        mf.TID_FEE TID_FEE,
        --t.tid_settl_method "Trans D/C",
        t2.tid_settl_method "Fee D/C",
        mf.FEE_STATUS STS,
        mf.RATE_PER_ITEM PER_ITEM,
        mf.RATE_PERCENT PERCENT
        --,
    --    mf.FEE_CURR FEE_CURR,
    --    mf.FEE_GRP_ID FEE_GRP_ID,
    --    mf.ITEM_CNT_PLAN_ID ITEM_CNT_PLAN_ID
    from entity_fee_pkg efp
    join fee_pkg fp
    on fp.FEE_PKG_ID = efp.FEE_PKG_ID AND fp.INSTITUTION_ID = efp.INSTITUTION_ID
    join mas_fees mf
    on mf.FEE_PKG_ID = efp.FEE_PKG_ID AND mf.INSTITUTION_ID = efp.INSTITUTION_ID
    join tid t
    on t.tid = mf.TID_ACTIVITY
    join tid t2
    on t2.tid = mf.TID_FEE
    where efp.entity_id like '_______2166%'
    and
        (fp.fee_pkg_name like '%\_T1~%' escape '\'
         or
         fp.fee_pkg_name like '%\_DISCOUNT~%' escape '\'
        )
    and mf.FEE_STATUS != 'O'
    and efp.END_DATE is null
    and mf.RATE_PERCENT  > 5
    order by fp.fee_pkg_name, mf.RATE_PERCENT
    )
)
;

select * from mas_fees where EFFECTIVE_DATE = '20-APR-16'
and tid_fee = '010004010005' order by 1,2,3,4,5
;

/*
delete mas_fees where EFFECTIVE_DATE = '21-APR-16'
and tid_fee = '010004010005'
;
*/

select *
from mas_fees
where fee_status is not null
and (institution_id, fee_pkg_id) in (
    select inst, fee_pkg_id

    from (

    select distinct
        efp.INSTITUTION_ID INST,

        efp.FEE_PKG_ID FEE_PKG_ID,

        efp.MAS_CODE_GRP_ID MCG,

        fp.FEE_PKG_NAME FEE_PKG_NAME,

        mf.MAS_CODE MAS_CODE,
        mf.TID_FEE TID_FEE,

        t2.tid_settl_method "Fee D/C",
        mf.FEE_STATUS STS,
        mf.RATE_PER_ITEM PER_ITEM,
        mf.RATE_PERCENT PERCENT


    from entity_fee_pkg efp
    join fee_pkg fp
    on fp.FEE_PKG_ID = efp.FEE_PKG_ID AND fp.INSTITUTION_ID = efp.INSTITUTION_ID
    join mas_fees mf
    on mf.FEE_PKG_ID = efp.FEE_PKG_ID AND mf.INSTITUTION_ID = efp.INSTITUTION_ID
    join tid t
    on t.tid = mf.TID_ACTIVITY
    join tid t2
    on t2.tid = mf.TID_FEE
    where efp.entity_id like '_______2166%'
    and
        (fp.fee_pkg_name like '%\_T1~%' escape '\'
         or
         fp.fee_pkg_name like '%\_DISCOUNT~%' escape '\'
        )
    and mf.FEE_STATUS != 'O'
    and efp.END_DATE is null
    and mf.RATE_PERCENT  > 5
    order by fp.fee_pkg_name, mf.RATE_PERCENT
    )

)
order by 1, 2, 3
;
