
set pagesize 1000
set linesize 1000
set colsep  ","
-- set headsep on
set pagesize 1000
set trimspool on

select 
    mtl.institution_id "Inst",
    mtl.gl_date, 
    nvl(case when mtl.card_scheme = '02' 
        then 'PIN Debit' 
        else cs.card_scheme_name end, 'Total') "Card Scheme",
    mtl.major_cat,
    mtl.minor_cat,
    sum(mtl.nbr_of_items) cnt,
    sum(mtl.calc_amount) calc_amount,
    sum(mtl.amount) amount_billed,
    sum(mtl.calc_amount - mtl.amount) not_billed,
    sum(case when date_to_settle > trunc(sysdate)
        then mtl.calc_amount else 0 end) "Deferred Amt"
from masclr.mas_trans_view mtl
join masclr.card_scheme cs
on cs.card_scheme = mtl.card_scheme
where 
    mtl.gl_date = trunc(sysdate)
and mtl.major_cat = 'FEES'
and mtl.minor_cat in ('INTERCHANGE', 'ASSESSMENTx', 'DISCOUNTx')
and institution_id in ('101', '107')
group by 
    mtl.institution_id,
    mtl.gl_date, 
    rollup(
    case when mtl.card_scheme = '02' 
        then 'PIN Debit' else cs.card_scheme_name end,
    mtl.major_cat,
    mtl.minor_cat)
having minor_cat is not null
or case when mtl.card_scheme = '02' 
        then 'PIN Debit' else cs.card_scheme_name end is null
order by 
    mtl.institution_id, 
    mtl.gl_date,    
    case when mtl.card_scheme = '02' 
        then 'PIN Debit' else cs.card_scheme_name end
;
exit