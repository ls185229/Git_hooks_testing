REM

REM $Id: 4_0_add_mas_code_n_mas_fees.sql 8 2016-10-18 15:38:11Z bjones $

SELECT
    distinct TID_ACTIVITY, TID_FEE,
    min(institution_id) min_inst,
    max(institution_id) max_inst,
    count(*) cnt
--*
--    institution_id, fee_pkg_id,
--    --mas_code,
--    count(*) cnt
        FROM mas_fees
        WHERE institution_id IN
            /*('129', '130', '131', '132', '133', '134')*/
            ('101', '105', '107', '121')
            /*(, '106', '112', '113') */
        AND fee_pkg_id  in (33, 34)
        --and mas_code like '%\_BASE\_%' escape '\'
        and FEE_STATUS not in 'O'
        --IN (33, 34)
        and card_scheme != '02'
group by
    TID_ACTIVITY, TID_FEE
--    institution_id, fee_pkg_id
    --,
    --mas_code
order by 1,2
    --,3,4
;

/*
update mas_fees
set tid_fee = '010004020005'
where institution_id IN
            ('129', '130', '131', '132', '133', '134')
and FEE_PKG_ID in (33,34)
and TID_ACTIVITY = '010003005102'
and tid_fee = '010004020000';
*/
select * from institution
where  institution_id IN
            ('129', '130', '131', '132', '133', '134')
            ;
