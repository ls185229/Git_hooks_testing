REM Update mas_code_grp rows

REM $Id: 7_0_update_mas_code_grp_plsql_2015_04.sql 17 2016-10-25 15:22:05Z bjones $

set serveroutput on size 1000000

DECLARE
  changed_rows number := 0;
  start_time varchar2(35);
  end_time varchar2(35);
  my_db varchar2(35);
  CURSOR mas_code_cursor
  IS
     SELECT distinct mas_code,
            template_mas_code
       FROM flmgr_interchange_rates
      WHERE tier IS NOT NULL and usage != 'INTERCHANGE';

  CURSOR mas_code_grp_cursor (in_template_mas_code VARCHAR2, in_mas_code varchar2)
    IS
    SELECT distinct a.institution_id   ,
            a.mas_code_grp_id  ,
            a.qualify_mas_code ,
            a.mas_code
    FROM mas_code_grp a
    WHERE a.qualify_mas_code = in_template_mas_code
    AND (a.institution_id, a.mas_code_grp_id, in_mas_code, a.mas_code) NOT IN
        (SELECT institution_id,
            mas_code_grp_id    ,
            qualify_mas_code   ,
            mas_code
        FROM mas_code_grp
        WHERE institution_id = a.institution_id
        AND mas_code_grp_id  = a.mas_code_grp_id
        AND qualify_mas_code = in_mas_code
        ) ;

  mas_code_grp_cursor_row mas_code_grp_cursor%rowtype;
  mas_code_cursor_row mas_code_cursor%rowtype;


BEGIN

    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')  into start_time from dual;
    select name into my_db from v$database;

    dbms_output.put_line('Added  '
    || 'institution_id '
    || 'mas_code_grp_id '
    || 'qualify_mas_code '
    || 'mas_code');


  FOR mas_code_cursor_row IN mas_code_cursor
  LOOP
    dbms_output.put_line(mas_code_cursor_row.mas_code ||
                    ' using ' || mas_code_cursor_row.template_mas_code ||
                    ' as template.');

    dbms_output.disable;
    dbms_output.enable (1000000);

    OPEN mas_code_grp_cursor(mas_code_cursor_row.template_mas_code,
                             mas_code_cursor_row.mas_code);
    LOOP
      FETCH mas_code_grp_cursor INTO mas_code_grp_cursor_row;
      exit when mas_code_grp_cursor%NOTFOUND ;
      -- break after 200 rows to avoid a buffer overflow in the output
           dbms_output.put_line('Added  '
     || mas_code_grp_cursor_row.INSTITUTION_ID
     || ' '
     || mas_code_grp_cursor_row.MAS_CODE_GRP_ID
     || ' '
     || mas_code_cursor_row.mas_code
     || ' '
     || mas_code_grp_cursor_row.MAS_CODE);


    /*
    open mas_code_grp_delete(mas_code_cursor_row.template_mas_code,
                             mas_code_cursor_row.mas_code);
    */
    /*
    CURSOR mas_code_grp_delete (in_template_mas_code VARCHAR2, in_mas_code varchar2)
    IS
    */

    /*
    delete mas_code_grp a
    WHERE a.qualify_mas_code = mas_code_cursor_row.template_mas_code
    and a.mas_code != mas_code_cursor_row.mas_code
    AND (a.institution_id, a.mas_code_grp_id, mas_code_cursor_row.template_mas_code) IN
        (SELECT institution_id,
            mas_code_grp_id    ,
            qualify_mas_code
        FROM mas_code_grp
        WHERE institution_id = a.institution_id
        AND mas_code_grp_id  = a.mas_code_grp_id
        AND qualify_mas_code = mas_code_cursor_row.template_mas_code
        ) ;
    */

    insert into mas_code_grp
    select
            mas_code_grp_cursor_row.INSTITUTION_ID  INSTITUTION_ID ,
            mas_code_grp_cursor_row.MAS_CODE_GRP_ID MAS_CODE_GRP_ID ,
            mas_code_cursor_row.mas_code            QUALIFY_MAS_CODE ,
            mas_code_grp_cursor_row.MAS_CODE        MAS_CODE
    from mas_code_grp mcg_l left outer join mas_code_grp  mcg_r
    on
        mcg_l.INSTITUTION_ID    =  mcg_r.INSTITUTION_ID
    and mcg_l.MAS_CODE_GRP_ID   =  mcg_r.MAS_CODE_GRP_ID
    and mcg_l.QUALIFY_MAS_CODE  =  mcg_r.QUALIFY_MAS_CODE
    where
        mcg_l.INSTITUTION_ID = mas_code_grp_cursor_row.INSTITUTION_ID
    and mcg_l.MAS_CODE_GRP_ID = mas_code_grp_cursor_row.MAS_CODE_GRP_ID
    and mcg_l.QUALIFY_MAS_CODE = mas_code_cursor_row.mas_code
    and mcg_r.institution_id is null;


    changed_rows := changed_rows + 1;


    END LOOP;
    CLOSE mas_code_grp_cursor;
    commit;
  END LOOP;
  dbms_output.put_line('Rows added: ' || changed_rows);
  commit;

    select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into end_time from dual;
    dbms_output.put_line('Started at: ' || start_time);
    dbms_output.put_line('Ended at: '   || end_time);
    dbms_output.put_line('Using database: ' || my_db);

/*
    commit;

    select sysdate from dual;
    select name from v$database;
*/
END;

