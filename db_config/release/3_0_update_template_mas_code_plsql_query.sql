REM

REM $Id: 3_0_update_template_mas_code_plsql_query.sql 17 2016-10-25 15:22:05Z bjones $

-- set serveroutput on;

-- declare
--     cursor cur_usage is
         select distinct usage, card_scheme, count(*) cnt
         from flmgr_interchange_rates
         where card_scheme not in ('02')
         and usage not in ('INTERCHANGE', 'DEFAULT_DISCOUNT')
         group by  usage, card_scheme;
--
--     idx number := 0;
--     usage_cnt number;
--     total_cnt number := 0 ;
--     DB varchar(20);
--     start_time varchar(40);
--     finish_time varchar(40);
--
-- begin
--     dbms_output.put_line (' ');
--     select name into DB from v$database ;
--     select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into start_time from dual;
--     dbms_output.put_line ('Database:' || DB || ' at:' || start_time );
--
--     for c_u in cur_usage
--     loop
--         idx := idx + 1;
--
        select count(*) cnt
--             into usage_cnt
        from flmgr_interchange_rates fir_l
        join
            (select distinct usage, card_scheme, count(*) cnt
             from flmgr_interchange_rates
             where card_scheme not in ('02')
             and usage not in ('INTERCHANGE')
             group by  usage, card_scheme) c_u
        on c_u.card_scheme = fir_l.card_scheme
        left join flmgr_interchange_rates fir_r
        on
            fir_l.mas_code  = fir_r.mas_code
        and fir_l.usage     = 'INTERCHANGE'
        and fir_r.usage     = c_u.usage
        and fir_r.card_scheme = c_u.card_scheme
--
        where fir_l.usage = 'INTERCHANGE'
        and fir_l.card_scheme != '02'
         --and fir_l.card_scheme is null
        and fir_r.usage is null
        ;
--
--         insert into flmgr_interchange_rates
        select
            fir_l.mas_code,
            fir_l.mas_desc,
            fir_l.tier,
            null rate_percent,
            null rate_per_item,
            null per_trans_max,
            fir_l.fpi_ird,
            fir_l.program,
            fir_l.program_desc,
            fir_l.association_updated,
            fir_l.retire,
            null database_updated,
            fir_l.card_scheme,
            case
                when fir_l.template_mas_code is null then null
                when fir_l.template_mas_code is not null then
                    substr(fir_l.template_mas_code,1, length(fir_l.template_mas_code)-13) ||
                    case c_u.usage
                        when 'DEFAULT_DISCOUNT'    then 'JP'

                        when 'CHECK_CARD_DISCOUNT' then 'CC'
                        when 'JP_MOBILE_DISCOUNT'  then 'JPMOBI'
                        when 'NETSECURE_DISCOUNT'  then 'NS'
                        -- when 'REVTRAK_DISCOUNT'    then 'RT'
                        when 'TFOCUSPAY_DISCOUNT'  then 'TFP'
                    end ||
                    substr(fir_l.template_mas_code,length(fir_l.template_mas_code)-10, 10) || fir_l.tier
                end
            template_mas_code,
            fir_l.notes,
            null per_trans_min,
            c_u.usage usage
            ,
            fir_l.curr_cd
            ,
            fir_r.*
            ,
            c_u.*

        from flmgr_interchange_rates fir_l
        join
            (select distinct usage, card_scheme, count(*) cnt
             from flmgr_interchange_rates
             where card_scheme not in ('02')
             and usage not in ('INTERCHANGE')
             group by  usage, card_scheme) c_u
        on c_u.card_scheme = fir_l.card_scheme
        left join flmgr_interchange_rates fir_r
        on
            fir_l.mas_code  = fir_r.mas_code
        and fir_l.usage     = 'INTERCHANGE'
        and fir_r.usage     = c_u.usage
        and fir_r.card_scheme = c_u.card_scheme
--
        where fir_l.usage = 'INTERCHANGE'
        and fir_l.card_scheme != '02'
         --and fir_l.card_scheme is null
        and fir_r.usage is null
        ;
--         dbms_output.put_line ('Usage:' || c_u.usage || ' ' || c_u.card_scheme ||
--
--                             ' rows to add: ' || usage_cnt);
--         total_cnt := total_cnt + usage_cnt;
--         /* commit; */
--
--     end loop;
--     dbms_output.put_line ('Usage / Card rows:' || idx || ' rows added:' || total_cnt );
--     commit;
--
--     select  to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') into finish_time from dual;
--     dbms_output.put_line ('Database:' || DB || ' at:' || finish_time );
--     dbms_output.put_line (' ');
--
-- end;
--
-- /* commit; */


/*
    case substr(template_mas_code, 1, length(template_mas_code) - 1)
        when 'DISC_JP_BASE_TIER' then fir_l.template_mas_code
    end

    CHECK_CARD_DISCOUNT
    DEFAULT_DISCOUNT
    INTERCHANGE
    JP_MOBILE_DISCOUNT
    NETSECURE_DISCOUNT
    -- REVTRAK_DISCOUNT
    TFOCUSPAY_DISCOUNT


*/
