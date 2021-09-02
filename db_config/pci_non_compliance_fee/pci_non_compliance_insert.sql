REM INSERTING into non_act_fee_pkg
SET DEFINE OFF;

/*
INSTITUTION_ID    MAX_NBR MAX_ID
-------------- ---------- ------------
101                 38199 9999
105             106023728 106023728
107                102979 99999
121             106020450 106020450

Rates
-----
19.99
24.95
28.95

TID             Description
--------------- -----------
010004420000    Service Fee

MAS_CODE        MAS_DESC
--------------- --------
00PCINONCOMP    PCI NON-COMPLIANCE FEE

*/

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('101', '38221', trunc(sysdate - 1), null, '00PCINONCOMP~19.99');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('101', '38221', 'B ', '010004240000', '00PCINONCOMP', 19.99,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('101', '38222', trunc(sysdate - 1), null, '00PCINONCOMP~24.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('101', '38222', 'B ', '010004240000', '00PCINONCOMP', 24.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('101', '38223', trunc(sysdate - 1), null, '00PCINONCOMP~28.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('101', '38223', 'B ', '010004240000', '00PCINONCOMP', 28.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

-----

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('105', '1050101', trunc(sysdate - 1), null, '00PCINONCOMP~19.99');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('105', '1050101', 'B ', '010004240000', '00PCINONCOMP', 19.99,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('105', '1050102', trunc(sysdate - 1), null, '00PCINONCOMP~24.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('105', '1050102', 'B ', '010004240000', '00PCINONCOMP', 24.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('105', '1050103', trunc(sysdate - 1), null, '00PCINONCOMP~28.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('105', '1050103', 'B ', '010004240000', '00PCINONCOMP', 28.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

-----

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('107', '102921', trunc(sysdate - 1), null, '00PCINONCOMP~19.99');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('107', '102921', 'B ', '010004240000', '00PCINONCOMP', 19.99,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('107', '102922', trunc(sysdate - 1), null, '00PCINONCOMP~24.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('107', '102922', 'B ', '010004240000', '00PCINONCOMP', 24.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('107', '102923', trunc(sysdate - 1), null, '00PCINONCOMP~28.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('107', '102923', 'B ', '010004240000', '00PCINONCOMP', 28.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

-----

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('121', '81', trunc(sysdate - 1), null, '00PCINONCOMP~19.99');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('121', '81', 'B ', '010004240000', '00PCINONCOMP', 19.99,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('121', '82', trunc(sysdate - 1), null, '00PCINONCOMP~24.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('121', '82', 'B ', '010004240000', '00PCINONCOMP', 24.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

Insert into non_act_fee_pkg
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, FEE_END_DATE, NONACT_FEEPKG_NAME)
    values ('121', '83', trunc(sysdate - 1), null, '00PCINONCOMP~28.95');

Insert into non_activity_fees
    (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT,
    FEE_CURR, NBR_INSTALLMENTS, ITEM_CNT_PLAN_ID, THRESHOLD, GENERATE_FREQ,
    GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, PRO_RATE_FLAG,
    DAY_OF_MONTH, TIER_ID, START_DAY_MONTH, END_DAY_MONTH, CHECK_ACTIVITY,
    CARD_SCHEME)
    values
    ('121', '83', 'B ', '010004240000', '00PCINONCOMP', 28.95,
    '840', 0, null, 0, 'M',
    0, trunc(sysdate, 'MM') - 1, trunc(last_day(sysdate)), null,
    31, null, 0, 0, null,
    '00');

-----

INSERT INTO MASCLR.NON_ACT_FEE_PKG (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME)
    VALUES ('107', '102924', TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~0');
INSERT INTO MASCLR.NON_ACT_FEE_PKG (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME)
    VALUES ('105', '1050104', TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~0');
INSERT INTO MASCLR.NON_ACT_FEE_PKG (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME)
    VALUES ('101', '38224', TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~0');
INSERT INTO MASCLR.NON_ACT_FEE_PKG (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME)
    VALUES ('121', '84', TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~0');



INSERT INTO MASCLR.NON_ACTIVITY_FEES (INSTITUTION_ID, NON_ACT_FEE_PKG_ID,
    CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD,
    GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE,
    DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME)
    VALUES
    ('101', '38224', 'B ', '010004240000', '00PCINONCOMP', '0', '840',
    '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'),
    TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');
INSERT INTO MASCLR.NON_ACTIVITY_FEES (INSTITUTION_ID, NON_ACT_FEE_PKG_ID,
    CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD,
    GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE,
    DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME)
    VALUES
    ('105', '1050104', 'B ', '010004240000', '00PCINONCOMP', '0', '840',
    '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'),
    TO_DATE('30-JUN-14', 'DD-MON-YY' ), '31', '0', '0', '00');
INSERT INTO MASCLR.NON_ACTIVITY_FEES (INSTITUTION_ID, NON_ACT_FEE_PKG_ID,
    CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD,
    GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE,
    DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME)
    VALUES
    ('107', '102924', 'B ', '010004240000', '00PCINONCOMP', '0', '840',
    '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'),
    TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');
INSERT INTO MASCLR.NON_ACTIVITY_FEES (INSTITUTION_ID, NON_ACT_FEE_PKG_ID,
    CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD,
    GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE,
    DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME)
    VALUES ('121', '84', 'B ', '010004240000', '00PCINONCOMP', '0', '840',
    '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'),
    TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');


INSERT INTO "MASCLR"."NON_ACT_FEE_PKG" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME) VALUES ('107', '102925',    TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~10');
INSERT INTO "MASCLR"."NON_ACT_FEE_PKG" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME) VALUES ('105', '1050105',   TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~10');
INSERT INTO "MASCLR"."NON_ACT_FEE_PKG" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME) VALUES ('101', '38225',     TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~10');
INSERT INTO "MASCLR"."NON_ACT_FEE_PKG" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, FEE_START_DATE, NONACT_FEEPKG_NAME) VALUES ('121', '85',        TO_DATE('09-JUN-14', 'DD-MON-YY'), '00PCINONCOMP~10');




INSERT INTO "MASCLR"."NON_ACTIVITY_FEES" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD, GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME) VALUES ('107', '102925',    'B ', '010004240000', '00PCINONCOMP', '10', '840', '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'), TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');
INSERT INTO "MASCLR"."NON_ACTIVITY_FEES" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD, GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME) VALUES ('105', '1050105',   'B ', '010004240000', '00PCINONCOMP', '10', '840', '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'), TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');
INSERT INTO "MASCLR"."NON_ACTIVITY_FEES" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD, GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME) VALUES ('101', '38225',     'B ', '010004240000', '00PCINONCOMP', '10', '840', '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'), TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');
INSERT INTO "MASCLR"."NON_ACTIVITY_FEES" (INSTITUTION_ID, NON_ACT_FEE_PKG_ID, CHARGE_METHOD, TID, MAS_CODE, FEE_AMT, FEE_CURR, NBR_INSTALLMENTS, THRESHOLD, GENERATE_FREQ, GEN_DATE_LIST_ID, LAST_GENERATE_DATE, NEXT_GENERATE_DATE, DAY_OF_MONTH, START_DAY_MONTH, END_DAY_MONTH, CARD_SCHEME) VALUES ('121', '85',        'B ', '010004240000', '00PCINONCOMP', '10', '840', '0', '0', 'M', '0', TO_DATE('31-MAY-14', 'DD-MON-YY'), TO_DATE('30-JUN-14', 'DD-MON-YY'), '31', '0', '0', '00');

--Insert into ent_nonact_fee_pkg (INSTITUTION_ID, ENTITY_ID, NON_ACT_FEE_PKG_ID, START_DATE, END_DATE, INC_CHILD_ENT_FLAG)
--    values ('101', '000590003002003', '80000', to_date('29-FEB-12', 'DD-MON-YY'), to_date('05-FEB-13', 'DD-MON-YY'), null);

