/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    $Id: fanf_process.sql 3786 2016-06-02 00:03:13Z bjones $

Origninal version: jcloud@jetpay.com

select to_date('201204', 'YYYYMM') into start_date from dual;~/MAS/
select add_months(to_date('201204', 'YYYYMM'), 1)-1 into stop_date from
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
select 'Start', to_char(sysdate, 'DD-MON-YY HH24:MI:SS') now from dual;

variable start_date varchar2(12)
variable stop_date varchar2(12)
exec :start_date := to_char(trunc(sysdate,'MM'), 'DD-MON-YY')
exec :stop_date  := to_char(last_day(sysdate), 'DD-MON-YY')

delete fanf_staging
where month_requested = to_date(:start_date, 'DD-MON-YY');

insert into fanf_staging
    (tax_id, entity_id, institution_id, default_mcc, cp_amt, cnp_amt,
    month_requested, date_of_request, inst_name, possible_hv_merch)
select a.tax_id,a.entity_id,a.institution_id,a.default_mcc,
    sum(case when v.moto_e_com_ind not in ('1','2','3','4','5','6','7','8','9') or
                   v.moto_e_com_ind is NULL
            then amt_billing else 0 end) cp_amt,
    sum(case when v.moto_e_com_ind     in ('1','2','3','4','5','6','7','8','9')
            then amt_billing else 0 end) cnp_amt,
    to_date(:start_date, 'DD-MON-YY'),
    trunc(sysdate) date_of_request,
    inst.inst_name,
    case when
        (a.default_mcc between 3000 and 3999 or
         a.default_mcc in
            ('4511', '7011', '7512', '4411', '4829', '5200', '5300', '5309', '5310',
            '5311', '5411', '5511', '5532', '5541', '5542', '5651', '5655', '5712',
            '5732', '5912', '5943', '7012', '7832'))
        then 'Y'
        else 'N' end possible_hv_merch
from mas_trans_log m
join acq_entity a
on  a.institution_id = m.institution_id
and a.entity_id = m.entity_id
join institution inst
on  m.institution_id = inst.institution_id
join in_draft_main i
on  m.external_trans_nbr = i.trans_seq_nbr
join visa_adn v
on     v.trans_seq_nbr = m.external_trans_nbr
where a.entity_status = 'A'
and m.trans_sub_seq = '0'
and m.tid like '0100030051%'
and m.tid != '010003005102'
and m.card_scheme = '04'
and m.settl_flag = 'Y'
and length(m.external_trans_nbr) <= 12
and  m.gl_date between  to_date(:start_date, 'DD-MON-YY') and
                        to_date(:stop_date , 'DD-MON-YY')
group by a.institution_id, a.entity_id, a.tax_id, a.default_mcc,
    inst.inst_name
order by a.tax_id,a.entity_id,a.institution_id,a.default_mcc;


update fanf_staging c
set (c.tot_cp_amt, c.tot_hv_cp) = (
    SELECT distinct
        ( SELECT SUM(cp_amt ) FROM fanf_staging b
            WHERE a.tax_id = b.tax_id
            AND a.inst_name = b.INST_NAME
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cp,
        ( SELECT SUM(cp_amt ) FROM fanf_staging b
            WHERE a.tax_id = b.tax_id
            AND a.inst_name = b.INST_NAME
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED
            and b.possible_hv_merch = 'Y' )             bank_hv_cp
        FROM fanf_staging a
        WHERE a.tax_id = c.tax_id
        AND a.inst_name = c.INST_NAME
        AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
    )
WHERE c.tax_id = c.tax_id
AND c.month_requested = to_date(:start_date, 'DD-MON-YY')
;

update fanf_staging c
set (c.tot_cnp_amt) = (
    SELECT distinct
        ( SELECT SUM(cnp_amt) FROM fanf_staging b
            WHERE a.tax_id = b.tax_id
            AND a.inst_name = b.INST_NAME
            AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cnp
        FROM fanf_staging a
        WHERE a.tax_id = c.tax_id
        and a.inst_name = c.inst_name
        AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
    )
WHERE c.tax_id = c.tax_id
AND c.month_requested = to_date(:start_date, 'DD-MON-YY')
;

update fanf_staging a set
    a.cp_percentage = a.tot_cp_amt / (a.tot_cp_amt + a.tot_cnp_amt) * 100.0
where a.month_requested = to_date(:start_date, 'DD-MON-YY')
;

update fanf_staging a
    set a.num_of_locations = (
            select count(1) as loc_count
            from fanf_staging b
            where
                a.tax_id = b.tax_id and
                a.inst_name = b.inst_name and
                b.cp_amt > 0 and
                b.month_requested = to_date(:start_date, 'DD-MON-YY'))
where
    a.cp_amt > 0 and
    a.month_requested = to_date(:start_date, 'DD-MON-YY');



/*
update fanf_staging a
    set a.possible_hv_merch =  case when
        (a.default_mcc between 3000 and 3999 or
         a.default_mcc in
            ('4511', '7011', '7512', '4411', '4829', '5200', '5300', '5309', '5310',
            '5311', '5411', '5511', '5532', '5541', '5542', '5651', '5655', '5712',
            '5732', '5912', '5943', '7012', '7832'))
        then 'Y'
        else 'N' end
where
    a.month_requested = to_date(:start_date, 'DD-MON-YY');
*/

update fanf_staging a set
    a.actual_hv_merch = null
where
    a.month_requested = to_date(:start_date, 'DD-MON-YY');

update fanf_staging a set
    a.actual_hv_merch = 'Y'
where
    a.tot_hv_cp > 0 and
    a.tot_cp_amt > 0 and
    a.cp_amt > 0 and
    (a.tot_hv_cp / a.tot_cp_amt) > .5 and
    a.month_requested = to_date(:start_date, 'DD-MON-YY');

update fanf_staging a set
    a.table_1 =
        case when a.cp_percentage > 0 and
                    a.actual_hv_merch = 'Y' then '1A'
             when a.cp_percentage > 0 and
                    (a.actual_hv_merch <> 'Y' or
                    a.actual_hv_merch is NULL) then '1B'
             else ' ' end
where
    a.month_requested = to_date(:start_date, 'DD-MON-YY');

update fanf_staging a set
    (a.table_1_tier, a.cp_fee )   =  (
            select ft.tier, ft.fee
            from fanf_table ft
            where ft.tbl = a.table_1
            and  ft.locations_min <= a.num_of_locations
            and (ft.locations_max >= a.num_of_locations
                or ft.locations_max is null)
            )
where a.table_1 is not null
and a.month_requested = to_date(:start_date, 'DD-MON-YY');

update fanf_staging a set
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
    from fanf_staging b
    join fanf_merchant m
    on b.institution_id = m.institution_id
    and b.entity_id = m.entity_id
    where m.partial_acquirer = 'Y'
    and b.institution_id = a.institution_id
    and b.entity_id = a.entity_id
    )
and a.month_requested = to_date(:start_date, 'DD-MON-YY');


update fanf_staging a set
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
and a.month_requested = to_date(:start_date, 'DD-MON-YY')
;

prompt

select 'Finish', to_char(sysdate, 'DD-MON-YY HH24:MI:SS') now from dual;
select name db_name from v$database;

commit;
