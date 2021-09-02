REM

REM $Id: 7_6_update_rates_usa_2016_10_testing.sql 28 2017-05-16 16:24:40Z bjones $

set linesize 1000

variable mf_cr_institution_id  varchar2(30)
variable mf_cr_fee_pkg_id      varchar2(30)
variable mc_cr_temp_mc         varchar2(30)
variable mc_cr_mas_code        varchar2(30)
variable eff_date              varchar2(30)
--variable mf_cr_tid_activity    varchar2(30)
--variable mf_cr_tid_fee         varchar2(30)
variable mc_cr_rate_per_item  number
variable mc_cr_rate_percent   number
variable mc_cr_per_trans_max  number

variable mf_cr_rate_per_item   number
variable mf_cr_rate_percent    number
variable mf_cr_per_trans_max   number


exec :mf_cr_institution_id := '129'
exec :mf_cr_fee_pkg_id     := '33'
exec :mc_cr_temp_mc        := 'DISC_JP_BASE_TIER1'
exec :mc_cr_mas_code       := '08CNAVP1CC'
exec :eff_date            := '16-oct-16'
--exec :mf_cr_tid_activity   := '010003005101'
--exec :mf_cr_tid_fee        := '010004020000'
exec :mc_cr_rate_per_item := '0'
exec :mc_cr_rate_percent  := '1.58'
exec :mc_cr_per_trans_max := null

exec :mf_cr_rate_per_item  := '0'
exec :mf_cr_rate_percent   := '1.72'
exec :mf_cr_per_trans_max  := null



/*
Changing 127 33 0104CNCOMMPPI1 010003005101 010004020000 to 0 1.8 '' from 0 1.85 ''
                    || mf_cr.institution_id || ' '
                    || mf_cr.fee_pkg_id || ' '
                    || mf_cr.mas_code || ' '
                    --|| mf_cr.tid_activity || ' '
                    --|| mf_cr.tid_fee
                    || ' to '
                    || mas_code_cursor_row.rate_per_item || ' '
                    || mas_code_cursor_row.rate_percent  || ' '''
                    || mas_code_cursor_row.per_trans_max || ''''
                    || ' from '
                    || mf_cr.rate_per_item || ' '
                    || mf_cr.rate_percent  || ' '''
                    || mf_cr.per_trans_max || '''');
*/

            /*
            INSERT INTO mas_fees
                (
                INSTITUTION_ID ,
                FEE_PKG_ID ,
                TID_ACTIVITY ,
                MAS_CODE ,
                TID_FEE ,
                EFFECTIVE_DATE ,
                FEE_STATUS ,
                RATE_PER_ITEM ,
                RATE_PERCENT ,
                FEE_CURR ,
                CARD_SCHEME ,
                AMT_METHOD ,
                CNT_METHOD ,
                ADD_AMT1_METHOD ,
                ADD_CNT1_METHOD ,
                ADD_AMT2_METHOD ,
                ADD_CNT2_METHOD ,
                PER_TRANS_MAX ,
                PER_TRANS_MIN ,
                FEE_GRP_ID ,
                ITEM_CNT_PLAN_ID ,
                TIER_ID ,
                TIER_FREQ ,
                TIER_DATE_LIST_ID ,
                TIER_ASSM_DAY ,
                TIER_NXT_ASSM_DATE ,
                TIER_LASTASSM_DATE ,
                VARIABLE_PRICE_FLG ,
                SLIDING_PRICE_FLG
                )
            */

            SELECT
                mf_l.INSTITUTION_ID ,
                mf_l.FEE_PKG_ID ,
                mf_l.TID_ACTIVITY ,
                :mc_cr_mas_code mas_code ,
                mf_l.TID_FEE ,
                :eff_date Effective_date,
                'F' FEE_STATUS ,
                :mc_cr_rate_per_item rate_per_item ,
                :mc_cr_rate_percent  rate_percent ,
                i.INST_CURR_CODE FEE_CURR ,
                mf_l.card_scheme ,
                mf_l.AMT_METHOD ,
                mf_l.CNT_METHOD ,
                mf_l.ADD_AMT1_METHOD ,
                mf_l.ADD_CNT1_METHOD ,
                mf_l.ADD_AMT2_METHOD ,
                mf_l.ADD_CNT2_METHOD ,
                case when :mc_cr_per_trans_max is null then null
                    else :mc_cr_per_trans_max end
                    per_trans_max ,
                mf_l.PER_TRANS_MIN ,
                mf_l.FEE_GRP_ID ,
                mf_l.ITEM_CNT_PLAN_ID ,
                mf_l.TIER_ID ,
                mf_l.TIER_FREQ ,
                mf_l.TIER_DATE_LIST_ID ,
                mf_l.TIER_ASSM_DAY ,
                mf_l.TIER_NXT_ASSM_DATE ,
                mf_l.TIER_LASTASSM_DATE ,
                mf_l.VARIABLE_PRICE_FLG ,
                mf_l.SLIDING_PRICE_FLG
                --,
                --mf_r.*
            FROM MAS_FEES mf_l
            join institution i
            on  i.institution_id = mf_l.institution_id
            left outer join mas_fees mf_r
            on
                mf_l.INSTITUTION_ID   =  mf_r.INSTITUTION_ID
            and mf_l.FEE_PKG_ID       =  mf_r.FEE_PKG_ID
            and mf_l.TID_ACTIVITY     =  mf_r.TID_ACTIVITY
            and mf_l.MAS_CODE         =  :mc_cr_temp_mc
            and mf_r.MAS_CODE         =  :mc_cr_mas_code
            and mf_l.TID_FEE          =  mf_r.TID_FEE
            and mf_r.fee_status       in ('C', 'F')
            --and mf_l.rate_per_item = :mf_cr_rate_per_item
            --and mf_r.rate_per_item = :mc_cr_rate_per_item
            --and mf_l.rate_percent  = :mf_cr_rate_percent
            --and mf_r.rate_percent  = :mc_cr_rate_percent

            and :eff_date   =  mf_r.EFFECTIVE_DATE

            WHERE
                mf_l.institution_id = :mf_cr_institution_id
            and mf_l.fee_pkg_id     = :mf_cr_fee_pkg_id
            and mf_l.mas_code       = :mc_cr_temp_mc
            --and mf_l.rate_per_item  = :mf_cr_rate_per_item
            --and mf_l.rate_percent   = :mf_cr_rate_percent
            --and mf_l.per_trans_max  = :mf_cr_per_trans_max
            --and mf_l.tid_activity   = :mf_cr_tid_activity
            --and mf_l.tid_fee        = :mf_cr_tid_fee
            --and mf_l.fee_curr       = i.inst_curr_code
            and mf_r.institution_id is null
            ;
