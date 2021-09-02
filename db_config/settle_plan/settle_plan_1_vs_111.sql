select
    INSTITUTION_ID
    --, SETTL_PLAN_ID
    , TID
    , CURR_CODE
    , CARD_SCHEME
    , SETTL_FLAG
    , POSTING_ENTITY_ID
    , GL_ACCT_DEBIT
    , GL_ACCT_CREDIT
    , DELAY_FACTOR0
    , DELAY_FACTOR1
    , DELAY_FACTOR2
    , DELAY_FACTOR3
    , DELAY_FACTOR4
    , DELAY_FACTOR5
    , DELAY_FACTOR6
    , SETTL_FREQ
    , SETTL_DATE_LIST_ID
    , NEXT_SETTL_DATE
    , PAYMENT_TERM
    , PARENT_ISO_TID
    , TID_RESERVE
    , DAY_OF_MONTH
    , HOL_DELAY_FACTOR
from settl_plan_tid
where settl_plan_id = 111
and institution_id in ('101', '105', '107', '121')


minus

select
    INSTITUTION_ID
    --, SETTL_PLAN_ID
    , TID
    , CURR_CODE
    , CARD_SCHEME
    , SETTL_FLAG
    , POSTING_ENTITY_ID
    , GL_ACCT_DEBIT
    , GL_ACCT_CREDIT
    , DELAY_FACTOR0
    , DELAY_FACTOR1
    , DELAY_FACTOR2
    , DELAY_FACTOR3
    , DELAY_FACTOR4
    , DELAY_FACTOR5
    , DELAY_FACTOR6
    , SETTL_FREQ
    , SETTL_DATE_LIST_ID
    , NEXT_SETTL_DATE
    , PAYMENT_TERM
    , PARENT_ISO_TID
    , TID_RESERVE
    , DAY_OF_MONTH
    , HOL_DELAY_FACTOR
from settl_plan_tid
where settl_plan_id = 1
and institution_id in ('101', '105', '107', '121')

;
