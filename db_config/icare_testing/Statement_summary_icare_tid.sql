set termout on
set verify off

-- multiple IDs can be used at once, like this: define entity_id_var = "'','','','','','',''"
-- multiple IDs need to be limited to 240 characters (in total, including the punctuation), so the practical limit is about 10 at a time.

define entity_id_var      = "' '"
define institution_id_var = "' '"
-- define entity_id_var = "like ''"
define begin_date         = "'01-FEB-2014'"
define end_date           = "'28-FEB-2014'"

SELECT 
  substr(mtl.institution_id,1,4) Inst, 
  substr(mtl.posting_entity_id,1,15) as Entity, 
  ae.entity_dba_name name, 
  (case when t.trans_class  = '07' 
    then  to_char(mtl.date_to_settle, 'YYYY-MM') 
    else  to_char(mtl.gl_date, 'YYYY-MM') end) as "Stmt", 
  to_char(COUNT(1),'99,999,999') AS "Cnt", 
  to_char(sum(mtl.nbr_of_items),'99,999,999') AS "Items", 
  to_char(SUM ( CASE WHEN mtl.tid_settl_method ='C' 
    THEN mtl.amt_original
    ELSE -mtl.amt_original END),'999,999,999.00') AS "Amt Original", 
  to_char(SUM ( CASE WHEN mtl.tid_settl_method ='C' 
    THEN mtl.amt_billing 
    ELSE -mtl.amt_billing END),'999,999,999.00') AS "Amt Billing", 
  (CASE WHEN mtl.tid LIKE '010004%' THEN '010004000000' ELSE mtl.tid END) AS TID , 
        (CASE 
          WHEN t.trans_class = '03' THEN 'Sales, Refunds, Chargebacks' 
          WHEN t.trans_class = '04' THEN 'Interchange and other Fees' 
          WHEN t.trans_class = '05' THEN 'Reserve Held' 
          WHEN t.trans_class = '07' THEN 'Reserve Paid' 
          ELSE 'Other' 
        END)                                               AS "Category", 
  --substr((CASE WHEN mtl.tid LIKE '010004%' THEN 'FEES' ELSE t.description END),1,25) AS "TID Description" ,
  mtl.tid mtl_tid,
  substr(t.description,1,25) AS "TID Description" 
FROM mas_trans_log mtl 
join acq_entity ae 
on mtl.institution_id = ae.institution_id 
and mtl.posting_entity_id = ae.entity_id 
JOIN tid t 
ON t.tid = mtl.tid 
WHERE ( ( mtl.date_to_settle BETWEEN &begin_date AND &end_date 
          and t.trans_class  = '07' ) 
      OR ( mtl.gl_date       BETWEEN &begin_date AND &end_date
			and t.trans_class != '07' ) ) 
 
--AND mtl.settl_flag        = 'Y' 
and t.trans_class not in  ('70')
and mtl.entity_id in 
	(
    '454045421660001', '454045421660010', '454045421660240', '454045421660620',
    '454045421660621', '454045421660622', '454045421660623', '454045421660624',
    '454045421660625', '454045421660626', '454045421660627', '454045421660628',
    '454045421660629'
	)
 
group by 
    substr(mtl.institution_id,1,4), 
	substr(mtl.posting_entity_id,1,15), 
	ae.entity_dba_name, 
    (case   when t.trans_class  = '07' 
            then  to_char(mtl.date_to_settle, 'YYYY-MM') 
            else  to_char(mtl.gl_date, 'YYYY-MM')           end), 
    (CASE   WHEN mtl.tid LIKE '010004%' THEN '010004000000' ELSE mtl.tid END), 
    (CASE   WHEN t.trans_class = '03'   THEN 'Sales, Refunds, Chargebacks' 
            WHEN t.trans_class = '04'   THEN 'Interchange and other Fees' 
            WHEN t.trans_class = '05'   THEN 'Reserve Held' 
            WHEN t.trans_class = '07'   THEN 'Reserve Paid' 
                                        ELSE 'Other'        END), 
    --substr((CASE WHEN mtl.tid LIKE '010004%' THEN 'FEES' ELSE t.description END),1,25) ,
  mtl.tid, 
  substr(t.description,1,25) 
ORDER BY 1, 2, TID
;