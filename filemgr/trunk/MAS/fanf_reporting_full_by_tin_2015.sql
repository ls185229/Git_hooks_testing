REM $Id: fanf_reporting_full_by_tin_2015.sql 4822 2019-03-11 16:47:43Z bjones $

set verify off
set linesize 1000
set pagesize 500

define qtr_var             = 4
define year_var            = 2018
define inst_var            = "'107'"
define mth_1               = "'01-oct-2018'"
define mth_2               = "'01-nov-2018'"
define mth_3               = "'01-dec-2018'"

prompt
prompt year: &year_var, qtr: &qtr_var

select distinct month_requested
from fanf_history
where month_requested
    between
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3))
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3)) - 1
order by 1
;

select
    &inst_var
                                                "Inst"      ,
    tbl                                         "Tbl"       ,
    tier                                        "Tier"      ,
    low_end                                     "Low End"   ,
    high_end                                    "High End"  ,
    null                                        ".",
    sum(M_1_Tin  )                              "M 1 Tin"   ,
    sum(M_1_loc  )                              "M 1 Loc"   ,
    sum(M_1_sales)                              "M 1 Sales" ,
    null                                        "..",
    sum(M_2_Tin  )                              "M 2 Tin"   ,
    sum(M_2_loc  )                              "M 2 Loc"   ,
    sum(M_2_sales)                              "M 2 Sales" ,
    null                                        "...",
    sum(M_3_Tin  )                              "M 3 Tin"   ,
    sum(M_3_loc  )                              "M 3 Loc"   ,
    sum(M_3_sales)                              "M 3 Sales" ,
    null                                        "....",
    sum(qtr_sales)                              "Qtr Sales" ,
    FANF_Amt                                    "Fanf Amt"  ,
    sum(loc_cnt)                                "Loc Cnt"   ,
    sum(case 
        when fee_pct is null then Fee 
                             else fee_pct
        end)                                    "Fee"       ,
    sum(aci_fee )                               "ACI"       ,
    sum(jtpy_fee)                               "JTPY TX"   ,
    sum(nvl(aci_fee, 0) + nvl(jtpy_fee, 0))     "Ttl Fee"
    --,
    --tax_id         "Tax Id"
from (

select
    --fh.institution_id                                                               inst,
    ft.tbl                                                                          tbl  ,
    ft.tier                                                                         tier ,
    ft.locations_min                                                                low_end,
    ft.locations_max                                                                high_end,
    fh.tax_id                                                                       tax_id ,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id        end) m_1_tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id     end) m_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cp_amt,0) end) m_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id        end) m_2_tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id     end) m_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cp_amt,0) end) m_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id        end) m_3_tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id     end) m_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cp_amt,0) end) m_3_sales ,
    sum(                                                      nvl(fh.cp_amt,0)    ) qtr_sales ,
    ft.fee                                                                          fanf_amt,
    sum(case when fh.tax_id is null then 0 else 1      end)                         loc_cnt,
    sum(case when ft.pct is not null then
            ft.pct / 100 * nvl(fh.cp_amt, 0)
            else
            ft.fee * case when fh.tax_id is null then 0 else 1      end
        end
    )                                                                               fee,
    null                                                                            fee_pct,
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
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
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
    ft.fee

union

select
    --fh.institution_id                                                               inst,
    ft.tbl                                                                          tbl ,
    ft.tier                                                                         tier ,
    ft.locations_min                                                                low_end,
    ft.locations_max                                                                high_end,
    fh.tax_id                                                                       tax_id ,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id        end) m_1_tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id     end) m_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cp_amt,0) end) m_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id        end) m_2_tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id     end) m_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cp_amt,0) end) m_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id        end) m_3_tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id     end) m_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cp_amt,0) end) m_3_sales ,
    sum(                                                      nvl(fh.cp_amt,0)    ) qtr_sales ,
    ft.fee                                                                          fanf_amt,
    sum(case when fh.tax_id is null then 0 else 1      end)                         loc_cnt,
    sum(case when ft.pct is not null then
            ft.pct / 100 * nvl(fh.cp_amt, 0)
            else
            ft.fee * case when fh.tax_id is null then 0 else 1      end
        end
    )                                                                               fee,
    null                                                                            fee_pct,   
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
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
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
    ft.fee

union

(
select
    --fh.institution_id                                                               inst,
    ft.tbl,
    ft.tier,
    ft.sales_min low_end,
    ft.sales_max high_end,
    fh.tax_id,
    count(distinct case when fh.month_requested = &mth_1 then fh.tax_id         end)    m_1_tin   ,
    count(distinct case when fh.month_requested = &mth_1 then fh.entity_id      end)    m_1_loc   ,
    sum(           case when fh.month_requested = &mth_1 then nvl(fh.cnp_amt,0) end)    m_1_sales ,
    count(distinct case when fh.month_requested = &mth_2 then fh.tax_id         end)    m_2_tin   ,
    count(distinct case when fh.month_requested = &mth_2 then fh.entity_id      end)    m_2_loc   ,
    sum(           case when fh.month_requested = &mth_2 then nvl(fh.cnp_amt,0) end)    m_2_sales ,
    count(distinct case when fh.month_requested = &mth_3 then fh.tax_id         end)    m_3_tin   ,
    count(distinct case when fh.month_requested = &mth_3 then fh.entity_id      end)    m_3_loc   ,
    sum(           case when fh.month_requested = &mth_3 then nvl(fh.cnp_amt,0) end)    m_3_sales ,
    sum(                                                      nvl(fh.cnp_amt,0)    )    qtr_sales ,
    ft.fee                                                                              fanf_amt,
    count(distinct fh.month_requested || fh.tax_id          )                           loc_cnt,
    ft.fee * count(distinct fh.month_requested || fh.tax_id )                           fee,
    sum(case when ft.pct is not null then
            ft.pct / 100 * nvl(fh.cp_amt, 0)
        end)                                                                            fee_pct,
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
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var - 1) * 3) )
        and
            add_months(trunc(to_date(&year_var, 'YYYY'), 'YY'), ((&qtr_var)     * 3) ) - 1
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
    ft.fee
)    

)
group by
    rollup(
    tbl,
    tier,
    --inst,
    low_end,
    high_end,
    FANF_Amt
    --,
    --tax_id
    )
having (
    FANF_Amt is not null
    and (
        low_end is not null
        or (tier is not null and tbl = '1A')
        or (tier is not null and tbl = '1B')
    )
)
or tier is null

order by
    tbl,
    tier
    --,
    --inst
    --,
    --tax_id
;
