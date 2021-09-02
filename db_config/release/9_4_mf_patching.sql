REM

REM $Id: 9_4_mf_patching.sql 38 2019-10-16 02:43:28Z bjones $

SET TIMING ON;
set serveroutput on ;
-- format wrapped;

declare

    cursor inst_dest is
        select
            institution_id inst, INST_CURR_CODE
        from masclr.institution
        where
          institution_id in ('122')
          --institution_id in ('101', '105', '107', '121')
          ---institution_id between '127' and '135'
        ;

    cursor inst_src is
        select
            institution_id inst, INST_CURR_CODE
        from masclr.institution
        where
          institution_id in ('101', '105', '107', '121')
          ---institution_id between '127' and '135'
        ;

    insert_cnt  number(16) := 0;
    total_cnt   number(16) := 0;
    DB          varchar(20);
    start_time  date;
    finish_time date;

begin

    select name into DB from v$database ;
    select sysdate into start_time from dual;
    dbms_output.put_line ('Database:' || DB || ' at:' || to_char(start_time, 'YYYY-MM-DD HH24:MI:SS')  );

    for src in inst_src
    loop

        for dest in inst_dest
        loop

            select count(*) into insert_cnt
            from mas_fees mf_l left outer join mas_fees mf_r
            on  mf_l.institution_id   = src.inst
            and mf_r.institution_id   = dest.inst
            and mf_l.FEE_PKG_ID     = mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY   = mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE       = mf_r.MAS_CODE
            and mf_l.TID_FEE        = mf_r.TID_FEE
            and trunc(mf_l.EFFECTIVE_DATE) = trunc(mf_r.EFFECTIVE_DATE)
            where
                mf_l.institution_id   = src.inst
            and mf_r.mas_code is null
            and mf_l.fee_pkg_id < 100
            and mf_l.fee_status != 'O'
            ;

            --/*
            insert into mas_fees
            select
                    dest.inst as INSTITUTION_ID
                ,   mf_l.FEE_PKG_ID
                ,   mf_l.TID_ACTIVITY
                ,   mf_l.MAS_CODE
                ,   mf_l.TID_FEE
                ,   trunc(mf_l.EFFECTIVE_DATE) EFFECTIVE_DATE
                ,   mf_l.FEE_STATUS
                ,   mf_l.RATE_PER_ITEM
                ,   mf_l.RATE_PERCENT
                ,   dest.INST_CURR_CODE  FEE_CURR
                ,   mf_l.CARD_SCHEME
                ,   mf_l.AMT_METHOD
                ,   mf_l.CNT_METHOD
                ,   mf_l.ADD_AMT1_METHOD
                ,   mf_l.ADD_CNT1_METHOD
                ,   mf_l.ADD_AMT2_METHOD
                ,   mf_l.ADD_CNT2_METHOD
                ,   mf_l.PER_TRANS_MAX
                ,   mf_l.PER_TRANS_MIN
                ,   mf_l.FEE_GRP_ID
                ,   mf_l.ITEM_CNT_PLAN_ID
                ,   mf_l.TIER_ID
                ,   mf_l.TIER_FREQ
                ,   mf_l.TIER_DATE_LIST_ID
                ,   mf_l.TIER_ASSM_DAY
                ,   mf_l.TIER_NXT_ASSM_DATE
                ,   mf_l.TIER_LASTASSM_DATE
                ,   mf_l.VARIABLE_PRICE_FLG
                ,   mf_l.SLIDING_PRICE_FLG
            from mas_fees mf_l left outer join mas_fees mf_r
            on  mf_l.institution_id   = src.inst
            and mf_r.institution_id   = dest.inst
            and mf_l.FEE_PKG_ID     = mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY   = mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE       = mf_r.MAS_CODE
            and mf_l.TID_FEE        = mf_r.TID_FEE
            and trunc(mf_l.EFFECTIVE_DATE) = trunc(mf_r.EFFECTIVE_DATE)
            where
                mf_l.institution_id   = src.inst
            and mf_r.mas_code is null
            and mf_l.fee_pkg_id < 100
            and mf_l.fee_status != 'O'
            ;
            --commit;
            -- */

            dbms_output.put_line ('    ' || insert_cnt || ' Inserts from ' || src.inst || ' to ' || dest.inst);
            total_cnt := total_cnt + insert_cnt;

        end loop;

        dbms_output.put_line ('  ' || ' ');

    end loop;

    dbms_output.put_line ('    ' || total_cnt || ' Inserts');

    select  sysdate into finish_time from dual;

    dbms_output.put_line ('Database:' || DB || ' at:' || to_char(finish_time, 'YYYY-MM-DD HH24:MI:SS')  );
    --dbms_output.put_line ('Time spent ' || to_char(finish_time - start_time, 'YYYY-MM-DD HH24:MI:SS')  );
end;
