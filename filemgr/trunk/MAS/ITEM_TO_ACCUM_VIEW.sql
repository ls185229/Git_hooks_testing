/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    $Id: ITEM_TO_ACCUM_VIEW.sql 4261 2017-08-07 20:20:44Z skumar $
    Origninal version: Copied from clear1 schema
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

CREATE OR REPLACE FORCE VIEW "MASCLR"."ITEM_TO_ACCUM_VIEW" (
    "INSTITUTION_ID", "ENTITY_ID", "TID_TO_ACCUM", "MAS_CODE_TO_ACCUM",
    "TID_SRC_TO_ACCUM", "CARD_SCH_TO_ACCUM", "CURR_CODE_TO_ACCUM",
    "CONVERT_TO_CURR", "FEE_PKG_ID", "PAYMENT_CYCLE"
  ) AS
  (select distinct 
        naf.institution_id                     AS INSTITUTION_ID      , 
        enafp.entity_id                        AS ENTITY_ID           , 
        icpd.tid_to_accum                      AS TID_TO_ACCUM        , 
        icpd.mas_code_to_accum                 AS MAS_CODE_TO_ACCUM   , 
        icpd.tid_src_to_accum                  AS TID_SRC_TO_ACCUM    , 
        icpd.card_sch_to_accum                 AS CARD_SCH_TO_ACCUM   ,
        icpd.curr_code_to_accum                AS CURR_CODE_TO_ACCUM  , 
        naf.fee_curr                           AS CONVERT_TO_CURR     , 
        0                                      AS FEE_PKG_ID          ,
        '*'                                    AS PAYMENT_CYCLE 
        from non_activity_fees naf 
        join ent_nonact_fee_pkg enafp 
            on naf.INSTITUTION_ID = enafp.INSTITUTION_ID 
            and naf.NON_ACT_FEE_PKG_ID = enafp.NON_ACT_FEE_PKG_ID 
            and enafp.END_DATE is null
        join item_cnt_plan_det icpd 
            on icpd.INSTITUTION_ID = enafp.INSTITUTION_ID 
            and naf.ITEM_CNT_PLAN_ID = icpd.ITEM_CNT_PLAN_ID 
        join acq_entity ae 
            on ae.INSTITUTION_ID = enafp.INSTITUTION_ID and ae.ENTITY_ID = enafp.ENTITY_ID
        where 
        ae.TERMINATION_DATE is null
        and ae.ENTITY_STATUS = 'A'
        and naf.next_generate_date >=  trunc(sysdate)
        and naf.item_cnt_plan_id is not null
    );
