/*
    File Name - monthly_settle.sql

    Description - This file implements the two new default monthly_settle fee packages.
    
    Details - This is a sql script that creates, adds or updates the following:
    - Two new mas fees for institutions 101, 105, 107, 121 with mas_code 
    'MONTHLY_SETTLE' and rate_percent 0 and 0.04 respectively
    - Two new fee packages for institutions 101, 105, 107, 121 linked to the two
    mas fees created. These fee packages will have names 
    'MONTHLY_SETTLE~0~0' and 'MONTHLY_SETTLE~0.04~0' to correspond
    with the mas fees of rate_percent 0 and 0.04 respectively and fee_pkg_id
    equal to the last_seq_nbr+1 and last_seq_nbr+2 in the seq_ctrl table for the 
    given institution and seq_name 'fee_pkg_id'.
    - Two new entries in both the fee_pkg_tid and fee_pkg_mas_code table for 
    institutions 101, 105, 107, and 121 to enable the use of the two new fee 
    packages
    - An entry in the entity_fee_pkg table for each entity currently attached to
    fee package of id 46 as that is where the old MONTHLY_SETTLE fee was applied
    - Sets the fee_status field of each mas fee with institution_id 101, 105, 107, or
    121, mas_code 'MONTHLY_SETTLE' and fee_pkg_id 46 to 'O'.
    - Update the seq_ctrl table to reflect the new last_seq_nbr for the fee_pkg_id's
    within the given institutions.
*/
DECLARE
fee_pkg_id_0_rate NUMBER;
fee_pkg_id_04_rate NUMBER;
type num_array is varray(5) of NUMBER;
inst_array num_array;
type entity_table is table of VARCHAR2(30);
entities entity_table;
BEGIN

--CHANGE 'C' to 'O' on each pre-existing MONTHLY_SETTLE mas_fee
UPDATE MASCLR.mas_fees
SET fee_status = 'O'
WHERE mas_code = 'MONTHLY_SETTLE'
AND fee_pkg_id = 46;

--CREATE fee_pkg + mas_fee w/ rate 0 and 0.04 for each institution
inst_array := num_array(101,105,107,121);
FOR inst IN 1 .. inst_array.count LOOP

    -- USE ON PRODUCTION ONLY
    /*
    SELECT last_seq_nbr + 1, last_seq_nbr + 2
    INTO fee_pkg_id_0_rate, fee_pkg_id_04_rate
    FROM MASCLR.seq_ctrl
    WHERE seq_name = 'fee_pkg_id'
    AND institution_id = inst_array(inst);
    */
    
    -- USE ON AUTHQA
    /*
    SELECT MAX(fee_pkg_id) + 1, MAX(fee_pkg_id) + 2 
    INTO fee_pkg_id_0_rate, fee_pkg_id_04_rate
    FROM MASCLR.fee_pkg
    WHERE institution_id = inst_array(inst);
    */

    --CREATE FEE_PKGS
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)  
    VALUES(inst_array(inst), fee_pkg_id_0_rate, 'G', TO_DATE('2021/04/01', 'YYYY/MM/DD'), NULL, NULL,  'MONTHLY_SETTLE~0~0');
    INSERT INTO MASCLR.fee_pkg (institution_id, fee_pkg_id, fee_pkg_type,  fee_start_date, fee_end_date, last_eval_date, fee_pkg_name)  
    VALUES(inst_array(inst), fee_pkg_id_04_rate, 'G', TO_DATE('2021/04/01', 'YYYY/MM/DD'), NULL, NULL,  'MONTHLY_SETTLE~0.04~0');

    --CREATE FEE PKG TID
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), fee_pkg_id_0_rate,'010070020001');
    INSERT INTO MASCLR.fee_pkg_tid (institution_id, fee_pkg_id, tid_activity)
    VALUES(inst_array(inst), fee_pkg_id_04_rate,'010070020001');
     
     --CREATE FEE PKG MAS CODE
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), fee_pkg_id_0_rate, 'MONTHLY_SETTLE', '00');
    INSERT INTO MASCLR.fee_pkg_mas_code (institution_id, fee_pkg_id, mas_code, card_scheme)
    VALUES(inst_array(inst), fee_pkg_id_04_rate, 'MONTHLY_SETTLE', '00');
       
    --CREATE MAS_FEES
    INSERT INTO MASCLR.mas_fees (institution_id, fee_pkg_id, tid_activity, mas_code, tid_fee, effective_date, fee_status, rate_per_item, rate_percent, fee_curr, card_scheme, amt_method, cnt_method, txn_curr, ext_amt1_method, ext_txn1, ext_cnt1_method, ext_amt2_method, ext_txn2, ext_cnt2_method, ext_amt3_method, ext_txn3, ext_cnt3_method, ext_amt4_method, ext_txn4, ext_cnt4_method)
    VALUES(inst_array(inst), fee_pkg_id_0_rate, '010070020001', 'MONTHLY_SETTLE', '010004240000', TO_DATE('2021/04/01', 'YYYY/MM/DD'), 'C', 0, 0, '840', '00', '+', '+', '000', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I');
    INSERT INTO MASCLR.mas_fees (institution_id, fee_pkg_id, tid_activity, mas_code, tid_fee, effective_date, fee_status, rate_per_item, rate_percent, fee_curr, card_scheme, amt_method, cnt_method, txn_curr, ext_amt1_method, ext_txn1, ext_cnt1_method, ext_amt2_method, ext_txn2, ext_cnt2_method, ext_amt3_method, ext_txn3, ext_cnt3_method, ext_amt4_method, ext_txn4, ext_cnt4_method)
    VALUES(inst_array(inst), fee_pkg_id_04_rate, '010070020001', 'MONTHLY_SETTLE', '010004240000', TO_DATE('2021/04/01', 'YYYY/MM/DD'), 'C', 0, .04, '840', '00', '+', '+', '000', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I');
    
    --UPDATE ENTITY FEE PKG Table
    SELECT DISTINCT entity_id
    BULK COLLECT INTO entities
    FROM MASCLR.entity_fee_pkg
    WHERE fee_pkg_id = 46
    AND institution_id = inst_array(inst);
    FOR entity IN 1 .. entities.count LOOP
        INSERT INTO MASCLR.entity_fee_pkg (institution_id, entity_id, fee_pkg_id, start_date, fee_pkg_type)
        VALUES(inst_array(inst), entities(entity), fee_pkg_id_04_rate, TO_DATE('2021/04/01', 'YYYY/MM/DD'),'G');
    END LOOP;
    
    --UPDATE SEQ CTRL Table
    UPDATE MASCLR.seq_ctrl
    SET last_seq_nbr = fee_pkg_id_04_rate
    WHERE seq_name = 'fee_pkg_id'
    AND institution_id = inst_array(inst);

END LOOP;
END;