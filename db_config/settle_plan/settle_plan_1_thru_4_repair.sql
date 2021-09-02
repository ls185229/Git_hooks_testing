set pagesize 500

select *
from settl_plan sp
where
    sp.settl_plan_id in (1, 2)
;

update settl_plan sp
set sp.plan_desc = 'Pass Thru Gross Fund (Monthly)'
where
    sp.settl_plan_id in (1)
and sp.institution_id between '101' and '135'
and sp.plan_desc != 'Pass Thru Gross Fund (Monthly)'
;

update settl_plan sp
set sp.plan_desc = 'Bundled Gross Fund (Monthly)'
where
    sp.settl_plan_id in (2)
and sp.institution_id between '101' and '135'
and sp.plan_desc != 'Bundled Gross Fund (Monthly)'
;

select *
from settl_plan_tid spt
where spt.settl_plan_id in (1, 2)
and spt.institution_id between '101' and '135'
and spt.tid like '010004%'
and spt.tid not like '01000435000_'
and spt.tid not like '0100042800%'
and spt.settl_freq != 'M'
;

update settl_plan_tid spt
set spt.settl_freq = 'M',
    day_of_month = 31,
    next_settl_date = last_day(sysdate)
where spt.settl_plan_id in (1, 2)
and spt.institution_id between '101' and '135'
and spt.tid like '010004%'
and spt.tid not like '01000435000_'
and spt.tid not like '0100042800%'
and spt.settl_freq != 'M'
;


select *
from settl_plan sp
where sp.settl_plan_id in (1, 2)
;

select *
from settl_plan_tid spt
where
    spt.settl_plan_id in (1, 2)
and spt.institution_id between '101' and '135'
and spt.tid like '010004%'
and spt.tid not like '01000435000_'
and spt.tid not like '0100042800%'
and spt.settl_freq != 'M'
;

-- commit;