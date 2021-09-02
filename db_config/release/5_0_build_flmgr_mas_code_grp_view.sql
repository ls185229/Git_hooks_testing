REM Update mas_code_grp table from flmgr_interchange_rates table

REM $Id: 5_0_build_flmgr_mas_code_grp_view.sql 17 2016-10-25 15:22:05Z bjones $

CREATE OR REPLACE FORCE VIEW "MASCLR"."FLMGR_MAS_CODE_GRP" ("INSTITUTION_ID",
    "MAS_CODE_GRP_ID", "QUALIFY_MAS_CODE", "MAS_CODE")
AS
    SELECT  DISTINCT fl_mcg.institution_id, fl_mcg.mas_code_grp_id, fir_r.mas_code
            qualify_mas_code, fl_mcg.mas_code
        FROM
            ( 
               SELECT DISTINCT
                   mcg.institution_id, mcg.mas_code_grp_id, mcg.qualify_mas_code,
                   mcg.mas_code, fir.region
               FROM flmgr_interchange_rates fir
               JOIN mas_code_grp mcg
               ON fir.template_mas_code = mcg.QUALIFY_MAS_CODE
                   OR SUBSTR(fir.template_mas_code, 1, LENGTH(fir.template_mas_code) - 5) ||
                   'DISCOUNT' = mcg.QUALIFY_MAS_CODE
               join (
                   SELECT i.INSTITUTION_ID, c.CNTRY_CODE_ALPHA3
                   FROM institution i
                   INNER JOIN inst_address ia
                   ON ia.INSTITUTION_ID = i.INSTITUTION_ID
                   AND ia.ADDRESS_ROLE = 'LOC'
                   INNER JOIN master_address ma
                   ON ma.INSTITUTION_ID = ia.INSTITUTION_ID
                   AND ma.ADDRESS_ID   = ia.ADDRESS_ID
                   INNER JOIN COUNTRY c
                   ON ma.CNTRY_CODE = c.CNTRY_CODE
               ) i_c
               on i_c.INSTITUTION_ID = mcg.INSTITUTION_ID
               and fir.region in ('ALL', i_c.CNTRY_CODE_ALPHA3)
               
               WHERE fir.usage           = 'DEFAULT_DISCOUNT'
               
               ORDER BY mcg.institution_id, mcg.mas_code_grp_id, mas_code
            ) fl_mcg
        JOIN flmgr_interchange_rates fir_r
        ON
            (
                fl_mcg.QUALIFY_MAS_CODE = fir_r.template_mas_code
                OR SUBSTR(fir_r.template_mas_code, 1, LENGTH(fir_r.template_mas_code) - 5)
                || 'DISCOUNT' = fl_mcg.qualify_mas_code
            )
            AND fir_r.usage = 'DEFAULT_DISCOUNT'
            AND fl_mcg.region = fir_r.region
            /*
            -- where rownum < 5
            */
        --ORDER BY fir_r.mas_code, 1, 2, 3
        ;
