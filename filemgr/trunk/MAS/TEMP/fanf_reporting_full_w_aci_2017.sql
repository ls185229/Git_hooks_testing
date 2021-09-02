
REM $Id: fanf_reporting_full_by_tin_2015.sql 3920 2016-10-24 21:58:03Z bjones $

set verify off

define qtr_var             = 4
define year_var            = 2016
define inst_var            = "'101', '107', 'ACI'"
define inst_var            = "'ACI'"
define mth_1               = "'01-Oct-16'"
define mth_2               = "'01-Nov-16'"
define mth_3               = "'01-Dec-16'"

prompt
prompt year: &year_var, qtr: &qtr_var
prompt

select distinct month_requested
from fanf_history
where 1=1
and month_requested
    between
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
 order by 1
 ;


select
    tbl,
    tier,
     low_end,
     high_end,
    sum(M_1_Tin  ) M_1_Tin   ,
    sum(M_1_loc  ) M_1_loc   ,
    sum(M_1_sales) M_1_sales ,
    sum(M_2_Tin  ) M_2_Tin   ,
    sum(M_2_loc  ) M_2_loc   ,
    sum(M_2_sales) M_2_sales ,
    sum(M_3_Tin  ) M_3_Tin   ,
    sum(M_3_loc  ) M_3_loc   ,
    sum(M_3_sales) M_3_sales ,
    sum(qtr_sales) qtr_sales ,
    FANF_Amt,
    sum(loc_cnt) loc_cnt,
    sum(Fee) Fee
--    ,
--    tax_id
from (



select
    ft.tbl,
    ft.tier,
    ft.locations_min low_end,
    ft.locations_max high_end,
    fh.tax_id,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id        end) M_1_Tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id     end) M_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cp_amt,0) end) M_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id        end) M_2_Tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id     end) M_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cp_amt,0) end) M_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id        end) M_3_Tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id     end) M_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cp_amt,0) end) M_3_sales ,
    sum(                                                      nvl(fh.cp_amt,0)    ) qtr_sales ,
    ft.fee FANF_Amt,
    sum(case when fh.tax_id is null then 0 else 1      end) loc_cnt,
    ft.fee * sum(case when fh.tax_id is null then 0 else 1      end) Fee
    ,
    min(fh.tax_id) min_tin,
    max(fh.tax_id) max_tin,
    min(fh.month_requested) min_mth,
    max(fh.month_requested) max_mth

from fanf_history fh right outer join fanf_table ft on fh.table_1_tier = ft.tier and fh.table_1 = ft.tbl
where 1=1
and ft.tbl = '1A'
and
    (fh.month_requested
        between
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
        and fh.institution_id in (&inst_var)
    )
or fh.tax_id is null
group by
    ft.tbl,
    ft.tier,
    ft.locations_min,
    ft.locations_max,
    fh.tax_id,
    ft.fee

union


select
    ft.tbl,
    ft.tier,
    ft.locations_min low_end,
    ft.locations_max high_end,
    fh.tax_id,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id        end) M_1_Tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id     end) M_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cp_amt,0) end) M_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id        end) M_2_Tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id     end) M_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cp_amt,0) end) M_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id        end) M_3_Tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id     end) M_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cp_amt,0) end) M_3_sales ,
    sum(                                                      nvl(fh.cp_amt,0)    ) qtr_sales ,
    ft.fee FANF_Amt,
    sum(case when fh.tax_id is null then 0 else 1      end) loc_cnt,
    ft.fee * sum(case when fh.tax_id is null then 0 else 1      end) Fee
    ,
    min(fh.tax_id) min_tin,
    max(fh.tax_id) max_tin,
    min(fh.month_requested) min_mth,
    max(fh.month_requested) max_mth

from fanf_history fh right outer join fanf_table ft on fh.table_1_tier = ft.tier and fh.table_1 = ft.tbl
where 1=1
and ft.tbl = '1B'
and
    (fh.month_requested
    between
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
    and fh.institution_id in (&inst_var)
    )
or fh.tax_id is null
group by
    ft.tbl,
    ft.tier,
    ft.locations_min,
    ft.locations_max,
    fh.tax_id,
    ft.fee

union


(
select
    ft.tbl,
    ft.tier,
    ft.sales_min low_end,
    ft.sales_max high_end,
    fh.tax_id,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id         end) M_1_Tin   ,
    0                                                                                M_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cnp_amt,0) end) M_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id         end) M_2_Tin   ,
    0                                                                                M_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cnp_amt,0) end) M_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id         end) M_3_Tin   ,
    0                                                                                M_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cnp_amt,0) end) M_3_sales ,
    sum(                                                      nvl(fh.cnp_amt,0)    ) qtr_sales ,
    ft.fee                                                    FANF_Amt,
    count(distinct fh.month_requested || fh.tax_id          ) loc_cnt,
    ft.fee * count(distinct fh.month_requested || fh.tax_id ) Fee
    ,
    min(fh.tax_id) min_tin,
    max(fh.tax_id) max_tin,
    min(fh.month_requested) min_mth,
    max(fh.month_requested) max_mth


from fanf_table ft left outer join fanf_history fh on ft.tbl = '2' and fh.table_2_tier = ft.tier
where 1=1
and ft.tbl = '2'
--and ft.sales_min is not null
and ft.fee is not null
and
(
    (fh.month_requested
        between
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
    and fh.institution_id in (&inst_var)
    )
or fh.tax_id is null
)

group by
    ft.tbl,
    ft.tier,
    ft.sales_min,
    ft.sales_max,
    fh.tax_id,
    ft.fee
--having ft.sales_min is not null
    )


)
group by
    rollup(
    tbl,
    tier,
    low_end,
    high_end,
    FANF_Amt
    --,
    --tax_id
    )
having FANF_Amt is not null
or (
    tier is null
    and
    low_end is null
    and
    high_end is null)


order by tbl, 2, 3, 4, 5
 ;
