
select 'Start', to_char(sysdate, 'DD-MON-YY HH24:MI:SS') now from dual;


variable start_date varchar2(12)
variable stop_date varchar2(12)
variable inst varchar2(10)

exec :start_date := to_char(trunc(sysdate,'MM'), 'DD-MON-YYYY')

exec :start_date := '01-jul-2019'
exec :inst := '101'

--to_char(trunc(sysdate,'MM'), 'DD-MON-YYYY')

-- exec :stop_date  := to_char(last_day(sysdate), 'DD-MON-YYYY')

/*
update fanf_history c
set c.inst_name = 'WELLS FARGO'
where c.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and c.institution_id = 'ACI'
and c.inst_name is null;
*/

update fanf_history c
set c.TABLE_1 = null,
    c.TABLE_1_TIER = null
where c.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and (c.CP_AMT <= 0 or c.cp_amt is null);

update fanf_history c
set (c.tot_cp_amt) = (
    SELECT distinct
        ( SELECT SUM(cp_amt) FROM fanf_history b
            WHERE a.tax_id = b.tax_id
            AND
                (
                  a.inst_name = b.INST_NAME
                or
                  (a.INSTITUTION_ID in (:inst) and
                   b.INSTITUTION_ID in (:inst))
                )
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cnp
        FROM fanf_history a
        WHERE a.tax_id = c.tax_id
        and
                  (
                    a.INSTITUTION_ID in (:inst)
                    and
                    c.INSTITUTION_ID in (:inst)
                    )
        AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
    )
WHERE c.cp_amt > 0

AND c.month_requested = to_date(:start_date, 'DD-MON-YYYY')

;

update fanf_history c
set (c.tot_cnp_amt) = (
    SELECT distinct
        ( SELECT SUM(cnp_amt) FROM fanf_history b
            WHERE a.tax_id = b.tax_id
            AND
                (
                  a.inst_name = b.INST_NAME
                or
                  (a.INSTITUTION_ID in (:inst) and
                   b.INSTITUTION_ID in (:inst))
                )
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cnp
        FROM fanf_history a
        WHERE a.tax_id = c.tax_id
        and
                  (
                    a.INSTITUTION_ID in (:inst)
                    and
                    c.INSTITUTION_ID in (:inst)
                    )
        AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
    )
WHERE c.tax_id = c.tax_id
AND c.month_requested = to_date(:start_date, 'DD-MON-YYYY')

;


update fanf_history  a set
    a.cp_percentage = a.tot_cp_amt / (a.tot_cp_amt + a.tot_cnp_amt) * 100.0
where a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst)
;


update fanf_history c
set (c.tot_cnp_amt) = (
    SELECT distinct
        ( SELECT SUM(cnp_amt) FROM fanf_history b
            WHERE a.tax_id = b.tax_id
            AND (a.INSTITUTION_ID in (:inst) and
                 b.INSTITUTION_ID in (:inst))
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cnp
        FROM fanf_history a
        WHERE a.tax_id = c.tax_id
        and (a.INSTITUTION_ID in (:inst) and
             c.INSTITUTION_ID in (:inst))
        AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
    )
WHERE c.tax_id = c.tax_id
AND c.month_requested = to_date(:start_date, 'DD-MON-YYYY')
;

update fanf_history a set
    a.cp_percentage = a.tot_cp_amt / (a.tot_cp_amt + a.tot_cnp_amt) * 100.0
where a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst)
;

update fanf_history a
    set a.num_of_locations = (
            select count(1) as loc_count
            from fanf_history b
            where
                a.tax_id = b.tax_id and
                --a.inst_name = b.inst_name and
                (a.INSTITUTION_ID in (:inst) and
                b.INSTITUTION_ID in (:inst)) and
                b.cp_amt > 0 and
                b.month_requested = to_date(:start_date, 'DD-MON-YYYY'))
where
    a.cp_amt > 0 and
    a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst);



/*
update fanf_history a
    set a.possible_hv_merch =  case when
        (a.default_mcc between 3000 and 3999 or
         a.default_mcc in
            ('4511', '7011', '7512', '4411', '4829', '5200', '5300', '5309', '5310',
            '5311', '5411', '5511', '5532', '5541', '5542', '5651', '5655', '5712',
            '5732', '5912', '5943', '7012', '7832'))
        then 'Y'
        else 'N' end
where
    a.month_requested = to_date(:start_date, 'DD-MON-YYYY');
*/

/*
update fanf_history a set
    a.actual_hv_merch = null
where
    a.month_requested = to_date(:start_date, 'DD-MON-YYYY');

update fanf_history a set
    a.actual_hv_merch = 'Y'
where
    a.tot_hv_cp > 0 and
    a.tot_cp_amt > 0 and
    a.cp_amt > 0 and
    (a.tot_hv_cp / a.tot_cp_amt) > .5 and
    a.month_requested = to_date(:start_date, 'DD-MON-YYYY');

update fanf_history a set
    a.table_1 =
        case when a.cp_percentage > 0 and
                    a.actual_hv_merch = 'Y' then '1A'
             when a.cp_percentage > 0 and
                    (a.actual_hv_merch <> 'Y' or
                    a.actual_hv_merch is NULL) then '1B'
             else ' ' end
where
    a.month_requested = to_date(:start_date, 'DD-MON-YYYY');
*/

update fanf_history a set
    (a.table_1_tier, a.cp_fee )   =  (
            select ft.tier, ft.fee
            from fanf_table ft
            where ft.tbl = a.table_1
            and  ft.locations_min <= a.num_of_locations
            and (ft.locations_max >= a.num_of_locations
                or ft.locations_max is null)
            )
where a.table_1 is not null
and a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst);

update fanf_history a set
    (a.table_1_tier, a.cp_fee) = (
            select ft.tier, ft.pct * a.cp_amt / 100
            from fanf_table ft
            where ft.tbl = a.table_1
            and ft.sales_min <= a.tot_cp_amt
            and ft.sales_max >= a.tot_cp_amt
            )
where a.table_1 is not null
and a.tot_cp_amt <= 1250
and a.tax_id not in (
    select distinct b.tax_id
    from fanf_history b
    join fanf_merchant m
    on b.institution_id = m.institution_id
    and b.entity_id = m.entity_id
    where m.partial_acquirer = 'Y'
    and b.institution_id = a.institution_id
    and b.entity_id = a.entity_id
    )
and a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst);


update fanf_history a set
    (a.table_2_tier, a.cnp_fee) = (
            select ft.tier,
                case
                    when pct is null then
                        case when a.cnp_amt = a.tot_cnp_amt then ft.fee
                        else
                            ft.fee * a.cnp_amt / a.tot_cnp_amt
                        end
                    else pct * a.tot_cnp_amt / 100
                end
            from fanf_table ft
            where ft.tbl = '2'
            and ft.sales_min  <= a.tot_cnp_amt
            and (ft.sales_max >= a.tot_cnp_amt
                or ft.sales_max is null)
            )
where a.tot_cnp_amt > 0
and a.month_requested = to_date(:start_date, 'DD-MON-YYYY')
and a.INSTITUTION_ID in (:inst)
;

prompt

select 'Finish', to_char(sysdate, 'DD-MON-YY HH24:MI:SS') now from dual;
select name db_name from v$database;

--commit;
