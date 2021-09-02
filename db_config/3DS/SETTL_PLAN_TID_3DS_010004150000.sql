/*
    Include the 3DS ACTIVITY FEE TID "010004150000" to all
    the active settlement plans for institution 101,105,107,121.
    Mimic "010004150000" like existing fee tid "010004130000"
*/
INSERT INTO settl_plan_tid (
    institution_id,
    settl_plan_id,
    tid,
    curr_code,
    card_scheme,
    settl_flag,
    posting_entity_id,
    gl_acct_debit,
    gl_acct_credit,
    delay_factor0,
    delay_factor1,
    delay_factor2,
    delay_factor3,
    delay_factor4,
    delay_factor5,
    delay_factor6,
    settl_freq,
    settl_date_list_id,
    next_settl_date,
    payment_term,
    parent_iso_tid,
    tid_reserve,
    day_of_month,
    hol_delay_factor,
    split_fee_type,
    item_cnt_plan_id
)
    SELECT DISTINCT
        spt.institution_id,
        spt.settl_plan_id,
        '010004150000' tid,
        spt.curr_code,
        spt.card_scheme,
        spt.settl_flag,
        spt.posting_entity_id,
        spt.gl_acct_debit,
        spt.gl_acct_credit,
        spt.delay_factor0,
        spt.delay_factor1,
        spt.delay_factor2,
        spt.delay_factor3,
        spt.delay_factor4,
        spt.delay_factor5,
        spt.delay_factor6,
        spt.settl_freq,
        spt.settl_date_list_id,
        spt.next_settl_date,
        spt.payment_term,
        spt.parent_iso_tid,
        spt.tid_reserve,
        spt.day_of_month,
        spt.hol_delay_factor,
        spt.split_fee_type,
        spt.item_cnt_plan_id
    FROM
        settl_plan_tid   spt
        JOIN acq_entity ae 
        ON ae.settl_plan_id = spt.settl_plan_id
        AND ae.institution_id = spt.institution_id
    WHERE
        spt.institution_id IN (101,105,107,121)
        AND spt.tid = '010004130000'
        AND ae.entity_status = 'A'
        AND spt.card_scheme NOT IN ('07','09','12')
    MINUS
    SELECT
        *
    FROM
        settl_plan_tid
    WHERE
        tid = '010004150000'
    ORDER BY 1,2,3,4,5; 
COMMIT;
