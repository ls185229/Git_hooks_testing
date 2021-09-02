
REM $Id: fanf_report_queries.sql 3537 2015-10-12 19:04:52Z bjones $

set verify off

define qtr_var             = 2
define year_var            = 2014
define inst_var            = "'101', '107'"

prompt
prompt year: &year_var, qtr: &qtr_var
prompt

select distinct month_requested
from fanf_history
where month_requested
    between add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var-1)*3))
    and     add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var  )*3))-1
order by month_requested ;

select
    'Table 1a' tbl,
    ft.tier,
    ft.fee fee,
    sum(case when fh.tax_id is null then 0 else ft.fee end) ttl_tier,
    sum(case when fh.tax_id is null then 0 else 1      end) cnt,
    sum(fh.cp_fee) ttl_fee,
    fh.month_requested,
    count(distinct fh.tax_id) tin_cnt,
    count(distinct fh.entity_id) locations,
    sum(nvl(fh.cp_amt,0)) sales_vol
    --,
    --fh.tax_id
from fanf_table_1a ft left outer join fanf_history fh
on fh.table_1_tier = ft.tier
and fh.table_1 = 'A'
and fh.month_requested
    between add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var-1)*3))
    and     add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var  )*3))-1
and fh.institution_id in (&inst_var)
--where 1=1
--or fh.tax_id is null
group by
    'Table 1a',
    ft.tier,
    fh.month_requested ,
    ft.fee
    --,
    --fh.tax_id
/* order by tbl, fanf_table_1a.tier, fh.table_1_tier, fh.month_requested  ; */
union

select
    'Table 1b' tbl,
    ft.tier,
    ft.fee fee,
    sum(case when fh.tax_id is null then 0 else ft.fee end) ttl_tier,
    sum(case when fh.tax_id is null then 0 else 1      end) cnt,
    sum(fh.cp_fee) ttl_fee,
    fh.month_requested,
    count(distinct fh.tax_id) tin_cnt,
    count(distinct fh.entity_id) locations,
    sum(nvl(fh.cp_amt,0)) sales_vol
from  fanf_table_1b ft left outer join fanf_history fh
on fh.table_1_tier = ft.tier
and fh.table_1 = 'B'
and fh.month_requested
    between add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var-1)*3))
    and     add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var  )*3))-1
and fh.institution_id in (&inst_var)
--where 1=1
--or fh.tax_id is null
 group by
    'Table 1b',
    ft.tier,
    fh.month_requested ,
    ft.fee
/*order by tbl, month_requested, table_1_tier ; */
 union

select
    'Table 2' tbl,
    ft.tier,
    ft.fee fee,
    count(distinct fh.tax_id) * ft.fee  ttl_tier,
    sum(case when fh.tax_id is null then 0 else 1      end) cnt,
    sum(fh.cnp_fee) ttl_fee,
    fh.month_requested,
    count(distinct fh.tax_id) tin_cnt,
    null,
    sum(nvl(fh.cnp_amt,0)) sales_vol
from fanf_table_2 ft left outer join fanf_history fh
on fh.table_2_tier = ft.tier
and fh.table_2 = 'Y'
and fh.month_requested
    between add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var-1)*3))
    and     add_months(trunc(to_date(&year_var,'YYYY'),'YY'), ((&qtr_var  )*3))-1
and fh.institution_id in (&inst_var)
--where 1=1
--or fh.tax_id is null

group by
    'Table 2',
    ft.tier,
    fh.month_requested ,
    ft.fee
order by tbl, tier, month_requested
 ;
