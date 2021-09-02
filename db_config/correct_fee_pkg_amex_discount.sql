
-- $Id: correct_fee_pkg_amex_discount.sql 4 2014-01-10 18:11:27Z bjones $

set serveroutput on ;
-- format wrapped;

declare
  cursor institution is
    SELECT distinct institution_id
    FROM masclr.institution
    WHERE institution_id in ('101', '105', '107', '112x', '121')
    order by institution_id ;

  cursor tid_activ is
    select tid
    from masclr.tid
    where tid in (
        '010003005101', '010003005201', '010003005301', '010003005401',
        '010003015101', '010003015201' )
        --, '010070010020', '010070010021'
    order by tid;

    idx         number := 0;
    fee_pkg_cnt number := 0;
    tid_cnt     number;
    fee_cnt     number;
    total_cnt   number := 0;
    DB          varchar(20);
    start_time  varchar(40);
    finish_time varchar(40);

begin

    select name into DB from v$database ;
    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into start_time from dual;
    dbms_output.put_line ('Database:' || DB || ' at:' || start_time );

    for inst in institution
    loop
        idx := idx + 1;
        fee_pkg_cnt := 0;

        for activ_tid in tid_activ
        loop
            fee_pkg_cnt := fee_pkg_cnt + 1;

            select count(*) cnt
            into tid_cnt
            from masclr.fee_pkg_tid fpt_l left join masclr.fee_pkg_tid fpt_r
            on
                fpt_l.INSTITUTION_ID = fpt_r.INSTITUTION_ID
            and fpt_l.fee_pkg_id     = fpt_r.fee_pkg_id
            and fpt_l.tid_activity   = '010070010020'
            and fpt_r.tid_activity   = activ_tid.tid
            where
                (fpt_l.institution_id, fpt_l.fee_pkg_id) in
                    (select institution_id, fee_pkg_id from masclr.fee_pkg
                    where fee_pkg_name like 'AMEX_DISCOUNT%'
                    and institution_id = inst.institution_id)
            and fpt_l.tid_activity   = '010070010020'
            and fpt_r.fee_pkg_id is null;

            select count(*) cnt
            into fee_cnt
            from masclr.mas_fees mf_l left join masclr.mas_fees mf_r
            on
                mf_l.INSTITUTION_ID = mf_r.INSTITUTION_ID
            and mf_l.fee_pkg_id     = mf_r.fee_pkg_id
            and mf_l.tid_activity   = '010070010020'
            and mf_r.tid_activity   = activ_tid.tid
            and mf_l.MAS_CODE       = mf_r.MAS_CODE
            and mf_l.TID_FEE        = mf_r.TID_FEE
            and mf_l.EFFECTIVE_DATE = mf_r.EFFECTIVE_DATE
            where
                (mf_l.institution_id, mf_l.fee_pkg_id) in
                    (select institution_id, fee_pkg_id from masclr.fee_pkg
                    where fee_pkg_name like 'AMEX_DISCOUNT%'
                    and institution_id = inst.institution_id)
            and mf_l.tid_activity   = '010070010020'
            and mf_r.fee_pkg_id is null;

            insert into fee_pkg_tid
            select
                    fpt_l.INSTITUTION_ID
                ,   fpt_l.FEE_PKG_ID
                ,   activ_tid.tid tid_activity
                --,   fpt_r.*
            from masclr.fee_pkg_tid fpt_l left join masclr.fee_pkg_tid fpt_r
            on
                fpt_l.INSTITUTION_ID = fpt_r.INSTITUTION_ID
            and fpt_l.fee_pkg_id     = fpt_r.fee_pkg_id
            and fpt_l.tid_activity   = '010070010020'
            and fpt_r.tid_activity   = activ_tid.tid
            where
                (fpt_l.institution_id, fpt_l.fee_pkg_id) in
                    (select institution_id, fee_pkg_id from masclr.fee_pkg
                    where fee_pkg_name like 'AMEX_DISCOUNT%'
                    and institution_id = inst.institution_id)
            and fpt_l.tid_activity   = '010070010020'
            and fpt_r.fee_pkg_id is null;

            insert into mas_fees
            select
                mf_l.INSTITUTION_ID     ,
                mf_l.FEE_PKG_ID         ,
                activ_tid.tid tid_activity ,
                mf_l.MAS_CODE           ,
                mf_l.TID_FEE            ,
                mf_l.EFFECTIVE_DATE     ,
                mf_l.FEE_STATUS         ,
                mf_l.RATE_PER_ITEM      ,
                mf_l.RATE_PERCENT       ,
                mf_l.FEE_CURR           ,
                mf_l.CARD_SCHEME        ,
                mf_l.AMT_METHOD         ,
                mf_l.CNT_METHOD         ,
                mf_l.ADD_AMT1_METHOD    ,
                mf_l.ADD_CNT1_METHOD    ,
                mf_l.ADD_AMT2_METHOD    ,
                mf_l.ADD_CNT2_METHOD    ,
                mf_l.PER_TRANS_MAX      ,
                mf_l.PER_TRANS_MIN      ,
                mf_l.FEE_GRP_ID         ,
                mf_l.ITEM_CNT_PLAN_ID   ,
                mf_l.TIER_ID            ,
                mf_l.TIER_FREQ          ,
                mf_l.TIER_DATE_LIST_ID  ,
                mf_l.TIER_ASSM_DAY      ,
                mf_l.TIER_NXT_ASSM_DATE ,
                mf_l.TIER_LASTASSM_DATE ,
                mf_l.VARIABLE_PRICE_FLG ,
                mf_l.SLIDING_PRICE_FLG
                --,   mf_r.*
            from masclr.mas_fees mf_l left join masclr.mas_fees mf_r
            on
                mf_l.INSTITUTION_ID = mf_r.INSTITUTION_ID
            and mf_l.FEE_PKG_ID     = mf_r.FEE_PKG_ID
            and mf_l.tid_activity   = '010070010020'
            and mf_r.tid_activity   = activ_tid.tid
            and mf_l.MAS_CODE       = mf_r.MAS_CODE
            and mf_l.TID_FEE        = mf_r.TID_FEE
            and mf_l.EFFECTIVE_DATE = mf_r.EFFECTIVE_DATE
            where
                (mf_l.institution_id, mf_l.fee_pkg_id) in
                    (select institution_id, fee_pkg_id from masclr.fee_pkg
                    where fee_pkg_name like 'AMEX_DISCOUNT%'
                    and institution_id = inst.institution_id)
            and mf_l.tid_activity   = '010070010020'
            and mf_r.fee_pkg_id is null;

            dbms_output.put_line ('Institution: '     || inst.institution_id ||
                                ' tid: '              || activ_tid.tid ||
                                ' mas_fees rows : '   || fee_cnt       ||
                                ' fee_pkg_tid rows: ' || tid_cnt);
            total_cnt := total_cnt + tid_cnt;
        end loop;

    end loop;
    dbms_output.put_line ('Institutions:' || idx || ' rows added:' || total_cnt );
    /* commit; */
    -- rollback;

    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into finish_time from dual;
    dbms_output.put_line ('Database:' || DB || ' at:' || finish_time );

end;

-- commit;
