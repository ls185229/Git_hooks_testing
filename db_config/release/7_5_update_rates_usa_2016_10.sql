REM Update rates in interchange fee packages

REM $Id: 7_5_update_rates_usa_2016_10.sql 38 2019-10-16 02:43:28Z bjones $

set serveroutput on size 1000000

DECLARE
    changed_rows NUMBER := 0;
    start_time date;
    end_time date;
    my_db varchar2(35);

    CURSOR mas_code_cursor
    IS
        SELECT mas_code,
            rate_per_item ,
            rate_percent  ,
            per_trans_max
        FROM flmgr_interchange_rates
        WHERE tier IS NOT NULL
        --AND usage = 'INTERCHANGE'
        and usage in ('ACTIVITY_ADMIN', 'INFRASTRUCT_SECURITY', 'NETWORK', 'PRE_AUTH', 'VISA_SWITCH', 'SWITCH_COMPLETION')
        ---and region in ('CAN', 'ALL')
        and (region in ('USA', 'ALL') or region is null)

        -- and mas_code like '0104CPS%'

        order by mas_code;

    CURSOR mas_fees_check_cursor (  in_mas_code VARCHAR2,
                                    in_rate_per_item NUMBER,
                                    in_rate_percent NUMBER,
                                    in_per_trans_max NUMBER)
    IS
        SELECT institution_id,
            fee_pkg_id          ,
            mas_code            ,
            rate_per_item       ,
            rate_percent        ,
            per_trans_max,
            tid_activity,
            tid_fee
        FROM mas_fees
        WHERE fee_pkg_id  IN ('33', '34')
        and institution_id in
            ---('127', '129', '130', '131', '132', '133', '134') /* Canada */
            ('101', '105x', '107x', '121x' )              /* USA */
        AND mas_code       = in_mas_code
        AND (rate_per_item != in_rate_per_item
        or rate_percent  != in_rate_percent
        or per_trans_max != in_per_trans_max
        or (per_trans_max is null and in_per_trans_max is not null)
        or (per_trans_max is not null and in_per_trans_max is null)
        );

    mas_code_cursor_row mas_code_cursor%rowtype;
    mas_fees_check_row mas_fees_check_cursor%rowtype;

    eff_date date := to_date('06-oct-17', 'DD-MON-YY');

BEGIN

    select sysdate into start_time from dual;
    select name into my_db from v$database;

    FOR mas_code_cursor_row IN mas_code_cursor
    LOOP
        dbms_output.put_line('Checking ' ||
            mas_code_cursor_row.mas_code || ' ' ||
            mas_code_cursor_row.rate_per_item || ' ' ||
            mas_code_cursor_row.rate_percent || ' ' ||
            mas_code_cursor_row.per_trans_max );

        OPEN mas_fees_check_cursor( mas_code_cursor_row.mas_code,
                                    mas_code_cursor_row.rate_per_item ,
                                    mas_code_cursor_row.rate_percent,
                                    mas_code_cursor_row.per_trans_max);
        LOOP
            FETCH mas_fees_check_cursor INTO mas_fees_check_row;
            EXIT WHEN mas_fees_check_cursor%NOTFOUND ;

            INSERT INTO mas_fees
                (
                INSTITUTION_ID ,
                FEE_PKG_ID ,
                TID_ACTIVITY ,
                MAS_CODE ,
                TID_FEE ,
                EFFECTIVE_DATE ,
                FEE_STATUS ,
                RATE_PER_ITEM ,
                RATE_PERCENT ,
                FEE_CURR ,
                CARD_SCHEME ,
                AMT_METHOD ,
                CNT_METHOD ,
                ADD_AMT1_METHOD ,
                ADD_CNT1_METHOD ,
                ADD_AMT2_METHOD ,
                ADD_CNT2_METHOD ,
                PER_TRANS_MAX ,
                PER_TRANS_MIN ,
                FEE_GRP_ID ,
                ITEM_CNT_PLAN_ID ,
                TIER_ID ,
                TIER_FREQ ,
                TIER_DATE_LIST_ID ,
                TIER_ASSM_DAY ,
                TIER_NXT_ASSM_DATE ,
                TIER_LASTASSM_DATE ,
                VARIABLE_PRICE_FLG ,
                SLIDING_PRICE_FLG
                )
            SELECT
                mf_l.INSTITUTION_ID ,
                mf_l.FEE_PKG_ID ,
                mf_l.TID_ACTIVITY ,
                mf_l.mas_code ,
                mf_l.TID_FEE ,
                eff_date Effective_date,
                'F' FEE_STATUS ,
                mas_code_cursor_row.rate_per_item rate_per_item ,
                mas_code_cursor_row.rate_percent  rate_percent ,
                mf_l.FEE_CURR ,
                mf_l.card_scheme ,
                mf_l.AMT_METHOD ,
                mf_l.CNT_METHOD ,
                mf_l.ADD_AMT1_METHOD ,
                mf_l.ADD_CNT1_METHOD ,
                mf_l.ADD_AMT2_METHOD ,
                mf_l.ADD_CNT2_METHOD ,
                case when mas_code_cursor_row.per_trans_max is null then null
                    else mas_code_cursor_row.per_trans_max end
                    per_trans_max ,
                mf_l.PER_TRANS_MIN ,
                mf_l.FEE_GRP_ID ,
                mf_l.ITEM_CNT_PLAN_ID ,
                mf_l.TIER_ID ,
                mf_l.TIER_FREQ ,
                mf_l.TIER_DATE_LIST_ID ,
                mf_l.TIER_ASSM_DAY ,
                mf_l.TIER_NXT_ASSM_DATE ,
                mf_l.TIER_LASTASSM_DATE ,
                mf_l.VARIABLE_PRICE_FLG ,
                mf_l.SLIDING_PRICE_FLG
            FROM MAS_FEES mf_l
            join institution i
            on  i.institution_id = mas_fees_check_row.institution_id
            left outer join mas_fees mf_r
            on
                mf_l.INSTITUTION_ID   =  mf_r.INSTITUTION_ID
            and mf_l.FEE_PKG_ID       =  mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY     =  mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE         =  mf_r.MAS_CODE
            and mf_l.TID_FEE          =  mf_r.TID_FEE
            and mf_l.EFFECTIVE_DATE   =  mf_r.EFFECTIVE_DATE

            WHERE
                mf_l.institution_id = mas_fees_check_row.institution_id
            and mf_l.fee_pkg_id     = mas_fees_check_row.fee_pkg_id
            and mf_l.tid_activity   = mas_fees_check_row.tid_activity
            and mf_l.tid_fee        = mas_fees_check_row.tid_fee
            and mf_l.mas_code       = mas_fees_check_row.mas_code
            and mf_r.institution_id is null
            ;

            if mas_fees_check_row.tid_activity = '010003005101' 
                and mas_fees_check_row.tid_fee = '010004720010'
            then
                dbms_output.put_line('Changing '
                    || mas_fees_check_row.institution_id || ' '
                    || mas_fees_check_row.fee_pkg_id || ' '
                    || mas_fees_check_row.mas_code || ' '
                    || mas_fees_check_row.tid_activity || ' '
                    || mas_fees_check_row.tid_fee
                    || ' to '
                    || mas_code_cursor_row.rate_per_item || ' '
                    || mas_code_cursor_row.rate_percent  || ' '''
                    || mas_code_cursor_row.per_trans_max || ''''
                    || ' from '
                    || mas_fees_check_row.rate_per_item || ' '
                    || mas_fees_check_row.rate_percent  || ' '''
                    || mas_fees_check_row.per_trans_max || '''');
            end if;

            /*
            update mas_fees
            set rate_per_item = mas_code_cursor_row.rate_per_item ,
                rate_percent  = mas_code_cursor_row.rate_percent  ,
                per_trans_max = mas_code_cursor_row.per_trans_max
                --,
                --effective_date = eff_date
            where
                institution_id = mas_fees_check_row.institution_id
            and fee_pkg_id     = mas_fees_check_row.fee_pkg_id
            and tid_activity   = mas_fees_check_row.tid_activity
            and tid_fee        = mas_fees_check_row.tid_fee
            and mas_code       = mas_fees_check_row.mas_code;
            */

            changed_rows := changed_rows + 1;
            commit;
        END LOOP;

        CLOSE mas_fees_check_cursor;
    END LOOP;

    dbms_output.put_line('Rows added: ' || changed_rows);
    commit;
    select sysdate into end_time from dual;

    dbms_output.put_line('Started at: ' || to_char(start_time, 'YY/MM/DD HH24:MI:SS'));
    dbms_output.put_line('Ended at:   ' || to_char(end_time,   'YY/MM/DD HH24:MI:SS'));
    dbms_output.put_line('Using database: ' || my_db);

END;
/

-- commit;
