-- Number of arguments: 2 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'U.S._Interchange_Fees_for_April_2016_(04-07-2016).xls']
rem gathering mas_codes from spreadsheet

rem delete FLMGR_ICHG_RATES_TEMPLATE;

-- Number of arguments: 2 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'U.S._Interchange_Fees_for_April_2016_(04-14-2016).xls']
rem gathering mas_codes from spreadsheet

rem delete FLMGR_ICHG_RATES_TEMPLATE;


rem Discover


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CC' , 'DS CONS ADJ VOUCHER 1 CORE' , 2 , 2.07 , 0.0 , null , 
    '172' , 'US Consumer Adjustment Voucher Program 1 Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CC' , 'DS CONS ADJ VOUCHER 1 CORE' , 2 , null, null, null , 
    '172' , 'US Consumer Adjustment Voucher Program 1 Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CD' , 'DS CONS ADJ VOUCHER 1 DEBIT' , 2 , 1.8 , 0.0 , null , 
    '131' , 'US Consumer Adjustment Voucher Program 1 Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CD' , 'DS CONS ADJ VOUCHER 1 DEBIT' , 2 , null, null, null , 
    '131' , 'US Consumer Adjustment Voucher Program 1 Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CDNXFP' , 'DS CONS ADJ VCHR1 DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '387' , 'US Consumer Adjustment Voucher Program 1 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CDNXFP' , 'DS CONS ADJ VCHR1 DBNEXMPT FRD' , 1 , null, null, null , 
    '387' , 'US Consumer Adjustment Voucher Program 1 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CO' , 'DS COMM ADJ VOUCHER 1' , 3 , 2.25 , 0.0 , null , 
    '136' , 'US Commercial Adjustment Voucher Program 1' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CO' , 'DS COMM ADJ VOUCHER 1' , 3 , null, null, null , 
    '136' , 'US Commercial Adjustment Voucher Program 1' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CODB' , 'DS COMM ADJ VOUCHER 1 DEBIT' , 3 , 2.25 , 0.0 , null , 
    '430' , 'US Commercial Adjustment Voucher Program 1 Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CODB' , 'DS COMM ADJ VOUCHER 1 DEBIT' , 3 , null, null, null , 
    '430' , 'US Commercial Adjustment Voucher Program 1 Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CONXFP' , 'DS COMM ADJ VCHR1 DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '425' , 'US Commercial Adjustment Voucher Program 1 Debit Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CONXFP' , 'DS COMM ADJ VCHR1 DBNEXMPT FRD' , 1 , null, null, null , 
    '425' , 'US Commercial Adjustment Voucher Program 1 Debit Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1COPR' , 'DS COMM ADJ VOUCHER 1 PREPAID' , 3 , 2.25 , 0.0 , null , 
    '363' , 'US Commercial Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1COPR' , 'DS COMM ADJ VOUCHER 1 PREPAID' , 3 , null, null, null , 
    '363' , 'US Commercial Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1COPRNXFP' , 'DS CO ADJ VCHR 1 PRPDNEXMPT FR' , 1 , 0.0 , 0.0 , null , 
    '420' , 'US Commercial Adjustment Voucher Program 1 Prepaid Non-Exempt Fraud Pr' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1COPRNXFP' , 'DS CO ADJ VCHR 1 PRPDNEXMPT FR' , 1 , null, null, null , 
    '420' , 'US Commercial Adjustment Voucher Program 1 Prepaid Non-Exempt Fraud Pr' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CP' , 'DS CONS ADJ VOUCHER 1 PREMIUM' , 2 , 2.07 , 0.0 , null , 
    '154' , 'US Consumer Adjustment Voucher Program 1 Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CP' , 'DS CONS ADJ VOUCHER 1 PREMIUM' , 2 , null, null, null , 
    '154' , 'US Consumer Adjustment Voucher Program 1 Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CR' , 'DS CONS ADJ VOUCHER 1 REWARDS' , 2 , 2.07 , 0.0 , null , 
    '130' , 'US Consumer Adjustment Voucher Program 1 Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1CR' , 'DS CONS ADJ VOUCHER 1 REWARDS' , 2 , null, null, null , 
    '130' , 'US Consumer Adjustment Voucher Program 1 Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PP' , 'DS CONS ADJ VOUCHER 1 PRM PLUS' , 2 , 2.07 , 0.0 , null , 
    '231' , 'US Consumer Adjustment Voucher Program 1 Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PP' , 'DS CONS ADJ VOUCHER 1 PRM PLUS' , 2 , null, null, null , 
    '231' , 'US Consumer Adjustment Voucher Program 1 Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PR' , 'DS CONS ADJ VOUCHER 1 PREPAID' , 2 , 1.8 , 0.0 , null , 
    '356' , 'US Consumer Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PR' , 'DS CONS ADJ VOUCHER 1 PREPAID' , 2 , null, null, null , 
    '356' , 'US Consumer Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PRNXFP' , 'DS CS ADJ VCHR 1 PRPDNEXMPT FR' , 1 , 0.0 , 0.0 , null , 
    '413' , 'US Consumer Adjustment Voucher Program 1 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP1PRNXFP' , 'DS CS ADJ VCHR 1 PRPDNEXMPT FR' , 1 , null, null, null , 
    '413' , 'US Consumer Adjustment Voucher Program 1 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CC' , 'DS CONS ADJ VOUCHER 2 CORE' , 2 , 2.02 , 0.0 , null , 
    '173' , 'US Consumer Adjustment Voucher Program 2 Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CC' , 'DS CONS ADJ VOUCHER 2 CORE' , 2 , null, null, null , 
    '173' , 'US Consumer Adjustment Voucher Program 2 Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CD' , 'DS CONS ADJ VOUCHER 2 DEBIT' , 1 , 1.69 , 0.0 , null , 
    '133' , 'US Consumer Adjustment Voucher Program 2 Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CD' , 'DS CONS ADJ VOUCHER 2 DEBIT' , 1 , null, null, null , 
    '133' , 'US Consumer Adjustment Voucher Program 2 Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CDNXFP' , 'DS CONS ADJ VCHR2 DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '388' , 'US Consumer Adjustment Voucher Program 2 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CDNXFP' , 'DS CONS ADJ VCHR2 DBNEXMPT FRD' , 1 , null, null, null , 
    '388' , 'US Consumer Adjustment Voucher Program 2 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CP' , 'DS CONS ADJ VOUCHER 2 PREMIUM' , 2 , 2.02 , 0.0 , null , 
    '155' , 'US Consumer Adjustment Voucher Program 2 Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CP' , 'DS CONS ADJ VOUCHER 2 PREMIUM' , 2 , null, null, null , 
    '155' , 'US Consumer Adjustment Voucher Program 2 Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CR' , 'DS CONS ADJ VOUCHER 2 REWARDS' , 2 , 2.02 , 0.0 , null , 
    '132' , 'US Consumer Adjustment Voucher Program 2 Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2CR' , 'DS CONS ADJ VOUCHER 2 REWARDS' , 2 , null, null, null , 
    '132' , 'US Consumer Adjustment Voucher Program 2 Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PP' , 'DS CONS ADJ VOUCHER 2 PRM PLUS' , 2 , 2.02 , 0.0 , null , 
    '232' , 'US Consumer Adjustment Voucher Program 2 Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PP' , 'DS CONS ADJ VOUCHER 2 PRM PLUS' , 2 , null, null, null , 
    '232' , 'US Consumer Adjustment Voucher Program 2 Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PR' , 'DS CONS ADJ VOUCHER 2 PREPAID' , 1 , 1.69 , 0.0 , null , 
    '357' , 'US Consumer Adjustment Voucher Program 2 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PR' , 'DS CONS ADJ VOUCHER 2 PREPAID' , 1 , null, null, null , 
    '357' , 'US Consumer Adjustment Voucher Program 2 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PRNXFP' , 'DS CS ADJ VCHR 2 PRPDNEXMPT FR' , 1 , 0.0 , 0.0 , null , 
    '414' , 'US Consumer Adjustment Voucher Program 2 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP2PRNXFP' , 'DS CS ADJ VCHR 2 PRPDNEXMPT FR' , 1 , null, null, null , 
    '414' , 'US Consumer Adjustment Voucher Program 2 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CC' , 'DS CONS ADJ VOUCHER 3 CORE' , 1 , 1.75 , 0.0 , null , 
    '174' , 'US Consumer Adjustment Voucher Program 3 Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CC' , 'DS CONS ADJ VOUCHER 3 CORE' , 1 , null, null, null , 
    '174' , 'US Consumer Adjustment Voucher Program 3 Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CD' , 'DS CONS ADJ VOUCHER 3 DEBIT' , 1 , 1.35 , 0.0 , null , 
    '135' , 'US Consumer Adjustment Voucher Program 3 Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CD' , 'DS CONS ADJ VOUCHER 3 DEBIT' , 1 , null, null, null , 
    '135' , 'US Consumer Adjustment Voucher Program 3 Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CDNXFP' , 'DS CONS ADJ VCHR3 DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '389' , 'US Consumer Adjustment Voucher Program 3 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CDNXFP' , 'DS CONS ADJ VCHR3 DBNEXMPT FRD' , 1 , null, null, null , 
    '389' , 'US Consumer Adjustment Voucher Program 3 Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CP' , 'DS CONS ADJ VOUCHER 3 PREMIUM' , 1 , 1.75 , 0.0 , null , 
    '156' , 'US Consumer Adjustment Voucher Program 3 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CP' , 'DS CONS ADJ VOUCHER 3 PREMIUM' , 1 , null, null, null , 
    '156' , 'US Consumer Adjustment Voucher Program 3 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CR' , 'DS CONS ADJ VOUCHER 3 REWARDS' , 1 , 1.75 , 0.0 , null , 
    '134' , 'US Consumer Adjustment Voucher Program 3 Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3CR' , 'DS CONS ADJ VOUCHER 3 REWARDS' , 1 , null, null, null , 
    '134' , 'US Consumer Adjustment Voucher Program 3 Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PP' , 'DS CONS ADJ VOUCHER 3 PRM PLUS' , 1 , 1.75 , 0.0 , null , 
    '233' , 'US Consumer Adjustment Voucher Program 3 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PP' , 'DS CONS ADJ VOUCHER 3 PRM PLUS' , 1 , null, null, null , 
    '233' , 'US Consumer Adjustment Voucher Program 3 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PR' , 'DS CONS ADJ VOUCHER 3 PREPAID' , 1 , 1.35 , 0.0 , null , 
    '358' , 'US Consumer Adjustment Voucher Program 3 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PR' , 'DS CONS ADJ VOUCHER 3 PREPAID' , 1 , null, null, null , 
    '358' , 'US Consumer Adjustment Voucher Program 3 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PRNXFP' , 'DS CS ADJ VCHR 3 PRPDNEXMPT FR' , 1 , 0.0 , 0.0 , null , 
    '415' , 'US Consumer Adjustment Voucher Program 3 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVP3PRNXFP' , 'DS CS ADJ VCHR 3 PRPDNEXMPT FR' , 1 , null, null, null , 
    '415' , 'US Consumer Adjustment Voucher Program 3 Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCDNX' , 'DS CS ADJ VCHR DEBIT NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '456' , 'US Consumer Adjustment Voucher Program Debit Non-Exempt W/O Fraud Adju' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCDNX' , 'DS CS ADJ VCHR DEBIT NEXMPT' , 1 , null, null, null , 
    '456' , 'US Consumer Adjustment Voucher Program Debit Non-Exempt W/O Fraud Adju' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCODNX' , 'DS COMM ADJ VCHR DB NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '457' , 'US Consumer Adjustment Voucher Program Prepaid Non-Exempt W/O Fraud Ad' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCODNX' , 'DS COMM ADJ VCHR DB NEXMPT' , 1 , null, null, null , 
    '457' , 'US Consumer Adjustment Voucher Program Prepaid Non-Exempt W/O Fraud Ad' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCOPRNX' , 'DS COMM ADJ VCHR PRPD NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '459' , 'US Commercial Adjustment Voucher Program Prepaid Non-Exempt W/O Fraud' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCOPRNX' , 'DS COMM ADJ VCHR PRPD NEXMPT' , 1 , null, null, null , 
    '459' , 'US Commercial Adjustment Voucher Program Prepaid Non-Exempt W/O Fraud' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCPRNX' , 'DS CS ADJ VCHR PREPAID NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '458' , 'US Commercial Adjustment Voucher Program Debit Non-Exempt W/O Fraud Ad' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08AVPCPRNX' , 'DS CS ADJ VCHR PREPAID NEXMPT' , 1 , null, null, null , 
    '458' , 'US Commercial Adjustment Voucher Program Debit Non-Exempt W/O Fraud Ad' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECC' , 'DS BASE CORE' , 3 , 2.95 , 0.1 , null , 
    '171' , 'US Consumer Base Submission Level Core' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECC' , 'DS BASE CORE' , 3 , null, null, null , 
    '171' , 'US Consumer Base Submission Level Core' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECD' , 'DS BASE DEBIT' , 2 , 1.89 , 0.25 , null , 
    '128' , 'US Consumer Base Submission Level Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECD' , 'DS BASE DEBIT' , 2 , null, null, null , 
    '128' , 'US Consumer Base Submission Level Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECDNXFP' , 'DS BASE DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '386' , 'US Consumer Base Submission Level Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECDNXFP' , 'DS BASE DB NEXMPT FRD' , 1 , null, null, null , 
    '386' , 'US Consumer Base Submission Level Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECP' , 'DS BASE PREMIUM' , 3 , 2.95 , 0.1 , null , 
    '153' , 'US Consumer Base Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECP' , 'DS BASE PREMIUM' , 3 , null, null, null , 
    '153' , 'US Consumer Base Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECR' , 'DS BASE REWARDS' , 3 , 2.95 , 0.1 , null , 
    '127' , 'US Consumer Base Submission Level Rewards' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASECR' , 'DS BASE REWARDS' , 3 , null, null, null , 
    '127' , 'US Consumer Base Submission Level Rewards' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPP' , 'DS BASE PREMIUM PLUS' , 3 , 2.95 , 0.1 , null , 
    '230' , 'US Consumer Base Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPP' , 'DS BASE PREMIUM PLUS' , 3 , null, null, null , 
    '230' , 'US Consumer Base Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPR' , 'DS BASE PREPAID' , 2 , 1.89 , 0.25 , null , 
    '355' , 'US Consumer Base Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPR' , 'DS BASE PREPAID' , 2 , null, null, null , 
    '355' , 'US Consumer Base Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPRNXFP' , 'DS BASE PREPAID NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '412' , 'US Consumer Base Submission Level Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08BASEPRNXFP' , 'DS BASE PREPAID NEXMPT FRD' , 1 , null, null, null , 
    '412' , 'US Consumer Base Submission Level Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CASHREIMB' , 'DS CASH REIMBURSEMENT' , 1 , 0.16 , 1.65 , null , 
    '000' , 'Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CASHREIMB' , 'DS CASH REIMBURSEMENT' , 1 , null, null, null , 
    '000' , 'Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CDNX' , 'DS DB NEXMPT' , 1 , 0.05 , 0.21 , null , 
    '452' , 'US Consumer Debit Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CDNX' , 'DS DB NEXMPT' , 1 , null, null, null , 
    '452' , 'US Consumer Debit Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCC' , 'DS CNP CORE' , 2 , 1.87 , 0.1 , null , 
    '463' , 'US Consumer Card Not Present Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCC' , 'DS CNP CORE' , 2 , null, null, null , 
    '463' , 'US Consumer Card Not Present Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCD' , 'DS CNP DEBIT' , 1 , 1.75 , 0.2 , null , 
    '461' , 'US Consumer Card Not Present Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCD' , 'DS CNP DEBIT' , 1 , null, null, null , 
    '461' , 'US Consumer Card Not Present Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCDNXFP' , 'DS CNP DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '466' , 'US Consumer Card Not Present Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCDNXFP' , 'DS CNP DB NEXMPT FRD' , 1 , null, null, null , 
    '466' , 'US Consumer Card Not Present Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCP' , 'DS CNP PREMIUM' , 2 , 2.0 , 0.1 , null , 
    '462' , 'US Consumer Card Not Present Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCP' , 'DS CNP PREMIUM' , 2 , null, null, null , 
    '462' , 'US Consumer Card Not Present Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCR' , 'DS CNP REWARDS' , 2 , 1.97 , 0.1 , null , 
    '460' , 'US Consumer Card Not Present Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPCR' , 'DS CNP REWARDS' , 2 , null, null, null , 
    '460' , 'US Consumer Card Not Present Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPP' , 'DS CNP PREMIUM PLUS' , 3 , 2.35 , 0.1 , null , 
    '464' , 'US Consumer Card Not Present Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPP' , 'DS CNP PREMIUM PLUS' , 3 , null, null, null , 
    '464' , 'US Consumer Card Not Present Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPR' , 'DS CNP PREPAID' , 1 , 1.75 , 0.2 , null , 
    '465' , 'US Consumer Card Not Present Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPR' , 'DS CNP PREPAID' , 1 , null, null, null , 
    '465' , 'US Consumer Card Not Present Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPRNXFP' , 'DS CNP PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '467' , 'US Consumer Card Not Present Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CNPPRNXFP' , 'DS CNP PRPD NEXMPT FRD' , 1 , null, null, null , 
    '467' , 'US Consumer Card Not Present Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CODNX' , 'DS COMM DB NEXMPT' , 1 , 0.05 , 0.21 , null , 
    '454' , 'US Commercial Debit Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CODNX' , 'DS COMM DB NEXMPT' , 1 , null, null, null , 
    '454' , 'US Commercial Debit Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBAS' , 'DS COMM BASE' , 3 , 2.95 , 0.1 , null , 
    '129' , 'US Commercial Base Submission' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBAS' , 'DS COMM BASE' , 3 , null, null, null , 
    '129' , 'US Commercial Base Submission' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASDB' , 'DS COMM BASE DEBIT' , 3 , 2.95 , 0.1 , null , 
    '429' , 'US Commercial Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASDB' , 'DS COMM BASE DEBIT' , 3 , null, null, null , 
    '429' , 'US Commercial Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASNXFP' , 'DS COMM BASE DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '424' , 'US Commercial Base Submission Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASNXFP' , 'DS COMM BASE DB NEXMPT FRD' , 1 , null, null, null , 
    '424' , 'US Commercial Base Submission Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASPR' , 'DS COMM BASE PREPAID' , 3 , 2.95 , 0.1 , null , 
    '362' , 'US Commercial Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASPR' , 'DS COMM BASE PREPAID' , 3 , null, null, null , 
    '362' , 'US Commercial Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASPRNXFP' , 'DS COMM BASE PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '419' , 'US Commercial Base Submission Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMBASPRNXFP' , 'DS COMM BASE PRPD NEXMPT FRD' , 1 , null, null, null , 
    '419' , 'US Commercial Base Submission Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELEC' , 'DS COMM ELECTRONIC' , 3 , 2.3 , 0.1 , null , 
    '124' , 'US Commercial Electronic' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELEC' , 'DS COMM ELECTRONIC' , 3 , null, null, null , 
    '124' , 'US Commercial Electronic' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECDB' , 'DS COMM ELECTRONIC DEBIT' , 3 , 2.3 , 0.1 , null , 
    '428' , 'US Commercial Electronic Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECDB' , 'DS COMM ELECTRONIC DEBIT' , 3 , null, null, null , 
    '428' , 'US Commercial Electronic Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECNXFP' , 'DS COMM ELEC DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '423' , 'US Commercial Electronic Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECNXFP' , 'DS COMM ELEC DB NEXMPT FRD' , 1 , null, null, null , 
    '423' , 'US Commercial Electronic Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECPR' , 'DS COMM ELECTRONIC PREPAID' , 3 , 2.3 , 0.1 , null , 
    '361' , 'US Commercial Electronic Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECPR' , 'DS COMM ELECTRONIC PREPAID' , 3 , null, null, null , 
    '361' , 'US Commercial Electronic Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECPRNXFP' , 'DS CO ELECTRN PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '418' , 'US Commercial Electronic Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMELECPRNXFP' , 'DS CO ELECTRN PRPD NEXMPT FRD' , 1 , null, null, null , 
    '418' , 'US Commercial Electronic Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKT' , 'DS COMM LARGE TICKET' , 3 , 0.9 , 20.0 , null , 
    '260' , 'US Commercial Large Ticket' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKT' , 'DS COMM LARGE TICKET' , 3 , null, null, null , 
    '260' , 'US Commercial Large Ticket' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTDB' , 'DS COMM LARGE TICKET DEBIT' , 3 , 0.9 , 20.0 , null , 
    '427' , 'US Commercial Large Ticket Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTDB' , 'DS COMM LARGE TICKET DEBIT' , 3 , null, null, null , 
    '427' , 'US Commercial Large Ticket Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTNXFP' , 'DS COMM LARGE TKT DBNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '422' , 'US Commercial Large Ticket Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTNXFP' , 'DS COMM LARGE TKT DBNEXMPT FRD' , 1 , null, null, null , 
    '422' , 'US Commercial Large Ticket Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTPR' , 'DS COMM LARGE TKT PREPAID' , 1 , 0.9 , 20.0 , null , 
    '360' , 'US Commercial Large Ticket Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTPR' , 'DS COMM LARGE TKT PREPAID' , 1 , null, null, null , 
    '360' , 'US Commercial Large Ticket Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTPRNXFP' , 'DS COMM LG TKT PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '417' , 'US Commercial Large Ticket Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMLRGTKTPRNXFP' , 'DS COMM LG TKT PRPD NEXMPT FRD' , 1 , null, null, null , 
    '417' , 'US Commercial Large Ticket Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTL' , 'DS COMM UTILITIES' , 1 , 0.0 , 1.5 , null , 
    '183' , 'US Commercial Utilities' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTL' , 'DS COMM UTILITIES' , 1 , null, null, null , 
    '183' , 'US Commercial Utilities' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLDB' , 'DS COMM UTILITIES DEBIT' , 1 , 0.0 , 1.5 , null , 
    '426' , 'US Commercial Utilities Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLDB' , 'DS COMM UTILITIES DEBIT' , 1 , null, null, null , 
    '426' , 'US Commercial Utilities Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLNXFP' , 'DS COMM UTILITIES DBNEXMPT FRD' , 1 , 0.05 , 0.21 , null , 
    '421' , 'US Commercial Utilities Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLNXFP' , 'DS COMM UTILITIES DBNEXMPT FRD' , 1 , null, null, null , 
    '421' , 'US Commercial Utilities Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLPR' , 'DS COMM UTILITIES PREPAID' , 1 , 0.0 , 1.5 , null , 
    '359' , 'US Commercial Utilities Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLPR' , 'DS COMM UTILITIES PREPAID' , 1 , null, null, null , 
    '359' , 'US Commercial Utilities Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLPRNXFP' , 'DS COMM UTIL PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '416' , 'US Commercial Utilities Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COMUTLPRNXFP' , 'DS COMM UTIL PRPD NEXMPT FRD' , 1 , null, null, null , 
    '416' , 'US Commercial Utilities Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COPRNX' , 'DS COMM PRPD NEXMPT' , 1 , 0.05 , 0.21 , null , 
    '455' , 'US Commercial Prepaid Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08COPRNX' , 'DS COMM PRPD NEXMPT' , 1 , null, null, null , 
    '455' , 'US Commercial Prepaid Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CPRNX' , 'DS PREPAID NEXMPT' , 1 , 0.05 , 0.21 , null , 
    '453' , 'US Consumer Prepaid Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08CPRNX' , 'DS PREPAID NEXMPT' , 1 , null, null, null , 
    '453' , 'US Consumer Prepaid Non-Exempt W/O Fraud Adjustment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCC' , 'DS DEFAULT BASE SUB CORE' , 2 , 2.95 , 0.1 , null , 
    '995' , 'US Consumer Default Base Submission Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCC' , 'DS DEFAULT BASE SUB CORE' , 2 , null, null, null , 
    '995' , 'US Consumer Default Base Submission Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCD' , 'DS DEFAULT BASE SUB DEBIT' , 2 , 1.89 , 0.25 , null , 
    '998' , 'US Consumer Default Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCD' , 'DS DEFAULT BASE SUB DEBIT' , 2 , null, null, null , 
    '998' , 'US Consumer Default Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCDNX' , 'DS DEFAULT BASE SUB DB NEXMPT' , 1 , 0.05 , 0.21 , null , 
    '1030' , 'US Consumer Default Base Submission Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCDNX' , 'DS DEFAULT BASE SUB DB NEXMPT' , 1 , null, null, null , 
    '1030' , 'US Consumer Default Base Submission Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCDNXFP' , 'DS DEFLT BASE SUB DBNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '998' , 'US Consumer Default Base Submission Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCDNXFP' , 'DS DEFLT BASE SUB DBNEXMPT FRD' , 1 , null, null, null , 
    '998' , 'US Consumer Default Base Submission Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCO' , 'DS DEFAULT COMMERCIAL BASE SUB' , 3 , 2.95 , 0.1 , null , 
    '999' , 'US Commercial Default Base Submission' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCO' , 'DS DEFAULT COMMERCIAL BASE SUB' , 3 , null, null, null , 
    '999' , 'US Commercial Default Base Submission' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCODB' , 'DS DEFAULT COMM BASE DEBIT' , 3 , 2.95 , 0.1 , null , 
    '999' , 'US Commercial Default Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCODB' , 'DS DEFAULT COMM BASE DEBIT' , 3 , null, null, null , 
    '999' , 'US Commercial Default Base Submission Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCONX' , 'DS DEFAULT COMM BASE DB NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '1032' , 'US Commercial Default Base Submission Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCONX' , 'DS DEFAULT COMM BASE DB NEXMPT' , 1 , null, null, null , 
    '1032' , 'US Commercial Default Base Submission Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCONXFP' , 'DS DFLT COMM BASE DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '999' , 'US Commercial Default Base Submission Debit Non-Exempt Fraud Preventio' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCONXFP' , 'DS DFLT COMM BASE DBNEXMPT FRD' , 1 , null, null, null , 
    '999' , 'US Commercial Default Base Submission Debit Non-Exempt Fraud Preventio' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPR' , 'DS DEFAULT COMM BASE SUB PRPD' , 3 , 2.95 , 0.1 , null , 
    '1012' , 'US Commercial Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPR' , 'DS DEFAULT COMM BASE SUB PRPD' , 3 , null, null, null , 
    '1012' , 'US Commercial Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPRNX' , 'DS DF CO BASE SUB PRPD NEXMPT' , 3 , 0.0 , 0.0 , null , 
    '1033' , 'US Commercial Default Base Submission Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPRNX' , 'DS DF CO BASE SUB PRPD NEXMPT' , 3 , null, null, null , 
    '1033' , 'US Commercial Default Base Submission Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPRNXFP' , 'DS DF CO BASE SUB PRPD EXT FRD' , 3 , 0.0 , 0.0 , null , 
    '999' , 'US Commercial Default Base Submission Prepaid Non-Exempt Fraud Prevent' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCOPRNXFP' , 'DS DF CO BASE SUB PRPD EXT FRD' , 3 , null, null, null , 
    '999' , 'US Commercial Default Base Submission Prepaid Non-Exempt Fraud Prevent' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCP' , 'DS DEFAULT BASE SUB PREMIUM' , 2 , 2.95 , 0.1 , null , 
    '996' , 'US Consumer Default Base Submission Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCP' , 'DS DEFAULT BASE SUB PREMIUM' , 2 , null, null, null , 
    '996' , 'US Consumer Default Base Submission Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCR' , 'DS DEFAULT BASE SUB REWARDS' , 2 , 2.95 , 0.1 , null , 
    '997' , 'US Consumer Default Base Submission Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPCR' , 'DS DEFAULT BASE SUB REWARDS' , 2 , null, null, null , 
    '997' , 'US Consumer Default Base Submission Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPP' , 'DS DEFAULT BASE SUB PRM PLUS' , 3 , 2.95 , 0.1 , null , 
    '1000' , 'US Consumer Default Base Submission Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPP' , 'DS DEFAULT BASE SUB PRM PLUS' , 3 , null, null, null , 
    '1000' , 'US Consumer Default Base Submission Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPR' , 'DS DEFAULT BASE SUB PRPAID' , 2 , 1.89 , 0.25 , null , 
    '1006' , 'US Consumer Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPR' , 'DS DEFAULT BASE SUB PRPAID' , 2 , null, null, null , 
    '1006' , 'US Consumer Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPRNX' , 'DS DF BASE SUB PRPD NEXMPT' , 2 , 0.05 , 0.21 , null , 
    '1031' , 'US Consumer Default Base Submission Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPRNX' , 'DS DF BASE SUB PRPD NEXMPT' , 2 , null, null, null , 
    '1031' , 'US Consumer Default Base Submission Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPRNXFP' , 'DS DF BASE SUB PRPD NEXMPT FRD' , 2 , 0.05 , 0.22 , null , 
    '991' , 'US Consumer Default Base Submission Prepaid Non-Exempt Fraud Preventio' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DAVPPRNXFP' , 'DS DF BASE SUB PRPD NEXMPT FRD' , 2 , null, null, null , 
    '991' , 'US Consumer Default Base Submission Prepaid Non-Exempt Fraud Preventio' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCC' , 'DS DEFAULT ADJ VOUCHER CORE' , 1 , 2.07 , 0.0 , null , 
    '904' , 'US Consumer Default Adjustment Voucher Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCC' , 'DS DEFAULT ADJ VOUCHER CORE' , 1 , null, null, null , 
    '904' , 'US Consumer Default Adjustment Voucher Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCD' , 'DS DEFAULT ADJ VOUCHER DEBIT' , 1 , 1.8 , 0.0 , null , 
    '901' , 'US Consumer Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCD' , 'DS DEFAULT ADJ VOUCHER DEBIT' , 1 , null, null, null , 
    '901' , 'US Consumer Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCDNX' , 'DS DEFAULT ADJ VCHR DB NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '1034' , 'US Consumer Default Adjustment Voucher Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCDNX' , 'DS DEFAULT ADJ VCHR DB NEXMPT' , 1 , null, null, null , 
    '1034' , 'US Consumer Default Adjustment Voucher Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCDNXFP' , 'DS DEFLT ADJ VCHR DBNEXMPT FRD' , 1 , 0.0 , 0.0 , null , 
    '901' , 'US Consumer Default Adjustment Voucher Debit Non-Exempt Fraud Preventi' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCDNXFP' , 'DS DEFLT ADJ VCHR DBNEXMPT FRD' , 1 , null, null, null , 
    '901' , 'US Consumer Default Adjustment Voucher Debit Non-Exempt Fraud Preventi' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCO' , 'DS DEFAULT ADJ COMM VOUCHER' , 3 , 2.25 , 0.0 , null , 
    '902' , 'US Commercial Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCO' , 'DS DEFAULT ADJ COMM VOUCHER' , 3 , null, null, null , 
    '902' , 'US Commercial Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCODB' , 'DS DFLT ADJ CO VOUCHER DEBIT' , 3 , 2.25 , 0.0 , null , 
    '902' , 'US Commercial Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCODB' , 'DS DFLT ADJ CO VOUCHER DEBIT' , 3 , null, null, null , 
    '902' , 'US Commercial Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCONX' , 'DS DFLT ADJ CO VCHR DB NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '1036' , 'US Commercial Default Adjustment Voucher Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCONX' , 'DS DFLT ADJ CO VCHR DB NEXMPT' , 1 , null, null, null , 
    '1036' , 'US Commercial Default Adjustment Voucher Debit Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCONXFP' , 'DS DFLT ADJ CO VCHR DB EXT FRD' , 1 , 0.0 , 0.0 , null , 
    '902' , 'US Commercial Default Adjustment Voucher Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCONXFP' , 'DS DFLT ADJ CO VCHR DB EXT FRD' , 1 , null, null, null , 
    '902' , 'US Commercial Default Adjustment Voucher Debit Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPR' , 'DS DFLT ADJ CO VCHR PREPAID' , 3 , 2.95 , 0.1 , null , 
    '1013' , 'US Commercial Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPR' , 'DS DFLT ADJ CO VCHR PREPAID' , 3 , null, null, null , 
    '1013' , 'US Commercial Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPRNX' , 'DS DF ADJ CO VCHR PPD NEXMPT' , 3 , 0.0 , 0.0 , null , 
    '1037' , 'US Commercial Default Adjustment Voucher Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPRNX' , 'DS DF ADJ CO VCHR PPD NEXMPT' , 3 , null, null, null , 
    '1037' , 'US Commercial Default Adjustment Voucher Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPRNXFP' , 'DS DF ADJ CO VCHR PPD EXT FRD' , 3 , 0.0 , 0.0 , null , 
    '907' , 'US Commercial Default Adjustment Voucher Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCOPRNXFP' , 'DS DF ADJ CO VCHR PPD EXT FRD' , 3 , null, null, null , 
    '907' , 'US Commercial Default Adjustment Voucher Prepaid Non-Exempt Fraud Prev' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCP' , 'DS DEFAULT ADJ VOUCHER PREM' , 1 , 2.07 , 0.0 , null , 
    '903' , 'US Consumer Default Adjustment Voucher Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCP' , 'DS DEFAULT ADJ VOUCHER PREM' , 1 , null, null, null , 
    '903' , 'US Consumer Default Adjustment Voucher Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCR' , 'DS DFLT ADJ VOUCHER REWARDS' , 1 , 2.07 , 0.0 , null , 
    '900' , 'US Consumer Default Adjustment Voucher Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFCR' , 'DS DFLT ADJ VOUCHER REWARDS' , 1 , null, null, null , 
    '900' , 'US Consumer Default Adjustment Voucher Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPP' , 'DS DEFAULT ADJ VOUCHER PRM PLS' , 1 , 2.07 , 0.0 , null , 
    '905' , 'US Consumer Default Adjustment Voucher Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPP' , 'DS DEFAULT ADJ VOUCHER PRM PLS' , 1 , null, null, null , 
    '905' , 'US Consumer Default Adjustment Voucher Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPR' , 'DS DEFAULT ADJ VOUCHER PREPAID' , 1 , 1.8 , 0.0 , null , 
    '1010' , 'US Consumer Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPR' , 'DS DEFAULT ADJ VOUCHER PREPAID' , 1 , null, null, null , 
    '1010' , 'US Consumer Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPRNX' , 'DS DFLT ADJ VCHR PRPD NEXMPT' , 1 , 0.0 , 0.0 , null , 
    '1035' , 'US Consumer Default Adjustment Voucher Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPRNX' , 'DS DFLT ADJ VCHR PRPD NEXMPT' , 1 , null, null, null , 
    '1035' , 'US Consumer Default Adjustment Voucher Prepaid Non-Exempt' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPRNXFP' , 'DS DFLT ADJ VCHR PRPD EXT FRD' , 1 , 0.0 , 0.0 , null , 
    '1010' , 'US Consumer Default Adjustment Voucher Prepaid Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DEFPRNXFP' , 'DS DFLT ADJ VCHR PRPD EXT FRD' , 1 , null, null, null , 
    '1010' , 'US Consumer Default Adjustment Voucher Prepaid Non-Exempt Fraud Preven' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DINTLAVP' , 'DS DEFAULT INTL ADJ VOUCHER' , 1 , 0.0 , 0.0 , null , 
    '906' , 'US International Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DINTLAVP' , 'DS DEFAULT INTL ADJ VOUCHER' , 1 , null, null, null , 
    '906' , 'US International Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DINTLBASE' , 'DS DEFAULT INTL BASE SUB' , 1 , 1.7 , 0.1 , null , 
    '993' , 'US International Default Base Submission' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08DINTLBASE' , 'DS DEFAULT INTL BASE SUB' , 1 , null, null, null , 
    '993' , 'US International Default Base Submission' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCC' , 'DS ECOMMERCE CORE' , 2 , 1.87 , 0.1 , null , 
    '168' , 'US Consumer E-Commerce/Internet Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCC' , 'DS ECOMMERCE CORE' , 2 , null, null, null , 
    '168' , 'US Consumer E-Commerce/Internet Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCD' , 'DS ECOMMERCE DEBIT' , 1 , 1.75 , 0.2 , null , 
    '121' , 'US Consumer E-Commerce/Internet Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCD' , 'DS ECOMMERCE DEBIT' , 1 , null, null, null , 
    '121' , 'US Consumer E-Commerce/Internet Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCDNXFP' , 'DS ECOMMERCE DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '364' , 'US Consumer E-Commerce/Internet Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCDNXFP' , 'DS ECOMMERCE DB NEXMPT FRD' , 1 , null, null, null , 
    '364' , 'US Consumer E-Commerce/Internet Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCP' , 'DS ECOMMERCE PREMIUM' , 2 , 2.0 , 0.1 , null , 
    '150' , 'US Consumer E-Commerce/Internet Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCP' , 'DS ECOMMERCE PREMIUM' , 2 , null, null, null , 
    '150' , 'US Consumer E-Commerce/Internet Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCR' , 'DS ECOMMERCE REWARDS' , 2 , 1.97 , 0.1 , null , 
    '120' , 'US Consumer E-Commerce/Internet Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMCR' , 'DS ECOMMERCE REWARDS' , 2 , null, null, null , 
    '120' , 'US Consumer E-Commerce/Internet Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPP' , 'DS ECOMMERCE PREMIUM PLUS' , 3 , 2.35 , 0.1 , null , 
    '221' , 'US Consumer E-Commerce/Internet Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPP' , 'DS ECOMMERCE PREMIUM PLUS' , 3 , null, null, null , 
    '221' , 'US Consumer E-Commerce/Internet Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPR' , 'DS ECOMMERCE PREPAID' , 1 , 1.75 , 0.2 , null , 
    '333' , 'US Consumer E-Commerce/Internet Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPR' , 'DS ECOMMERCE PREPAID' , 1 , null, null, null , 
    '333' , 'US Consumer E-Commerce/Internet Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPRNXFP' , 'DS ECOMMERCE PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '390' , 'US Consumer E-Commerce/Internet Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08ECOMPRNXFP' , 'DS ECOMMERCE PRPD NEXMPT FRD' , 1 , null, null, null , 
    '390' , 'US Consumer E-Commerce/Internet Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECC' , 'DS EMERGING MARKETS CORE' , 1 , 1.45 , 0.05 , null , 
    '160' , 'US Consumer Emerging Markets Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECC' , 'DS EMERGING MARKETS CORE' , 1 , null, null, null , 
    '160' , 'US Consumer Emerging Markets Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECD' , 'DS EMERGING MARKETS DEBIT' , 1 , 0.9 , 0.2 , null , 
    '105' , 'US Consumer Emerging Markets Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECD' , 'DS EMERGING MARKETS DEBIT' , 1 , null, null, null , 
    '105' , 'US Consumer Emerging Markets Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECDNXFP' , 'DS EMERG MRKTS DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '374' , 'US Consumer Emerging Markets Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECDNXFP' , 'DS EMERG MRKTS DB NEXMPT FRD' , 1 , null, null, null , 
    '374' , 'US Consumer Emerging Markets Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECP' , 'DS EMERGING MARKETS PREMIUM' , 1 , 1.45 , 0.05 , null , 
    '142' , 'US Consumer Emerging Markets Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECP' , 'DS EMERGING MARKETS PREMIUM' , 1 , null, null, null , 
    '142' , 'US Consumer Emerging Markets Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECR' , 'DS EMERGING MARKETS REWARDS' , 1 , 1.45 , 0.05 , null , 
    '104' , 'US Consumer Emerging Markets Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMECR' , 'DS EMERGING MARKETS REWARDS' , 1 , null, null, null , 
    '104' , 'US Consumer Emerging Markets Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPP' , 'DS EMERGING MARKETS PRM PLUS' , 3 , 2.3 , 0.1 , null , 
    '213' , 'US Consumer Emerging Markets Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPP' , 'DS EMERGING MARKETS PRM PLUS' , 3 , null, null, null , 
    '213' , 'US Consumer Emerging Markets Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPR' , 'DS EMERGING MARKETS PREPAID' , 1 , 0.9 , 0.2 , null , 
    '343' , 'US Consumer Emerging Markets Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPR' , 'DS EMERGING MARKETS PREPAID' , 1 , null, null, null , 
    '343' , 'US Consumer Emerging Markets Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPRNXFP' , 'DS EMERGING MKT PRPD EXT FRD' , 1 , 0.05 , 0.22 , null , 
    '400' , 'US Consumer Emerging Markets Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EMEPRNXFP' , 'DS EMERGING MKT PRPD EXT FRD' , 1 , null, null, null , 
    '400' , 'US Consumer Emerging Markets Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCC' , 'DS EXPRESS SERVICES CORE' , 2 , 1.95 , 0.0 , null , 
    '162' , 'US Consumer Express Services Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCC' , 'DS EXPRESS SERVICES CORE' , 2 , null, null, null , 
    '162' , 'US Consumer Express Services Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCD' , 'DS EXPRESS SERVICES DEBIT' , 1 , 1.8 , 0.0 , null , 
    '109' , 'US Consumer Express Services Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCD' , 'DS EXPRESS SERVICES DEBIT' , 1 , null, null, null , 
    '109' , 'US Consumer Express Services Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCDNXFP' , 'DS EXPRESS SERV DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '376' , 'US Consumer Express Services Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCDNXFP' , 'DS EXPRESS SERV DB NEXMPT FRD' , 1 , null, null, null , 
    '376' , 'US Consumer Express Services Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCP' , 'DS EXPRESS SERVICES PREMIUM' , 2 , 1.95 , 0.0 , null , 
    '144' , 'US Consumer Express Services Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCP' , 'DS EXPRESS SERVICES PREMIUM' , 2 , null, null, null , 
    '144' , 'US Consumer Express Services Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCR' , 'DS EXPRESS SERVICES REWARDS' , 2 , 1.95 , 0.0 , null , 
    '108' , 'US Consumer Express Services Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPCR' , 'DS EXPRESS SERVICES REWARDS' , 2 , null, null, null , 
    '108' , 'US Consumer Express Services Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPP' , 'DS EXPRESS SERVICES PRM PLUS' , 2 , 2.05 , 0.0 , null , 
    '215' , 'US Consumer Express Services Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPP' , 'DS EXPRESS SERVICES PRM PLUS' , 2 , null, null, null , 
    '215' , 'US Consumer Express Services Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPPR' , 'DS EXPRESS SERVICES PREPAID' , 1 , 1.8 , 0.0 , null , 
    '345' , 'US Consumer Express Services Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPPR' , 'DS EXPRESS SERVICES PREPAID' , 1 , null, null, null , 
    '345' , 'US Consumer Express Services Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPPRNXFP' , 'DS EXPRESS SRVC PRPDNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '402' , 'US Consumer Express Services Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08EXPPPRNXFP' , 'DS EXPRESS SRVC PRPDNEXMPT FRD' , 1 , null, null, null , 
    '402' , 'US Consumer Express Services Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCC' , 'DS HOTEL CAR RENTAL CORE' , 1 , 1.58 , 0.1 , null , 
    '166' , 'US Consumer Hotels or Car Rentals Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCC' , 'DS HOTEL CAR RENTAL CORE' , 1 , null, null, null , 
    '166' , 'US Consumer Hotels or Car Rentals Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCD' , 'DS HOTEL CAR RENTAL DEBIT' , 1 , 1.35 , 0.16 , null , 
    '117' , 'US Consumer Hotels or Car Rentals Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCD' , 'DS HOTEL CAR RENTAL DEBIT' , 1 , null, null, null , 
    '117' , 'US Consumer Hotels or Car Rentals Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCDNXFP' , 'DS HOTEL CAR RENT DBNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '383' , 'US Consumer Hotels or Car Rentals Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCDNXFP' , 'DS HOTEL CAR RENT DBNEXMPT FRD' , 1 , null, null, null , 
    '383' , 'US Consumer Hotels or Car Rentals Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCP' , 'DS HOTEL CAR RENTAL PREMIUM' , 3 , 2.3 , 0.1 , null , 
    '148' , 'US Consumer Hotels or Car Rentals Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCP' , 'DS HOTEL CAR RENTAL PREMIUM' , 3 , null, null, null , 
    '148' , 'US Consumer Hotels or Car Rentals Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCR' , 'DS HOTEL CAR RENTAL REWARDS' , 2 , 1.9 , 0.1 , null , 
    '116' , 'US Consumer Hotels or Car Rentals Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTCR' , 'DS HOTEL CAR RENTAL REWARDS' , 2 , null, null, null , 
    '116' , 'US Consumer Hotels or Car Rentals Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPP' , 'DS HOTEL CAR RENTAL PRM PLUS' , 3 , 2.3 , 0.1 , null , 
    '219' , 'US Consumer Hotels or Car Rentals Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPP' , 'DS HOTEL CAR RENTAL PRM PLUS' , 3 , null, null, null , 
    '219' , 'US Consumer Hotels or Car Rentals Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPR' , 'DS HOTEL CAR RENTAL PREPAID' , 1 , 1.35 , 0.16 , null , 
    '352' , 'US Consumer Hotels or Car Rentals Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPR' , 'DS HOTEL CAR RENTAL PREPAID' , 1 , null, null, null , 
    '352' , 'US Consumer Hotels or Car Rentals Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPRNXFP' , 'DS HTL CAR RENT PRPDNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '409' , 'US Consumer Hotels or Car Rentals Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08HOTPRNXFP' , 'DS HTL CAR RENT PRPDNEXMPT FRD' , 1 , null, null, null , 
    '409' , 'US Consumer Hotels or Car Rentals Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCC' , 'DS INSURANCE CORE' , 1 , 1.43 , 0.05 , null , 
    '179' , 'US Consumer Insurance Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCC' , 'DS INSURANCE CORE' , 1 , null, null, null , 
    '179' , 'US Consumer Insurance Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCD' , 'DS INSURANCE DEBIT' , 1 , 0.8 , 0.25 , null , 
    '182' , 'US Consumer Insurance Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCD' , 'DS INSURANCE DEBIT' , 1 , null, null, null , 
    '182' , 'US Consumer Insurance Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCDNXFP' , 'DS INSURANCE DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '369' , 'US Consumer Insurance Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCDNXFP' , 'DS INSURANCE DB NEXMPT FRD' , 1 , null, null, null , 
    '369' , 'US Consumer Insurance Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCP' , 'DS INSURANCE PREMIUM' , 1 , 1.43 , 0.05 , null , 
    '181' , 'US Consumer Insurance Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCP' , 'DS INSURANCE PREMIUM' , 1 , null, null, null , 
    '181' , 'US Consumer Insurance Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCR' , 'DS INSURANCE REWARDS' , 1 , 1.43 , 0.05 , null , 
    '180' , 'US Consumer Insurance Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUCR' , 'DS INSURANCE REWARDS' , 1 , null, null, null , 
    '180' , 'US Consumer Insurance Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPP' , 'DS INSURANCE PREMIUM PLUS' , 3 , 2.3 , 0.05 , null , 
    '211' , 'US Consumer Insurance Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPP' , 'DS INSURANCE PREMIUM PLUS' , 3 , null, null, null , 
    '211' , 'US Consumer Insurance Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPR' , 'DS INSURANCE PREPAID' , 1 , 0.8 , 0.25 , null , 
    '338' , 'US Consumer Insurance Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPR' , 'DS INSURANCE PREPAID' , 1 , null, null, null , 
    '338' , 'US Consumer Insurance Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPRNXFP' , 'DS INSURANCE PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '395' , 'US Consumer Insurance Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INSUPRNXFP' , 'DS INSURANCE PRPD NEXMPT FRD' , 1 , null, null, null , 
    '395' , 'US Consumer Insurance Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLAVP' , 'DS INTL ADJ VOUCHER' , 1 , 0.0 , 0.0 , null , 
    '802' , 'US International Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLAVP' , 'DS INTL ADJ VOUCHER' , 1 , null, null, null , 
    '802' , 'US International Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLBASE' , 'DS INTL BASE SUB' , 1 , 1.7 , 0.1 , null , 
    '801' , 'US International Base Submission' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLBASE' , 'DS INTL BASE SUB' , 1 , null, null, null , 
    '801' , 'US International Base Submission' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLELEC' , 'DS INTL ELECTRONIC' , 1 , 1.36 , 0.0 , null , 
    '800' , 'US International Electronic' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08INTLELEC' , 'DS INTL ELECTRONIC' , 1 , null, null, null , 
    '800' , 'US International Electronic' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCC' , 'DS KEY ENTRY CORE' , 2 , 1.87 , 0.1 , null , 
    '169' , 'US Consumer Key Entry Core' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCC' , 'DS KEY ENTRY CORE' , 2 , null, null, null , 
    '169' , 'US Consumer Key Entry Core' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCD' , 'DS KEY ENTRY DEBIT' , 1 , 1.75 , 0.2 , null , 
    '123' , 'US Consumer Key Entry Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCD' , 'DS KEY ENTRY DEBIT' , 1 , null, null, null , 
    '123' , 'US Consumer Key Entry Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCDNXFP' , 'DS KEY ENTRY DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '365' , 'US Consumer Key Entry Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCDNXFP' , 'DS KEY ENTRY DB NEXMPT FRD' , 1 , null, null, null , 
    '365' , 'US Consumer Key Entry Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCP' , 'DS KEY ENTRY PREMIUM' , 2 , 2.0 , 0.1 , null , 
    '151' , 'US Consumer Key Entry Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCP' , 'DS KEY ENTRY PREMIUM' , 2 , null, null, null , 
    '151' , 'US Consumer Key Entry Premium' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCR' , 'DS KEY ENTRY REWARDS' , 2 , 1.97 , 0.1 , null , 
    '122' , 'US Consumer Key Entry Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYCR' , 'DS KEY ENTRY REWARDS' , 2 , null, null, null , 
    '122' , 'US Consumer Key Entry Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPP' , 'DS KEY ENTRY PREMIUM PLUS' , 2 , 2.15 , 0.1 , null , 
    '222' , 'US Consumer Key Entry Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPP' , 'DS KEY ENTRY PREMIUM PLUS' , 2 , null, null, null , 
    '222' , 'US Consumer Key Entry Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPR' , 'DS KEY ENTRY PREPAID' , 1 , 1.75 , 0.2 , null , 
    '334' , 'US Consumer Key Entry Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPR' , 'DS KEY ENTRY PREPAID' , 1 , null, null, null , 
    '334' , 'US Consumer Key Entry Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPRNXFP' , 'DS KEY ENTRY PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '391' , 'US Consumer Key Entry Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08KEYPRNXFP' , 'DS KEY ENTRY PRPD NEXMPT FRD' , 1 , null, null, null , 
    '391' , 'US Consumer Key Entry Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCC' , 'DS MID SUB CORE' , 3 , 2.4 , 0.1 , null , 
    '170' , 'US Consumer Mid Submission Level Core' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCC' , 'DS MID SUB CORE' , 3 , null, null, null , 
    '170' , 'US Consumer Mid Submission Level Core' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCD' , 'DS MID SUB DEBIT' , 1 , 1.8 , 0.2 , null , 
    '126' , 'US Consumer Mid Submission Level Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCD' , 'DS MID SUB DEBIT' , 1 , null, null, null , 
    '126' , 'US Consumer Mid Submission Level Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCDNXFP' , 'DS MID SUB DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '385' , 'US Consumer Mid Submission Level Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCDNXFP' , 'DS MID SUB DB NEXMPT FRD' , 1 , null, null, null , 
    '385' , 'US Consumer Mid Submission Level Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCP' , 'DS MID SUB PREMIUM' , 3 , 2.4 , 0.1 , null , 
    '152' , 'US Consumer Mid Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCP' , 'DS MID SUB PREMIUM' , 3 , null, null, null , 
    '152' , 'US Consumer Mid Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCR' , 'DS MID SUB REWARDS' , 3 , 2.4 , 0.1 , null , 
    '125' , 'US Consumer Mid Submission Level Rewards' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDCR' , 'DS MID SUB REWARDS' , 3 , null, null, null , 
    '125' , 'US Consumer Mid Submission Level Rewards' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPP' , 'DS MID SUB PREMIUM PLUS' , 3 , 2.4 , 0.1 , null , 
    '229' , 'US Consumer Mid Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPP' , 'DS MID SUB PREMIUM PLUS' , 3 , null, null, null , 
    '229' , 'US Consumer Mid Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPR' , 'DS MID SUB PREPAID' , 1 , 1.8 , 0.2 , null , 
    '354' , 'US Consumer Mid Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPR' , 'DS MID SUB PREPAID' , 1 , null, null, null , 
    '354' , 'US Consumer Mid Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPRNXFP' , 'DS MID SUB PREPAID NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '411' , 'US Consumer Mid Submission Level Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08MIDPRNXFP' , 'DS MID SUB PREPAID NEXMPT FRD' , 1 , null, null, null , 
    '411' , 'US Consumer Mid Submission Level Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCC' , 'DS PASS TRANSPORT CORE' , 1 , 1.75 , 0.1 , null , 
    '167' , 'US Consumer Passenger Transport Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCC' , 'DS PASS TRANSPORT CORE' , 1 , null, null, null , 
    '167' , 'US Consumer Passenger Transport Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCD' , 'DS PASS TRANSPORT DEBIT' , 1 , 1.59 , 0.16 , null , 
    '119' , 'US Consumer Passenger Transport Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCD' , 'DS PASS TRANSPORT DEBIT' , 1 , null, null, null , 
    '119' , 'US Consumer Passenger Transport Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCDNXFP' , 'DS PASS TRANSPORT DBNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '384' , 'US Consumer Passenger Transport Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCDNXFP' , 'DS PASS TRANSPORT DBNEXMPT FRD' , 1 , null, null, null , 
    '384' , 'US Consumer Passenger Transport Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCP' , 'DS PASS TRANSPORT PREMIUM' , 3 , 2.3 , 0.1 , null , 
    '149' , 'US Consumer Passenger Transport Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCP' , 'DS PASS TRANSPORT PREMIUM' , 3 , null, null, null , 
    '149' , 'US Consumer Passenger Transport Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCR' , 'DS PASS TRANSPORT REWARDS' , 2 , 1.9 , 0.1 , null , 
    '118' , 'US Consumer Passenger Transport Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASCR' , 'DS PASS TRANSPORT REWARDS' , 2 , null, null, null , 
    '118' , 'US Consumer Passenger Transport Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPP' , 'DS PASS TRANSPORT PREMIUM PLUS' , 3 , 2.3 , 0.1 , null , 
    '220' , 'US Consumer Passenger Transport Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPP' , 'DS PASS TRANSPORT PREMIUM PLUS' , 3 , null, null, null , 
    '220' , 'US Consumer Passenger Transport Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPR' , 'DS PASS TRANSPORT PREPAID' , 1 , 1.59 , 0.16 , null , 
    '353' , 'US Consumer Passenger Transport Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPR' , 'DS PASS TRANSPORT PREPAID' , 1 , null, null, null , 
    '353' , 'US Consumer Passenger Transport Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPRNXFP' , 'DS PASS TRANS PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '410' , 'US Consumer Passenger Transport Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PASPRNXFP' , 'DS PASS TRANS PRPD NEXMPT FRD' , 1 , null, null, null , 
    '410' , 'US Consumer Passenger Transport Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCC' , 'DS PETROLEUM CORE' , 1 , 1.55 , 0.05 , null , 
    '163' , 'US Consumer Petroleum Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCC' , 'DS PETROLEUM CORE' , 1 , null, null, null , 
    '163' , 'US Consumer Petroleum Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCD' , 'DS PETROLEUM DEBIT' , 1 , 0.76 , 0.16 , null , 
    '111' , 'US Consumer Petroleum Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCD' , 'DS PETROLEUM DEBIT' , 1 , null, null, null , 
    '111' , 'US Consumer Petroleum Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCDNXFP' , 'DS PETROLEUM DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '377' , 'US Consumer Petroleum Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCDNXFP' , 'DS PETROLEUM DB NEXMPT FRD' , 1 , null, null, null , 
    '377' , 'US Consumer Petroleum Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCP' , 'DS PETROLEUM PREMIUM' , 1 , 1.73 , 0.05 , null , 
    '145' , 'US Consumer Petroleum Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCP' , 'DS PETROLEUM PREMIUM' , 1 , null, null, null , 
    '145' , 'US Consumer Petroleum Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCR' , 'DS PETROLEUM REWARDS' , 1 , 1.73 , 0.05 , null , 
    '110' , 'US Consumer Petroleum Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETCR' , 'DS PETROLEUM REWARDS' , 1 , null, null, null , 
    '110' , 'US Consumer Petroleum Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPP' , 'DS PETROLEUM PREMIUM PLUS' , 1 , 1.73 , 0.05 , null , 
    '216' , 'US Consumer Petroleum Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPP' , 'DS PETROLEUM PREMIUM PLUS' , 1 , null, null, null , 
    '216' , 'US Consumer Petroleum Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPR' , 'DS PETROLEUM PREPAID' , 1 , 0.76 , 0.16 , null , 
    '346' , 'US Consumer Petroleum Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPR' , 'DS PETROLEUM PREPAID' , 1 , null, null, null , 
    '346' , 'US Consumer Petroleum Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPRNXFP' , 'DS PETROLEUM PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '403' , 'US Consumer Petroleum Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PETPRNXFP' , 'DS PETROLEUM PRPD NEXMPT FRD' , 1 , null, null, null , 
    '403' , 'US Consumer Petroleum Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCC' , 'DS PUBLIC SERVICE CORE' , 1 , 1.55 , 0.1 , null , 
    '161' , 'US Consumer Public Services Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCC' , 'DS PUBLIC SERVICE CORE' , 1 , null, null, null , 
    '161' , 'US Consumer Public Services Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCD' , 'DS PUBLIC SERVICE DEBIT' , 1 , 0.9 , 0.2 , null , 
    '107' , 'US Consumer Public Services Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCD' , 'DS PUBLIC SERVICE DEBIT' , 1 , null, null, null , 
    '107' , 'US Consumer Public Services Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCDNXFP' , 'DS PUBLIC SERVICE DBNEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '375' , 'US Consumer Public Services Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCDNXFP' , 'DS PUBLIC SERVICE DBNEXMPT FRD' , 1 , null, null, null , 
    '375' , 'US Consumer Public Services Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCP' , 'DS PUBLIC SERVICE PREMIUM' , 1 , 1.55 , 0.1 , null , 
    '143' , 'US Consumer Public Services Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCP' , 'DS PUBLIC SERVICE PREMIUM' , 1 , null, null, null , 
    '143' , 'US Consumer Public Services Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCR' , 'DS PUBLIC SERVICE REWARDS' , 1 , 1.55 , 0.1 , null , 
    '106' , 'US Consumer Public Services Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBCR' , 'DS PUBLIC SERVICE REWARDS' , 1 , null, null, null , 
    '106' , 'US Consumer Public Services Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPP' , 'DS PUBLIC SERVICE PREMIUM PLUS' , 1 , 1.55 , 0.1 , null , 
    '214' , 'US Consumer Public Services Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPP' , 'DS PUBLIC SERVICE PREMIUM PLUS' , 1 , null, null, null , 
    '214' , 'US Consumer Public Services Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPR' , 'DS PUBLIC SERVICE PREPAID' , 1 , 0.9 , 0.2 , null , 
    '344' , 'US Consumer Public Services Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPR' , 'DS PUBLIC SERVICE PREPAID' , 1 , null, null, null , 
    '344' , 'US Consumer Public Services Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPRNXFP' , 'DS PUBLIC SRVC PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '401' , 'US Consumer Public Services Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08PUBPRNXFP' , 'DS PUBLIC SRVC PRPD NEXMPT FRD' , 1 , null, null, null , 
    '401' , 'US Consumer Public Services Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCC' , 'DS RECUR PAYMENT CORE' , 1 , 1.2 , 0.05 , null , 
    '157' , 'US Consumer Recurring Payment Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCC' , 'DS RECUR PAYMENT CORE' , 1 , null, null, null , 
    '157' , 'US Consumer Recurring Payment Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCD' , 'DS RECUR PAYMENT DEBIT' , 1 , 1.2 , 0.05 , null , 
    '101' , 'US Consumer Recurring Payment Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCD' , 'DS RECUR PAYMENT DEBIT' , 1 , null, null, null , 
    '101' , 'US Consumer Recurring Payment Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCDNXFP' , 'DS RECUR PAYMENT DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '366' , 'US Consumer Recurring Payment Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCDNXFP' , 'DS RECUR PAYMENT DB NEXMPT FRD' , 1 , null, null, null , 
    '366' , 'US Consumer Recurring Payment Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCP' , 'DS RECUR PAYMENT PREMIUM' , 1 , 1.2 , 0.05 , null , 
    '139' , 'US Consumer Recurring Payment Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCP' , 'DS RECUR PAYMENT PREMIUM' , 1 , null, null, null , 
    '139' , 'US Consumer Recurring Payment Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCR' , 'DS RECUR PAYMENT REWARDS' , 1 , 1.2 , 0.05 , null , 
    '100' , 'US Consumer Recurring Payment Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECCR' , 'DS RECUR PAYMENT REWARDS' , 1 , null, null, null , 
    '100' , 'US Consumer Recurring Payment Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPP' , 'DS RECUR PAYMENT PREMIUM PLUS' , 2 , 1.8 , 0.05 , null , 
    '208' , 'US Consumer Recurring Payment Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPP' , 'DS RECUR PAYMENT PREMIUM PLUS' , 2 , null, null, null , 
    '208' , 'US Consumer Recurring Payment Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPR' , 'DS RECUR PAYMENT PREPAID' , 1 , 1.2 , 0.05 , null , 
    '335' , 'US Consumer Recurring Payment Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPR' , 'DS RECUR PAYMENT PREPAID' , 1 , null, null, null , 
    '335' , 'US Consumer Recurring Payment Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPRNXFP' , 'DS RECUR PYMNT PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '392' , 'US Consumer Recurring Payment Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RECPRNXFP' , 'DS RECUR PYMNT PRPD NEXMPT FRD' , 1 , null, null, null , 
    '392' , 'US Consumer Recurring Payment Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCC' , 'DS RESTAURANT CORE' , 1 , 1.56 , 0.1 , null , 
    '165' , 'US Consumer Restaurants Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCC' , 'DS RESTAURANT CORE' , 1 , null, null, null , 
    '165' , 'US Consumer Restaurants Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCD' , 'DS RESTAURANT DEBIT' , 1 , 1.1 , 0.16 , null , 
    '115' , 'US Consumer Restaurants Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCD' , 'DS RESTAURANT DEBIT' , 1 , null, null, null , 
    '115' , 'US Consumer Restaurants Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCDNXFP' , 'DS RESTAURANT DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '382' , 'US Consumer Restaurants Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCDNXFP' , 'DS RESTAURANT DB NEXMPT FRD' , 1 , null, null, null , 
    '382' , 'US Consumer Restaurants Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCP' , 'DS RESTAURANT PREMIUM' , 3 , 2.2 , 0.1 , null , 
    '147' , 'US Consumer Restaurants Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCP' , 'DS RESTAURANT PREMIUM' , 3 , null, null, null , 
    '147' , 'US Consumer Restaurants Premium' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCR' , 'DS RESTAURANT REWARDS' , 2 , 1.9 , 0.1 , null , 
    '114' , 'US Consumer Restaurants Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESCR' , 'DS RESTAURANT REWARDS' , 2 , null, null, null , 
    '114' , 'US Consumer Restaurants Rewards' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPP' , 'DS RESTAURANT PREMIUM PLUS' , 3 , 2.3 , 0.1 , null , 
    '218' , 'US Consumer Restaurants Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPP' , 'DS RESTAURANT PREMIUM PLUS' , 3 , null, null, null , 
    '218' , 'US Consumer Restaurants Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPR' , 'DS RESTAURANT PREPAID' , 1 , 1.1 , 0.16 , null , 
    '351' , 'US Consumer Restaurants Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPR' , 'DS RESTAURANT PREPAID' , 1 , null, null, null , 
    '351' , 'US Consumer Restaurants Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPRNXFP' , 'DS RESTAURANT PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '408' , 'US Consumer Restaurants Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RESPRNXFP' , 'DS RESTAURANT PRPD NEXMPT FRD' , 1 , null, null, null , 
    '408' , 'US Consumer Restaurants Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCC' , 'DS RETAIL CORE' , 1 , 1.56 , 0.1 , null , 
    '164' , 'US Consumer Retail Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCC' , 'DS RETAIL CORE' , 1 , null, null, null , 
    '164' , 'US Consumer Retail Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCD' , 'DS RETAIL DEBIT' , 1 , 1.1 , 0.16 , null , 
    '113' , 'US Consumer Retail Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCD' , 'DS RETAIL DEBIT' , 1 , null, null, null , 
    '113' , 'US Consumer Retail Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCDNXFP' , 'DS RETAIL DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '381' , 'US Consumer Retail Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCDNXFP' , 'DS RETAIL DB NEXMPT FRD' , 1 , null, null, null , 
    '381' , 'US Consumer Retail Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCP' , 'DS RETAIL PREMIUM' , 1 , 1.71 , 0.1 , null , 
    '146' , 'US Consumer Retail Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCP' , 'DS RETAIL PREMIUM' , 1 , null, null, null , 
    '146' , 'US Consumer Retail Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCR' , 'DS RETAIL REWARDS' , 1 , 1.71 , 0.1 , null , 
    '112' , 'US Consumer Retail Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETCR' , 'DS RETAIL REWARDS' , 1 , null, null, null , 
    '112' , 'US Consumer Retail Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPP' , 'DS RETAIL PREMIUM PLUS' , 2 , 2.1 , 0.1 , null , 
    '217' , 'US Consumer Retail Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPP' , 'DS RETAIL PREMIUM PLUS' , 2 , null, null, null , 
    '217' , 'US Consumer Retail Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPR' , 'DS RETAIL PREPAID' , 1 , 1.1 , 0.16 , null , 
    '350' , 'US Consumer Retail Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPR' , 'DS RETAIL PREPAID' , 1 , null, null, null , 
    '350' , 'US Consumer Retail Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPRNXFP' , 'DS RETAIL PREPAID NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '407' , 'US Consumer Retail Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RETPRNXFP' , 'DS RETAIL PREPAID NEXMPT FRD' , 1 , null, null, null , 
    '407' , 'US Consumer Retail Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCC' , 'DS REAL ESTATE CORE' , 1 , 1.1 , 0.0 , null , 
    '175' , 'US Consumer Real Estate Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCC' , 'DS REAL ESTATE CORE' , 1 , null, null, null , 
    '175' , 'US Consumer Real Estate Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCD' , 'DS REAL ESTATE DEBIT' , 1 , 1.1 , 0.0 , null , 
    '178' , 'US Consumer Real Estate Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCD' , 'DS REAL ESTATE DEBIT' , 1 , null, null, null , 
    '178' , 'US Consumer Real Estate Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCDNXFP' , 'DS REAL ESTATE DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '368' , 'US Consumer Real Estate Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCDNXFP' , 'DS REAL ESTATE DB NEXMPT FRD' , 1 , null, null, null , 
    '368' , 'US Consumer Real Estate Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCP' , 'DS REAL ESTATE PREMIUM' , 1 , 1.1 , 0.0 , null , 
    '177' , 'US Consumer Real Estate Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCP' , 'DS REAL ESTATE PREMIUM' , 1 , null, null, null , 
    '177' , 'US Consumer Real Estate Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCR' , 'DS REAL ESTATE REWARDS' , 1 , 1.1 , 0.0 , null , 
    '176' , 'US Consumer Real Estate Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTCR' , 'DS REAL ESTATE REWARDS' , 1 , null, null, null , 
    '176' , 'US Consumer Real Estate Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPP' , 'DS REAL ESTATE PREMIUM PLUS' , 3 , 2.3 , 0.1 , null , 
    '210' , 'US Consumer Real Estate Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPP' , 'DS REAL ESTATE PREMIUM PLUS' , 3 , null, null, null , 
    '210' , 'US Consumer Real Estate Premium Plus' , '08' , 'DISC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPR' , 'DS REAL ESTATE PREPAID' , 1 , 1.1 , 0.0 , null , 
    '337' , 'US Consumer Real Estate Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPR' , 'DS REAL ESTATE PREPAID' , 1 , null, null, null , 
    '337' , 'US Consumer Real Estate Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPRNXFP' , 'DS REAL ESTATE PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '394' , 'US Consumer Real Estate Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08RSTPRNXFP' , 'DS REAL ESTATE PRPD NEXMPT FRD' , 1 , null, null, null , 
    '394' , 'US Consumer Real Estate Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCC' , 'DS SUPERMARKET WH CORE' , 1 , 1.4 , 0.05 , null , 
    '159' , 'US Consumer Supermarkets/Warehouse Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCC' , 'DS SUPERMARKET WH CORE' , 1 , null, null, null , 
    '159' , 'US Consumer Supermarkets/Warehouse Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCD' , 'DS SUPERMARKET WH DEBIT' , 1 , 1.1 , 0.16 ,  0.36 , 
    '103' , 'US Consumer Supermarkets/Warehouse Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCD' , 'DS SUPERMARKET WH DEBIT' , 1 , null, null, null , 
    '103' , 'US Consumer Supermarkets/Warehouse Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCDNXFP' , 'DS SUPERMARKET WH DB EXT FRD' , 1 , 0.05 , 0.22 ,  0.36 , 
    '373' , 'US Consumer Supermarkets/Warehouse Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCDNXFP' , 'DS SUPERMARKET WH DB EXT FRD' , 1 , null, null, null , 
    '373' , 'US Consumer Supermarkets/Warehouse Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCP' , 'DS SUPERMARKET WH PREMIUM' , 1 , 1.65 , 0.05 , null , 
    '141' , 'US Consumer Supermarkets/Warehouse Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCP' , 'DS SUPERMARKET WH PREMIUM' , 1 , null, null, null , 
    '141' , 'US Consumer Supermarkets/Warehouse Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCR' , 'DS SUPERMARKET WH REWARDS' , 1 , 1.65 , 0.05 , null , 
    '102' , 'US Consumer Supermarkets/Warehouse Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPCR' , 'DS SUPERMARKET WH REWARDS' , 1 , null, null, null , 
    '102' , 'US Consumer Supermarkets/Warehouse Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPP' , 'DS SUPERMARKET WH PREM PLUS' , 2 , 1.9 , 0.1 , null , 
    '212' , 'US Consumer Supermarkets/Warehouse Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPP' , 'DS SUPERMARKET WH PREM PLUS' , 2 , null, null, null , 
    '212' , 'US Consumer Supermarkets/Warehouse Premium Plus' , '08' , 'DISC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPR' , 'DS SUPERMARKET WH PREPAID' , 1 , 1.1 , 0.16 ,  0.36 , 
    '342' , 'US Consumer Supermarkets/Warehouse Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPR' , 'DS SUPERMARKET WH PREPAID' , 1 , null, null, null , 
    '342' , 'US Consumer Supermarkets/Warehouse Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPRNXFP' , 'DS SUPERMKT WH PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '399' , 'US Consumer Supermarkets/Warehouse Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08SUPPRNXFP' , 'DS SUPERMKT WH PRPD NEXMPT FRD' , 1 , null, null, null , 
    '399' , 'US Consumer Supermarkets/Warehouse Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08USINTLCASHREIMB' , 'DS US INTL CASH REIMBURSEMENT' , 1 , 0.16 , 3.0 , null , 
    '000' , 'US International Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08USINTLCASHREIMB' , 'DS US INTL CASH REIMBURSEMENT' , 1 , null, null, null , 
    '000' , 'US International Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICC' , 'US UTILITIES CORE' , 1 , 0.0 , 0.75 , null , 
    '158' , 'US Consumer Utilities Core' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICC' , 'US UTILITIES CORE' , 1 , null, null, null , 
    '158' , 'US Consumer Utilities Core' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICD' , 'US UTILITIES DEBIT' , 1 , 0.0 , 0.75 , null , 
    '138' , 'US Consumer Utilities Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICD' , 'US UTILITIES DEBIT' , 1 , null, null, null , 
    '138' , 'US Consumer Utilities Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICDNXFP' , 'DS UTILITIES DB NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '367' , 'US Consumer Utilities Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICDNXFP' , 'DS UTILITIES DB NEXMPT FRD' , 1 , null, null, null , 
    '367' , 'US Consumer Utilities Debit Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICP' , 'US UTILITIES PREMIUM' , 1 , 0.0 , 0.75 , null , 
    '140' , 'US Consumer Utilities Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICP' , 'US UTILITIES PREMIUM' , 1 , null, null, null , 
    '140' , 'US Consumer Utilities Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICR' , 'US UTILITIES REWARD' , 1 , 0.0 , 0.75 , null , 
    '137' , 'US Consumer Utilities Reward' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTICR' , 'US UTILITIES REWARD' , 1 , null, null, null , 
    '137' , 'US Consumer Utilities Reward' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPP' , 'DS UTILITIES PREMIUM PLUS' , 1 , 0.0 , 0.75 , null , 
    '209' , 'US Consumer Utilities Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPP' , 'DS UTILITIES PREMIUM PLUS' , 1 , null, null, null , 
    '209' , 'US Consumer Utilities Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPR' , 'DS UTILITIES PREPAID' , 1 , 0.0 , 0.75 , null , 
    '336' , 'US Consumer Utilities Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPR' , 'DS UTILITIES PREPAID' , 1 , null, null, null , 
    '336' , 'US Consumer Utilities Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPRNXFP' , 'DS UTILITIES PRPD NEXMPT FRD' , 1 , 0.05 , 0.22 , null , 
    '393' , 'US Consumer Utilities Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '08UTIPRNXFP' , 'DS UTILITIES PRPD NEXMPT FRD' , 1 , null, null, null , 
    '393' , 'US Consumer Utilities Prepaid Non-Exempt Fraud Prevention' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );

rem Visa


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKBUS' , 'INTERLINK BUS' , 2 , 1.7 , 0.1 , null , 
    '287' , 'Interlink Business Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKBUS' , 'INTERLINK BUS' , 2 , null, null, null , 
    '287' , 'Interlink Business Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKCOMMPP' , 'INTERLINK COMM PP' , 3 , 2.15 , 0.1 , null , 
    '362' , 'Interlink Commercial Prepaid Card' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKCOMMPP' , 'INTERLINK COMM PP' , 3 , null, null, null , 
    '362' , 'Interlink Commercial Prepaid Card' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKFUEL' , 'INTERLINK FUEL' , 1 , 0.8 , 0.15 ,  0.95 , 
    '122' , 'Interlink Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKFUEL' , 'INTERLINK FUEL' , 1 , null, null, null , 
    '122' , 'Interlink Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKFUELPP' , 'INTRLNK FUEL PP' , 1 , 1.15 , 0.15 ,  0.95 , 
    '343' , 'Interlink Fuel Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKFUELPP' , 'INTRLNK FUEL PP' , 1 , null, null, null , 
    '343' , 'Interlink Fuel Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKIRREG' , 'IR REG INTLK' , 1 , 0.05 , 0.22 , null , 
    '604' , 'Interregional Regulated Interlink' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKIRREG' , 'IR REG INTLK' , 1 , null, null, null , 
    '604' , 'Interregional Regulated Interlink' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKMERRET' , 'INTLNK MER RETRN' , 1 , 0.0 , 0.0 , null , 
    '368' , 'Interlink Merchandise Return' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKMERRET' , 'INTLNK MER RETRN' , 1 , null, null, null , 
    '368' , 'Interlink Merchandise Return' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKREG' , 'US INTERLINK REG' , 1 , 0.05 , 0.22 , null , 
    '342' , 'Interlink Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKREG' , 'US INTERLINK REG' , 1 , null, null, null , 
    '342' , 'Interlink Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSPMKTPP' , 'INTRLNK SPMKT PP' , 1 , 1.15 , 0.15 ,  0.35 , 
    '345' , 'Interlink Supermarket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSPMKTPP' , 'INTRLNK SPMKT PP' , 1 , null, null, null , 
    '345' , 'Interlink Supermarket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSTD' , 'INTERLINK STANDARD' , 1 , 0.8 , 0.15 , null , 
    '121' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSTD' , 'INTERLINK STANDARD' , 1 , null, null, null , 
    '121' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSTDPP' , 'INTERLINK STD PP' , 1 , 1.15 , 0.15 , null , 
    '346' , 'Interlink Standard Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSTDPP' , 'INTERLINK STD PP' , 1 , null, null, null , 
    '346' , 'Interlink Standard Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSUP' , 'INTERLINK SUPERMARKET' , 1 , 0.0 , 0.3 , null , 
    '120' , 'Interlink Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKSUP' , 'INTERLINK SUPERMARKET' , 1 , null, null, null , 
    '120' , 'Interlink Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKTRVL' , 'ILK TVL SVC' , 1 , 1.19 , 0.1 , null , 
    '289' , 'Interlink Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKTRVL' , 'ILK TVL SVC' , 1 , null, null, null , 
    '289' , 'Interlink Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKTRVLPP' , 'ILK TVL SVC PP' , 1 , 1.15 , 0.15 , null , 
    '288' , 'Interlink Consumer Prepaid Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102INTLNKTRVLPP' , 'ILK TVL SVC PP' , 1 , null, null, null , 
    '288' , 'Interlink Consumer Prepaid Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PACOMMPP' , 'PIN AUTH COMM PP' , 3 , 2.15 , 0.1 , null , 
    '366' , 'PIN-Authenticated Commercial Prepaid - Non-Regulated' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PACOMMPP' , 'PIN AUTH COMM PP' , 3 , null, null, null , 
    '366' , 'PIN-Authenticated Commercial Prepaid - Non-Regulated' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBBUS' , 'PIN AUTH DB BUS' , 2 , 1.7 , 0.1 , null , 
    '275' , 'PIN-authenticated - Visa Business Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBBUS' , 'PIN AUTH DB BUS' , 2 , null, null, null , 
    '275' , 'PIN-authenticated - Visa Business Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBCV' , 'PIN AUTH DB CV' , 1 , 0.0 , 0.0 , null , 
    '274' , 'Credit Voucher - PIN-Authenticated Visa Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBCV' , 'PIN AUTH DB CV' , 1 , null, null, null , 
    '274' , 'Credit Voucher - PIN-Authenticated Visa Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBFUEL' , 'PIN AUTH DB FUEL' , 1 , 0.8 , 0.15 ,  0.95 , 
    '277' , 'PIN-authenticated - Consumer Debit, Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBFUEL' , 'PIN AUTH DB FUEL' , 1 , null, null, null , 
    '277' , 'PIN-authenticated - Consumer Debit, Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBREG' , 'PIN AUTH DB REG' , 1 , 0.05 , 0.22 , null , 
    '273' , 'PIN-Authenticated Visa Debit - Regulated w/Fraud' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBREG' , 'PIN AUTH DB REG' , 1 , null, null, null , 
    '273' , 'PIN-Authenticated Visa Debit - Regulated w/Fraud' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBRTL' , 'PIN AUTH DB RTL' , 1 , 0.8 , 0.15 , null , 
    '279' , 'PIN-authenticated - Consumer Debit, Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBRTL' , 'PIN AUTH DB RTL' , 1 , null, null, null , 
    '279' , 'PIN-authenticated - Consumer Debit, Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBSMKT' , 'PIN AUTH DB SMKT' , 1 , 0.0 , 0.3 , null , 
    '278' , 'PIN-authenticated - Consumer Debit, Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBSMKT' , 'PIN AUTH DB SMKT' , 1 , null, null, null , 
    '278' , 'PIN-authenticated - Consumer Debit, Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBSTKT' , 'PIN AUTHDB STKT' , 2 , 1.55 , 0.04 , null , 
    '280' , 'PIN-authenticated - Consumer Debit, Small Ticket' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBSTKT' , 'PIN AUTHDB STKT' , 2 , null, null, null , 
    '280' , 'PIN-authenticated - Consumer Debit, Small Ticket' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBTRVL' , 'PIN AUTH DB TRVL' , 1 , 1.19 , 0.1 , null , 
    '276' , 'PIN-authenticated - Consumer Debit, Travel Services' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PADBTRVL' , 'PIN AUTH DB TRVL' , 1 , null, null, null , 
    '276' , 'PIN-authenticated - Consumer Debit, Travel Services' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPFUEL' , 'PIN AUTH PP FUEL' , 1 , 1.15 , 0.15 ,  0.95 , 
    '282' , 'PIN-authenticated - Consumer Prepaid, Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPFUEL' , 'PIN AUTH PP FUEL' , 1 , null, null, null , 
    '282' , 'PIN-authenticated - Consumer Prepaid, Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPRTL' , 'PIN AUTH PP RTL' , 1 , 1.15 , 0.15 , null , 
    '284' , 'PIN-authenticated - Consumer Prepaid, Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPRTL' , 'PIN AUTH PP RTL' , 1 , null, null, null , 
    '284' , 'PIN-authenticated - Consumer Prepaid, Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPSMKT' , 'PIN AUTH PP SMKT' , 1 , 1.15 , 0.15 ,  0.35 , 
    '283' , 'PIN-authenticated - Consumer Prepaid, Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPSMKT' , 'PIN AUTH PP SMKT' , 1 , null, null, null , 
    '283' , 'PIN-authenticated - Consumer Prepaid, Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPSTKT' , 'PIN AUTH PP STKT' , 2 , 1.6 , 0.05 , null , 
    '285' , 'PIN-authenticated - Consumer Prepaid, Small Ticket' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPSTKT' , 'PIN AUTH PP STKT' , 2 , null, null, null , 
    '285' , 'PIN-authenticated - Consumer Prepaid, Small Ticket' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPTRVL' , 'PINAUTH PP TRVL' , 1 , 1.15 , 0.15 , null , 
    '281' , 'PIN-authenticated - Consumer Prepaid, Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PAPPTRVL' , 'PINAUTH PP TRVL' , 1 , null, null, null , 
    '281' , 'PIN-authenticated - Consumer Prepaid, Travel Service' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PPALOAD' , 'PREPAID ATM LOAD' , 1 , 0.0 , 0.05 , null , 
    '247' , 'Prepaid ATM Load' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PPALOAD' , 'PREPAID ATM LOAD' , 1 , null, null, null , 
    '247' , 'Prepaid ATM Load' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PPRLOAD' , 'VS Prepaid Reload' , 1 , 0.0 , 0.05 , null , 
    '223' , 'Prepaid Reload' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102PPRLOAD' , 'VS Prepaid Reload' , 1 , null, null, null , 
    '223' , 'Prepaid Reload' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102VMTFF' , 'VMT FAST FUNDS' , 1 , 0.0 , 0.1 , null , 
    '255' , 'Visa Money Transfer Fast Funds' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0102VMTFF' , 'VMT FAST FUNDS' , 1 , null, null, null , 
    '255' , 'Visa Money Transfer Fast Funds' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCFLPIN' , 'AIR CHIP FULL PIN' , 1 , 1.1 , 0.0 , null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCFLPIN' , 'AIR CHIP FULL PIN' , 1 , null, null, null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCFULL' , 'AIR CHIP FULL' , 1 , 1.1 , 0.0 , null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCFULL' , 'AIR CHIP FULL' , 1 , null, null, null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCT' , 'VS AIR CHIP TERMNL' , 1 , 1.0 , 0.0 , null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104AIRCT' , 'VS AIR CHIP TERMNL' , 1 , null, null, null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASBUSEIRF' , 'VS US BUS ELEC' , 3 , 2.4 , 0.1 , null , 
    '112' , 'Business Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASBUSEIRF' , 'VS US BUS ELEC' , 3 , null, null, null , 
    '112' , 'Business Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASBUSSTD' , 'VS US BUS STD' , 3 , 2.95 , 0.2 , null , 
    '109' , 'Business Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASBUSSTD' , 'VS US BUS STD' , 3 , null, null, null , 
    '109' , 'Business Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPAQ' , 'VS CHIP TERMNL' , 1 , 1.0 , 0.0 , null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPAQ' , 'VS CHIP TERMNL' , 1 , null, null, null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPIS' , 'VS CHIP ISS' , 1 , 1.2 , 0.0 , null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPIS' , 'VS CHIP ISS' , 1 , null, null, null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPOFF' , 'VS SET MRCH' , 1 , 1.44 , 0.0 , null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPOFF' , 'VS SET MRCH' , 1 , null, null, null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPON' , 'VS SET MRCH SEC' , 1 , 1.44 , 0.0 , null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCHPON' , 'VS SET MRCH SEC' , 1 , null, null, null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCONSTD' , 'VS STANDARD' , 1 , 1.6 , 0.0 , null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCONSTD' , 'VS STANDARD' , 1 , null, null, null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCOREIRF' , 'VS US CORP ELEC' , 3 , 2.95 , 0.1 , null , 
    '113' , 'Corporate Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCOREIRF' , 'VS US CORP ELEC' , 3 , null, null, null , 
    '113' , 'Corporate Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCORPSTD' , 'VS US CORP STD' , 3 , 2.95 , 0.1 , null , 
    '110' , 'Corporate Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASCORPSTD' , 'VS US CORP STD' , 3 , null, null, null , 
    '110' , 'Corporate Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASEIRF' , 'VS INTL PRE PS2000' , 1 , 1.1 , 0.0 , null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASEIRF' , 'VS INTL PRE PS2000' , 1 , null, null, null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASPUREIRF' , 'VS US PURCH ELEC' , 3 , 2.95 , 0.1 , null , 
    '114' , 'Purchasing Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASPUREIRF' , 'VS US PURCH ELEC' , 3 , null, null, null , 
    '114' , 'Purchasing Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASPURSTD' , 'VS US PURCH STD' , 3 , 2.95 , 0.1 , null , 
    '111' , 'Purchasing Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASPURSTD' , 'VS US PURCH STD' , 3 , null, null, null , 
    '111' , 'Purchasing Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASRECURPMT' , 'Rec Payment' , 1 , 1.43 , 0.05 , null , 
    '160' , 'CPS/Recurring Bill Payment' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASRECURPMT' , 'Rec Payment' , 1 , null, null, null , 
    '160' , 'CPS/Recurring Bill Payment' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASSMALLTK' , 'VS SMALL TCKT CR' , 1 , 1.65 , 0.04 , null , 
    '179' , 'CPS/Small-Ticket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASSMALLTK' , 'VS SMALL TCKT CR' , 1 , null, null, null , 
    '179' , 'CPS/Small-Ticket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASSMALLTKCOM' , 'Small Ticket Com' , 1 , 1.55 , 0.04 , null , 
    '214' , 'CPS/Small-Ticket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ASSMALLTKCOM' , 'Small Ticket Com' , 1 , null, null, null , 
    '214' , 'CPS/Small-Ticket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CAF' , 'VS CPS ACCT FUNDING' , 3 , 2.14 , 0.1 , null , 
    '159' , 'CPS/Account Funding Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CAF' , 'VS CPS ACCT FUNDING' , 3 , null, null, null , 
    '159' , 'CPS/Account Funding Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CCNP' , 'VS CPS CAR CNP' , 1 , 1.54 , 0.1 , null , 
    '115' , 'CPS/Car Rental Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CCNP' , 'VS CPS CAR CNP' , 1 , null, null, null , 
    '115' , 'CPS/Car Rental Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CCP' , 'VS CPS CAR CP' , 1 , 1.54 , 0.1 , null , 
    '132' , 'CPS/Car Rental Card Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CCP' , 'VS CPS CAR CP' , 1 , null, null, null , 
    '132' , 'CPS/Car Rental Card Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CECB' , 'VS CPS ECOMM BASIC' , 2 , 1.8 , 0.1 , null , 
    '158' , 'CPS/E-Commerce-Basic Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CECB' , 'VS CPS ECOMM BASIC' , 2 , null, null, null , 
    '158' , 'CPS/E-Commerce-Basic Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CECP' , 'VS CPS ECOMM PREF' , 2 , 1.8 , 0.1 , null , 
    '162' , 'CPS/E-Commerce-Preferred Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CECP' , 'VS CPS ECOMM PREF' , 2 , null, null, null , 
    '162' , 'CPS/E-Commerce-Preferred Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CFLPIN' , 'CHIP FULL PIN' , 1 , 1.1 , 0.0 , null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CFLPIN' , 'CHIP FULL PIN' , 1 , null, null, null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CFULL' , 'CHIP FULL' , 1 , 1.1 , 0.0 , null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CFULL' , 'CHIP FULL' , 1 , null, null, null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CHFT' , 'VS CH FUNDS TRANSFER' , 1 , 0.0 , 0.49 , null , 
    '926' , 'Original Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CHFT' , 'VS CH FUNDS TRANSFER' , 1 , null, null, null , 
    '926' , 'Original Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSACCTFDB' , 'VS CPS ACCT FUND DB' , 1 , 1.75 , 0.2 , null , 
    '185' , 'CPS/Account Funding Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSACCTFDB' , 'VS CPS ACCT FUND DB' , 1 , null, null, null , 
    '185' , 'CPS/Account Funding Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDCRCAP' , 'VS CPS AFD CR CAP' , 1 , 1.15 , 0.25 ,  1.1 , 
    '134' , 'CPS/Automated Fuel Dispenser Credit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDCRCAP' , 'VS CPS AFD CR CAP' , 1 , null, null, null , 
    '134' , 'CPS/Automated Fuel Dispenser Credit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDDB' , 'VS CPS AFD DB' , 1 , 0.8 , 0.15 ,  0.95 , 
    '184' , 'CPS/Automated Fuel Dispenser Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDDB' , 'VS CPS AFD DB' , 1 , null, null, null , 
    '184' , 'CPS/Automated Fuel Dispenser Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDDBCAP' , 'VS CPS AFD DB CAP' , 1 , 0.8 , 0.15 ,  0.95 , 
    '184' , 'US Automated Fuel Dispenser Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSAFDDBCAP' , 'VS CPS AFD DB CAP' , 1 , null, null, null , 
    '184' , 'US Automated Fuel Dispenser Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCACNPDB' , 'VS CPS CAR CNP DB' , 1 , 1.7 , 0.15 , null , 
    '189' , 'CPS/Car Rental Card Not present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCACNPDB' , 'VS CPS CAR CNP DB' , 1 , null, null, null , 
    '189' , 'CPS/Car Rental Card Not present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCACPDB' , 'VS CPS CAR CP DB' , 1 , 1.19 , 0.1 , null , 
    '188' , 'CPS/Car Rental Card Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCACPDB' , 'VS CPS CAR CP DB' , 1 , null, null, null , 
    '188' , 'CPS/Car Rental Card Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCAECPDB' , 'VS CPS CAR ECP DB' , 1 , 1.7 , 0.15 , null , 
    '190' , 'CPS/E-Commerce Preferred - Car Rental Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCAECPDB' , 'VS CPS CAR ECP DB' , 1 , null, null, null , 
    '190' , 'CPS/E-Commerce Preferred - Car Rental Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCHR' , 'VS US CPS CHR' , 1 , 1.35 , 0.05 , null , 
    '379' , 'CPS/Charity' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCHR' , 'VS US CPS CHR' , 1 , null, null, null , 
    '379' , 'CPS/Charity' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCNPDB' , 'VS CPS CNP DB' , 1 , 1.65 , 0.15 , null , 
    '183' , 'CPS/Card Not Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSCNPDB' , 'VS CPS CNP DB' , 1 , null, null, null , 
    '183' , 'CPS/Card Not Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSECBAS' , 'VS CPS EC BAS DB' , 1 , 1.65 , 0.15 , null , 
    '186' , 'CPS/E-Commerce-Basic Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSECBAS' , 'VS CPS EC BAS DB' , 1 , null, null, null , 
    '186' , 'CPS/E-Commerce-Basic Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSECPREF' , 'VS CPS EC PREF DB' , 1 , 1.6 , 0.15 , null , 
    '187' , 'CPS/E-Commerce-Preferred Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSECPREF' , 'VS CPS EC PREF DB' , 1 , null, null, null , 
    '187' , 'CPS/E-Commerce-Preferred Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLCNPDB' , 'VS CPS HTL CNP DB' , 1 , 1.7 , 0.15 , null , 
    '189' , 'CPS/Hotel Card Not present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLCNPDB' , 'VS CPS HTL CNP DB' , 1 , null, null, null , 
    '189' , 'CPS/Hotel Card Not present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLCPDB' , 'VS CPS HTL CP DB' , 1 , 1.19 , 0.1 , null , 
    '188' , 'CPS/Hotel Card Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLCPDB' , 'VS CPS HTL CP DB' , 1 , null, null, null , 
    '188' , 'CPS/Hotel Card Present Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLECPDB' , 'VS CPS HTL ECP DB' , 1 , 1.7 , 0.15 , null , 
    '190' , 'CPS/E-Commerce Preferred - Hotel Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSHTLECPDB' , 'VS CPS HTL ECP DB' , 1 , null, null, null , 
    '190' , 'CPS/E-Commerce Preferred - Hotel Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDB' , 'VS CPS PT DB' , 1 , 1.6 , 0.2 , null , 
    '191' , 'CPS/Passenger Transport Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDB' , 'VS CPS PT DB' , 1 , null, null, null , 
    '191' , 'CPS/Passenger Transport Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDBCNP' , 'CPS PASS TR CNP DB' , 2 , 1.7 , 0.15 , null , 
    '297' , 'CPS/Passenger Transport Card Not Present-Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDBCNP' , 'CPS PASS TR CNP DB' , 2 , null, null, null , 
    '297' , 'CPS/Passenger Transport Card Not Present-Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDBCP' , 'CPS PASS TR CP DB' , 1 , 1.19 , 0.1 , null , 
    '294' , 'CPS/Passenger Transport Card Present-Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTDBCP' , 'CPS PASS TR CP DB' , 1 , null, null, null , 
    '294' , 'CPS/Passenger Transport Card Present-Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTECPDB' , 'VS CPS PT ECP DB' , 1 , 1.7 , 0.15 , null , 
    '192' , 'CPS/E-Commerce Preferred - Passenger Transport Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTECPDB' , 'VS CPS PT ECP DB' , 1 , null, null, null , 
    '192' , 'CPS/E-Commerce Preferred - Passenger Transport Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTPPCNP' , 'CPS PASS TR CNP PP' , 2 , 1.75 , 0.2 , null , 
    '298' , 'CPS/Passenger Transport Card Not Present-Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTPPCNP' , 'CPS PASS TR CNP PP' , 2 , null, null, null , 
    '298' , 'CPS/Passenger Transport Card Not Present-Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTPPCP' , 'CPS PASS TR CP PP' , 1 , 1.15 , 0.15 , null , 
    '295' , 'CPS/Passenger Transport Card Present-Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSPTPPCP' , 'CPS PASS TR CP PP' , 1 , null, null, null , 
    '295' , 'CPS/Passenger Transport Card Present-Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSREW1' , 'VS CPS REWARDS 1' , 1 , 1.65 , 0.1 , null , 
    '219' , 'CPS/Rewards 1' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSREW1' , 'VS CPS REWARDS 1' , 1 , null, null, null , 
    '219' , 'CPS/Rewards 1' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSREW2' , 'VS CPS REWARDS 2' , 2 , 1.95 , 0.1 , null , 
    '220' , 'CPS/Rewards 2' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSREW2' , 'VS CPS REWARDS 2' , 2 , null, null, null , 
    '220' , 'CPS/Rewards 2' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSRTL2DB' , 'VS CPS RTL2 DB' , 1 , 0.65 , 0.15 ,  2.0 , 
    '193' , 'CPS/Retail 2 Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSRTL2DB' , 'VS CPS RTL2 DB' , 1 , null, null, null , 
    '193' , 'CPS/Retail 2 Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSRTL2DBCAP' , 'VS CPS RTL2 DB CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    '193' , 'CPS/Retail 2 Debit CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPSRTL2DBCAP' , 'VS CPS RTL2 DB CAP' , 1 , null, null, null , 
    '193' , 'CPS/Retail 2 Debit CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTR' , 'VS CPS PASS TR' , 1 , 1.7 , 0.1 , null , 
    '103' , 'CPS/Passenger Transport Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTR' , 'VS CPS PASS TR' , 1 , null, null, null , 
    '103' , 'CPS/Passenger Transport Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTRCNP' , 'CPS PASS TR CNP CR' , 2 , 1.7 , 0.1 , null , 
    '296' , 'CPS/Passenger Transport Card Not Present-Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTRCNP' , 'CPS PASS TR CNP CR' , 2 , null, null, null , 
    '296' , 'CPS/Passenger Transport Card Not Present-Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTRCP' , 'CPS PASS TR CP CR' , 2 , 1.7 , 0.1 , null , 
    '293' , 'CPS/Passenger Transport Card Present-Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CPTRCP' , 'CPS PASS TR CP CR' , 2 , null, null, null , 
    '293' , 'CPS/Passenger Transport Card Present-Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRDCNP' , 'VS CPS CRD NOT PRES' , 2 , 1.8 , 0.1 , null , 
    '133' , 'CPS/Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRDCNP' , 'VS CPS CRD NOT PRES' , 2 , null, null, null , 
    '133' , 'CPS/Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRECP' , 'VS CPS RECUR PMT' , 1 , 1.43 , 0.05 , null , 
    '160' , 'CPS/Recurring Bill Payment' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRECP' , 'VS CPS RECUR PMT' , 1 , null, null, null , 
    '160' , 'CPS/Recurring Bill Payment' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRT2' , 'VS CPS RETAIL2' , 1 , 1.43 , 0.05 , null , 
    '143' , 'CPS/Retail 2 Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRT2' , 'VS CPS RETAIL2' , 1 , null, null, null , 
    '143' , 'CPS/Retail 2 Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCR' , 'VS CPS RETAIL CR' , 1 , 1.51 , 0.1 , null , 
    '106' , 'CPS/Retail Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCR' , 'VS CPS RETAIL CR' , 1 , null, null, null , 
    '106' , 'CPS/Retail Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT1' , 'VS CPS RTL CR T1' , 1 , 1.43 , 0.1 , null , 
    'RCT' , 'CPS/Retail Credit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT1' , 'VS CPS RTL CR T1' , 1 , null, null, null , 
    'RCT' , 'CPS/Retail Credit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT2' , 'VS CPS RTL CR T2' , 1 , 1.47 , 0.1 , null , 
    'RCT' , 'CPS/Retail Credit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT2' , 'VS CPS RTL CR T2' , 1 , null, null, null , 
    'RCT' , 'CPS/Retail Credit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT3' , 'VS CPS RTL CR T3' , 1 , 1.51 , 0.1 , null , 
    'RCT' , 'CPS/Retail Credit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTCRT3' , 'VS CPS RTL CR T3' , 1 , null, null, null , 
    'RCT' , 'CPS/Retail Credit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTKE' , 'VS CPS RTL KEYENTRY' , 2 , 1.8 , 0.1 , null , 
    '152' , 'CPS/Retail Key Entry Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104CRTKE' , 'VS CPS RTL KEYENTRY' , 2 , null, null, null , 
    '152' , 'CPS/Retail Key Entry Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFCA' , 'VS EC PREFERRED CAR RENTAL' , 1 , 1.54 , 0.1 , null , 
    '169' , 'CPS/E-Commerce Preferred - Car Rental' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFCA' , 'VS EC PREFERRED CAR RENTAL' , 1 , null, null, null , 
    '169' , 'CPS/E-Commerce Preferred - Car Rental' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFH' , 'VS EC PREFERRED HOTEL' , 1 , 1.54 , 0.1 , null , 
    '169' , 'CPS/E-Commerce Preferred - Hotel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFH' , 'VS EC PREFERRED HOTEL' , 1 , null, null, null , 
    '169' , 'CPS/E-Commerce Preferred - Hotel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFPT' , 'VS EC PREF PASS TRANSPORT' , 1 , 1.7 , 0.1 , null , 
    '168' , 'CPS/E-Commerce Preferred - Passenger Transport' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ECPREFPT' , 'VS EC PREF PASS TRANSPORT' , 1 , null, null, null , 
    '168' , 'CPS/E-Commerce Preferred - Passenger Transport' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EDCASH' , 'VS EXP DOM CASH ADV' , 3 , 2.3 , 0.1 , null , 
    '004' , 'Express Domestic Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EDCASH' , 'VS EXP DOM CASH ADV' , 3 , null, null, null , 
    '004' , 'Express Domestic Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EICASH' , 'VS EXP INTL CASH ADV' , 3 , 2.3 , 0.1 , null , 
    '005' , 'Express International Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EICASH' , 'VS EXP INTL CASH ADV' , 3 , null, null, null , 
    '005' , 'Express International Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EIRFSIG' , 'VS SIG EIRF CR' , 3 , 2.3 , 0.1 , null , 
    '150' , 'Signature EIRF Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EIRFSIG' , 'VS SIG EIRF CR' , 3 , null, null, null , 
    '150' , 'Signature EIRF Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EXPMTDB' , 'VS US EXPRESS PMT DB' , 1 , 1.95 , 0.02 , null , 
    '194' , 'Express Payment Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EXPMTDB' , 'VS US EXPRESS PMT DB' , 1 , null, null, null , 
    '194' , 'Express Payment Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EXPY' , 'VS US EXPRESS PMT CR' , 2 , 2.0 , 0.02 , null , 
    '117' , 'Express Payment Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104EXPY' , 'VS US EXPRESS PMT CR' , 2 , null, null, null , 
    '117' , 'Express Payment Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104GSAG2G' , 'GSA GOVERNMENT TO GOVERNMENT' , 1 , 1.65 , 0.1 , null , 
    'G2G' , 'GSA Government to Government' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104GSAG2G' , 'GSA GOVERNMENT TO GOVERNMENT' , 1 , null, null, null , 
    'G2G' , 'GSA Government to Government' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104GSALT' , 'VS GSA COMM LRG TX0' , 3 , 1.2 , 39.0 , null , 
    '147' , 'GSA Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104GSALT' , 'VS GSA COMM LRG TX0' , 3 , null, null, null , 
    '147' , 'GSA Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104HCNP' , 'VS HTL CARD NOT PRESENT' , 1 , 1.54 , 0.1 , null , 
    '115' , 'CPS/Hotel Rental Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104HCNP' , 'VS HTL CARD NOT PRESENT' , 1 , null, null, null , 
    '115' , 'CPS/Hotel Rental Card Not Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104HCP' , 'VS CPS HTL CARD PRESENT' , 1 , 1.54 , 0.1 , null , 
    '132' , 'CPS/Hotel Card Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104HCP' , 'VS CPS HTL CARD PRESENT' , 1 , null, null, null , 
    '132' , 'CPS/Hotel Card Present Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IBUS' , 'VS COMCL BUS' , 2 , 2.0 , 0.0 , null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IBUS' , 'VS COMCL BUS' , 2 , null, null, null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICASH' , 'VS US CASH ADV' , 3 , -0.33 , -1.75 , null , 
    '001' , 'International Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICASH' , 'VS US CASH ADV' , 3 , null, null, null , 
    '001' , 'International Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICISS' , 'VS CHIP ISS' , 1 , 1.2 , 0.0 , null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICISS' , 'VS CHIP ISS' , 1 , null, null, null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICOR' , 'VS COMCL CORP' , 2 , 2.0 , 0.0 , null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICOR' , 'VS COMCL CORP' , 2 , null, null, null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICTER' , 'VS CHIP TERMNL' , 1 , 1.0 , 0.0 , null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ICTER' , 'VS CHIP TERMNL' , 1 , null, null, null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INEMLT' , 'VS INTLMRCH EMRGMKT' , 3 , 0.95 , 35.0 , null , 
    '157' , 'Purchasing Large Ticket - International Merchant' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INEMLT' , 'VS INTLMRCH EMRGMKT' , 3 , null, null, null , 
    '157' , 'Purchasing Large Ticket - International Merchant' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INFC' , 'VS INFINITE CR' , 2 , 1.97 , 0.0 , null , 
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INFC' , 'VS INFINITE CR' , 2 , null, null, null , 
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INGOV' , 'VS STL INTRAGOVT' , 1 , 0.0 , 5.0 , null , 
    '155' , 'Intragovernment Transfer - Settled' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INGOV' , 'VS STL INTRAGOVT' , 1 , null, null, null , 
    '155' , 'Intragovernment Transfer - Settled' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INLKS' , 'VS INTERLINK STD' , 1 , 1.1 , 0.0 , null , 
    '923' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INLKS' , 'VS INTERLINK STD' , 1 , null, null, null , 
    '923' , 'Interlink Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLM' , 'VS INTLMRCH' , 1 , 1.6 , 0.0 , null , 
    '104' , 'International Merchant - Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLM' , 'VS INTLMRCH' , 1 , null, null, null , 
    '104' , 'International Merchant - Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMB' , 'VS INTLMRCH BUS' , 2 , 1.8 , 0.0 , null , 
    '136' , 'International Merchant - Business card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMB' , 'VS INTLMRCH BUS' , 2 , null, null, null , 
    '136' , 'International Merchant - Business card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMC' , 'VS INTLMRCH CORP' , 2 , 1.8 , 0.0 , null , 
    '137' , 'International Merchant - Corporate card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMC' , 'VS INTLMRCH CORP' , 2 , null, null, null , 
    '137' , 'International Merchant - Corporate card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLME' , 'VS INTLMRCH ELEC' , 1 , 1.1 , 0.0 , null , 
    '135' , 'International Merchant - Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLME' , 'VS INTLMRCH ELEC' , 1 , null, null, null , 
    '135' , 'International Merchant - Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMINF' , 'VS INTL MERCH INFINITE' , 2 , 1.8 , 0.0 , null , 
    '229' , 'International Merchant - Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMINF' , 'VS INTL MERCH INFINITE' , 2 , null, null, null , 
    '229' , 'International Merchant - Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMP' , 'VS INTLMRCH PURCH' , 2 , 1.8 , 0.0 , null , 
    '138' , 'International Merchant - Purchasing card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMP' , 'VS INTLMRCH PURCH' , 2 , null, null, null , 
    '138' , 'International Merchant - Purchasing card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMSIG' , 'VS INTL MERCH SIGNATURE' , 2 , 1.8 , 0.0 , null , 
    '228' , 'International Merchant - Signature Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLMSIG' , 'VS INTL MERCH SIGNATURE' , 2 , null, null, null , 
    '228' , 'International Merchant - Signature Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLVSP' , 'INTLMRCH  VSP' , 2 , 1.97 , 0.0 , null , 
    '245' , 'Visa International Merchant - Signature Preferred' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104INTLVSP' , 'INTLMRCH  VSP' , 2 , null, null, null , 
    '245' , 'Visa International Merchant - Signature Preferred' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPREM' , 'INTERREGIONAL PREMIUM CARD' , 1 , 1.8 , 0.0 , null , 
    '947' , 'Visa International Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPREM' , 'INTERREGIONAL PREMIUM CARD' , 1 , null, null, null , 
    '947' , 'Visa International Premium Card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPS2' , 'VS INTL PRE PS2000' , 1 , 1.1 , 0.0 , null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPS2' , 'VS INTL PRE PS2000' , 1 , null, null, null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPUR' , 'VS COMCL PURCH' , 2 , 2.0 , 0.0 , null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IPUR' , 'VS COMCL PURCH' , 2 , null, null, null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ISPREM' , 'US VSP INTR' , 2 , 1.97 , 0.0 , null , 
    '948' , 'Super Premium Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ISPREM' , 'US VSP INTR' , 2 , null, null, null , 
    '948' , 'Super Premium Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ISTD' , 'VS STANDARD' , 1 , 1.6 , 0.0 , null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104ISTD' , 'VS STANDARD' , 1 , null, null, null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IVSP' , 'VSP INTR' , 2 , 1.97 , 0.0 , null , 
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104IVSP' , 'VSP INTR' , 2 , null, null, null , 
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PS2AF' , 'VS PS2000 AFD' , 1 , 1.15 , 0.25 ,  1.1 , 
    '134' , 'CPS/Automated Fuel Dispenser Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PS2AF' , 'VS PS2000 AFD' , 1 , null, null, null , 
    '134' , 'CPS/Automated Fuel Dispenser Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA1' , 'US PURCH LPA1' , 3 , 0.7 , 49.5 , null , 
    '267' , 'Purchasing Card - Large Purchase Advantage 1' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA1' , 'US PURCH LPA1' , 3 , null, null, null , 
    '267' , 'Purchasing Card - Large Purchase Advantage 1' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA2' , 'US PURCH LPA2' , 3 , 0.6 , 52.5 , null , 
    '268' , 'Purchasing Card - Large Purchase Advantage 2' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA2' , 'US PURCH LPA2' , 3 , null, null, null , 
    '268' , 'Purchasing Card - Large Purchase Advantage 2' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA3' , 'US PURCH LPA3' , 3 , 0.5 , 55.5 , null , 
    '269' , 'Purchasing Card - Large Purchase Advantage 3' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA3' , 'US PURCH LPA3' , 3 , null, null, null , 
    '269' , 'Purchasing Card - Large Purchase Advantage 3' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA4' , 'US PURCH LPA4' , 3 , 0.4 , 58.5 , null , 
    '270' , 'Purchasing Card - Large Purchase Advantage 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULPA4' , 'US PURCH LPA4' , 3 , null, null, null , 
    '270' , 'Purchasing Card - Large Purchase Advantage 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULTPP' , 'VS PUR LT PP' , 1 , 1.45 , 35.0 , null , 
    '367' , 'Purchasing Large Ticket' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PULTPP' , 'VS PUR LT PP' , 1 , null, null, null , 
    '367' , 'Purchasing Large Ticket' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLBSC' , 'PRIVATE LABEL BASIC' , 1 , 0.0 , 0.0 , null , 
    '952' , 'Private Label - Basic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLBSC' , 'PRIVATE LABEL BASIC' , 1 , null, null, null , 
    '952' , 'Private Label - Basic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLENH' , 'PRIVATE LABEL ENHANCED' , 3 , 5.0 , 0.0 , null , 
    '954' , 'Private Label - Enhanced' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLENH' , 'PRIVATE LABEL ENHANCED' , 3 , null, null, null , 
    '954' , 'Private Label - Enhanced' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLPRE' , 'PRIVATE LABEL PREMIUM' , 3 , 30.0 , 0.0 , null , 
    '956' , 'Private Label - Premium' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLPRE' , 'PRIVATE LABEL PREMIUM' , 3 , null, null, null , 
    '956' , 'Private Label - Premium' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLSPL' , 'PRIVATE LABEL SPECIALIZED' , 3 , 25.0 , 0.0 , null , 
    '955' , 'Private Label - Specialized' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLSPL' , 'PRIVATE LABEL SPECIALIZED' , 3 , null, null, null , 
    '955' , 'Private Label - Specialized' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLSTD' , 'PRIVATE LABEL STANDARD' , 1 , 1.75 , 0.2 , null , 
    '953' , 'Private Label - Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104PVLSTD' , 'PRIVATE LABEL STANDARD' , 1 , null, null, null , 
    '953' , 'Private Label - Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104RTLKEYDB' , 'VS RTL KEY DB' , 1 , 1.65 , 0.15 , null , 
    '182' , 'CPS/Retail Key Entry Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104RTLKEYDB' , 'VS RTL KEY DB' , 1 , null, null, null , 
    '182' , 'CPS/Retail Key Entry Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104RTOCH' , 'VS RTL ONL CHCK' , 1 , 0.55 , 0.1 , null , 
    '139' , 'U.S. Check Card II - Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104RTOCH' , 'VS RTL ONL CHCK' , 1 , null, null, null , 
    '139' , 'U.S. Check Card II - Retail' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SETM' , 'VS SET MRCH' , 1 , 1.44 , 0.0 , null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SETM' , 'VS SET MRCH' , 1 , null, null, null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SETMS' , 'VS SET MRCH SEC' , 1 , 1.44 , 0.0 , null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SETMS' , 'VS SET MRCH SEC' , 1 , null, null, null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SMKTDBCAP' , 'VS SUPER MKT DB CAP' , 1 , 0.0 , 0.3 , null , 
    '180' , 'US Supermarket Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SMKTDBCAP' , 'VS SUPER MKT DB CAP' , 1 , null, null, null , 
    '180' , 'US Supermarket Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104STDSIG' , 'VS US SIG STD CR' , 3 , 2.7 , 0.1 , null , 
    '148' , 'Signature Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104STDSIG' , 'VS US SIG STD CR' , 3 , null, null, null , 
    '148' , 'Signature Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCR' , 'VS SUPERMARKET CR' , 1 , 1.22 , 0.05 , null , 
    '102' , 'CPS/Supermarket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCR' , 'VS SUPERMARKET CR' , 1 , null, null, null , 
    '102' , 'CPS/Supermarket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRDB' , 'SUPERMARKET CRED DB' , 1 , 1.03 , 0.15 ,  0.35 , 
    '181' , 'CPS/Supermarket Credit Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRDB' , 'SUPERMARKET CRED DB' , 1 , null, null, null , 
    '181' , 'CPS/Supermarket Credit Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT1' , 'VS SUPM T1 CR' , 1 , 1.15 , 0.05 , null , 
    'SCT' , 'CPS/Supermarket Credit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT1' , 'VS SUPM T1 CR' , 1 , null, null, null , 
    'SCT' , 'CPS/Supermarket Credit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT2' , 'VS SUPM T2 CR' , 1 , 1.2 , 0.05 , null , 
    'SCT' , 'CPS/Supermarket Credit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT2' , 'VS SUPM T2 CR' , 1 , null, null, null , 
    'SCT' , 'CPS/Supermarket Credit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT3' , 'VS SUPM T3 CR' , 1 , 1.22 , 0.05 , null , 
    'SCT' , 'CPS/Supermarket Credit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPCRT3' , 'VS SUPM T3 CR' , 1 , null, null, null , 
    'SCT' , 'CPS/Supermarket Credit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDB' , 'VS SUPERMARKET DB' , 1 , 0.0 , 0.3 , null , 
    '180' , 'CPS/Supermarket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDB' , 'VS SUPERMARKET DB' , 1 , null, null, null , 
    '180' , 'CPS/Supermarket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCAP' , 'VS SUPM CAP DB' , 1 , 1.03 , 0.15 ,  0.35 , 
    'CP0' , 'CPS/Supermarket Debit Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCAP' , 'VS SUPM CAP DB' , 1 , null, null, null , 
    'CP0' , 'CPS/Supermarket Debit Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT1' , 'VS SUPM CAP T1 DB' , 1 , 0.62 , 0.19 ,  0.35 , 
    'CP1' , 'CPS/Supermarket Debit Thresh I Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT1' , 'VS SUPM CAP T1 DB' , 1 , null, null, null , 
    'CP1' , 'CPS/Supermarket Debit Thresh I Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT2' , 'VS SUPM CAP T2 DB' , 1 , 0.81 , 0.23 ,  0.35 , 
    'CP2' , 'CPS/Supermarket Debit Thresh II Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT2' , 'VS SUPM CAP T2 DB' , 1 , null, null, null , 
    'CP2' , 'CPS/Supermarket Debit Thresh II Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT3' , 'VS SUPM CAP T3 DB' , 1 , 0.92 , 0.28 ,  0.35 , 
    'CP3' , 'CPS/Supermarket Debit Thresh III Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBCT3' , 'VS SUPM CAP T3 DB' , 1 , null, null, null , 
    'CP3' , 'CPS/Supermarket Debit Thresh III Cap' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT1' , 'VS SUPM T1 DB' , 1 , 0.62 , 0.19 ,  0.35 , 
    'SDT' , 'CPS/Supermarket Debit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT1' , 'VS SUPM T1 DB' , 1 , null, null, null , 
    'SDT' , 'CPS/Supermarket Debit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT2' , 'VS SUPM T2 DB' , 1 , 0.81 , 0.23 ,  0.35 , 
    'SDT' , 'CPS/Supermarket Debit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT2' , 'VS SUPM T2 DB' , 1 , null, null, null , 
    'SDT' , 'CPS/Supermarket Debit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT3' , 'VS SUPM T3 DB' , 1 , 0.92 , 0.28 ,  0.35 , 
    'SDT' , 'CPS/Supermarket Debit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPDBT3' , 'VS SUPM T3 DB' , 1 , null, null, null , 
    'SDT' , 'CPS/Supermarket Debit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPOCH' , 'VS SUPERMKT ONL CHCK' , 1 , 0.0 , 0.25 , null , 
    '140' , 'U.S. Check Card II - Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104SUPOCH' , 'VS SUPERMKT ONL CHCK' , 1 , null, null, null , 
    '140' , 'U.S. Check Card II - Supermarket' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPACQ' , 'Acq Chip-Air' , 1 , 1.0 , 0.0 , null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPACQ' , 'Acq Chip-Air' , 1 , null, null, null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , 1.1 , 0.0 , null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , null, null, null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , null, null, null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRLINE' , 'Airline' , 1 , 1.1 , 0.0 , null , 
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCAIRLINE' , 'Airline' , 1 , null, null, null , 
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCBUS' , 'Business' , 2 , 2.0 , 0.0 , null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCBUS' , 'Business' , 2 , null, null, null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPACQ' , 'Acq Chip' , 1 , 1.0 , 0.0 , null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPACQ' , 'Acq Chip' , 1 , null, null, null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPFULL' , 'Chip-Full Data' , 1 , 1.1 , 0.0 , null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPFULL' , 'Chip-Full Data' , 1 , null, null, null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , null, null, null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPISS' , 'Iss Chip' , 1 , 1.2 , 0.0 , null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCHIPISS' , 'Iss Chip' , 1 , null, null, null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCORP' , 'Corporate' , 2 , 2.0 , 0.0 , null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCCORP' , 'Corporate' , 2 , null, null, null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCECM' , 'Ele Comm Merch' , 1 , 1.44 , 0.0 , null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCECM' , 'Ele Comm Merch' , 1 , null, null, null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCEIRF' , 'Electronic' , 1 , 1.1 , 0.0 , null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCEIRF' , 'Electronic' , 1 , null, null, null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCEIRFVE' , 'VE INT PREPS2000' , 1 , 1.1 , 0.0 , null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCEIRFVE' , 'VE INT PREPS2000' , 1 , null, null, null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCINF' , 'Infinite' , 2 , 1.97 , 0.0 , null , 
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCINF' , 'Infinite' , 2 , null, null, null , 
    '904' , 'Infinite Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCPURCH' , 'Purchasing' , 2 , 2.0 , 0.0 , null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCPURCH' , 'Purchasing' , 2 , null, null, null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSEC' , 'Sec Ele Comm' , 1 , 1.44 , 0.0 , null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSEC' , 'Sec Ele Comm' , 1 , null, null, null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSIG' , 'VS SIGNATURE CARD' , 2 , 1.8 , 0.0 , null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSIG' , 'VS SIGNATURE CARD' , 2 , null, null, null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSTD' , 'Cons Std' , 1 , 1.6 , 0.0 , null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCSTD' , 'Cons Std' , 1 , null, null, null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPACQ' , 'Acq Chip Air-VE' , 1 , 1.0 , 0.0 , null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPACQ' , 'Acq Chip Air-VE' , 1 , null, null, null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , null, null, null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRCHIPFULLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , null, null, null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRLINE' , 'Airline-VE' , 1 , 1.1 , 0.0 , null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEAIRLINE' , 'Airline-VE' , 1 , null, null, null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPACQ' , 'Acq Chip-VE' , 1 , 1.0 , 0.0 , null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPACQ' , 'Acq Chip-VE' , 1 , null, null, null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPFULL' , 'Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPFULL' , 'Chip-Full Data-VE' , 1 , null, null, null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , null, null, null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPISS' , 'Iss Chip-VE' , 1 , 1.2 , 0.0 , null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVECHIPISS' , 'Iss Chip-VE' , 1 , null, null, null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEECM' , 'Ele Comm Merch-VE' , 1 , 1.44 , 0.0 , null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVEECM' , 'Ele Comm Merch-VE' , 1 , null, null, null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVESEC' , 'Sec Ele Comm-VE' , 1 , 1.44 , 0.0 , null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVESEC' , 'Sec Ele Comm-VE' , 1 , null, null, null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVESTD' , 'VE STANDARD' , 1 , 1.6 , 0.0 , null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104TCVESTD' , 'VE STANDARD' , 1 , null, null, null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSCNPDB' , 'US BUS CARD NOT PRESENT DB' , 3 , 2.45 , 0.1 , null , 
    '292' , 'Business card-Card Not Present Debit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSCNPDB' , 'US BUS CARD NOT PRESENT DB' , 3 , null, null, null , 
    '292' , 'Business card-Card Not Present Debit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSCPDB' , 'US BUS CARD PRESENT DB' , 2 , 1.7 , 0.1 , null , 
    '291' , 'Business card-Card Present Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSCPDB' , 'US BUS CARD PRESENT DB' , 2 , null, null, null , 
    '291' , 'Business card-Card Present Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSINAIR' , 'VS US BUS INTR AIR' , 2 , 1.8 , 0.0 , null , 
    '175' , 'U.S. Business Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSINAIR' , 'VS US BUS INTR AIR' , 2 , null, null, null , 
    '175' , 'U.S. Business Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSSDB' , 'US BUS STD DB' , 3 , 2.95 , 0.1 , null , 
    '290' , 'Business card-Standard Debit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSSDB' , 'US BUS STD DB' , 3 , null, null, null , 
    '290' , 'Business card-Standard Debit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1B2B' , 'BUSINESS CARD B2B' , 2 , 2.1 , 0.1 , null , 
    '230' , 'Business Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1B2B' , 'BUSINESS CARD B2B' , 2 , null, null, null , 
    '230' , 'Business Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1CNP' , 'BUSINESS CARD CNP' , 3 , 2.25 , 0.1 , null , 
    '231' , 'Business Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1CNP' , 'BUSINESS CARD CNP' , 3 , null, null, null , 
    '231' , 'Business Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1ELEC' , 'VS US BUSTIER1 ELEC' , 3 , 2.4 , 0.1 , null , 
    '112' , 'Business Card - Electronic Tier 1' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1ELEC' , 'VS US BUSTIER1 ELEC' , 3 , null, null, null , 
    '112' , 'Business Card - Electronic Tier 1' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1LVL2' , 'VS US BUS LEVEL2' , 2 , 2.05 , 0.1 , null , 
    '170' , 'Business Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1LVL2' , 'VS US BUS LEVEL2' , 2 , null, null, null , 
    '170' , 'Business Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1RTL' , 'BUSINESS CARD RTL' , 3 , 2.2 , 0.1 , null , 
    '232' , 'Business Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1RTL' , 'BUSINESS CARD RTL' , 3 , null, null, null , 
    '232' , 'Business Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1STD' , 'VS US BUSTIER1 STD' , 3 , 2.95 , 0.2 , null , 
    '109' , 'Business Card-Standard Tier 1' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR1STD' , 'VS US BUSTIER1 STD' , 3 , null, null, null , 
    '109' , 'Business Card-Standard Tier 1' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2B2B' , 'VS US BUS ENH B2B' , 3 , 2.25 , 0.1 , null , 
    '383' , 'Business Enhanced Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2B2B' , 'VS US BUS ENH B2B' , 3 , null, null, null , 
    '383' , 'Business Enhanced Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2CNP' , 'VS US BUS ENH CNP' , 3 , 2.45 , 0.15 , null , 
    '381' , 'Business Enhanced Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2CNP' , 'VS US BUS ENH CNP' , 3 , null, null, null , 
    '381' , 'Business Enhanced Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2ELEC' , 'VS US BUS ENH ELEC' , 3 , 2.75 , 0.15 , null , 
    '384' , 'Business Enhanced Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2ELEC' , 'VS US BUS ENH ELEC' , 3 , null, null, null , 
    '384' , 'Business Enhanced Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2LVL2' , 'VS US BUS ENH LVL2' , 2 , 2.05 , 0.1 , null , 
    '380' , 'Business Enhanced Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2LVL2' , 'VS US BUS ENH LVL2' , 2 , null, null, null , 
    '380' , 'Business Enhanced Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2RTL' , 'VS US BUS ENH RTL' , 3 , 2.3 , 0.1 , null , 
    '382' , 'Business Enhanced Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2RTL' , 'VS US BUS ENH RTL' , 3 , null, null, null , 
    '382' , 'Business Enhanced Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2STD' , 'VS US BUS ENH STD' , 3 , 2.95 , 0.2 , null , 
    '385' , 'Business Enhanced Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR2STD' , 'VS US BUS ENH STD' , 3 , null, null, null , 
    '385' , 'Business Enhanced Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3B2B' , 'VS US SIG BUS B2B' , 3 , 2.4 , 0.1 , null , 
    '389' , 'Signature Business Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3B2B' , 'VS US SIG BUS B2B' , 3 , null, null, null , 
    '389' , 'Signature Business Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3CNP' , 'VS US SIG BUS CNP' , 3 , 2.6 , 0.2 , null , 
    '390' , 'Signature Business Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3CNP' , 'VS US SIG BUS CNP' , 3 , null, null, null , 
    '390' , 'Signature Business Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3ELEC' , 'VS US SIG BUS ELEC' , 3 , 2.85 , 0.2 , null , 
    '387' , 'Signature Business Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3ELEC' , 'VS US SIG BUS ELEC' , 3 , null, null, null , 
    '387' , 'Signature Business Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3LVL2' , 'VS US SIG BUS LVL2' , 3 , 2.05 , 0.1 , null , 
    '388' , 'Signature Business Card - Level 2' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3LVL2' , 'VS US SIG BUS LVL2' , 3 , null, null, null , 
    '388' , 'Signature Business Card - Level 2' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3RTL' , 'VS US SIG BUS RTL' , 3 , 2.4 , 0.1 , null , 
    '391' , 'Signature Business Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3RTL' , 'VS US SIG BUS RTL' , 3 , null, null, null , 
    '391' , 'Signature Business Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3STD' , 'VS US SIG BUS STD' , 3 , 2.95 , 0.2 , null , 
    '386' , 'Signature Business Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR3STD' , 'VS US SIG BUS STD' , 3 , null, null, null , 
    '386' , 'Signature Business Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4B2B' , 'VS US BUSTIER4 B2B' , 3 , 2.5 , 0.1 , null , 
    '397' , 'Business to Business Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4B2B' , 'VS US BUSTIER4 B2B' , 3 , null, null, null , 
    '397' , 'Business to Business Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4CNP' , 'VS US BUSTIER4 CNP' , 3 , 2.7 , 0.2 , null , 
    '377' , 'Business Card Not Present Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4CNP' , 'VS US BUSTIER4 CNP' , 3 , null, null, null , 
    '377' , 'Business Card Not Present Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4ELEC' , 'VS US BUSTIER4 ELEC' , 3 , 2.95 , 0.2 , null , 
    '399' , 'Business Electronic Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4ELEC' , 'VS US BUSTIER4 ELEC' , 3 , null, null, null , 
    '399' , 'Business Electronic Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4LVL2' , 'VS US BUSTIER4 LVL2' , 2 , 2.2 , 0.1 , null , 
    '398' , 'Business Level 2 Tier 4' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4LVL2' , 'VS US BUSTIER4 LVL2' , 2 , null, null, null , 
    '398' , 'Business Level 2 Tier 4' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4RTL' , 'VS US BUSTIER4 RTL' , 3 , 2.5 , 0.1 , null , 
    '378' , 'Business Retail Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4RTL' , 'VS US BUSTIER4 RTL' , 3 , null, null, null , 
    '378' , 'Business Retail Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4STD' , 'VS US BUSTIER4 STD' , 3 , 2.95 , 0.25 , null , 
    '376' , 'Business Standard Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UBUSTR4STD' , 'VS US BUSTIER4 STD' , 3 , null, null, null , 
    '376' , 'Business Standard Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCASH' , 'VS US CASH ADV' , 3 , 0.0 , -2.0 , null , 
    '002' , 'US Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCASH' , 'VS US CASH ADV' , 3 , null, null, null , 
    '002' , 'US Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCASH' , 'VS US CASH ADV' , 3 , 0.0 , -2.0 , null , 
    '003' , 'US Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCASH' , 'VS US CASH ADV' , 3 , null, null, null , 
    '003' , 'US Cash Advance' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORE' , 'VS US CORP ELEC' , 3 , 2.95 , 0.1 , null , 
    '113' , 'Corporate Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORE' , 'VS US CORP ELEC' , 3 , null, null, null , 
    '113' , 'Corporate Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPELWD' , 'US CORPORATE ELEC WITH DATA' , 3 , 2.95 , 0.1 , null , 
    '272' , 'Corporate Card - Electronic with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPELWD' , 'US CORPORATE ELEC WITH DATA' , 3 , null, null, null , 
    '272' , 'Corporate Card - Electronic with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPLVL2' , 'VS US CORP LEVEL2' , 2 , 2.05 , 0.1 , null , 
    '171' , 'Corporate Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPLVL2' , 'VS US CORP LEVEL2' , 2 , null, null, null , 
    '171' , 'Corporate Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPLVL3' , 'US CORPORATE LEVEL3' , 2 , 1.85 , 0.1 , null , 
    '271' , 'Corporate Card - Non-Travel Service, Level 3' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPLVL3' , 'US CORPORATE LEVEL3' , 2 , null, null, null , 
    '271' , 'Corporate Card - Non-Travel Service, Level 3' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPSTDWD' , 'US Corporate Std with Data' , 3 , 2.95 , 0.1 , null , 
    '272' , 'Corporate Card - Standard with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPSTDWD' , 'US Corporate Std with Data' , 3 , null, null, null , 
    '272' , 'Corporate Card - Standard with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPTVLS' , 'US CORP TRAVEL SVC' , 3 , 2.55 , 0.1 , null , 
    '225' , 'Corporate Card-Travel Service' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORPTVLS' , 'US CORP TRAVEL SVC' , 3 , null, null, null , 
    '225' , 'Corporate Card-Travel Service' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORS' , 'VS US CORP STD' , 3 , 2.95 , 0.1 , null , 
    '110' , 'Corporate Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCORS' , 'VS US CORP STD' , 3 , null, null, null , 
    '110' , 'Corporate Card - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSACCTFPP' , 'CPS_Account Funding Prepaid' , 1 , 1.8 , 0.2 , null , 
    '327' , 'CPS/Account Funding Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSACCTFPP' , 'CPS_Account Funding Prepaid' , 1 , null, null, null , 
    '327' , 'CPS/Account Funding Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSAFDPP' , 'CPS AFD PREPAID' , 1 , 1.15 , 0.15 ,  0.95 , 
    '318' , 'CPS/Automated Fuel Dispenser Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSAFDPP' , 'CPS AFD PREPAID' , 1 , null, null, null , 
    '318' , 'CPS/Automated Fuel Dispenser Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSAFDPPCAP' , 'CPS_AFD Prepaid CAP' , 1 , 1.15 , 0.15 ,  0.95 , 
    '318' , 'CPS/Automated Fuel Dispenser Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSAFDPPCAP' , 'CPS_AFD Prepaid CAP' , 1 , null, null, null , 
    '318' , 'CPS/Automated Fuel Dispenser Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSCNPPP' , 'CPS CARD NOT PRESENT PREPAID' , 1 , 1.75 , 0.2 , null , 
    '319' , 'CPS/Card Not Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSCNPPP' , 'CPS CARD NOT PRESENT PREPAID' , 1 , null, null, null , 
    '319' , 'CPS/Card Not Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSDCRVO' , 'CPS CREDIT VOUCHER DEBIT' , 1 , 0.0 , 0.0 , null , 
    '369' , 'CPS/ Credit Voucher Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSDCRVO' , 'CPS CREDIT VOUCHER DEBIT' , 1 , null, null, null , 
    '369' , 'CPS/ Credit Voucher Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSECBASPP' , 'CPS_ECom-Basic Prepaid' , 1 , 1.75 , 0.2 , null , 
    '321' , 'CPS/E-Commerce - Basic Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSECBASPP' , 'CPS_ECom-Basic Prepaid' , 1 , null, null, null , 
    '321' , 'CPS/E-Commerce - Basic Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSECPREFPP' , 'CPS_ECom-Preferred Prepaid' , 1 , 1.75 , 0.2 , null , 
    '320' , 'CPS/E-Commerce - Preferred Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSECPREFPP' , 'CPS_ECom-Preferred Prepaid' , 1 , null, null, null , 
    '320' , 'CPS/E-Commerce - Preferred Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLCNPPP' , 'CPS_Hotel CardNotPre Prepaid' , 1 , 1.75 , 0.2 , null , 
    '324' , 'CPS/Hotel / Car Rental Card Not Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLCNPPP' , 'CPS_Hotel CardNotPre Prepaid' , 1 , null, null, null , 
    '324' , 'CPS/Hotel / Car Rental Card Not Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLCPPP' , 'CPS_Hotel CardPresent Prepaid' , 1 , 1.15 , 0.15 , null , 
    '325' , 'CPS/Hotel / Car Rental Card Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLCPPP' , 'CPS_Hotel CardPresent Prepaid' , 1 , null, null, null , 
    '325' , 'CPS/Hotel / Car Rental Card Present Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLECPPP' , 'CPS_ECom PrefHotel Prepaid' , 1 , 1.75 , 0.2 , null , 
    '326' , 'CPS/E-Commerce Preferred - Hotel and Car Rental Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSHTLECPPP' , 'CPS_ECom PrefHotel Prepaid' , 1 , null, null, null , 
    '326' , 'CPS/E-Commerce Preferred - Hotel and Car Rental Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSPTECPPP' , 'CPS_ECom PrefPasTrans Prepaid' , 1 , 1.75 , 0.2 , null , 
    '322' , 'CPS/E-Commerce Preferred - Passenger Transport Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSPTECPPP' , 'CPS_ECom PrefPasTrans Prepaid' , 1 , null, null, null , 
    '322' , 'CPS/E-Commerce Preferred - Passenger Transport Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSPTPP' , 'CPS PAS TRANS PREPAID' , 1 , 1.75 , 0.2 , null , 
    '323' , 'CPS/Passenger Transport Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSPTPP' , 'CPS PAS TRANS PREPAID' , 1 , null, null, null , 
    '323' , 'CPS/Passenger Transport Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSREGSMT' , 'CPS SMALL TICKET REG' , 1 , 0.05 , 0.22 , null , 
    '331' , 'CPS/Small Ticket Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSREGSMT' , 'CPS SMALL TICKET REG' , 1 , null, null, null , 
    '331' , 'CPS/Small Ticket Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTL2PP' , 'CPS RETAIL 2 PREPAID' , 1 , 0.65 , 0.15 ,  2.0 , 
    '315' , 'CPS/Retail 2 Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTL2PP' , 'CPS RETAIL 2 PREPAID' , 1 , null, null, null , 
    '315' , 'CPS/Retail 2 Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTL2PPCAP' , 'CPS_Retail2 Prepaid CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    '315' , 'CPS/Retail 2 Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTL2PPCAP' , 'CPS_Retail2 Prepaid CAP' , 1 , null, null, null , 
    '315' , 'CPS/Retail 2 Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTLKEPP' , 'CPS_Retail Key Entry Prepaid' , 1 , 1.75 , 0.2 , null , 
    '330' , 'CPS/Retail Key Entry Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTLKEPP' , 'CPS_Retail Key Entry Prepaid' , 1 , null, null, null , 
    '330' , 'CPS/Retail Key Entry Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTLPP' , 'CPS RETAIL PREPAID' , 1 , 1.15 , 0.15 , null , 
    '316' , 'CPS/Retail Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSRTLPP' , 'CPS RETAIL PREPAID' , 1 , null, null, null , 
    '316' , 'CPS/Retail Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSSMTPP' , 'CPS SMALL TICKET PREPAID' , 1 , 1.6 , 0.05 , null , 
    '314' , 'CPS/Small Ticket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCPSSMTPP' , 'CPS SMALL TICKET PREPAID' , 1 , null, null, null , 
    '314' , 'CPS/Small Ticket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCRPINAIR' , 'VS US CORP INTR AIR' , 2 , 1.8 , 0.0 , null , 
    '176' , 'U.S. Corporate Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCRPINAIR' , 'VS US CORP INTR AIR' , 2 , null, null, null , 
    '176' , 'U.S. Corporate Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVAIPT' , 'VS CREDIT VOUCHER ALL PT' , 3 , 2.33 , 0.0 , null , 
    '165' , 'Credit Voucher-Passenger Transport, All Card Types' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVAIPT' , 'VS CREDIT VOUCHER ALL PT' , 3 , null, null, null , 
    '165' , 'Credit Voucher-Passenger Transport, All Card Types' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCMNPT' , 'VS CREDIT VOUCHER COMM NPT' , 3 , 2.35 , 0.0 , null , 
    '167' , 'Credit Voucher-Nonpassenger Transport, Commercial Card' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCMNPT' , 'VS CREDIT VOUCHER COMM NPT' , 3 , null, null, null , 
    '167' , 'Credit Voucher-Nonpassenger Transport, Commercial Card' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCSMOTO' , 'VS CREDIT VOUCHER CONS MOTO' , 2 , 2.05 , 0.0 , null , 
    '164' , 'Credit Voucher-MOTO and E-Commerce, Consumer Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCSMOTO' , 'VS CREDIT VOUCHER CONS MOTO' , 2 , null, null, null , 
    '164' , 'Credit Voucher-MOTO and E-Commerce, Consumer Credit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCSNPT' , 'VS CREDIT VOUCHER CONS NPT' , 1 , 1.76 , 0.0 , null , 
    '166' , 'Credit Voucher-Nonpassenger Transport, Consumer Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVCSNPT' , 'VS CREDIT VOUCHER CONS NPT' , 1 , null, null, null , 
    '166' , 'Credit Voucher-Nonpassenger Transport, Consumer Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVMOTODB' , 'VS US CV MOTO CONS' , 2 , 1.87 , 0.0 , null , 
    '199' , 'Credit Voucher - MOTO and E-Commerce, Consumer Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVMOTODB' , 'VS US CV MOTO CONS' , 2 , null, null, null , 
    '199' , 'Credit Voucher - MOTO and E-Commerce, Consumer Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVNPTDB' , 'VS US CV NONPT CONS' , 1 , 1.31 , 0.0 , null , 
    '198' , 'Credit Voucher - Non-Passenger Transport, Consumer Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVNPTDB' , 'VS US CV NONPT CONS' , 1 , null, null, null , 
    '198' , 'Credit Voucher - Non-Passenger Transport, Consumer Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA1' , 'US CV GSA PUR 1' , 3 , 2.35 , 0.0 , null , 
    '352' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 1' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA1' , 'US CV GSA PUR 1' , 3 , null, null, null , 
    '352' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 1' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA2' , 'US CV GSA PUR 2' , 3 , 2.15 , 0.0 , null , 
    '353' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 2' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA2' , 'US CV GSA PUR 2' , 3 , null, null, null , 
    '353' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 2' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA3' , 'US CV GSA PUR 3' , 3 , 2.0 , 0.0 , null , 
    '354' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 3' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA3' , 'US CV GSA PUR 3' , 3 , null, null, null , 
    '354' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 3' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA4' , 'US CV GSA PUR 4' , 2 , 1.8 , 0.0 , null , 
    '355' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 4' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA4' , 'US CV GSA PUR 4' , 2 , null, null, null , 
    '355' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 4' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA5' , 'US CV GSA PUR 5' , 2 , 1.8 , 0.0 , null , 
    '356' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 5' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPGSA5' , 'US CV GSA PUR 5' , 2 , null, null, null , 
    '356' , 'Credit Voucher - GSA Purchasing, Non-Passenger Transport 5' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA1' , 'US CV PURCH 1' , 3 , 2.4 , 0.0 , null , 
    '357' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 1' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA1' , 'US CV PURCH 1' , 3 , null, null, null , 
    '357' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 1' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA2' , 'US CV PURCH 2' , 3 , 2.3 , 0.0 , null , 
    '358' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 2' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA2' , 'US CV PURCH 2' , 3 , null, null, null , 
    '358' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 2' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA3' , 'US CV PURCH 3' , 3 , 2.2 , 0.0 , null , 
    '359' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 3' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA3' , 'US CV PURCH 3' , 3 , null, null, null , 
    '359' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 3' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA4' , 'US CV PURCH 4' , 3 , 2.0 , 0.0 , null , 
    '360' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA4' , 'US CV PURCH 4' , 3 , null, null, null , 
    '360' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA5' , 'US CV PURCH 5' , 2 , 1.8 , 0.0 , null , 
    '361' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 5' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPNGSA5' , 'US CV PURCH 5' , 2 , null, null, null , 
    '361' , 'Credit Voucher - Non-GSA Purchasing, Non-Passenger Transport 5' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPTDB' , 'VS US CV PT' , 2 , 2.07 , 0.0 , null , 
    '197' , 'Credit Voucher-Passenger Transport' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UCVPTDB' , 'VS US CV PT' , 2 , null, null, null , 
    '197' , 'Credit Voucher-Passenger Transport' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRF' , 'VS EIRF US' , 3 , 2.3 , 0.1 ,  1.1 , 
    '141' , 'EIRF Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRF' , 'VS EIRF US' , 3 , null, null, null , 
    '141' , 'EIRF Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFCRCAP' , 'VS EIRF US CAP' , 3 , 2.3 , 0.1 ,  1.1 , 
    '141' , 'EIRF Credit CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFCRCAP' , 'VS EIRF US CAP' , 3 , null, null, null , 
    '141' , 'EIRF Credit CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFDB' , 'VS US EIRF DB' , 2 , 1.75 , 0.2 ,  0.95 , 
    '195' , 'EIRF Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFDB' , 'VS US EIRF DB' , 2 , null, null, null , 
    '195' , 'EIRF Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFDBCAP' , 'VS EIRF DB CAP' , 2 , 1.75 , 0.2 ,  0.95 , 
    '195' , 'US EIRF Debit CAP' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFDBCAP' , 'VS EIRF DB CAP' , 2 , null, null, null , 
    '195' , 'US EIRF Debit CAP' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFPP' , 'ELECTRONIC PREPAID' , 2 , 1.8 , 0.2 ,  0.95 , 
    '336' , 'Electronic Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFPP' , 'ELECTRONIC PREPAID' , 2 , null, null, null , 
    '336' , 'Electronic Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFPPCAP' , 'ELECTRONIC PREPAID CAP' , 2 , 1.8 , 0.2 ,  0.95 , 
    '336' , 'Electronic Prepaid CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UEIRFPPCAP' , 'ELECTRONIC PREPAID CAP' , 2 , null, null, null , 
    '336' , 'Electronic Prepaid CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UELEC' , 'VS ELECTRON' , 1 , 1.05 , 0.03 , null , 
    '105' , 'Electron card' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UELEC' , 'VS ELECTRON' , 1 , null, null, null , 
    '105' , 'Electron card' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UINAIR' , 'VS US CONS INTR AIR' , 1 , 1.1 , 0.0 , null , 
    '174' , 'U.S. Consumer Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UINAIR' , 'VS US CONS INTR AIR' , 1 , null, null, null , 
    '174' , 'U.S. Consumer Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURE' , 'VS US PURCH ELEC' , 3 , 2.95 , 0.1 , null , 
    '114' , 'Purchasing Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURE' , 'VS US PURCH ELEC' , 3 , null, null, null , 
    '114' , 'Purchasing Card - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURINAIR' , 'VS US PUR INTR AIR' , 2 , 1.8 , 0.0 , null , 
    '177' , 'U.S. Purchasing Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURINAIR' , 'VS US PUR INTR AIR' , 2 , null, null, null , 
    '177' , 'U.S. Purchasing Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURLVL2' , 'VS US PURCH LEVEL2' , 2 , 2.05 , 0.1 , null , 
    '172' , 'Purchasing Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURLVL2' , 'VS US PURCH LEVEL2' , 2 , null, null, null , 
    '172' , 'Purchasing Card - Non-Travel Service, Level 2' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURLVL3' , 'VS US PURCH LEVEL3' , 2 , 1.85 , 0.1 , null , 
    '173' , 'Purchasing Card-Non-Travel Service, Level 3' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURLVL3' , 'VS US PURCH LEVEL3' , 2 , null, null, null , 
    '173' , 'Purchasing Card-Non-Travel Service, Level 3' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURS' , 'VS US PURCH STD' , 3 , 2.95 , 0.1 , null , 
    '111' , 'Purchasing Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURS' , 'VS US PURCH STD' , 3 , null, null, null , 
    '111' , 'Purchasing Card-Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURTVLS' , 'US PURCH TRAVEL SVC' , 3 , 2.55 , 0.1 , null , 
    '226' , 'Purchasing Card-Travel Service' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UPURTVLS' , 'US PURCH TRAVEL SVC' , 3 , null, null, null , 
    '226' , 'Purchasing Card-Travel Service' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTCR' , 'VS CPS RESTRNT CR' , 1 , 1.54 , 0.1 , null , 
    '217' , 'CPS/Restaurant Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTCR' , 'VS CPS RESTRNT CR' , 1 , null, null, null , 
    '217' , 'CPS/Restaurant Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTDB' , 'VS CPS RESTRNT DB' , 1 , 1.19 , 0.1 , null , 
    '215' , 'CPS/Restaurant Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTDB' , 'VS CPS RESTRNT DB' , 1 , null, null, null , 
    '215' , 'CPS/Restaurant Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTPP' , 'CPS RESTAURANT PREPAID' , 1 , 1.15 , 0.15 , null , 
    '334' , 'CPS/Restaurant Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URESTRNTPP' , 'CPS RESTAURANT PREPAID' , 1 , null, null, null , 
    '334' , 'CPS/Restaurant Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLCRDB' , 'CPS RTL CR DB' , 1 , 0.95 , 0.2 , null , 
    '211' , 'CPS/Retail Credit Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLCRDB' , 'CPS RTL CR DB' , 1 , null, null, null , 
    '211' , 'CPS/Retail Credit Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDB' , 'VS CPS RETAIL DB' , 1 , 0.8 , 0.15 , null , 
    '210' , 'CPS/Retail Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDB' , 'VS CPS RETAIL DB' , 1 , null, null, null , 
    '210' , 'CPS/Retail Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT1' , 'VS CPS RETAIL T1 DB' , 1 , 0.62 , 0.13 , null , 
    'RDT' , 'CPS/Retail Debit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT1' , 'VS CPS RETAIL T1 DB' , 1 , null, null, null , 
    'RDT' , 'CPS/Retail Debit Thresh I' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT2' , 'VS CPS RETAIL T2 DB' , 1 , 0.81 , 0.13 , null , 
    'RDT' , 'CPS/Retail Debit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT2' , 'VS CPS RETAIL T2 DB' , 1 , null, null, null , 
    'RDT' , 'CPS/Retail Debit Thresh II' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT3' , 'VS CPS RETAIL T3 DB' , 1 , 0.92 , 0.15 , null , 
    'RDT' , 'CPS/Retail Debit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBT3' , 'VS CPS RETAIL T3 DB' , 1 , null, null, null , 
    'RDT' , 'CPS/Retail Debit Thresh III' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX1' , 'VISA CPS/ DEBIT TAX PAYMENT1' , 1 , 0.65 , 0.15 ,  2.0 , 
    'TX1' , 'CPS/Debit Tax Payment I' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX1' , 'VISA CPS/ DEBIT TAX PAYMENT1' , 1 , null, null, null , 
    'TX1' , 'CPS/Debit Tax Payment I' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX1CAP' , 'VS CPS RTL DB TX1 CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    'TX1' , 'CPS/Debit Tax Payment I CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX1CAP' , 'VS CPS RTL DB TX1 CAP' , 1 , null, null, null , 
    'TX1' , 'CPS/Debit Tax Payment I CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX2' , 'VISA CPS/ DEBIT TAX PAYMENT2' , 1 , 0.65 , 0.15 ,  2.0 , 
    'TX2' , 'CPS/Debit Tax Payment II' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX2' , 'VISA CPS/ DEBIT TAX PAYMENT2' , 1 , null, null, null , 
    'TX2' , 'CPS/Debit Tax Payment II' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX2CAP' , 'VS CPS RTL DB TX2 CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    'TX2' , 'CPS/Debit Tax Payment II CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDBTX2CAP' , 'VS CPS RTL DB TX2 CAP' , 1 , null, null, null , 
    'TX2' , 'CPS/Debit Tax Payment II CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDPT' , 'CPS/DEBT REPAYMENT' , 1 , 0.65 , 0.15 ,  2.0 , 
    'DPT' , 'CPS/Debt Repayment' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDPT' , 'CPS/DEBT REPAYMENT' , 1 , null, null, null , 
    'DPT' , 'CPS/Debt Repayment' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDPTCAP' , 'VS CPS RTL DB REPMT CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    'DPT' , 'CPS/Debt Repayment CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104URTLDPTCAP' , 'VS CPS RTL DB REPMT CAP' , 1 , null, null, null , 
    'DPT' , 'CPS/Debt Repayment CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMCNPPP' , 'US COM CNP PP' , 3 , 2.65 , 0.1 , null , 
    '364' , 'Commercial Card Not Present - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMCNPPP' , 'US COM CNP PP' , 3 , null, null, null , 
    '364' , 'Commercial Card Not Present - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMLT' , 'VS COMM LT' , 3 , 1.45 , 35.0 , null , 
    '156' , 'Commercial Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMLT' , 'VS COMM LT' , 3 , null, null, null , 
    '156' , 'Commercial Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMLT' , 'VS COMM LT' , 3 , 1.45 , 35.0 , null , 
    '156' , 'Purchasing Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMLT' , 'VS COMM LT' , 3 , null, null, null , 
    '156' , 'Purchasing Large Ticket' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMRTLPP' , 'US COM RTL PP' , 3 , 2.15 , 0.1 , null , 
    '363' , 'Commercial Retail - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMRTLPP' , 'US COM RTL PP' , 3 , null, null, null , 
    '363' , 'Commercial Retail - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMSTDPP' , 'US COM STD PP' , 3 , 2.95 , 0.1 , null , 
    '365' , 'Commercial Standard - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCOMSTDPP' , 'US COM STD PP' , 3 , null, null, null , 
    '365' , 'Commercial Standard - Prepaid' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPB2B' , 'CORP CARD B2B' , 2 , 2.55 , 0.1 , null , 
    '233' , 'Corporate Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPB2B' , 'CORP CARD B2B' , 2 , null, null, null , 
    '233' , 'Corporate Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPCNP' , 'CORP CARD CNP' , 3 , 2.65 , 0.1 , null , 
    '234' , 'Corporate Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPCNP' , 'CORP CARD CNP' , 3 , null, null, null , 
    '234' , 'Corporate Card - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPCP' , 'US CORP CP' , 3 , 2.5 , 0.1 , null , 
    '235' , 'Corporate Card - Card Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPCP' , 'US CORP CP' , 3 , null, null, null , 
    '235' , 'Corporate Card - Card Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPRTL' , 'CORP CARD RTL' , 3 , 2.5 , 0.1 , null , 
    '235' , 'Corporate Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCORPRTL' , 'CORP CARD RTL' , 3 , null, null, null , 
    '235' , 'Corporate Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCPSREG' , 'US CPS REG DEBIT' , 1 , 0.05 , 0.22 , null , 
    '338' , 'CPS/Retail Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USCPSREG' , 'US CPS REG DEBIT' , 1 , null, null, null , 
    '338' , 'CPS/Retail Regulated' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWB2B' , 'US HNW B2B' , 2 , 2.1 , 0.1 , null , 
    '374' , 'Visa Infinite - B2B' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWB2B' , 'US HNW B2B' , 2 , null, null, null , 
    '374' , 'Visa Infinite - B2B' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWCNP' , 'US HNW CNP' , 3 , 2.4 , 0.1 , null , 
    '372' , 'Visa Infinite - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWCNP' , 'US HNW CNP' , 3 , null, null, null , 
    '372' , 'Visa Infinite - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWELEC' , 'US HNW ELEC' , 3 , 2.4 , 0.1 , null , 
    '370' , 'Visa Infinite Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWELEC' , 'US HNW ELEC' , 3 , null, null, null , 
    '370' , 'Visa Infinite Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWFUEL' , 'US HNW FUEL' , 1 , 1.15 , 0.25 ,  1.1 , 
    '375' , 'Visa Infinite - Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWFUEL' , 'US HNW FUEL' , 1 , null, null, null , 
    '375' , 'Visa Infinite - Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWFUELCAP' , 'US HNW FUEL CAP' , 1 , 1.15 , 0.25 ,  1.1 , 
    '375' , 'Visa Infinite - Fuel CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWFUELCAP' , 'US HNW FUEL CAP' , 1 , null, null, null , 
    '375' , 'Visa Infinite - Fuel CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWRTL' , 'US HNW Retail' , 2 , 2.1 , 0.1 , null , 
    '373' , 'Visa Infinite - Retail' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWRTL' , 'US HNW Retail' , 2 , null, null, null , 
    '373' , 'Visa Infinite - Retail' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWSTD' , 'US HNW STD' , 3 , 2.95 , 0.1 ,  1.1 , 
    '371' , 'Visa Infinite - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWSTD' , 'US HNW STD' , 3 , null, null, null , 
    '371' , 'Visa Infinite - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWSTDCAP' , 'US HNW STD CAP' , 3 , 2.95 , 0.1 ,  1.1 , 
    '371' , 'Visa Infinite - Standard CAP' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USHNWSTDCAP' , 'US HNW STD CAP' , 3 , null, null, null , 
    '371' , 'Visa Infinite - Standard CAP' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USIGINAIR' , 'VS SIG INTR AIR' , 2 , 1.8 , 0.0 , null , 
    '178' , 'U.S. Infinite Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USIGINAIR' , 'VS SIG INTR AIR' , 2 , null, null, null , 
    '178' , 'U.S. Infinite Card Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMKTPP' , 'CPS SUPERMARKET PREPAID' , 1 , 1.15 , 0.15 ,  0.35 , 
    '313' , 'CPS/Supermarket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMKTPP' , 'CPS SUPERMARKET PREPAID' , 1 , null, null, null , 
    '313' , 'CPS/Supermarket Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMKTPPCAP' , 'CPS SUPERMARKET PREPAID CAP' , 1 , 1.15 , 0.15 ,  0.35 , 
    '313' , 'CPS/Supermarket Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMKTPPCAP' , 'CPS SUPERMARKET PREPAID CAP' , 1 , null, null, null , 
    '313' , 'CPS/Supermarket Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMLTCKT' , 'VS SMALL TCKT CR' , 1 , 1.65 , 0.04 , null , 
    '179' , 'CPS/Small-Ticket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMLTCKT' , 'VS SMALL TCKT CR' , 1 , null, null, null , 
    '179' , 'CPS/Small-Ticket Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMLTCKTDB' , 'VS SMALL TCKT DB' , 1 , 1.55 , 0.04 , null , 
    '214' , 'CPS/Small-Ticket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USMLTCKTDB' , 'VS SMALL TCKT DB' , 1 , null, null, null , 
    '214' , 'CPS/Small-Ticket Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHB2B' , 'PURCH B2B' , 2 , 2.55 , 0.1 , null , 
    '236' , 'Purchasing Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHB2B' , 'PURCH B2B' , 2 , null, null, null , 
    '236' , 'Purchasing Card - Business-to-Business' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCNP' , 'PURCH CNP' , 3 , 2.65 , 0.1 , null , 
    '237' , 'Purchasing Card - Card not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCNP' , 'PURCH CNP' , 3 , null, null, null , 
    '237' , 'Purchasing Card - Card not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCP' , 'PURCH RTL' , 3 , 2.5 , 0.1 , null , 
    '238' , 'Purchasing Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCP' , 'PURCH RTL' , 3 , null, null, null , 
    '238' , 'Purchasing Card - Retail' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCP' , 'US PURCH CP' , 3 , 2.5 , 0.1 , null , 
    '238' , 'Purchasing Card - Card Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHCP' , 'US PURCH CP' , 3 , null, null, null , 
    '238' , 'Purchasing Card - Card Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHFLT' , 'US Purchase Fleet' , 3 , 2.5 , 0.1 , null , 
    '262' , 'Purchasing Card - Fleet' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURCHFLT' , 'US Purchase Fleet' , 3 , null, null, null , 
    '262' , 'Purchasing Card - Fleet' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURELWD' , 'PURCHASING ELEC W DATA' , 3 , 2.95 , 0.1 , null , 
    '239' , 'Purchasing Card - Electronic with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURELWD' , 'PURCHASING ELEC W DATA' , 3 , null, null, null , 
    '239' , 'Purchasing Card - Electronic with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURSTDWD' , 'US PUR Std with DATA' , 3 , 2.95 , 0.1 , null , 
    '239' , 'Purchasing Card - Standard with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USPURSTDWD' , 'US PUR Std with DATA' , 3 , null, null, null , 
    '239' , 'Purchasing Card - Standard with Data' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSIGNATAIR' , 'VS US SIG INTR AIR' , 2 , 1.8 , 0.0 , null , 
    '227' , 'U.S. Signature Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSIGNATAIR' , 'VS US SIG INTR AIR' , 2 , null, null, null , 
    '227' , 'U.S. Signature Interregional Airline' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP1' , 'US STP Tier1' , 2 , 2.0 , 0.1 , null , 
    '392' , 'U.S. Straight Through Processing Tier 1' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP1' , 'US STP Tier1' , 2 , null, null, null , 
    '392' , 'U.S. Straight Through Processing Tier 1' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP2' , 'US STP Tier2' , 3 , 1.3 , 35.0 , null , 
    '393' , 'U.S. Straight Through Processing Tier 2' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP2' , 'US STP Tier2' , 3 , null, null, null , 
    '393' , 'U.S. Straight Through Processing Tier 2' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP3' , 'US STP Tier3' , 3 , 1.1 , 35.0 , null , 
    '394' , 'U.S. Straight Through Processing Tier 3' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP3' , 'US STP Tier3' , 3 , null, null, null , 
    '394' , 'U.S. Straight Through Processing Tier 3' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP4' , 'US STP Tier4' , 3 , 0.95 , 35.0 , null , 
    '395' , 'U.S. Straight Through Processing Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP4' , 'US STP Tier4' , 3 , null, null, null , 
    '395' , 'U.S. Straight Through Processing Tier 4' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP5' , 'US STP Tier5' , 3 , 0.8 , 35.0 , null , 
    '396' , 'U.S. Straight Through Processing Tier 5' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USSTP5' , 'US STP Tier5' , 3 , null, null, null , 
    '396' , 'U.S. Straight Through Processing Tier 5' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , 1.1 , 0.0 , null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHIPFULL' , 'Air Chip-Full Data' , 1 , null, null, null , 
    '940' , 'Air Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHIPTERMNL' , 'Acq Chip' , 1 , 1.0 , 0.0 , null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHIPTERMNL' , 'Acq Chip' , 1 , null, null, null , 
    '916' , 'Airline Acquire Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAIRCHPFULLPIN' , 'Air Chip-Full Data w Pin' , 1 , null, null, null , 
    '944' , 'Air Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAUTHENTICTDSEC' , 'Sec Ele Comm' , 1 , 1.44 , 0.0 , null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTAUTHENTICTDSEC' , 'Sec Ele Comm' , 1 , null, null, null , 
    '919' , 'Secure Electronic Commerce Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPFULL' , 'Chip-Full Data' , 1 , 1.1 , 0.0 , null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPFULL' , 'Chip-Full Data' , 1 , null, null, null , 
    '938' , 'Chip Full' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , 1.1 , 0.0 , null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPFULLPIN' , 'Chip-Full Data w Pin' , 1 , null, null, null , 
    '942' , 'Chip Full PIN' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPISS' , 'Iss Chip' , 1 , 1.2 , 0.0 , null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPISS' , 'Iss Chip' , 1 , null, null, null , 
    '917' , 'Issuer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPTERMNL' , 'Acq Chip-Air' , 1 , 1.0 , 0.0 , null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCHIPTERMNL' , 'Acq Chip-Air' , 1 , null, null, null , 
    '915' , 'Acquirer Chip Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLBUS' , 'Business' , 2 , 2.0 , 0.0 , null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLBUS' , 'Business' , 2 , null, null, null , 
    '905' , 'Business Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLCORP' , 'Corporate' , 2 , 2.0 , 0.0 , null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLCORP' , 'Corporate' , 2 , null, null, null , 
    '906' , 'Corporate Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLPURCH' , 'Purchasing' , 2 , 2.0 , 0.0 , null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTCOMCLPURCH' , 'Purchasing' , 2 , null, null, null , 
    '907' , 'Purchasing Card' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTD' , 'VS US STANDARD' , 3 , 2.7 , 0.1 , null , 
    '101' , 'Standard Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTD' , 'VS US STANDARD' , 3 , null, null, null , 
    '101' , 'Standard Credit' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTDDB' , 'VS US STANDARD DB' , 2 , 1.9 , 0.25 , null , 
    '196' , 'Standard Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTDDB' , 'VS US STANDARD DB' , 2 , null, null, null , 
    '196' , 'Standard Debit' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTDPP' , 'STANDARD PREPAID' , 2 , 1.9 , 0.25 , null , 
    '317' , 'Standard Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTDPP' , 'STANDARD PREPAID' , 2 , null, null, null , 
    '317' , 'Standard Prepaid' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTERREGDB' , 'INTER-REG REGULATED DB' , 1 , 0.05 , 0.22 , null , 
    '603' , 'Interregional Regulated Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTERREGDB' , 'INTER-REG REGULATED DB' , 1 , null, null, null , 
    '603' , 'Interregional Regulated Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTINTLPREPS2000' , 'PS2000' , 1 , 1.1 , 0.0 , null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTINTLPREPS2000' , 'PS2000' , 1 , null, null, null , 
    '903' , 'Electronic' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTINTRAIRLINE' , 'Airline' , 1 , 1.1 , 0.0 , null , 
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTINTRAIRLINE' , 'Airline' , 1 , null, null, null , 
    '920' , 'Airline Fee' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTNONAUTHNDMRCH' , 'NDMRCH' , 1 , 1.44 , 0.0 , null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTNONAUTHNDMRCH' , 'NDMRCH' , 1 , null, null, null , 
    '918' , 'Electronic Commerce Merchant Rate' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTSIGCARD' , 'Signature' , 2 , 1.8 , 0.0 , null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTSIGCARD' , 'Signature' , 2 , null, null, null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTSTANDARD' , 'Cons Std' , 1 , 1.6 , 0.0 , null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTSTANDARD' , 'Cons Std' , 1 , null, null, null , 
    '901' , 'Standard' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTUSVSPINTR' , 'Infinite' , 2 , 1.97 , 0.0 , null , 
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTUSVSPINTR' , 'Infinite' , 2 , null, null, null , 
    '946' , 'Visa Signature Preferred - Interregional' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHIPFULL' , 'Air Chip-Full Data-VE' , 1 , null, null, null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHIPTERMNL' , 'Acq Chip-VE' , 1 , 1.0 , 0.0 , null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHIPTERMNL' , 'Acq Chip-VE' , 1 , null, null, null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHPFLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAIRCHPFLPIN' , 'Air Chip-Full Data w Pin-VE' , 1 , null, null, null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAUTHENTICSEC' , 'Sec Ele Comm-VE' , 1 , 1.44 , 0.0 , null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEAUTHENTICSEC' , 'Sec Ele Comm-VE' , 1 , null, null, null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPFULL' , 'Chip-Full Data-VE' , 1 , 1.1 , 0.0 , null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPFULL' , 'Chip-Full Data-VE' , 1 , null, null, null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , 1.1 , 0.0 , null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPFULLPIN' , 'Chip-Full Data w Pin-VE' , 1 , null, null, null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPISS' , 'Iss Chip-VE' , 1 , 1.2 , 0.0 , null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPISS' , 'Iss Chip-VE' , 1 , null, null, null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPTERMNL' , 'Acq Chip Air-VE' , 1 , 1.0 , 0.0 , null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVECHIPTERMNL' , 'Acq Chip Air-VE' , 1 , null, null, null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEINTPREPS2000' , 'Electronic-VE' , 1 , 1.1 , 0.0 , null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEINTPREPS2000' , 'Electronic-VE' , 1 , null, null, null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEINTRAIRLINE' , 'Airline-VE' , 1 , 1.1 , 0.0 , null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVEINTRAIRLINE' , 'Airline-VE' , 1 , null, null, null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVENONAUTHNMER' , 'Ele Comm Merch-VE' , 1 , 1.44 , 0.0 , null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVENONAUTHNMER' , 'Ele Comm Merch-VE' , 1 , null, null, null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVESTANDARD' , 'Cons Std-VE' , 1 , 1.6 , 0.0 , null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USTVESTANDARD' , 'Cons Std-VE' , 1 , null, null, null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNCR' , 'VS CPS SERV STN CR' , 1 , 1.15 , 0.25 ,  1.1 , 
    '218' , 'CPS/Retail Service Station Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNCR' , 'VS CPS SERV STN CR' , 1 , null, null, null , 
    '218' , 'CPS/Retail Service Station Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNCRCAP' , 'VS CPS SERV STN CR CAP' , 1 , 1.15 , 0.25 ,  1.1 , 
    '218' , 'CPS/Retail Service Station Credit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNCRCAP' , 'VS CPS SERV STN CR CAP' , 1 , null, null, null , 
    '218' , 'CPS/Retail Service Station Credit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNDB' , 'VS CPS SERV STN DB' , 1 , 0.8 , 0.15 ,  0.95 , 
    '216' , 'CPS/Retail Service Station Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNDB' , 'VS CPS SERV STN DB' , 1 , null, null, null , 
    '216' , 'CPS/Retail Service Station Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNDBCAP' , 'VS CPS SERV STN DB CAP' , 1 , 0.8 , 0.15 ,  0.95 , 
    '216' , 'CPS/Retail Service Station Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNDBCAP' , 'VS CPS SERV STN DB CAP' , 1 , null, null, null , 
    '216' , 'CPS/Retail Service Station Debit CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNPP' , 'CPS RET SER STAT PREPAID' , 1 , 1.15 , 0.15 ,  0.95 , 
    '332' , 'CPS/Retail Service Station Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNPP' , 'CPS RET SER STAT PREPAID' , 1 , null, null, null , 
    '332' , 'CPS/Retail Service Station Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNPPCAP' , 'CPS_Ret Ser Stat Prepaid CAP' , 1 , 1.15 , 0.15 ,  0.95 , 
    '332' , 'CPS/Retail Service Station Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVCSTNPPCAP' , 'CPS_Ret Ser Stat Prepaid CAP' , 1 , null, null, null , 
    '332' , 'CPS/Retail Service Station Prepaid CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPB2B' , 'US VSP B2B' , 2 , 2.1 , 0.1 , null , 
    '244' , 'Visa Signature Card Preferred - B2B' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPB2B' , 'US VSP B2B' , 2 , null, null, null , 
    '244' , 'Visa Signature Card Preferred - B2B' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPCNP' , 'US VSP CNP' , 3 , 2.4 , 0.1 , null , 
    '242' , 'Visa Signature Card Preferred - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPCNP' , 'US VSP CNP' , 3 , null, null, null , 
    '242' , 'Visa Signature Card Preferred - Card Not Present' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPELEC' , 'US VSP ELEC' , 3 , 2.4 , 0.1 , null , 
    '241' , 'Visa Signature Card Preferred - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPELEC' , 'US VSP ELEC' , 3 , null, null, null , 
    '241' , 'Visa Signature Card Preferred - Electronic' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPFUEL' , 'US VSP FUEL' , 1 , 1.15 , 0.25 ,  1.1 , 
    '249' , 'US VSP - Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPFUEL' , 'US VSP FUEL' , 1 , null, null, null , 
    '249' , 'US VSP - Fuel' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPFUELCAP' , 'US VSP FUEL CAP' , 1 , 1.15 , 0.25 ,  1.1 , 
    '249' , 'US VSP - Fuel CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPFUELCAP' , 'US VSP FUEL CAP' , 1 , null, null, null , 
    '249' , 'US VSP - Fuel CAP' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPRTL' , 'US VSP RTL' , 2 , 2.1 , 0.1 , null , 
    '243' , 'Visa Signature Card Preferred - Retail' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPRTL' , 'US VSP RTL' , 2 , null, null, null , 
    '243' , 'Visa Signature Card Preferred - Retail' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPSTD' , 'VSP STD' , 3 , 2.95 , 0.1 ,  1.1 , 
    '240' , 'Visa Signature Card Preferred - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPSTD' , 'VSP STD' , 3 , null, null, null , 
    '240' , 'Visa Signature Card Preferred - Standard' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPSTDCAP' , 'US VSP STD CAP' , 3 , 2.95 , 0.1 ,  1.1 , 
    '240' , 'Visa Signature Card Preferred - Standard CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104USVSPSTDCAP' , 'US VSP STD CAP' , 3 , null, null, null , 
    '240' , 'Visa Signature Card Preferred - Standard CAP [MCCs 5541, 5542]' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUBC' , 'CPS/UTILITY BUS' , 1 , 0.0 , 1.5 , null , 
    'UBC' , 'CPS/Utility Business' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUBC' , 'CPS/UTILITY BUS' , 1 , null, null, null , 
    'UBC' , 'CPS/Utility Business' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUBD' , 'CPS Utility Business D/P' , 1 , 0.0 , 1.5 , null , 
    'UBD' , 'Visa Utility Business Debit and Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUBD' , 'CPS Utility Business D/P' , 1 , null, null, null , 
    'UBD' , 'Visa Utility Business Debit and Prepaid' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUTILCR' , 'VS US UTILITY  CR' , 1 , 0.0 , 0.75 , null , 
    'UTC' , 'Utility Program Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUTILCR' , 'VS US UTILITY  CR' , 1 , null, null, null , 
    'UTC' , 'Utility Program Credit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUTILDB' , 'VS US UTILITY  DB' , 1 , 0.0 , 0.65 , null , 
    'UTD' , 'Utility Program Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104UUTILDB' , 'VS US UTILITY  DB' , 1 , null, null, null , 
    'UTD' , 'Utility Program Debit' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCFLPIN' , 'VE AIR CHIP FULL PIN' , 1 , 1.1 , 0.0 , null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCFLPIN' , 'VE AIR CHIP FULL PIN' , 1 , null, null, null , 
    '945' , 'Air Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCFULL' , 'VE AIR CHIP FULL' , 1 , 1.1 , 0.0 , null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCFULL' , 'VE AIR CHIP FULL' , 1 , null, null, null , 
    '941' , 'Air Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCHIP' , 'VE AIR CHIP TERM' , 1 , 1.0 , 0.0 , null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAIRCHIP' , 'VE AIR CHIP TERM' , 1 , null, null, null , 
    '935' , 'Airline Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAUTHNSEC' , 'VE AUTHENTIC SEC' , 1 , 1.44 , 0.0 , null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEAUTHNSEC' , 'VE AUTHENTIC SEC' , 1 , null, null, null , 
    '933' , 'Secure Electronic Commerce Rate - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECFLPIN' , 'VE CHIP FULL PIN' , 1 , 1.1 , 0.0 , null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECFLPIN' , 'VE CHIP FULL PIN' , 1 , null, null, null , 
    '943' , 'Chip Full PIN - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECFULL' , 'VE CHIP FULL' , 1 , 1.1 , 0.0 , null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECFULL' , 'VE CHIP FULL' , 1 , null, null, null , 
    '939' , 'Chip Full - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECI' , 'VS VE CHIP ISS' , 1 , 1.2 , 0.0 , null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECI' , 'VS VE CHIP ISS' , 1 , null, null, null , 
    '922' , 'Issuer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECT' , 'VS VE CHIP TERMNL' , 1 , 1.0 , 0.0 , null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VECT' , 'VS VE CHIP TERMNL' , 1 , null, null, null , 
    '921' , 'Acquirer Chip Fee - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEEIRF' , 'CEM 0104VEEIRF' , 3 , 30.0 , 0.0 , null , 
    '956' , 'Private Label - Premium' , '04' , 'VISA_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEEIRF' , 'CEM 0104VEEIRF' , 3 , null, null, null , 
    '956' , 'Private Label - Premium' , '04' , 'VISA_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEINTAIR' , 'VE INT AIRLINE' , 1 , 1.1 , 0.0 , null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEINTAIR' , 'VE INT AIRLINE' , 1 , null, null, null , 
    '934' , 'Airline Fee-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEINTPS2000' , 'VE INT PREPS2000' , 1 , 1.1 , 0.0 , null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VEINTPS2000' , 'VE INT PREPS2000' , 1 , null, null, null , 
    '931' , 'Electronic - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VENONAUTHNM' , 'VE NONAUTH MER' , 1 , 1.44 , 0.0 , null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VENONAUTHNM' , 'VE NONAUTH MER' , 1 , null, null, null , 
    '932' , 'Electronic Commerce Merchant Rate-Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VESTD' , 'VE STANDARD' , 1 , 1.6 , 0.0 , null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VESTD' , 'VE STANDARD' , 1 , null, null, null , 
    '936' , 'Standard - Visa Electron' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VISGNATURE' , 'VS SIGNATURE CARD' , 2 , 1.8 , 0.0 , null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0104VISGNATURE' , 'VS SIGNATURE CARD' , 2 , null, null, null , 
    '937' , 'Visa Signature' , '04' , 'VISA_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UDMTRFR' , 'VS MONEY TRANSFER' , 1 , 0.0 , 0.1 , null , 
    'VMT' , 'Visa Money Transfer' , '04' , 'VISA_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UDMTRFR' , 'VS MONEY TRANSFER' , 1 , null, null, null , 
    'VMT' , 'Visa Money Transfer' , '04' , 'VISA_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );

rem MasterCard


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR1' , 'BUSINESS L2 DATA RATE I' , 3 , 2.81 , 0.1 , null , 
    'SA' , 'Commercial Data Rate I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR1' , 'BUSINESS L2 DATA RATE I' , 3 , null, null, null , 
    'SA' , 'Commercial Data Rate I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR2' , 'BUSINESS L2 DATA RATE II' , 3 , 2.16 , 0.1 , null , 
    'SB' , 'Commercial Data Rate II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR2' , 'BUSINESS L2 DATA RATE II' , 3 , null, null, null , 
    'SB' , 'Commercial Data Rate II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR3' , 'BUSINESS L2 DATA RATE III' , 2 , 1.91 , 0.1 , null , 
    'SC' , 'Commercial Data Rate III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2DR3' , 'BUSINESS L2 DATA RATE III' , 2 , null, null, null , 
    'SC' , 'Commercial Data Rate III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2F2F' , 'BUSINESS L2 FACE-TO-FACE' , 3 , 2.16 , 0.1 , null , 
    'SD' , 'Commercial Face-to-face Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2F2F' , 'BUSINESS L2 FACE-TO-FACE' , 3 , null, null, null , 
    'SD' , 'Commercial Face-to-face Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT1' , 'BUSINESS L2 LARGE TICKET I' , 3 , 1.36 , 40.0 , null , 
    'SE' , 'Commercial Large Ticket I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT1' , 'BUSINESS L2 LARGE TICKET I' , 3 , null, null, null , 
    'SE' , 'Commercial Large Ticket I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT2' , 'BUSINESS L2 LARGE TICKET II' , 3 , 1.36 , 40.0 , null , 
    'SF' , 'Commercial Large Ticket II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT2' , 'BUSINESS L2 LARGE TICKET II' , 3 , null, null, null , 
    'SF' , 'Commercial Large Ticket II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT3' , 'BUSINESS L2 LARGE TICKET III' , 3 , 1.36 , 40.0 , null , 
    'SG' , 'Commercial Large Ticket III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2LT3' , 'BUSINESS L2 LARGE TICKET III' , 3 , null, null, null , 
    'SG' , 'Commercial Large Ticket III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2STD' , 'BUSINESS L2 STANDARD' , 3 , 3.11 , 0.1 , null , 
    'SK' , 'Commercial Standard Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2STD' , 'BUSINESS L2 STANDARD' , 3 , null, null, null , 
    'SK' , 'Commercial Standard Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2SUPMKT' , 'BUSINESS L2 SUPERMARKET' , 3 , 2.16 , 0.1 , null , 
    'SM' , 'Commercial Supermarket Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2SUPMKT' , 'BUSINESS L2 SUPERMARKET' , 3 , null, null, null , 
    'SM' , 'Commercial Supermarket Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE1' , 'BUSINESS L2 T AND E RATE I' , 3 , 2.66 , 0.0 , null , 
    'SL' , 'Commercial T/E Rate I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE1' , 'BUSINESS L2 T AND E RATE I' , 3 , null, null, null , 
    'SL' , 'Commercial T/E Rate I Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE2' , 'BUSINESS L2 T AND E RATE II' , 3 , 2.51 , 0.1 , null , 
    'SN' , 'Commercial T/E Rate II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE2' , 'BUSINESS L2 T AND E RATE II' , 3 , null, null, null , 
    'SN' , 'Commercial T/E Rate II Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE3' , 'BUSINESS L2 T AND E RATE III' , 3 , 2.46 , 0.1 , null , 
    'SO' , 'Commercial T/E Rate III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2TE3' , 'BUSINESS L2 T AND E RATE III' , 3 , null, null, null , 
    'SO' , 'Commercial T/E Rate III Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2UTI' , 'BUSINESS L2 UTILITIES' , 1 , 0.0 , 1.5 , null , 
    'SR' , 'Commercial Utilities Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2UTI' , 'BUSINESS L2 UTILITIES' , 1 , null, null, null , 
    'SR' , 'Commercial Utilities Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2WB' , 'BUSINESS L2 WAREHOUSE BASE' , 1 , 1.48 , 0.1 , null , 
    'SP' , 'Commercial Warehouse Base Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2WB' , 'BUSINESS L2 WAREHOUSE BASE' , 1 , null, null, null , 
    'SP' , 'Commercial Warehouse Base Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2WT1' , 'BUSINESS L2 WAREHOUSE TIER I' , 1 , 1.48 , 0.1 , null , 
    'SQ' , 'Commercial Warehouse Tier 1 Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL2WT1' , 'BUSINESS L2 WAREHOUSE TIER I' , 1 , null, null, null , 
    'SQ' , 'Commercial Warehouse Tier 1 Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR1' , 'BUSINESS L3 DATA RATE I' , 3 , 2.86 , 0.1 , null , 
    '3A' , 'Commercial Data Rate I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR1' , 'BUSINESS L3 DATA RATE I' , 3 , null, null, null , 
    '3A' , 'Commercial Data Rate I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR2' , 'BUSINESS L3 DATA RATE II' , 3 , 2.21 , 0.1 , null , 
    '3B' , 'Commercial Data Rate II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR2' , 'BUSINESS L3 DATA RATE II' , 3 , null, null, null , 
    '3B' , 'Commercial Data Rate II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR3' , 'BUSINESS L3 DATA RATE III' , 2 , 1.96 , 0.1 , null , 
    '3C' , 'Commercial Data Rate III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3DR3' , 'BUSINESS L3 DATA RATE III' , 2 , null, null, null , 
    '3C' , 'Commercial Data Rate III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3F2F' , 'BUSINESS L3 FACE-TO-FACE' , 3 , 2.21 , 0.1 , null , 
    '3D' , 'Commercial Face-to-face Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3F2F' , 'BUSINESS L3 FACE-TO-FACE' , 3 , null, null, null , 
    '3D' , 'Commercial Face-to-face Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT1' , 'BUSINESS L3 LARGE TICKET I' , 1 , 1.41 , 40.0 , null , 
    '3E' , 'Commercial Large Ticket I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT1' , 'BUSINESS L3 LARGE TICKET I' , 1 , null, null, null , 
    '3E' , 'Commercial Large Ticket I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT2' , 'BUSINESS L3 LARGE TICKET II' , 1 , 1.41 , 40.0 , null , 
    '3F' , 'Commercial Large Ticket II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT2' , 'BUSINESS L3 LARGE TICKET II' , 1 , null, null, null , 
    '3F' , 'Commercial Large Ticket II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT3' , 'BUSINESS L3 LARGE TICKET III' , 1 , 1.41 , 40.0 , null , 
    '3G' , 'Commercial Large Ticket III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3LT3' , 'BUSINESS L3 LARGE TICKET III' , 1 , null, null, null , 
    '3G' , 'Commercial Large Ticket III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3STD' , 'BUSINESS L3 STANDARD' , 3 , 3.16 , 0.1 , null , 
    '3K' , 'Commercial Standard Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3STD' , 'BUSINESS L3 STANDARD' , 3 , null, null, null , 
    '3K' , 'Commercial Standard Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3SUPMKT' , 'BUSINESS L3 SUPERMARKET' , 3 , 2.21 , 0.1 , null , 
    '3M' , 'Commercial Supermarket Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3SUPMKT' , 'BUSINESS L3 SUPERMARKET' , 3 , null, null, null , 
    '3M' , 'Commercial Supermarket Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE1' , 'BUSINESS L3 T AND E RATE I' , 3 , 2.71 , 0.0 , null , 
    '3L' , 'Commercial T/E Rate I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE1' , 'BUSINESS L3 T AND E RATE I' , 3 , null, null, null , 
    '3L' , 'Commercial T/E Rate I Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE2' , 'BUSINESS L3 T AND E RATE II' , 3 , 2.56 , 0.1 , null , 
    '3N' , 'Commercial T/E Rate II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE2' , 'BUSINESS L3 T AND E RATE II' , 3 , null, null, null , 
    '3N' , 'Commercial T/E Rate II Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE3' , 'BUSINESS L3 T AND E RATE III' , 3 , 2.51 , 0.1 , null , 
    '3O' , 'Commercial T/E Rate III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3TE3' , 'BUSINESS L3 T AND E RATE III' , 3 , null, null, null , 
    '3O' , 'Commercial T/E Rate III Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3UTI' , 'BUSINESS L3 UTILITIES' , 1 , 0.0 , 1.5 , null , 
    '3R' , 'Commercial Utilities Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3UTI' , 'BUSINESS L3 UTILITIES' , 1 , null, null, null , 
    '3R' , 'Commercial Utilities Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3WB' , 'BUSINESS L3 WAREHOUSE BASE' , 1 , 1.48 , 0.1 , null , 
    '3P' , 'Commercial Warehouse Base Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3WB' , 'BUSINESS L3 WAREHOUSE BASE' , 1 , null, null, null , 
    '3P' , 'Commercial Warehouse Base Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3WT1' , 'BUSINESS L3 WAREHOUSE TIER I' , 1 , 1.48 , 0.1 , null , 
    '3Q' , 'Commercial Warehouse Tier 1 Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL3WT1' , 'BUSINESS L3 WAREHOUSE TIER I' , 1 , null, null, null , 
    '3Q' , 'Commercial Warehouse Tier 1 Level 3 - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR1' , 'BUSINESS L4 DATA RATE I' , 3 , 2.96 , 0.1 , null , 
    '4A' , 'Commercial Data Rate I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR1' , 'BUSINESS L4 DATA RATE I' , 3 , null, null, null , 
    '4A' , 'Commercial Data Rate I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR2' , 'BUSINESS L4 DATA RATE II' , 3 , 2.31 , 0.1 , null , 
    '4B' , 'Commercial Data Rate II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR2' , 'BUSINESS L4 DATA RATE II' , 3 , null, null, null , 
    '4B' , 'Commercial Data Rate II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR3' , 'BUSINESS L4 DATA RATE III' , 2 , 2.06 , 0.1 , null , 
    '4C' , 'Commercial Data Rate III Level 4' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4DR3' , 'BUSINESS L4 DATA RATE III' , 2 , null, null, null , 
    '4C' , 'Commercial Data Rate III Level 4' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4F2F' , 'BUSINESS L4 FACE-TO-FACE' , 3 , 2.31 , 0.1 , null , 
    '4D' , 'Commercial Face-to-face Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4F2F' , 'BUSINESS L4 FACE-TO-FACE' , 3 , null, null, null , 
    '4D' , 'Commercial Face-to-face Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT1' , 'BUSINESS L4 LARGE TICKET I' , 3 , 1.51 , 40.0 , null , 
    '4E' , 'Commercial Large Ticket I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT1' , 'BUSINESS L4 LARGE TICKET I' , 3 , null, null, null , 
    '4E' , 'Commercial Large Ticket I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT2' , 'BUSINESS L4 LARGE TICKET II' , 3 , 1.51 , 40.0 , null , 
    '4F' , 'Commercial Large Ticket II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT2' , 'BUSINESS L4 LARGE TICKET II' , 3 , null, null, null , 
    '4F' , 'Commercial Large Ticket II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT3' , 'BUSINESS L4 LARGE TICKET III' , 3 , 1.51 , 40.0 , null , 
    '4G' , 'Commercial Large Ticket III Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4LT3' , 'BUSINESS L4 LARGE TICKET III' , 3 , null, null, null , 
    '4G' , 'Commercial Large Ticket III Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4STD' , 'BUSINESS L4 STANDARD' , 3 , 3.26 , 0.1 , null , 
    '4K' , 'Commercial Standard Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4STD' , 'BUSINESS L4 STANDARD' , 3 , null, null, null , 
    '4K' , 'Commercial Standard Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4SUPMKT' , 'BUSINESS L4 SUPERMARKET' , 3 , 2.31 , 0.1 , null , 
    '4M' , 'Commercial Supermarket Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4SUPMKT' , 'BUSINESS L4 SUPERMARKET' , 3 , null, null, null , 
    '4M' , 'Commercial Supermarket Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE1' , 'BUSINESS L4 T AND E RATE I' , 3 , 2.81 , 0.0 , null , 
    '4L' , 'Commercial T/E Rate I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE1' , 'BUSINESS L4 T AND E RATE I' , 3 , null, null, null , 
    '4L' , 'Commercial T/E Rate I Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE2' , 'BUSINESS L4 T AND E RATE II' , 3 , 2.66 , 0.1 , null , 
    '4N' , 'Commercial T/E Rate II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE2' , 'BUSINESS L4 T AND E RATE II' , 3 , null, null, null , 
    '4N' , 'Commercial T/E Rate II Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE3' , 'BUSINESS L4 T AND E RATE III' , 3 , 2.61 , 0.1 , null , 
    '4O' , 'Commercial T/E Rate III Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4TE3' , 'BUSINESS L4 T AND E RATE III' , 3 , null, null, null , 
    '4O' , 'Commercial T/E Rate III Level 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4UTI' , 'BUSINESS L4 UTILITIES' , 1 , 0.0 , 1.5 , null , 
    '4R' , 'Commercial Utilities Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4UTI' , 'BUSINESS L4 UTILITIES' , 1 , null, null, null , 
    '4R' , 'Commercial Utilities Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4WB' , 'BUSINESS L4 WAREHOUSE BASE' , 1 , 1.48 , 0.1 , null , 
    '4P' , 'Commercial Warehouse Base Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4WB' , 'BUSINESS L4 WAREHOUSE BASE' , 1 , null, null, null , 
    '4P' , 'Commercial Warehouse Base Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4WT1' , 'BUSINESS L4 WAREHOUSE TIER I' , 1 , 1.48 , 0.1 , null , 
    '4Q' , 'Commercial Warehouse Tier 1 Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BL4WT1' , 'BUSINESS L4 WAREHOUSE TIER I' , 1 , null, null, null , 
    '4Q' , 'Commercial Warehouse Tier 1 Level 4' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BUSENFBB' , 'MC MASCODE for IRD BB' , 1 , 1.57 , 0.0 , null , 
    'BB' , 'Commercial Business-to-Business' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105BUSENFBB' , 'MC MASCODE for IRD BB' , 1 , null, null, null , 
    'BB' , 'Commercial Business-to-Business' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DR1HEALTHCAP' , 'Data Rate 1 HealthCareMCC CAP' , 1 , 1.0 , 0.0 ,  5.0 , 
    '68' , 'Data Rate I - Health Care' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DR1HEALTHCAP' , 'Data Rate 1 HealthCareMCC CAP' , 1 , null, null, null , 
    '68' , 'Data Rate I - Health Care' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS1' , 'MC US DB CONS REFUND GR1' , 1 , 1.72 , 0.0 , null , 
    '31' , 'Consumer Debit/Prepaid Refund Group 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS1' , 'MC US DB CONS REFUND GR1' , 1 , null, null, null , 
    '31' , 'Consumer Debit/Prepaid Refund Group 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS2' , 'MC US DB CONS REFUND GR2' , 1 , 1.68 , 0.0 , null , 
    '32' , 'Consumer Debit/Prepaid Refund Group 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS2' , 'MC US DB CONS REFUND GR2' , 1 , null, null, null , 
    '32' , 'Consumer Debit/Prepaid Refund Group 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS3' , 'MC US DB CONS REFUND GR3' , 1 , 1.4 , 0.0 , null , 
    '33' , 'Consumer Debit/Prepaid Refund Group 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DREFCS3' , 'MC US DB CONS REFUND GR3' , 1 , null, null, null , 
    '33' , 'Consumer Debit/Prepaid Refund Group 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCATAFD' , 'MC US PETROL DB' , 1 , 0.7 , 0.17 ,  0.95 , 
    '27' , 'Consumer Debit/Prepaid Petroleum CAT/AFD' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCATAFD' , 'MC US PETROL DB' , 1 , null, null, null , 
    '27' , 'Consumer Debit/Prepaid Petroleum CAT/AFD' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCATFDC' , 'MC US PETROL DB' , 1 , 0.7 , 0.17 ,  0.95 , 
    '27' , 'Consumer Debit/Prepaid Petroleum CAT/FDC' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCATFDC' , 'MC US PETROL DB' , 1 , null, null, null , 
    '27' , 'Consumer Debit/Prepaid Petroleum CAT/FDC' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCONCVM1RELST' , 'Cons Merit1 Real Est DB' , 1 , 1.1 , 0.0 , null , 
    '78' , 'Consumer Debit/Prepaid Merit I Real Estate' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCONCVM1RELST' , 'Cons Merit1 Real Est DB' , 1 , null, null, null , 
    '78' , 'Consumer Debit/Prepaid Merit I Real Estate' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCPUR' , 'MC CONV PURCHASE DB' , 2 , 1.9 , 0.0 , null , 
    '23' , 'Consumer Debit/Prepaid Convenience Purchases Base' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCPUR' , 'MC CONV PURCHASE DB' , 2 , null, null, null , 
    '23' , 'Consumer Debit/Prepaid Convenience Purchases Base' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCPURT1' , 'MC CONV PURCHASE DB TIER 1' , 1 , 0.75 , 0.17 ,  0.95 , 
    'CP' , 'Consumer Debit Convenience Purchases Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCPURT1' , 'MC CONV PURCHASE DB TIER 1' , 1 , null, null, null , 
    'CP' , 'Consumer Debit Convenience Purchases Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHC' , 'MC US CONS WAREHOUSE DB' , 1 , 1.05 , 0.15 ,  0.35 , 
    '91' , 'Consumer Debit/Prepaid Warehouse Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHC' , 'MC US CONS WAREHOUSE DB' , 1 , null, null, null , 
    '91' , 'Consumer Debit/Prepaid Warehouse Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCAP' , 'MC US WAREHOUSE DB BASE CAP' , 1 , 1.05 , 0.15 ,  0.35 , 
    '91' , 'Consumer Debit/Prepaid Warehouse Base Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCAP' , 'MC US WAREHOUSE DB BASE CAP' , 1 , null, null, null , 
    '91' , 'Consumer Debit/Prepaid Warehouse Base Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT1' , 'MC US WAREHOUSE DB T1 CAP' , 1 , 1.05 , 0.15 ,  0.35 , 
    '16' , 'Consumer Debit/Prepaid Warehouse Tier 1 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT1' , 'MC US WAREHOUSE DB T1 CAP' , 1 , null, null, null , 
    '16' , 'Consumer Debit/Prepaid Warehouse Tier 1 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT2' , 'MC US WAREHOUSE DB T2 CAP' , 1 , 1.05 , 0.15 ,  0.35 , 
    '17' , 'Consumer Debit/Prepaid Warehouse Tier 2 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT2' , 'MC US WAREHOUSE DB T2 CAP' , 1 , null, null, null , 
    '17' , 'Consumer Debit/Prepaid Warehouse Tier 2 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT3' , 'MC US WAREHOUSE DB T3 CAP' , 1 , 1.05 , 0.15 ,  0.35 , 
    '18' , 'Consumer Debit/Prepaid Warehouse Tier 3 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCCT3' , 'MC US WAREHOUSE DB T3 CAP' , 1 , null, null, null , 
    '18' , 'Consumer Debit/Prepaid Warehouse Tier 3 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT1' , 'MC US WAREHOUSE DB T1' , 1 , 1.05 , 0.15 ,  0.35 , 
    '16' , 'Consumer Debit/Prepaid Warehouse Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT1' , 'MC US WAREHOUSE DB T1' , 1 , null, null, null , 
    '16' , 'Consumer Debit/Prepaid Warehouse Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT2' , 'MC US WAREHOUSE DB T2' , 1 , 1.05 , 0.15 ,  0.35 , 
    '17' , 'Consumer Debit/Prepaid Warehouse Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT2' , 'MC US WAREHOUSE DB T2' , 1 , null, null, null , 
    '17' , 'Consumer Debit/Prepaid Warehouse Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT3' , 'MC US WAREHOUSE DB T3' , 1 , 1.05 , 0.15 ,  0.35 , 
    '18' , 'Consumer Debit/Prepaid Warehouse Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUCWHCT3' , 'MC US WAREHOUSE DB T3' , 1 , null, null, null , 
    '18' , 'Consumer Debit/Prepaid Warehouse Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMEDUGOV' , 'MC US EM MT EDU GOV MCC DB PP' , 1 , 0.65 , 0.15 ,  2.0 , 
    '29' , 'Consumer Debit/Prepaid Emerging Market - Goverment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMEDUGOV' , 'MC US EM MT EDU GOV MCC DB PP' , 1 , null, null, null , 
    '29' , 'Consumer Debit/Prepaid Emerging Market - Goverment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMEDUGOVCAP' , 'MC EM MT EDU GOV MCC DB PP CAP' , 1 , 0.65 , 0.15 ,  2.0 , 
    '29' , 'Consumer Debit/Prepaid Emerging Market - Goverment Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMEDUGOVCAP' , 'MC EM MT EDU GOV MCC DB PP CAP' , 1 , null, null, null , 
    '29' , 'Consumer Debit/Prepaid Emerging Market - Goverment Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMERGMKT' , 'MC US EMERGING MKT DB' , 1 , 0.8 , 0.25 , null , 
    '29' , 'Consumer Debit/Prepaid Emerging Markets' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUEMERGMKT' , 'MC US EMERGING MKT DB' , 1 , null, null, null , 
    '29' , 'Consumer Debit/Prepaid Emerging Markets' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUFUCAF' , 'MC US FULL UCAF DB' , 1 , 1.25 , 0.15 , null , 
    '79' , 'Consumer Debit/Prepaid Full UCAF' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUFUCAF' , 'MC US FULL UCAF DB' , 1 , null, null, null , 
    '79' , 'Consumer Debit/Prepaid Full UCAF' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUKEY' , 'MC KEY ENTERED DB' , 1 , 1.6 , 0.15 , null , 
    '92' , 'Consumer Debit Key-Entered' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUKEY' , 'MC KEY ENTERED DB' , 1 , null, null, null , 
    '92' , 'Consumer Debit Key-Entered' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , 1.6 , 0.15 , null , 
    '78' , 'Consumer Debit Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , null, null, null , 
    '78' , 'Consumer Debit Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , 1.6 , 0.15 , null , 
    '88' , 'Consumer Debit/Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , null, null, null , 
    '88' , 'Consumer Debit/Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , 1.6 , 0.15 , null , 
    '98' , 'Consumer Debit/Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1' , 'MC MERIT 1 DB' , 1 , null, null, null , 
    '98' , 'Consumer Debit/Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1CONLOAN' , 'MC MERIT 1 CON LOAN DB' , 1 , 0.8 , 0.25 ,  2.95 , 
    '78' , 'Consumer Debit/Prepaid Merit I Loan' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1CONLOAN' , 'MC MERIT 1 CON LOAN DB' , 1 , null, null, null , 
    '78' , 'Consumer Debit/Prepaid Merit I Loan' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1CONLOANCAP' , 'MC MERIT 1 CON LOAN DB CAP' , 1 , 0.8 , 0.25 ,  2.95 , 
    '78' , 'Consumer Debit/Prepaid Merit I Loan Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1CONLOANCAP' , 'MC MERIT 1 CON LOAN DB CAP' , 1 , null, null, null , 
    '78' , 'Consumer Debit/Prepaid Merit I Loan Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1EC' , 'MC MERIT 1 ECOMMERCE DB' , 1 , 1.64 , 0.16 , null , 
    '98' , 'Consumer Debit Ecommerce Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM1EC' , 'MC MERIT 1 ECOMMERCE DB' , 1 , null, null, null , 
    '98' , 'Consumer Debit Ecommerce Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3' , 'MC MERIT 3 DB' , 1 , 1.05 , 0.15 , null , 
    '70' , 'Consumer Debit/Prepaid Merit III Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3' , 'MC MERIT 3 DB' , 1 , null, null, null , 
    '70' , 'Consumer Debit/Prepaid Merit III Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3' , 'MC MERIT 3 DB' , 1 , 1.05 , 0.15 , null , 
    '80' , 'Consumer Debit/Prepaid Merit III Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3' , 'MC MERIT 3 DB' , 1 , null, null, null , 
    '80' , 'Consumer Debit/Prepaid Merit III Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T1' , 'MC MERIT 3 DB T1' , 1 , 0.7 , 0.15 , null , 
    '10' , 'Consumer Debit/Prepaid Merit III Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T1' , 'MC MERIT 3 DB T1' , 1 , null, null, null , 
    '10' , 'Consumer Debit/Prepaid Merit III Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T2' , 'MC MERIT 3 DB T2' , 1 , 0.83 , 0.15 , null , 
    '11' , 'Consumer Debit/Prepaid Merit III Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T2' , 'MC MERIT 3 DB T2' , 1 , null, null, null , 
    '11' , 'Consumer Debit/Prepaid Merit III Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T3' , 'MC MERIT 3 DB T3' , 1 , 0.95 , 0.15 , null , 
    '12' , 'Consumer Debit/Prepaid Merit III Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUM3T3' , 'MC MERIT 3 DB T3' , 1 , null, null, null , 
    '12' , 'Consumer Debit/Prepaid Merit III Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUMUCAF' , 'MC US MERCH UCAF DB' , 1 , 1.15 , 0.15 , null , 
    '24' , 'Consumer Debit/Prepaid Merchant UCAF' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUMUCAF' , 'MC US MERCH UCAF DB' , 1 , null, null, null , 
    '24' , 'Consumer Debit/Prepaid Merchant UCAF' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUPBLSEC' , 'MC US PUBLIC SECTOR' , 1 , 1.55 , 0.1 , null , 
    '22' , 'Consumer Debit/Prepaid Public Sector' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUPBLSEC' , 'MC US PUBLIC SECTOR' , 1 , null, null, null , 
    '22' , 'Consumer Debit/Prepaid Public Sector' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUPT' , 'MC PASS TRANSPORT DB' , 1 , 1.6 , 0.15 , null , 
    '93' , 'Consumer Debit/Prepaid Passenger Transport' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUPT' , 'MC PASS TRANSPORT DB' , 1 , null, null, null , 
    '93' , 'Consumer Debit/Prepaid Passenger Transport' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DURESTAUR' , 'MC RESTAURANT DB' , 1 , 1.19 , 0.1 , null , 
    '26' , 'Consumer Debit/Prepaid Restaurant' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DURESTAUR' , 'MC RESTAURANT DB' , 1 , null, null, null , 
    '26' , 'Consumer Debit/Prepaid Restaurant' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSERVST' , 'MC US PETROL SERV ST DB' , 1 , 0.7 , 0.17 ,  0.95 , 
    '28' , 'Consumer Debit/Prepaid Petroleum Service Station' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSERVST' , 'MC US PETROL SERV ST DB' , 1 , null, null, null , 
    '28' , 'Consumer Debit/Prepaid Petroleum Service Station' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSERVSTC' , 'MC US PETROL SERV ST DB CAP' , 1 , 0.7 , 0.17 ,  0.95 , 
    '28' , 'Consumer Debit/Prepaid Petroleum Service Station Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSERVSTC' , 'MC US PETROL SERV ST DB CAP' , 1 , null, null, null , 
    '28' , 'Consumer Debit/Prepaid Petroleum Service Station Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSIND' , 'MC SERVICE INDUSTRY DB' , 1 , 1.15 , 0.05 , null , 
    '90' , 'Consumer Debit/Prepaid Service Industries' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSIND' , 'MC SERVICE INDUSTRY DB' , 1 , null, null, null , 
    '90' , 'Consumer Debit/Prepaid Service Industries' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSMLTCKT' , 'MC SMALL TCKT DB' , 1 , 1.55 , 0.04 , null , 
    '25' , 'Consumer Debit/Prepaid Small Ticket Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSMLTCKT' , 'MC SMALL TCKT DB' , 1 , null, null, null , 
    '25' , 'Consumer Debit/Prepaid Small Ticket Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , 1.9 , 0.25 , null , 
    '75' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , null, null, null , 
    '75' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , 1.9 , 0.25 , null , 
    '85' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , null, null, null , 
    '85' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , 1.9 , 0.25 , null , 
    '95' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTD' , 'MC STANDARD DB' , 2 , null, null, null , 
    '95' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTDEC' , 'MC STANDARD EC DB' , 2 , 1.9 , 0.25 , null , 
    '95' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSTDEC' , 'MC STANDARD EC DB' , 2 , null, null, null , 
    '95' , 'Consumer Debit/Prepaid Standard' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUP' , 'MC SUPERMARKET DB' , 1 , 1.05 , 0.15 ,  0.35 , 
    '71' , 'Consumer Debit/Prepaid Supermarket Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUP' , 'MC SUPERMARKET DB' , 1 , null, null, null , 
    '71' , 'Consumer Debit/Prepaid Supermarket Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUP' , 'MC SUPERMARKET DB' , 1 , 1.05 , 0.15 ,  0.35 , 
    '81' , 'Consumer Debit/Prepaid Supermarket Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUP' , 'MC SUPERMARKET DB' , 1 , null, null, null , 
    '81' , 'Consumer Debit/Prepaid Supermarket Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCAP' , 'MC SUPERMARKET DB BASE CAP' , 1 , 1.05 , 0.15 ,  0.35 , 
    '71' , 'Consumer Debit/Prepaid Supermarket Cap Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCAP' , 'MC SUPERMARKET DB BASE CAP' , 1 , null, null, null , 
    '71' , 'Consumer Debit/Prepaid Supermarket Cap Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT1' , 'MC SUPERMARKET DB T1 CAP' , 1 , 0.7 , 0.15 ,  0.35 , 
    '13' , 'Consumer Debit/Prepaid Supermarket Tier 1 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT1' , 'MC SUPERMARKET DB T1 CAP' , 1 , null, null, null , 
    '13' , 'Consumer Debit/Prepaid Supermarket Tier 1 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT2' , 'MC SUPERMARKET DB T2 CAP' , 1 , 0.83 , 0.15 ,  0.35 , 
    '14' , 'Consumer Debit/Prepaid Supermarket Tier 2 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT2' , 'MC SUPERMARKET DB T2 CAP' , 1 , null, null, null , 
    '14' , 'Consumer Debit/Prepaid Supermarket Tier 2 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT3' , 'MC SUPERMARKET DB T3 CAP' , 1 , 0.95 , 0.15 ,  0.35 , 
    '15' , 'Consumer Debit/Prepaid Supermarket Tier 3 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPCT3' , 'MC SUPERMARKET DB T3 CAP' , 1 , null, null, null , 
    '15' , 'Consumer Debit/Prepaid Supermarket Tier 3 Cap' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT1' , 'MC SUPERMARKET DB T1' , 1 , 0.7 , 0.15 ,  0.35 , 
    '13' , 'Consumer Debit/Prepaid Supermarket Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT1' , 'MC SUPERMARKET DB T1' , 1 , null, null, null , 
    '13' , 'Consumer Debit/Prepaid Supermarket Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT2' , 'MC SUPERMARKET DB T2' , 1 , 0.83 , 0.15 ,  0.35 , 
    '14' , 'Consumer Debit/Prepaid Supermarket Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT2' , 'MC SUPERMARKET DB T2' , 1 , null, null, null , 
    '14' , 'Consumer Debit/Prepaid Supermarket Tier 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT3' , 'MC SUPERMARKET DB T3' , 1 , 0.95 , 0.15 ,  0.35 , 
    '15' , 'Consumer Debit/Prepaid Supermarket Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUSUPT3' , 'MC SUPERMARKET DB T3' , 1 , null, null, null , 
    '15' , 'Consumer Debit/Prepaid Supermarket Tier 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUTPR' , 'MC TRAVEL PREMIER DB' , 1 , 1.15 , 0.15 , null , 
    '97' , 'Consumer Debit/Prepaid Lodging and Auto Rental' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105DUTPR' , 'MC TRAVEL PREMIER DB' , 1 , null, null, null , 
    '97' , 'Consumer Debit/Prepaid Lodging and Auto Rental' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HAIR' , 'HIGH VALUE AIRLINE' , 3 , 2.3 , 0.1 , null , 
    'HU' , 'Consumer Credit Airline - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HAIR' , 'HIGH VALUE AIRLINE' , 3 , null, null, null , 
    'HU' , 'Consumer Credit Airline - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HCONP' , 'HIGH VALUE CONVENIENCE PURCH' , 2 , 2.0 , 0.0 , null , 
    'HH' , 'Consumer Credit Convenience Purchases Base - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HCONP' , 'HIGH VALUE CONVENIENCE PURCH' , 2 , null, null, null , 
    'HH' , 'Consumer Credit Convenience Purchases Base - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HCONPT1' , 'HIGH VALUE CONV PUR TIER 1' , 1 , 1.6 , 0.0 , null , 
    'HY' , 'Consumer Credit Convenience Purchases Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HCONPT1' , 'HIGH VALUE CONV PUR TIER 1' , 1 , null, null, null , 
    'HY' , 'Consumer Credit Convenience Purchases Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HFULLUCAF' , 'HIGH VALUE FULL UCAF' , 3 , 2.4 , 0.1 , null , 
    'HT' , 'Consumer Credit Full UCAF - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HFULLUCAF' , 'HIGH VALUE FULL UCAF' , 3 , null, null, null , 
    'HT' , 'Consumer Credit Full UCAF - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HKEY' , 'HIGH VALUE KEY-ENTERED' , 3 , 2.5 , 0.1 , null , 
    'HC' , 'Consumer Credit Key-Entered - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HKEY' , 'HIGH VALUE KEY-ENTERED' , 3 , null, null, null , 
    'HC' , 'Consumer Credit Key-Entered - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HLRGTKT' , 'HIGH VALUE T/E LARGE TICKET' , 2 , 2.0 , 0.0 , null , 
    'HZ' , 'Consumer Credit T/E Large Ticket - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HLRGTKT' , 'HIGH VALUE T/E LARGE TICKET' , 2 , null, null, null , 
    'HZ' , 'Consumer Credit T/E Large Ticket - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3B' , 'HIGH VALUE MERIT III BASE' , 3 , 2.2 , 0.1 , null , 
    'HD' , 'Consumer Credit Merit III Base - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3B' , 'HIGH VALUE MERIT III BASE' , 3 , null, null, null , 
    'HD' , 'Consumer Credit Merit III Base - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T1' , 'HIGH VALUE MERIT III TIER 1' , 2 , 2.05 , 0.1 , null , 
    'HE' , 'Consumer Credit Merit III Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T1' , 'HIGH VALUE MERIT III TIER 1' , 2 , null, null, null , 
    'HE' , 'Consumer Credit Merit III Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T2' , 'HIGH VALUE MERIT III TIER 2' , 2 , 2.1 , 0.1 , null , 
    'HF' , 'Consumer Credit Merit III Tier 2 - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T2' , 'HIGH VALUE MERIT III TIER 2' , 2 , null, null, null , 
    'HF' , 'Consumer Credit Merit III Tier 2 - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T3' , 'HIGH VALUE MERIT III TIER 3' , 3 , 2.15 , 0.1 , null , 
    'HG' , 'Consumer Credit Merit III Tier 3 - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HM3T3' , 'HIGH VALUE MERIT III TIER 3' , 3 , null, null, null , 
    'HG' , 'Consumer Credit Merit III Tier 3 - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1' , 'HIGH VALUE MERIT I' , 3 , 2.5 , 0.1 , null , 
    'HB' , 'Consumer Credit Merit I - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1' , 'HIGH VALUE MERIT I' , 3 , null, null, null , 
    'HB' , 'Consumer Credit Merit I - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1INS' , 'HIGH VALUE MERIT 1 INS' , 3 , 2.2 , 0.1 , null , 
    'HB' , 'Consumer Credit Merit I Insurance - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1INS' , 'HIGH VALUE MERIT 1 INS' , 3 , null, null, null , 
    'HB' , 'Consumer Credit Merit I Insurance - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1RELST' , 'HIGH VALUE MERIT 1 REAL EST' , 3 , 2.2 , 0.1 , null , 
    'HB' , 'Consumer Credit Merit I Real Estate - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMER1RELST' , 'HIGH VALUE MERIT 1 REAL EST' , 3 , null, null, null , 
    'HB' , 'Consumer Credit Merit I Real Estate - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMERUCAF' , 'HIGH VALUE MERCHANT UCAF' , 3 , 2.3 , 0.1 , null , 
    'HS' , 'Consumer Credit Merchant UCAF - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HMERUCAF' , 'HIGH VALUE MERCHANT UCAF' , 3 , null, null, null , 
    'HS' , 'Consumer Credit Merchant UCAF - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPETBASE' , 'HIGH VALUE PETROLEUM BASE' , 1 , 2.0 , 0.0 ,  0.95 , 
    'HX' , 'Consumer Credit Petroleum Base - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPETBASE' , 'HIGH VALUE PETROLEUM BASE' , 1 , null, null, null , 
    'HX' , 'Consumer Credit Petroleum Base - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPETCAP' , 'HIGH VALUE PETROLEUM BASE-CAP' , 1 , 2.0 , 0.0 ,  0.95 , 
    'HX' , 'Consumer Credit Petroleum Base Cap - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPETCAP' , 'HIGH VALUE PETROLEUM BASE-CAP' , 1 , null, null, null , 
    'HX' , 'Consumer Credit Petroleum Base Cap - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPUBSEC' , 'HIGH VALUE PUBLIC SECTOR' , 1 , 1.55 , 0.1 , null , 
    'HP' , 'Consumer Credit Public Sector - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HPUBSEC' , 'HIGH VALUE PUBLIC SECTOR' , 1 , null, null, null , 
    'HP' , 'Consumer Credit Public Sector - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HREST' , 'HIGH VALUE RESTAURANT' , 3 , 2.2 , 0.1 , null , 
    'HQ' , 'Consumer Credit Restaurant - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HREST' , 'HIGH VALUE RESTAURANT' , 3 , null, null, null , 
    'HQ' , 'Consumer Credit Restaurant - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSERIND' , 'HIGH VALUE SERVICE INDUSTRIES' , 1 , 1.15 , 0.05 , null , 
    'HO' , 'Consumer Credit Service Industries - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSERIND' , 'HIGH VALUE SERVICE INDUSTRIES' , 1 , null, null, null , 
    'HO' , 'Consumer Credit Service Industries - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTB' , 'HIGH VALUE SUPERMARKET BASE' , 2 , 1.9 , 0.1 , null , 
    'HI' , 'Consumer Credit Supermarket Base - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTB' , 'HIGH VALUE SUPERMARKET BASE' , 2 , null, null, null , 
    'HI' , 'Consumer Credit Supermarket Base - World High Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT1' , 'HIGH VALUE SUPERMARKET TIER 1' , 1 , 1.25 , 0.05 , null , 
    'HJ' , 'Consumer Credit Supermarket Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT1' , 'HIGH VALUE SUPERMARKET TIER 1' , 1 , null, null, null , 
    'HJ' , 'Consumer Credit Supermarket Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT2' , 'HIGH VALUE SUPERMARKET TIER 2' , 1 , 1.25 , 0.05 , null , 
    'HK' , 'Consumer Credit Supermarket Tier 2 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT2' , 'HIGH VALUE SUPERMARKET TIER 2' , 1 , null, null, null , 
    'HK' , 'Consumer Credit Supermarket Tier 2 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT3' , 'HIGH VALUE SUPERMARKET TIER 3' , 1 , 1.32 , 0.05 , null , 
    'HL' , 'Consumer Credit Supermarket Tier 3 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSMKTT3' , 'HIGH VALUE SUPERMARKET TIER 3' , 1 , null, null, null , 
    'HL' , 'Consumer Credit Supermarket Tier 3 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSTD' , 'HIGH VALUE STANDARD' , 3 , 3.25 , 0.1 , null , 
    'HA' , 'Consumer Credit Standard - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HSTD' , 'HIGH VALUE STANDARD' , 3 , null, null, null , 
    'HA' , 'Consumer Credit Standard - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HTNE' , 'HIGH VALUE T/E' , 3 , 2.75 , 0.1 , null , 
    'HR' , 'Consumer Credit T/E - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HTNE' , 'HIGH VALUE T/E' , 3 , null, null, null , 
    'HR' , 'Consumer Credit T/E - World High Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HUTL' , 'HIGH VALUE UTILITIES' , 1 , 0.0 , 0.75 , null , 
    'HV' , 'Consumer Credit Utilities - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HUTL' , 'HIGH VALUE UTILITIES' , 1 , null, null, null , 
    'HV' , 'Consumer Credit Utilities - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HWHOB' , 'HIGH VALUE WAREHOUSE BASE' , 1 , 1.9 , 0.1 , null , 
    'HM' , 'Consumer Credit Warehouse Base - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HWHOB' , 'HIGH VALUE WAREHOUSE BASE' , 1 , null, null, null , 
    'HM' , 'Consumer Credit Warehouse Base - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HWHT1' , 'HIGH VALUE WAREHOUSE TIER 1' , 1 , 1.9 , 0.1 , null , 
    'HN' , 'Consumer Credit Warehouse Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105HWHT1' , 'HIGH VALUE WAREHOUSE TIER 1' , 1 , null, null, null , 
    'HN' , 'Consumer Credit Warehouse Tier 1 - World High Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICASHCS' , 'MC CONS CASH INT' , 3 , 0.09 , 3.6 , null , 
    '' , 'Intercountry Manual Cash' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICASHCS' , 'MC CONS CASH INT' , 3 , null, null, null , 
    '' , 'Intercountry Manual Cash' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICORP' , 'MC INTL CORPORATE' , 2 , 2.0 , 0.0 , null , 
    '61' , 'Commercial Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICORP' , 'MC INTL CORPORATE' , 2 , null, null, null , 
    '61' , 'Commercial Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICPAY' , 'MC INTL CORP PAYMENT' , 1 , 0.19 , 0.53 , null , 
    '21' , 'Commercial Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ICPAY' , 'MC INTL CORP PAYMENT' , 1 , null, null, null , 
    '21' , 'Commercial Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , 1.1 , 0.0 , null , 
    '73' , 'Consumer Credit Electronic US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , null, null, null , 
    '73' , 'Consumer Credit Electronic US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , 1.1 , 0.0 , null , 
    '83' , 'Consumer Electronic Payment - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IEI' , 'MC INTL ELECTRONIC' , 1 , null, null, null , 
    '83' , 'Consumer Electronic Payment - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IFUCAF' , 'MC INTL FULL UCAF' , 1 , 1.54 , 0.0 , null , 
    '79' , 'Cosumer Credit Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IFUCAF' , 'MC INTL FULL UCAF' , 1 , null, null, null , 
    '79' , 'Cosumer Credit Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELCARDCRP' , 'MC ELECTRONIC CARD COMM' , 2 , 1.85 , 0.0 , null , 
    '47' , 'Commercial Electronic Card - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELCARDCRP' , 'MC ELECTRONIC CARD COMM' , 2 , null, null, null , 
    '47' , 'Commercial Electronic Card - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELCARDCS' , 'MC ELEC CARD CONS' , 1 , 1.1 , 0.0 , null , 
    '74' , 'Consumer Credit Electronic Card US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELCARDCS' , 'MC ELEC CARD CONS' , 1 , null, null, null , 
    '74' , 'Consumer Credit Electronic Card US Region - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELFUCAFCRP' , 'MC US MCE CORPORATE FULL UCAF' , 2 , 1.85 , 0.0 , null , 
    '47' , 'Commercial Electronic Card Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELFUCAFCRP' , 'MC US MCE CORPORATE FULL UCAF' , 2 , null, null, null , 
    '47' , 'Commercial Electronic Card Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELFUCAFCS' , 'MC US MCE CONSUMER FULL UCAF' , 1 , 1.54 , 0.0 , null , 
    '79' , 'Cosumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMCELFUCAFCS' , 'MC US MCE CONSUMER FULL UCAF' , 1 , null, null, null , 
    '79' , 'Cosumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMUCAF' , 'MC INTL MERCHANT UCAF' , 1 , 1.44 , 0.0 , null , 
    '24' , 'Consumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IMUCAF' , 'MC INTL MERCHANT UCAF' , 1 , null, null, null , 
    '24' , 'Consumer Credit Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPAY' , 'MC INTL PAYMENT' , 1 , 0.19 , 0.53 , null , 
    '20' , 'Consumer Credit Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPAY' , 'MC INTL PAYMENT' , 1 , null, null, null , 
    '20' , 'Consumer Credit Payment Transaction - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCOMSTD' , 'MC INTL COMM PREM STANDARD' , 2 , 2.0 , 0.0 , null , 
    'IP' , 'Commercial Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCOMSTD' , 'MC INTL COMM PREM STANDARD' , 2 , null, null, null , 
    'IP' , 'Commercial Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSEI' , 'MC INTL CONS PREM ELECTRONIC' , 2 , 1.85 , 0.0 , null , 
    'PE' , 'Consumer Credit Electronic - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSEI' , 'MC INTL CONS PREM ELECTRONIC' , 2 , null, null, null , 
    'PE' , 'Consumer Credit Electronic - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSFUCAF' , 'MC INTL CONS PREM FULL UCAF' , 2 , 1.85 , 0.0 , null , 
    'PF' , 'Consumer Credit Full UCAF - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSFUCAF' , 'MC INTL CONS PREM FULL UCAF' , 2 , null, null, null , 
    'PF' , 'Consumer Credit Full UCAF - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSMUCAF' , 'MC INTL CONS PREM MERCH UCAF' , 2 , 1.85 , 0.0 , null , 
    'PM' , 'Consumer Credit Merchant UCAF - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSMUCAF' , 'MC INTL CONS PREM MERCH UCAF' , 2 , null, null, null , 
    'PM' , 'Consumer Credit Merchant UCAF - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSSTD' , 'MC INTL CONS PREM STANDARD' , 2 , 1.85 , 0.0 , null , 
    'PS' , 'Consumer Credit Standard - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPCSSTD' , 'MC INTL CONS PREM STANDARD' , 2 , null, null, null , 
    'PS' , 'Consumer Credit Standard - Premium' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPDR2' , 'MC INTL PURCH DATA RATE II' , 1 , 1.7 , 0.0 , null , 
    '67' , 'Commercial Purchasing Data Rate II - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPDR2' , 'MC INTL PURCH DATA RATE II' , 1 , null, null, null , 
    '67' , 'Commercial Purchasing Data Rate II - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPLT' , 'MC INTL PURCH LARGE TICKET' , 3 , 0.9 , 30.0 , null , 
    '62' , 'Commercial Purchasing Large Ticket - Interregional' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPLT' , 'MC INTL PURCH LARGE TICKET' , 3 , null, null, null , 
    '62' , 'Commercial Purchasing Large Ticket - Interregional' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPURC' , 'MC INTL PURCHASING' , 2 , 2.0 , 0.0 , null , 
    '63' , 'Commercial Purchasing Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IPURC' , 'MC INTL PURCHASING' , 2 , null, null, null , 
    '63' , 'Commercial Purchasing Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IREBATE' , 'MC INTL COMMERCIAL REBATE' , 1 , 0.0 , 0.0 , null , 
    'EZ' , 'Commercial Rebate - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105IREBATE' , 'MC INTL COMMERCIAL REBATE' , 1 , null, null, null , 
    'EZ' , 'Commercial Rebate - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCACH' , 'MC INTL SUPER PREM ACQ CHIP' , 2 , 1.98 , 0.0 , null , 
    'EA' , 'Consumer Super Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCACH' , 'MC INTL SUPER PREM ACQ CHIP' , 2 , null, null, null , 
    'EA' , 'Consumer Super Premium Acquirer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCICH' , 'MC INTL SUPER PREM ISS CHIP' , 2 , 1.98 , 0.0 , null , 
    'EI' , 'Consumer Super Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCICH' , 'MC INTL SUPER PREM ISS CHIP' , 2 , null, null, null , 
    'EI' , 'Consumer Super Premium Issuer Chip - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSEI' , 'MC INTL CONS SUPERPREM ELEC' , 2 , 1.98 , 0.0 , null , 
    'EE' , 'Consumer Super Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSEI' , 'MC INTL CONS SUPERPREM ELEC' , 2 , null, null, null , 
    'EE' , 'Consumer Super Premium Electronic - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSFUCAF' , 'MC INTL CONS SUPERPREM FULUCAF' , 2 , 1.98 , 0.0 , null , 
    'EF' , 'Consumer Super Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSFUCAF' , 'MC INTL CONS SUPERPREM FULUCAF' , 2 , null, null, null , 
    'EF' , 'Consumer Super Premium Full UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSMUCAF' , 'MC INTL CONS SUPERPREM MERUCAF' , 2 , 1.98 , 0.0 , null , 
    'EM' , 'Consumer Super Premium Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSMUCAF' , 'MC INTL CONS SUPERPREM MERUCAF' , 2 , null, null, null , 
    'EM' , 'Consumer Super Premium Merchant UCAF - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSSTD' , 'MC INTL CONS SUPERPREM STD' , 2 , 1.98 , 0.0 , null , 
    'ES' , 'Consumer Super Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISPCSSTD' , 'MC INTL CONS SUPERPREM STD' , 2 , null, null, null , 
    'ES' , 'Consumer Super Premium Standard - Interregional' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null , 
    '75' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , null, null, null , 
    '75' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null , 
    '85' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , null, null, null , 
    '85' , 'Consumer Credit Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null , 
    '95' , 'Consumer Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTD' , 'MC INTL STANDARD' , 1 , null, null, null , 
    '95' , 'Consumer Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTDEC' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null , 
    '75' , 'Consumer Debit/Prepaid Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTDEC' , 'MC INTL STANDARD' , 1 , null, null, null , 
    '75' , 'Consumer Debit/Prepaid Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTDEC' , 'MC INTL STANDARD' , 1 , 1.6 , 0.0 , null , 
    '95' , 'Consumer Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105ISTDEC' , 'MC INTL STANDARD' , 1 , null, null, null , 
    '95' , 'Consumer Standard - Interregional' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MONSND' , 'MASTERCARD MONEYSEND PAYMENT' , 1 , 0.0 , 0.0 , null , 
    'MS' , 'MoneySend Payment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MONSND' , 'MASTERCARD MONEYSEND PAYMENT' , 1 , null, null, null , 
    'MS' , 'MoneySend Payment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPCORERATE1' , 'MPP Core Rate1' , d ,  ,  , null , 
    'ME' , 'Merchant Partner Program (MPP) Consumer Core Value Credit Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPCORERATE1' , 'MPP Core Rate1' , d , null, null, null , 
    'ME' , 'Merchant Partner Program (MPP) Consumer Core Value Credit Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPCORERATE2' , 'MPP Core Rate2' , d ,  ,  , null , 
    'MU' , 'Merchant Partner Program (MPP) Consumer Core Value Credit Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPCORERATE2' , 'MPP Core Rate2' , d , null, null, null , 
    'MU' , 'Merchant Partner Program (MPP) Consumer Core Value Credit Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPENHRATE1' , 'MPP Enhanced Rate1' , d ,  ,  , null , 
    'MF' , 'Merchant Partner Program (MPP) Enhanced Value Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPENHRATE1' , 'MPP Enhanced Rate1' , d , null, null, null , 
    'MF' , 'Merchant Partner Program (MPP) Enhanced Value Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPENHRATE2' , 'MPP Enhanced Rate2' , d ,  ,  , null , 
    'MV' , 'Merchant Partner Program (MPP) Enhanced Value Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPENHRATE2' , 'MPP Enhanced Rate2' , d , null, null, null , 
    'MV' , 'Merchant Partner Program (MPP) Enhanced Value Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPHIGHRATE1' , 'MPP High Rate1' , d ,  ,  , null , 
    'MH' , 'Merchant Partner Program (MPP) World High Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPHIGHRATE1' , 'MPP High Rate1' , d , null, null, null , 
    'MH' , 'Merchant Partner Program (MPP) World High Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPHIGHRATE2' , 'MPP High Rate2' , d ,  ,  , null , 
    'MX' , 'Merchant Partner Program (MPP) World High Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPHIGHRATE2' , 'MPP High Rate2' , d , null, null, null , 
    'MX' , 'Merchant Partner Program (MPP) World High Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPRATE1' , 'MPP Rate1' , d ,  ,  , null , 
    'MC' , 'Merchant Partner Program (MPP) Face-to-face Rate 1 - Non-Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPRATE1' , 'MPP Rate1' , d , null, null, null , 
    'MC' , 'Merchant Partner Program (MPP) Face-to-face Rate 1 - Non-Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPRATE2' , 'MPP Rate2' , d ,  ,  , null , 
    'MM' , 'Merchant Partner Program (MPP) Rate 1 - Non-Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPRATE2' , 'MPP Rate2' , d , null, null, null , 
    'MM' , 'Merchant Partner Program (MPP) Rate 1 - Non-Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPREGRATE1' , 'MPP REGULATED Rate1' , d ,  ,  , null , 
    'LC' , 'Merchant Partner Program (MPP) Face-to-face Rate 1 - Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPREGRATE1' , 'MPP REGULATED Rate1' , d , null, null, null , 
    'LC' , 'Merchant Partner Program (MPP) Face-to-face Rate 1 - Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPREGRATE2' , 'MPP REGULATED Rate2' , d ,  ,  , null , 
    'LP' , 'Merchant Partner Program (MPP) Rate 1 - Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPREGRATE2' , 'MPP REGULATED Rate2' , d , null, null, null , 
    'LP' , 'Merchant Partner Program (MPP) Rate 1 - Regulated' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDERATE1' , 'MPP World Elite Rate1' , d ,  ,  , null , 
    'MI' , 'Merchant Partner Program (MPP) World Elite Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDERATE1' , 'MPP World Elite Rate1' , d , null, null, null , 
    'MI' , 'Merchant Partner Program (MPP) World Elite Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDERATE2' , 'MPP World Elite Rate2' , d ,  ,  , null , 
    'MY' , 'Merchant Partner Program (MPP) World Elite Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDERATE2' , 'MPP World Elite Rate2' , d , null, null, null , 
    'MY' , 'Merchant Partner Program (MPP) World Elite Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDRATE1' , 'MPP World Rate1' , d ,  ,  , null , 
    'MG' , 'Merchant Partner Program (MPP) World Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDRATE1' , 'MPP World Rate1' , d , null, null, null , 
    'MG' , 'Merchant Partner Program (MPP) World Rate 1' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDRATE2' , 'MPP World Rate2' , d ,  ,  , null , 
    'MW' , 'Merchant Partner Program (MPP) World Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105MPPWORLDRATE2' , 'MPP World Rate2' , d , null, null, null , 
    'MW' , 'Merchant Partner Program (MPP) World Rate 2' , '05' , 'variable upon agreement with MasterCar_JP_BASE_TIERd' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105PPUKEY' , 'MC KEY ENTERED PREPAID' , 1 , 1.76 , 0.2 , null , 
    '92' , 'Consumer Prepaid Key-Entered' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105PPUKEY' , 'MC KEY ENTERED PREPAID' , 1 , null, null, null , 
    '92' , 'Consumer Prepaid Key-Entered' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105PPUM1' , 'MC MERIT I PREPAID' , 1 , 1.76 , 0.2 , null , 
    '78' , 'Consumer Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105PPUM1' , 'MC MERIT I PREPAID' , 1 , null, null, null , 
    '78' , 'Consumer Prepaid Merit I' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCDR3' , 'BUSINESS CORE DATA RATE 3' , 2 , 1.75 , 0.1 , null , 
    '66' , 'Commercial Data Rate III Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCDR3' , 'BUSINESS CORE DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCSUPMKT' , 'BUSINESS CORE SUPER MARKET' , 2 , 2.0 , 0.1 , null , 
    '72' , 'Commercial Supermarket Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCSUPMKT' , 'BUSINESS CORE SUPER MARKET' , 2 , null, null, null , 
    '72' , 'Commercial Supermarket Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE1' , 'MC US BUSINESS CARD T/E I' , 3 , 2.5 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE1' , 'MC US BUSINESS CARD T/E I' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE2' , 'MC US BUSINESS CARD T/E II' , 3 , 2.35 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE2' , 'MC US BUSINESS CARD T/E II' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE3' , 'MC US BUSINESS CARD T/E III' , 3 , 2.3 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBCTE3' , 'MC US BUSINESS CARD T/E III' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDDR3' , 'BUSINESS DEBIT DATA RATE 3' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Business Debit' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDDR3' , 'BUSINESS DEBIT DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Business Debit' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR1' , 'DR I - BUS WORLD' , 3 , 2.81 , 0.1 , null , 
    '68' , 'Commercial Data Rate I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR1' , 'DR I - BUS WORLD' , 3 , null, null, null , 
    '68' , 'Commercial Data Rate I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR2' , 'COMMERCIAL DATA RATE 2' , 3 , 2.16 , 0.1 , null , 
    '67' , 'Commercial Data Rate II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR2' , 'COMMERCIAL DATA RATE 2' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR2PETR' , 'COMMERCIAL DATA RATE 2 PETROL' , 3 , 2.22 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR2PETR' , 'COMMERCIAL DATA RATE 2 PETROL' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR3' , 'COMMERCIAL DATA RATE 3' , 2 , 1.91 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Business World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDR3' , 'COMMERCIAL DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Business World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDSUPMKT' , 'BUSINESS DEBIT SUPER MARKET' , 2 , 2.2 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Business Debit' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBDSUPMKT' , 'BUSINESS DEBIT SUPER MARKET' , 2 , null, null, null , 
    '72' , 'Commercial Supermarket - Business Debit' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBEVDR2PETR' , 'BEV DR II- PETR' , 3 , 2.16 , 0.1 , null , 
    'SB' , 'Commercial Data Rate II Petroleum Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBEVDR2PETR' , 'BEV DR II- PETR' , 3 , null, null, null , 
    'SB' , 'Commercial Data Rate II Petroleum Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBEVF2FPETR' , 'BEV F2F- PETR' , 3 , 2.16 , 0.1 , null , 
    'SD' , 'Commercial Face-to-face Petroleum Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBEVF2FPETR' , 'BEV F2F- PETR' , 3 , null, null, null , 
    'SD' , 'Commercial Face-to-face Petroleum Level 2 - Business Enhanced' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBFTF' , 'COMMERCIAL FACE-TO-FACE' , 3 , 2.16 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBFTF' , 'COMMERCIAL FACE-TO-FACE' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBFTFPETR' , 'US COMMERCIAL F2F PETROLEUM' , 3 , 2.22 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBFTFPETR' , 'US COMMERCIAL F2F PETROLEUM' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT' , 'COMMERCIAL LARGE TICKET 1' , 3 , 1.36 , 40.0 , null , 
    '62' , 'Commercial Large Ticket I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT' , 'COMMERCIAL LARGE TICKET 1' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT2' , 'BUSINESS LARGE TICKET II' , 3 , 1.36 , 40.0 , null , 
    '94' , 'Commercial Large Ticket II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT2' , 'BUSINESS LARGE TICKET II' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT3' , 'BUSINESS LARGE TICKET III' , 3 , 1.36 , 40.0 , null , 
    '99' , 'Commercial Large Ticket III - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLT3' , 'BUSINESS LARGE TICKET III' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR1MPG' , 'BUSINESS LARGE TKT RI' , 1 , 1.2 , 0.0 , null , 
    'E1' , 'Commercial Large Ticket 1 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR1MPG' , 'BUSINESS LARGE TKT RI' , 1 , null, null, null , 
    'E1' , 'Commercial Large Ticket 1 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR2MPG' , 'BUSINESS LARGE TKT RII' , 1 , 1.0 , 0.0 , null , 
    'E2' , 'Commercial Large Ticket 2 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR2MPG' , 'BUSINESS LARGE TKT RII' , 1 , null, null, null , 
    'E2' , 'Commercial Large Ticket 2 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR3MPG' , 'BUSINESS LARGE TKT RIII' , 1 , 0.9 , 0.0 , null , 
    'E3' , 'Commercial Large Ticket 3 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBLTR3MPG' , 'BUSINESS LARGE TKT RIII' , 1 , null, null, null , 
    'E3' , 'Commercial Large Ticket 3 MPG - Business World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBST' , 'COMMERCIAL STD' , 3 , 3.11 , 0.1 , null , 
    '65' , 'Commercial Standard - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBST' , 'COMMERCIAL STD' , 3 , null, null, null , 
    '65' , 'Commercial Standard - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE1' , 'COMMERCIAL T/E 1' , 3 , 2.66 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE1' , 'COMMERCIAL T/E 1' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE2' , 'COMMERCIAL T/E 2' , 3 , 2.51 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE2' , 'COMMERCIAL T/E 2' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE3' , 'COMMERCIAL T/E 3' , 3 , 2.46 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBTE3' , 'COMMERCIAL T/E 3' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBUTIL' , 'MC US BUSINESS CARD UTILITIES' , 1 , 0.0 , 1.5 , null , 
    'CU' , 'Commercial Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBUTIL' , 'MC US BUSINESS CARD UTILITIES' , 1 , null, null, null , 
    'CU' , 'Commercial Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR1' , 'DR I - BUS WORLD ELITE' , 3 , 2.86 , 0.1 , null , 
    '68' , 'Commercial Data Rate I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR1' , 'DR I - BUS WORLD ELITE' , 3 , null, null, null , 
    '68' , 'Commercial Data Rate I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR2' , 'DR II - BUS WORLD ELITE' , 3 , 2.21 , 0.1 , null , 
    '67' , 'Commercial Data Rate II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR2' , 'DR II - BUS WORLD ELITE' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR2PETR' , 'DR II-BUS WORLD ELITE PETR' , 3 , 2.27 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR2PETR' , 'DR II-BUS WORLD ELITE PETR' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR3' , 'DR III - BUS WORLD ELITE' , 2 , 1.96 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Business World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEDR3' , 'DR III - BUS WORLD ELITE' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Business World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEF2FPETR' , 'F2F -BUS WORLD ELITE PETR' , 3 , 2.27 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEF2FPETR' , 'F2F -BUS WORLD ELITE PETR' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEFTF' , 'F2F- BUS WORLD ELITE' , 3 , 2.21 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEFTF' , 'F2F- BUS WORLD ELITE' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT' , 'LARGE TKT -BUS WORLD ELITE' , 3 , 1.41 , 40.0 , null , 
    '62' , 'Commercial Large Ticket I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT' , 'LARGE TKT -BUS WORLD ELITE' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT2' , 'LARGE TKT2 -BUS WORLD ELITE' , 3 , 1.41 , 40.0 , null , 
    '94' , 'Commercial Large Ticket II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT2' , 'LARGE TKT2 -BUS WORLD ELITE' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT3' , 'LARGE TKT3 -BUS WORLD ELITE' , 3 , 1.41 , 40.0 , null , 
    '99' , 'Commercial Large Ticket III - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWELT3' , 'LARGE TKT3 -BUS WORLD ELITE' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEST' , 'STANDARD-BUS WORLD ELITE' , 3 , 3.16 , 0.1 , null , 
    '65' , 'Commercial Standard - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWEST' , 'STANDARD-BUS WORLD ELITE' , 3 , null, null, null , 
    '65' , 'Commercial Standard - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWESUPMKT' , 'BUSINESS WORLD ELITE SUPMKT' , 3 , 2.21 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWESUPMKT' , 'BUSINESS WORLD ELITE SUPMKT' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE1' , 'T/E 1 BUS WORLD ELITE' , 3 , 2.71 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE1' , 'T/E 1 BUS WORLD ELITE' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE2' , 'T/E 2 BUS WORLD ELITE' , 3 , 2.56 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE2' , 'T/E 2 BUS WORLD ELITE' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE3' , 'T/E 3 BUS WORLD ELITE' , 3 , 2.51 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWETE3' , 'T/E 3 BUS WORLD ELITE' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Business World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWSUPMKT' , 'BUSINESS WORLD SUPMKT' , 3 , 2.16 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UBWSUPMKT' , 'BUSINESS WORLD SUPMKT' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Business World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCASHCS' , 'MC US CONS CASH' , 3 , 0.0 , 2.05 , null , 
    '' , 'Intracountry Manual Cash' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCASHCS' , 'MC US CONS CASH' , 3 , null, null, null , 
    '' , 'Intracountry Manual Cash' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR1' , 'MC US DATA RATE I' , 3 , 2.65 , 0.1 , null , 
    '68' , 'Commercial Data Rate I' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR1' , 'MC US DATA RATE I' , 3 , null, null, null , 
    '68' , 'Commercial Data Rate I' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR1BUS' , 'DR I - BUS' , 3 , 2.65 , 0.1 , null , 
    '68' , 'Commercial Data Rate I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR1BUS' , 'DR I - BUS' , 3 , null, null, null , 
    '68' , 'Commercial Data Rate I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2' , 'MC US DATA RATE II' , 3 , 2.5 , 0.1 , null , 
    '67' , 'Commercial Data Rate II - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2' , 'MC US DATA RATE II' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2BUS' , 'COMMERCIAL DATA RATE 2 BUS' , 3 , 2.0 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2BUS' , 'COMMERCIAL DATA RATE 2 BUS' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2FL' , 'COMMERCIAL DATA RATE 2 FL' , 3 , 2.5 , 0.1 , null , 
    '67' , 'Commercial Data Rate II - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2FL' , 'COMMERCIAL DATA RATE 2 FL' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETR' , 'COMMERCIAL DATA RATE 2 BUS' , 2 , 2.05 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETR' , 'COMMERCIAL DATA RATE 2 BUS' , 2 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRBUS' , 'COMMERCIAL DR2 PETROL BUS' , 2 , 2.05 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRBUS' , 'COMMERCIAL DR2 PETROL BUS' , 2 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRFL' , 'COMMERCIAL DATA RATE 2 FL' , 2 , 2.05 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRFL' , 'COMMERCIAL DATA RATE 2 FL' , 2 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRPUR' , 'COMMERCIAL DR2 PETROL PUR' , 2 , 2.05 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PETRPUR' , 'COMMERCIAL DR2 PETROL PUR' , 2 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PUR' , 'COMMERCIAL DATA RATE 2 PUR' , 3 , 2.5 , 0.1 , null , 
    '67' , 'Commercial Data Rate II - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR2PUR' , 'COMMERCIAL DATA RATE 2 PUR' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate II - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR3' , 'MC US DATA RATE III' , 2 , 1.75 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR3' , 'MC US DATA RATE III' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR3BUS' , 'Data Rate III Business' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Business Debit/Prepaid' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCDR3BUS' , 'Data Rate III Business' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Business Debit/Prepaid' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTF' , 'MC US FACE TO FACE' , 3 , 2.1 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTF' , 'MC US FACE TO FACE' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFBUS' , 'MC US FACE TO FACE BUS' , 3 , 2.0 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFBUS' , 'MC US FACE TO FACE BUS' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFFL' , 'MC US FACE TO FACE FL' , 3 , 2.5 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFFL' , 'MC US FACE TO FACE FL' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETR' , 'MC US F2F PETROLEUM' , 2 , 2.05 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Corporate' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETR' , 'MC US F2F PETROLEUM' , 2 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Corporate' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRBUS' , 'MC US FACE TO FACE PETROL BUS' , 2 , 2.05 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRBUS' , 'MC US FACE TO FACE PETROL BUS' , 2 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Business Core' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRFL' , 'MC US F2F PETROLEUM FL' , 2 , 2.05 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRFL' , 'MC US F2F PETROLEUM FL' , 2 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRPUR' , 'MC US FACE TO FACE PETROLM PUR' , 2 , 2.05 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPETRPUR' , 'MC US FACE TO FACE PETROLM PUR' , 2 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPUR' , 'MC US FACE TO FACE PUR 60' , 3 , 2.1 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCFTFPUR' , 'MC US FACE TO FACE PUR 60' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR1' , 'Large Market Data Rate I' , 3 , 2.65 , 0.1 , null , 
    '68' , 'Commercial Data Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR1' , 'Large Market Data Rate I' , 3 , null, null, null , 
    '68' , 'Commercial Data Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR2' , 'Large Market Data Rate II' , 3 , 2.5 , 0.1 , null , 
    '67' , 'Commercial Data Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR2' , 'Large Market Data Rate II' , 3 , null, null, null , 
    '67' , 'Commercial Data Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR2PETR' , 'Large Market DR II PETR MCC' , 2 , 2.05 , 0.1 , null , 
    '67' , 'Commercial Data Rate II Petroleum - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR2PETR' , 'Large Market DR II PETR MCC' , 2 , null, null, null , 
    '67' , 'Commercial Data Rate II Petroleum - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR3' , 'Large Market Data Rate III' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III Level 1 - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMDR3' , 'Large Market Data Rate III' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III Level 1 - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMFTF' , 'Large Market Face to Face' , 3 , 2.5 , 0.1 , null , 
    '60' , 'Commercial Face-to-face - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMFTF' , 'Large Market Face to Face' , 3 , null, null, null , 
    '60' , 'Commercial Face-to-face - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMFTFPETR' , 'Large Market FtoF PETR MCC' , 2 , 2.05 , 0.1 , null , 
    '60' , 'Commercial Face-to-face Petroleum - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLMFTFPETR' , 'Large Market FtoF PETR MCC' , 2 , null, null, null , 
    '60' , 'Commercial Face-to-face Petroleum - Large Market' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT' , 'MC US LARGE TICKET' , 3 , 1.2 , 40.0 , null , 
    '62' , 'Commercial Large Ticket I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT' , 'MC US LARGE TICKET' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1BUS' , 'Business Large Ticket 1' , 3 , 1.2 , 40.0 , null , 
    '62' , 'Commercial Large Ticket I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1BUS' , 'Business Large Ticket 1' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1LM' , 'Large Ticket 1 LM' , 3 , 1.25 , 40.0 , null , 
    '62' , 'Commercial Large Ticket I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1LM' , 'Large Ticket 1 LM' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1LOGBUS' , 'Business LT1 Lodging' , 3 , 2.3 , 0.1 , null , 
    '62' , 'Commercial Large Ticket I Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT1LOGBUS' , 'Business LT1 Lodging' , 3 , null, null, null , 
    '62' , 'Commercial Large Ticket I Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2' , 'COMMERCIAL LARGE TICKET II' , 3 , 1.2 , 40.0 , null , 
    '94' , 'Commercial Large Ticket II - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2' , 'COMMERCIAL LARGE TICKET II' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2BUS' , 'Business Large Ticket 2' , 3 , 1.2 , 40.0 , null , 
    '94' , 'Commercial Large Ticket II - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2BUS' , 'Business Large Ticket 2' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2LM' , 'Large Ticket 2 LM' , 3 , 1.25 , 40.0 , null , 
    '94' , 'Commercial Large Ticket II - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2LM' , 'Large Ticket 2 LM' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2LOGBUS' , 'Business LT2 Lodging' , 3 , 2.3 , 0.1 , null , 
    '94' , 'Commercial Large Ticket II Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT2LOGBUS' , 'Business LT2 Lodging' , 3 , null, null, null , 
    '94' , 'Commercial Large Ticket II Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3' , 'COMMERCIAL LARGE TICKET III' , 3 , 1.2 , 40.0 , null , 
    '99' , 'Commercial Large Ticket III - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3' , 'COMMERCIAL LARGE TICKET III' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3BUS' , 'Business Large Ticket 3' , 3 , 1.2 , 40.0 , null , 
    '99' , 'Commercial Large Ticket III - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3BUS' , 'Business Large Ticket 3' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3LM' , 'Large Ticket 3 LM' , 3 , 1.25 , 40.0 , null , 
    '99' , 'Commercial Large Ticket III - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3LM' , 'Large Ticket 3 LM' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3LOGBUS' , 'Business LT3 Lodging' , 3 , 2.3 , 0.1 , null , 
    '99' , 'Commercial Large Ticket III Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLT3LOGBUS' , 'Business LT3 Lodging' , 3 , null, null, null , 
    '99' , 'Commercial Large Ticket III Lodging - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR1MPG' , 'COMMERCIAL LARGE TKT RI' , 1 , 1.2 , 0.0 , null , 
    'E1' , 'Commercial Large Ticket 1 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR1MPG' , 'COMMERCIAL LARGE TKT RI' , 1 , null, null, null , 
    'E1' , 'Commercial Large Ticket 1 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR2MPG' , 'COMMERCIAL LARGE TKT RII' , 1 , 1.0 , 0.0 , null , 
    'E2' , 'Commercial Large Ticket 2 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR2MPG' , 'COMMERCIAL LARGE TKT RII' , 1 , null, null, null , 
    'E2' , 'Commercial Large Ticket 2 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR3MPG' , 'COMMERCIAL LARGE TKT RIII' , 1 , 0.9 , 0.0 , null , 
    'E3' , 'Commercial Large Ticket 3 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCLTR3MPG' , 'COMMERCIAL LARGE TKT RIII' , 1 , null, null, null , 
    'E3' , 'Commercial Large Ticket 3 MPG - Business World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCODR3' , 'CORPORATE DATA RATE 3' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Corporate' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCODR3' , 'CORPORATE DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Corporate' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCOMEP' , 'MC US COMMERCIAL ELEC PAYMENT' , 1 , 0.19 , 0.53 , null , 
    '82' , 'Commercial Electronic Payment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCOMEP' , 'MC US COMMERCIAL ELEC PAYMENT' , 1 , null, null, null , 
    '82' , 'Commercial Electronic Payment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVECM1INS' , 'MC US CONS CREDIT CORE VALUE M' , 1 , 1.43 , 0.05 , null , 
    '78' , 'Consumer Credit Merit I Insurance - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVECM1INS' , 'MC US CONS CREDIT CORE VALUE M' , 1 , null, null, null , 
    '78' , 'Consumer Credit Merit I Insurance - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVECM1RELST' , 'MC US CONS CREDIT CORE VALUE M' , 1 , 1.1 , 0.0 , null , 
    '78' , 'Consumer Credit Merit I Real Estate - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVECM1RELST' , 'MC US CONS CREDIT CORE VALUE M' , 1 , null, null, null , 
    '78' , 'Consumer Credit Merit I Real Estate - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVM1INS' , 'CONS CRED CORE MERIT 1 INS' , 1 , 1.43 , 0.05 , null , 
    '78' , 'Consumer Credit Merit I Insurance' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVM1INS' , 'CONS CRED CORE MERIT 1 INS' , 1 , null, null, null , 
    '78' , 'Consumer Credit Merit I Insurance' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVM1RELST' , 'Cons Cred Core Merit1 RealEst' , 1 , 1.1 , 0.0 , null , 
    '78' , 'Consumer Credit Merit I Real Estate' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCONCVM1RELST' , 'Cons Cred Core Merit1 RealEst' , 1 , null, null, null , 
    '78' , 'Consumer Credit Merit I Real Estate' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCOSUPMKT' , 'CORPORATE SUPER MARKET' , 3 , 2.5 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCOSUPMKT' , 'CORPORATE SUPER MARKET' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAY' , 'MC US PAYMENT COMMERCIAL' , 1 , 0.19 , 0.53 , null , 
    '21' , 'Commercial Payment Transaction - US' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAY' , 'MC US PAYMENT COMMERCIAL' , 1 , null, null, null , 
    '21' , 'Commercial Payment Transaction - US' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAYBUS' , 'Business Payment Transaction' , 1 , 0.19 , 0.53 , null , 
    '21' , 'Commercial Payment Transaction - Business' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAYBUS' , 'Business Payment Transaction' , 1 , null, null, null , 
    '21' , 'Commercial Payment Transaction - Business' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAYLM' , 'Large Market Payment Txn' , 1 , 0.19 , 0.53 , null , 
    '21' , 'Commercial Payment Transaction - Large Market' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPAYLM' , 'Large Market Payment Txn' , 1 , null, null, null , 
    '21' , 'Commercial Payment Transaction - Large Market' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPUR' , 'MC CONV PURCHASE' , 2 , 1.9 , 0.0 , null , 
    '23' , 'Consumer Credit Convenience Purchases Base - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPUR' , 'MC CONV PURCHASE' , 2 , null, null, null , 
    '23' , 'Consumer Credit Convenience Purchases Base - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPURDR2' , 'COMMERCIAL DATA RATE 2 PUR' , 3 , 2.1 , 0.1 , null , 
    '67' , 'Commercial Purchasing Data Rate II - US' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPURDR2' , 'COMMERCIAL DATA RATE 2 PUR' , 3 , null, null, null , 
    '67' , 'Commercial Purchasing Data Rate II - US' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPURT1' , 'MC CONV PURCHASE TIER 1' , 1 , 1.35 , 0.0 , null , 
    'CP' , 'Consumer Credit Convenience Purchases Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCPURT1' , 'MC CONV PURCHASE TIER 1' , 1 , null, null, null , 
    'CP' , 'Consumer Credit Convenience Purchases Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREBATE' , 'COMMERCIAL REBATE' , 1 , 0.0 , 0.0 , null , 
    'EZ' , 'Commercial Rebate - US' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREBATE' , 'COMMERCIAL REBATE' , 1 , null, null, null , 
    'EZ' , 'Commercial Rebate - US' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG1BUS' , 'Business Refund Group 1' , 3 , 2.37 , 0.0 , null , 
    '39' , 'Commercial Refund Group 1 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG1BUS' , 'Business Refund Group 1' , 3 , null, null, null , 
    '39' , 'Commercial Refund Group 1 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG1LM' , 'LM Refund Group 1' , 3 , 2.37 , 0.0 , null , 
    '39' , 'Commercial Refund Group 1 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG1LM' , 'LM Refund Group 1' , 3 , null, null, null , 
    '39' , 'Commercial Refund Group 1 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG2BUS' , 'Business Refund Group 2' , 3 , 2.3 , 0.0 , null , 
    '40' , 'Commercial Refund Group 2 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG2BUS' , 'Business Refund Group 2' , 3 , null, null, null , 
    '40' , 'Commercial Refund Group 2 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG2LM' , 'LM Refund Group 2' , 3 , 2.3 , 0.0 , null , 
    '40' , 'Commercial Refund Group 2 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG2LM' , 'LM Refund Group 2' , 3 , null, null, null , 
    '40' , 'Commercial Refund Group 2 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG3BUS' , 'Business Refund Group 3' , 3 , 2.21 , 0.0 , null , 
    '41' , 'Commercial Refund Group 3 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG3BUS' , 'Business Refund Group 3' , 3 , null, null, null , 
    '41' , 'Commercial Refund Group 3 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG3LM' , 'LM Refund Group 3' , 3 , 2.21 , 0.0 , null , 
    '41' , 'Commercial Refund Group 3 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG3LM' , 'LM Refund Group 3' , 3 , null, null, null , 
    '41' , 'Commercial Refund Group 3 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG4BUS' , 'Business Refund Group 4' , 3 , 2.16 , 0.0 , null , 
    '42' , 'Commercial Refund Group 4 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG4BUS' , 'Business Refund Group 4' , 3 , null, null, null , 
    '42' , 'Commercial Refund Group 4 - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG4LM' , 'LM Refund Group 4' , 3 , 2.16 , 0.0 , null , 
    '42' , 'Commercial Refund Group 4 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCREFG4LM' , 'LM Refund Group 4' , 3 , null, null, null , 
    '42' , 'Commercial Refund Group 4 - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCST' , 'MC US CORPORATE STD' , 3 , 2.95 , 0.1 , null , 
    '65' , 'Commercial Core Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCST' , 'MC US CORPORATE STD' , 3 , null, null, null , 
    '65' , 'Commercial Core Level 1 - Business Core' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSTDBUS' , 'Business standard' , 3 , 2.95 , 0.1 , null , 
    '65' , 'Commercial Standard - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSTDBUS' , 'Business standard' , 3 , null, null, null , 
    '65' , 'Commercial Standard - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSTDLM' , 'Large Market standard' , 3 , 2.95 , 0.1 , null , 
    '65' , 'Commercial Standard - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSTDLM' , 'Large Market standard' , 3 , null, null, null , 
    '65' , 'Commercial Standard - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPBUS' , 'Business supermarket' , 3 , 2.2 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPBUS' , 'Business supermarket' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPLM' , 'Large Market supermarket' , 3 , 2.5 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPLM' , 'Large Market supermarket' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPMKT' , 'US COMMERCIAL SUPERMARKET' , 2 , 2.5 , 0.1 , null , 
    '72' , 'Commercial Supermarket' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCSUPMKT' , 'US COMMERCIAL SUPERMARKET' , 2 , null, null, null , 
    '72' , 'Commercial Supermarket' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE1' , 'MC US CORPORATE CARD T/E I' , 3 , 2.7 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE1' , 'MC US CORPORATE CARD T/E I' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE2' , 'MC US CORPORATE CARD T/E II' , 3 , 2.55 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE2' , 'MC US CORPORATE CARD T/E II' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE3' , 'MC US CORPORATE CARD T/E III' , 3 , 2.5 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTE3' , 'MC US CORPORATE CARD T/E III' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Corporate' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER1BUS' , 'Business TE Rate I' , 3 , 2.5 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER1BUS' , 'Business TE Rate I' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER1LM' , 'Large Market TE Rate 1' , 3 , 2.7 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER1LM' , 'Large Market TE Rate 1' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER2BUS' , 'Business TE Rate 2' , 3 , 2.35 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER2BUS' , 'Business TE Rate 2' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER2LM' , 'Large Market TE Rate 2' , 3 , 2.55 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER2LM' , 'Large Market TE Rate 2' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3AIRBUS' , 'Business TER3 Airline MCC' , 3 , 2.3 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III Airline MCCs - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3AIRBUS' , 'Business TER3 Airline MCC' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III Airline MCCs - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3AIRLM' , 'Large Market TER3 Airline MCC' , 3 , 2.43 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III Airline MCCs - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3AIRLM' , 'Large Market TER3 Airline MCC' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III Airline MCCs - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3BUS' , 'Business TE Rate 3' , 3 , 2.3 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Business' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3BUS' , 'Business TE Rate 3' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Business' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3LM' , 'Large Market TE Rate 3' , 3 , 2.5 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCTER3LM' , 'Large Market TE Rate 3' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Large Market' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCWHC' , 'MC US CORP WAREHOUSE' , 1 , 1.48 , 0.1 , null , 
    '91' , 'Consumer/Commercial Credit Warehouse Base' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCWHC' , 'MC US CORP WAREHOUSE' , 1 , null, null, null , 
    '91' , 'Consumer/Commercial Credit Warehouse Base' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCWHCT1' , 'MC US WAREHOUSE T1 CR' , 1 , 1.48 , 0.1 , null , 
    '16' , 'Consumer/Commercial Credit Warehouse Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UCWHCT1' , 'MC US WAREHOUSE T1 CR' , 1 , null, null, null , 
    '16' , 'Consumer/Commercial Credit Warehouse Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCPUR' , 'ENHANCED CONVENIENCE PURCHASES' , 2 , 1.9 , 0.0 , null , 
    'RL' , 'Consumer Credit Convenience Purchases Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCPUR' , 'ENHANCED CONVENIENCE PURCHASES' , 2 , null, null, null , 
    'RL' , 'Consumer Credit Convenience Purchases Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCPURT1' , 'ENHANCED CONV PURCH TIER1' , 1 , 1.35 , 0.0 , null , 
    'R9' , 'Consumer Credit Convenience Purchases Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCPURT1' , 'ENHANCED CONV PURCH TIER1' , 1 , null, null, null , 
    'R9' , 'Consumer Credit Convenience Purchases Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCWHC' , 'ENHANCED WAREHOUSE CLUB BASE' , 1 , 1.48 , 0.1 , null , 
    'RI' , 'Consumer Credit Warehouse Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCWHC' , 'ENHANCED WAREHOUSE CLUB BASE' , 1 , null, null, null , 
    'RI' , 'Consumer Credit Warehouse Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCWHCT1' , 'ENHANCED WAREHOUSE CLUB TIER 1' , 1 , 1.48 , 0.1 , null , 
    'RJ' , 'Consumer Credit Warehouse Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHCWHCT1' , 'ENHANCED WAREHOUSE CLUB TIER 1' , 1 , null, null, null , 
    'RJ' , 'Consumer Credit Warehouse Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHFUCAF' , 'ENHANCED FULL UCAF' , 2 , 1.93 , 0.1 , null , 
    'RO' , 'Consumer Credit Full UCAF - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHFUCAF' , 'ENHANCED FULL UCAF' , 2 , null, null, null , 
    'RO' , 'Consumer Credit Full UCAF - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHKEY' , 'ENHANCED KEY ENTERED' , 2 , 2.04 , 0.1 , null , 
    'RQ' , 'Consumer Credit Key-Entered - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHKEY' , 'ENHANCED KEY ENTERED' , 2 , null, null, null , 
    'RQ' , 'Consumer Credit Key-Entered - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM1' , 'ENHANCED MERIT I' , 2 , 2.04 , 0.1 , null , 
    'RP' , 'Consumer Credit Merit I - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM1' , 'ENHANCED MERIT I' , 2 , null, null, null , 
    'RP' , 'Consumer Credit Merit I - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM1RELST' , 'CONS ENHANCED MERIT 1 REAL EST' , 1 , 1.1 , 0.0 , null , 
    'RP' , 'Consumer Credit Merit I Real Estate - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM1RELST' , 'CONS ENHANCED MERIT 1 REAL EST' , 1 , null, null, null , 
    'RP' , 'Consumer Credit Merit I Real Estate - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3' , 'ENHANCED MERIT III BASE' , 1 , 1.73 , 0.1 , null , 
    'RA' , 'Consumer Credit Merit III Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3' , 'ENHANCED MERIT III BASE' , 1 , null, null, null , 
    'RA' , 'Consumer Credit Merit III Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T1' , 'ENHANCED MERIT III TIER I' , 1 , 1.43 , 0.1 , null , 
    'RB' , 'Consumer Credit Merit III Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T1' , 'ENHANCED MERIT III TIER I' , 1 , null, null, null , 
    'RB' , 'Consumer Credit Merit III Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T2' , 'ENHANCED MERIT III TIER II' , 1 , 1.48 , 0.1 , null , 
    'RC' , 'Consumer Credit Merit III Tier 2 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T2' , 'ENHANCED MERIT III TIER II' , 1 , null, null, null , 
    'RC' , 'Consumer Credit Merit III Tier 2 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T3' , 'ENHANCED MERIT III TIER III' , 1 , 1.55 , 0.1 , null , 
    'RD' , 'Consumer Credit Merit III Tier 3 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHM3T3' , 'ENHANCED MERIT III TIER III' , 1 , null, null, null , 
    'RD' , 'Consumer Credit Merit III Tier 3 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHMIINS' , 'ENHANCED MERIT 1 INS' , 1 , 1.43 , 0.05 , null , 
    'RP' , 'Consumer Credit Merit I Insurance - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHMIINS' , 'ENHANCED MERIT 1 INS' , 1 , null, null, null , 
    'RP' , 'Consumer Credit Merit I Insurance - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHMUCAF' , 'ENHANCED MERCHANT UCAF' , 1 , 1.83 , 0.1 , null , 
    'RN' , 'Consumer Credit Merchant UCAF - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHMUCAF' , 'ENHANCED MERCHANT UCAF' , 1 , null, null, null , 
    'RN' , 'Consumer Credit Merchant UCAF - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPBLSEC' , 'ENHANCED PUBIC SECTOR' , 1 , 1.55 , 0.1 , null , 
    'RK' , 'Consumer Credit Public Sector - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPBLSEC' , 'ENHANCED PUBIC SECTOR' , 1 , null, null, null , 
    'RK' , 'Consumer Credit Public Sector - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPETR' , 'ENHANCED PETROLEUM BASE' , 1 , 1.9 , 0.0 ,  0.95 , 
    'RW' , 'Consumer Credit Petroleum Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPETR' , 'ENHANCED PETROLEUM BASE' , 1 , null, null, null , 
    'RW' , 'Consumer Credit Petroleum Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPETRC' , 'ENHANCED PETROLEUM BASE CAP' , 1 , 1.9 , 0.0 ,  0.95 , 
    'RW' , 'Consumer Credit Petroleum Base Cap - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPETRC' , 'ENHANCED PETROLEUM BASE CAP' , 1 , null, null, null , 
    'RW' , 'Consumer Credit Petroleum Base Cap - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPT' , 'ENHANCED PASSENGER TRANSPORT' , 2 , 1.9 , 0.1 , null , 
    'RR' , 'Consumer Credit Passenger Transport - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHPT' , 'ENHANCED PASSENGER TRANSPORT' , 2 , null, null, null , 
    'RR' , 'Consumer Credit Passenger Transport - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSIND' , 'ENHANCED SERVICE INDUSTRIES' , 1 , 1.15 , 0.05 , null , 
    'RM' , 'Consumer Credit Service Industries - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSIND' , 'ENHANCED SERVICE INDUSTRIES' , 1 , null, null, null , 
    'RM' , 'Consumer Credit Service Industries - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSTD' , 'ENHANCED STANDARD' , 3 , 2.95 , 0.1 , null , 
    'RU' , 'Consumer Credit Standard - Enhanced Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSTD' , 'ENHANCED STANDARD' , 3 , null, null, null , 
    'RU' , 'Consumer Credit Standard - Enhanced Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUP' , 'ENHANCED SUPERMARKET BASE' , 1 , 1.48 , 0.1 , null , 
    'RE' , 'Consumer Credit Supermarket Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUP' , 'ENHANCED SUPERMARKET BASE' , 1 , null, null, null , 
    'RE' , 'Consumer Credit Supermarket Base - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT1' , 'ENHANCED SUPERMARKET TIER 1' , 1 , 1.15 , 0.05 , null , 
    'RF' , 'Consumer Credit Supermarket Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT1' , 'ENHANCED SUPERMARKET TIER 1' , 1 , null, null, null , 
    'RF' , 'Consumer Credit Supermarket Tier 1 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT2' , 'ENHANCED SUPERMARKET TIER 2' , 1 , 1.15 , 0.05 , null , 
    'RG' , 'Consumer Credit Supermarket Tier 2 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT2' , 'ENHANCED SUPERMARKET TIER 2' , 1 , null, null, null , 
    'RG' , 'Consumer Credit Supermarket Tier 2 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT3' , 'ENHANCED SUPERMARKET TIER 3' , 1 , 1.22 , 0.05 , null , 
    'RH' , 'Consumer Credit Supermarket Tier 3 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHSUPT3' , 'ENHANCED SUPERMARKET TIER 3' , 1 , null, null, null , 
    'RH' , 'Consumer Credit Supermarket Tier 3 - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHTPR' , 'ENHANCED TRAVEL PREMIER SERV' , 2 , 1.8 , 0.1 , null , 
    'RS' , 'Consumer Credit Lodging and Auto Rental - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHTPR' , 'ENHANCED TRAVEL PREMIER SERV' , 2 , null, null, null , 
    'RS' , 'Consumer Credit Lodging and Auto Rental - Enhanced Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHUTIL' , 'ENHANCED UTILITIES' , 1 , 0.0 , 0.65 , null , 
    'RT' , 'Consumer Credit Utilities - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UENHUTIL' , 'ENHANCED UTILITIES' , 1 , null, null, null , 
    'RT' , 'Consumer Credit Utilities - Enhanced Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFLDR3' , 'FLEET DATA RATE 3' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFLDR3' , 'FLEET DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Fleet' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFLSUPMKT' , 'FLEET SUPER MARKET' , 3 , 2.5 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFLSUPMKT' , 'FLEET SUPER MARKET' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE1' , 'MC US FLEET CARD T/E I' , 3 , 2.7 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE1' , 'MC US FLEET CARD T/E I' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE2' , 'MC US FLEET CARD T/E II' , 3 , 2.55 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE2' , 'MC US FLEET CARD T/E II' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE3' , 'MC US FLEET CARD T/E III' , 3 , 2.5 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFTE3' , 'MC US FLEET CARD T/E III' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Fleet' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFUCAF' , 'MC US FULL UCAF CR' , 1 , 1.78 , 0.1 , null , 
    '79' , 'Consumer Credit Full UCAF - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UFUCAF' , 'MC US FULL UCAF CR' , 1 , null, null, null , 
    '79' , 'Consumer Credit Full UCAF - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UKEY' , 'MC KEY ENTERED' , 2 , 1.89 , 0.1 , null , 
    '92' , 'Consumer Credit Key-Entered - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UKEY' , 'MC KEY ENTERED' , 2 , null, null, null , 
    '92' , 'Consumer Credit Key-Entered - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1' , 'MC MERIT 1' , 2 , 1.89 , 0.1 , null , 
    '78' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1' , 'MC MERIT 1' , 2 , null, null, null , 
    '78' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1' , 'MC MERIT 1' , 2 , 1.89 , 0.1 , null , 
    '88' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1' , 'MC MERIT 1' , 2 , null, null, null , 
    '88' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1EC' , 'MC MERIT 1 ECOMMERCE' , 2 , 1.89 , 0.1 , null , 
    '98' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM1EC' , 'MC MERIT 1 ECOMMERCE' , 2 , null, null, null , 
    '98' , 'Consumer Credit Merit I - Core Value' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3' , 'MC MERIT 3' , 1 , 1.58 , 0.1 , null , 
    '70' , 'Consumer Credit Merit III Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3' , 'MC MERIT 3' , 1 , null, null, null , 
    '70' , 'Consumer Credit Merit III Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3' , 'MC MERIT 3' , 1 , 1.58 , 0.1 , null , 
    '80' , 'Consumer Credit Merit III Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3' , 'MC MERIT 3' , 1 , null, null, null , 
    '80' , 'Consumer Credit Merit III Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T1' , 'MC MERIT3 T1 CR' , 1 , 1.43 , 0.1 , null , 
    '10' , 'Consumer Credit Merit III Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T1' , 'MC MERIT3 T1 CR' , 1 , null, null, null , 
    '10' , 'Consumer Credit Merit III Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T2' , 'MC MERIT3 T2 CR' , 1 , 1.48 , 0.1 , null , 
    '11' , 'Consumer Credit Merit III Tier 2 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T2' , 'MC MERIT3 T2 CR' , 1 , null, null, null , 
    '11' , 'Consumer Credit Merit III Tier 2 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T3' , 'MC MERIT3 T3 CR' , 1 , 1.55 , 0.1 , null , 
    '12' , 'Consumer Credit Merit III Tier 3 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UM3T3' , 'MC MERIT3 T3 CR' , 1 , null, null, null , 
    '12' , 'Consumer Credit Merit III Tier 3 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UMUCAF' , 'MC US MERCH UCAF CR' , 1 , 1.68 , 0.1 , null , 
    '24' , 'Consumer Credit Merchant UCAF - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UMUCAF' , 'MC US MERCH UCAF CR' , 1 , null, null, null , 
    '24' , 'Consumer Credit Merchant UCAF - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPAY' , 'MC US PAYMENT' , 1 , 0.19 , 0.53 , null , 
    '20' , 'Consumer Credit Payment Transaction - US' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPAY' , 'MC US PAYMENT' , 1 , null, null, null , 
    '20' , 'Consumer Credit Payment Transaction - US' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPBLSEC' , 'MC PUBLIC SECTOR' , 1 , 1.55 , 0.1 , null , 
    '22' , 'Consumer Credit Public Sector - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPBLSEC' , 'MC PUBLIC SECTOR' , 1 , null, null, null , 
    '22' , 'Consumer Credit Public Sector - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPETR' , 'MC PETROLEUM BASE' , 1 , 1.9 , 0.0 ,  0.95 , 
    '61' , 'Consumer Credit Petroleum Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPETR' , 'MC PETROLEUM BASE' , 1 , null, null, null , 
    '61' , 'Consumer Credit Petroleum Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPETRC' , 'MC PETROLEUM CAP' , 1 , 1.9 , 0.0 ,  0.95 , 
    '61' , 'Consumer Credit Petroleum Base Cap - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPETRC' , 'MC PETROLEUM CAP' , 1 , null, null, null , 
    '61' , 'Consumer Credit Petroleum Base Cap - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPT' , 'MC PASS TRANSPORT' , 1 , 1.75 , 0.1 , null , 
    '93' , 'Consumer Credit Passenger Transport - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPT' , 'MC PASS TRANSPORT' , 1 , null, null, null , 
    '93' , 'Consumer Credit Passenger Transport - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE1' , 'MC US PURCASHING CARD T/E I' , 3 , 2.7 , 0.0 , null , 
    '76' , 'Commercial T/E Rate I - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE1' , 'MC US PURCASHING CARD T/E I' , 3 , null, null, null , 
    '76' , 'Commercial T/E Rate I - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE2' , 'MC US PURCASHING CARD T/E II' , 3 , 2.55 , 0.1 , null , 
    '69' , 'Commercial T/E Rate II - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE2' , 'MC US PURCASHING CARD T/E II' , 3 , null, null, null , 
    '69' , 'Commercial T/E Rate II - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE3' , 'MC US PURCHASING CARD T/E III' , 3 , 2.5 , 0.1 , null , 
    '89' , 'Commercial T/E Rate III - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPTE3' , 'MC US PURCHASING CARD T/E III' , 3 , null, null, null , 
    '89' , 'Commercial T/E Rate III - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPUDR3' , 'PURCHASING DATA RATE 3' , 2 , 1.8 , 0.1 , null , 
    '66' , 'Commercial Data Rate III - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPUDR3' , 'PURCHASING DATA RATE 3' , 2 , null, null, null , 
    '66' , 'Commercial Data Rate III - Purchasing' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPUSUPMKT' , 'PURCHASING SUPER MARKET' , 3 , 2.5 , 0.1 , null , 
    '72' , 'Commercial Supermarket - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UPUSUPMKT' , 'PURCHASING SUPER MARKET' , 3 , null, null, null , 
    '72' , 'Commercial Supermarket - Purchasing' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR1' , 'MC US CORPORATE REFUND GR1' , 3 , 2.37 , 0.0 , null , 
    '39' , 'Commercial Refund Group 1' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR1' , 'MC US CORPORATE REFUND GR1' , 3 , null, null, null , 
    '39' , 'Commercial Refund Group 1' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR2' , 'MC US CORPORATE REFUND GR2' , 3 , 2.3 , 0.0 , null , 
    '40' , 'Commercial Refund Group 2' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR2' , 'MC US CORPORATE REFUND GR2' , 3 , null, null, null , 
    '40' , 'Commercial Refund Group 2' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR3' , 'MC US CORPORATE REFUND GR3' , 3 , 2.21 , 0.0 , null , 
    '41' , 'Commercial Refund Group 3' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR3' , 'MC US CORPORATE REFUND GR3' , 3 , null, null, null , 
    '41' , 'Commercial Refund Group 3' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR4' , 'MC US CORPORATE REFUND GR4' , 3 , 2.16 , 0.0 , null , 
    '42' , 'Commercial Refund Group 4' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCR4' , 'MC US CORPORATE REFUND GR4' , 3 , null, null, null , 
    '42' , 'Commercial Refund Group 4' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS1' , 'MC US CR CONSUMER REFUND GR1' , 3 , 2.42 , 0.0 , null , 
    '34' , 'Consumer Credit Refund Group 1' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS1' , 'MC US CR CONSUMER REFUND GR1' , 3 , null, null, null , 
    '34' , 'Consumer Credit Refund Group 1' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS2' , 'MC US CR CONSUMER REFUND GR2' , 2 , 2.09 , 0.0 , null , 
    '35' , 'Consumer Credit Refund Group 2' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS2' , 'MC US CR CONSUMER REFUND GR2' , 2 , null, null, null , 
    '35' , 'Consumer Credit Refund Group 2' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS3' , 'MC US CR CONSUMER REFUND GR3' , 2 , 1.95 , 0.0 , null , 
    '36' , 'Consumer Credit Refund Group 3' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS3' , 'MC US CR CONSUMER REFUND GR3' , 2 , null, null, null , 
    '36' , 'Consumer Credit Refund Group 3' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS4' , 'MC US CR CONSUMER REFUND GR4' , 2 , 1.82 , 0.0 , null , 
    '37' , 'Consumer Credit Refund Group 4' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS4' , 'MC US CR CONSUMER REFUND GR4' , 2 , null, null, null , 
    '37' , 'Consumer Credit Refund Group 4' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS5' , 'MC US CR CONSUMER REFUND GR5' , 1 , 1.73 , 0.0 , null , 
    '38' , 'Consumer Credit Refund Group 5' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UREFCS5' , 'MC US CR CONSUMER REFUND GR5' , 1 , null, null, null , 
    '38' , 'Consumer Credit Refund Group 5' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPD' , 'REGULATED POS DEBIT' , 1 , 0.05 , 0.21 , null , 
    'LD' , 'Regulated POS Debit' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPD' , 'REGULATED POS DEBIT' , 1 , null, null, null , 
    'LD' , 'Regulated POS Debit' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDFA' , 'REG POS DEBIT W FRAUD ADJ' , 1 , 0.05 , 0.22 , null , 
    'LF' , 'Regulated POS Debit with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDFA' , 'REG POS DEBIT W FRAUD ADJ' , 1 , null, null, null , 
    'LF' , 'Regulated POS Debit with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDSM' , 'MC REG POS DEBIT ST BASE' , 1 , 0.05 , 0.21 , null , 
    'LS' , 'Regulated POS Debit Small Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDSM' , 'MC REG POS DEBIT ST BASE' , 1 , null, null, null , 
    'LS' , 'Regulated POS Debit Small Ticket' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDSMT1' , 'MC REG POS DEBIT ST TIER 1' , 1 , 0.05 , 0.22 , null , 
    'LT' , 'Regulated POS Debit Small Ticket with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105URPDSMT1' , 'MC REG POS DEBIT ST TIER 1' , 1 , null, null, null , 
    'LT' , 'Regulated POS Debit Small Ticket with Fraud Adjustment' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCH' , 'MC US CHARITY' , 2 , 2.0 , 0.1 , null , 
    'CH' , 'Charity - US' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCH' , 'MC US CHARITY' , 2 , null, null, null , 
    'CH' , 'Charity - US' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCHCONDBPP' , 'MC US Charity' , 1 , 1.45 , 0.15 , null , 
    'CH' , 'Charity - US Debit/Prepaid' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCHCONDBPP' , 'MC US Charity' , 1 , null, null, null , 
    'CH' , 'Charity - US Debit/Prepaid' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAY' , 'MC US Commercial Pay' , 1 , 1.2 , 0.0 , null , 
    'E6' , 'Commercial Payments Account' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAY' , 'MC US Commercial Pay' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT1' , 'Commercial Pay LT1' , 1 , 1.2 , 0.0 , null , 
    'E6' , 'Commercial Payments Account - Large Ticket 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT1' , 'Commercial Pay LT1' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account - Large Ticket 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT2' , 'Commercial Pay LT2' , 1 , 1.0 , 0.0 , null , 
    'E6' , 'Commercial Payments Account - Large Ticket 2' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT2' , 'Commercial Pay LT2' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account - Large Ticket 2' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT3' , 'Commercial Pay LT3' , 1 , 0.9 , 0.0 , null , 
    'E6' , 'Commercial Payments Account - Large Ticket 3' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT3' , 'Commercial Pay LT3' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account - Large Ticket 3' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT4' , 'Commercial Pay LT4' , 1 , 0.8 , 0.0 , null , 
    'E6' , 'Commercial Payments Account - Large Ticket 4' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT4' , 'Commercial Pay LT4' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account - Large Ticket 4' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT5' , 'Commercial Pay LT5' , 1 , 0.7 , 0.0 , null , 
    'E6' , 'Commercial Payments Account - Large Ticket 5' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USCOMMPAYLT5' , 'Commercial Pay LT5' , 1 , null, null, null , 
    'E6' , 'Commercial Payments Account - Large Ticket 5' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USIND' , 'MC SERVICE INDUSTRY' , 1 , 1.15 , 0.05 , null , 
    '90' , 'Consumer Credit Service Industries - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USIND' , 'MC SERVICE INDUSTRY' , 1 , null, null, null , 
    '90' , 'Consumer Credit Service Industries - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , 2.95 , 0.1 , null , 
    '75' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , null, null, null , 
    '75' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , 2.95 , 0.1 , null , 
    '85' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , null, null, null , 
    '85' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , 2.95 , 0.1 , null , 
    '95' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTD' , 'MC STANDARD' , 3 , null, null, null , 
    '95' , 'Consumer Credit Standard - Core Value' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTDEC' , 'MC STANDARD EC' , 3 , 2.95 , 0.1 , null , 
    '95' , 'Consumer Credit Electronic Standard' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USTDEC' , 'MC STANDARD EC' , 3 , null, null, null , 
    '95' , 'Consumer Credit Electronic Standard' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUP' , 'MC SUPERMARKET' , 1 , 1.48 , 0.1 , null , 
    '71' , 'Consumer Credit Supermarket Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUP' , 'MC SUPERMARKET' , 1 , null, null, null , 
    '71' , 'Consumer Credit Supermarket Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUP' , 'MC SUPERMARKET' , 1 , 1.48 , 0.1 , null , 
    '81' , 'Consumer Credit Supermarket Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUP' , 'MC SUPERMARKET' , 1 , null, null, null , 
    '81' , 'Consumer Credit Supermarket Base - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT1' , 'MC SUPM T1 CR' , 1 , 1.15 , 0.05 , null , 
    '13' , 'Consumer Credit Supermarket Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT1' , 'MC SUPM T1 CR' , 1 , null, null, null , 
    '13' , 'Consumer Credit Supermarket Tier 1 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT2' , 'MC SUPM T2 CR' , 1 , 1.15 , 0.05 , null , 
    '14' , 'Consumer Credit Supermarket Tier 2 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT2' , 'MC SUPM T2 CR' , 1 , null, null, null , 
    '14' , 'Consumer Credit Supermarket Tier 2 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT3' , 'MC SUPM T3 CR' , 1 , 1.22 , 0.05 , null , 
    '15' , 'Consumer Credit Supermarket Tier 3 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105USUPT3' , 'MC SUPM T3 CR' , 1 , null, null, null , 
    '15' , 'Consumer Credit Supermarket Tier 3 - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UTPR' , 'MC TRAVEL PREMIER' , 1 , 1.58 , 0.1 , null , 
    '97' , 'Consumer Credit Lodging and Auto Rental - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UTPR' , 'MC TRAVEL PREMIER' , 1 , null, null, null , 
    '97' , 'Consumer Credit Lodging and Auto Rental - Core Value' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILCR' , 'MC US UTILITY CR' , 1 , 0.0 , 0.65 , null , 
    'CU' , 'Consumer Credit Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILCR' , 'MC US UTILITY CR' , 1 , null, null, null , 
    'CU' , 'Consumer Credit Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILDB' , 'MC US UTILITY DB' , 1 , 0.0 , 0.45 , null , 
    'CU' , 'Consumer Debit Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILDB' , 'MC US UTILITY DB' , 1 , null, null, null , 
    'CU' , 'Consumer Debit Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILPP' , 'MC US UTILITY PREPAID' , 1 , 0.0 , 0.65 , null , 
    'CU' , 'Consumer Prepaid Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UUTILPP' , 'MC US UTILITY PREPAID' , 1 , null, null, null , 
    'CU' , 'Consumer Prepaid Utilities' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCAIRL' , 'MC US MWE AIRLINE' , 3 , 2.3 , 0.1 , null , 
    'WU' , 'Consumer Credit Airline - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCAIRL' , 'MC US MWE AIRLINE' , 3 , null, null, null , 
    'WU' , 'Consumer Credit Airline - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCCPUR' , 'MC US MWE CONV PURCH' , 2 , 2.0 , 0.0 , null , 
    'WH' , 'Consumer Credit Convenience Purchases Base - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCCPUR' , 'MC US MWE CONV PURCH' , 2 , null, null, null , 
    'WH' , 'Consumer Credit Convenience Purchases Base - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCCPURT1' , 'MC CONV PURCHASE TIER 1' , 1 , 1.6 , 0.0 , null , 
    'W9' , 'Consumer Credit Convenience Purchases Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCCPURT1' , 'MC CONV PURCHASE TIER 1' , 1 , null, null, null , 
    'W9' , 'Consumer Credit Convenience Purchases Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCFUCAF' , 'MC US MWE FULL UCAF' , 3 , 2.4 , 0.1 , null , 
    'WT' , 'Consumer Credit Full UCAF - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCFUCAF' , 'MC US MWE FULL UCAF' , 3 , null, null, null , 
    'WT' , 'Consumer Credit Full UCAF - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCKEY' , 'MC US MWE KEY ENTERED' , 3 , 2.5 , 0.1 , null , 
    'WC' , 'Consumer Credit Key-Entered - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCKEY' , 'MC US MWE KEY ENTERED' , 3 , null, null, null , 
    'WC' , 'Consumer Credit Key-Entered - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1' , 'MC US MWE MERIT 1' , 3 , 2.5 , 0.1 , null , 
    'WB' , 'Consumer Credit Merit I - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1' , 'MC US MWE MERIT 1' , 3 , null, null, null , 
    'WB' , 'Consumer Credit Merit I - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1INS' , 'WORLD ELITE MERIT 1 INS' , 3 , 2.2 , 0.1 , null , 
    'WB' , 'Consumer Credit Merit I Insurance - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1INS' , 'WORLD ELITE MERIT 1 INS' , 3 , null, null, null , 
    'WB' , 'Consumer Credit Merit I Insurance - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1RELST' , 'World Elite Merit1 Real Est' , 3 , 2.2 , 0.1 , null , 
    'WB' , 'Consumer Credit Merit I Real Estate - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM1RELST' , 'World Elite Merit1 Real Est' , 3 , null, null, null , 
    'WB' , 'Consumer Credit Merit I Real Estate - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3' , 'MC US MWE MERIT 3' , 3 , 2.2 , 0.1 , null , 
    'WD' , 'Consumer Credit Merit III Base - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3' , 'MC US MWE MERIT 3' , 3 , null, null, null , 
    'WD' , 'Consumer Credit Merit III Base - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T1' , 'MC US MWE MERIT 3 T1' , 2 , 2.05 , 0.1 , null , 
    'WE' , 'Consumer Credit Merit III Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T1' , 'MC US MWE MERIT 3 T1' , 2 , null, null, null , 
    'WE' , 'Consumer Credit Merit III Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T2' , 'MC US MWE MERIT 3 T2' , 2 , 2.1 , 0.1 , null , 
    'WF' , 'Consumer Credit Merit III Tier 2 - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T2' , 'MC US MWE MERIT 3 T2' , 2 , null, null, null , 
    'WF' , 'Consumer Credit Merit III Tier 2 - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T3' , 'MC US MWE MERIT 3 T3' , 3 , 2.15 , 0.1 , null , 
    'WG' , 'Consumer Credit Merit III Tier 3 - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCM3T3' , 'MC US MWE MERIT 3 T3' , 3 , null, null, null , 
    'WG' , 'Consumer Credit Merit III Tier 3 - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCMUCAF' , 'MC US MWE MERCH UCAF' , 3 , 2.3 , 0.1 , null , 
    'WS' , 'Consumer Credit Merchant UCAF - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCMUCAF' , 'MC US MWE MERCH UCAF' , 3 , null, null, null , 
    'WS' , 'Consumer Credit Merchant UCAF - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPETR' , 'MC PETROLEUM BASE' , 1 , 2.0 , 0.0 ,  0.95 , 
    'WX' , 'Consumer Credit Petroleum Base - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPETR' , 'MC PETROLEUM BASE' , 1 , null, null, null , 
    'WX' , 'Consumer Credit Petroleum Base - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPETRC' , 'MC PETROLEUM CAP' , 1 , 2.0 , 0.0 ,  0.95 , 
    'WX' , 'Consumer Credit Petroleum Base Cap - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPETRC' , 'MC PETROLEUM CAP' , 1 , null, null, null , 
    'WX' , 'Consumer Credit Petroleum Base Cap - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPUBLSE' , 'MC US MWE PUBLIC SEC' , 1 , 1.55 , 0.1 , null , 
    'WP' , 'Consumer Credit Public Sector - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCPUBLSE' , 'MC US MWE PUBLIC SEC' , 1 , null, null, null , 
    'WP' , 'Consumer Credit Public Sector - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCREST' , 'MC US MWE RESTAURANT' , 3 , 2.2 , 0.1 , null , 
    'WQ' , 'Consumer Credit Restaurant - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCREST' , 'MC US MWE RESTAURANT' , 3 , null, null, null , 
    'WQ' , 'Consumer Credit Restaurant - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSIND' , 'MC US MWE SERVICE IND' , 1 , 1.15 , 0.05 , null , 
    'WO' , 'Consumer Credit Service Industries - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSIND' , 'MC US MWE SERVICE IND' , 1 , null, null, null , 
    'WO' , 'Consumer Credit Service Industries - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSTD' , 'MC US MWE STANDARD' , 3 , 3.25 , 0.1 , null , 
    'WA' , 'Consumer Credit Standard - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSTD' , 'MC US MWE STANDARD' , 3 , null, null, null , 
    'WA' , 'Consumer Credit Standard - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUP' , 'MC US MWE SUPERMARKET' , 2 , 1.9 , 0.1 , null , 
    'WI' , 'Consumer Credit Supermarket Base - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUP' , 'MC US MWE SUPERMARKET' , 2 , null, null, null , 
    'WI' , 'Consumer Credit Supermarket Base - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT1' , 'MC US MWE SUPERMARKET T1' , 1 , 1.25 , 0.05 , null , 
    'WJ' , 'Consumer Credit Supermarket Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT1' , 'MC US MWE SUPERMARKET T1' , 1 , null, null, null , 
    'WJ' , 'Consumer Credit Supermarket Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT2' , 'MC US MWE SUPERMARKET T2' , 1 , 1.25 , 0.05 , null , 
    'WK' , 'Consumer Credit Supermarket Tier 2 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT2' , 'MC US MWE SUPERMARKET T2' , 1 , null, null, null , 
    'WK' , 'Consumer Credit Supermarket Tier 2 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT3' , 'MC US MWE SUPERMARKET T3' , 1 , 1.32 , 0.05 , null , 
    'WL' , 'Consumer Credit Supermarket Tier 3 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCSUPT3' , 'MC US MWE SUPERMARKET T3' , 1 , null, null, null , 
    'WL' , 'Consumer Credit Supermarket Tier 3 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCTELT' , 'WORLD ELITE T/E LARGE TICKET' , 2 , 2.0 , 0.0 , null , 
    'WZ' , 'Consumer Credit T/E Large Ticket - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCTELT' , 'WORLD ELITE T/E LARGE TICKET' , 2 , null, null, null , 
    'WZ' , 'Consumer Credit T/E Large Ticket - World Elite' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCTNE' , 'MC US MWE TNE' , 3 , 2.75 , 0.1 , null , 
    'WR' , 'Consumer Credit T/E - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCTNE' , 'MC US MWE TNE' , 3 , null, null, null , 
    'WR' , 'Consumer Credit T/E - World Elite' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCUTIL' , 'MC US MWE UTILITY' , 1 , 0.0 , 0.75 , null , 
    'WV' , 'Consumer Credit Utilities - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCUTIL' , 'MC US MWE UTILITY' , 1 , null, null, null , 
    'WV' , 'Consumer Credit Utilities - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCWHCT' , 'MC US MWE WAREHOUSE' , 1 , 1.9 , 0.1 , null , 
    'WM' , 'Consumer Credit Warehouse Base - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCWHCT' , 'MC US MWE WAREHOUSE' , 1 , null, null, null , 
    'WM' , 'Consumer Credit Warehouse Base - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCWHCT1' , 'MC US MWE WAREHOUSE T1' , 1 , 1.9 , 0.1 , null , 
    'WN' , 'Consumer Credit Warehouse Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWEMCWHCT1' , 'MC US MWE WAREHOUSE T1' , 1 , null, null, null , 
    'WN' , 'Consumer Credit Warehouse Tier 1 - World Elite' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMC' , 'MC WORLD MASTERCARD' , 3 , 2.3 , 0.1 , null , 
    '96' , 'Consumer Credit T/E - World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMC' , 'MC WORLD MASTERCARD' , 3 , null, null, null , 
    '96' , 'Consumer Credit T/E - World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCCPUR' , 'MC US MCW CONV PURCHASE' , 2 , 2.0 , 0.0 , null , 
    '06' , 'Consumer Credit Convenience Purchases Base - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCCPUR' , 'MC US MCW CONV PURCHASE' , 2 , null, null, null , 
    '06' , 'Consumer Credit Convenience Purchases Base - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCCPURT1' , 'MC US MCW CONV PURCHASE TIER 1' , 1 , 1.45 , 0.0 , null , 
    'C9' , 'World Convenience Purchases Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCCPURT1' , 'MC US MCW CONV PURCHASE TIER 1' , 1 , null, null, null , 
    'C9' , 'World Convenience Purchases Tier 1' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCFUCAF' , 'MC US MCW FULL UCAF' , 2 , 1.97 , 0.1 , null , 
    '53' , 'Consumer Credit Full UCAF - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCFUCAF' , 'MC US MCW FULL UCAF' , 2 , null, null, null , 
    '53' , 'Consumer Credit Full UCAF - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCKEY' , 'MC US MCW KEY ENTERED' , 2 , 2.05 , 0.1 , null , 
    '03' , 'Consumer Credit Key-Entered  - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCKEY' , 'MC US MCW KEY ENTERED' , 2 , null, null, null , 
    '03' , 'Consumer Credit Key-Entered  - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1' , 'MC US MCW MERIT 1' , 2 , 2.05 , 0.1 , null , 
    '02' , 'Consumer Credit Merit I - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1' , 'MC US MCW MERIT 1' , 2 , null, null, null , 
    '02' , 'Consumer Credit Merit I - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1INS' , 'CONS WORLD MERIT 1 INS' , 1 , 1.43 , 0.05 , null , 
    '02' , 'Consumer Credit Merit I Insurance - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1INS' , 'CONS WORLD MERIT 1 INS' , 1 , null, null, null , 
    '02' , 'Consumer Credit Merit I Insurance - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1RELST' , 'CONS WORLD MERIT 1 REAL EST' , 1 , 1.1 , 0.0 , null , 
    '02' , 'Consumer Credit Merit I Real Estate - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM1RELST' , 'CONS WORLD MERIT 1 REAL EST' , 1 , null, null, null , 
    '02' , 'Consumer Credit Merit I Real Estate - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3' , 'MC US MCW MERIT 3' , 1 , 1.77 , 0.1 , null , 
    '04' , 'Consumer Credit Merit III Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3' , 'MC US MCW MERIT 3' , 1 , null, null, null , 
    '04' , 'Consumer Credit Merit III Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T1' , 'MC US MCW MERIT 1 T1' , 1 , 1.53 , 0.1 , null , 
    '05' , 'Consumer Credit Merit III Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T1' , 'MC US MCW MERIT 1 T1' , 1 , null, null, null , 
    '05' , 'Consumer Credit Merit III Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T2' , 'MC US MCW MERIT 3 T2' , 1 , 1.58 , 0.1 , null , 
    '19' , 'Consumer Credit Merit III Tier 2 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T2' , 'MC US MCW MERIT 3 T2' , 1 , null, null, null , 
    '19' , 'Consumer Credit Merit III Tier 2 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T3' , 'MC US MCW MERIT 3 T3' , 1 , 1.65 , 0.1 , null , 
    '30' , 'Consumer Credit Merit III Tier 3 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCM3T3' , 'MC US MCW MERIT 3 T3' , 1 , null, null, null , 
    '30' , 'Consumer Credit Merit III Tier 3 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCMUCAF' , 'MC US MCW MERCH UCAF' , 1 , 1.87 , 0.1 , null , 
    '52' , 'Consumer Credit Merchant UCAF - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCMUCAF' , 'MC US MCW MERCH UCAF' , 1 , null, null, null , 
    '52' , 'Consumer Credit Merchant UCAF - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPETR' , 'MC PETROLEUM BASE' , 2 , 2.0 , 0.0 ,  0.95 , 
    '45' , 'Consumer Credit Petroleum Base - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPETR' , 'MC PETROLEUM BASE' , 2 , null, null, null , 
    '45' , 'Consumer Credit Petroleum Base - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPETRC' , 'MC PETROLEUM CAP' , 2 , 2.0 , 0.0 ,  0.95 , 
    '45' , 'Consumer Credit Petroleum Base Cap - World' , '05' , 'MC_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPETRC' , 'MC PETROLEUM CAP' , 2 , null, null, null , 
    '45' , 'Consumer Credit Petroleum Base Cap - World' , '05' , 'MC_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPUBLSEC' , 'MC US MCW PUBLIC SECTOR' , 1 , 1.55 , 0.1 , null , 
    '56' , 'Consumer Credit Public Sector - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCPUBLSEC' , 'MC US MCW PUBLIC SECTOR' , 1 , null, null, null , 
    '56' , 'Consumer Credit Public Sector - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCREST' , 'MC US MCW RESTAURANT' , 1 , 1.73 , 0.1 , null , 
    '58' , 'Consumer Credit Restaurant - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCREST' , 'MC US MCW RESTAURANT' , 1 , null, null, null , 
    '58' , 'Consumer Credit Restaurant - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSIND' , 'MC US MCW SERVICE IND' , 1 , 1.15 , 0.05 , null , 
    '55' , 'Consumer Credit Service Industries - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSIND' , 'MC US MCW SERVICE IND' , 1 , null, null, null , 
    '55' , 'Consumer Credit Service Industries - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSTD' , 'MC US MCW STANDARD' , 3 , 2.95 , 0.1 , null , 
    '01' , 'Consumer Credit Standard - World' , '05' , 'MC_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSTD' , 'MC US MCW STANDARD' , 3 , null, null, null , 
    '01' , 'Consumer Credit Standard - World' , '05' , 'MC_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUP' , 'MC US MCW SUPERMARKET BASE' , 1 , 1.58 , 0.1 , null , 
    '07' , 'Consumer Credit Supermarket Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUP' , 'MC US MCW SUPERMARKET BASE' , 1 , null, null, null , 
    '07' , 'Consumer Credit Supermarket Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT1' , 'MC US MCW SUPERMARKET' , 1 , 1.25 , 0.05 , null , 
    '08' , 'Consumer Credit Supermarket Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT1' , 'MC US MCW SUPERMARKET' , 1 , null, null, null , 
    '08' , 'Consumer Credit Supermarket Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT2' , 'MC US MCW SUPERMARKET T2' , 1 , 1.25 , 0.05 , null , 
    '77' , 'Consumer Credit Supermarket Tier 2 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT2' , 'MC US MCW SUPERMARKET T2' , 1 , null, null, null , 
    '77' , 'Consumer Credit Supermarket Tier 2 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT3' , 'MC US MCW SUPERMARKET T3' , 1 , 1.32 , 0.05 , null , 
    '64' , 'Consumer Credit Supermarket Tier 3 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCSUPT3' , 'MC US MCW SUPERMARKET T3' , 1 , null, null, null , 
    '64' , 'Consumer Credit Supermarket Tier 3 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCUTIL' , 'MC US WORLD UTILITY' , 1 , 0.0 , 0.65 , null , 
    'CW' , 'Consumer Credit Utilities - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCUTIL' , 'MC US WORLD UTILITY' , 1 , null, null, null , 
    'CW' , 'Consumer Credit Utilities - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCWHCT' , 'MC US MCW WAREHOUSE BASE' , 1 , 1.58 , 0.1 , null , 
    '09' , 'Consumer Credit Warehouse Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCWHCT' , 'MC US MCW WAREHOUSE BASE' , 1 , null, null, null , 
    '09' , 'Consumer Credit Warehouse Base - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCWHCT1' , 'MC US MCW WAREHOUSE T1' , 1 , 1.58 , 0.1 , null , 
    '54' , 'Consumer Credit Warehouse Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0105UWMCWHCT1' , 'MC US MCW WAREHOUSE T1' , 1 , null, null, null , 
    '54' , 'Consumer Credit Warehouse Tier 1 - World' , '05' , 'MC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
