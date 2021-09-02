
REM $Id: 0_4_remove_unused_mas_code_templates.sql 17 2016-10-25 15:22:05Z bjones $

/*

    remove revtrak mas_code templates

*/

delete FLMGR_INTERCHANGE_RATES where usage like 'REVTRAK%';
delete FLMGR_INTERCHANGE_RATES where mas_code = '105USUPT3';

update mas_fees
set fee_status = 'O'
where
    fee_status != 'O'
and (
    --    qualify_mas_code like '%\_RT\_BASE\_%' escape '\'
    --or
    mas_code like    'RT\_%'       escape '\'
)
;

delete mas_code_grp where qualify_mas_code like '%\_RT\_BASE\_%' escape '\';

-- delete mas_code     where         mas_code like '%\_RT\_BASE\_%' escape '\';

--update flmgr_interchange_rates
--mas_desc like '%INTL%'
