
# Types of counting types
#
# VS_ISA_FEE MC_BORDER MC_GE_1K DS_INTERNATIONAL ZZACQSUPPORTFEE
#
# cnt_type      description                     filename  mas_code
#
# CANADA_TAX    Sales tax for Canada            CANADAST  00GST 00QST
# DS_INTL       Discover Int'l Service Fee      DSBORDER  DS_INTL_PROC DS_INTL_SERV
# FUND_XFER     Funds transfer counts           FUNDXFER  00FUNDXFER
# PIN_DB_ENTITY PIN Debit sponsorship fee       PINDBENT  02PINDBENT
# MC_BORDER     MasterCard Cross Border Fees    MCBORDER  MC_BORDER MC_GLOBAL_ACQ
# MC_GE_1K      MasterCard Assessment >= 1000   MCASGE1K  MC_ASSMT_GE1K MC_ASSMT_GE1K_DBT
# VS_ISA_FEE    Visa International Service Fee  VISAISAF  VS_ISA_FEE VS_INT_ACQ_FEE
# ZZACQSUPPORT  Acquirer Support (not used)     ACQSUPPO

        "MC_GE_1K" {
            set nm "
            SELECT
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original CURR_CD,
                COUNT(mtl.trans_seq_nbr) COUNT,
                SUM(mtl.amt_original) amount
            FROM masclr.mas_trans_log mtl
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
                mtl.curr_cd_original
            "
        }

        "MC_GE_1K" {
            set rec(card_scheme) "05"
            set mas_code_var "MC_ASSMT_GE1K"
            set rec(mas_code) $mas_code_var
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }

insert into mas_code () values ();
insert into fee_pkg_mas_code () values ();
insert into mas_fees () values ();
