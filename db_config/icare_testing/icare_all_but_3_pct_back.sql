/*

select * from fee_pkg            where institution_id = '107' and fee_pkg_id = 107114068;
select * from fee_pkg_tid        where institution_id = '107' and fee_pkg_id = 107114068;
select * from fee_pkg_mas_code   where institution_id = '107' and fee_pkg_id = 107114068;
select * from mas_fees           where institution_id = '107' and fee_pkg_id = 107114068;
select * from entity_fee_pkg     where institution_id = '107' and fee_pkg_id = 107114068;

select * from mas_code_grp       where institution_id = '107' and mas_code_grp = 9 mas_code   = 'MC_T2';


REM INSERTING into MAS_FEES
SET DEFINE OFF;
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005101', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005201', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005201', 'MC_T2', '010004010000', to_date('01-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005201', 'MC_T2', '010004010000', to_date('02-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005301', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005401', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005401', 'MC_T2', '010004010000', to_date('01-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003005401', 'MC_T2', '010004010000', to_date('02-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015101', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015101', 'MC_T2', '010004010000', to_date('01-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015101', 'MC_T2', '010004010000', to_date('02-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015201', 'MC_T2', '010004010000', to_date('24-MAY-11', 'DD-MON-YY'), 'C', 0, 15, '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015201', 'MC_T2', '010004010000', to_date('01-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 107114068, '010003015201', 'MC_T2', '010004010000', to_date('02-NOV-14', 'DD-MON-YY'), 'C', 0, 3 , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);

*/

set serveroutput on;

declare
    cursor fee_pkg_list is
        select inst, fee_pkg_id, percent, (percent - 3 ) ref_pct
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
        where efp.entity_id like '_______2166%'  /* iCare agent */
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
        order by 1, 2
        ;

    idx number := 0;
    usage_cnt number;
    total_cnt number := 0 ;
    DB varchar(20);
    start_time varchar(40);
    finish_time varchar(40);

begin
    dbms_output.put_line (' ');
    select name into DB from v$database ;
    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into start_time from dual;
    dbms_output.put_line ('--Database:' || DB || ' at:' || start_time );

    for fpl in fee_pkg_list
    loop
        idx := idx + 1;
        update mas_fees mf
            set mf.fee_status = 'O'
        where mf.institution_id = fpl.inst
        and mf.fee_pkg_id = fpl.fee_pkg_id
        and mf.tid_activity != '010003005101'
        and mf.fee_status = 'C';

        /*
        merge into fee_pkg_tid
        using
            fee_pkg_tid fpt
            on (
                fpt.INSTITUTION_ID = fpl.inst and
                fpt.FEE_PKG_ID     = fpl.fee_pkg_id and
                fpt.TID_ACTIVITY   = '010003005102')
        when not matched then
            insert (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY )
            values (fpl.inst  , fpl.fee_pkg_id, '010003005102');
        */

        dbms_output.put_line ('   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (' || fpl.inst || ', ' || fpl.fee_pkg_id  ||  ', ''010003005102'');');
        dbms_output.put_line ('           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            ' || '''010003005102''' || ' TID_ACTIVITY,
            MAS_CODE,
            ' || '''010004010005''' || ' TID_FEE,
            ' || '''trunc(sysdate)''' || ' EFFECTIVE_DATE,
            ' || '''F''' || ' FEE_STATUS,
            RATE_PER_ITEM,
            ' || fpl.ref_pct || ' RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = ''' || fpl.inst || '''
        and mfl.fee_pkg_id = ''' || fpl.fee_pkg_id || '''
        and mfl.TID_ACTIVITY = ' || '''010003005101''' || '
        and mfl.fee_status = ' || '''C''' || ' ;');

        /*
        Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            fpl.ref_pct RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = fpl.inst
        and mfl.fee_pkg_id = fpl.fee_pkg_id
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C';
        */

        dbms_output.put_line ('--Inst:' || fpl.inst || ' ' || fpl.fee_pkg_id ||
            ' ' || fpl.percent || ' ' || fpl.ref_pct );
        total_cnt := total_cnt + 1;
        /* commit; */

    end loop;
    dbms_output.put_line ('--Usage / Card rows:' || idx || ' rows added:' || total_cnt );
    /* commit; */

    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into finish_time from dual;
    dbms_output.put_line ('--Database:' || DB || ' at:' || finish_time );
    dbms_output.put_line (' ');

end;

/* commit; */
