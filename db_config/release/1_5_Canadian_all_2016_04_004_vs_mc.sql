-- Number of arguments: 4 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'Canadian_Interchange_Fees_for_April_2016_(04-14-2016).xls', 'ALL', 'CAN']
rem gathering mas_codes from spreadsheet

--delete FLMGR_ICHG_RATES_TEMPLATE;


rem Discover


rem MasterCard


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPAY' , 'MC INTL PAYMENT' , 1 , 0.19 , 0.53 , null ,
    '20' , 'Consumer Credit Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPAY' , 'MC INTL PAYMENT' , 1 , null, null, null ,
    '20' , 'Consumer Credit Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ICPAY' , 'MC INTL CORP PAYMENT' , 1 , 0.19 , 0.53 , null ,
    '21' , 'Commercial Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ICPAY' , 'MC INTL CORP PAYMENT' , 1 , null, null, null ,
    '21' , 'Commercial Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMUCAF' , 'MC INTL MERCHANT UCAF' , 1 , 1.44 , 0.0 , null ,
    '24' , 'Consumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMUCAF' , 'MC INTL MERCHANT UCAF' , 1 , null, null, null ,
    '24' , 'Consumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDREWARDS' , 'MC CAN REWARDS' , 1 , 0.0 , 0.0 , null ,
    '2A' , 'Canada Intracountry MasterCard Initiated Rewards' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDREWARDS' , 'MC CAN REWARDS' , 1 , null, null, null ,
    '2A' , 'Canada Intracountry MasterCard Initiated Rewards' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNIREWARDS' , 'MC INTL REWARDS' , 1 , 0.0 , 0.0 , null ,
    '2A' , 'Canada Interregional MasterCard Initiated Rewards' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNIREWARDS' , 'MC INTL REWARDS' , 1 , null, null, null ,
    '2A' , 'Canada Interregional MasterCard Initiated Rewards' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOM' , 'MC CAN COMM' , 1 , 2.0 , 0.0 , null ,
    '40' , 'Canada Intracountry Commercial Programs' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOM' , 'MC CAN COMM' , 1 , null, null, null ,
    '40' , 'Canada Intracountry Commercial Programs' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSUPMKT' , 'MC CAN DB SUPMKT' , 1 , 0.15 , 0.05 , null ,
    '41' , 'Canada Intracountry Supermarket Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSUPMKT' , 'MC CAN DB SUPMKT' , 1 , null, null, null ,
    '41' , 'Canada Intracountry Supermarket Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1SUPMKT' , 'MC CAN DB 1 SUPMKT' , 1 , 0.0 , 0.0 , null ,
    '42' , 'Canada Intracountry Supermarket Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1SUPMKT' , 'MC CAN DB 1 SUPMKT' , 1 , null, null, null ,
    '42' , 'Canada Intracountry Supermarket Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2SUPMKT' , 'MC CAN DB 2 SUPMKT' , 1 , 0.0 , 0.0 , null ,
    '43' , 'Canada Intracountry Supermarket Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2SUPMKT' , 'MC CAN DB 2 SUPMKT' , 1 , null, null, null ,
    '43' , 'Canada Intracountry Supermarket Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBBOX' , 'MC CAN DB BBOX' , 1 , 0.25 , 0.05 , null ,
    '44' , 'Canada Intracountry Big Box Stores Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBBOX' , 'MC CAN DB BBOX' , 1 , null, null, null ,
    '44' , 'Canada Intracountry Big Box Stores Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1BBOX' , 'MC CAN DB 1 BBOX' , 1 , 0.0 , 0.0 , null ,
    '45' , 'Canada Intracountry Big Box Stores Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1BBOX' , 'MC CAN DB 1 BBOX' , 1 , null, null, null ,
    '45' , 'Canada Intracountry Big Box Stores Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2BBOX' , 'MC CAN DB 2 BBOX' , 1 , 0.0 , 0.0 , null ,
    '46' , 'Canada Intracountry Big Box Stores Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2BBOX' , 'MC CAN DB 2 BBOX' , 1 , null, null, null ,
    '46' , 'Canada Intracountry Big Box Stores Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDPETR' , 'MC CAN DB PETR' , 1 , 0.15 , 0.05 , null ,
    '47' , 'Canada Intracountry Petroleum Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDPETR' , 'MC CAN DB PETR' , 1 , null, null, null ,
    '47' , 'Canada Intracountry Petroleum Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMCELCARDCRP' , 'MC ELEC CARD COMM' , 1 , 1.85 , 0.0 , null ,
    '47' , 'Commercial Electronic Card - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMCELCARDCRP' , 'MC ELEC CARD COMM' , 1 , null, null, null ,
    '47' , 'Commercial Electronic Card - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1PETR' , 'MC CAN DB 1 PETR' , 1 , 0.0 , 0.0 , null ,
    '48' , 'Canada Intracountry Petroleum Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1PETR' , 'MC CAN DB 1 PETR' , 1 , null, null, null ,
    '48' , 'Canada Intracountry Petroleum Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2PETR' , 'MC CAN DB 2 PETR' , 1 , 0.0 , 0.0 , null ,
    '49' , 'Canada Intracountry Petroleum Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2PETR' , 'MC CAN DB 2 PETR' , 1 , null, null, null ,
    '49' , 'Canada Intracountry Petroleum Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSPCCLTH' , 'MC CAN DB SPCCLTH' , 1 , 0.25 , 0.05 , null ,
    '50' , 'Canada Intracountry Specialty Clothing Stores Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSPCCLTH' , 'MC CAN DB SPCCLTH' , 1 , null, null, null ,
    '50' , 'Canada Intracountry Specialty Clothing Stores Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1SPCCLTH' , 'MC CAN DB 1 SPCCLTH' , 1 , 0.0 , 0.0 , null ,
    '51' , 'Canada Intracountry Specialty Clothing Stores Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1SPCCLTH' , 'MC CAN DB 1 SPCCLTH' , 1 , null, null, null ,
    '51' , 'Canada Intracountry Specialty Clothing Stores Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2SPCCLTH' , 'MC CAN DB 2 SPCCLTH' , 1 , 0.0 , 0.0 , null ,
    '52' , 'Canada Intracountry Specialty Clothing Stores Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2SPCCLTH' , 'MC CAN DB 2 SPCCLTH' , 1 , null, null, null ,
    '52' , 'Canada Intracountry Specialty Clothing Stores Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDECOMM' , 'MC CAN DB ECOMM' , 1 , 1.15 , 0.0 , null ,
    '53' , 'Canada Intracountry Standard and Non-SecureCode-enabled E-commerce (De' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDECOMM' , 'MC CAN DB ECOMM' , 1 , null, null, null ,
    '53' , 'Canada Intracountry Standard and Non-SecureCode-enabled E-commerce (De' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSECECOMM' , 'MC CAN DB SEC ECOMM' , 1 , 1.0 , 0.0 , null ,
    '54' , 'Canada Intracountry Standard SecureCode-enabled (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDSECECOMM' , 'MC CAN DB SEC ECOMM' , 1 , null, null, null ,
    '54' , 'Canada Intracountry Standard SecureCode-enabled (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDOTHR' , 'MC CAN DB OTHR' , 1 , 0.25 , 0.05 , null ,
    '55' , 'Canada Intracountry Other Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDOTHR' , 'MC CAN DB OTHR' , 1 , null, null, null ,
    '55' , 'Canada Intracountry Other Base (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1OTHR' , 'MC CAN DB 1 OTHR' , 1 , 0.0 , 0.0 , null ,
    '56' , 'Canada Intracountry Other Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND1OTHR' , 'MC CAN DB 1 OTHR' , 1 , null, null, null ,
    '56' , 'Canada Intracountry Other Tier 1 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2OTHR' , 'MC CAN DB 2 OTHR' , 1 , 0.0 , 0.0 , null ,
    '58' , 'Canada Intracountry Other Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CND2OTHR' , 'MC CAN DB 2 OTHR' , 1 , null, null, null ,
    '58' , 'Canada Intracountry Other Tier 2 (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBEMS' , 'MC CAN DB EMERG SEC' , 1 , 0.3 , 0.0 , null ,
    '59' , 'Canada Intracountry Emerging Sectors (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBEMS' , 'MC CAN DB EMERG SEC' , 1 , null, null, null ,
    '59' , 'Canada Intracountry Emerging Sectors (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRA' , 'MC CAN RATE A' , 1 , 1.36 , 0.0 , null ,
    '61' , 'Canada Intracountry Consumer Credit Core Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRA' , 'MC CAN RATE A' , 1 , null, null, null ,
    '61' , 'Canada Intracountry Consumer Credit Core Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ICORP' , 'MC INTL CORPORATE' , 1 , 2.0 , 0.0 , null ,
    '61' , 'Commercial Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ICORP' , 'MC INTL CORPORATE' , 1 , null, null, null ,
    '61' , 'Commercial Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRB' , 'MC CAN RATE B' , 1 , 1.41 , 0.0 , null ,
    '62' , 'Canada Intracountry Consumer Credit Core Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRB' , 'MC CAN RATE B' , 1 , null, null, null ,
    '62' , 'Canada Intracountry Consumer Credit Core Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPLT' , 'MC INTL PURCH LARGE TICKET' , 1 , 0.9 , 30.0 , null ,
    '62' , 'Commercial Purchasing Large Ticket - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPLT' , 'MC INTL PURCH LARGE TICKET' , 1 , null, null, null ,
    '62' , 'Commercial Purchasing Large Ticket - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRA' , 'MC CAN HS RATE A' , 1 , 1.48 , 0.0 , null ,
    '63' , 'Canada Intracountry Consumer Credit World Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRA' , 'MC CAN HS RATE A' , 1 , null, null, null ,
    '63' , 'Canada Intracountry Consumer Credit World Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPURC' , 'MC INTL PURCHASING' , 1 , 2.0 , 0.0 , null ,
    '63' , 'Commercial Purchasing Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPURC' , 'MC INTL PURCHASING' , 1 , null, null, null ,
    '63' , 'Commercial Purchasing Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRB' , 'MC CAN HS RATE B' , 1 , 1.53 , 0.0 , null ,
    '64' , 'Canada Intracountry Consumer Credit World Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRB' , 'MC CAN HS RATE B' , 1 , null, null, null ,
    '64' , 'Canada Intracountry Consumer Credit World Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRA' , 'MC CAN PHS RATE A' , 1 , 1.96 , 0.0 , null ,
    '65' , 'Canada Intracountry Consumer Credit World Elite Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRA' , 'MC CAN PHS RATE A' , 1 , null, null, null ,
    '65' , 'Canada Intracountry Consumer Credit World Elite Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRB' , 'MC CAN PHS RATE B' , 1 , 1.96 , 0.0 , null ,
    '66' , 'Canada Intracountry Consumer Credit World Elite Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRB' , 'MC CAN PHS RATE B' , 1 , null, null, null ,
    '66' , 'Canada Intracountry Consumer Credit World Elite Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPAYPASS' , 'MC CAN PAYPASS' , 1 , 0.0 , 0.05 , null ,
    '67' , 'Canada Intracountry Consumer Credit Core Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPAYPASS' , 'MC CAN PAYPASS' , 1 , null, null, null ,
    '67' , 'Canada Intracountry Consumer Credit Core Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPDR2' , 'MC INTL PURCH DATA RATE II' , 1 , 1.7 , 0.0 , null ,
    '67' , 'Commercial Purchasing Data Rate II - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPDR2' , 'MC INTL PURCH DATA RATE II' , 1 , null, null, null ,
    '67' , 'Commercial Purchasing Data Rate II - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSPAYPASS' , 'MC CAN HS PAYPASS' , 1 , 0.0 , 0.06 , null ,
    '68' , 'Canada Intracountry Consumer Credit World Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSPAYPASS' , 'MC CAN HS PAYPASS' , 1 , null, null, null ,
    '68' , 'Canada Intracountry Consumer Credit World Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSPAYPASS' , 'MC CAN PHS PAYPASS' , 1 , 0.0 , 0.07 , null ,
    '69' , 'Canada Intracountry Consumer Credit World Elite Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSPAYPASS' , 'MC CAN PHS PAYPASS' , 1 , null, null, null ,
    '69' , 'Canada Intracountry Consumer Credit World Elite Contactless' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCSTD' , 'MC CAN STD' , 1 , 1.61 , 0.0 , null ,
    '70' , 'Canada Intracountry Consumer Credit Core Standard' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCSTD' , 'MC CAN STD' , 1 , null, null, null ,
    '70' , 'Canada Intracountry Consumer Credit Core Standard' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCELEC' , 'MC CAN ELEC' , 1 , 1.49 , 0.0 , null ,
    '71' , 'Canada Intracountry Consumer Credit Core Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCELEC' , 'MC CAN ELEC' , 1 , null, null, null ,
    '71' , 'Canada Intracountry Consumer Credit Core Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCSUPMKT' , 'MC CAN SUPMKT' , 1 , 1.32 , 0.0 , null ,
    '72' , 'Canada Intracountry Consumer Credit Core Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCSUPMKT' , 'MC CAN SUPMKT' , 1 , null, null, null ,
    '72' , 'Canada Intracountry Consumer Credit Core Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPETR' , 'MC CAN PETR' , 1 , 1.17 , 0.0 , null ,
    '73' , 'Canada Intracountry Consumer Credit Core Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPETR' , 'MC CAN PETR' , 1 , null, null, null ,
    '73' , 'Canada Intracountry Consumer Credit Core Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105UIEI' , 'MC INTL US ELECTRONIC' , 1 , 1.1 , 0.0 , null ,
    '73' , 'Consumer Credit Electronic US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105UIEI' , 'MC INTL US ELECTRONIC' , 1 , null, null, null ,
    '73' , 'Consumer Credit Electronic US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVSUPMKT' , 'MC CAN HV SUPMKT' , 1 , 1.32 , 0.0 , null ,
    '74' , 'Canada Intracountry Consumer Credit Core Supermarket (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVSUPMKT' , 'MC CAN HV SUPMKT' , 1 , null, null, null ,
    '74' , 'Canada Intracountry Consumer Credit Core Supermarket (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMCELCARDCS' , 'MC ELEC CARD CONS' , 1 , 1.1 , 0.0 , null ,
    '74' , 'Consumer Credit Electronic Card US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IMCELCARDCS' , 'MC ELEC CARD CONS' , 1 , null, null, null ,
    '74' , 'Consumer Credit Electronic Card US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVPETR' , 'MC CAN HV PETR' , 1 , 1.17 , 0.0 , null ,
    '75' , 'Canada Intracountry Consumer Credit Core Petroleum (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVPETR' , 'MC CAN HV PETR' , 1 , null, null, null ,
    '75' , 'Canada Intracountry Consumer Credit Core Petroleum (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105UISTD' , 'MC INTL US STANDARD' , 1 , 1.6 , 0.0 , null ,
    '75' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105UISTD' , 'MC INTL US STANDARD' , 1 , null, null, null ,
    '75' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRCUR' , 'MC CAN RCUR' , 1 , 1.36 , 0.0 , null ,
    '76' , 'Canada Intracountry Consumer Credit Core Recurring Payment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRCUR' , 'MC CAN RCUR' , 1 , null, null, null ,
    '76' , 'Canada Intracountry Consumer Credit Core Recurring Payment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRSEC' , 'MC CAN RSEC' , 1 , 1.61 , 0.0 , null ,
    '77' , 'Canada Intracountry Consumer Credit Core SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRSEC' , 'MC CAN RSEC' , 1 , null, null, null ,
    '77' , 'Canada Intracountry Consumer Credit Core SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IFUCAF' , 'MC INTL FULL UCAF' , 1 , 1.54 , 0.0 , null ,
    '79' , 'Cosumer Credit Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IFUCAF' , 'MC INTL FULL UCAF' , 1 , null, null, null ,
    '79' , 'Cosumer Credit Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSTD' , 'MC CAN HS STD' , 1 , 1.89 , 0.0 , null ,
    '80' , 'Canada Intracountry Consumer Credit World Standard' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSTD' , 'MC CAN HS STD' , 1 , null, null, null ,
    '80' , 'Canada Intracountry Consumer Credit World Standard' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSELEC' , 'MC CAN HS ELEC' , 1 , 1.77 , 0.0 , null ,
    '81' , 'Canada Intracountry Consumer Credit World Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSELEC' , 'MC CAN HS ELEC' , 1 , null, null, null ,
    '81' , 'Canada Intracountry Consumer Credit World Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSUPMKT' , 'MC CAN HS SUPMKT' , 1 , 1.44 , 0.0 , null ,
    '82' , 'Canada Intracountry Consumer Credit World Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSUPMKT' , 'MC CAN HS SUPMKT' , 1 , null, null, null ,
    '82' , 'Canada Intracountry Consumer Credit World Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSPETR' , 'MC CAN HS PETR' , 1 , 1.3 , 0.0 , null ,
    '83' , 'Canada Intracountry Consumer Credit World Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSPETR' , 'MC CAN HS PETR' , 1 , null, null, null ,
    '83' , 'Canada Intracountry Consumer Credit World Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , 1.1 , 0.0 , null ,
    '83' , 'Consumer Electronic Payment - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , null, null, null ,
    '83' , 'Consumer Electronic Payment - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSHVSUPMKT' , 'MC CAN HS HV SUPMKT' , 1 , 1.44 , 0.0 , null ,
    '84' , 'Canada Intracountry Consumer Credit World Supermarket (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSHVSUPMKT' , 'MC CAN HS HV SUPMKT' , 1 , null, null, null ,
    '84' , 'Canada Intracountry Consumer Credit World Supermarket (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSHVPETR' , 'MC CAN HS HV PETR' , 1 , 1.3 , 0.0 , null ,
    '85' , 'Canada Intracountry Consumer Credit World Petroleum (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSHVPETR' , 'MC CAN HS HV PETR' , 1 , null, null, null ,
    '85' , 'Canada Intracountry Consumer Credit World Petroleum (High Volume)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null ,
    '85' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , null, null, null ,
    '85' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRCUR' , 'MC CAN HS RCUR' , 1 , 1.48 , 0.0 , null ,
    '86' , 'Canada Intracountry Consumer Credit World Recurring Payment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSRCUR' , 'MC CAN HS RCUR' , 1 , null, null, null ,
    '86' , 'Canada Intracountry Consumer Credit World Recurring Payment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSEC' , 'MC CAN HS SEC' , 1 , 1.89 , 0.0 , null ,
    '87' , 'Canada Intracountry Consumer Credit World SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSSEC' , 'MC CAN HS SEC' , 1 , null, null, null ,
    '87' , 'Canada Intracountry Consumer Credit World SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSTD' , 'MC CAN PHS STD' , 1 , 2.49 , 0.0 , null ,
    '90' , 'Canada Intracountry Consumer Credit World Elite Standard' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSTD' , 'MC CAN PHS STD' , 1 , null, null, null ,
    '90' , 'Canada Intracountry Consumer Credit World Elite Standard' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSELEC' , 'MC CAN PHS ELEC' , 1 , 2.12 , 0.0 , null ,
    '91' , 'Canada Intracountry Consumer Credit World Elite Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSELEC' , 'MC CAN PHS ELEC' , 1 , null, null, null ,
    '91' , 'Canada Intracountry Consumer Credit World Elite Electronic' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSUPMKT' , 'MC CAN PHS SUPMKT' , 1 , 1.96 , 0.0 , null ,
    '92' , 'Canada Intracountry Consumer Credit World Elite Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSUPMKT' , 'MC CAN PHS SUPMKT' , 1 , null, null, null ,
    '92' , 'Canada Intracountry Consumer Credit World Elite Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSPETR' , 'MC CAN PHS PETR' , 1 , 1.96 , 0.0 , null ,
    '93' , 'Canada Intracountry Consumer Credit World Elite Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSPETR' , 'MC CAN PHS PETR' , 1 , null, null, null ,
    '93' , 'Canada Intracountry Consumer Credit World Elite Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSHVSUPMKT' , 'MC CAN PHS HV SUPMKT' , 1 , 1.96 , 0.0 , null ,
    '94' , 'Canada Intracountry Consumer Credit World Elite Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSHVSUPMKT' , 'MC CAN PHS HV SUPMKT' , 1 , null, null, null ,
    '94' , 'Canada Intracountry Consumer Credit World Elite Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSHVPETR' , 'MC CAN PHS HV PETR' , 1 , 1.96 , 0.0 , null ,
    '95' , 'Canada Intracountry Consumer Credit World Elite Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSHVPETR' , 'MC CAN PHS HV PETR' , 1 , null, null, null ,
    '95' , 'Canada Intracountry Consumer Credit World Elite Petroleum' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRCUR' , 'MC CAN PHS RCUR' , 1 , 1.96 , 0.0 , null ,
    '96' , 'Canada Intracountry Consumer Credit World Elite Recurring' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSRCUR' , 'MC CAN PHS RCUR' , 1 , null, null, null ,
    '96' , 'Canada Intracountry Consumer Credit World Elite Recurring' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSEC' , 'MC CAN PHS SEC' , 1 , 2.49 , 0.0 , null ,
    '97' , 'Canada Intracountry Consumer Credit World Elite SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSSEC' , 'MC CAN PHS SEC' , 1 , null, null, null ,
    '97' , 'Canada Intracountry Consumer Credit World Elite SecureCode-enabled' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBES' , 'MC CAN IND BUS' , 1 , 1.44 , 0.0 , null ,
    'B1' , 'Canada Intracountry Consumer Credit Core Independent Business' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBES' , 'MC CAN IND BUS' , 1 , null, null, null ,
    'B1' , 'Canada Intracountry Consumer Credit Core Independent Business' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBESHS' , 'MC CAN HS IND BUS' , 1 , 1.56 , 0.0 , null ,
    'B2' , 'Canada Intracountry Consumer Credit World Independent Business' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBESHS' , 'MC CAN HS IND BUS' , 1 , null, null, null ,
    'B2' , 'Canada Intracountry Consumer Credit World Independent Business' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBESPHS' , 'MC CAN PHS IND BUS' , 1 , 2.0 , 0.0 , null ,
    'B3' , 'Canada Intracountry Consumer Credit World Elite Independent' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCINBESPHS' , 'MC CAN PHS IND BUS' , 1 , null, null, null ,
    'B3' , 'Canada Intracountry Consumer Credit World Elite Independent' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMHSRB' , 'MC CAN COM HS RATE B' , 1 , 2.0 , 0.0 , null ,
    'BB' , 'Canada Intracountry Commercial Premium High Spend Business Rate B' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMHSRB' , 'MC CAN COM HS RATE B' , 1 , null, null, null ,
    'BB' , 'Canada Intracountry Commercial Premium High Spend Business Rate B' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDR1' , 'MC CAN COM DR1' , 1 , 1.8 , 0.0 , null ,
    'BQ' , 'Canada Intracountry Commercial Data Rate I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDR1' , 'MC CAN COM DR1' , 1 , null, null, null ,
    'BQ' , 'Canada Intracountry Commercial Data Rate I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDR2' , 'MC CAN COM DR2' , 1 , 1.4 , 0.0 , null ,
    'BR' , 'Canada Intracountry Commercial Data Rate II' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDR2' , 'MC CAN COM DR2' , 1 , null, null, null ,
    'BR' , 'Canada Intracountry Commercial Data Rate II' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDLT' , 'MC CAN COM LT' , 1 , 1.2 , 0.0 , null ,
    'BS' , 'Canada Intracountry Commercial Large Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMDLT' , 'MC CAN COM LT' , 1 , null, null, null ,
    'BS' , 'Canada Intracountry Commercial Large Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCCH' , 'MC CAN CHARITY' , 1 , 1.0 , 0.0 , null ,
    'C2' , 'Canada Intracountry Consumer Credit Core Charity' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCCH' , 'MC CAN CHARITY' , 1 , null, null, null ,
    'C2' , 'Canada Intracountry Consumer Credit Core Charity' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSCH' , 'MC CAN HS CHARITY' , 1 , 1.25 , 0.0 , null ,
    'C3' , 'Canada Intracountry Consumer Credit World Charity' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSCH' , 'MC CAN HS CHARITY' , 1 , null, null, null ,
    'C3' , 'Canada Intracountry Consumer Credit World Charity' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSCH' , 'MC CAN PHS CHARITY' , 1 , 1.5 , 0.0 , null ,
    'C4' , 'Canada Intracountry Consumer Credit World Elite Charity' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSCH' , 'MC CAN PHS CHARITY' , 1 , null, null, null ,
    'C4' , 'Canada Intracountry Consumer Credit World Elite Charity' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBCH' , 'MC CAN DEBIT CHARITY' , 1 , 0.3 , 0.0 , null ,
    'C5' , 'Canada Intracountry Consumer Credit World Elite Charity' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBCH' , 'MC CAN DEBIT CHARITY' , 1 , null, null, null ,
    'C5' , 'Canada Intracountry Consumer Credit World Elite Charity' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMCH' , 'MC CAN COM CHARITY' , 1 , 1.8 , 0.0 , null ,
    'CC' , 'Canada Intracountry Commercial Charity' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMCH' , 'MC CAN COM CHARITY' , 1 , null, null, null ,
    'CC' , 'Canada Intracountry Commercial Charity' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBRCUR' , 'MC CAN DEBIT RCUR' , 1 , 0.6 , 0.0 , null ,
    'CR' , 'Canada Intracountry Consumer Recurring Payments (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBRCUR' , 'MC CAN DEBIT RCUR' , 1 , null, null, null ,
    'CR' , 'Canada Intracountry Consumer Recurring Payments (Debit)' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKT' , 'MC CAN SUPMKT T1' , 1 , 1.22 , 0.0 , null ,
    'D1' , 'Canada Intracountry Consumer Credit Core Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKT' , 'MC CAN SUPMKT T1' , 1 , null, null, null ,
    'D1' , 'Canada Intracountry Consumer Credit Core Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKTHS' , 'MC CAN HS SUPMKT T1' , 1 , 1.34 , 0.0 , null ,
    'D2' , 'Canada Intracountry Consumer Credit World Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKTHS' , 'MC CAN HS SUPMKT T1' , 1 , null, null, null ,
    'D2' , 'Canada Intracountry Consumer Credit World Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKTPHS' , 'MC CAN PHS SUPMKT T1' , 1 , 1.96 , 0.0 , null ,
    'D3' , 'Canada Intracountry Consumer Credit World Elite Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1SMKTPHS' , 'MC CAN PHS SUPMKT T1' , 1 , null, null, null ,
    'D3' , 'Canada Intracountry Consumer Credit World Elite Tier 1 Supermarket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCEMS' , 'MC CAN EMERG SEC' , 1 , 1.0 , 0.0 , null ,
    'E7' , 'Canada Intracountry Consumer Credit Core Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCEMS' , 'MC CAN EMERG SEC' , 1 , null, null, null ,
    'E7' , 'Canada Intracountry Consumer Credit Core Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSEMS' , 'MC CAN HS EMERG SEC' , 1 , 1.25 , 0.0 , null ,
    'E8' , 'Canada Intracountry Consumer Credit World Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSEMS' , 'MC CAN HS EMERG SEC' , 1 , null, null, null ,
    'E8' , 'Canada Intracountry Consumer Credit World Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSEMS' , 'MC CAN PHS EMERG SEC' , 1 , 1.5 , 0.0 , null ,
    'E9' , 'Canada Intracountry Consumer Credit World Elite Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCPHSEMS' , 'MC CAN PHS EMERG SEC' , 1 , null, null, null ,
    'E9' , 'Canada Intracountry Consumer Credit World Elite Emerging Sectors' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCACH' , 'MC INTL SUPER PREM ACQ CHIP' , 1 , 1.98 , 0.0 , null ,
    'EA' , 'Consumer Super Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCACH' , 'MC INTL SUPER PREM ACQ CHIP' , 1 , null, null, null ,
    'EA' , 'Consumer Super Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSEI' , 'MC INTL CONS SUPERPREM ELEC' , 1 , 1.98 , 0.0 , null ,
    'EE' , 'Consumer Super Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSEI' , 'MC INTL CONS SUPERPREM ELEC' , 1 , null, null, null ,
    'EE' , 'Consumer Super Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSFUCAF' , 'MC INTL CONS SUPERPREM FULUCAF' , 1 , 1.98 , 0.0 , null ,
    'EF' , 'Consumer Super Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSFUCAF' , 'MC INTL CONS SUPERPREM FULUCAF' , 1 , null, null, null ,
    'EF' , 'Consumer Super Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCICH' , 'MC INTL SUPER PREM ISS CHIP' , 1 , 1.98 , 0.0 , null ,
    'EI' , 'Consumer Super Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCICH' , 'MC INTL SUPER PREM ISS CHIP' , 1 , null, null, null ,
    'EI' , 'Consumer Super Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSMUCAF' , 'MC INTL CONS SUPERPREM MERUCAF' , 1 , 1.98 , 0.0 , null ,
    'EM' , 'Consumer Super Premium Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSMUCAF' , 'MC INTL CONS SUPERPREM MERUCAF' , 1 , null, null, null ,
    'EM' , 'Consumer Super Premium Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSSTD' , 'MC INTL CONS SUPERPREM STD' , 1 , 1.98 , 0.0 , null ,
    'ES' , 'Consumer Super Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105ISPCSSTD' , 'MC INTL CONS SUPERPREM STD' , 1 , null, null, null ,
    'ES' , 'Consumer Super Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMREBATE' , 'MC CAN COM REBATE' , 1 , 0.0 , 0.0 , null ,
    'EZ' , 'Canada Intracountry Commercial Rebate' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMREBATE' , 'MC CAN COM REBATE' , 1 , null, null, null ,
    'EZ' , 'Canada Intracountry Commercial Rebate' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IREBATE' , 'MC INTL COMMERCIAL REBATE' , 1 , 0.0 , 0.0 , null ,
    'EZ' , 'Interregional Rebate' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IREBATE' , 'MC INTL COMMERCIAL REBATE' , 1 , null, null, null ,
    'EZ' , 'Interregional Rebate' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRMPASS' , 'MC CAN CREDIT MPASS' , 1 , 1.61 , 0.0 , null ,
    'G1' , 'Canada Intracountry Consumer Credit Core MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCRMPASS' , 'MC CAN CREDIT MPASS' , 1 , null, null, null ,
    'G1' , 'Canada Intracountry Consumer Credit Core MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVMPASS' , 'MC CAN HIGH SPEND MPASS' , 1 , 1.89 , 0.0 , null ,
    'G2' , 'Canada Intracountry Consumer Credit High Spend MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHVMPASS' , 'MC CAN HIGH SPEND MPASS' , 1 , null, null, null ,
    'G2' , 'Canada Intracountry Consumer Credit High Spend MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSMPASS' , 'MC CAN PREM HIGH SPEND MPASS' , 1 , 2.49 , 0.0 , null ,
    'G3' , 'Canada Intracountry Consumer Credit Premium High Spend MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCHSMPASS' , 'MC CAN PREM HIGH SPEND MPASS' , 1 , null, null, null ,
    'G3' , 'Canada Intracountry Consumer Credit Premium High Spend MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBMPASS' , 'MC CAN DEBIT MPASS' , 1 , 1.0 , 0.0 , null ,
    'G4' , 'Canada Intracountry Consumer Debit MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNDBMPASS' , 'MC CAN DEBIT MPASS' , 1 , null, null, null ,
    'G4' , 'Canada Intracountry Consumer Debit MasterPass' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCOMSTD' , 'MC INTL COMM PREM STANDARD' , 1 , 2.0 , 0.0 , null ,
    'IP' , 'Commercial Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCOMSTD' , 'MC INTL COMM PREM STANDARD' , 1 , null, null, null ,
    'IP' , 'Commercial Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1' , 'MC CAN T1' , 1 , 1.26 , 0.0 , null ,
    'J1' , 'Canada Intracountry Consumer Credit Core Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1' , 'MC CAN T1' , 1 , null, null, null ,
    'J1' , 'Canada Intracountry Consumer Credit Core Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1HS' , 'MC CAN HS T1' , 1 , 1.38 , 0.0 , null ,
    'J2' , 'Canada Intracountry Consumer Credit World Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1HS' , 'MC CAN HS T1' , 1 , null, null, null ,
    'J2' , 'Canada Intracountry Consumer Credit World Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1PHS' , 'MC CAN PHS T1' , 1 , 1.96 , 0.0 , null ,
    'J3' , 'Canada Intracountry Consumer Credit World Elite Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCVT1PHS' , 'MC CAN PHS T1' , 1 , null, null, null ,
    'J3' , 'Canada Intracountry Consumer Credit World Elite Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPD' , 'MC REG POS DB' , 1 , 0.05 , 0.21 , null ,
    'LD' , 'Regulated POS Debit' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPD' , 'MC REG POS DB' , 1 , null, null, null ,
    'LD' , 'Regulated POS Debit' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDFA' , 'MC REG POS DB W FRAUD ADJ' , 1 , 0.05 , 0.22 , null ,
    'LF' , 'Regulated POS Debit with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDFA' , 'MC REG POS DB W FRAUD ADJ' , 1 , null, null, null ,
    'LF' , 'Regulated POS Debit with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDSM' , 'MC REG POS DB ST BASE' , 1 , 0.05 , 0.21 , null ,
    'LS' , 'Regulated POS Debit Small Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDSM' , 'MC REG POS DB ST BASE' , 1 , null, null, null ,
    'LS' , 'Regulated POS Debit Small Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDSMT1' , 'MC REG POS DB ST TIER 1' , 1 , 0.05 , 0.22 , null ,
    'LT' , 'Regulated POS Debit Small Ticket with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105URPDSMT1' , 'MC REG POS DB ST TIER 1' , 1 , null, null, null ,
    'LT' , 'Regulated POS Debit Small Ticket with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMONSND' , 'MC CAN COM MONSND' , 1 , 0.0 , 0.0 , null ,
    'MS' , 'Canada Intracountry MasterCard MoneySend' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105CNCOMMONSND' , 'MC CAN COM MONSND' , 1 , null, null, null ,
    'MS' , 'Canada Intracountry MasterCard MoneySend' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105MONSND' , 'MC MONEYSEND PAYMENT' , 1 , 0.0 , 0.0 , null ,
    'MS' , 'MoneySend Payment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105MONSND' , 'MC MONEYSEND PAYMENT' , 1 , null, null, null ,
    'MS' , 'MoneySend Payment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSACH' , 'MC INTL CONS ACQ CHIP' , 1 , 1.85 , 0.0 , null ,
    'PA' , 'Consumer Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSACH' , 'MC INTL CONS ACQ CHIP' , 1 , null, null, null ,
    'PA' , 'Consumer Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSEI' , 'MC INTL CONS PREM ELECTRONIC' , 1 , 1.85 , 0.0 , null ,
    'PE' , 'Consumer Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSEI' , 'MC INTL CONS PREM ELECTRONIC' , 1 , null, null, null ,
    'PE' , 'Consumer Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSFUCAF' , 'MC INTL CONS PREM FULL UCAF' , 1 , 1.85 , 0.0 , null ,
    'PF' , 'Consumer Credit Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSFUCAF' , 'MC INTL CONS PREM FULL UCAF' , 1 , null, null, null ,
    'PF' , 'Consumer Credit Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSICH' , 'MC INTL CONS ISS CHIP' , 1 , 1.85 , 0.0 , null ,
    'PI' , 'Consumer Credit Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSICH' , 'MC INTL CONS ISS CHIP' , 1 , null, null, null ,
    'PI' , 'Consumer Credit Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSMUCAF' , 'MC INTL CONS PREM MERCH UCAF' , 1 , 1.85 , 0.0 , null ,
    'PM' , 'Consumer Credit Merchant UCAF Premium - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSMUCAF' , 'MC INTL CONS PREM MERCH UCAF' , 1 , null, null, null ,
    'PM' , 'Consumer Credit Merchant UCAF Premium - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSSTD' , 'MC INTL CONS PREM STANDARD' , 1 , 1.85 , 0.0 , null ,
    'PS' , 'Consumer Credit Standard - Premium' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0105IPCSSTD' , 'MC INTL CONS PREM STANDARD' , 1 , null, null, null ,
    'PS' , 'Consumer Credit Standard - Premium' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );

rem Visa


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCONSTD' , 'VS STANDARD' , 1 , 1.6 , 0.0 , null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCONSTD' , 'VS STANDARD' , 1 , null, null, null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ISTD' , 'VS STANDARD' , 1 , 1.6 , 0.0 , null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ISTD' , 'VS STANDARD' , 1 , null, null, null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSTD' , 'Cons Std' , 1 , 1.6 , 0.0 , null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSTD' , 'Cons Std' , 1 , null, null, null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTSTANDARD' , 'Cons Std' , 1 , 1.6 , 0.0 , null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTSTANDARD' , 'Cons Std' , 1 , null, null, null ,
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASEIRF' , 'VS INTL PRE PS2000' , 1 , 1.1 , 0.0 , null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASEIRF' , 'VS INTL PRE PS2000' , 1 , null, null, null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPS2' , 'VS INTL PRE PS2000' , 1 , 1.1 , 0.0 , null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPS2' , 'VS INTL PRE PS2000' , 1 , null, null, null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCEIRF' , 'Electronic' , 1 , 1.1 , 0.0 , null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCEIRF' , 'Electronic' , 1 , null, null, null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTINTLPREPS2000' , 'PS2000' , 1 , 1.1 , 0.0 , null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTINTLPREPS2000' , 'PS2000' , 1 , null, null, null ,
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104INFC' , 'VS INFINITE CR' , 1 , 1.97 , 0.0 , null ,
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104INFC' , 'VS INFINITE CR' , 1 , null, null, null ,
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCINF' , 'Infinite' , 1 , 1.97 , 0.0 , null ,
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCINF' , 'Infinite' , 1 , null, null, null ,
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IBUS' , 'VS COMCL BUS' , 1 , 2.0 , 0.0 , null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IBUS' , 'VS COMCL BUS' , 1 , null, null, null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCBUS' , 'Business' , 1 , 2.0 , 0.0 , null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCBUS' , 'Business' , 1 , null, null, null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLBUS' , 'Business' , 1 , 2.0 , 0.0 , null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLBUS' , 'Business' , 1 , null, null, null ,
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICOR' , 'VS COMCL CORP' , 1 , 2.0 , 0.0 , null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICOR' , 'VS COMCL CORP' , 1 , null, null, null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCORP' , 'Corporate' , 1 , 2.0 , 0.0 , null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCORP' , 'Corporate' , 1 , null, null, null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLCORP' , 'Corporate' , 1 , 2.0 , 0.0 , null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLCORP' , 'Corporate' , 1 , null, null, null ,
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPUR' , 'VS COMCL PURCH' , 1 , 2.0 , 0.0 , null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPUR' , 'VS COMCL PURCH' , 1 , null, null, null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCPURCH' , 'Purchasing' , 1 , 2.0 , 0.0 , null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCPURCH' , 'Purchasing' , 1 , null, null, null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLPURCH' , 'Purchasing' , 1 , 2.0 , 0.0 , null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCOMCLPURCH' , 'Purchasing' , 1 , null, null, null ,
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPAQ' , 'VS CHIP TERMNL' , 1 , 1.0 , 0.0 , null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPAQ' , 'VS CHIP TERMNL' , 1 , null, null, null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICTER' , 'VS CHIP TERMNL' , 1 , 1.0 , 0.0 , null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICTER' , 'VS CHIP TERMNL' , 1 , null, null, null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPACQ' , 'Acq Chip' , 1 , 1.0 , 0.0 , null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPACQ' , 'Acq Chip' , 1 , null, null, null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPTERMNL' , 'Acq Chip-Air' , 1 , 1.0 , 0.0 , null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPTERMNL' , 'Acq Chip-Air' , 1 , null, null, null ,
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCT' , 'VS AIR CHIP TERMNL' , 1 , 1.0 , 0.0 , null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCT' , 'VS AIR CHIP TERMNL' , 1 , null, null, null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPACQ' , 'Acq Chip-Air' , 1 , 1.0 , 0.0 , null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPACQ' , 'Acq Chip-Air' , 1 , null, null, null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHIPTERMNL' , 'Acq Chip' , 1 , 1.0 , 0.0 , null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHIPTERMNL' , 'Acq Chip' , 1 , null, null, null ,
    '916' , 'Airline Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPIS' , 'VS CHIP ISS' , 1 , 1.2 , 0.0 , null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPIS' , 'VS CHIP ISS' , 1 , null, null, null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICISS' , 'VS CHIP ISS' , 1 , 1.2 , 0.0 , null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ICISS' , 'VS CHIP ISS' , 1 , null, null, null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPISS' , 'Iss Chip' , 1 , 1.2 , 0.0 , null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPISS' , 'Iss Chip' , 1 , null, null, null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPISS' , 'Iss Chip' , 1 , 1.2 , 0.0 , null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPISS' , 'Iss Chip' , 1 , null, null, null ,
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPOFF' , 'VS SET MRCH' , 1 , 1.44 , 0.0 , null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPOFF' , 'VS SET MRCH' , 1 , null, null, null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104SETM' , 'VS SET MRCH' , 1 , 1.44 , 0.0 , null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104SETM' , 'VS SET MRCH' , 1 , null, null, null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCECM' , 'Ele Comm Merch' , 1 , 1.44 , 0.0 , null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCECM' , 'Ele Comm Merch' , 1 , null, null, null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTNONAUTHNDMRCH' , 'NDMRCH' , 1 , 1.44 , 0.0 , null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTNONAUTHNDMRCH' , 'NDMRCH' , 1 , null, null, null ,
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPON' , 'VS SET MRCH SEC' , 1 , 1.44 , 0.0 , null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ASCHPON' , 'VS SET MRCH SEC' , 1 , null, null, null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104SETMS' , 'VS SET MRCH SEC' , 1 , 1.44 , 0.0 , null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104SETMS' , 'VS SET MRCH SEC' , 1 , null, null, null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSEC' , 'Sec Ele Comm' , 1 , 1.44 , 0.0 , null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSEC' , 'Sec Ele Comm' , 1 , null, null, null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAUTHENTICTDSEC' , 'Sec Ele Comm' , 1 , 1.44 , 0.0 , null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAUTHENTICTDSEC' , 'Sec Ele Comm' , 1 , null, null, null ,
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRLINE' , 'Airline' , 1 , 1.1 , 0.0 , null ,
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRLINE' , 'Airline' , 1 , null, null, null ,
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTINTRAIRLINE' , 'Airline' , 1 , 1.1 , 0.0 , null ,
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTINTRAIRLINE' , 'Airline' , 1 , null, null, null ,
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPACQ' , 'Acq Chip-VE' , 1 , 1.0 , 0.0 , null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPACQ' , 'Acq Chip-VE' , 1 , null, null, null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPTERMNL' , 'Acq Chip Air-VE' , 1 , 1.0 , 0.0 , null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPTERMNL' , 'Acq Chip Air-VE' , 1 , null, null, null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECT' , 'VS VE CHIP TERMNL' , 1 , 1.0 , 0.0 , null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECT' , 'VS VE CHIP TERMNL' , 1 , null, null, null ,
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPISS' , 'Iss Chip-VE' , 1 , 1.2 , 0.0 , null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPISS' , 'Iss Chip-VE' , 1 , null, null, null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPISS' , 'Iss Chip-VE' , 1 , 1.2 , 0.0 , null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPISS' , 'Iss Chip-VE' , 1 , null, null, null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECI' , 'VS VE CHIP ISS' , 1 , 1.2 , 0.0 , null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECI' , 'VS VE CHIP ISS' , 1 , null, null, null ,
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104INLKS' , 'VS INTERLINK STD' , 1 , 1.1 , 0.0 , null ,
    '923' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104INLKS' , 'VS INTERLINK STD' , 1 , null, null, null ,
    '923' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CHFT' , 'VS CH FUNDS TRANSFER' , 1 , 0.0 , 0.49 , null ,
    '926' , 'Original Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CHFT' , 'VS CH FUNDS TRANSFER' , 1 , null, null, null ,
    '926' , 'Original Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCEIRFVE' , 'VE INT PREPS2000' , 1 , 1.1 , 0.0 , null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCEIRFVE' , 'VE INT PREPS2000' , 1 , null, null, null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEINTPREPS2000' , 'Electronic-VE' , 1 , 1.1 , 0.0 , null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEINTPREPS2000' , 'Electronic-VE' , 1 , null, null, null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEINTPS2000' , 'VE INT PREPS2000' , 1 , 1.1 , 0.0 , null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEINTPS2000' , 'VE INT PREPS2000' , 1 , null, null, null ,
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVESEC' , 'Sec Ele Comm-VE' , 1 , 1.44 , 0.0 , null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVESEC' , 'Sec Ele Comm-VE' , 1 , null, null, null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVENONAUTHNMER' , 'Ele Comm Merch-VE' , 1 , 1.44 , 0.0 , null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVENONAUTHNMER' , 'Ele Comm Merch-VE' , 1 , null, null, null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VENONAUTHNM' , 'VE NONAUTH MER' , 1 , 1.44 , 0.0 , null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VENONAUTHNM' , 'VE NONAUTH MER' , 1 , null, null, null ,
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEECM' , 'Ele Comm Merch-VE' , 1 , 1.44 , 0.0 , null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEECM' , 'Ele Comm Merch-VE' , 1 , null, null, null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAUTHENTICSEC' , 'Sec Ele Comm-VE' , 1 , 1.44 , 0.0 , null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAUTHENTICSEC' , 'Sec Ele Comm-VE' , 1 , null, null, null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAUTHNSEC' , 'VE AUTHENTIC SEC' , 1 , 1.44 , 0.0 , null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAUTHNSEC' , 'VE AUTHENTIC SEC' , 1 , null, null, null ,
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRLINE' , 'Airline-VE' , 1 , 1.1 , 0.0 , null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRLINE' , 'Airline-VE' , 1 , null, null, null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEINTRAIRLINE' , 'Airline-VE' , 1 , 1.1 , 0.0 , null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEINTRAIRLINE' , 'Airline-VE' , 1 , null, null, null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEINTAIR' , 'VE INT AIRLINE' , 1 , 1.1 , 0.0 , null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEINTAIR' , 'VE INT AIRLINE' , 1 , null, null, null ,
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPACQ' , 'Acq Chip Air-VE' , 1 , 1.0 , 0.0 , null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPACQ' , 'Acq Chip Air-VE' , 1 , null, null, null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHIPTERMNL' , 'Acq Chip-VE' , 1 , 1.0 , 0.0 , null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHIPTERMNL' , 'Acq Chip-VE' , 1 , null, null, null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCHIP' , 'VE AIR CHIP TERM' , 1 , 1.0 , 0.0 , null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCHIP' , 'VE AIR CHIP TERM' , 1 , null, null, null ,
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVESTD' , 'VE STANDARD' , 1 , 1.6 , 0.0 , null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVESTD' , 'VE STANDARD' , 1 , null, null, null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVESTANDARD' , 'Cons Std-VE' , 1 , 1.6 , 0.0 , null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVESTANDARD' , 'Cons Std-VE' , 1 , null, null, null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VESTD' , 'VE STANDARD' , 1 , 1.6 , 0.0 , null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VESTD' , 'VE STANDARD' , 1 , null, null, null ,
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSIG' , 'VS SIGNATURE CARD' , 1 , 1.8 , 0.0 , null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCSIG' , 'VS SIGNATURE CARD' , 1 , null, null, null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTSIGCARD' , 'Signature' , 1 , 1.8 , 0.0 , null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTSIGCARD' , 'Signature' , 1 , null, null, null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VISGNATURE' , 'VS SIGNATURE CARD' , 1 , 1.8 , 0.0 , null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VISGNATURE' , 'VS SIGNATURE CARD' , 1 , null, null, null ,
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CFULL' , 'CHIP FULL' , 1 , 1.1 , 0.0 , null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CFULL' , 'CHIP FULL' , 1 , null, null, null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPFULL' , 'Chip-Full Data' , 1 , 1.1 , 0.0 , null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPFULL' , 'Chip-Full Data' , 1 , null, null, null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPFULL' , 'Chip-Full Data' , 1 , 1.1 , 0.0 , null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPFULL' , 'Chip-Full Data' , 1 , null, null, null ,
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPFULL' , 'Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPFULL' , 'Chip-Full Data-VE' , 1 , null, null, null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPFULL' , 'Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPFULL' , 'Chip-Full Data-VE' , 1 , null, null, null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECFULL' , 'VE CHIP FULL' , 1 , 1.1 , 0.0 , null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECFULL' , 'VE CHIP FULL' , 1 , null, null, null ,
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCFULL' , 'AIR CHIP FULL' , 1 , 1.1 , 0.0 , null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCFULL' , 'AIR CHIP FULL' , 1 , null, null, null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , 1.1 , 0.0 , null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , null, null, null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , 1.1 , 0.0 , null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , null, null, null ,
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , null, null, null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , null, null, null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCFULL' , 'VE AIR CHIP FULL' , 1 , 1.1 , 0.0 , null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCFULL' , 'VE AIR CHIP FULL' , 1 , null, null, null ,
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CFLPIN' , 'CHIP FULL PIN' , 1 , 1.1 , 0.0 , null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CFLPIN' , 'CHIP FULL PIN' , 1 , null, null, null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , null, null, null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , null, null, null ,
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , null, null, null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , null, null, null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECFLPIN' , 'VE CHIP FULL PIN' , 1 , 1.1 , 0.0 , null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VECFLPIN' , 'VE CHIP FULL PIN' , 1 , null, null, null ,
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCFLPIN' , 'AIR CHIP FULL PIN' , 1 , 1.1 , 0.0 , null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104AIRCFLPIN' , 'AIR CHIP FULL PIN' , 1 , null, null, null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , null, null, null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTAIRCHPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , null, null, null ,
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104TCVEAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , null, null, null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHPFLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTVEAIRCHPFLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , null, null, null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCFLPIN' , 'VE AIR CHIP FULL PIN' , 1 , 1.1 , 0.0 , null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104VEAIRCFLPIN' , 'VE AIR CHIP FULL PIN' , 1 , null, null, null ,
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IVSP' , 'VSP INTR' , 1 , 1.97 , 0.0 , null ,
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IVSP' , 'VSP INTR' , 1 , null, null, null ,
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTUSVSPINTR' , 'Infinite' , 1 , 1.97 , 0.0 , null ,
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104USTUSVSPINTR' , 'Infinite' , 1 , null, null, null ,
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPREM' , 'INTERREGIONAL PREMIUM CARD' , 1 , 1.8 , 0.0 , null ,
    '947' , 'Visa International Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104IPREM' , 'INTERREGIONAL PREMIUM CARD' , 1 , null, null, null ,
    '947' , 'Visa International Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ISPREM' , 'US VSP INTR' , 1 , 1.97 , 0.0 , null ,
    '948' , 'Super Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104ISPREM' , 'US VSP INTR' , 1 , null, null, null ,
    '948' , 'Super Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCON' , 'VS CAN RECPMT CR NAT' , 1 , 1.37 , 0.0 , null ,
    'B01' , 'Recurring Payment - Consumer Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCON' , 'VS CAN RECPMT CR NAT' , 1 , null, null, null ,
    'B01' , 'Recurring Payment - Consumer Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCONINTLSTL' , 'VS CAN RECPMT CR INT' , 1 , 1.37 , 0.0 , null ,
    'B02' , 'Recurring Payment - Consumer Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCONINTLSTL' , 'VS CAN RECPMT CR INT' , 1 , null, null, null ,
    'B02' , 'Recurring Payment - Consumer Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPBUS' , 'VS CAN RECPMT BUS NAT' , 1 , 1.85 , 0.0 , null ,
    'B03' , 'Recurring Payment - Business Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPBUS' , 'VS CAN RECPMT BUS NAT' , 1 , null, null, null ,
    'B03' , 'Recurring Payment - Business Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPBUSINTLSTL' , 'VS CAN RECPMT BUS INT' , 1 , 1.85 , 0.0 , null ,
    'B04' , 'Recurring Payment - Business Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPBUSINTLSTL' , 'VS CAN RECPMT BUS INT' , 1 , null, null, null ,
    'B04' , 'Recurring Payment - Business Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOR' , 'VS CAN RECPMT COR NAT' , 1 , 1.85 , 0.0 , null ,
    'B05' , 'Recurring Payment - Corporate Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOR' , 'VS CAN RECPMT COR NAT' , 1 , null, null, null ,
    'B05' , 'Recurring Payment - Corporate Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCORINTL' , 'VS CAN RECPMT COR INT' , 1 , 1.85 , 0.0 , null ,
    'B06' , 'Recurring Payment - Corporate Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCORINTL' , 'VS CAN RECPMT COR INT' , 1 , null, null, null ,
    'B06' , 'Recurring Payment - Corporate Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPUR' , 'VS CAN RECPMT PUR NAT' , 1 , 1.85 , 0.0 , null ,
    'B07' , 'Recurring Payment - Purchasing Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPUR' , 'VS CAN RECPMT PUR NAT' , 1 , null, null, null ,
    'B07' , 'Recurring Payment - Purchasing Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPURINTLSTL' , 'VS CAN RECPMT PUR INT' , 1 , 1.85 , 0.0 , null ,
    'B08' , 'Recurring Payment - Purchasing Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPURINTLSTL' , 'VS CAN RECPMT PUR INT' , 1 , null, null, null ,
    'B08' , 'Recurring Payment - Purchasing Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPDB' , 'VS CAN RECPMT DB NAT' , 1 , 0.6 , 0.0 , null ,
    'B09' , 'Recurring Payment - Debit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPDB' , 'VS CAN RECPMT DB NAT' , 1 , null, null, null ,
    'B09' , 'Recurring Payment - Debit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPDBINTLSTL' , 'VS CAN RECPMT DB INT' , 1 , 0.6 , 0.0 , null ,
    'B10' , 'Recurring Payment - Debit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPDBINTLSTL' , 'VS CAN RECPMT DB INT' , 1 , null, null, null ,
    'B10' , 'Recurring Payment - Debit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPP' , 'VS CAN RECPMT PP NAT' , 1 , 1.37 , 0.0 , null ,
    'B11' , 'Recurring Payment - Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPP' , 'VS CAN RECPMT PP NAT' , 1 , null, null, null ,
    'B11' , 'Recurring Payment - Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPPINTLSTL' , 'VS CAN RECPMT PP INT' , 1 , 1.37 , 0.0 , null ,
    'B12' , 'Recurring Payment - Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPPPINTLSTL' , 'VS CAN RECPMT PP INT' , 1 , null, null, null ,
    'B12' , 'Recurring Payment - Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOMMPP' , 'VS CAN COMM RPMT PP NAT' , 1 , 1.85 , 0.0 , null ,
    'B13' , 'Recurring Payment - Commercial Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOMMPP' , 'VS CAN COMM RPMT PP NAT' , 1 , null, null, null ,
    'B13' , 'Recurring Payment - Commercial Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOMMPPINTL' , 'VS CAN COMM RPMT PP INT' , 1 , 1.85 , 0.0 , null ,
    'B14' , 'Recurring Payment - Commercial Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPCOMMPPINTL' , 'VS CAN COMM RPMT PP INT' , 1 , null, null, null ,
    'B14' , 'Recurring Payment - Commercial Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBCHIP' , 'VS CAN CHIP DB NAT' , 1 , 1.15 , 0.0 , null ,
    'C10' , 'Chip - Debit card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBCHIP' , 'VS CAN CHIP DB NAT' , 1 , null, null, null ,
    'C10' , 'Chip - Debit card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBCHIPINTLSTL' , 'VS CAN CHIP DB INT' , 1 , 1.15 , 0.0 , null ,
    'C12' , 'Chip - Debit card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBCHIPINTLSTL' , 'VS CAN CHIP DB INT' , 1 , null, null, null ,
    'C12' , 'Chip - Debit card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCECON' , 'VS CAN ELEC CR NAT' , 1 , 1.42 , 0.0 , null ,
    'E01' , 'Electronic - Consumer Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCECON' , 'VS CAN ELEC CR NAT' , 1 , null, null, null ,
    'E01' , 'Electronic - Consumer Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCECONINTLSTL' , 'VS CAN ELEC CR INT' , 1 , 1.42 , 0.0 , null ,
    'E02' , 'Electronic - Consumer Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCECONINTLSTL' , 'VS CAN ELEC CR INT' , 1 , null, null, null ,
    'E02' , 'Electronic - Consumer Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCBUS' , 'VS CAN ELEC BUS NAT' , 1 , 1.9 , 0.0 , null ,
    'E03' , 'Electronic - Business Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCBUS' , 'VS CAN ELEC BUS NAT' , 1 , null, null, null ,
    'E03' , 'Electronic - Business Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCBUSINTLSTL' , 'VS CAN ELEC BUS INT' , 1 , 1.9 , 0.0 , null ,
    'E04' , 'Electronic - Business Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCBUSINTLSTL' , 'VS CAN ELEC BUS INT' , 1 , null, null, null ,
    'E04' , 'Electronic - Business Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOR' , 'VS CAN ELEC COR NAT' , 1 , 1.9 , 0.0 , null ,
    'E05' , 'Electronic - Corporate Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOR' , 'VS CAN ELEC COR NAT' , 1 , null, null, null ,
    'E05' , 'Electronic - Corporate Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCORINTLSTL' , 'VS CAN ELEC COR INT' , 1 , 1.9 , 0.0 , null ,
    'E06' , 'Electronic - Corporate Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCORINTLSTL' , 'VS CAN ELEC COR INT' , 1 , null, null, null ,
    'E06' , 'Electronic - Corporate Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPUR' , 'VS CAN ELEC PUR NAT' , 1 , 1.9 , 0.0 , null ,
    'E07' , 'Electronic - Purchasing Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPUR' , 'VS CAN ELEC PUR NAT' , 1 , null, null, null ,
    'E07' , 'Electronic - Purchasing Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPURINTLSTL' , 'VS CAN ELEC PUR INT' , 1 , 1.9 , 0.0 , null ,
    'E08' , 'Electronic - Purchasing Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPURINTLSTL' , 'VS CAN ELEC PUR INT' , 1 , null, null, null ,
    'E08' , 'Electronic - Purchasing Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPP' , 'VS CAN ELEC PP NAT' , 1 , 1.42 , 0.0 , null ,
    'E11' , 'Electronic - Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPP' , 'VS CAN ELEC PP NAT' , 1 , null, null, null ,
    'E11' , 'Electronic - Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPPINTLSTL' , 'VS CAN ELEC PP INT' , 1 , 1.42 , 0.0 , null ,
    'E12' , 'Electronic - Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCPPINTLSTL' , 'VS CAN ELEC PP INT' , 1 , null, null, null ,
    'E12' , 'Electronic - Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCDB' , 'VS CAN CHIP ELEC DB NAT' , 1 , 0.25 , 0.05 , null ,
    'E21' , 'Electronic - Debit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCDB' , 'VS CAN CHIP ELEC DB NAT' , 1 , null, null, null ,
    'E21' , 'Electronic - Debit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCDBINTLSTL' , 'VS CAN CHIP ELEC DB INT' , 1 , 0.25 , 0.05 , null ,
    'E22' , 'Electronic - Debit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCDBINTLSTL' , 'VS CAN CHIP ELEC DB INT' , 1 , null, null, null ,
    'E22' , 'Electronic - Debit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMDB' , 'VS CAN DB ES NAT' , 1 , 0.3 , 0.0 , null ,
    'E30' , 'Debit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMDB' , 'VS CAN DB ES NAT' , 1 , null, null, null ,
    'E30' , 'Debit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEM' , 'VS CAN CONS CR ES NAT' , 1 , 0.98 , 0.0 , null ,
    'E31' , 'Consumer Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEM' , 'VS CAN CONS CR ES NAT' , 1 , null, null, null ,
    'E31' , 'Consumer Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINF' , 'VS CAN INF CR ES NAT' , 1 , 1.17 , 0.0 , null ,
    'E32' , 'Infinite Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINF' , 'VS CAN INF CR ES NAT' , 1 , null, null, null ,
    'E32' , 'Infinite Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMBUS' , 'VS CAN BUS ES NAT' , 1 , 1.8 , 0.0 , null ,
    'E33' , 'Business Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMBUS' , 'VS CAN BUS ES NAT' , 1 , null, null, null ,
    'E33' , 'Business Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOR' , 'VS CAN COR ES NAT' , 1 , 1.8 , 0.0 , null ,
    'E34' , 'Corporate Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOR' , 'VS CAN COR ES NAT' , 1 , null, null, null ,
    'E34' , 'Corporate Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPUR' , 'VS CAN PUR ES NAT' , 1 , 1.8 , 0.0 , null ,
    'E35' , 'Purchasing Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPUR' , 'VS CAN PUR ES NAT' , 1 , null, null, null ,
    'E35' , 'Purchasing Credit, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMDBINTLSTL' , 'VS CAN DB ES INT' , 1 , 0.3 , 0.0 , null ,
    'E40' , 'Debit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMDBINTLSTL' , 'VS CAN DB ES INT' , 1 , null, null, null ,
    'E40' , 'Debit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINTLSTL' , 'VS CAN CONS CR ES INT' , 1 , 0.98 , 0.0 , null ,
    'E41' , 'Consumer Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINTLSTL' , 'VS CAN CONS CR ES INT' , 1 , null, null, null ,
    'E41' , 'Consumer Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINFINTLSTL' , 'VS CAN INF CR ES INT' , 1 , 1.17 , 0.0 , null ,
    'E42' , 'Infinite Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMINFINTLSTL' , 'VS CAN INF CR ES INT' , 1 , null, null, null ,
    'E42' , 'Infinite Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMBUSINTLSTL' , 'VS CAN BUS ES INT' , 1 , 1.8 , 0.0 , null ,
    'E43' , 'Business Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMBUSINTLSTL' , 'VS CAN BUS ES INT' , 1 , null, null, null ,
    'E43' , 'Business Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCORINTLSTL' , 'VS CAN COR ES INT' , 1 , 1.8 , 0.0 , null ,
    'E44' , 'Corporate Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCORINTLSTL' , 'VS CAN COR ES INT' , 1 , null, null, null ,
    'E44' , 'Corporate Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPURINTLSTL' , 'VS CAN PUR ES INT' , 1 , 1.8 , 0.0 , null ,
    'E45' , 'Purchasing Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPURINTLSTL' , 'VS CAN PUR ES INT' , 1 , null, null, null ,
    'E45' , 'Purchasing Credit, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPP' , 'VS CAN CONS PP ES NAT' , 1 , 0.98 , 0.0 , null ,
    'E46' , 'Prepaid, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPP' , 'VS CAN CONS PP ES NAT' , 1 , null, null, null ,
    'E46' , 'Prepaid, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPPINTLSTL' , 'VS CAN CONS PP ES INT' , 1 , 0.98 , 0.0 , null ,
    'E47' , 'Prepaid, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMPPINTLSTL' , 'VS CAN CONS PP ES INT' , 1 , null, null, null ,
    'E47' , 'Prepaid, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOMMPP' , 'VS CAN COMM ELEC PP NAT' , 1 , 1.9 , 0.0 , null ,
    'E48' , 'Electronic - Commercial Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOMMPP' , 'VS CAN COMM ELEC PP NAT' , 1 , null, null, null ,
    'E48' , 'Electronic - Commercial Prepaid, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOMMPPINTLSTL' , 'VS CAN COMM ELEC PP INT' , 1 , 1.9 , 0.0 , null ,
    'E49' , 'Electronic - Commercial Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCCOMMPPINTLSTL' , 'VS CAN COMM ELEC PP INT' , 1 , null, null, null ,
    'E49' , 'Electronic - Commercial Prepaid, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOMMPP' , 'VS CAN CONS PP ES NAT' , 1 , 1.8 , 0.0 , null ,
    'E50' , 'Commercial Prepaid, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOMMPP' , 'VS CAN CONS PP ES NAT' , 1 , null, null, null ,
    'E50' , 'Commercial Prepaid, Emerging Segment, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOMMPPINTLSTL' , 'VS CAN CONS PP ES INT' , 1 , 1.8 , 0.0 , null ,
    'E51' , 'Commercial Prepaid, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMCOMMPPINTLSTL' , 'VS CAN CONS PP ES INT' , 1 , null, null, null ,
    'E51' , 'Commercial Prepaid, Emerging Segment, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNFUELENH' , 'VS CAN FUEL DATA NAT' , 1 , 1.8 , 0.0 , null ,
    'ED1' , 'Fuel Enhanced Data, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNFUELENH' , 'VS CAN FUEL DATA NAT' , 1 , null, null, null ,
    'ED1' , 'Fuel Enhanced Data, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNFUELENHINTLSTL' , 'VS CAN FUEL DATA INT' , 1 , 1.8 , 0.0 , null ,
    'ED2' , 'Fuel Enhanced Data, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNFUELENHINTLSTL' , 'VS CAN FUEL DATA INT' , 1 , null, null, null ,
    'ED2' , 'Fuel Enhanced Data, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL2' , 'VS CAN B2B LVL2 NAT' , 1 , 1.6 , 0.0 , null ,
    'ED3' , 'B2B Enhanced Data Level 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL2' , 'VS CAN B2B LVL2 NAT' , 1 , null, null, null ,
    'ED3' , 'B2B Enhanced Data Level 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL2INTLSTL' , 'VS CAN B2B LVL2 INT' , 1 , 1.6 , 0.0 , null ,
    'ED4' , 'B2B Enhanced Data Level 2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL2INTLSTL' , 'VS CAN B2B LVL2 INT' , 1 , null, null, null ,
    'ED4' , 'B2B Enhanced Data Level 2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL3' , 'VS CAN B2B LVL3 NAT' , 1 , 1.4 , 0.0 , null ,
    'ED5' , 'B2B Enhanced Data Level 3, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL3' , 'VS CAN B2B LVL3 NAT' , 1 , null, null, null ,
    'ED5' , 'B2B Enhanced Data Level 3, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL3INTLSTL' , 'VS CAN B2B LVL3 INT' , 1 , 1.4 , 0.0 , null ,
    'ED6' , 'B2B Enhanced Data Level 3, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNB2BLVL3INTLSTL' , 'VS CAN B2B LVL3 INT' , 1 , null, null, null ,
    'ED6' , 'B2B Enhanced Data Level 3, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFSTD' , 'VS CAN NATL SETTLED INF' , 1 , 1.71 , 0.0 , null ,
    'F01' , 'Standard - Infinite credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFSTD' , 'VS CAN NATL SETTLED INF' , 1 , null, null, null ,
    'F01' , 'Standard - Infinite credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFINTLSTL' , 'VS CAN INTL SETTLED INF' , 1 , 1.71 , 0.0 , null ,
    'F02' , 'Standard - Infinite credit, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFINTLSTL' , 'VS CAN INTL SETTLED INF' , 1 , null, null, null ,
    'F02' , 'Standard - Infinite credit, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEINF' , 'VS CAN ELEC INF NAT' , 1 , 1.61 , 0.0 , null ,
    'F07' , 'Electronic - Infinite Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEINF' , 'VS CAN ELEC INF NAT' , 1 , null, null, null ,
    'F07' , 'Electronic - Infinite Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEINFINTLSTL' , 'VS CAN ELEC INF INT' , 1 , 1.61 , 0.0 , null ,
    'F08' , 'Electronic - Infinite Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEINFINTLSTL' , 'VS CAN ELEC INF INT' , 1 , null, null, null ,
    'F08' , 'Electronic - Infinite Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPINF' , 'VS CAN RECPMT INF NAT' , 1 , 1.56 , 0.0 , null ,
    'F11' , 'Recurring Payment - Infinite Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPINF' , 'VS CAN RECPMT INF NAT' , 1 , null, null, null ,
    'F11' , 'Recurring Payment - Infinite Credit, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPINFINTLSTL' , 'VS CAN RECPMT INF INT' , 1 , 1.56 , 0.0 , null ,
    'F12' , 'Recurring Payment - Infinite Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPINFINTLSTL' , 'VS CAN RECPMT INF INT' , 1 , null, null, null ,
    'F12' , 'Recurring Payment - Infinite Credit, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI1' , 'VS CAN INF CR IND1 NAT' , 1 , 1.37 , 0.0 , null ,
    'F13' , 'Infinite Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI1' , 'VS CAN INF CR IND1 NAT' , 1 , null, null, null ,
    'F13' , 'Infinite Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCR1INTLSTL' , 'VS CAN INF CR IND1 INT' , 1 , 1.37 , 0.0 , null ,
    'F14' , 'Infinite Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCR1INTLSTL' , 'VS CAN INF CR IND1 INT' , 1 , null, null, null ,
    'F14' , 'Infinite Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI2' , 'VS CAN INF CR IND2 NAT' , 1 , 1.52 , 0.0 , null ,
    'F15' , 'Infinite Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI2' , 'VS CAN INF CR IND2 NAT' , 1 , null, null, null ,
    'F15' , 'Infinite Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI2INTLSTL' , 'VS CAN INF CR IND2 INT' , 1 , 1.52 , 0.0 , null ,
    'F16' , 'Infinite Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRI2INTLSTL' , 'VS CAN INF CR IND2 INT' , 1 , null, null, null ,
    'F16' , 'Infinite Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT1INTLSTL' , 'VS CAN INF TR1 INT' , 1 , 1.56 , 0.0 , null ,
    'F21' , 'Infinite Credit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT1INTLSTL' , 'VS CAN INF TR1 INT' , 1 , null, null, null ,
    'F21' , 'Infinite Credit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT1' , 'VS CAN INF TR1 NAT' , 1 , 1.56 , 0.0 , null ,
    'F22' , 'Infinite Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT1' , 'VS CAN INF TR1 NAT' , 1 , null, null, null ,
    'F22' , 'Infinite Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT2INTLSTL' , 'VS CAN INF TR2 INT' , 1 , 1.61 , 0.0 , null ,
    'F23' , 'Infinite Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT2INTLSTL' , 'VS CAN INF TR2 INT' , 1 , null, null, null ,
    'F23' , 'Infinite Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT2' , 'VS CAN INF TR2 NAT' , 1 , 1.61 , 0.0 , null ,
    'F24' , 'Infinite Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINFCRT2' , 'VS CAN INF TR2 NAT' , 1 , null, null, null ,
    'F24' , 'Infinite Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWSTD' , 'VS CAN HNW STD NAT' , 1 , 2.45 , 0.0 , null ,
    'F63' , 'Standard-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWSTD' , 'VS CAN HNW STD NAT' , 1 , null, null, null ,
    'F63' , 'Standard-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWINTLSTL' , 'VS CAN HNW STD INT' , 1 , 2.45 , 0.0 , null ,
    'F64' , 'Standard-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWINTLSTL' , 'VS CAN HNW STD INT' , 1 , null, null, null ,
    'F64' , 'Standard-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNW' , 'VS CAN HNW ELEC NAT' , 1 , 2.08 , 0.0 , null ,
    'F65' , 'Electronic-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNW' , 'VS CAN HNW ELEC NAT' , 1 , null, null, null ,
    'F65' , 'Electronic-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWINTLSTL' , 'VS CAN HNW ELEC INT' , 1 , 2.08 , 0.0 , null ,
    'F66' , 'Electronic-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWINTLSTL' , 'VS CAN HNW ELEC INT' , 1 , null, null, null ,
    'F66' , 'Electronic-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI1' , 'VS CAN HNW TR1 NAT' , 1 , 1.95 , 0.0 , null ,
    'F67' , 'Performance Tier 1-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI1' , 'VS CAN HNW TR1 NAT' , 1 , null, null, null ,
    'F67' , 'Performance Tier 1-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI1INTLSTL' , 'VS CAN HNW TR1 INT' , 1 , 1.95 , 0.0 , null ,
    'F68' , 'Performance Tier 1-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI1INTLSTL' , 'VS CAN HNW TR1 INT' , 1 , null, null, null ,
    'F68' , 'Performance Tier 1-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI2INTLSTL' , 'VS CAN HNW TR2 NAT' , 1 , 2.0 , 0.0 , null ,
    'F69' , 'Performance Tier 2-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI2INTLSTL' , 'VS CAN HNW TR2 NAT' , 1 , null, null, null ,
    'F69' , 'Performance Tier 2-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI2' , 'VS CAN HNW TR2 INT' , 1 , 2.0 , 0.0 , null ,
    'F70' , 'Performance Tier 2-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWCRI2' , 'VS CAN HNW TR2 INT' , 1 , null, null, null ,
    'F70' , 'Performance Tier 2-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI1' , 'VS CAN HNW IND1 NAT' , 1 , 1.95 , 0.0 , null ,
    'F73' , 'Industry Rate 1-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI1' , 'VS CAN HNW IND1 NAT' , 1 , null, null, null ,
    'F73' , 'Industry Rate 1-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCR1INTLSTL' , 'VS CAN HNW IND1 INT' , 1 , 1.95 , 0.0 , null ,
    'F74' , 'Industry Rate 1-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCR1INTLSTL' , 'VS CAN HNW IND1 INT' , 1 , null, null, null ,
    'F74' , 'Industry Rate 1-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI2' , 'VS CAN HNW IND2 NAT' , 1 , 1.95 , 0.0 , null ,
    'F75' , 'Industry Rate 2-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI2' , 'VS CAN HNW IND2 NAT' , 1 , null, null, null ,
    'F75' , 'Industry Rate 2-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI2INTLSTL' , 'VS CAN HNW IND2 INT' , 1 , 1.95 , 0.0 , null ,
    'F76' , 'Industry Rate 2-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWCRI2INTLSTL' , 'VS CAN HNW IND2 INT' , 1 , null, null, null ,
    'F76' , 'Industry Rate 2-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWCR' , 'VS CAN HNW RC NAT' , 1 , 1.95 , 0.0 , null ,
    'F77' , 'Recurring Payment-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWCR' , 'VS CAN HNW RC NAT' , 1 , null, null, null ,
    'F77' , 'Recurring Payment-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWCRINTLSTL' , 'VS CAN HNW RC INT' , 1 , 1.95 , 0.0 , null ,
    'F78' , 'Recurring Payment-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWCRINTLSTL' , 'VS CAN HNW RC INT' , 1 , null, null, null ,
    'F78' , 'Recurring Payment-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWCR' , 'VS CAN HNW ES NAT' , 1 , 1.95 , 0.0 , null ,
    'F79' , 'Emerging Segment-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWCR' , 'VS CAN HNW ES NAT' , 1 , null, null, null ,
    'F79' , 'Emerging Segment-HNW, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWCRINTLSTL' , 'VS CAN HNW ES INT' , 1 , 1.95 , 0.0 , null ,
    'F80' , 'Emerging Segment-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWCRINTLSTL' , 'VS CAN HNW ES INT' , 1 , null, null, null ,
    'F80' , 'Emerging Segment-HNW, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBSTD' , 'VS CAN HNW BUS STD NAT' , 1 , 2.65 , 0.0 , null ,
    'FA1' , 'Standard-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBSTD' , 'VS CAN HNW BUS STD NAT' , 1 , null, null, null ,
    'FA1' , 'Standard-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSINTLSTL' , 'VS CAN HNW BUS STD INT' , 1 , 2.65 , 0.0 , null ,
    'FA2' , 'Standard-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSINTLSTL' , 'VS CAN HNW BUS STD INT' , 1 , null, null, null ,
    'FA2' , 'Standard-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWBUS' , 'VS CAN HNW BUS ELEC NAT' , 1 , 2.25 , 0.0 , null ,
    'FA3' , 'Electronic-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWBUS' , 'VS CAN HNW BUS ELEC NAT' , 1 , null, null, null ,
    'FA3' , 'Electronic-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWBUSINTLSTL' , 'VS CAN HNW ELEC INT' , 1 , 2.25 , 0.0 , null ,
    'FA4' , 'Electronic-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNNCEHNWBUSINTLSTL' , 'VS CAN HNW ELEC INT' , 1 , null, null, null ,
    'FA4' , 'Electronic-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI1' , 'VS CAN HNW BUS TR1 NAT' , 1 , 2.0 , 0.0 , null ,
    'FA5' , 'Performance Tier 1-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI1' , 'VS CAN HNW BUS TR1 NAT' , 1 , null, null, null ,
    'FA5' , 'Performance Tier 1-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI1INTLSTL' , 'VS CAN HNW BUS TR1 INT' , 1 , 2.0 , 0.0 , null ,
    'FA6' , 'Performance Tier 1-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI1INTLSTL' , 'VS CAN HNW BUS TR1 INT' , 1 , null, null, null ,
    'FA6' , 'Performance Tier 1-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI2' , 'VS CAN HNW BUS TR2 NAT' , 1 , 2.0 , 0.0 , null ,
    'FA7' , 'Performance Tier 2-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI2' , 'VS CAN HNW BUS TR2 NAT' , 1 , null, null, null ,
    'FA7' , 'Performance Tier 2-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI2INTLSTL' , 'VS CAN HNW BUS TR2 INT' , 1 , 2.0 , 0.0 , null ,
    'FA8' , 'Performance Tier 2-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPHNWBUSI2INTLSTL' , 'VS CAN HNW BUS TR2 INT' , 1 , null, null, null ,
    'FA8' , 'Performance Tier 2-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI1' , 'VS CAN HNW BUS IND1 NAT' , 1 , 2.0 , 0.0 , null ,
    'FC5' , 'Industry Rate 1-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI1' , 'VS CAN HNW BUS IND1 NAT' , 1 , null, null, null ,
    'FC5' , 'Industry Rate 1-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI1INTLSTL' , 'VS CAN HNW BUS IND1 INT' , 1 , 2.0 , 0.0 , null ,
    'FC6' , 'Industry Rate 1-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI1INTLSTL' , 'VS CAN HNW BUS IND1 INT' , 1 , null, null, null ,
    'FC6' , 'Industry Rate 1-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI2' , 'VS CAN HNW BUS IND2 NAT' , 1 , 2.0 , 0.0 , null ,
    'FC7' , 'Industry Rate 2-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI2' , 'VS CAN HNW BUS IND2 NAT' , 1 , null, null, null ,
    'FC7' , 'Industry Rate 2-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI2INTLSTL' , 'VS CAN HNW BUS IND2 INT' , 1 , 2.0 , 0.0 , null ,
    'FC8' , 'Industry Rate 2-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNHNWBUSI2INTLSTL' , 'VS CAN HNW BUS IND2 INT' , 1 , null, null, null ,
    'FC8' , 'Industry Rate 2-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWBUS' , 'VS CAN HNW BUS RC NAT' , 1 , 2.0 , 0.0 , null ,
    'FC9' , 'Recurring Payment-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWBUS' , 'VS CAN HNW BUS RC NAT' , 1 , null, null, null ,
    'FC9' , 'Recurring Payment-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWBUSINTLSTL' , 'VS CAN HNW BUS RC INT' , 1 , 2.0 , 0.0 , null ,
    'FD1' , 'Recurring Payment-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNRPHNWBUSINTLSTL' , 'VS CAN HNW BUS RC INT' , 1 , null, null, null ,
    'FD1' , 'Recurring Payment-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWBUS' , 'VS CAN HNW BUS ES NAT' , 1 , 2.0 , 0.0 , null ,
    'FD2' , 'Emerging Segment-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWBUS' , 'VS CAN HNW BUS ES NAT' , 1 , null, null, null ,
    'FD2' , 'Emerging Segment-HNW Business, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWBUSINTLSTL' , 'VS CAN HNW BUS ES INT' , 1 , 2.0 , 0.0 , null ,
    'FD3' , 'Emerging Segment-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNEMHNWBUSINTLSTL' , 'VS CAN HNW BUS ES INT' , 1 , null, null, null ,
    'FD3' , 'Emerging Segment-HNW Business, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI1' , 'VS CAN CONS CR IND1 NAT' , 1 , 1.18 , 0.0 , null ,
    'I01' , 'Consumer Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI1' , 'VS CAN CONS CR IND1 NAT' , 1 , null, null, null ,
    'I01' , 'Consumer Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI1INTLSTL' , 'VS CAN CONS CR IND1 INT' , 1 , 1.18 , 0.0 , null ,
    'I02' , 'Consumer Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI1INTLSTL' , 'VS CAN CONS CR IND1 INT' , 1 , null, null, null ,
    'I02' , 'Consumer Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI2' , 'VS CAN CONS CR IND2 NAT' , 1 , 1.33 , 0.0 , null ,
    'I03' , 'Consumer Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI2' , 'VS CAN CONS CR IND2 NAT' , 1 , null, null, null ,
    'I03' , 'Consumer Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI2INTLSTL' , 'VS CAN CONS CR IND2 INT' , 1 , 1.33 , 0.0 , null ,
    'I04' , 'Consumer Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRI2INTLSTL' , 'VS CAN CONS CR IND2 INT' , 1 , null, null, null ,
    'I04' , 'Consumer Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI1' , 'VS CAN BUS IND1 NAT' , 1 , 1.8 , 0.0 , null ,
    'I05' , 'Business Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI1' , 'VS CAN BUS IND1 NAT' , 1 , null, null, null ,
    'I05' , 'Business Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI1INTSTL' , 'VS CAN BUS IND1 INT' , 1 , 1.8 , 0.0 , null ,
    'I06' , 'Business Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI1INTSTL' , 'VS CAN BUS IND1 INT' , 1 , null, null, null ,
    'I06' , 'Business Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI2' , 'VS CAN BUS IND2 NAT' , 1 , 1.85 , 0.0 , null ,
    'I07' , 'Business Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI2' , 'VS CAN BUS IND2 NAT' , 1 , null, null, null ,
    'I07' , 'Business Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI2INTSTL' , 'VS CAN BUS IND2 INT' , 1 , 1.85 , 0.0 , null ,
    'I08' , 'Business Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRI2INTSTL' , 'VS CAN BUS IND2 INT' , 1 , null, null, null ,
    'I08' , 'Business Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI1' , 'VS CAN COR IND1 NAT' , 1 , 1.8 , 0.0 , null ,
    'I09' , 'Corporate Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI1' , 'VS CAN COR IND1 NAT' , 1 , null, null, null ,
    'I09' , 'Corporate Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI1INTSTL' , 'VS CAN COR IND1 INT' , 1 , 1.8 , 0.0 , null ,
    'I10' , 'Corporate Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI1INTSTL' , 'VS CAN COR IND1 INT' , 1 , null, null, null ,
    'I10' , 'Corporate Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI2' , 'VS CAN COR IND2 NAT' , 1 , 1.85 , 0.0 , null ,
    'I11' , 'Corporate Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI2' , 'VS CAN COR IND2 NAT' , 1 , null, null, null ,
    'I11' , 'Corporate Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI2INTSTL' , 'VS CAN COR IND2 INT' , 1 , 1.85 , 0.0 , null ,
    'I12' , 'Corporate Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRI2INTSTL' , 'VS CAN COR IND2 INT' , 1 , null, null, null ,
    'I12' , 'Corporate Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI1' , 'VS CAN PUR IND1 NAT' , 1 , 1.8 , 0.0 , null ,
    'I13' , 'Purchasing Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI1' , 'VS CAN PUR IND1 NAT' , 1 , null, null, null ,
    'I13' , 'Purchasing Credit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI1INTSTL' , 'VS CAN PUR IND1 INT' , 1 , 1.8 , 0.0 , null ,
    'I14' , 'Purchasing Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI1INTSTL' , 'VS CAN PUR IND1 INT' , 1 , null, null, null ,
    'I14' , 'Purchasing Credit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI2' , 'VS CAN PUR IND2 NAT' , 1 , 1.85 , 0.0 , null ,
    'I15' , 'Purchasing Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI2' , 'VS CAN PUR IND2 NAT' , 1 , null, null, null ,
    'I15' , 'Purchasing Credit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI2INTSTL' , 'VS CAN PUR IND2 INT' , 1 , 1.85 , 0.0 , null ,
    'I16' , 'Purchasing Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRI2INTSTL' , 'VS CAN PUR IND2 INT' , 1 , null, null, null ,
    'I16' , 'Purchasing Credit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI1' , 'VS CAN PP IND1 NAT' , 1 , 1.18 , 0.0 , null ,
    'I21' , 'Prepaid, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI1' , 'VS CAN PP IND1 NAT' , 1 , null, null, null ,
    'I21' , 'Prepaid, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI1INTSTL' , 'VS CAN PP IND1 INT' , 1 , 1.25 , 0.0 , null ,
    'I22' , 'Prepaid, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI1INTSTL' , 'VS CAN PP IND1 INT' , 1 , null, null, null ,
    'I22' , 'Prepaid, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI2' , 'VS CAN PP IND2 NAT' , 1 , 1.33 , 0.0 , null ,
    'I23' , 'Prepaid, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI2' , 'VS CAN PP IND2 NAT' , 1 , null, null, null ,
    'I23' , 'Prepaid, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI2INTSTL' , 'VS CAN PP IND2 INT' , 1 , 1.33 , 0.0 , null ,
    'I24' , 'Prepaid, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPI2INTSTL' , 'VS CAN PP IND2 INT' , 1 , null, null, null ,
    'I24' , 'Prepaid, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI1' , 'VS CAN DB IND1 NAT' , 1 , 0.15 , 0.05 , null ,
    'I41' , 'Debit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI1' , 'VS CAN DB IND1 NAT' , 1 , null, null, null ,
    'I41' , 'Debit, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI1INTSTL' , 'VS CAN DB IND1 INT' , 1 , 0.15 , 0.05 , null ,
    'I42' , 'Debit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI1INTSTL' , 'VS CAN DB IND1 INT' , 1 , null, null, null ,
    'I42' , 'Debit, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI2' , 'VS CAN DB IND2 NAT' , 1 , 0.15 , 0.05 , null ,
    'I43' , 'Debit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI2' , 'VS CAN DB IND2 NAT' , 1 , null, null, null ,
    'I43' , 'Debit, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI2INTSTL' , 'VS CAN DB IND2 INT' , 1 , 0.15 , 0.05 , null ,
    'I44' , 'Debit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBI2INTSTL' , 'VS CAN DB IND2 INT' , 1 , null, null, null ,
    'I44' , 'Debit, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI1' , 'VS CAN COMM PP IND1 NAT' , 1 , 1.8 , 0.0 , null ,
    'I49' , 'Commercial Prepaid, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI1' , 'VS CAN COMM PP IND1 NAT' , 1 , null, null, null ,
    'I49' , 'Commercial Prepaid, Industry1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI1INTSTL' , 'VS CAN COMM PP IND1 INT' , 1 , 1.8 , 0.0 , null ,
    'I50' , 'Commercial Prepaid, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI1INTSTL' , 'VS CAN COMM PP IND1 INT' , 1 , null, null, null ,
    'I50' , 'Commercial Prepaid, Industry1, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI2' , 'VS CAN COMM PP IND2 NAT' , 1 , 1.85 , 0.0 , null ,
    'I51' , 'Commercial Prepaid, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI2' , 'VS CAN COMM PP IND2 NAT' , 1 , null, null, null ,
    'I51' , 'Commercial Prepaid, Industry2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI2INTSTL' , 'VS CAN COMM PP IND2 INT' , 1 , 1.85 , 0.0 , null ,
    'I52' , 'Commercial Prepaid, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPI2INTSTL' , 'VS CAN COMM PP IND2 INT' , 1 , null, null, null ,
    'I52' , 'Commercial Prepaid, Industry2, internationally-settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT1INTLSTL' , 'VS CAN BUS TR1 INT' , 1 , 1.8 , 0.0 , null ,
    'P01' , 'Business Credit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT1INTLSTL' , 'VS CAN BUS TR1 INT' , 1 , null, null, null ,
    'P01' , 'Business Credit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT1' , 'VS CAN BUS TR1 NAT' , 1 , 1.8 , 0.0 , null ,
    'P02' , 'Business Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT1' , 'VS CAN BUS TR1 NAT' , 1 , null, null, null ,
    'P02' , 'Business Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT2INTLSTL' , 'VS CAN BUS TR2 INT' , 1 , 1.85 , 0.0 , null ,
    'P03' , 'Business Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT2INTLSTL' , 'VS CAN BUS TR2 INT' , 1 , null, null, null ,
    'P03' , 'Business Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT2' , 'VS CAN BUS TR2 NAT' , 1 , 1.85 , 0.0 , null ,
    'P04' , 'Business Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSCRT2' , 'VS CAN BUS TR2 NAT' , 1 , null, null, null ,
    'P04' , 'Business Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT1INTLSTL' , 'VS CAN CONS CR TR1 INT' , 1 , 1.37 , 0.0 , null ,
    'P07' , 'Consumer Credit, Consumer Performance Incentive Tier 1, internationall' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT1INTLSTL' , 'VS CAN CONS CR TR1 INT' , 1 , null, null, null ,
    'P07' , 'Consumer Credit, Consumer Performance Incentive Tier 1, internationall' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT1' , 'VS CAN CONS CR TR1 NAT' , 1 , 1.37 , 0.0 , null ,
    'P08' , 'Consumer Credit, Consumer Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT1' , 'VS CAN CONS CR TR1 NAT' , 1 , null, null, null ,
    'P08' , 'Consumer Credit, Consumer Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT2INTLSTL' , 'VS CAN CONS CR TR2 INT' , 1 , 1.41 , 0.0 , null ,
    'P09' , 'Consumer Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT2INTLSTL' , 'VS CAN CONS CR TR2 INT' , 1 , null, null, null ,
    'P09' , 'Consumer Credit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT2' , 'VS CAN CONS CR TR2 NAT' , 1 , 1.41 , 0.0 , null ,
    'P10' , 'Consumer Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCONCRT2' , 'VS CAN CONS CR TR2 NAT' , 1 , null, null, null ,
    'P10' , 'Consumer Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT1INTLSTL' , 'VS CAN COR TR1 INT' , 1 , 1.8 , 0.0 , null ,
    'P13' , 'Corporate Credit, Performance Incentive Tier 1, internationally settle' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT1INTLSTL' , 'VS CAN COR TR1 INT' , 1 , null, null, null ,
    'P13' , 'Corporate Credit, Performance Incentive Tier 1, internationally settle' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT1' , 'VS CAN COR TR1 NAT' , 1 , 1.8 , 0.0 , null ,
    'P14' , 'Corporate Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT1' , 'VS CAN COR TR1 NAT' , 1 , null, null, null ,
    'P14' , 'Corporate Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT2INTLSTL' , 'VS CAN COR TR2 INT' , 1 , 1.85 , 0.0 , null ,
    'P15' , 'Corporate Credit, Performance Incentive Tier 2, internationally settle' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT2INTLSTL' , 'VS CAN COR TR2 INT' , 1 , null, null, null ,
    'P15' , 'Corporate Credit, Performance Incentive Tier 2, internationally settle' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT2' , 'VS CAN COR TR2 NAT' , 1 , 1.85 , 0.0 , null ,
    'P16' , 'Corporate Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORCRT2' , 'VS CAN COR TR2 NAT' , 1 , null, null, null ,
    'P16' , 'Corporate Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT1INTLSTL' , 'VS CAN PP TR1 INT' , 1 , 1.37 , 0.0 , null ,
    'P25' , 'Prepaid, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT1INTLSTL' , 'VS CAN PP TR1 INT' , 1 , null, null, null ,
    'P25' , 'Prepaid, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT1' , 'VS CAN PP TR1 NAT' , 1 , 1.37 , 0.0 , null ,
    'P26' , 'Prepaid, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT1' , 'VS CAN PP TR1 NAT' , 1 , null, null, null ,
    'P26' , 'Prepaid, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT2INTLSTL' , 'VS CAN PP TR2 INT' , 1 , 1.41 , 0.0 , null ,
    'P27' , 'Prepaid, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT2INTLSTL' , 'VS CAN PP TR2 INT' , 1 , null, null, null ,
    'P27' , 'Prepaid, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT2' , 'VS CAN PP TR2 NAT' , 1 , 1.41 , 0.0 , null ,
    'P28' , 'Prepaid, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPT2' , 'VS CAN PP TR2 NAT' , 1 , null, null, null ,
    'P28' , 'Prepaid, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT1INTLSTL' , 'VS CAN PUR TR1 INT' , 1 , 1.8 , 0.0 , null ,
    'P31' , 'Purchasing Credit, Performance Incentive Tier 1, internationally settl' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT1INTLSTL' , 'VS CAN PUR TR1 INT' , 1 , null, null, null ,
    'P31' , 'Purchasing Credit, Performance Incentive Tier 1, internationally settl' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT1' , 'VS CAN PUR TR1 NAT' , 1 , 1.8 , 0.0 , null ,
    'P32' , 'Purchasing Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT1' , 'VS CAN PUR TR1 NAT' , 1 , null, null, null ,
    'P32' , 'Purchasing Credit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT2INTLSTL' , 'VS CAN PUR TR2 INT' , 1 , 1.85 , 0.0 , null ,
    'P33' , 'Purchasing Credit, Performance Incentive Tier 2, internationally settl' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT2INTLSTL' , 'VS CAN PUR TR2 INT' , 1 , null, null, null ,
    'P33' , 'Purchasing Credit, Performance Incentive Tier 2, internationally settl' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT2' , 'VS CAN PUR TR2 NAT' , 1 , 1.85 , 0.0 , null ,
    'P34' , 'Purchasing Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURCRT2' , 'VS CAN PUR TR2 NAT' , 1 , null, null, null ,
    'P34' , 'Purchasing Credit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT1' , 'VS CAN DB TR1 NAT' , 1 , 0.15 , 0.05 , null ,
    'P61' , 'Debit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT1' , 'VS CAN DB TR1 NAT' , 1 , null, null, null ,
    'P61' , 'Debit, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT1INTLSTL' , 'VS CAN DB TR1 INT' , 1 , 0.15 , 0.05 , null ,
    'P62' , 'Debit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT1INTLSTL' , 'VS CAN DB TR1 INT' , 1 , null, null, null ,
    'P62' , 'Debit, Performance Incentive Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT2' , 'VS CAN DB TR2 NAT' , 1 , 0.15 , 0.05 , null ,
    'P63' , 'Debit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT2' , 'VS CAN DB TR2 NAT' , 1 , null, null, null ,
    'P63' , 'Debit, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT2INTLSTL' , 'VS CAN DB TR2 INT' , 1 , 0.15 , 0.05 , null ,
    'P64' , 'Debit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBT2INTLSTL' , 'VS CAN DB TR2 INT' , 1 , null, null, null ,
    'P64' , 'Debit, Performance Incentive Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT1INTLSTL' , 'VS CAN COMM PP TR1 NAT' , 1 , 1.8 , 0.0 , null ,
    'P73' , 'Commercial Prepaid, Performance Incentive Tier 1, internationally sett' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT1INTLSTL' , 'VS CAN COMM PP TR1 NAT' , 1 , null, null, null ,
    'P73' , 'Commercial Prepaid, Performance Incentive Tier 1, internationally sett' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT1' , 'VS CAN COMM PP TR1 INT' , 1 , 1.8 , 0.0 , null ,
    'P74' , 'Commercial Prepaid, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT1' , 'VS CAN COMM PP TR1 INT' , 1 , null, null, null ,
    'P74' , 'Commercial Prepaid, Performance Incentive Tier 1, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT2INTLSTL' , 'VS CAN COMM PP TR2 NAT' , 1 , 1.85 , 0.0 , null ,
    'P75' , 'Commercial Prepaid, Performance Incentive Tier 2, internationally sett' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT2INTLSTL' , 'VS CAN COMM PP TR2 NAT' , 1 , null, null, null ,
    'P75' , 'Commercial Prepaid, Performance Incentive Tier 2, internationally sett' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT2' , 'VS CAN COMM PP TR2 INT' , 1 , 1.85 , 0.0 , null ,
    'P76' , 'Commercial Prepaid, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPT2' , 'VS CAN COMM PP TR2 INT' , 1 , null, null, null ,
    'P76' , 'Commercial Prepaid, Performance Incentive Tier 2, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTD' , 'VS CAN NATL SETTLED' , 1 , 1.52 , 0.0 , null ,
    'S01' , 'Standard - Consumer card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTD' , 'VS CAN NATL SETTLED' , 1 , null, null, null ,
    'S01' , 'Standard - Consumer card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINTLSTL' , 'VS CAN INTL SETTLED' , 1 , 1.52 , 0.0 , null ,
    'S02' , 'Standard - Consumer card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNINTLSTL' , 'VS CAN INTL SETTLED' , 1 , null, null, null ,
    'S02' , 'Standard - Consumer card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSSTD' , 'VS CAN BUS NATL' , 1 , 2.0 , 0.0 , null ,
    'S03' , 'Standard - Business card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSSTD' , 'VS CAN BUS NATL' , 1 , null, null, null ,
    'S03' , 'Standard - Business card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSINTLSTL' , 'VS CAN BUS INTL' , 1 , 2.0 , 0.0 , null ,
    'S04' , 'Standard - Business card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNBUSINTLSTL' , 'VS CAN BUS INTL' , 1 , null, null, null ,
    'S04' , 'Standard - Business card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORSTD' , 'VS CAN CORP NATL' , 1 , 2.0 , 0.0 , null ,
    'S05' , 'Standard - Corporate card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORSTD' , 'VS CAN CORP NATL' , 1 , null, null, null ,
    'S05' , 'Standard - Corporate card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORINTLSTL' , 'VS CAN CORP INTL' , 1 , 2.0 , 0.0 , null ,
    'S06' , 'Standard - Corporate card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCORINTLSTL' , 'VS CAN CORP INTL' , 1 , null, null, null ,
    'S06' , 'Standard - Corporate card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURSTD' , 'VS CAN PURCH NATL' , 1 , 2.0 , 0.0 , null ,
    'S07' , 'Standard - Purchasing card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURSTD' , 'VS CAN PURCH NATL' , 1 , null, null, null ,
    'S07' , 'Standard - Purchasing card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURINTLSTL' , 'VS CAN PURCH INTL' , 1 , 2.0 , 0.0 , null ,
    'S08' , 'Standard - Purchasing card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPURINTLSTL' , 'VS CAN PURCH INTL' , 1 , null, null, null ,
    'S08' , 'Standard - Purchasing card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBSTD' , 'VS CAN DB NATL' , 1 , 1.15 , 0.0 , null ,
    'S09' , 'Standard - Debit card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBSTD' , 'VS CAN DB NATL' , 1 , null, null, null ,
    'S09' , 'Standard - Debit card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPSTD' , 'VS CAN PP NATL' , 1 , 1.52 , 0.0 , null ,
    'S10' , 'Standard - Prepaid card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPSTD' , 'VS CAN PP NATL' , 1 , null, null, null ,
    'S10' , 'Standard - Prepaid card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBINTLSTL' , 'VS CAN DB INTL' , 1 , 1.52 , 0.0 , null ,
    'S11' , 'Standard - Debit card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNDBINTLSTL' , 'VS CAN DB INTL' , 1 , null, null, null ,
    'S11' , 'Standard - Debit card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPINTLSTL' , 'VS CAN PP INTL' , 1 , 1.25 , 0.0 , null ,
    'S12' , 'Standard - Prepaid card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNPPINTLSTL' , 'VS CAN PP INTL' , 1 , null, null, null ,
    'S12' , 'Standard - Prepaid card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP1' , 'VS CAN STP1 NNSS' , 1 , 2.0 , 0.0 , null ,
    'S14' , 'Straight Through Processing Payments Tier 1 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP1' , 'VS CAN STP1 NNSS' , 1 , null, null, null ,
    'S14' , 'Straight Through Processing Payments Tier 1 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP1INTLSTL' , 'VS CAN STP1 INTL' , 1 , 2.0 , 0.0 , null ,
    'S15' , 'Straight Through Processing Payments Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP1INTLSTL' , 'VS CAN STP1 INTL' , 1 , null, null, null ,
    'S15' , 'Straight Through Processing Payments Tier 1, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP2' , 'VS CAN STP2 NNSS' , 1 , 1.3 , 35.0 , null ,
    'S16' , 'Straight Through Processing Payments Tier 2 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP2' , 'VS CAN STP2 NNSS' , 1 , null, null, null ,
    'S16' , 'Straight Through Processing Payments Tier 2 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP2INTLSTL' , 'VS CAN STP2 INTL' , 1 , 1.3 , 35.0 , null ,
    'S17' , 'Straight Through Processing Payments Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP2INTLSTL' , 'VS CAN STP2 INTL' , 1 , null, null, null ,
    'S17' , 'Straight Through Processing Payments Tier 2, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP3' , 'VS CAN STP3 NNSS' , 1 , 1.2 , 35.0 , null ,
    'S18' , 'Straight Through Processing Payments Tier 3 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP3' , 'VS CAN STP3 NNSS' , 1 , null, null, null ,
    'S18' , 'Straight Through Processing Payments Tier 3 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP3INTLSTL' , 'VS CAN STP3 INTL' , 1 , 1.2 , 35.0 , null ,
    'S19' , 'Straight Through Processing Payments Tier 3, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP3INTLSTL' , 'VS CAN STP3 INTL' , 1 , null, null, null ,
    'S19' , 'Straight Through Processing Payments Tier 3, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP4' , 'VS CAN STP4 NNSS' , 1 , 1.1 , 35.0 , null ,
    'S20' , 'Straight Through Processing Payments Tier 4 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP4' , 'VS CAN STP4 NNSS' , 1 , null, null, null ,
    'S20' , 'Straight Through Processing Payments Tier 4 NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP4INTLSTL' , 'VS CAN STP5 INTL' , 1 , 1.1 , 35.0 , null ,
    'S21' , 'Straight Through Processing Payments Tier 4, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNSTP4INTLSTL' , 'VS CAN STP5 INTL' , 1 , null, null, null ,
    'S21' , 'Straight Through Processing Payments Tier 4, internationally settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPSTD' , 'VS CAN COMM PP NATL' , 1 , 2.0 , 0.0 , null ,
    'S22' , 'Standard - Commercial prepaid card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPSTD' , 'VS CAN COMM PP NATL' , 1 , null, null, null ,
    'S22' , 'Standard - Commercial prepaid card, NNSS' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPINTLSTL' , 'VS CAN COMM PP INTL' , 1 , 2.0 , 0.0 , null ,
    'S23' , 'Standard - Commercial prepaid card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '0104CNCOMMPPINTLSTL' , 'VS CAN COMM PP INTL' , 1 , null, null, null ,
    'S23' , 'Standard - Commercial prepaid card, Intl Settlement Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
