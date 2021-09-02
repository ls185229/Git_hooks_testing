REM Add  mas_codes that were listed with 0102 and card scheme 04

REM $Id: 0_7_add_mas_codes_0104_from_0102_card_schem_04.sql 17 2016-10-25 15:22:05Z bjones $


REM INSERTING into MAS_CODE
SET DEFINE OFF;


UPDATE "MASCLR"."MAS_CODE" SET CARD_SCHEME = '04' WHERE mas_code in ('0104VCRCNSR', '0104VCRCOMM') and card_scheme != '04';

--update flmgr_ichg_rates_template set region = 'ALL' where mas_desc like '%INTL%' and region is null;
--update flmgr_interchange_rates   set region = 'ALL' where mas_desc like '%INTL%' and region is null;


Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBBUS'       , '04', 'PIN AUTH DB BUS'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKREG'     , '04', 'US INTERLINK REG'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PAPPFUEL'      , '04', 'PIN AUTH PP FUEL'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PAPPSTKT'      , '04', 'PIN AUTH PP STKT'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBCV'        , '04', 'PIN AUTH DB CV'        , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKBUS'     , '04', 'INTERLINK BUS'         , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKMERRET'  , '04', 'INTLNK MER RETRN'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKTRVL'    , '04', 'ILK TVL SVC'           , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKTRVLPP'  , '04', 'ILK TVL SVC PP'        , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBFUEL'      , '04', 'PIN AUTH DB FUEL'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBRTL'       , '04', 'PIN AUTH DB RTL'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKCOMMPP'  , '04', 'INTERLINK COMM PP'     , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PACOMMPP'      , '04', 'PIN AUTH COMM PP'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104VMTFF'         , '04', 'VMT FAST FUNDS'        , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKSTDPP'   , '04', 'INTERLINK STD PP'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PAPPTRVL'      , '04', 'PINAUTH PP TRVL'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PAPPSMKT'      , '04', 'PIN AUTH PP SMKT'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKFUEL'    , '04', 'INTERLINK FUEL'        , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKIRREG'   , '04', 'IR REG INTLK'          , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKSTD'     , '04', 'INTERLINK STANDARD'    , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PAPPRTL'       , '04', 'PIN AUTH PP RTL'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKFUELPP'  , '04', 'INTRLNK FUEL PP'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKSUP'     , '04', 'INTERLINK SUPERMARKET' , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PPRLOAD'       , '04', 'VS Prepaid Reload'     , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBSMKT'      , '04', 'PIN AUTH DB SMKT'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBSTKT'      , '04', 'PIN AUTHDB STKT'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104INTLNKSPMKTPP' , '04', 'INTRLNK SPMKT PP'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PPALOAD'       , '04', 'PREPAID ATM LOAD'      , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBREG'       , '04', 'PIN AUTH DB REG'       , null);
Insert into MAS_CODE (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC) values ('0104PADBTRVL'      , '04', 'PIN AUTH DB TRVL'      , null);
commit;
