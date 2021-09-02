--this query will give count of mas_codes to verify
SELECT fir.CARD_SCHEME, count(distinct fir.mas_code)
FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
group by fir.CARD_SCHEME
order by fir.CARD_SCHEME
;

--this query will give the different mascode group to verify and their count
--verify it against the 1st query result
select --*
institution_id,mas_code,mas_code_grp_id,count(qualify_mas_code)
from masclr.mas_code_grp where 
institution_id = '130'
--and mas_code like '%ASSM%'
and qualify_mas_code in  
( select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
)
group by institution_id,mas_code,mas_code_grp_id
order by mas_code; 

--Below queries will return the mas_codes missing
set linesize 10000;
set pagesize 500;
--ASSMT group check
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mcg.qualify_mas_code  from masclr.mas_code_grp mcg
where mcg.INSTITUTION_ID = '130'
and mcg.MAS_CODE_GRP_ID = '13'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;

--DISCOUNT group check
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mcg.qualify_mas_code  from masclr.mas_code_grp mcg
where mcg.INSTITUTION_ID = '130'
and mcg.MAS_CODE_GRP_ID = '14'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;

--SETTLE group check
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mcg.qualify_mas_code  from masclr.mas_code_grp mcg
where mcg.INSTITUTION_ID = '130'
and mcg.MAS_CODE_GRP_ID = '4'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;

--TIER group check
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mcg.qualify_mas_code  from masclr.mas_code_grp mcg
where mcg.INSTITUTION_ID = '130'
and mcg.MAS_CODE_GRP_ID = '9'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;

--Credit debit prepaid group check
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mcg.qualify_mas_code  from masclr.mas_code_grp mcg
where mcg.INSTITUTION_ID = '130'
and mcg.MAS_CODE_GRP_ID = '60'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;
--mas_fees check for sale tid alone
select * from flmgr_interchange_rates where MAS_CODE in (
select distinct mas_code FROM flmgr_interchange_rates fir
WHERE fir.usage           = 'INTERCHANGE'
and fir.region in ('ALL','CAN')
and fir.CARD_SCHEME in ('04','05','08')
and fir.FPI_IRD is not null
and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
minus
select distinct mf.mas_code  from masclr.mas_fees mf
where mf.INSTITUTION_ID = '130'
and mf.FEE_PKG_ID = '33'
and mf.FEE_STATUS = 'C'
and mf.TID_FEE = '010004020000'
and mf.TID_ACTIVITY = '010003005101'
)
and usage           = 'INTERCHANGE'
and region in ('ALL','CAN')
;