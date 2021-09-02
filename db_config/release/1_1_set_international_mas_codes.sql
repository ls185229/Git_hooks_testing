REM

REM $Id: 1_1_set_international_mas_codes.sql 17 2016-10-25 15:22:05Z bjones $


REM INSERTING into MAS_CODE
SET DEFINE OFF;

UPDATE "MASCLR"."MAS_CODE" SET CARD_SCHEME = '04' WHERE mas_code in ('0104VCRCNSR', '0104VCRCOMM') and card_scheme != '04';

delete  flmgr_ichg_rates_template where mas_code like '0102%' and card_scheme = '04';
delete  flmgr_interchange_rates   where mas_code like '0102%' and card_scheme = '04';

--update flmgr_ichg_rates_template set region = 'ALL' where mas_desc like '%INTL%' and region is null;
--update flmgr_interchange_rates   set region = 'ALL' where mas_desc like '%INTL%' and region is null;

update flmgr_ichg_rates_template set region = 'ALL' where mas_desc like '%INTL%' and mas_desc not like '%CAN%' and mas_desc not like '%US %' and region is null and card_scheme in ('04', '05');
update flmgr_interchange_rates   set region = 'ALL' where mas_desc like '%INTL%' and mas_desc not like '%CAN%' and mas_desc not like '%US %' and region is null and card_scheme in ('04', '05');
--update flmgr_ichg_rates_template set region = 'ALL' where mas_desc like '%INTL%' and mas_desc not like '%CAN%' and region is null;

update flmgr_ichg_rates_template set region = 'ALL' where card_scheme = '04' and fpi_ird like '9__' and region != 'ALL' ;
update flmgr_interchange_rates   set region = 'ALL' where card_scheme = '04' and fpi_ird like '9__' and region != 'ALL' ;
