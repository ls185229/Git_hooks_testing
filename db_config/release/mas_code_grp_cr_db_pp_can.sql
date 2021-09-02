set linesize 1000
set pagesize 500
--Change the institution_id & execute for all the canadian institution between 129 and 135

insert into MAS_CODE_GRP
    (INSTITUTION_ID, MAS_CODE_GRP_ID, QUALIFY_MAS_CODE, MAS_CODE)
select
    '130' as institution_id ,
    '60' as mas_code_grp_id,
    MAS_CODE as qualify_mas_code,
    case when mas_desc like ('%DB%') 
           or mas_code like '%REG%'  
           or mas_code like '%INLK%'   then 'VSDB'
         when mas_desc like ('%PP%')   then 'VSPP'
                                       else 'VSCR' end   as mas_code
  --  ,MAS_DESC
from FLMGR_INTERCHANGE_RATES
where usage = 'INTERCHANGE'
and REGION in ('ALL','CAN')
and CARD_SCHEME = '04'
and MAS_CODE in (
    select distinct fir.MAS_CODE
    from FLMGR_INTERCHANGE_RATES fir
    where fir.usage = 'INTERCHANGE'
    and fir.REGION in ('ALL','CAN')
    and fir.CARD_SCHEME = '04'
    and fir.FPI_IRD is not null
    and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
    minus

    select distinct QUALIFY_MAS_CODE as MAS_CODE
    from MAS_CODE_GRP mcg
    where mcg.MAS_CODE_GRP_ID = '60'
    and mcg.INSTITUTION_ID = '130'
    and mcg.QUALIFY_MAS_CODE like '0104%'
)
;


insert into MAS_CODE_GRP
    (INSTITUTION_ID, MAS_CODE_GRP_ID, QUALIFY_MAS_CODE, MAS_CODE)
select
    '130' as institution_id ,
    '60' as mas_code_grp_id,
    MAS_CODE as qualify_mas_code,
    case when upper(mas_desc) like ('%DEBIT%') 
           or upper(mas_desc) like '%DB%'        then 'MCDB'
         when upper(mas_desc) like ('%PREPAID%') then 'MCPP'
                                                 else 'MCCR' end as mas_code
  --  ,MAS_DESC
from FLMGR_INTERCHANGE_RATES
where usage = 'INTERCHANGE'
and REGION in ('ALL','CAN')
and CARD_SCHEME = '05'
and MAS_CODE in (
    select distinct fir.MAS_CODE
    from FLMGR_INTERCHANGE_RATES fir
    where fir.usage = 'INTERCHANGE'
    and fir.REGION in ('ALL','CAN')
    and fir.CARD_SCHEME = '05'
    and fir.FPI_IRD is not null
    and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
    minus

    select distinct QUALIFY_MAS_CODE as MAS_CODE
    from MAS_CODE_GRP mcg
    where mcg.MAS_CODE_GRP_ID = '60'
    and mcg.INSTITUTION_ID = '130'
    and mcg.QUALIFY_MAS_CODE like '0105%'
)
;

insert into MAS_CODE_GRP
    (INSTITUTION_ID, MAS_CODE_GRP_ID, QUALIFY_MAS_CODE, MAS_CODE)
select
    '130' as institution_id ,
    '60' as mas_code_grp_id,
    MAS_CODE as qualify_mas_code,
    case when upper(mas_desc) like ('%DEBIT%') 
           or upper(mas_desc) like '%DB%'        then 'DSDB'
         when upper(mas_desc) like ('%PREPAID%') then 'DSPP'
                                                 else 'DSCR' end as mas_code
  --  ,MAS_DESC
from FLMGR_INTERCHANGE_RATES fir where 
usage = 'INTERCHANGE' 
and REGION in ('ALL','CAN') 
and CARD_SCHEME = '08' 
and MAS_CODE in (
    select distinct fir.MAS_CODE 
    from FLMGR_INTERCHANGE_RATES fir 
    where fir.usage = 'INTERCHANGE' 
    and fir.REGION in ('ALL','CAN') 
    and fir.CARD_SCHEME = '08'
    and fir.FPI_IRD is not null
    and (fir.RATE_PER_ITEM is not null or fir.RATE_PERCENT is not null)
    minus
    select distinct QUALIFY_MAS_CODE as MAS_CODE 
    from MAS_CODE_GRP mcg 
    where mcg.MAS_CODE_GRP_ID = '60'  
    and mcg.INSTITUTION_ID = '130' 
    and mcg.QUALIFY_MAS_CODE like '08%'
)
;