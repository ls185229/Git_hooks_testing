/*
    Include the 3DS ACTIVITY FEE TID "010004150000" to all
    the active posting plans for institution 101,105,107,121.
    Mimic "010004150000" like existing fee tid "010004130000"
*/
INSERT INTO acct_posting_plan (
    institution_id,
    acct_pplan_id,
    tid_to_post,
    curr_code,
    card_sch_to_post,
    entity_acct_id,
    acct_posting_type,
    payment_method_cd,
    acct_accum_method,
    payment_cycle,
    inst_cnv_plan_id
)
    SELECT DISTINCT
        app.institution_id,
        app.acct_pplan_id,
        '010004150000' tid_to_post,
        app.curr_code,
        app.card_sch_to_post,
        app.entity_acct_id,
        app.acct_posting_type,
        app.payment_method_cd,
        app.acct_accum_method,
        app.payment_cycle,
        app.inst_cnv_plan_id
    FROM
        acct_posting_plan   app
        JOIN acq_entity ae 
        ON ae.acct_pplan_id = app.acct_pplan_id
        AND ae.institution_id = app.institution_id
    WHERE
        app.institution_id IN (101,105,107,121)
        AND app.tid_to_post = '010004130000'
        AND ae.entity_status = 'A'
        AND app.card_sch_to_post NOT IN ('07','09','12')
    MINUS
    SELECT
        *
    FROM
        acct_posting_plan
    WHERE
        tid_to_post = '010004150000'
        AND institution_id IN (101,105,107,121)
    ORDER BY
        1,2,3,4,5; 

COMMIT;
