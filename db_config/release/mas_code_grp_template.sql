
-- $Id: mas_code_grp_template.sql 12 2016-10-20 21:31:41Z bjones $

SELECT DISTINCT
    mcg.institution_id, mcg.mas_code_grp_id, mcg.qualify_mas_code,
    mcg.mas_code
FROM flmgr_interchange_rates fir
JOIN mas_code_grp mcg
ON fir.template_mas_code = mcg.QUALIFY_MAS_CODE
    OR SUBSTR(fir.template_mas_code, 1, LENGTH(fir.template_mas_code) - 5) ||
    'DISCOUNT' = mcg.QUALIFY_MAS_CODE
--LEFT JOIN mas_code_grp_summary mcgs
--ON mcg.institution_id     = mcgs.institution_id
--    AND mcgs.mas_code_grp_id = mcg.mas_code_grp_id
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

ORDER BY mcg.institution_id, mcg.mas_code_grp_id, mas_code;
