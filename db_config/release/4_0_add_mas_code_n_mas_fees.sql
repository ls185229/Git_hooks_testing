REM Add missing mas codes to interchange fee packages

REM $Id: 4_0_add_mas_code_n_mas_fees.sql 34 2017-10-06 20:14:33Z skumar $

SET serveroutput ON size 1000000
REM turn variable substitution off so ampersands in data will not be a problem.
SET define OFF

DECLARE 

    eff_date date := to_date('21-Apr-17', 'DD-MON-YY');

    TYPE missing_mas_codes_aat IS
        TABLE OF flmgr_interchange_rates%rowtype INDEX BY pls_integer;
    missing_mas_codes missing_mas_codes_aat;
    --mas_code_conf_query_string VARCHAR2(10000);
    row_index pls_integer;

    changed_rows number := 0;
    rows_added number := 0;

    cursor inst_fp is
        SELECT distinct institution_id, fee_pkg_id
        FROM fee_pkg
        WHERE institution_id IN
           ('129', '130', '131', '132', '133', '134') /* Canada */
          -- ('101', '105', '107', '121','122' )              /* USA */
        AND fee_pkg_id   IN (33, 34); /* , '66', '67', '78' */

    cursor flmgr_interchange (inst varchar, fp_id number) is
        SELECT
            distinct
            mas_code,
            rate_per_item,
            --rate_per_item,
            rate_percent,
            per_trans_max,
            card_scheme,
            template_mas_code

        FROM flmgr_interchange_rates
        WHERE tier       IS NOT NULL
        AND usage = 'INTERCHANGE'
        -- and card_scheme = '08'
        and region in ('CAN', 'ALL')
        --and (region in ('USA', 'ALL') or region is null)
        --AND mas_code IN
        --    (
        --    SELECT mas_code --,region
        --    FROM flmgr_interchange_rates
        --    WHERE tier   IS NOT NULL
        --    AND usage = 'INTERCHANGE'

            /*
            MINUS
            SELECT mas_code
            FROM mas_fees
            where institution_id = inst
            and fee_pkg_id = fp_id
            */
        --    )
        ORDER BY mas_code;

BEGIN

    DBMS_OUTPUT.put_line('REM Before Processing '  );
    for ifp in inst_fp
    loop
        DBMS_OUTPUT.put_line('REM ');
        DBMS_OUTPUT.put_line('REM in outer loop ' || ifp.institution_id ||
            '  ' ||  ifp.fee_pkg_id);
        for fi in flmgr_interchange(ifp.institution_id, ifp.fee_pkg_id)
        loop

            -- DBMS_OUTPUT.put_line('    REM in inner loop '  );
            --mas_code_conf_query_string := mas_code_conf_query_string ||
            --    ', ''' || fi.mas_code || '''';
            DBMS_OUTPUT.put_line('REM Processing ' || fi.mas_code );

            dbms_output.put_line( 'REM Attempt to add ' || fi.mas_code ||
                ' ' || fi.rate_per_item || ' ' || fi.rate_percent ||
                ' ' || fi.per_trans_max || ' ' || fi.card_scheme  ||
                ' using: ' || fi.template_mas_code ||
                ' ' || ifp.institution_id
                );

            /*
            DELETE fee_pkg_mas_code
            WHERE mas_code      = fi.mas_code
            AND fee_pkg_id = ifp.fee_pkg_id
            and institution_id = ifp.institution_id;
            */

            insert into mas_code

            select distinct
                fir.mas_code,
                fir.card_scheme,
                substr(trim(fir.mas_desc), 1,30) mas_desc,
                null irf_prog_ind_desc
                --, mc.*
            from flmgr_interchange_rates fir left outer join mas_code mc
            on fir.mas_code = mc.mas_code
            where mc.mas_code is null;


            INSERT INTO fee_pkg_mas_code
                (
                INSTITUTION_ID,
                FEE_PKG_ID ,
                MAS_CODE ,
                CARD_SCHEME ,
                MAS_EXPECTED_FLAG
                )
            SELECT
                fpmc_l.INSTITUTION_ID ,
                fpmc_l.FEE_PKG_ID ,
                fi.mas_code,
                fpmc_l.CARD_SCHEME ,
                fpmc_l.MAS_EXPECTED_FLAG
            FROM FEE_PKG_MAS_CODE fpmc_l left outer join fee_pkg_mas_code fpmc_r
            on
                fpmc_l.INSTITUTION_ID = fpmc_r.INSTITUTION_ID
            and fpmc_l.FEE_PKG_ID     = fpmc_r.FEE_PKG_ID
            and fpmc_l.MAS_CODE       = fi.template_mas_code
            and fpmc_r.MAS_CODE       = fi.mas_code

            WHERE fpmc_l.mas_code        = fi.template_mas_code
            AND fpmc_l.fee_pkg_id = ifp.fee_pkg_id
            and fpmc_l.institution_id = ifp.institution_id
            and fpmc_r.institution_id is null

            /*
            AND fpmc_l.mas_code NOT IN
                (
                SELECT mas_code
                FROM fee_pkg_mas_code
                WHERE mas_code      = fi.mas_code
                AND fee_pkg_id = ifp.fee_pkg_id
                )
            */
            ;

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
                fi.mas_code ,
                mf_l.TID_FEE ,
                eff_date Effective_date,
                'F' FEE_STATUS ,
                fi.rate_per_item ,
                fi.rate_percent ,
                i.inst_curr_code FEE_CURR ,
                fi.card_scheme ,
                mf_l.AMT_METHOD ,
                mf_l.CNT_METHOD ,
                mf_l.ADD_AMT1_METHOD ,
                mf_l.ADD_CNT1_METHOD ,
                mf_l.ADD_AMT2_METHOD ,
                mf_l.ADD_CNT2_METHOD ,
                fi.per_trans_max ,
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
            on  i.institution_id = ifp.institution_id
            left outer join mas_fees mf_r
            on
                mf_l.INSTITUTION_ID   =  mf_r.INSTITUTION_ID
            and mf_l.FEE_PKG_ID       =  mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY     =  mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE         =  fi.template_mas_code
            and mf_r.MAS_CODE         =  fi.mas_code
            and mf_l.TID_FEE          =  mf_r.TID_FEE
            -- and mf_l.EFFECTIVE_DATE   =  mf_r.EFFECTIVE_DATE

            WHERE mf_l.mas_code      = fi.template_mas_code
            and mf_l.institution_id = ifp.institution_id
            AND mf_l.fee_pkg_id = ifp.fee_pkg_id
            and mf_r.institution_id is null
            and mf_l.FEE_STATUS in ('C','F');



            changed_rows   := changed_rows + 1;

            --row_index                    := missing_mas_codes.NEXT(row_index);
            --IF row_index                 IS NOT NULL THEN
            --    mas_code_conf_query_string := mas_code_conf_query_string || ', ';
            --END IF;

            /*
            dbms_output.put_line ('REM confirmation');
            dbms_output.put_line( 'select mas_code, count(1) ' ||
                            'from fee_pkg_mas_code ' ||
                            'where mas_code in (' );
            dbms_output.put_line(mas_code_conf_query_string);
            dbms_output.put_line( ') and fee_pkg_id in (' || ifp.fee_pkg_id ||
                            ') group by mas_code order by mas_code;' );
            dbms_output.put_line( 'select mas_code, RATE_PER_ITEM, rate_percent, ' ||
                            'per_trans_max, count(1) from mas_fees where mas_code in (' );
            dbms_output.put_line(mas_code_conf_query_string);
            dbms_output.put_line( ') and fee_pkg_id in (' || ifp.fee_pkg_id ||
                            ') group by mas_code, RATE_PER_ITEM, ' ||
                            'rate_percent, per_trans_max ' ||
                            'order by mas_code;'  );
            */
            dbms_output.disable;
            dbms_output.enable (1000000);

        end loop;
        commit;

    end loop;
    -- commit;

    dbms_output.put_line('Rows added: ' || changed_rows);

end;

-- commit;
