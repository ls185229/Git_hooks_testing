REM

REM $Id: 8_0_update assessment_rates.sql 17 2016-10-25 15:22:05Z bjones $

REM INSERTING into MAS_FEES
SET DEFINE OFF;
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003005101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003005101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003005101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003005101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003005103', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003005103', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003005103', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003005103', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003005201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003005201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003005201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003005201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003005301', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003005301', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003005301', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003005301', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003005401', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '-', '-', '-', '-', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003005401', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '-', '-', '-', '-', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003005401', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '-', '-', '-', '-', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003005401', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '-', '-', '-', '-', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003015101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003015101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003015101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003015101', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 11, '010003015201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 11, '010003015201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 11, '010003015201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 11, '010003015201', 'DISC_ASSMT'     , '010004030000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.13, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 12, '010070010000', 'DISC_DATA_USAGE', '010004030002', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 12, '010070010000', 'DISC_DATA_USAGE', '010004030002', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 12, '010070010000', 'DISC_DATA_USAGE', '010004030002', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 12, '010070010000', 'DISC_DATA_USAGE', '010004030002', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 45, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 45, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 45, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 45, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 45, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 45, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 45, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 45, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 47, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 47, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 47, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 47, '010070020001', 'DS_INTL_PROC'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.5 , '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 47, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 47, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 47, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 47, '010070020001', 'DS_INTL_SERV'   , '010004360000', to_date('15-apr-16', 'DD-MON-YY'), 'F', 0     , 0.80, '840', '08', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);


REM INSERTING into MAS_FEES
SET DEFINE OFF;
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 12, '010070010000', 'MC_ASSMT_FLAT'  , '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 12, '010070010000', 'MC_ASSMT_FLAT'  , '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 12, '010070010000', 'MC_ASSMT_FLAT'  , '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 12, '010070010000', 'MC_ASSMT_FLAT'  , '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '05', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);

Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('101', 12, '010070010000', 'VISA_ASSMT_FLAT', '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '04', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('105', 12, '010070010000', 'VISA_ASSMT_FLAT', '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '04', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('107', 12, '010070010000', 'VISA_ASSMT_FLAT', '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '04', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);
Insert into MAS_FEES (INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE, TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM, RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD, CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD, ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX, PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID, TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY, TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE, VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG) values ('121', 12, '010070010000', 'VISA_ASSMT_FLAT', '010004030002', to_date('15-Apr-16', 'DD-MON-YY'), 'F', 0.0195, 0   , '840', '04', '+', '+', '+', '+', 'I', 'I', null, null, null, null, null, null, null, null, null, null, null, null);