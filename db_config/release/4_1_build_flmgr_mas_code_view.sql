REM

REM $Id: 4_1_build_flmgr_mas_code_view.sql 17 2016-10-25 15:22:05Z bjones $

CREATE OR REPLACE FORCE VIEW "MASCLR"."FLMGR_MAS_CODE" (
    "MAS_CODE", card_scheme, "MAS_DESC", ipf_prog_ind_desc)
AS
    SELECT  distinct fir.mas_code,
            fir.card_scheme,
            fir.mas_desc,
            null
    FROM
        flmgr_interchange_rates fir
    ORDER BY fir.mas_code;
