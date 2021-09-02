REM

REM $Id: 9_2_fpmc_patching.sql 38 2019-10-16 02:43:28Z bjones $

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
            from fee_pkg_mas_code fpm_l left outer join fee_pkg_mas_code fpm_r
            on  fpm_l.institution_id   = src.inst
            and fpm_r.institution_id   = dest.inst
            and fpm_l.fee_pkg_id  = fpm_r.fee_pkg_id
            and fpm_l.mas_code = fpm_r.mas_code
            where
                fpm_l.institution_id   = src.inst
            and fpm_r.mas_code is null
            and fpm_l.fee_pkg_id < 100
            ;

            --/*
            insert into fee_pkg_mas_code
            select
                    dest.inst as INSTITUTION_ID
                ,   fpm_l.FEE_PKG_ID
                ,   fpm_l.MAS_CODE
                ,   fpm_l.CARD_SCHEME
                ,   fpm_l.MAS_EXPECTED_FLAG
            from fee_pkg_mas_code fpm_l left outer join fee_pkg_mas_code fpm_r
            on  fpm_l.institution_id   = src.inst
            and fpm_r.institution_id   = dest.inst
            and fpm_l.fee_pkg_id  = fpm_r.fee_pkg_id
            and  fpm_l.mas_code   = fpm_r.mas_code
            where
                fpm_l.institution_id   = src.inst
            and fpm_r.mas_code is null
            and fpm_l.fee_pkg_id < 100
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
