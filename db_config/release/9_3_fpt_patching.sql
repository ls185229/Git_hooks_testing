REM

REM $Id: 9_3_fpt_patching.sql 38 2019-10-16 02:43:28Z bjones $

SET TIMING ON;
set serveroutput on ;
-- format wrapped;

declare

    cursor inst_dest is
        select
            institution_id inst
        from masclr.institution
        where
          institution_id in ('122')
          --institution_id in ('101', '105', '107', '121')
          ---institution_id between '127' and '135'
        ;

    cursor inst_src is
        select
            institution_id inst
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
            from fee_pkg_tid fpt_l left outer join fee_pkg_tid fpt_r
            on  fpt_l.institution_id   = src.inst
            and fpt_r.institution_id   = dest.inst
            and fpt_l.fee_pkg_id  = fpt_r.fee_pkg_id
            and fpt_l.tid_activity = fpt_r.tid_activity
            where
                fpt_l.institution_id   = src.inst
            and fpt_r.tid_activity is null
            and fpt_l.fee_pkg_id < 100
            ;

            --/*
            insert into fee_pkg_tid
            select
                    dest.inst as institution_id
                ,   fpt_l.fee_pkg_id
                ,   fpt_l.tid_activity
            from fee_pkg_tid fpt_l left outer join fee_pkg_tid fpt_r
            on  fpt_l.institution_id   = src.inst
            and fpt_r.institution_id   = dest.inst
            and fpt_l.fee_pkg_id  = fpt_r.fee_pkg_id
            and  fpt_l.tid_activity   = fpt_r.tid_activity
            where
                fpt_l.institution_id   = src.inst
            and fpt_r.tid_activity is null
            and fpt_l.fee_pkg_id < 100
            ;
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
