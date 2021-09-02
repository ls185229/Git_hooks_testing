REM Update rates in interchange fee packages

REM $Id: 7_5_update_rates_2015_04.sql 17 2016-10-25 15:22:05Z bjones $

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
        AND usage = 'INTERCHANGE'
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
        AND mas_code       = in_mas_code
        AND (rate_per_item != in_rate_per_item
        or rate_percent  != in_rate_percent
        or per_trans_max != in_per_trans_max
        or (per_trans_max is null and in_per_trans_max is not null)
        );

    mas_code_cursor_row mas_code_cursor%rowtype;
    mas_fees_check_cursor_row mas_fees_check_cursor%rowtype;

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
        FETCH mas_fees_check_cursor INTO mas_fees_check_cursor_row;
        EXIT WHEN mas_fees_check_cursor%NOTFOUND ;

        if mas_fees_check_cursor_row.tid_activity = '010003015101'
        then
            dbms_output.put_line('Changing '
                || mas_fees_check_cursor_row.institution_id || ' '
                || mas_fees_check_cursor_row.fee_pkg_id || ' '
                || mas_fees_check_cursor_row.mas_code || ' '
                || mas_fees_check_cursor_row.tid_activity || ' '
                || mas_fees_check_cursor_row.tid_fee
                || ' to '
                || mas_code_cursor_row.rate_per_item || ' '
                || mas_code_cursor_row.rate_percent || ' '
                || mas_code_cursor_row.per_trans_max
                || ' from '
                || mas_fees_check_cursor_row.rate_per_item || ' '
                || mas_fees_check_cursor_row.rate_percent || ' '
                || mas_fees_check_cursor_row.per_trans_max);
        end if;

        --/*
        update mas_fees
        set   rate_per_item = mas_code_cursor_row.rate_per_item,
                rate_percent = mas_code_cursor_row.rate_percent,
                per_trans_max = mas_code_cursor_row.per_trans_max
        where institution_id = mas_fees_check_cursor_row.institution_id
        and fee_pkg_id = mas_fees_check_cursor_row.fee_pkg_id
        and tid_activity = mas_fees_check_cursor_row.tid_activity
        and tid_fee = mas_fees_check_cursor_row.tid_fee
        and mas_code = mas_fees_check_cursor_row.mas_code;
        --*/

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
