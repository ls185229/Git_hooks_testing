-- Number of arguments: 2 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'U.S._Interchange_Fees_for_April_2016_(04-14-2016).xls']
rem gathering mas_codes from spreadsheet

-- delete FLMGR_ICHG_RATES_TEMPLATE;


rem Discover



rem Visa



rem MasterCard


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
-- Number of arguments: 2 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'U.S._AMEX_Discount_fees_-_External_April_2016_(04-07-2016).xls']
rem gathering mas_codes from spreadsheet

delete FLMGR_ICHG_RATES_TEMPLATE;


rem AMEX


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B1' , 'AX B2B WHLSL TIER 1' , 1 , 1.55 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B1' , 'AX B2B WHLSL TIER 1' , 1 , null, null, null ,
    '' , 'B2B / Wholesale Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B1CNP' , 'AX B2B WHLSL TIER 1 CNP' , 1 , 1.85 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B1CNP' , 'AX B2B WHLSL TIER 1 CNP' , 1 , null, null, null ,
    '' , 'B2B / Wholesale Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B2' , 'AX B2B WHLSL TIER 2' , 2 , 1.8 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B2' , 'AX B2B WHLSL TIER 2' , 2 , null, null, null ,
    '' , 'B2B / Wholesale Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B2CNP' , 'AX B2B WHLSL TIER 2 CNP' , 2 , 2.1 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B2CNP' , 'AX B2B WHLSL TIER 2 CNP' , 2 , null, null, null ,
    '' , 'B2B / Wholesale Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B3' , 'AX B2B WHLSL TIER 3' , 3 , 2.25 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B3' , 'AX B2B WHLSL TIER 3' , 3 , null, null, null ,
    '' , 'B2B / Wholesale Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B3CNP' , 'AX B2B WHLSL TIER 3 CNP' , 3 , 2.55 , 0.1 , null ,
    '' , 'B2B / Wholesale Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103B2B3CNP' , 'AX B2B WHLSL TIER 3 CNP' , 3 , null, null, null ,
    '' , 'B2B / Wholesale Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT1' , 'AX CATERING TIER 1' , 1 , 1.9 , 0.04 , null ,
    '' , 'Catering / Drinking Places Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT1' , 'AX CATERING TIER 1' , 1 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT1CNP' , 'AX CATERING TIER 1 CNP' , 1 , 2.2 , 0.04 , null ,
    '' , 'Catering / Drinking Places Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT1CNP' , 'AX CATERING TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT2' , 'AX CATERING TIER 2' , 2 , 1.85 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT2' , 'AX CATERING TIER 2' , 2 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT2CNP' , 'AX CATERING TIER 2 CNP' , 2 , 2.15 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT2CNP' , 'AX CATERING TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT3' , 'AX CATERING TIER 3' , 3 , 2.45 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT3' , 'AX CATERING TIER 3' , 3 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT3CNP' , 'AX CATERING TIER 3 CNP' , 3 , 2.75 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT3CNP' , 'AX CATERING TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT4' , 'AX CATERING TIER 4' , 3 , 2.75 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT4' , 'AX CATERING TIER 4' , 3 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT4CNP' , 'AX CATERING TIER 4 CNP' , 3 , 3.05 , 0.1 , null ,
    '' , 'Catering / Drinking Places Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103CAT4CNP' , 'AX CATERING TIER 4 CNP' , 3 , null, null, null ,
    '' , 'Catering / Drinking Places Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH1' , 'AX HEALTHCARE TIER 1' , 1 , 1.55 , 0.1 , null ,
    '' , 'Healthcare Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH1' , 'AX HEALTHCARE TIER 1' , 1 , null, null, null ,
    '' , 'Healthcare Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH1CNP' , 'AX HEALTHCARE TIER 1 CNP' , 1 , 1.85 , 0.1 , null ,
    '' , 'Healthcare Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH1CNP' , 'AX HEALTHCARE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Healthcare Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH2' , 'AX HEALTHCARE TIER 2' , 2 , 1.85 , 0.1 , null ,
    '' , 'Healthcare Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH2' , 'AX HEALTHCARE TIER 2' , 2 , null, null, null ,
    '' , 'Healthcare Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH2CNP' , 'AX HEALTHCARE TIER 2 CNP' , 2 , 2.15 , 0.1 , null ,
    '' , 'Healthcare Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH2CNP' , 'AX HEALTHCARE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Healthcare Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH3' , 'AX HEALTHCARE TIER 3' , 3 , 2.3 , 0.1 , null ,
    '' , 'Healthcare Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH3' , 'AX HEALTHCARE TIER 3' , 3 , null, null, null ,
    '' , 'Healthcare Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH3CNP' , 'AX HEALTHCARE TIER 3 CNP' , 3 , 2.6 , 0.1 , null ,
    '' , 'Healthcare Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103HLTH3CNP' , 'AX HEALTHCARE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Healthcare Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B1' , 'AX INTL B2B WHLSL TIER 1' , 1 , 1.95 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B1' , 'AX INTL B2B WHLSL TIER 1' , 1 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B1CNP' , 'AX INTL B2B WHLSL TIER 1 CNP' , 1 , 2.25 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B1CNP' , 'AX INTL B2B WHLSL TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B2' , 'AX INTL B2B WHLSL TIER 2' , 2 , 2.2 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B2' , 'AX INTL B2B WHLSL TIER 2' , 2 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B2CNP' , 'AX INTL B2B WHLSL TIER 2 CNP' , 2 , 2.5 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B2CNP' , 'AX INTL B2B WHLSL TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B3' , 'AX INTL B2B WHLSL TIER 3' , 3 , 2.65 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B3' , 'AX INTL B2B WHLSL TIER 3' , 3 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B3CNP' , 'AX INTL B2B WHLSL TIER 3 CNP' , 3 , 2.95 , 0.1 , null ,
    '' , 'International B2B / Wholesale Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IB2B3CNP' , 'AX INTL B2B WHLSL TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International B2B / Wholesale Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT1' , 'AX INTL CATERING TIER 1' , 1 , 2.3 , 0.04 , null ,
    '' , 'International Catering / Drinking Places Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT1' , 'AX INTL CATERING TIER 1' , 1 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT1CNP' , 'AX INTL CATERING TIER 1 CNP' , 1 , 2.6 , 0.04 , null ,
    '' , 'International Catering / Drinking Places Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT1CNP' , 'AX INTL CATERING TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT2' , 'AX INTL CATERING TIER 2' , 2 , 2.25 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT2' , 'AX INTL CATERING TIER 2' , 2 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT2CNP' , 'AX INTL CATERING TIER 2 CNP' , 2 , 2.55 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT2CNP' , 'AX INTL CATERING TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT3' , 'AX INTL CATERING TIER 3' , 3 , 2.85 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT3' , 'AX INTL CATERING TIER 3' , 3 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT3CNP' , 'AX INTL CATERING TIER 3 CNP' , 3 , 3.15 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT3CNP' , 'AX INTL CATERING TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT4' , 'AX INTL CATERING TIER 4' , 3 , 3.15 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT4' , 'AX INTL CATERING TIER 4' , 3 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT4CNP' , 'AX INTL CATERING TIER 4 CNP' , 3 , 3.45 , 0.1 , null ,
    '' , 'International Catering / Drinking Places Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ICAT4CNP' , 'AX INTL CATERING TIER 4 CNP' , 3 , null, null, null ,
    '' , 'International Catering / Drinking Places Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH1' , 'AX INTL HEALTHCARE TIER 1' , 1 , 1.95 , 0.1 , null ,
    '' , 'International Healthcare Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH1' , 'AX INTL HEALTHCARE TIER 1' , 1 , null, null, null ,
    '' , 'International Healthcare Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH1CNP' , 'AX INTL HEALTHCARE TIER 1 CNP' , 1 , 2.25 , 0.1 , null ,
    '' , 'International Healthcare Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH1CNP' , 'AX INTL HEALTHCARE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Healthcare Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH2' , 'AX INTL HEALTHCARE TIER 2' , 2 , 2.25 , 0.1 , null ,
    '' , 'International Healthcare Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH2' , 'AX INTL HEALTHCARE TIER 2' , 2 , null, null, null ,
    '' , 'International Healthcare Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH2CNP' , 'AX INTL HEALTHCARE TIER 2 CNP' , 2 , 2.55 , 0.1 , null ,
    '' , 'International Healthcare Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH2CNP' , 'AX INTL HEALTHCARE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Healthcare Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH3' , 'AX INTL HEALTHCARE TIER 3' , 3 , 2.7 , 0.1 , null ,
    '' , 'International Healthcare Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH3' , 'AX INTL HEALTHCARE TIER 3' , 3 , null, null, null ,
    '' , 'International Healthcare Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH3CNP' , 'AX INTL HEALTHCARE TIER 3 CNP' , 3 , 3.0 , 0.1 , null ,
    '' , 'International Healthcare Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IHLTH3CNP' , 'AX INTL HEALTHCARE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Healthcare Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG1' , 'AX INTL LODG TIER 1' , 1 , 2.65 , 0.1 , null ,
    '' , 'International Lodging Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG1' , 'AX INTL LODG TIER 1' , 1 , null, null, null ,
    '' , 'International Lodging Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG1CNP' , 'AX INTL LODG TIER 1 CNP' , 1 , 2.95 , 0.1 , null ,
    '' , 'International Lodging Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG1CNP' , 'AX INTL LODG TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Lodging Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG2' , 'AX INTL LODG TIER 2' , 2 , 3.0 , 0.1 , null ,
    '' , 'International Lodging Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG2' , 'AX INTL LODG TIER 2' , 2 , null, null, null ,
    '' , 'International Lodging Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG2CNP' , 'AX INTL LODG TIER 2 CNP' , 2 , 3.3 , 0.1 , null ,
    '' , 'International Lodging Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG2CNP' , 'AX INTL LODG TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Lodging Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG3' , 'AX INTL LODG TIER 3' , 3 , 3.4 , 0.1 , null ,
    '' , 'International Lodging Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG3' , 'AX INTL LODG TIER 3' , 3 , null, null, null ,
    '' , 'International Lodging Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG3CNP' , 'AX INTL LODG TIER 3 CNP' , 3 , 3.7 , 0.1 , null ,
    '' , 'International Lodging Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ILODG3CNP' , 'AX INTL LODG TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Lodging Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO1' , 'AX INTL MOTO EC TIER 1' , 1 , 2.1 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO1' , 'AX INTL MOTO EC TIER 1' , 1 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO1CNP' , 'AX INTL MOTO EC TIER 1 CNP' , 1 , 2.4 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO1CNP' , 'AX INTL MOTO EC TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO2' , 'AX INTL MOTO EC TIER 2' , 2 , 2.45 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO2' , 'AX INTL MOTO EC TIER 2' , 2 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO2CNP' , 'AX INTL MOTO EC TIER 2 CNP' , 2 , 2.75 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO2CNP' , 'AX INTL MOTO EC TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO3' , 'AX INTL MOTO EC TIER 3' , 3 , 2.9 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO3' , 'AX INTL MOTO EC TIER 3' , 3 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO3CNP' , 'AX INTL MOTO EC TIER 3 CNP' , 3 , 3.2 , 0.1 , null ,
    '' , 'International Mail Order / Internet Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IMOTO3CNP' , 'AX INTL MOTO EC TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Mail Order / Internet Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH1' , 'AX INTL OTHER TIER 1' , 1 , 1.9 , 0.1 , null ,
    '' , 'International Other Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH1' , 'AX INTL OTHER TIER 1' , 1 , null, null, null ,
    '' , 'International Other Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH1CNP' , 'AX INTL OTHER TIER 1 CNP' , 1 , 2.2 , 0.1 , null ,
    '' , 'International Other Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH1CNP' , 'AX INTL OTHER TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Other Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH2' , 'AX INTL OTHER TIER 2' , 2 , 2.25 , 0.1 , null ,
    '' , 'International Other Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH2' , 'AX INTL OTHER TIER 2' , 2 , null, null, null ,
    '' , 'International Other Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH2CNP' , 'AX INTL OTHER TIER 2 CNP' , 2 , 2.55 , 0.1 , null ,
    '' , 'International Other Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH2CNP' , 'AX INTL OTHER TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Other Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH3' , 'AX INTL OTHER TIER 3' , 3 , 2.7 , 0.1 , null ,
    '' , 'International Other Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH3' , 'AX INTL OTHER TIER 3' , 3 , null, null, null ,
    '' , 'International Other Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH3CNP' , 'AX INTL OTHER TIER 3 CNP' , 3 , 3.0 , 0.1 , null ,
    '' , 'International Other Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IOTH3CNP' , 'AX INTL OTHER TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Other Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD1' , 'AX INTL PREPAID TIER 1' , 1 , 1.75 , 0.1 , null ,
    '' , 'International Prepaid Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD1' , 'AX INTL PREPAID TIER 1' , 1 , null, null, null ,
    '' , 'International Prepaid Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD1CNP' , 'AX INTL PREPAID TIER 1 CNP' , 1 , 2.05 , 0.1 , null ,
    '' , 'International Prepaid Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD1CNP' , 'AX INTL PREPAID TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Prepaid Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD2' , 'AX INTL PREPAID TIER 2' , 2 , 2.1 , 0.1 , null ,
    '' , 'International Prepaid Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD2' , 'AX INTL PREPAID TIER 2' , 2 , null, null, null ,
    '' , 'International Prepaid Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD2CNP' , 'AX INTL PREPAID TIER 2 CNP' , 2 , 2.4 , 0.1 , null ,
    '' , 'International Prepaid Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD2CNP' , 'AX INTL PREPAID TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Prepaid Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD3' , 'AX INTL PREPAID TIER 3' , 3 , 2.55 , 0.1 , null ,
    '' , 'International Prepaid Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD3' , 'AX INTL PREPAID TIER 3' , 3 , null, null, null ,
    '' , 'International Prepaid Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD3CNP' , 'AX INTL PREPAID TIER 3 CNP' , 3 , 2.85 , 0.1 , null ,
    '' , 'International Prepaid Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IPRPD3CNP' , 'AX INTL PREPAID TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Prepaid Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST1' , 'AX INTL RESTAURANT TIER 1' , 1 , 2.3 , 0.1 , null ,
    '' , 'International Restaurant Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST1' , 'AX INTL RESTAURANT TIER 1' , 1 , null, null, null ,
    '' , 'International Restaurant Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST1CNP' , 'AX INTL RESTAURANT TIER 1 CNP' , 1 , 2.6 , 0.1 , null ,
    '' , 'International Restaurant Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST1CNP' , 'AX INTL RESTAURANT TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Restaurant Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST2' , 'AX INTL RESTAURANT TIER 2' , 2 , 2.25 , 0.1 , null ,
    '' , 'International Restaurant Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST2' , 'AX INTL RESTAURANT TIER 2' , 2 , null, null, null ,
    '' , 'International Restaurant Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST2CNP' , 'AX INTL RESTAURANT TIER 2 CNP' , 2 , 2.55 , 0.1 , null ,
    '' , 'International Restaurant Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST2CNP' , 'AX INTL RESTAURANT TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Restaurant Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST3' , 'AX INTL RESTAURANT TIER 3' , 3 , 2.85 , 0.1 , null ,
    '' , 'International Restaurant Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST3' , 'AX INTL RESTAURANT TIER 3' , 3 , null, null, null ,
    '' , 'International Restaurant Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST3CNP' , 'AX INTL RESTAURANT TIER 3 CNP' , 3 , 3.15 , 0.1 , null ,
    '' , 'International Restaurant Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST3CNP' , 'AX INTL RESTAURANT TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Restaurant Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST4' , 'AX INTL RESTAURANT TIER 4' , 3 , 3.15 , 0.1 , null ,
    '' , 'International Restaurant Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST4' , 'AX INTL RESTAURANT TIER 4' , 3 , null, null, null ,
    '' , 'International Restaurant Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST4CNP' , 'AX INTL RESTAURANT TIER 4 CNP' , 3 , 3.45 , 0.1 , null ,
    '' , 'International Restaurant Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IREST4CNP' , 'AX INTL RESTAURANT TIER 4 CNP' , 3 , null, null, null ,
    '' , 'International Restaurant Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL1' , 'AX INTL RETAIL TIER 1' , 1 , 2.0 , 0.1 , null ,
    '' , 'International Retail Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL1' , 'AX INTL RETAIL TIER 1' , 1 , null, null, null ,
    '' , 'International Retail Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL1CNP' , 'AX INTL RETAIL TIER 1 CNP' , 1 , 2.3 , 0.1 , null ,
    '' , 'International Retail Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL1CNP' , 'AX INTL RETAIL TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Retail Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL2' , 'AX INTL RETAIL TIER 2' , 2 , 2.35 , 0.1 , null ,
    '' , 'International Retail Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL2' , 'AX INTL RETAIL TIER 2' , 2 , null, null, null ,
    '' , 'International Retail Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL2CNP' , 'AX INTL RETAIL TIER 2 CNP' , 2 , 2.65 , 0.1 , null ,
    '' , 'International Retail Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL2CNP' , 'AX INTL RETAIL TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Retail Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL3' , 'AX INTL RETAIL TIER 3' , 3 , 2.8 , 0.1 , null ,
    '' , 'International Retail Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL3' , 'AX INTL RETAIL TIER 3' , 3 , null, null, null ,
    '' , 'International Retail Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL3CNP' , 'AX INTL RETAIL TIER 3 CNP' , 3 , 3.1 , 0.1 , null ,
    '' , 'International Retail Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103IRTL3CNP' , 'AX INTL RETAIL TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Retail Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV1' , 'AX INTL SERVICE TIER 1' , 1 , 2.0 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV1' , 'AX INTL SERVICE TIER 1' , 1 , null, null, null ,
    '' , 'International Service / Professional Service Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV1CNP' , 'AX INTL SERVICE TIER 1 CNP' , 1 , 2.3 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV1CNP' , 'AX INTL SERVICE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Service / Professional Service Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV2' , 'AX INTL SERVICE TIER 2' , 2 , 2.35 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV2' , 'AX INTL SERVICE TIER 2' , 2 , null, null, null ,
    '' , 'International Service / Professional Service Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV2CNP' , 'AX INTL SERVICE TIER 2 CNP' , 2 , 2.65 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV2CNP' , 'AX INTL SERVICE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Service / Professional Service Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV3' , 'AX INTL SERVICE TIER 3' , 3 , 2.8 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV3' , 'AX INTL SERVICE TIER 3' , 3 , null, null, null ,
    '' , 'International Service / Professional Service Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV3CNP' , 'AX INTL SERVICE TIER 3 CNP' , 3 , 3.1 , 0.1 , null ,
    '' , 'International Service / Professional Service Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ISRV3CNP' , 'AX INTL SERVICE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Service / Professional Service Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE1' , 'AX INTL T/E TIER 1' , 1 , 2.65 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE1' , 'AX INTL T/E TIER 1' , 1 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE1CNP' , 'AX INTL TE TIER 1 CNP' , 1 , 2.95 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE1CNP' , 'AX INTL TE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE2' , 'AX INTL TE TIER 2' , 2 , 3.0 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE2' , 'AX INTL TE TIER 2' , 2 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE2CNP' , 'AX INTL TE TIER 2 CNP' , 2 , 3.3 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE2CNP' , 'AX INTL TE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE3' , 'AX INTL TE TIER 3' , 3 , 3.4 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE3' , 'AX INTL TE TIER 3' , 3 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE3CNP' , 'AX INTL TE TIER 3 CNP' , 3 , 3.7 , 0.1 , null ,
    '' , 'International Travel / Entertainment Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103ITE3CNP' , 'AX INTL TE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'International Travel / Entertainment Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG1' , 'AX LODG TIER 1' , 1 , 2.25 , 0.1 , null ,
    '' , 'Lodging Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG1' , 'AX LODG TIER 1' , 1 , null, null, null ,
    '' , 'Lodging Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG1CNP' , 'AX LODG TIER 1 CNP' , 1 , 2.55 , 0.1 , null ,
    '' , 'Lodging Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG1CNP' , 'AX LODG TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Lodging Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG2' , 'AX LODG TIER 2' , 2 , 2.6 , 0.1 , null ,
    '' , 'Lodging Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG2' , 'AX LODG TIER 2' , 2 , null, null, null ,
    '' , 'Lodging Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG2CNP' , 'AX LODG TIER 2 CNP' , 2 , 2.9 , 0.1 , null ,
    '' , 'Lodging Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG2CNP' , 'AX LODG TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Lodging Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG3' , 'AX LODG TIER 3' , 3 , 3.0 , 0.1 , null ,
    '' , 'Lodging Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG3' , 'AX LODG TIER 3' , 3 , null, null, null ,
    '' , 'Lodging Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG3CNP' , 'AX LODG TIER 3 CNP' , 3 , 3.3 , 0.1 , null ,
    '' , 'Lodging Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103LODG3CNP' , 'AX LODG TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Lodging Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO1' , 'AX MOTO EC TIER 1' , 1 , 1.7 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO1' , 'AX MOTO EC TIER 1' , 1 , null, null, null ,
    '' , 'Mail Order / Internet Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO1CNP' , 'AX MOTO EC TIER 1 CNP' , 1 , 2.0 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO1CNP' , 'AX MOTO EC TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Mail Order / Internet Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO2' , 'AX MOTO EC TIER 2' , 2 , 2.05 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO2' , 'AX MOTO EC TIER 2' , 2 , null, null, null ,
    '' , 'Mail Order / Internet Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO2CNP' , 'AX MOTO EC TIER 2 CNP' , 2 , 2.35 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO2CNP' , 'AX MOTO EC TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Mail Order / Internet Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO3' , 'AX MOTO EC TIER 3' , 3 , 2.5 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO3' , 'AX MOTO EC TIER 3' , 3 , null, null, null ,
    '' , 'Mail Order / Internet Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO3CNP' , 'AX MOTO EC TIER 3 CNP' , 3 , 2.8 , 0.1 , null ,
    '' , 'Mail Order / Internet Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103MOTO3CNP' , 'AX MOTO EC TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Mail Order / Internet Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH1' , 'AX OTHER TIER 1' , 1 , 1.5 , 0.1 , null ,
    '' , 'Other Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH1' , 'AX OTHER TIER 1' , 1 , null, null, null ,
    '' , 'Other Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH1CNP' , 'AX OTHER TIER 1 CNP' , 1 , 1.8 , 0.1 , null ,
    '' , 'Other Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH1CNP' , 'AX OTHER TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Other Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH2' , 'AX OTHER TIER 2' , 2 , 1.85 , 0.1 , null ,
    '' , 'Other Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH2' , 'AX OTHER TIER 2' , 2 , null, null, null ,
    '' , 'Other Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH2CNP' , 'AX OTHER TIER 2 CNP' , 2 , 2.15 , 0.1 , null ,
    '' , 'Other Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH2CNP' , 'AX OTHER TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Other Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH3' , 'AX OTHER TIER 3' , 3 , 2.3 , 0.1 , null ,
    '' , 'Other Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH3' , 'AX OTHER TIER 3' , 3 , null, null, null ,
    '' , 'Other Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH3CNP' , 'AX OTHER TIER 3 CNP' , 3 , 2.6 , 0.1 , null ,
    '' , 'Other Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103OTH3CNP' , 'AX OTHER TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Other Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD1' , 'AX PREPAID TIER 1' , 1 , 1.35 , 0.1 , null ,
    '' , 'Prepaid Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD1' , 'AX PREPAID TIER 1' , 1 , null, null, null ,
    '' , 'Prepaid Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD1CNP' , 'AX PREPAID TIER 1 CNP' , 1 , 1.65 , 0.1 , null ,
    '' , 'Prepaid Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD1CNP' , 'AX PREPAID TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Prepaid Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD2' , 'AX PREPAID TIER 2' , 2 , 1.7 , 0.1 , null ,
    '' , 'Prepaid Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD2' , 'AX PREPAID TIER 2' , 2 , null, null, null ,
    '' , 'Prepaid Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD2CNP' , 'AX PREPAID TIER 2 CNP' , 2 , 2.0 , 0.1 , null ,
    '' , 'Prepaid Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD2CNP' , 'AX PREPAID TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Prepaid Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD3' , 'AX PREPAID TIER 3' , 3 , 2.15 , 0.1 , null ,
    '' , 'Prepaid Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD3' , 'AX PREPAID TIER 3' , 3 , null, null, null ,
    '' , 'Prepaid Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD3CNP' , 'AX PREPAID TIER 3 CNP' , 3 , 2.45 , 0.1 , null ,
    '' , 'Prepaid Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103PRPD3CNP' , 'AX PREPAID TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Prepaid Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST1' , 'AX RESTAURANT TIER 1' , 1 , 1.9 , 0.04 , null ,
    '' , 'Restaurant Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST1' , 'AX RESTAURANT TIER 1' , 1 , null, null, null ,
    '' , 'Restaurant Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST1CNP' , 'AX RESTAURANT TIER 1 CNP' , 1 , 2.2 , 0.04 , null ,
    '' , 'Restaurant Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST1CNP' , 'AX RESTAURANT TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Restaurant Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST2' , 'AX RESTAURANT TIER 2' , 2 , 1.85 , 0.1 , null ,
    '' , 'Restaurant Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST2' , 'AX RESTAURANT TIER 2' , 2 , null, null, null ,
    '' , 'Restaurant Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST2CNP' , 'AX RESTAURANT TIER 2 CNP' , 2 , 2.15 , 0.1 , null ,
    '' , 'Restaurant Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST2CNP' , 'AX RESTAURANT TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Restaurant Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST3' , 'AX RESTAURANT TIER 3' , 3 , 2.45 , 0.1 , null ,
    '' , 'Restaurant Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST3' , 'AX RESTAURANT TIER 3' , 3 , null, null, null ,
    '' , 'Restaurant Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST3CNP' , 'AX RESTAURANT TIER 3 CNP' , 3 , 2.75 , 0.1 , null ,
    '' , 'Restaurant Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST3CNP' , 'AX RESTAURANT TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Restaurant Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST4' , 'AX RESTAURANT TIER 4' , 3 , 2.75 , 0.1 , null ,
    '' , 'Restaurant Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST4' , 'AX RESTAURANT TIER 4' , 3 , null, null, null ,
    '' , 'Restaurant Tier 4' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST4CNP' , 'AX RESTAURANT TIER 4 CNP' , 3 , 3.05 , 0.1 , null ,
    '' , 'Restaurant Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103REST4CNP' , 'AX RESTAURANT TIER 4 CNP' , 3 , null, null, null ,
    '' , 'Restaurant Tier 4 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL1' , 'AX RETAIL TIER 1' , 1 , 1.6 , 0.1 , null ,
    '' , 'Retail Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL1' , 'AX RETAIL TIER 1' , 1 , null, null, null ,
    '' , 'Retail Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL1CNP' , 'AX RETAIL TIER 1 CNP' , 1 , 1.9 , 0.1 , null ,
    '' , 'Retail Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL1CNP' , 'AX RETAIL TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Retail Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL2' , 'AX RETAIL TIER 2' , 2 , 1.95 , 0.1 , null ,
    '' , 'Retail Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL2' , 'AX RETAIL TIER 2' , 2 , null, null, null ,
    '' , 'Retail Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL2CNP' , 'AX RETAIL TIER 2 CNP' , 2 , 2.25 , 0.1 , null ,
    '' , 'Retail Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL2CNP' , 'AX RETAIL TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Retail Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL3' , 'AX RETAIL TIER 3' , 3 , 2.4 , 0.1 , null ,
    '' , 'Retail Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL3' , 'AX RETAIL TIER 3' , 3 , null, null, null ,
    '' , 'Retail Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL3CNP' , 'AX RETAIL TIER 3 CNP' , 3 , 2.7 , 0.1 , null ,
    '' , 'Retail Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103RTL3CNP' , 'AX RETAIL TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Retail Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV1' , 'AX SERVICE TIER 1' , 1 , 1.6 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV1' , 'AX SERVICE TIER 1' , 1 , null, null, null ,
    '' , 'Service / Professional Service Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV1CNP' , 'AX SERVICE TIER 1 CNP' , 1 , 1.9 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV1CNP' , 'AX SERVICE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Service / Professional Service Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV2' , 'AX SERVICE TIER 2' , 2 , 1.95 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV2' , 'AX SERVICE TIER 2' , 2 , null, null, null ,
    '' , 'Service / Professional Service Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV2CNP' , 'AX SERVICE TIER 2 CNP' , 2 , 2.25 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV2CNP' , 'AX SERVICE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Service / Professional Service Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV3' , 'AX SERVICE TIER 3' , 3 , 2.4 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV3' , 'AX SERVICE TIER 3' , 3 , null, null, null ,
    '' , 'Service / Professional Service Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV3CNP' , 'AX SERVICE TIER 3 CNP' , 3 , 2.7 , 0.1 , null ,
    '' , 'Service / Professional Service Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103SRV3CNP' , 'AX SERVICE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Service / Professional Service Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE1' , 'AX TE TIER 1' , 1 , 2.25 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE1' , 'AX TE TIER 1' , 1 , null, null, null ,
    '' , 'Travel / Entertainment Tier 1' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE1CNP' , 'AX TE TIER 1 CNP' , 1 , 2.55 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE1CNP' , 'AX TE TIER 1 CNP' , 1 , null, null, null ,
    '' , 'Travel / Entertainment Tier 1 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE2' , 'AX TE TIER 2' , 2 , 2.6 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE2' , 'AX TE TIER 2' , 2 , null, null, null ,
    '' , 'Travel / Entertainment Tier 2' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE2CNP' , 'AX TE TIER 2 CNP' , 2 , 2.9 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE2CNP' , 'AX TE TIER 2 CNP' , 2 , null, null, null ,
    '' , 'Travel / Entertainment Tier 2 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER2' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE3' , 'AX TE TIER 3' , 3 , 3.0 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE3' , 'AX TE TIER 3' , 3 , null, null, null ,
    '' , 'Travel / Entertainment Tier 3' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE3CNP' , 'AX TE TIER 3 CNP' , 3 , 3.3 , 0.1 , null ,
    '' , 'Travel / Entertainment Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'INTERCHANGE' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE)
    values (
         '0103TE3CNP' , 'AX TE TIER 3 CNP' , 3 , null, null, null ,
    '' , 'Travel / Entertainment Tier 3 - Card Not Present' , '03' , 'AMEX_JP_BASE_TIER3' , 'DEFAULT_DISCOUNT' );
