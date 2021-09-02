/*********************************************ACCOUNT UPDATER*********************************************
Create new Activity Fee packages for Account updater. 
AU_CHK Fees is applied for the card transactions which does a check on the account.
The response will be received from the card network whenever the AU_CHK is initiated.
AU_UPDATE is to update the account information the response will be the new account details.
***************************************************************************************************************/
set serveroutput on;

DECLARE  
ax_auchk_fee_pkg_id_0_rate NUMBER;
vs_auchk_fee_pkg_id_0_rate NUMBER;
mc_auchk_fee_pkg_id_0_rate NUMBER;
ds_auchk_fee_pkg_id_0_rate NUMBER;
other_auchk_fee_pkg_id_0_rate NUMBER;
ax_auupd_fee_pkg_id_0_rate NUMBER;
vs_auupd_fee_pkg_id_0_rate NUMBER;
mc_auupd_fee_pkg_id_0_rate NUMBER;
ds_auupd_fee_pkg_id_0_rate NUMBER;
other_auupd_fee_pkg_id_0_rate NUMBER;
type num_array is varray(5) of NUMBER;
inst_array num_array;

BEGIN
inst_array := num_array(101,105,107,121);

-----------  ***  Might be required to add the two MAS-Codes to the MAS_CODE table.  Uncomment as necessary  *************  -----
--Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('00AU_UPDATE','00','Othr Account Updater / Success',null);
--Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('00AU_CHK','00','Othr Account Updater / Txn',null);

FOR inst IN 1 .. inst_array.count LOOP
     SELECT 
     MAX(fee_pkg_id) + 1,
     MAX(fee_pkg_id) + 2, 
     MAX(fee_pkg_id) + 3,
     MAX(fee_pkg_id) + 4, 
     MAX(fee_pkg_id) + 5,
     MAX(fee_pkg_id) + 6,
     MAX(fee_pkg_id) + 7, 
     MAX(fee_pkg_id) + 8,
     MAX(fee_pkg_id) + 9, 
     MAX(fee_pkg_id) + 10
     INTO 
     ax_auchk_fee_pkg_id_0_rate,
     vs_auchk_fee_pkg_id_0_rate,
     mc_auchk_fee_pkg_id_0_rate,
     ds_auchk_fee_pkg_id_0_rate,
     other_auchk_fee_pkg_id_0_rate,
     ax_auupd_fee_pkg_id_0_rate,
     vs_auupd_fee_pkg_id_0_rate,
     mc_auupd_fee_pkg_id_0_rate,
     ds_auupd_fee_pkg_id_0_rate,
     other_auupd_fee_pkg_id_0_rate
     FROM MASCLR.fee_pkg
     WHERE institution_id = inst_array(inst);
     
    --CREATE AU_CHK FEE_PKGS

    DBMS_output.put_line( 'Begin FEE_PKG: ');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), ax_auchk_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'03AU_CHK~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), vs_auchk_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'04AU_CHK~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), mc_auchk_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'05AU_CHK~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), ds_auchk_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'08AU_CHK~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), other_auchk_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'00AU_CHK~0~0');

    --CREATE AU_UPDATE FEE_PKGS
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), ax_auupd_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'03AU_UPDATE~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), vs_auupd_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'04AU_UPDATE~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), mc_auupd_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'05AU_UPDATE~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), ds_auupd_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'08AU_UPDATE~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)
    VALUES(inst_array(inst), other_auupd_fee_pkg_id_0_rate, 'G', TO_DATE('2021/09/01', 'YYYY/MM/DD'), NULL, NULL,'00AU_UPDATE~0~0');
     DBMS_output.put_line( 'End FEE_PKG: ');   
    
    --CREATE AU_CHK FEE PKG TID
 
    DBMS_output.put_line( 'Begin FEE_PKG_TID');
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), ax_auchk_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), vs_auchk_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), mc_auchk_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), ds_auchk_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), other_auchk_fee_pkg_id_0_rate,'010070010008');

   --CREATE AU_UPDATE FEE PKG TID
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), ax_auupd_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), vs_auupd_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), mc_auupd_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), ds_auupd_fee_pkg_id_0_rate,'010070010008'); 
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), other_auupd_fee_pkg_id_0_rate,'010070010008');
    DBMS_output.put_line( 'End FEE_PK_TID');
 
    --CREATE AU_CHK FEE PKG MAS CODE ~0 

    DBMS_output.put_line( 'Begin FEE_PKG_MAS_CODE');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), ax_auchk_fee_pkg_id_0_rate, '03AU_CHK', '03');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), vs_auchk_fee_pkg_id_0_rate, '04AU_CHK', '04');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), mc_auchk_fee_pkg_id_0_rate, '05AU_CHK', '05');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), ds_auchk_fee_pkg_id_0_rate, '08AU_CHK', '08');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), other_auchk_fee_pkg_id_0_rate, '00AU_CHK', '00');
    
    --CREATE AU_UPDATE FEE PKG MAS CODE ~0 
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), ax_auupd_fee_pkg_id_0_rate, '03AU_UPDATE', '03');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), vs_auupd_fee_pkg_id_0_rate, '04AU_UPDATE', '04');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), mc_auupd_fee_pkg_id_0_rate, '05AU_UPDATE', '05');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), ds_auupd_fee_pkg_id_0_rate, '08AU_UPDATE', '08');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), other_auupd_fee_pkg_id_0_rate, '00AU_UPDATE', '00');
    DBMS_output.put_line( 'End FEE_PKG_MAS_CODE');
    
	--CREATE AU_CHK MAS FEES ~0 
    DBMS_output.put_line( 'Begin MAS_FEES');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),ax_auchk_fee_pkg_id_0_rate,'010070010008','03AU_CHK','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),vs_auchk_fee_pkg_id_0_rate,'010070010008','04AU_CHK','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),mc_auchk_fee_pkg_id_0_rate,'010070010008','05AU_CHK','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),ds_auchk_fee_pkg_id_0_rate,'010070010008','08AU_CHK','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),other_auchk_fee_pkg_id_0_rate,'010070010008','00AU_CHK','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','00','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    --CREATE  AU_UPDATE MAS FEES ~0 
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),ax_auupd_fee_pkg_id_0_rate,'010070010008','03AU_UPDATE','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),vs_auupd_fee_pkg_id_0_rate,'010070010008','04AU_UPDATE','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),mc_auupd_fee_pkg_id_0_rate,'010070010008','05AU_UPDATE','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),ds_auupd_fee_pkg_id_0_rate,'010070010008','08AU_UPDATE','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');
    INSERT INTO MASCLR.MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TXN_CURR,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG,EXT_AMT1_METHOD,EXT_TXN1,EXT_CNT1_METHOD,EXT_AMT2_METHOD,EXT_TXN2,EXT_CNT2_METHOD,EXT_AMT3_METHOD,EXT_TXN3,EXT_CNT3_METHOD,EXT_AMT4_METHOD,EXT_TXN4,EXT_CNT4_METHOD) 
    VALUES (inst_array(inst),other_auupd_fee_pkg_id_0_rate,'010070010008','00AU_UPDATE','000','010004270000',to_date('01-SEP-21','DD-MON-RR'),'C',0,0,'840','00','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null,'I','I','I','I','I','I','I','I','I','I','I','I');

     DBMS_output.put_line( 'End MAS_FEES');
     --UPDATE SEQ CTRL Table
    UPDATE MASCLR.seq_ctrl
    SET last_seq_nbr = other_auupd_fee_pkg_id_0_rate
    WHERE seq_name = 'fee_pkg_id'
    AND institution_id = inst_array(inst);
END LOOP;
COMMIT;
END;
