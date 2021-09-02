
REM $Id: fanf_reporting_full_by_tin_2015.sql 4747 2018-10-15 15:32:36Z bjones $

set verify off

set linesize 1000
set pagesize 500

define qtr_var             = 3
define year_var            = 2019
define inst_var            = "'121'"
define inst_var            = "'101'"
define inst_var            = "'107'"
-- define inst_var            = "'ACI'"
define mth_1               = "'01-jul-2019'"
define mth_2               = "'01-aug-2019'"
define mth_3               = "'01-sep-2019'"

prompt
prompt year: &year_var, qtr: &qtr_var
prompt

select distinct month_requested
from fanf_history
where 1=1
and month_requested
    between
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3))
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3)) - 1
order by 1
;


select distinct
    &inst_var
                   "Inst"      ,
    tbl            "Tbl"       ,
    tier           "Tier"      ,
    low_end        "Low End"   ,
    high_end       "High End"  ,
    null ".",
    sum(M_1_Tin  ) "M 1 Tin"   ,
    sum(M_1_loc  ) "M 1 Loc"   ,
    sum(M_1_sales) "M 1 Sales" ,
    null "..",
    sum(M_2_Tin  ) "M 2 Tin"   ,
    sum(M_2_loc  ) "M 2 Loc"   ,
    sum(M_2_sales) "M 2 Sales" ,
    null "...",
    sum(M_3_Tin  ) "M 3 Tin"   ,
    sum(M_3_loc  ) "M 3 Loc"   ,
    sum(M_3_sales) "M 3 Sales" ,
    null                                        "....",
    sum(qtr_sales) "Qtr Sales" ,
    FANF_Amt       
                   "Fanf Amt"  ,
    --FANF_Pct_Amt   "Fanf Pct"  ,
    sum(loc_cnt)   "Loc Cnt"   ,
    sum(Fee)       "Fee"       ,
    sum(aci_fee )  "ACI"       ,
    sum(jtpy_fee)  "JTPY TX"   ,
    sum(nvl(aci_fee, 0)    +
        nvl(jtpy_fee, 0))  "Ttl Fee"
    --,
    --tax_id         "Tax Id"
from (



select 
    --fh.institution_id                                                             inst,
    ft.tbl                                                                          tbl  ,
    ft.tier                                                                         tier ,
    ft.locations_min                                                                low_end,
    ft.locations_max                                                                high_end,
    fh.tax_id                                                                       tax_id ,
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
    ft.fee                                                                          FANF_Amt,
    ft.pct                                                                          FANF_Pct_Amt,
    sum(case when fh.tax_id is null then 0 else 1      end)                         loc_cnt,
    sum(
        case when ft.pct is not null then
            ft.pct / 100 * nvl(fh.cnp_amt, 0)
            else
            ft.fee * case when fh.tax_id is null then 0 else 1      end
        end
    )
                                                                                    Fee,
    min(fh.tax_id)                                                                  min_tin,
    max(fh.tax_id)                                                                  max_tin,
    min(fh.month_requested)                                                         min_mth,
    max(fh.month_requested)                                                         max_mth,
    sum(case when fh.institution_id  = 'ACI' then fh.cp_fee end)                    aci_fee,
    sum(case when fh.institution_id != 'ACI' then fh.cp_fee end)                    jtpy_fee

from fanf_history fh 
right outer join fanf_table ft 
on fh.table_1_tier = ft.tier 
and fh.table_1 = ft.tbl
and (fh.month_requested
        between
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3))
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3)) - 1
    and fh.institution_id in (&inst_var)
    )
where ft.tbl = '1A'

group by
    --fh.institution_id,
    ft.tbl,
    ft.tier,
    ft.locations_min,
    ft.locations_max,
    fh.tax_id,
    ft.fee,
    ft.pct

union


select
    --fh.institution_id                                                               inst,
    ft.tbl                                                                          tbl ,
    ft.tier                                                                         tier ,
    ft.locations_min                                                                low_end,
    ft.locations_max                                                                high_end,
    fh.tax_id                                                                       tax_id ,
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
    ft.fee                                                                          FANF_Amt,
    ft.pct                                                                          FANF_Pct_Amt,
    sum(case when fh.tax_id is null then 0 else 1      end)                         loc_cnt,
    sum(
        case when ft.pct is not null then
            ft.pct / 100 * nvl(fh.cnp_amt, 0)
            else
            ft.fee * case when fh.tax_id is null then 0 else 1      end
        end
    )
                                                                                    Fee,
    min(fh.tax_id)                                                                  min_tin,
    max(fh.tax_id)                                                                  max_tin,
    min(fh.month_requested)                                                         min_mth,
    max(fh.month_requested)                                                         max_mth,
    sum(case when fh.institution_id  = 'ACI' then fh.cp_fee end)                    aci_fee,
    sum(case when fh.institution_id != 'ACI' then fh.cp_fee end)                    jtpy_fee

from fanf_history fh 
right outer join fanf_table ft 
on fh.table_1_tier = ft.tier 
and fh.table_1 = ft.tbl
and (fh.month_requested
    between
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3))
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3)) - 1
    and fh.institution_id in (&inst_var)
    )
where ft.tbl = '1B'

group by
    --fh.institution_id,
    ft.tbl,
    ft.tier,
    ft.locations_min,
    ft.locations_max,
    fh.tax_id,
    ft.fee,
    ft.pct

union


(
select
    --fh.institution_id                                                               inst,
    ft.tbl,
    ft.tier,
    ft.sales_min low_end,
    ft.sales_max high_end,
    fh.tax_id,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id         end)    M_1_Tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id      end)    M_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cnp_amt,0) end)    M_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id         end)    M_2_Tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id      end)    M_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cnp_amt,0) end)    M_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id         end)    M_3_Tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id      end)    M_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cnp_amt,0) end)    M_3_sales ,
    sum(                                                      nvl(fh.cnp_amt,0)    )    qtr_sales ,
    ft.fee                                                                              FANF_Amt,
    ft.pct                                                                              FANF_Pct_Amt,
    count(distinct fh.month_requested || fh.tax_id          )                           loc_cnt,
    ft.fee * count(distinct fh.month_requested || fh.tax_id )                           Fee
    ,
    min(fh.tax_id)                                                                      min_tin,
    max(fh.tax_id)                                                                      max_tin,
    min(fh.month_requested)                                                             min_mth,
    max(fh.month_requested)                                                             max_mth,
    sum(case when fh.institution_id  = 'ACI' then fh.cnp_fee end)                       aci_fee,
    sum(case when fh.institution_id != 'ACI' then fh.cnp_fee end)                       jtpy_fee

from fanf_history fh 
right outer join fanf_table ft 
on ft.tbl = '2' 
and fh.table_2_tier = ft.tier
and (fh.month_requested
        between
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3))
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3)) - 1
    and fh.institution_id in (&inst_var)
    )
where ft.tbl = '2'
and ft.fee is not null

group by
    --fh.institution_id,
    ft.tbl,
    ft.tier,
    ft.sales_min,
    ft.sales_max,
    fh.tax_id,
    ft.fee,
    ft.pct
--having ft.sales_min is not null
    )


)
group by
    rollup(
    tbl,
    tier,
    --inst,
    low_end,
    high_end,
    Fanf_Amt
    --,
    --FANF_Pct_Amt
    --,
    --tax_id
    )
having
    (
    Fanf_Amt is not null
    and
        (
        low_end is not null
        or
        tier is not null
        or
        sum(qtr_sales) != 0
        )
    )

--/*
or (
    tier is null
    --and
    --(low_end is null)
    --and
    --(high_end is null)
)
--*/


order by
    tbl,
    tier
    --,
    --inst
    --,
    --tax_id
 ;
