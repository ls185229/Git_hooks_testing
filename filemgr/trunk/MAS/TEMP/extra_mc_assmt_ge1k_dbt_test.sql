set pagesize 60

variable year_var     varchar2(30)
variable month_var    varchar2(30)
variable inst_id_var  varchar2(30)

exec :year_var    := '2016'
exec :month_var   := '07'
exec :inst_id_var := '107'

-- sqlplus
set verify off

define arn_var            = "''"

--select * from in_draft_main where idm.arn in (&arn_var) ;

            SELECT
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original CURR_CD,
                case when mcg.mas_code in ('MCDB', 'MCPP') then 'MC_ASSMT_GE1K_DBT'
                     when mcg.mas_code in ('MCCR') then 'MC_ASSMT_GE1K'
                     else 'MC_ASSMT_GE1K' --|| mtl.mas_code
                     end mas_code,
                COUNT(mtl.trans_seq_nbr) COUNT,
                SUM(mtl.amt_original) amount
            FROM masclr.mas_trans_log mtl
            left outer join mas_code_grp mcg
            on mcg.institution_id = mtl.institution_id
            and mcg.mas_code_grp_id = 60
            and mcg.qualify_mas_code = mtl.mas_code
            WHERE
                  mtl.gl_date >=          to_date(:year_var || :month_var, 'YYYYMM')
              AND mtl.gl_date <= last_day(to_date(:year_var || :month_var, 'YYYYMM'))
              AND mtl.institution_id               = :inst_id_var
              AND mtl.card_scheme                  = '05'
              AND mtl.tid                         IN (
                  '010003005101', '010003005103', '010003005104',
                  '010003005105', '010003005106', '010003005107',
                  '010003005108', '010003005109', '010003005301')
              and mtl.amt_original >= 1000
            group by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original,
                case when mcg.mas_code in ('MCDB', 'MCPP') then 'MC_ASSMT_GE1K_DBT'
                     when mcg.mas_code in ('MCCR') then 'MC_ASSMT_GE1K'
                     else 'MC_ASSMT_GE1K' -- || mtl.mas_code
                     end
            order by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme
