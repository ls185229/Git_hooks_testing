--anonymous block completed

--Database:AUTHQA at:2016-04-20 16:31:31
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007115, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007115'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007115 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007121, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007121'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007121 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007125, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007125'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007125 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007128, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007128'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007128 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007679, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007679'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007679 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007682, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007682'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007682 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105007685, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105007685'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105007685 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105108857, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105108857'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105108857 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105110159, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105110159'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105110159 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105111461, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105111461'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105111461 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105125256, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105125256'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105125256 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (105, 105126411, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '105'
        and mfl.fee_pkg_id = '105126411'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:105 105126411 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007115, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007115'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007115 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007121, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007121'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007121 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007125, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007125'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007125 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007128, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007128'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007128 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007679, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007679'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007679 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007682, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007682'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007682 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107007685, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            4.5 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107007685'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107007685 7.5 4.5
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107108260, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107108260'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107108260 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107108660, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107108660'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107108660 13 10
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107108735, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10.75 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107108735'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107108735 13.75 10.75
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107108860, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107108860'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107108860 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107109562, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107109562'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107109562 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107109962, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107109962'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107109962 13 10
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107110037, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10.75 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107110037'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107110037 13.75 10.75
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107110162, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107110162'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107110162 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107110864, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107110864'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107110864 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107111264, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107111264'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107111264 13 10
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107111339, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10.75 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107111339'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107111339 13.75 10.75
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107111464, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107111464'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107111464 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107126320, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            7 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107126320'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107126320 10 7
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (107, 107126321, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            12 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '107'
        and mfl.fee_pkg_id = '107126321'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:107 107126321 15 12
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 128257, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '128257'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 128257 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 128657, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '128657'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 128657 13 10
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 129559, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '129559'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 129559 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 129959, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '129959'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 129959 13 10
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 130861, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            6 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '130861'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 130861 9 6
   insert into fee_pkg_tid (institution_id, fee_pkg_id, tid_activity) values (121, 131261, '010003005102');
           Insert into MAS_FEES (
            INSTITUTION_ID,
            FEE_PKG_ID,
            TID_ACTIVITY,
            MAS_CODE, TID_FEE,
            EFFECTIVE_DATE,
            FEE_STATUS,
            RATE_PER_ITEM,
            RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG)

        select
            INSTITUTION_ID,
            FEE_PKG_ID,
            '010003005102' TID_ACTIVITY,
            MAS_CODE,
            '010004010005' TID_FEE,
            trunc(sysdate) EFFECTIVE_DATE,
            'F' FEE_STATUS,
            RATE_PER_ITEM,
            10 RATE_PERCENT,
            FEE_CURR,
            CARD_SCHEME,
            AMT_METHOD,
            CNT_METHOD,
            ADD_AMT1_METHOD,
            ADD_CNT1_METHOD,
            ADD_AMT2_METHOD,
            ADD_CNT2_METHOD,
            PER_TRANS_MAX,
            PER_TRANS_MIN,
            FEE_GRP_ID,
            ITEM_CNT_PLAN_ID,
            TIER_ID, TIER_FREQ,
            TIER_DATE_LIST_ID,
            TIER_ASSM_DAY,
            TIER_NXT_ASSM_DATE,
            TIER_LASTASSM_DATE,
            VARIABLE_PRICE_FLG,
            SLIDING_PRICE_FLG
        from mas_fees mfl
        where
            mfl.institution_id = '121'
        and mfl.fee_pkg_id = '131261'
        and mfl.TID_ACTIVITY = '010003005101'
        and mfl.fee_status = 'C' ;
--Inst:121 131261 13 10
--Usage / Card rows:39 rows added:39
--Database:AUTHQA at:2016-04-20 16:31:32


REM INSERTING into fee_pkg_tid
SET DEFINE OFF;
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007115,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007121,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007125,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007128,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007679,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007682,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105007685,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105108857,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105110159,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105111461,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105125256,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('105',105126411,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007115,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007121,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007125,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007128,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007679,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007682,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107007685,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107108260,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107108660,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107108735,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107108860,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107109562,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107109962,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107110037,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107110162,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107110864,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107111264,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107111339,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107111464,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107126320,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('107',107126321,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',128257,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',128657,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',129559,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',129959,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',130861,'010003005201');
Insert into fee_pkg_tid (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY) values ('121',131261,'010003005201');


REM INSERTING into MAS_FEES
SET DEFINE OFF;
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007115,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007121,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007125,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007128,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007679,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007682,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105007685,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105108857,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105110159,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105111461,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105125256,'010003005201','AMEX_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('105',105126411,'010003005201','AMEX_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007115,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007121,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007125,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007128,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007679,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007682,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107007685,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,4.5,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107108260,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107108660,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107108735,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10.75,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107108860,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107109562,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107109962,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107110037,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10.75,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107110162,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107110864,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107111264,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107111339,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10.75,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107111464,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107126320,'010003005201','AMEX_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,7,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('107',107126321,'010003005201','AMEX_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,12,'840','03','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',128257,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',128657,'010003005201','VISA_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','04','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',129559,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',129959,'010003005201','MC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','05','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',130861,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,6,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
Insert into MAS_FEES (INSTITUTION_ID,FEE_PKG_ID,TID_ACTIVITY,MAS_CODE,TID_FEE,EFFECTIVE_DATE,FEE_STATUS,RATE_PER_ITEM,RATE_PERCENT,FEE_CURR,CARD_SCHEME,AMT_METHOD,CNT_METHOD,ADD_AMT1_METHOD,ADD_CNT1_METHOD,ADD_AMT2_METHOD,ADD_CNT2_METHOD,PER_TRANS_MAX,PER_TRANS_MIN,FEE_GRP_ID,ITEM_CNT_PLAN_ID,TIER_ID,TIER_FREQ,TIER_DATE_LIST_ID,TIER_ASSM_DAY,TIER_NXT_ASSM_DATE,TIER_LASTASSM_DATE,VARIABLE_PRICE_FLG,SLIDING_PRICE_FLG) values ('121',131261,'010003005201','DISC_T1','010004010005',to_date('20-APR-16','DD-MON-YY'),'F',0,10,'840','08','+','+','+','+','I','I',null,null,null,null,null,null,null,null,null,null,null,null);
