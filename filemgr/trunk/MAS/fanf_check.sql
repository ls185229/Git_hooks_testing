SELECT  
  fs.INST_NAME, fs.TAX_ID,
  fs.institution_id inst,  
  fs.entity_id,  
  ae.entity_dba_name,  
  to_char(fs.month_requested, 'YYYY-MM') mnth,  
  fs.num_of_locations locs,  
  fs.cp_percentage cp_pct,  
  fs.cp_amt,  
  fs.cnp_amt,  
  fs.cp_fee,  
  fs.cnp_fee  
FROM  
  Fanf_Staging fs, acq_entity ae  
WHERE  
  
    fs.MONTH_REQUESTED = trunc(trunc(sysdate, 'MM') - 01, 'MM')  
and ae.institution_id = fs.institution_id  
and ae.entity_id = fs.entity_id  
 
 
  
order by 1, 2, 3, 4;