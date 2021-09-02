#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: wells_fargo_thinfile.tcl 4605 2018-06-06 17:25:20Z bjones $
# $Rev: 4605 $
################################################################################

################################################################################
#
#    File Name     wells_fargo_thinfile.tcl
#
#    Description   This is a monthly custom report for Wells Fargo to report
#                  all transactions volume and counts for the month.
#
#    Arguments     $1 Date to run the report. e.g. YYYYMMDD
#                  This script can run with or without a date. If no date
#                  provided it will use start and end of the last month. With
#                  one date argument, the script will calculatethe month start
#                  and end based on the given date.
#
#    Example       With date argument:  wells_fargo_thinfile.tcl -d 20140501
#
#    Return        0 = Success
#                  1 = Fail
#
################################################################################

package require Oratcl

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Get the DB variables
#
#    Arguments - 
#
#    Return -
#
###############################################################################

proc readCfgFile {} {
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db
   global mail_err
   global mail_to

   set cfg_file_name wells_thinfile.cfg

   set clr_db_logon ""
   set clr_db ""
   set auth_db_logon ""
   set auth_db ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts "File Open Err: Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ~]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB" {
            set auth_db [lindex $line_parms 1]
         }
         "MAIL_ERR" {
            set mail_err [lindex $line_parms 1]
         }
         "MAIL_TO" {
            set mail_to [lindex $line_parms 1]
            puts "Mail To:     $mail_to"
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
       puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }

   if {$auth_db_logon == ""} {
       puts "Unable to find AUTH_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }
}

#########################################
# connect_to_db
# handles connections to the database
#########################################

proc connect_to_db {} {
   global auth_logon_handle mas_logon_handle
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db
   global mail_err
   global mail_to

   if {[catch {set auth_logon_handle [oralogon $auth_db_logon@$auth_db]} result] } {
        puts "Encountered error $result while trying to connect to AUTH_DB"
        exit 1
   } else {
        puts "Connected to AUTH_DB" 
   }
   if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts "Connected to CLR_DB"
   }

};


# Setting up the date range

if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 date_arg] } {
      puts "Date argument: $date_arg"
      set given_date $date_arg
}

if {![info exists given_date]} {
      set report_date [clock format [clock seconds] -format "%Y%m"]
      set file_date $report_date
      append file_date "01"
      set end_date $report_date
      append end_date "01160000"
      set start_date  [clock format [clock add [clock scan $report_date -format "%Y%m"] -1 months] -format "%Y%m"]
      set amex_date $start_date
      append start_date "01160000"
} else {
      set report_date [clock format [clock scan $given_date -format %Y%m%d ] -format %Y%m]
      set file_date $report_date
      append file_date "01"
      set start_date $report_date
      set amex_date $start_date
      append start_date "01160000"
      set end_date    [clock format [clock add [clock scan $given_date -format "%Y%m%d"] +1 months] -format "%Y%m"] 
      append end_date "01160000"
}
set lastdayprevmonth [clock format [clock add [clock scan $file_date] -1 day] -format "%Y%m%d"]

puts "wells_fargo_thinfile_report.tcl Started at: [clock format [clock seconds] -format "%Y%m%d@%H:%M:%S"]"
puts "Report Date: $report_date"
puts "Amex Date:   $amex_date"
puts "Start Date:  $start_date"
puts "End Date:    $end_date"
puts "File Date:   $file_date"
puts "Last Date Prev Month: $lastdayprevmonth"

set fileName "1245_AltE_$lastdayprevmonth"
append fileName "_Jetpay_ThinFile.tsv"

puts "Report Name: $fileName"

set header    "Report Month|Merchant Account|Merchant Legal Name|Merchant DBA Name|Merchant Descriptor|Multiple Descriptor Flag|"
append header "Multiple Descriptor Count|Merchant Registration ID|Merchant Household ID|Merchant Household Name|Affliate ID|"
append header "Affiliate Name|Account Status|Date Opened|Date Closed|MCC|Sales Count Visa|Sales Count MC|Sales Count AX|"
append header "Sales Count DS|Sales Amount Visa|Sales Amount MC|Sales Amount AX|Sales Amount DS|Chargeback Count Visa|"
append header "Chargeback Count MC|Chargeback Count AX|Chargeback Count DS|Chargeback Amount Visa|Chargeback Amount MC|"
append header "Chargeback Amount AX|Chargeback Amount DS|Credits Count Visa|Credits Count MC|Credits Count AX|Credits Count DS|"
append header "Credits Amount Visa|Credits Amount MC|Credits Amount AX|Credits Amount DS|% Card Not Present Count Visa|"
append header "% Card Not Present Count MC|% Card Not Present Count AX|% Card Not Present Count DS|% Card Not Present Amount Visa|"
append header "% Card Not Present Amount MC|% Card Not Present Amount AX|% Card Not Present Amount DS|Reserve Amount|"
	append header "Website Address|DBA Phone|DBA Street|DBA City|DBA State|DBA Zip|Country|"
	append header "Pin Debit Count|Pin Debit Amount|Pin Debit Chargeback Count|Pin Debit Chargeback Amount|Pin Debit Refunds Count|Pin Debit Refunds Amount|"

exec echo $header >> $fileName

set conversion 0

if {$conversion == 0} {
    append header "Website Address|DBA Phone|DBA Address - Street|DBA Address - City|DBA Address - State|DBA Address - ZIP|DBA Address - Country"
}

set body ""

##################
#####  MAIN  #####
##################

readCfgFile

connect_to_db

set auth_sql  [oraopen $auth_logon_handle]
set auth_sql1 [oraopen $auth_logon_handle]
set mas_sql   [oraopen $mas_logon_handle]
set mas_sql1  [oraopen $mas_logon_handle]
set pmas_sql  [oraopen $mas_logon_handle]
  
set merch_id "000000000000000"
set amt_cb   "case when trans_ccd = '840' then amt_trans ELSE case when recon_ccd = '840' THEN amt_recon end end"

#set Query_sql "
#    SELECT idm.merch_id,
#       ae.entity_name,
#       ae.entity_dba_name,
#       to_char(ae.creation_date,'YYYYMMDD') as creation_date,
#       ae.entity_status,
#       ae.default_mcc,
#       to_char(ae.termination_date,'YYYYMMDD') as termination_date,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0) AS AX_Sales_NP_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)             AS AX_Sales_NP_count,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                            AS AX_Sales_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                               AS AX_Sales_count,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                            AS AX_credit_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                        AS AX_credit_count,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                              AS AX_cb_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                        AS AX_cb_count,

#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0) AS VS_Sales_NP_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)             AS VS_Sales_NP_count,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                            AS VS_Sales_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                        AS VS_Sales_count,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                            AS VS_credit_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                        AS VS_credit_count,
#       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                              AS VS_cb_AMOUNT,
#      nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                        AS VS_cb_count,       

#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0) AS MC_Sales_NP_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)             AS MC_Sales_NP_count,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                            AS MC_Sales_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                        AS MC_Sales_count,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                            AS MC_credit_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                        AS MC_credit_count,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                              AS MC_cb_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                        AS MC_cb_count,

#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' and pos_crd_present <> '1' 
#                                                                 THEN amt_trans ELSE 0 END)/100,0)                               AS DS_Sales_NP_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' and pos_crd_present <> '1' 
#                                                                 THEN 1 ELSE 0 END),0)                                           AS DS_Sales_NP_count,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0) AS DS_Sales_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' THEN 1 ELSE 0 END),0)             AS DS_Sales_count,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0) AS DS_credit_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005102' THEN 1 ELSE 0 END),0)             AS DS_credit_count,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)   AS DS_cb_AMOUNT,
#       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103015101' THEN 1 ELSE 0 END),0)             AS DS_cb_count,

#       ma.url,
#       ma.postal_cd_zip,
#       ma.country,
#       ma.phone1,
#       ma.address1,
#       ma.city,
#       ma.prov_state_abbrev
#    FROM port.WELLS_FG_MAIN idm       
#         RIGHT JOIN port.WELLS_FG_ACQENT ae 
#            on idm.merch_id = ae.entity_id
#         JOIN masclr.acq_entity_address aea 
#            on aea.institution_id = ae.institution_id and aea.entity_id = ae.entity_id
#         JOIN masclr.master_address ma 
#            on ma.institution_id = aea.institution_id and ma.address_id = aea.address_id
#    WHERE ((idm.trans_dt    >= TO_DATE('$start_date','YYYYMMDDHH24MISS')
#            and idm.trans_dt < TO_DATE('$end_date','YYYYMMDDHH24MISS')
#            and tid in ('010103005101','010103005102'))
#            or 
#           (idm.activity_dt    >= TO_DATE('$start_date','YYYYMMDDHH24MISS')
#            and idm.activity_dt < TO_DATE('$end_date','YYYYMMDDHH24MISS')
#            and tid not in ('010103005101','010103005102'))
#          )
#          and aea.address_role = 'LOC'
#          and ae.institution_id in ('101','107')
#          and (termination_date >= to_date('$start_date','YYYYMMDDHH24MISS') or termination_date is null)
#          and merch_id > '$merch_id'
#          and merch_id NOT IN
#          ('000000030000318',    -- BACKPAGE.COM           
#           '455665942394',       -- BACKPAGE.COM
#           '000000030000635'     -- POSTFASTR.COM
#           )
#    GROUP BY idm.merch_id,
#          ae.entity_name,
#          ae.entity_dba_name,
#          ae.creation_date,
#          ae.entity_status,
#          ae.default_mcc,
#          ae.termination_date,
#          ma.url,
#          ma.postal_cd_zip,
#          ma.country,
#          ma.phone1,
#          ma.address1,
#          ma.city,
#          ma.prov_state_abbrev
#    ORDER BY idm.merch_id"

    # puts "Main Query: $Query_sql"

set Query_sql "
select distinct
    merch_id,
    entity_name,
    entity_dba_name,
    creation_date,
    entity_status,
    default_mcc,
    termination_date,

    sum(AX_Sales_NP_AMOUNT) AX_Sales_NP_AMOUNT,
    sum(AX_Sales_NP_count ) AX_Sales_NP_count,
    sum(AX_Sales_AMOUNT   ) AX_Sales_AMOUNT,
    sum(AX_Sales_count    ) AX_Sales_count,
    sum(AX_credit_AMOUNT  ) AX_credit_AMOUNT,
    sum(AX_credit_count   ) AX_credit_count,
    sum(AX_cb_AMOUNT      ) AX_cb_AMOUNT,
    sum(AX_cb_count       ) AX_cb_count,

    sum(VS_Sales_NP_AMOUNT) VS_Sales_NP_AMOUNT,
    sum(VS_Sales_NP_count ) VS_Sales_NP_count,
    sum(VS_Sales_AMOUNT   ) VS_Sales_AMOUNT,
    sum(VS_Sales_count    ) VS_Sales_count,
    sum(VS_credit_AMOUNT  ) VS_credit_AMOUNT,
    sum(VS_credit_count   ) VS_credit_count,
    sum(VS_cb_AMOUNT      ) VS_cb_AMOUNT,
    sum(VS_cb_count       ) VS_cb_count,

    sum(MC_Sales_NP_AMOUNT) MC_Sales_NP_AMOUNT,
    sum(MC_Sales_NP_count ) MC_Sales_NP_count,
    sum(MC_Sales_AMOUNT   ) MC_Sales_AMOUNT,
    sum(MC_Sales_count    ) MC_Sales_count,
    sum(MC_credit_AMOUNT  ) MC_credit_AMOUNT,
    sum(MC_credit_count   ) MC_credit_count,
    sum(MC_cb_AMOUNT      ) MC_cb_AMOUNT,
    sum(MC_cb_count       ) MC_cb_count,

    sum(DS_Sales_NP_AMOUNT) DS_Sales_NP_AMOUNT,
    sum(DS_Sales_NP_count ) DS_Sales_NP_count,
    sum(DS_Sales_AMOUNT   ) DS_Sales_AMOUNT,
    sum(DS_Sales_count    ) DS_Sales_count,
    sum(DS_credit_AMOUNT  ) DS_credit_AMOUNT,
    sum(DS_credit_count   ) DS_credit_count,
    sum(DS_cb_AMOUNT      ) DS_cb_AMOUNT,
    sum(DS_cb_count       ) DS_cb_count,

    url,
    postal_cd_zip,
    country,
    phone1,
    address1,
    city,
    prov_state_abbrev

FROM (
    SELECT distinct idm.merch_id,
       ae.entity_name,
       ae.entity_dba_name,
       to_char(ae.creation_date,'YYYYMMDD') as creation_date,
       ae.entity_status,
       ae.default_mcc,
       to_char(ae.termination_date,'YYYYMMDD') as termination_date,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0)   AS AX_Sales_NP_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)               AS AX_Sales_NP_count,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                              AS AX_Sales_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                          AS AX_Sales_count,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                              AS AX_credit_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                          AS AX_credit_count,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                          AS AX_cb_count,
       nvl(SUM(CASE WHEN card_scheme = '03' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                                AS AX_cb_AMOUNT,

       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0)   AS VS_Sales_NP_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)               AS VS_Sales_NP_count,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                              AS VS_Sales_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                          AS VS_Sales_count,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                              AS VS_credit_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                          AS VS_credit_count,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                                AS VS_cb_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '04' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                          AS VS_cb_count,

       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' and pos_crd_present <> '1' THEN amt_trans ELSE 0 END)/100,0)   AS MC_Sales_NP_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' and pos_crd_present <> '1' THEN 1 ELSE 0 END),0)               AS MC_Sales_NP_count,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0)                              AS MC_Sales_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005101' THEN 1 ELSE 0 END),0)                                          AS MC_Sales_count,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0)                              AS MC_credit_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103005102' THEN 1 ELSE 0 END),0)                                          AS MC_credit_count,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)                                AS MC_cb_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '05' and tid = '010103015101' THEN 1 ELSE 0 END),0)                                          AS MC_cb_count,

       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' and pos_crd_present <> '1'
                                                                 THEN     amt_trans ELSE 0 END)/100,0)                              AS DS_Sales_NP_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' and pos_crd_present <> '1'
                                                                 THEN 1 ELSE 0 END),0)                                              AS DS_Sales_NP_count,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' THEN amt_trans ELSE 0 END)/100,0) AS DS_Sales_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005101' THEN 1 ELSE 0 END),0)             AS DS_Sales_count,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005102' THEN amt_trans ELSE 0 END)/100,0) AS DS_credit_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103005102' THEN 1 ELSE 0 END),0)             AS DS_credit_count,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103015101' THEN $amt_cb ELSE 0 END)/100,0)   AS DS_cb_AMOUNT,
       nvl(SUM(CASE WHEN card_scheme = '08' and pri_dest_file_type = '83' and tid = '010103015101' THEN 1 ELSE 0 END),0)             AS DS_cb_count,

       ma.url,
       ma.postal_cd_zip,
       ma.country,
       ma.phone1,
       ma.address1,
       ma.city,
       ma.prov_state_abbrev
    FROM masclr.IN_DRAFT_MAIN idm
         RIGHT JOIN masclr.acq_entity ae
            on idm.merch_id = ae.entity_id
         JOIN masclr.acq_entity_address aea on aea.institution_id = ae.institution_id and aea.entity_id = ae.entity_id
         JOIN masclr.master_address ma on ma.institution_id = aea.institution_id and ma.address_id = aea.address_id
    WHERE
          ((idm.trans_dt    >= TO_DATE($start_date,'YYYYMMDDHH24MISS')
            and idm.trans_dt < TO_DATE($end_date,'YYYYMMDDHH24MISS')
            and tid in ('010103005101','010103005102'))
            or
           (idm.activity_dt    >= TO_DATE($start_date,'YYYYMMDDHH24MISS')
            and idm.activity_dt < TO_DATE($end_date,'YYYYMMDDHH24MISS')
            and tid not in ('010103005101','010103005102'))
          )
          and aea.address_role = 'LOC'
          and ae.institution_id in ('101','107')
          and (termination_date >= to_date($start_date,'YYYYMMDDHH24MISS') or termination_date is null)
          and merch_id > '000000000000000'
          and merch_id NOT IN
          ('000000030000318',    -- BACKPAGE.COM
           '455665942394',       -- BACKPAGE.COM
           '000000030000635'     -- POSTFASTR.COM
           )
    GROUP BY idm.merch_id,
          ae.entity_name,
          ae.entity_dba_name,
          ae.creation_date,
          ae.entity_status,
          ae.default_mcc,
          ae.termination_date,
          ma.url,
          ma.postal_cd_zip,
          ma.country,
          ma.phone1,
          ma.address1,
          ma.city,
          ma.prov_state_abbrev

  UNION

    SELECT distinct idm.merch_id,
       ae.entity_name,
       ae.entity_dba_name,
       to_char(ae.creation_date,'YYYYMMDD') as creation_date,
       ae.entity_status,
       ae.default_mcc,
       to_char(ae.termination_date,'YYYYMMDD') as termination_date,
       0 AS AX_Sales_NP_AMOUNT,
       0 AS AX_Sales_NP_count,
       0 AS AX_Sales_AMOUNT,
       0 AS AX_Sales_count,
       0 AS AX_credit_AMOUNT,
       0 AS AX_credit_count,
       0 AS AX_cb_AMOUNT,
       0 AS AX_cb_count,

       0 AS VS_Sales_NP_AMOUNT,
       0 AS VS_Sales_NP_count,
       0 AS VS_Sales_AMOUNT,
       0 AS VS_Sales_count,
       0 AS VS_credit_AMOUNT,
       0 AS VS_credit_count,
       0 AS VS_cb_AMOUNT,
       0 AS VS_cb_count,

       0 AS MC_Sales_NP_AMOUNT,
       0 AS MC_Sales_NP_count,
       0 AS MC_Sales_AMOUNT,
       0 AS MC_Sales_count,
       0 AS MC_credit_AMOUNT,
       0 AS MC_credit_count,
       0 AS MC_cb_AMOUNT,
       0 AS MC_cb_count,

       0 AS DS_Sales_NP_AMOUNT,
       0 AS DS_Sales_NP_count,
       0 AS DS_Sales_AMOUNT,
       0 AS DS_Sales_count,
       0 AS DS_credit_AMOUNT,
       0 AS DS_credit_count,
       0 AS DS_cb_AMOUNT,
       0 AS DS_cb_count,

       ma.url,
       ma.postal_cd_zip,
       ma.country,
       ma.phone1,
       ma.address1,
       ma.city,
       ma.prov_state_abbrev
    FROM masclr.IN_DRAFT_MAIN idm
         RIGHT JOIN masclr.acq_entity ae
            on idm.merch_id = ae.entity_id
         JOIN masclr.acq_entity_address aea on aea.institution_id = ae.institution_id and aea.entity_id = ae.entity_id
         JOIN masclr.master_address ma
            on ma.institution_id = aea.institution_id and ma.address_id = aea.address_id
    WHERE
        (ae.entity_status = 'A'or (entity_status = 'C' and termination_date >= to_date('20150901000000','YYYYMMDDHH24MISS')))
          and aea.address_role = 'LOC'
          and ae.institution_id in ('101','107')
          and merch_id > '000000000000000'
          and merch_id NOT IN
          ('000000030000318',    -- BACKPAGE.COM
           '455665942394',       -- BACKPAGE.COM
           '000000030000635'     -- POSTFASTR.COM
           )
    GROUP BY idm.merch_id,
          ae.entity_name,
          ae.entity_dba_name,
          ae.creation_date,
          ae.entity_status,
          ae.default_mcc,
          ae.termination_date,
          ma.url,
          ma.postal_cd_zip,
          ma.country,
          ma.phone1,
          ma.address1,
          ma.city,
          ma.prov_state_abbrev
)
    GROUP BY merch_id,
             entity_name,
             entity_dba_name,
             creation_date,
             entity_status,
             default_mcc,
             termination_date,
             url,
             postal_cd_zip,
             country,
             phone1,
             address1,
             city,
             prov_state_abbrev
  ORDER BY merch_id"

# puts $Query_sql
  
orasql $mas_sql $Query_sql

while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
      append body "[string range $start_date 0 7]|"

      if {$mas_query(ENTITY_STATUS) == "A"} {
          if {$mas_query(TERMINATION_DATE) != ""} {
              set mas_query(ENTITY_STATUS) "C"
          } else {
            set mas_query(ENTITY_STATUS) "O"
          }
      }

###################
# Calculate AMEX 
###################

#      set auth_query_sql "
#          select nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' and pos_entry <> '1' THEN amount ELSE 0 END),0) AS AX_Sales_NP_AMOUNT,
#                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' and pos_entry <> '1' THEN 1 ELSE 0 END),0)      AS AX_Sales_NP_count,
#                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' THEN amount ELSE 0 END),0)                      AS AX_Sales_AMOUNT,
#                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' THEN 1 ELSE 0 END),0)                           AS AX_Sales_count,
#                  nvl(SUM(CASE WHEN substr(request_type,0,2) = '04' THEN amount ELSE 0 END),0)                      AS AX_credit_AMOUNT,
#
#                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '04' THEN 1 ELSE 0 END),0)                           AS AX_credit_count
#          from  port.WFG_TRANHIST
#          where authdatetime like '$amex_date%' 
#                and mid in (select mid from tei_merchant where visa_id = '$mas_query(MERCH_ID)')
#                and card_type = 'AX'
#                and status in ('SET','CNV')"

      set auth_query_sql "
          select nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' and pos_entry <> '1' THEN amount ELSE 0 END),0) AS AX_Sales_NP_AMOUNT,
                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' and pos_entry <> '1' THEN 1 ELSE 0 END),0)      AS AX_Sales_NP_count,
                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' THEN amount ELSE 0 END),0)                      AS AX_Sales_AMOUNT,
                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '02' THEN 1 ELSE 0 END),0)                           AS AX_Sales_count,
                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '04' THEN amount ELSE 0 END),0)                      AS AX_credit_AMOUNT,

                 nvl(SUM(CASE WHEN substr(request_type,0,2) = '04' THEN 1 ELSE 0 END),0)                           AS AX_credit_count
          from  teihost.TRANHISTORY
          where authdatetime like '$amex_date%'
                and mid in (select mid from teihost.merchant where visa_id = '$mas_query(MERCH_ID)')
                and card_type = 'AX'
                and status in ('SET','CNV')"

     # puts "AMEX Query: $auth_query_sql"

     orasql $auth_sql $auth_query_sql

     orafetch $auth_sql -dataarray auth_query -indexbyname

      set mas_query(AX_SALES_COUNT)     [expr $mas_query(AX_SALES_COUNT)     + $auth_query(AX_SALES_COUNT)]
      set mas_query(AX_SALES_AMOUNT)    [expr $mas_query(AX_SALES_AMOUNT)    + $auth_query(AX_SALES_AMOUNT)]
      set mas_query(AX_SALES_NP_COUNT)  [expr $mas_query(AX_SALES_NP_COUNT)  + $auth_query(AX_SALES_NP_COUNT)]
      set mas_query(AX_SALES_NP_AMOUNT) [expr $mas_query(AX_SALES_NP_AMOUNT) + $auth_query(AX_SALES_NP_AMOUNT)]
      set mas_query(AX_CREDIT_COUNT)    [expr $mas_query(AX_CREDIT_COUNT)    + $auth_query(AX_CREDIT_COUNT)]
      set mas_query(AX_CREDIT_AMOUNT)   [expr $mas_query(AX_CREDIT_AMOUNT)   + $auth_query(AX_CREDIT_AMOUNT)]

###########################
# Calculate Dynamic names
###########################

      set count 0

      set query "select merch_name
                 from port.WFG_MERCHANT
                 where merch_id = '$mas_query(MERCH_ID)'
                    and trans_dt >= TO_DATE('$start_date','YYYYMMDDHH24MISS')
                    and trans_dt  < TO_DATE('$end_date','YYYYMMDDHH24MISS')
                 group by merch_name"

#     puts "Dynamic names Query: $query"

      orasql $mas_sql1 $query

      while {[orafetch $mas_sql1 -dataarray mas_query1 -indexbyname] != 1403 } {
              set count [expr $count + 1]
      }


      if {$count > 1} {
           set Descriptor_flag Y
      } else {
           set count ""
           set Descriptor_flag "N"
      }

      append body "$mas_query(MERCH_ID)|$mas_query(ENTITY_NAME)|$mas_query(ENTITY_DBA_NAME)|$mas_query(ENTITY_DBA_NAME)|"
      append body "$Descriptor_flag|$count|$mas_query(MERCH_ID)|||||$mas_query(ENTITY_STATUS)|$mas_query(CREATION_DATE)|"
      append body "$mas_query(TERMINATION_DATE)|[string trim $mas_query(DEFAULT_MCC)]|$mas_query(VS_SALES_COUNT)|"
      append body "$mas_query(MC_SALES_COUNT)|$mas_query(AX_SALES_COUNT)|$mas_query(DS_SALES_COUNT)|"
      append body "[format "%0.2f" $mas_query(VS_SALES_AMOUNT)]|[format "%0.2f" $mas_query(MC_SALES_AMOUNT)]|"
      append body "[format "%0.2f" $mas_query(AX_SALES_AMOUNT)]|[format "%0.2f" $mas_query(DS_SALES_AMOUNT)]|"
      append body "$mas_query(VS_CB_COUNT)|$mas_query(MC_CB_COUNT)|$mas_query(AX_CB_COUNT)|$mas_query(DS_CB_COUNT)|"
      append body "[format "%0.2f" $mas_query(VS_CB_AMOUNT)]|[format "%0.2f" $mas_query(MC_CB_AMOUNT)]|"
      append body "[format "%0.2f" $mas_query(AX_CB_AMOUNT)]|[format "%0.2f" $mas_query(DS_CB_AMOUNT)]|"
      append body "$mas_query(VS_CREDIT_COUNT)|$mas_query(MC_CREDIT_COUNT)|$mas_query(AX_CREDIT_COUNT)|$mas_query(DS_CREDIT_COUNT)|"
      append body "[format "%0.2f" $mas_query(VS_CREDIT_AMOUNT)]|[format "%0.2f" $mas_query(MC_CREDIT_AMOUNT)]|"
      append body "[format "%0.2f" $mas_query(AX_CREDIT_AMOUNT)]|[format "%0.2f" $mas_query(DS_CREDIT_AMOUNT)]|"

# This is to solve the problem with tcl and integer division.
      append mas_query(VS_SALES_NP_COUNT) ".0"
      append mas_query(MC_SALES_NP_COUNT) ".0"
      append mas_query(AX_SALES_NP_COUNT) ".0"
      append mas_query(DS_SALES_NP_COUNT) ".0"

      if {$mas_query(VS_SALES_COUNT) != 0 } {
          append body "[expr $mas_query(VS_SALES_NP_COUNT) / $mas_query(VS_SALES_COUNT)]|"
      } else {
          append body "0|"
      }

      if {$mas_query(MC_SALES_COUNT) != 0 } {
          append body "[expr $mas_query(MC_SALES_NP_COUNT) / $mas_query(MC_SALES_COUNT)]|"
      } else {
          append body "0|"
      }

      if {$mas_query(AX_SALES_COUNT) != 0 } {
           append body "[expr $mas_query(AX_SALES_NP_COUNT) / $mas_query(AX_SALES_COUNT)]|"
      } else {
           append body "0|"
      }

      if {$mas_query(DS_SALES_COUNT) != 0 } {
           append body "[expr $mas_query(DS_SALES_NP_COUNT) / $mas_query(DS_SALES_COUNT)]|"
      } else {
           append body "0|"
      }

      if {$mas_query(VS_SALES_AMOUNT) != 0 } {
           append body "[format "%0.2f" [expr $mas_query(VS_SALES_NP_AMOUNT) / $mas_query(VS_SALES_AMOUNT)]]|"
      } else {
           append body "0.00|"
      }

      if {$mas_query(MC_SALES_AMOUNT) != 0 } {
           append body "[format "%0.2f" [expr $mas_query(MC_SALES_NP_AMOUNT) / $mas_query(MC_SALES_AMOUNT)]]|"
      } else {
           append body "0.00|"
      }

      if {$mas_query(AX_SALES_AMOUNT) != 0 } {
           append body "[format "%0.2f" [expr $mas_query(AX_SALES_NP_AMOUNT) / $mas_query(AX_SALES_AMOUNT)]]|"
      } else {
           append body "0.00|"
      }

      if {$mas_query(DS_SALES_AMOUNT) != 0 } {
           append body "[format "%0.2f" [expr $mas_query(DS_SALES_NP_AMOUNT) / $mas_query(DS_SALES_AMOUNT)]]|"
      } else {
           append body "0.00|"
      }

######################
# Calculate Reserve
######################

      set query "
          select nvl(SUM(CASE WHEN tid = '010005050000' THEN amt_original ELSE 0 END),0)                   AS Reserve_plus,
                 nvl(SUM(CASE WHEN tid in ('010007050000','010007050100') THEN amt_original ELSE 0 END),0) AS Reserve_minus
          from port.WFG_RESEREVES
          where entity_id = '$mas_query(MERCH_ID)'
                  and gl_date  >= TO_DATE('$start_date','YYYYMMDDHH24MISS')
                  and gl_date   < TO_DATE('$end_date','YYYYMMDDHH24MISS')
                  and date_to_settle  < TO_DATE('$end_date','YYYYMMDDHH24MISS')
                  and tid in ('010005050000','010007050000','010007050100')"

#     puts "Reserve Query: $query"

      orasql $mas_sql1 $query

      orafetch $mas_sql1 -dataarray mas_query1 -indexbyname

      set reserve [format "%0.2f" [expr $mas_query1(RESERVE_PLUS) - $mas_query1(RESERVE_MINUS)]]

      append body "$reserve|"
      
######################
# Add Dmeographics
######################      
     append body "$mas_query(URL)|"
     append body "$mas_query(PHONE1)|"
     append body "$mas_query(ADDRESS1)|"
     append body "$mas_query(CITY)|"
     append body "$mas_query(PROV_STATE_ABBREV)|"
     append body "$mas_query(POSTAL_CD_ZIP)|"
     append body "$mas_query(COUNTRY)|"
     
  #    exec echo $body >> $fileName
  #    set body ""
######################
# Calculate Pin Debit
######################
     set pdquery "
  SELECT nvl(SUM(CASE WHEN tid = '010003005101' THEN 1 ELSE 0 END),0) AS PINDEBIT_SALES_COUNT,
         nvl(SUM(CASE WHEN tid = '010003005101' THEN amt_trans ELSE 0 END)/100,0) AS PINDEBIT_SALES_AMOUNT,
         nvl(SUM(CASE WHEN tid = '010003015101' THEN 1 ELSE 0 END),0) AS PINDEBIT_CB_COUNT, 
         nvl(SUM(CASE WHEN tid = '010003015101' THEN amt_trans ELSE 0 END)/100,0) AS PINDEBIT_CB_AMOUNT, 
         nvl(SUM(CASE WHEN tid = '010003005102' THEN 1 ELSE 0 END),0) AS PINDEBIT_CREDIT_COUNT,  
         nvl(SUM(CASE WHEN tid = '010003005102' THEN amt_trans ELSE 0 END)/100,0) AS PINDEBIT_CREDIT_AMOUNT
  FROM IN_DRAFT_PIN_DEBIT
  WHERE merch_id = '$mas_query(MERCH_ID)' and trans_dt >= TO_DATE('$start_date','YYYYMMDDHH24MISS') and trans_dt < TO_DATE('$end_date','YYYYMMDDHH24MISS')"
 
#puts $mas_sql1
  orasql $pmas_sql $pdquery

  orafetch $pmas_sql -dataarray pmas_query1 -indexbyname

  append body "$pmas_query1(PINDEBIT_SALES_COUNT)|"
  append body "$pmas_query1(PINDEBIT_SALES_AMOUNT)|"
  append body "$pmas_query1(PINDEBIT_CB_COUNT)|"
  append body "$pmas_query1(PINDEBIT_CB_AMOUNT)|"
  append body "$pmas_query1(PINDEBIT_CREDIT_COUNT)|"
  append body "$pmas_query1(PINDEBIT_CREDIT_AMOUNT)|"

  exec echo $body >> $fileName
  set body ""

}

 #exec echo "Please see attached." | mutt -a $fileName -s "Wells Fargo Report for $report_date" -- "$mail_to"

# Comment out the upload and move to ARCHIVE - this will be done in a separate script - send_thinfile.tcl
# exec upload.exp $fileName
# exec mv $fileName ARCHIVE

exit 0 
