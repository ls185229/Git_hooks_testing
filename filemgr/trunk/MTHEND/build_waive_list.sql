set head off
set pagesize 0
set feed off
set echo off
set term off
set trims on
set verify off

spool month_min_waive_list.txt
select unique enfp.entity_id
from masclr.NON_ACT_FEE_PKG nafp
join masclr.ent_nonact_fee_pkg enfp on nafp.institution_id = enfp.institution_id
 and  nafp.non_act_fee_pkg_id = enfp.non_act_fee_pkg_id
join masclr.non_activity_fees naf on enfp.institution_id = naf.institution_id
 and enfp.non_act_fee_pkg_id =  naf.non_act_fee_pkg_id
join masclr.mas_code mc on mc.mas_code = naf.mas_code
join masclr.acq_entity acq on acq.entity_id = enfp.entity_id
where trunc(naf.next_generate_date) =  trunc(last_day(add_months(sysdate, 1)))
  and naf.institution_id =  enfp.institution_id
  and naf.non_act_fee_pkg_id = enfp.non_act_fee_pkg_id
  and acq.entity_id = enfp.entity_id
  and mc.mas_code = naf.mas_code
  and naf.generate_freq in ('M')
  and (nafp.fee_end_date > sysdate or nafp.fee_end_date is null)
  and (enfp.end_date  > sysdate or enfp.end_date is null)
order by enfp.entity_id;
spool off
exit

