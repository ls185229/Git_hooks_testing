REM Update rates in interchange fee packages

REM $Id: 7_6_update_rates_usa_2016_10.sql 28 2017-05-16 16:24:40Z bjones $

set serveroutput on size 1000000

DECLARE
    changed_rows NUMBER := 0;
    row_count    NUMBER := 0;
    start_time date;
    end_time date;
    my_db varchar2(35);

    CURSOR mas_code_cursor
    IS
        SELECT mas_code,
            rate_per_item ,
            rate_percent  ,
            per_trans_max ,
            template_mas_code temp_mc
        FROM flmgr_interchange_rates
        WHERE tier IS NOT NULL
        AND usage = 'INTERCHANGE'
        and region in ('CAN', 'ALL')
        --and region in ('USA', 'ALL')
        ---and (region in ('USA', 'ALL') or region is null)

        -- and mas_code like '0104CPS%'

        /*
        and mas_code in (
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
            '08CNSUPCC', '08CNSUPCP', '08CNSUPCSIGD', '08CNSUPPP', '08CNSUPPR',
            '08DINTLAVP', '08DINTLBASE'
            ,
            '08DAVPCDNXFP', '08DAVPCO', '08DAVPCODB', '08DAVPCONX', '08DAVPCONXFP',
            '08DAVPCOPR', '08DAVPCOPRNX', '08DAVPCOPRNXFP', '08DAVPCP', '08DAVPCR',
            '08SUPCDNX', '08SUPCDNXFP', '08SUPCP'
            ,
            '08CNAVP1CC', '08CNAVP1CD', '08CNAVP1CO', '08CNAVP1CP', '08CNAVP1PP',
            '08CNAVP1PR', '08CNAVP2CC', '08CNAVP2CD', '08CNAVP2CO', '08CNAVP2CP',
            '08CNAVP2PP', '08CNAVP2PR', '08CNAVP3CC', '08CNAVP3CD', '08CNAVP3CO',
            '08CNAVP3CP', '08CNAVP3PP', '08CNAVP3PR', '08CNBASECC', '08CNBASECP',
            '08CNBASECSIGD', '08CNBASEPP', '08CNBASEPR', '08CNCASHREIMB', '08CNCOBASE',
            '08CNCOHOT', '08CNCOPAS', '08CNCOPET', '08CNCOREC', '08CNCORET', '08CNCOSUP',
            '08CNDAVPCC', '08CNDAVPCO', '08CNDAVPCP', '08CNDAVPCSIGD', '08CNDAVPPP',
            '08CNDAVPPR', '08CNDCOBASE', '08CNDCOHOT', '08CNDCOPAS', '08CNDCOPET',
            '08CNDCOREC', '08CNDCORET', '08CNDCOSUP', '08CNDEFCC', '08CNDEFCP',
            '08CNDEFCSIGD', '08CNDEFPP', '08CNDEFPR', '08CNDINTLAVP', '08CNDINTLBASE',
            '08CNHOTCC', '08CNHOTCP', '08CNHOTCSIGD', '08CNHOTPP', '08CNHOTPR',
            '08CNINTLAVP', '08CNINTLBASE', '08CNINTLCASHREIMB', '08CNINTLELEC', '08CNPASCC',
            '08CNPASCP', '08CNPASCSIGD', '08CNPASPP', '08CNPASPR', '08CNPCC', '08CNPCD',
            '08CNPCDNXFP', '08CNPCP', '08CNPCR', '08CNPETCC', '08CNPETCP', '08CNPETCSIGD',
            '08CNPETPP', '08CNPETPR', '08CNPPP', '08CNPPR', '08CNPPRNXFP', '08CNRECCC',
            '08CNRECCP', '08CNRECCSIGD', '08CNRECPP', '08CNRECPR', '08CNRETCC', '08CNRETCP',
            '08CNRETCSIGD', '08CNRETPP', '08CNRETPR'
        */

        order by mas_code;

    CURSOR mas_fees_check_cursor (  in_mas_code VARCHAR2,
                                    in_rate_per_item NUMBER,
                                    in_rate_percent NUMBER,
                                    in_per_trans_max NUMBER)
    IS
        SELECT
            institution_id  ,
            fee_pkg_id      ,
            mas_code        ,
            rate_per_item   ,
            rate_percent    ,
            per_trans_max   ,
            tid_activity    ,
            tid_fee
        FROM mas_fees
        WHERE fee_pkg_id  IN ('33', '34')
        and institution_id in
            ('127', '129', '130', '131', '132', '133', '134') /* Canada */
            ---('101', '105', '107', '121' )              /* USA */
        and fee_status in ('C', 'F')
        AND mas_code       = in_mas_code
        AND (
             rate_per_item != in_rate_per_item
          or rate_percent  != in_rate_percent
          or per_trans_max != in_per_trans_max
          or (per_trans_max is null and in_per_trans_max is not null)
          or (per_trans_max is not null and in_per_trans_max is null)
        )
        ;

    mas_code_cursor_row mas_code_cursor%rowtype;
    mas_fees_check_row mas_fees_check_cursor%rowtype;

    eff_date date := to_date('16-Oct-16', 'DD-MON-YY');

BEGIN

    select sysdate into start_time from dual;
    select name into my_db from v$database;

    FOR mas_code_cursor_row IN mas_code_cursor
    LOOP

        dbms_output.put_line('Checking ' ||
            mas_code_cursor_row.temp_mc || ' ' ||
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

            if mas_fees_check_row.tid_activity = '010003005101'
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
                mas_code_cursor_row.mas_code mas_code ,
                mf_l.TID_FEE ,
                eff_date Effective_date,
                'F' FEE_STATUS ,
                mas_code_cursor_row.rate_per_item rate_per_item ,
                mas_code_cursor_row.rate_percent  rate_percent ,
                i.INST_CURR_CODE FEE_CURR ,
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
            on  i.institution_id = mf_l.institution_id
            left outer join mas_fees mf_r
            on
                mf_l.INSTITUTION_ID   =  mf_r.INSTITUTION_ID
            and mf_l.FEE_PKG_ID       =  mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY     =  mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE         =  mas_code_cursor_row.temp_mc
            and mf_r.MAS_CODE         =  mas_code_cursor_row.mas_code
            and mf_l.TID_FEE          =  mf_r.TID_FEE
            and mf_r.fee_status       in ('C', 'F')
            --and mf_l.rate_per_item = mas_fees_check_row.rate_per_item
            --and mf_r.rate_per_item = mas_code_cursor_row.rate_per_item
            --and mf_l.rate_percent  = mas_fees_check_row.rate_percent
            --and mf_r.rate_percent  = mas_code_cursor_row.rate_percent

            and mf_r.EFFECTIVE_DATE  = eff_date

            WHERE
                mf_l.institution_id = mas_fees_check_row.institution_id
            and mf_l.fee_pkg_id     = mas_fees_check_row.fee_pkg_id
            and mf_l.mas_code       = mas_code_cursor_row.temp_mc
            -- and mf_l.rate_per_item  = mas_fees_check_row.rate_per_item
            -- and mf_l.rate_percent   = mas_fees_check_row.rate_percent
            -- --and mf_l.per_trans_max  = mas_fees_check_row.per_trans_max
            -- and mf_l.tid_activity   = mas_fees_check_row.tid_activity
            -- and mf_l.tid_fee        = mas_fees_check_row.tid_fee
            -- and mf_l.fee_curr       = i.inst_curr_code
            and mf_r.institution_id is null
            ;

            -- row_count = SQL%ROWCOUNT;
            if  SQL%ROWCOUNT > 0
            then
                DBMS_OUTPUT.PUT_LINE('         Inserted ' ||  SQL%ROWCOUNT || ' rows.');
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
