set pagesize 0
set feedback off
set heading off
set linesize 400
set termout off
set verify off
spool meridian_report.csv
select '"Merchant Name","Address","City","State","Zip","Bank Routing Number","Merchant ID","Owner name","DOB","MCC","Open Date","Closed Date","Total sales Ct","Total sales '||chr(36)||'","Card Present CT","Card Present '||chr(36)||'","Card not Present CT","Card not Present '||chr(36)||'","Credit Ct","Credit '||chr(36)||'","Chargeback Ct","Chargeback '||chr(36)||'"'
from dual;

select '"'||entity_name
   ||'","'||address
   ||'","'||city
   ||'","'||PROV_STATE_ABbREV
   ||'","'||POSTAL_CD_ZIP
   ||'","'||aba_account_number
   ||'","'||entity_id
   ||'","'||name
   ||'","'||DOB
   ||'","'||default_mcc
   ||'","'||actual_start_date
   ||'","'||termination_date
   ||'","'||Total_sales_Ct
   ||'","'||Total_sales_amt
   ||'","'||Card_Present_CT
   ||'","'||Card_Present_amt
   ||'","'||Card_not_Present_CT
   ||'","'||Card_not_Present_amt
   ||'","'||Credit_Ct
   ||'","'||Credit_amt
   ||'","'||Chargeback_ct
   ||'","'||Chargeback_amt||'"'
  from (select entity_name
    , trim(address1||' '||address2) address
    , city
    , PROV_STATE_ABbREV
    , POSTAL_CD_ZIP
    , null aba_account_number
    , ae.entity_id
    , trim(mc.first_name||' '||mc.last_name) name
    , null  DOB
    , ae.default_mcc
    , to_char(actual_start_date, 'mm/dd/yyyy') actual_start_date
    , decode(entity_status, 'C', to_char(termination_date, 'mm/dd/yyyy'), null) termination_date
    , sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102', '010003005201') and mtl.tid_settl_method = 'C') 
		            then 1 
	       	       else 0 
	            end ) Total_sales_Ct
    , (sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102') and mtl.tid_settl_method = 'C') 
	        then mtl.amt_original 
		    else 0 
		    end ) 
           - sum(case when (mtl.tid in ( '010003005201')  and mtl.tid_settl_method = 'C') 
		            then mtl.amt_original 
					else 0 
				end  )) Total_sales_amt
    , sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102', '010003005201') and mtl.tid_settl_method = 'C' and nvl(pos_crd_present, 0) = 1) 
		then 1 
		else 0 
	  end ) Card_Present_CT
    , sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102', '010003005201') and mtl.tid_settl_method = 'C' and nvl(pos_crd_present, 0) = 1) 
		then mtl.amt_original 
		else 0 
	  end ) Card_Present_amt
    , sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102', '010003005201') and mtl.tid_settl_method = 'C' and nvl(pos_crd_present, 0) <> 1) 
		then 1 
		else 0 
	  end ) Card_not_Present_CT
    , sum(case when (mtl.tid in ('010003005101', '010003005102', '010123005101', '010123005102', '010003005201') and mtl.tid_settl_method = 'C' and nvl(pos_crd_present, 0) <> 1) 
		then mtl.amt_original 
		else 0 
	  end ) Card_not_Present_amt
    , sum(case when (mtl.tid in ('010003005101', '010003005102')  and mtl.tid_settl_method <> 'C') then 1 else 0 end ) Credit_Ct
    , sum(case when (mtl.tid in ('010003005101', '010003005102')  and mtl.tid_settl_method <> 'C') then mtl.amt_original else 0 end ) Credit_amt
    , Sum(case when mtl.tid in ('010003005301', '010003005401', '010003005402', '010003015301', '010003015101', '010003015102',
                            '010003015106', '010003015201', '010003015202', '010003015210', '010003015301', '010003010102',      
                            '010003010101', '010008010001', '010008010101') and mtl.amt_original <> 0 then 1 else 0 end) Chargeback_ct
    , (sum(CASE WHEN (mtl.tid in ('010003005301', '010003005401', '010003005402', '010003015301', '010003015101', '010003015102',      
                            '010003015106', '010003015201', '010003015202', '010003015210', '010003015301', '010003010102',      
                            '010003010101', '010008010001', '010008010101') and mtl.TID_SETTL_METHOD = 'C') then mtl.AMT_ORIGINAL else 0 end)               
        - sum(CASE WHEN( mtl.TID in ('010003005301', '010003005401', '010003005402', '010003015301', '010003015101', '010003015102',      
                            '010003015106', '010003015201', '010003015202', '010003015210', '010003015301', '010003010102',      
                            '010003010101', '010008010001', '010008010101') and mtl.TID_SETTL_METHOD <> 'C') then mtl.AMT_ORIGINAL else 0 end)) Chargeback_amt
from acq_entity ae
join acq_entity_address aea on (ae.institution_id = aea.institution_id and ae.entity_id = aea.entity_id)
join master_address ma on (aea.ADDRESS_ID = MA.ADDRESs_ID 
                      AND MA.INSTITUTION_ID = aea.INSTITUTION_ID)
join acq_entity_contact aec on (ae.institution_id = aec.institution_id 
                          and ae.entity_id = aec.entity_id)
join master_contact mc on (aec.contact_id = Mc.contact_id
                       AND Mc.INSTITUTION_ID = aec.INSTITUTION_ID)
right outer join mas_trans_log mtl on (mtl.posting_entity_id = ae.entity_id
                          and mtl.INSTITUTION_ID = ae.INSTITUTION_ID)
--join in_draft_main idm on (idm.arn = mtl.trans_ref_data)
--join entity_to_auth eta on (eta.institution_id = ae.institution_id and eta.entity_id = ae.entity_id)
--left join teihost.merchant@PORTW_REPTRANSP4 m on (m.mid = eta.mid)
where institution_id in ('105', '106')
  and entity_level = '70'
  and Contact_Role = 'DEF'
  and address_role = 'LOC'
  and gl_date between to_date('01/01/2012', 'dd/mm/yyyy') and last_day(to_date('01/01/2012', 'dd/mm/yyyy'))
group by  entity_name
    , address1
    , address2
    , city
    , PROV_STATE_ABbREV
    , POSTAL_CD_ZIP
--    , aba_account_number
    , ae.entity_id
    , mc.first_name
    , mc.last_name
    , ae.default_mcc
    , actual_start_date
    , entity_status
    , termination_date);
spool off
exit

