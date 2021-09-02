-- Number of arguments: 4 arguments.
-- Argument List: ['./1_0_build_insert_sql_mas_codes.py', 'Canadian_Interchange_Fees_for_April_2016_(04-14-2016).xls', 'ALL', 'CAN']
rem gathering mas_codes from spreadsheet

--delete FLMGR_ICHG_RATES_TEMPLATE;


rem Discover


Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLCASHREIMB' , 'DS CAN INTL CASH REIMBURSEMENT' , 1 , 0.16 , 3.0 , null ,
    '000' , 'Canada International Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLCASHREIMB' , 'DS CAN INTL CASH REIMBURSEMENT' , 1 , null, null, null ,
    '000' , 'Canada International Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCASHREIMB' , 'DS CAN CASH REIMBURSEMENT' , 1 , 0.0 , 1.65 , null ,
    '000' , 'Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCASHREIMB' , 'DS CAN CASH REIMBURSEMENT' , 1 , null, null, null ,
    '000' , 'Cash Reimbursement' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOREC' , 'DS CAN DFLT COMM RCUR PYMNT' , 1 , 2.2 , 0.0 , null ,
    '2001' , 'Canada Commercial Default Recurring Payment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOREC' , 'DS CAN DFLT COMM RCUR PYMNT' , 1 , null, null, null ,
    '2001' , 'Canada Commercial Default Recurring Payment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOSUP' , 'DS CAN DFLT COMM SUPRMRKT WH' , 1 , 2.15 , 0.0 , null ,
    '2002' , 'Canada Commercial Default Supermarkets/Warehouse' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOSUP' , 'DS CAN DFLT COMM SUPRMRKT WH' , 1 , null, null, null ,
    '2002' , 'Canada Commercial Default Supermarkets/Warehouse' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOPET' , 'DS CAN DFLT COMM PETROLEUM' , 1 , 2.15 , 0.0 , null ,
    '2003' , 'Canada Commercial Default Petroleum' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOPET' , 'DS CAN DFLT COMM PETROLEUM' , 1 , null, null, null ,
    '2003' , 'Canada Commercial Default Petroleum' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCORET' , 'DS CAN DFLT COMM RETAIL' , 1 , 2.25 , 0.0 , null ,
    '2004' , 'Canada Commercial Default Retail' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCORET' , 'DS CAN DFLT COMM RETAIL' , 1 , null, null, null ,
    '2004' , 'Canada Commercial Default Retail' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOHOT' , 'DS CAN DFLT COMM HTL CAR RNTL' , 1 , 2.45 , 0.0 , null ,
    '2005' , 'Canada Commercial Default Hotels/Car Rental' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOHOT' , 'DS CAN DFLT COMM HTL CAR RNTL' , 1 , null, null, null ,
    '2005' , 'Canada Commercial Default Hotels/Car Rental' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOPAS' , 'DS CAN DFLT COMM PASS TRANS' , 1 , 2.4 , 0.0 , null ,
    '2006' , 'Canada Commercial Default Passenger Transport' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOPAS' , 'DS CAN DFLT COMM PASS TRANS' , 1 , null, null, null ,
    '2006' , 'Canada Commercial Default Passenger Transport' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOBASE' , 'DS CAN DFLT COMM BASE' , 1 , 2.65 , 0.0 , null ,
    '2007' , 'Canada Commercial Default Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDCOBASE' , 'DS CAN DFLT COMM BASE' , 1 , null, null, null ,
    '2007' , 'Canada Commercial Default Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCC' , 'DS CAN DFLT ADJ VCHR CORE' , 1 , 1.42 , 0.0 , null ,
    '2008' , 'Canada Consumer Default Adjustment Voucher Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCC' , 'DS CAN DFLT ADJ VCHR CORE' , 1 , null, null, null ,
    '2008' , 'Canada Consumer Default Adjustment Voucher Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCSIGD' , 'DS CAN DFLT ADJ VCHR SIG DB' , 1 , 1.2 , 0.0 , null ,
    '2009' , 'Canada Consumer Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCSIGD' , 'DS CAN DFLT ADJ VCHR SIG DB' , 1 , null, null, null ,
    '2009' , 'Canada Consumer Default Adjustment Voucher Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCP' , 'DS CAN DFLT ADJ VCHR PREM' , 1 , 1.65 , 0.0 , null ,
    '2010' , 'Canada Consumer Default Adjustment Voucher Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCP' , 'DS CAN DFLT ADJ VCHR PREM' , 1 , null, null, null ,
    '2010' , 'Canada Consumer Default Adjustment Voucher Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPPP' , 'DS CAN DFLT ADJ VCHR PRM PLS' , 1 , 2.0 , 0.0 , null ,
    '2011' , 'Canada Consumer Default Adjustment Voucher Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPPP' , 'DS CAN DFLT ADJ VCHR PRM PLS' , 1 , null, null, null ,
    '2011' , 'Canada Consumer Default Adjustment Voucher Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPPR' , 'DS CAN DFLT ADJ VCHR PREPAID' , 1 , 1.49 , 0.0 , null ,
    '2012' , 'Canada Consumer Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPPR' , 'DS CAN DFLT ADJ VCHR PREPAID' , 1 , null, null, null ,
    '2012' , 'Canada Consumer Default Adjustment Voucher Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCC' , 'DS CAN DFLT BASE SUB CORE' , 1 , 1.72 , 0.0 , null ,
    '2013' , 'Canada Consumer Default Base Submission Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCC' , 'DS CAN DFLT BASE SUB CORE' , 1 , null, null, null ,
    '2013' , 'Canada Consumer Default Base Submission Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCSIGD' , 'DS CAN DFLT BASE SUB SIG DB' , 1 , 1.2 , 0.0 , null ,
    '2014' , 'Canada Consumer Default Base Submission Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCSIGD' , 'DS CAN DFLT BASE SUB SIG DB' , 1 , null, null, null ,
    '2014' , 'Canada Consumer Default Base Submission Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCP' , 'DS CAN DFLT BASE SUB PRM' , 1 , 2.1 , 0.0 , null ,
    '2015' , 'Canada Consumer Default Base Submission Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFCP' , 'DS CAN DFLT BASE SUB PRM' , 1 , null, null, null ,
    '2015' , 'Canada Consumer Default Base Submission Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFPP' , 'DS CAN DFLT BASE SUB PRM PLS' , 1 , 2.6 , 0.0 , null ,
    '2016' , 'Canada Consumer Default Base Submission Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFPP' , 'DS CAN DFLT BASE SUB PRM PLS' , 1 , null, null, null ,
    '2016' , 'Canada Consumer Default Base Submission Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFPR' , 'DS CAN DFLT BASE SUB PRPAID' , 1 , 1.49 , 0.0 , null ,
    '2017' , 'Canada Consumer Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDEFPR' , 'DS CAN DFLT BASE SUB PRPAID' , 1 , null, null, null ,
    '2017' , 'Canada Consumer Default Base Submission Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCO' , 'DS CAN DFLT ADJ VCHR COMM' , 1 , 2.15 , 0.0 , null ,
    '2018' , 'Canada Commercial Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDAVPCO' , 'DS CAN DFLT ADJ VCHR COMM' , 1 , null, null, null ,
    '2018' , 'Canada Commercial Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDINTLAVP' , 'DS CAN DFLT INTL ADJ VCHR' , 1 , 1.2 , 0.0 , null ,
    '2019' , 'Canada International Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDINTLAVP' , 'DS CAN DFLT INTL ADJ VCHR' , 1 , null, null, null ,
    '2019' , 'Canada International Default Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDINTLBASE' , 'DS CAN DFLT INTL BASE SUB' , 1 , 1.72 , 0.0 , null ,
    '2020' , 'Canada International Default Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNDINTLBASE' , 'DS CAN DFLT INTL BASE SUB' , 1 , null, null, null ,
    '2020' , 'Canada International Default Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCC' , 'DS CAN RCUR PYMNT CORE' , 1 , 1.45 , 0.0 , null ,
    '261' , 'Canada Consumer Recurring Payment Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCC' , 'DS CAN RCUR PYMNT CORE' , 1 , null, null, null ,
    '261' , 'Canada Consumer Recurring Payment Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCC' , 'DS CAN SUPRMRKT WH CORE' , 1 , 1.42 , 0.0 , null ,
    '262' , 'Canada Consumer Supermarkets/Warehouse Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCC' , 'DS CAN SUPRMRKT WH CORE' , 1 , null, null, null ,
    '262' , 'Canada Consumer Supermarkets/Warehouse Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCC' , 'DS CAN PETROLEUM CORE' , 1 , 1.27 , 0.0 , null ,
    '263' , 'Canada Consumer Petroleum Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCC' , 'DS CAN PETROLEUM CORE' , 1 , null, null, null ,
    '263' , 'Canada Consumer Petroleum Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCC' , 'DS CAN RETAIL CORE' , 1 , 1.6 , 0.0 , null ,
    '264' , 'Canada Consumer Retail Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCC' , 'DS CAN RETAIL CORE' , 1 , null, null, null ,
    '264' , 'Canada Consumer Retail Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCC' , 'DS CAN HTL CAR RNTL CORE' , 1 , 1.67 , 0.0 , null ,
    '265' , 'Canada Consumer Hotels/Car Rentals Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCC' , 'DS CAN HTL CAR RNTL CORE' , 1 , null, null, null ,
    '265' , 'Canada Consumer Hotels/Car Rentals Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCC' , 'DS CAN PASS TRANS CORE' , 1 , 1.67 , 0.0 , null ,
    '266' , 'Canada Consumer Passenger Transport Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCC' , 'DS CAN PASS TRANS CORE' , 1 , null, null, null ,
    '266' , 'Canada Consumer Passenger Transport Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECC' , 'DS CAN BASE CORE' , 1 , 1.72 , 0.0 , null ,
    '267' , 'Canada Consumer Base Submission Level Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECC' , 'DS CAN BASE CORE' , 1 , null, null, null ,
    '267' , 'Canada Consumer Base Submission Level Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCP' , 'DS CAN RCUR PYMNT PRM' , 1 , 1.7 , 0.0 , null ,
    '268' , 'Canada Consumer Recurring Payment Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCP' , 'DS CAN RCUR PYMNT PRM' , 1 , null, null, null ,
    '268' , 'Canada Consumer Recurring Payment Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCP' , 'DS CAN SUPRMRKT WH PRM' , 1 , 1.65 , 0.0 , null ,
    '269' , 'Canada Consumer Supermarkets/Warehouse Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCP' , 'DS CAN SUPRMRKT WH PRM' , 1 , null, null, null ,
    '269' , 'Canada Consumer Supermarkets/Warehouse Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCP' , 'DS CAN PETROLEUM PRM' , 1 , 1.5 , 0.0 , null ,
    '270' , 'Canada Consumer Petroleum Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCP' , 'DS CAN PETROLEUM PRM' , 1 , null, null, null ,
    '270' , 'Canada Consumer Petroleum Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCP' , 'DS CAN RETAIL PRM' , 1 , 1.98 , 0.0 , null ,
    '271' , 'Canada Consumer Retail Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCP' , 'DS CAN RETAIL PRM' , 1 , null, null, null ,
    '271' , 'Canada Consumer Retail Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCP' , 'DS CAN HTL CAR RNTL PRM' , 1 , 2.05 , 0.0 , null ,
    '272' , 'Canada Consumer Hotels/Car Rentals Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCP' , 'DS CAN HTL CAR RNTL PRM' , 1 , null, null, null ,
    '272' , 'Canada Consumer Hotels/Car Rentals Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCP' , 'DS CAN PASS TRANS PRM' , 1 , 2.03 , 0.0 , null ,
    '273' , 'Canada Consumer Passenger Transport Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCP' , 'DS CAN PASS TRANS PRM' , 1 , null, null, null ,
    '273' , 'Canada Consumer Passenger Transport Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECP' , 'DS CAN BASE PRM' , 1 , 2.1 , 0.0 , null ,
    '274' , 'Canada Consumer Base Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECP' , 'DS CAN BASE PRM' , 1 , null, null, null ,
    '274' , 'Canada Consumer Base Submission Level Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECPP' , 'DS CAN RCUR PYMNT PRM PLS' , 1 , 2.1 , 0.0 , null ,
    '275' , 'Canada Consumer Recurring Payment Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECPP' , 'DS CAN RCUR PYMNT PRM PLS' , 1 , null, null, null ,
    '275' , 'Canada Consumer Recurring Payment Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPPP' , 'DS CAN SUPRMRKT WH PREM PLS' , 1 , 2.0 , 0.0 , null ,
    '276' , 'Canada Consumer Supermarkets/Warehouse Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPPP' , 'DS CAN SUPRMRKT WH PREM PLS' , 1 , null, null, null ,
    '276' , 'Canada Consumer Supermarkets/Warehouse Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETPP' , 'DS CAN PETROLEUM PRM PLS' , 1 , 2.0 , 0.0 , null ,
    '277' , 'Canada Consumer Petroleum Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETPP' , 'DS CAN PETROLEUM PRM PLS' , 1 , null, null, null ,
    '277' , 'Canada Consumer Petroleum Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETPP' , 'DS CAN RETAIL PRM PLS' , 1 , 2.25 , 0.0 , null ,
    '278' , 'Canada Consumer Retail Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETPP' , 'DS CAN RETAIL PRM PLS' , 1 , null, null, null ,
    '278' , 'Canada Consumer Retail Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTPP' , 'DS CAN HTL CAR RNTL PRM PLS' , 1 , 2.4 , 0.0 , null ,
    '279' , 'Canada Consumer Hotels/Car Rentals Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTPP' , 'DS CAN HTL CAR RNTL PRM PLS' , 1 , null, null, null ,
    '279' , 'Canada Consumer Hotels/Car Rentals Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASPP' , 'DS CAN PASS TRANS PRM PLS' , 1 , 2.35 , 0.0 , null ,
    '280' , 'Canada Consumer Passenger Transport Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASPP' , 'DS CAN PASS TRANS PRM PLS' , 1 , null, null, null ,
    '280' , 'Canada Consumer Passenger Transport Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASEPP' , 'DS CAN BASE PRM PLS' , 1 , 2.6 , 0.0 , null ,
    '281' , 'Canada Consumer Base Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASEPP' , 'DS CAN BASE PRM PLS' , 1 , null, null, null ,
    '281' , 'Canada Consumer Base Submission Level Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOREC' , 'DS CAN COMM RCUR PYMNT' , 1 , 2.2 , 0.0 , null ,
    '282' , 'Canada Commercial Recurring Payment' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOREC' , 'DS CAN COMM RCUR PYMNT' , 1 , null, null, null ,
    '282' , 'Canada Commercial Recurring Payment' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOSUP' , 'DS CAN COMM SUPRMRKT WH' , 1 , 2.15 , 0.0 , null ,
    '283' , 'Canada Commercial Supermarkets/Warehouse' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOSUP' , 'DS CAN COMM SUPRMRKT WH' , 1 , null, null, null ,
    '283' , 'Canada Commercial Supermarkets/Warehouse' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOPET' , 'DS CAN COMM PETROLEUM' , 1 , 2.15 , 0.0 , null ,
    '284' , 'Canada Commercial Petroleum' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOPET' , 'DS CAN COMM PETROLEUM' , 1 , null, null, null ,
    '284' , 'Canada Commercial Petroleum' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCORET' , 'DS CAN COMM RETAIL' , 1 , 2.25 , 0.0 , null ,
    '285' , 'Canada Commercial Retail' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCORET' , 'DS CAN COMM RETAIL' , 1 , null, null, null ,
    '285' , 'Canada Commercial Retail' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOHOT' , 'DS CAN COMM HTL CAR RNTL' , 1 , 2.45 , 0.0 , null ,
    '286' , 'Canada Commercial Hotels/Car' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOHOT' , 'DS CAN COMM HTL CAR RNTL' , 1 , null, null, null ,
    '286' , 'Canada Commercial Hotels/Car' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOPAS' , 'DS CAN COMM PASS TRANS' , 1 , 2.4 , 0.0 , null ,
    '287' , 'Canada Commercial Passenger Transport' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOPAS' , 'DS CAN COMM PASS TRANS' , 1 , null, null, null ,
    '287' , 'Canada Commercial Passenger Transport' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOBASE' , 'DS CAN COMM BASE' , 1 , 2.65 , 0.0 , null ,
    '288' , 'Canada Commercial Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNCOBASE' , 'DS CAN COMM BASE' , 1 , null, null, null ,
    '288' , 'Canada Commercial Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCSIGD' , 'DS CAN RCUR PYMNT SIG DB' , 1 , 1.2 , 0.0 , null ,
    '289' , 'Canada Consumer Recurring Payment Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECCSIGD' , 'DS CAN RCUR PYMNT SIG DB' , 1 , null, null, null ,
    '289' , 'Canada Consumer Recurring Payment Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECPR' , 'DS CAN RCUR PYMNT PREPAID' , 1 , 1.49 , 0.0 , null ,
    '290' , 'Canada Consumer Recurring Payment Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRECPR' , 'DS CAN RCUR PYMNT PREPAID' , 1 , null, null, null ,
    '290' , 'Canada Consumer Recurring Payment Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECSIGD' , 'DS CAN BASE SIG DB' , 1 , 1.2 , 0.0 , null ,
    '291' , 'Canada Consumer Base Submission Level Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASECSIGD' , 'DS CAN BASE SIG DB' , 1 , null, null, null ,
    '291' , 'Canada Consumer Base Submission Level Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASEPR' , 'DS CAN BASE PREPAID' , 1 , 1.49 , 0.0 , null ,
    '292' , 'Canada Consumer Base Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNBASEPR' , 'DS CAN BASE PREPAID' , 1 , null, null, null ,
    '292' , 'Canada Consumer Base Submission Level Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CC' , 'DS CAN CONS ADJ VCHR 1 CORE' , 1 , 1.72 , 0.0 , null ,
    '293' , 'Canada Consumer Adjustment Voucher Program 1 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CC' , 'DS CAN CONS ADJ VCHR 1 CORE' , 1 , null, null, null ,
    '293' , 'Canada Consumer Adjustment Voucher Program 1 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CD' , 'DS CAN CONS ADJ VCHR 1 DB' , 1 , 1.2 , 0.0 , null ,
    '294' , 'Canada Consumer Adjustment Voucher Program 1 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CD' , 'DS CAN CONS ADJ VCHR 1 DB' , 1 , null, null, null ,
    '294' , 'Canada Consumer Adjustment Voucher Program 1 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1PR' , 'DS CAN CONS ADJ VCHR 1 PREPAID' , 1 , 1.49 , 0.0 , null ,
    '295' , 'Canada Consumer Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1PR' , 'DS CAN CONS ADJ VCHR 1 PREPAID' , 1 , null, null, null ,
    '295' , 'Canada Consumer Adjustment Voucher Program 1 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CP' , 'DS CAN CONS ADJ VCHR 1 PRM' , 1 , 2.1 , 0.0 , null ,
    '296' , 'Canada Consumer Adjustment Voucher Program 1 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CP' , 'DS CAN CONS ADJ VCHR 1 PRM' , 1 , null, null, null ,
    '296' , 'Canada Consumer Adjustment Voucher Program 1 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1PP' , 'DS CAN CONS ADJ VCHR 1 PRM PLS' , 1 , 2.6 , 0.0 , null ,
    '297' , 'Canada Consumer Adjustment Voucher Program 1 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1PP' , 'DS CAN CONS ADJ VCHR 1 PRM PLS' , 1 , null, null, null ,
    '297' , 'Canada Consumer Adjustment Voucher Program 1 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CC' , 'DS CAN CONS ADJ VCHR 2 CORE' , 1 , 1.67 , 0.0 , null ,
    '298' , 'Canada Consumer Adjustment Voucher Program 2 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CC' , 'DS CAN CONS ADJ VCHR 2 CORE' , 1 , null, null, null ,
    '298' , 'Canada Consumer Adjustment Voucher Program 2 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CD' , 'DS CAN CONS ADJ VCHR 2 DB' , 1 , 1.2 , 0.0 , null ,
    '299' , 'Canada Consumer Adjustment Voucher Program 2 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CD' , 'DS CAN CONS ADJ VCHR 2 DB' , 1 , null, null, null ,
    '299' , 'Canada Consumer Adjustment Voucher Program 2 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2PR' , 'DS CAN CONS ADJ VCHR 2 PREPAID' , 1 , 1.49 , 0.0 , null ,
    '300' , 'Canada Consumer Adjustment Voucher Program 2 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2PR' , 'DS CAN CONS ADJ VCHR 2 PREPAID' , 1 , null, null, null ,
    '300' , 'Canada Consumer Adjustment Voucher Program 2 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CP' , 'DS CAN CONS ADJ VCHR 2 PRM' , 1 , 2.03 , 0.0 , null ,
    '301' , 'Canada Consumer Adjustment Voucher Program 2 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CP' , 'DS CAN CONS ADJ VCHR 2 PRM' , 1 , null, null, null ,
    '301' , 'Canada Consumer Adjustment Voucher Program 2 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2PP' , 'DS CAN CONS ADJ VCHR 2 PRM PLS' , 1 , 2.35 , 0.0 , null ,
    '302' , 'Canada Consumer Adjustment Voucher Program 2 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2PP' , 'DS CAN CONS ADJ VCHR 2 PRM PLS' , 1 , null, null, null ,
    '302' , 'Canada Consumer Adjustment Voucher Program 2 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CC' , 'DS CAN CONS ADJ VCHR 3 CORE' , 1 , 1.42 , 0.0 , null ,
    '303' , 'Canada Consumer Adjustment Voucher Program 3 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CC' , 'DS CAN CONS ADJ VCHR 3 CORE' , 1 , null, null, null ,
    '303' , 'Canada Consumer Adjustment Voucher Program 3 Core/Rewards' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CD' , 'DS CAN CONS ADJ VCHR 3 DB' , 1 , 1.2 , 0.0 , null ,
    '304' , 'Canada Consumer Adjustment Voucher Program 3 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CD' , 'DS CAN CONS ADJ VCHR 3 DB' , 1 , null, null, null ,
    '304' , 'Canada Consumer Adjustment Voucher Program 3 Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3PR' , 'DS CAN CONS ADJ VCHR 3 PREPAID' , 1 , 1.49 , 0.0 , null ,
    '305' , 'Canada Consumer Adjustment Voucher Program 3 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3PR' , 'DS CAN CONS ADJ VCHR 3 PREPAID' , 1 , null, null, null ,
    '305' , 'Canada Consumer Adjustment Voucher Program 3 Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CP' , 'DS CAN CONS ADJ VCHR 3 PRM' , 1 , 1.65 , 0.0 , null ,
    '306' , 'Canada Consumer Adjustment Voucher Program 3 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CP' , 'DS CAN CONS ADJ VCHR 3 PRM' , 1 , null, null, null ,
    '306' , 'Canada Consumer Adjustment Voucher Program 3 Premium' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3PP' , 'DS CAN CONS ADJ VCHR 3 PRM PLS' , 1 , 2.0 , 0.0 , null ,
    '307' , 'Canada Consumer Adjustment Voucher Program 3 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3PP' , 'DS CAN CONS ADJ VCHR 3 PRM PLS' , 1 , null, null, null ,
    '307' , 'Canada Consumer Adjustment Voucher Program 3 Premium Plus' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CO' , 'DS CAN COMM ADJ VCHR 1' , 1 , 2.65 , 0.0 , null ,
    '308' , 'Canada Commercial Adjustment Voucher Program 1' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP1CO' , 'DS CAN COMM ADJ VCHR 1' , 1 , null, null, null ,
    '308' , 'Canada Commercial Adjustment Voucher Program 1' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CO' , 'DS CAN COMM ADJ VCHR 2' , 1 , 2.4 , 0.0 , null ,
    '309' , 'Canada Commercial Adjustment Voucher Program 2' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP2CO' , 'DS CAN COMM ADJ VCHR 2' , 1 , null, null, null ,
    '309' , 'Canada Commercial Adjustment Voucher Program 2' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CO' , 'DS CAN COMM ADJ VCHR 3' , 1 , 2.15 , 0.0 , null ,
    '310' , 'Canada Commercial Adjustment Voucher Program 3' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNAVP3CO' , 'DS CAN COMM ADJ VCHR 3' , 1 , null, null, null ,
    '310' , 'Canada Commercial Adjustment Voucher Program 3' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCSIGD' , 'DS CAN SUPRMRKT WH SIG DB' , 1 , 1.2 , 0.0 , null ,
    '323' , 'Canada Consumer Supermarkets/Warehouse Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPCSIGD' , 'DS CAN SUPRMRKT WH SIG DB' , 1 , null, null, null ,
    '323' , 'Canada Consumer Supermarkets/Warehouse Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCSIGD' , 'DS CAN PETROLEUM SIG DB' , 1 , 1.2 , 0.0 , null ,
    '324' , 'Canada Consumer Petroleum Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETCSIGD' , 'DS CAN PETROLEUM SIG DB' , 1 , null, null, null ,
    '324' , 'Canada Consumer Petroleum Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCSIGD' , 'DS CAN RETAIL SIG DB' , 1 , 1.2 , 0.0 , null ,
    '325' , 'Canada Consumer Retail Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETCSIGD' , 'DS CAN RETAIL SIG DB' , 1 , null, null, null ,
    '325' , 'Canada Consumer Retail Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCSIGD' , 'DS CAN HTL CAR RNTL SIG DB' , 1 , 1.2 , 0.0 , null ,
    '326' , 'Canada Consumer Hotels/Car Rentals Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTCSIGD' , 'DS CAN HTL CAR RNTL SIG DB' , 1 , null, null, null ,
    '326' , 'Canada Consumer Hotels/Car Rentals Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCSIGD' , 'DS CAN PASS TRANS SIG DB' , 1 , 1.2 , 0.0 , null ,
    '327' , 'Canada Consumer Passenger Transport Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASCSIGD' , 'DS CAN PASS TRANS SIG DB' , 1 , null, null, null ,
    '327' , 'Canada Consumer Passenger Transport Signature Debit' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPPR' , 'DS CAN SUPRMRKT WH PREPAID' , 1 , 1.49 , 0.0 , null ,
    '328' , 'Canada Consumer Supermarkets/Warehouse Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNSUPPR' , 'DS CAN SUPRMRKT WH PREPAID' , 1 , null, null, null ,
    '328' , 'Canada Consumer Supermarkets/Warehouse Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETPR' , 'DS CAN PETROLEUM PREPAID' , 1 , 1.49 , 0.0 , null ,
    '329' , 'Canada Consumer Petroleum Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPETPR' , 'DS CAN PETROLEUM PREPAID' , 1 , null, null, null ,
    '329' , 'Canada Consumer Petroleum Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETPR' , 'DS CAN RETAIL PREPAID' , 1 , 1.49 , 0.0 , null ,
    '330' , 'Canada Consumer Retail Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNRETPR' , 'DS CAN RETAIL PREPAID' , 1 , null, null, null ,
    '330' , 'Canada Consumer Retail Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTPR' , 'DS CAN HTL CAR RNTL PREPAID' , 1 , 1.49 , 0.0 , null ,
    '331' , 'Canada Consumer Hotels/Car Rentals Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNHOTPR' , 'DS CAN HTL CAR RNTL PREPAID' , 1 , null, null, null ,
    '331' , 'Canada Consumer Hotels/Car Rentals Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASPR' , 'DS CAN PASS TRANS PREPAID' , 1 , 1.49 , 0.0 , null ,
    '332' , 'Canada Consumer Passenger Transport Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNPASPR' , 'DS CAN PASS TRANS PREPAID' , 1 , null, null, null ,
    '332' , 'Canada Consumer Passenger Transport Prepaid' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLELEC' , 'DS CAN INTL ELECTRONIC' , 1 , 1.2 , 0.0 , null ,
    '835' , 'Canada International Electronic' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLELEC' , 'DS CAN INTL ELECTRONIC' , 1 , null, null, null ,
    '835' , 'Canada International Electronic' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLBASE' , 'DS CAN INTL BASE SUB' , 1 , 1.72 , 0.0 , null ,
    '836' , 'Canada International Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLBASE' , 'DS CAN INTL BASE SUB' , 1 , null, null, null ,
    '836' , 'Canada International Base Submission Level' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLAVP' , 'DS CAN INTL ADJ VCHR' , 1 , 1.2 , 0.0 , null ,
    '837' , 'Canada International Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'INTERCHANGE' , 'CAN' );
Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
         '08CNINTLAVP' , 'DS CAN INTL ADJ VCHR' , 1 , null, null, null ,
    '837' , 'Canada International Adjustment Voucher' , '08' , 'DISC_JP_BASE_TIER1' , 'DEFAULT_DISCOUNT' , 'CAN' );

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
    'C12' ,
