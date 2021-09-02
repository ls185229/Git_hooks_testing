REM

REM $Id: 4_4_flmgr_mas_code_merge.sql 17 2016-10-25 15:22:05Z bjones $

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

--commit;
