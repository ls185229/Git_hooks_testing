REM Update mas_code_grp table from flmgr_mas_code_grp view

REM $Id: 6_0_flmgr_mas_code_grp_merge_mcg.sql 38 2019-10-16 02:43:28Z bjones $

merge into mas_code_grp mcg
using flmgr_mas_code_grp fmcg
on
(
    mcg.institution_id = fmcg.institution_id
and mcg.mas_code_grp_id = fmcg.mas_code_grp_id
and mcg.qualify_mas_code = fmcg.qualify_mas_code
)
when not matched then insert
    (INSTITUTION_ID,
    MAS_CODE_GRP_ID,
    QUALIFY_MAS_CODE,
    MAS_CODE )
values
    (fmcg.INSTITUTION_ID,
    fmcg.MAS_CODE_GRP_ID,
    fmcg.QUALIFY_MAS_CODE,
    fmcg.MAS_CODE )
;


update mas_code_grp mcg
set mcg.MAS_CODE = (
    select fmcg.MAS_CODE
    from flmgr_mas_code_grp fmcg
    where
        (
            mcg.institution_id   = fmcg.institution_id
        and mcg.mas_code_grp_id  = fmcg.mas_code_grp_id
        and mcg.qualify_mas_code = fmcg.qualify_mas_code
        and mcg.mas_code        != fmcg.mas_code
        )
    )

where (mcg.institution_id, mcg.mas_code_grp_id, mcg.qualify_mas_code) in
    (select mcg2.institution_id, mcg2.mas_code_grp_id, mcg2.qualify_mas_code

    from flmgr_mas_code_grp fmcg2
    join mas_code_grp mcg2
    on
            mcg2.institution_id   = fmcg2.institution_id
        and mcg2.mas_code_grp_id  = fmcg2.mas_code_grp_id
        and mcg2.qualify_mas_code = fmcg2.qualify_mas_code
    where
         mcg2.mas_code        != fmcg2.mas_code
    )



;

select fmcg.* --, fir.* 
from flmgr_mas_code_grp fmcg join FLMGR_INTERCHANGE_RATES fir
on fmcg.QUALIFY_MAS_CODE = fir.MAS_CODE 
where fmcg.institution_id in ('101') 
--and fir.REGION in ('USA', 'ALL')

minus
select * from       mas_code_grp where institution_id  in ('101', '105', '107', '121') 
;
--commit;
