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
