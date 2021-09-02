set linesize 2500

select
  mtl.institution_id inst,
  mtl.entity_id,
  trunc(mtl.gl_date, 'MM') gl_month,
  -- min(tab) min_tab,
  -- max(tab) max_tab,
  --case when mtl.tid = '010004620000' then mtl.mas_code end mas_code,
  --mtl.tid,
  --t.description,
  --count(*) cnt,
  --sum(nbr_of_items) items,
  --sum(
  --  case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --  mtl.amt_billing) total_fees,
  --sum(  case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --      mtl.amt_original 
  --  ) calc_fees,
  sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
        mtl.amt_billing 
    ) taxable_fees
  --,
  --sum(
  --  case when mtl.tid = '010004620000' then
  --      case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --      mtl.principal_amt 
  --  end) total_covered,
  --sum(
  --  case when mtl.tid = '010004620000' then
  --      case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --      mtl.amt_billing 
  --  end ) tax_charged
from 

    (    
    select 'mtl'   
        tab, institution_id, entity_id, gl_date, tid, mas_code, nbr_of_items, 
        amt_original, amt_billing, tid_settl_method, principal_amt 
    from mas_trans_log 
    --where institution_id = '130'
    
    union
     
    select 'mtlmf' 
        tab, institution_id, entity_id, gl_date, tid, mas_code, nbr_of_items, 
        amt_original, amt_billing, tid_settl_method, principal_amt 
    from mas_trans_log_missed_fees)  mtl

join tid t
on t.tid = mtl.tid
where mtl.institution_id = '130'
and mtl.gl_date >= '01-jun-16'
and mtl.gl_date <  '01-jul-16'
and mtl.tid like '010004%' 
and mtl.tid != '010004620000' 

group by institution_id, entity_id, trunc(gl_date, 'MM')
    --, case when mtl.tid = '010004620000' then mas_code end
    --, tid
    --, description
order by institution_id, entity_id, trunc(gl_date, 'MM')
    --,  mas_code desc
    --, tid
;


select       
  mtl.institution_id inst,
  mtl.entity_id,
  trunc(mtl.gl_date, 'MM') gl_month,
  --min(tab) min_tab,
  --max(tab) max_tab,
  case when mtl.tid like '01000462%' then mtl.mas_code end mas_code,
  mtl.tid,
  substr(t.description, 1, 20) description,
  --count(*) cnt,
  --sum(nbr_of_items) items,
  --sum(
  --  case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --  mtl.amt_billing) total_fees,
  --sum(  case when mtl.tid_settl_method = 'D' then -1 else 1 end *
  --      mtl.amt_original 
  --  ) calc_fees,
  --sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
  --      mtl.amt_billing 
  --  ) taxable_fees
  --,
  sum(
    case when mtl.tid like '01000462%' then
        case when mtl.tid_settl_method = 'D' then 1 else -1 end *
        mtl.principal_amt 
    end) total_covered,
  sum(
    case when mtl.tid like '01000462%' then
        case when mtl.tid_settl_method = 'D' then 1 else -1 end *
        mtl.amt_billing 
    end ) tax_charged
from 

    (    
    select 'mtl'   
        tab, institution_id, entity_id, gl_date, tid, mas_code, nbr_of_items, 
        amt_original, amt_billing, tid_settl_method, principal_amt 
    from mas_trans_log 
    --where institution_id = '130'
    
    union
     
    select 'mtlmf' 
        tab, institution_id, entity_id, gl_date, tid, mas_code, nbr_of_items, 
        amt_original, amt_billing, tid_settl_method, principal_amt 
    from mas_trans_log_missed_fees)  mtl

join tid t
on t.tid = mtl.tid
where mtl.institution_id = '130'
and mtl.gl_date >= '01-jun-16'
and mtl.gl_date <  '01-jul-16'
and mtl.tid like '010004%' 
and mtl.tid like '01000462%' 

group by institution_id, entity_id, trunc(gl_date, 'MM')
    , case when mtl.tid like '01000462%' then mtl.mas_code end
    , mtl.tid
    , substr(t.description, 1, 20) 
order by mtl.institution_id, mtl.entity_id, trunc(mtl.gl_date, 'MM')
    , mas_code desc
    , mtl.tid
;
