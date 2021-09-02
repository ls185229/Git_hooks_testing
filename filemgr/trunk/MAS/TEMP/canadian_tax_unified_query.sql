set linesize 2500

select 
    taxable.inst, 
    taxable.entity_id, 
    taxable.gl_month,
    paid.tid,
    paid.mas_code,
    paid.description,
    taxable.taxable_fees,
    paid.total_covered,
    (taxable.taxable_fees - paid.total_covered) Amt_to_tax
from 
    (
    select 
      
      mtl.institution_id inst,
      mtl.entity_id,
      trunc(mtl.gl_date, 'MM') gl_month,
      sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
            mtl.amt_billing 
        ) taxable_fees
    from 
        (select 'mtl' tab, institution_id, entity_id, gl_date, tid, mas_code, 
            nbr_of_items, amt_original, amt_billing, tid_settl_method, principal_amt 
        from mas_trans_log         
        union                       
        select 'mtlmf' tab, institution_id, entity_id, gl_date, tid, mas_code, 
            nbr_of_items, amt_original, amt_billing, tid_settl_method, principal_amt 
        from mas_trans_log_missed_fees)  mtl
    --join tid t
    --on t.tid = mtl.tid

    where mtl.institution_id = '130'
    and mtl.gl_date >= '01-jun-16'
    and mtl.gl_date <  '01-jul-16'
    and mtl.tid like '010004%' 
    and mtl.tid != '010004620000' 

    group by institution_id, entity_id, trunc(gl_date, 'MM')
    having sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
            mtl.amt_billing 
        ) != 0

    ) taxable 
    
    left outer join 
    
    (

    select 
      
      mtl.institution_id inst,
      mtl.entity_id,
      trunc(mtl.gl_date, 'MM') gl_month,
      case when mtl.tid like '01000462%' then mtl.mas_code end mas_code,
      mtl.tid,
      substr(t.description, 1, 20) description,
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
        (select 'mtl' tab, institution_id, entity_id, gl_date, tid, mas_code, 
            nbr_of_items, amt_original, amt_billing, tid_settl_method, principal_amt 
        from mas_trans_log         
        union                       
        select 'mtlmf' tab, institution_id, entity_id, gl_date, tid, mas_code, 
            nbr_of_items, amt_original, amt_billing, tid_settl_method, principal_amt 
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
    ) paid
    on  taxable.inst = paid.inst
    and taxable.entity_id = paid.entity_id
    and taxable.gl_month = paid.gl_month
    
order by 
    taxable.inst, 
    taxable.entity_id, 
    taxable.gl_month,
    paid.mas_code,
    paid.tid,
    taxable.taxable_fees
;
