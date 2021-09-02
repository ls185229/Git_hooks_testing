
REM $Id: fanf_report_schedule_m_2015.sql 4906 2019-10-15 14:13:32Z bjones $

variable entity_id varchar2(30)
exec :entity_id := ''

variable qtr_var  varchar2(2)
variable year_var varchar2(4)
variable inst1_var varchar2(20)
variable inst2_var varchar2(20)
variable inst3_var varchar2(20)
variable inst4_var varchar2(20)
variable inst5_var varchar2(20)
variable mth_1    varchar2(20)
variable mth_2    varchar2(20)
variable mth_3    varchar2(20)

exec :qtr_var             := 3
exec :year_var            := 2019
exec :inst1_var           := '121'
exec :inst2_var           := ''
exec :inst3_var           := ''
--exec :inst1_var           := '101'
--exec :inst2_var           := '107'
--exec :inst3_var           := 'ACI'
exec :inst4_var           := ''
exec :inst5_var           := ''
exec :mth_1               := '01-jul-2019'
exec :mth_2               := '01-aug-2019'
exec :mth_3               := '01-sep-2019'

-- sqlplus
--set verify off
--define arn_var            = "''"
--select * from in_draft_main where idm.arn in (&arn_var) ;


--set verify off

--define qtr_var             = 4
--define year_var            = 2014
--define inst_var            = "'101', '107'"
--define mth_1               = "'01-oct-14'"
--define mth_2               = "'01-nov-14'"
--define mth_3               = "'01-dec-14'"

prompt
select :year_var yr,  :qtr_var qtr from dual;
prompt

select distinct month_requested
from fanf_history
where 1=1
and month_requested
    between
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var)     * 3) ) - 1
 order by 1
 ;

select
    'SCHDM' Record_type,
    ' ' action_code,
    ' ' Business_id,
    :year_var || :qtr_var year_quarter,
    'A' Certificate_type,
    '1a' table_type,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier1_mon1_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.entity_id end)     tier1_mon1_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier1_mon1_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier1_mon2_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.entity_id end)     tier1_mon2_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier1_mon2_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier1_mon3_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.entity_id end)     tier1_mon3_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier1_mon3_vol

,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier2_mon1_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.entity_id end)     tier2_mon1_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier2_mon1_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier2_mon2_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.entity_id end)     tier2_mon2_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier2_mon2_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier2_mon3_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.entity_id end)     tier2_mon3_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier2_mon3_vol

,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier3_mon1_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.entity_id end)     tier3_mon1_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier3_mon1_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier3_mon2_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.entity_id end)     tier3_mon2_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier3_mon2_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier3_mon3_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.entity_id end)     tier3_mon3_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier3_mon3_vol

,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier4_mon1_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.entity_id end)     tier4_mon1_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier4_mon1_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier4_mon2_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.entity_id end)     tier4_mon2_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier4_mon2_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier4_mon3_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.entity_id end)     tier4_mon3_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier4_mon3_vol

,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier5_mon1_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.entity_id end)     tier5_mon1_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier5_mon1_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier5_mon2_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.entity_id end)     tier5_mon2_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier5_mon2_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier5_mon3_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.entity_id end)     tier5_mon3_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier5_mon3_vol

,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier6_mon1_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.entity_id end)     tier6_mon1_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier6_mon1_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier6_mon2_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.entity_id end)     tier6_mon2_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier6_mon2_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier6_mon3_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.entity_id end)     tier6_mon3_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier6_mon3_vol

,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier7_mon1_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.entity_id end)     tier7_mon1_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier7_mon1_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier7_mon2_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.entity_id end)     tier7_mon2_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier7_mon2_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier7_mon3_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.entity_id end)     tier7_mon3_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier7_mon3_vol

,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier8_mon1_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.entity_id end)     tier8_mon1_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier8_mon1_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier8_mon2_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.entity_id end)     tier8_mon2_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier8_mon2_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier8_mon3_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.entity_id end)     tier8_mon3_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier8_mon3_vol

,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier9_mon1_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.entity_id end)     tier9_mon1_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier9_mon1_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier9_mon2_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.entity_id end)     tier9_mon2_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier9_mon2_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier9_mon3_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.entity_id end)     tier9_mon3_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier9_mon3_vol

,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier10_mon1_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.entity_id end)     tier10_mon1_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier10_mon1_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier10_mon2_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.entity_id end)     tier10_mon2_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier10_mon2_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier10_mon3_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.entity_id end)     tier10_mon3_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier10_mon3_vol

,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier11_mon1_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.entity_id end)     tier11_mon1_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier11_mon1_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier11_mon2_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.entity_id end)     tier11_mon2_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier11_mon2_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier11_mon3_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.entity_id end)     tier11_mon3_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier11_mon3_vol

,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier12_mon1_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.entity_id end)     tier12_mon1_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier12_mon1_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier12_mon2_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.entity_id end)     tier12_mon2_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier12_mon2_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier12_mon3_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.entity_id end)     tier12_mon3_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier12_mon3_vol

,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier13_mon1_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.entity_id end)     tier13_mon1_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier13_mon1_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier13_mon2_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.entity_id end)     tier13_mon2_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier13_mon2_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier13_mon3_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.entity_id end)     tier13_mon3_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier13_mon3_vol

,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier14_mon1_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.entity_id end)     tier14_mon1_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier14_mon1_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier14_mon2_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.entity_id end)     tier14_mon2_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier14_mon2_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier14_mon3_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.entity_id end)     tier14_mon3_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier14_mon3_vol

,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier15_mon1_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.entity_id end)     tier15_mon1_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier15_mon1_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier15_mon2_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.entity_id end)     tier15_mon2_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier15_mon2_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier15_mon3_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.entity_id end)     tier15_mon3_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier15_mon3_vol

,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier16_mon1_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.entity_id end)     tier16_mon1_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier16_mon1_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier16_mon2_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.entity_id end)     tier16_mon2_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier16_mon2_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier16_mon3_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.entity_id end)     tier16_mon3_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier16_mon3_vol

,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier17_mon1_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.entity_id end)     tier17_mon1_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier17_mon1_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier17_mon2_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.entity_id end)     tier17_mon2_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier17_mon2_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier17_mon3_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.entity_id end)     tier17_mon3_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier17_mon3_vol

,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier18_mon1_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.entity_id end)     tier18_mon1_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier18_mon1_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier18_mon2_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.entity_id end)     tier18_mon2_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier18_mon2_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier18_mon3_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.entity_id end)     tier18_mon3_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier18_mon3_vol

,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier19_mon1_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.entity_id end)     tier19_mon1_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier19_mon1_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier19_mon2_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.entity_id end)     tier19_mon2_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier19_mon2_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier19_mon3_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.entity_id end)     tier19_mon3_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier19_mon3_vol

,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier20_mon1_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.entity_id end)     tier20_mon1_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier20_mon1_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier20_mon2_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.entity_id end)     tier20_mon2_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier20_mon2_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier20_mon3_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.entity_id end)     tier20_mon3_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier20_mon3_vol

from fanf_history fh right outer join fanf_table ft on fh.table_1_tier = ft.tier and fh.table_1 = ft.tbl
where 1=1
and ft.tbl = '1A'
and
    (fh.table_1 = '1A'
    and fh.month_requested
        between
            add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var - 1) * 3) )
        and
            add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var)     * 3) ) - 1
        and fh.institution_id in (:inst1_var, :inst2_var, :inst3_var, :inst4_var, :inst5_var )
    )
or fh.tax_id is null
group by '1a'

union

select
    'SCHDM' Record_type,
    ' ' action_code,
    ' ' Business_id,
    :year_var || :qtr_var year_quarter,
    'A' Certificate_type,
    '1b' table_type,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier1_mon1_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.entity_id end)     tier1_mon1_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier1_mon1_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier1_mon2_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.entity_id end)     tier1_mon2_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier1_mon2_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier1_mon3_taxid        ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.entity_id end)     tier1_mon3_loc          ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier1_mon3_vol

,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier2_mon1_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.entity_id end)     tier2_mon1_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier2_mon1_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier2_mon2_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.entity_id end)     tier2_mon2_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier2_mon2_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier2_mon3_taxid        ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.entity_id end)     tier2_mon3_loc          ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier2_mon3_vol

,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier3_mon1_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.entity_id end)     tier3_mon1_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier3_mon1_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier3_mon2_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.entity_id end)     tier3_mon2_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier3_mon2_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier3_mon3_taxid        ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.entity_id end)     tier3_mon3_loc          ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier3_mon3_vol

,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier4_mon1_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.entity_id end)     tier4_mon1_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier4_mon1_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier4_mon2_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.entity_id end)     tier4_mon2_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier4_mon2_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier4_mon3_taxid        ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.entity_id end)     tier4_mon3_loc          ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier4_mon3_vol

,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier5_mon1_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.entity_id end)     tier5_mon1_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier5_mon1_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier5_mon2_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.entity_id end)     tier5_mon2_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier5_mon2_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier5_mon3_taxid        ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.entity_id end)     tier5_mon3_loc          ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier5_mon3_vol

,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier6_mon1_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.entity_id end)     tier6_mon1_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier6_mon1_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier6_mon2_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.entity_id end)     tier6_mon2_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier6_mon2_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier6_mon3_taxid        ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.entity_id end)     tier6_mon3_loc          ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier6_mon3_vol

,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier7_mon1_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.entity_id end)     tier7_mon1_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier7_mon1_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier7_mon2_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.entity_id end)     tier7_mon2_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier7_mon2_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier7_mon3_taxid        ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.entity_id end)     tier7_mon3_loc          ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier7_mon3_vol

,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier8_mon1_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.entity_id end)     tier8_mon1_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier8_mon1_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier8_mon2_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.entity_id end)     tier8_mon2_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier8_mon2_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier8_mon3_taxid        ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.entity_id end)     tier8_mon3_loc          ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier8_mon3_vol

,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier9_mon1_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.entity_id end)     tier9_mon1_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier9_mon1_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier9_mon2_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.entity_id end)     tier9_mon2_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier9_mon2_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier9_mon3_taxid        ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.entity_id end)     tier9_mon3_loc          ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier9_mon3_vol

,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier10_mon1_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.entity_id end)     tier10_mon1_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier10_mon1_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier10_mon2_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.entity_id end)     tier10_mon2_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier10_mon2_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier10_mon3_taxid       ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.entity_id end)     tier10_mon3_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier10_mon3_vol

,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier11_mon1_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.entity_id end)     tier11_mon1_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier11_mon1_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier11_mon2_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.entity_id end)     tier11_mon2_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier11_mon2_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier11_mon3_taxid       ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.entity_id end)     tier11_mon3_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier11_mon3_vol

,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier12_mon1_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.entity_id end)     tier12_mon1_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier12_mon1_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier12_mon2_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.entity_id end)     tier12_mon2_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier12_mon2_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier12_mon3_taxid       ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.entity_id end)     tier12_mon3_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier12_mon3_vol

,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier13_mon1_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.entity_id end)     tier13_mon1_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier13_mon1_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier13_mon2_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.entity_id end)     tier13_mon2_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier13_mon2_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier13_mon3_taxid       ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.entity_id end)     tier13_mon3_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier13_mon3_vol

,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier14_mon1_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.entity_id end)     tier14_mon1_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier14_mon1_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier14_mon2_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.entity_id end)     tier14_mon2_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier14_mon2_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier14_mon3_taxid       ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.entity_id end)     tier14_mon3_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier14_mon3_vol

,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier15_mon1_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.entity_id end)     tier15_mon1_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier15_mon1_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier15_mon2_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.entity_id end)     tier15_mon2_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier15_mon2_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier15_mon3_taxid       ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.entity_id end)     tier15_mon3_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier15_mon3_vol

,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier16_mon1_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.entity_id end)     tier16_mon1_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier16_mon1_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier16_mon2_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.entity_id end)     tier16_mon2_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier16_mon2_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier16_mon3_taxid       ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.entity_id end)     tier16_mon3_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier16_mon3_vol

,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier17_mon1_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.entity_id end)     tier17_mon1_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier17_mon1_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier17_mon2_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.entity_id end)     tier17_mon2_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier17_mon2_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier17_mon3_taxid       ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.entity_id end)     tier17_mon3_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier17_mon3_vol

,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier18_mon1_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.entity_id end)     tier18_mon1_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier18_mon1_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier18_mon2_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.entity_id end)     tier18_mon2_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier18_mon2_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier18_mon3_taxid       ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.entity_id end)     tier18_mon3_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier18_mon3_vol

,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier19_mon1_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.entity_id end)     tier19_mon1_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier19_mon1_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier19_mon2_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.entity_id end)     tier19_mon2_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier19_mon2_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier19_mon3_taxid       ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.entity_id end)     tier19_mon3_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier19_mon3_vol

,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier20_mon1_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.entity_id end)     tier20_mon1_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.cp_amt    end) ,0) tier20_mon1_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier20_mon2_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.entity_id end)     tier20_mon2_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.cp_amt    end) ,0) tier20_mon2_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier20_mon3_taxid       ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.entity_id end)     tier20_mon3_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.cp_amt    end) ,0) tier20_mon3_vol

from fanf_history fh right outer join fanf_table ft on fh.table_1_tier = ft.tier and fh.table_1 = ft.tbl
where 1=1
and ft.tbl = '1B'
and
    (fh.table_1 = '1B'
    and fh.month_requested
    between
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var)     * 3) ) - 1
    and fh.institution_id in (:inst1_var, :inst2_var, :inst3_var, :inst4_var, :inst5_var )
    )
or fh.tax_id is null
group by '1b'

 union

select
    'SCHDM' Record_type,
    ' ' action_code,
    ' ' Business_id,
    :year_var || :qtr_var year_quarter,
    'A' Certificate_type,
    '2' table_type,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier1_mon1_taxid        ,
    null  tier1_mon1_loc         ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier1_mon1_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier1_mon2_taxid        ,
    null  tier1_mon2_loc         ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier1_mon2_vol          ,
    count(distinct case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier1_mon3_taxid        ,
    null  tier1_mon3_loc         ,
    nvl(sum(       case when ft.tier =  1 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier1_mon3_vol

,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier2_mon1_taxid        ,
    null  tier2_mon1_loc         ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier2_mon1_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier2_mon2_taxid        ,
    null  tier2_mon2_loc         ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier2_mon2_vol          ,
    count(distinct case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier2_mon3_taxid        ,
    null  tier2_mon3_loc         ,
    nvl(sum(       case when ft.tier =  2 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier2_mon3_vol

,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier3_mon1_taxid        ,
    null  tier3_mon1_loc         ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier3_mon1_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier3_mon2_taxid        ,
    null  tier3_mon2_loc         ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier3_mon2_vol          ,
    count(distinct case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier3_mon3_taxid        ,
    null  tier3_mon3_loc         ,
    nvl(sum(       case when ft.tier =  3 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier3_mon3_vol

,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier4_mon1_taxid        ,
    null  tier4_mon1_loc         ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier4_mon1_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier4_mon2_taxid        ,
    null  tier4_mon2_loc         ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier4_mon2_vol          ,
    count(distinct case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier4_mon3_taxid        ,
    null  tier4_mon3_loc         ,
    nvl(sum(       case when ft.tier =  4 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier4_mon3_vol

,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier5_mon1_taxid        ,
    null  tier5_mon1_loc         ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier5_mon1_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier5_mon2_taxid        ,
    null  tier5_mon2_loc         ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier5_mon2_vol          ,
    count(distinct case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier5_mon3_taxid        ,
    null  tier5_mon3_loc         ,
    nvl(sum(       case when ft.tier =  5 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier5_mon3_vol

,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier6_mon1_taxid        ,
    null  tier6_mon1_loc         ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier6_mon1_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier6_mon2_taxid        ,
    null  tier6_mon2_loc         ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier6_mon2_vol          ,
    count(distinct case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier6_mon3_taxid        ,
    null  tier6_mon3_loc         ,
    nvl(sum(       case when ft.tier =  6 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier6_mon3_vol

,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier7_mon1_taxid        ,
    null  tier7_mon1_loc         ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier7_mon1_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier7_mon2_taxid        ,
    null  tier7_mon2_loc         ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier7_mon2_vol          ,
    count(distinct case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier7_mon3_taxid        ,
    null  tier7_mon3_loc         ,
    nvl(sum(       case when ft.tier =  7 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier7_mon3_vol

,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier8_mon1_taxid        ,
    null  tier8_mon1_loc         ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier8_mon1_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier8_mon2_taxid        ,
    null  tier8_mon2_loc         ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier8_mon2_vol          ,
    count(distinct case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier8_mon3_taxid        ,
    null  tier8_mon3_loc         ,
    nvl(sum(       case when ft.tier =  8 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier8_mon3_vol

,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier9_mon1_taxid        ,
    null  tier9_mon1_loc         ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier9_mon1_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier9_mon2_taxid        ,
    null  tier9_mon2_loc         ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier9_mon2_vol          ,
    count(distinct case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier9_mon3_taxid        ,
    null  tier9_mon3_loc         ,
    nvl(sum(       case when ft.tier =  9 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier9_mon3_vol

,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier10_mon1_taxid       ,
    null  tier10_mon1_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier10_mon1_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier10_mon2_taxid       ,
    null  tier10_mon2_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier10_mon2_vol         ,
    count(distinct case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier10_mon3_taxid       ,
    null  tier10_mon3_loc         ,
    nvl(sum(       case when ft.tier = 10 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier10_mon3_vol

,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier11_mon1_taxid       ,
    null  tier11_mon1_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier11_mon1_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier11_mon2_taxid       ,
    null  tier11_mon2_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier11_mon2_vol         ,
    count(distinct case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier11_mon3_taxid       ,
    null  tier11_mon3_loc         ,
    nvl(sum(       case when ft.tier = 11 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier11_mon3_vol

,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier12_mon1_taxid       ,
    null  tier12_mon1_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier12_mon1_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier12_mon2_taxid       ,
    null  tier12_mon2_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier12_mon2_vol         ,
    count(distinct case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier12_mon3_taxid       ,
    null  tier12_mon3_loc         ,
    nvl(sum(       case when ft.tier = 12 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier12_mon3_vol

,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier13_mon1_taxid       ,
    null  tier13_mon1_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier13_mon1_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier13_mon2_taxid       ,
    null  tier13_mon2_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier13_mon2_vol         ,
    count(distinct case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier13_mon3_taxid       ,
    null  tier13_mon3_loc         ,
    nvl(sum(       case when ft.tier = 13 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier13_mon3_vol

,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier14_mon1_taxid       ,
    null  tier14_mon1_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier14_mon1_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier14_mon2_taxid       ,
    null  tier14_mon2_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier14_mon2_vol         ,
    count(distinct case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier14_mon3_taxid       ,
    null  tier14_mon3_loc         ,
    nvl(sum(       case when ft.tier = 14 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier14_mon3_vol

,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier15_mon1_taxid       ,
    null  tier15_mon1_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier15_mon1_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier15_mon2_taxid       ,
    null  tier15_mon2_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier15_mon2_vol         ,
    count(distinct case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier15_mon3_taxid       ,
    null  tier15_mon3_loc         ,
    nvl(sum(       case when ft.tier = 15 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier15_mon3_vol

,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier16_mon1_taxid       ,
    null  tier16_mon1_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier16_mon1_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier16_mon2_taxid       ,
    null  tier16_mon2_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier16_mon2_vol         ,
    count(distinct case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier16_mon3_taxid       ,
    null  tier16_mon3_loc         ,
    nvl(sum(       case when ft.tier = 16 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier16_mon3_vol

,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier17_mon1_taxid       ,
    null  tier17_mon1_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier17_mon1_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier17_mon2_taxid       ,
    null  tier17_mon2_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier17_mon2_vol         ,
    count(distinct case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier17_mon3_taxid       ,
    null  tier17_mon3_loc         ,
    nvl(sum(       case when ft.tier = 17 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier17_mon3_vol

,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier18_mon1_taxid       ,
    null  tier18_mon1_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier18_mon1_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier18_mon2_taxid       ,
    null  tier18_mon2_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier18_mon2_vol         ,
    count(distinct case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier18_mon3_taxid       ,
    null  tier18_mon3_loc         ,
    nvl(sum(       case when ft.tier = 18 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier18_mon3_vol

,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier19_mon1_taxid       ,
    null  tier19_mon1_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier19_mon1_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier19_mon2_taxid       ,
    null  tier19_mon2_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier19_mon2_vol         ,
    count(distinct case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier19_mon3_taxid       ,
    null  tier19_mon3_loc         ,
    nvl(sum(       case when ft.tier = 19 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier19_mon3_vol

,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.tax_id    end)     tier20_mon1_taxid       ,
    null  tier20_mon1_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_1 then fh.cnp_amt   end) ,0) tier20_mon1_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.tax_id    end)     tier20_mon2_taxid       ,
    null  tier20_mon2_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_2 then fh.cnp_amt   end) ,0) tier20_mon2_vol         ,
    count(distinct case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.tax_id    end)     tier20_mon3_taxid       ,
    null  tier20_mon3_loc         ,
    nvl(sum(       case when ft.tier = 20 and fh.month_requested = :mth_3 then fh.cnp_amt   end) ,0) tier20_mon3_vol

from fanf_history fh right outer join fanf_table ft on fh.table_2_tier = ft.tier and ft.tbl = '2'
where 1=1
and ft.tbl = '2'
and
    (fh.month_requested
    between
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var - 1) * 3) )
    and
        add_months(trunc(to_date(:year_var, 'YYYY'), 'YY'), ((:qtr_var)     * 3) ) - 1
    and fh.institution_id in (:inst1_var, :inst2_var, :inst3_var, :inst4_var, :inst5_var )
    )
or fh.tax_id is null

group by '2'

order by table_type
 ;
