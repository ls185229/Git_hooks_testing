#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: create_conv_residuals.tcl 
# $Rev: 4410 $
################################################################################

################################################################################
#
#    File Name     create_conv_residuals.tcl 
#
#    Description   This is a monthly residual file containing information
#                  convenience merchants collected fees, monthly fees and
#                  interchange/dues & assessments for all transactions,
#                  volume and counts for the day or month.  A daily
#                  run will total all calculations from the previous day.  A 
#                  month-end run will total all calculations from the previous
#                  month.
#
#    Arguments     $1 Parameter to denote if this is a daily or month-end run.
#
#    Example       With daily argument:     create_conv_residuals.tcl "D"
#                  With month-end argument: create_conv_residuals.tcl "D" 
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

   set cfg_file_name residual.cfg

   set clr_db_logon ""
   set clr_db ""

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
}

#########################################
# connect_to_db
# handles connections to the database
#########################################

proc connect_to_db {} {
   global mas_logon_handle
   global clr_db_logon
   global clr_db
   global mail_err
   global mail_to
   global rpt_type

   if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts "Connected to CLR_DB"
   }

};


# Setting up the date range
set rpt_type [lindex $argv 0]

if { $rpt_type == "D" } {
      set report_date [clock format [clock seconds] -format "%Y%m%d"]
      set file_date $report_date
      set end_date $report_date
      set start_date  [clock format [clock add [clock scan $end_date -format "%Y%m%d"] -1 day] -format "%Y%m%d"]
} else {
      set report_date [clock format [clock seconds] -format "%Y%m"]
      set file_date $report_date
      append report_date "01"
      set end_date $report_date
      set start_date  [clock format [clock add [clock scan $end_date -format "%Y%m%d"] -1 months] -format "%Y%m%d"]
}
  
set lastdayprevmonth [clock format [clock add [clock scan $end_date] -1 day] -format "%Y%m%d"]
puts "create_conv_residuals.tcl Started at: [clock format [clock seconds] -format "%Y%m%d@%H:%M:%S"]"
puts "Report Date: $report_date"
puts "Start Date:  $start_date"
puts "End Date:    $end_date"
puts "File Date:   $file_date"
puts "Last Date Prev Month: $lastdayprevmonth"
set fileName "$lastdayprevmonth"
append fileName "_residual"
append fileName "_$rpt_type"
append fileName ".csv"
puts "Report Name: $fileName"
set header    "GL_MONTH,POSTING_ENTITY_ID,POST_NAME,ENTITY_ID,ENTITY_DBA_NAME,START_DATE,MER_FEE,CONV_AMT,IC_DA,MAINTENANCE_FEE,PCICOMP_FEE,PCINONCOMP_FEE,OTHER_FEE"

exec echo $header >> $fileName


set body ""

##################
#####  MAIN  #####
##################

readCfgFile

connect_to_db

set residual_sql   [oraopen $mas_logon_handle]

set Query_sql "SELECT *
FROM
  (SELECT *
  FROM
    (SELECT TO_CHAR(TRUNC(mtl.GL_Date, 'MM'),'MON-YY') AS Gl_Month,
      mtl.posting_entity_id,
      ae2.ENTITY_DBA_NAME post_name,
      mtl.entity_id,
      ae.ENTITY_DBA_NAME,
      ae.actual_Start_date,
      SUM(CASE WHEN mtl.mas_code IN ('00AMAINT','00EQPPUR','00SHPFEE','00PCICOMP') THEN 
        amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS Mer_Fee,
      SUM(CASE WHEN mtl.TID IN ('010003005141','010003005142','010003005143','010003005144') THEN 
        amt_billing * (CASE WHEN mtl.tid_settl_method = 'C' THEN 1 ELSE -1 END) ELSE 0 END) AS Conv_Amt,
      SUM(CASE WHEN mtl.tid LIKE '010004%' AND mtl.mas_code NOT IN ('00AMAINT','00EQPPUR','00SHPFEE','00PCICOMP','00PCINONCOMP','06ECNFEE','02CHGBCKFEE','04CHGBCKFEE','05CHGBCKFEE','08CHGBCKFEE',
         '03CHGBCKFEE','00ACTSET','CW_DAF','00GATEFEE','00POSCLUB','00HDMONT','00FEECREDIT','MC_ANNUAL_NW') THEN 
        amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS IC_DA,
      SUM(CASE WHEN mtl.mas_code IN ('00AMAINT') THEN amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS Maintenance_Fee,
      SUM(CASE WHEN mtl.mas_code IN ('00PCICOMP') THEN amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS PCIComp_Fee,
      SUM(CASE WHEN mtl.mas_code IN ('00PCINONCOMP') THEN amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS PCINonComp_Fee,
      SUM(CASE WHEN mtl.mas_code IN ('00AMAINT','00EQPPUR','00SHPFEE','00PCICOMP','00PCINONCOMP','06ECNFEE','02CHGBCKFEE','04CHGBCKFEE','05CHGBCKFEE','08CHGBCKFEE',
         '03CHGBCKFEE','00ACTSET','CW_DAF','00GATEFEE','00POSCLUB','00HDMONT','00FEECREDIT','MC_ANNUAL_NW') THEN amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) AS Other_Fee
FROM 
    mas_trans_log mtl
    JOIN ACQ_ENTITY ae ON ae.ENTITY_ID = mtl.ENTITY_ID
    JOIN ENTITY_TO_AUTH eta ON eta.ENTITY_ID = mtl.ENTITY_ID
      AND (eta.FILE_GROUP_ID LIKE 'CNV%107%' OR eta.file_group_id LIKE '%OKDMV%')
      AND eta.INSTITUTION_ID = mtl.institution_id
    JOIN ACQ_ENTITY ae2 ON ae2.ENTITY_ID   = mtl.POSTING_ENTITY_ID WHERE mtl.gl_date >= to_date('$start_date','YYYYMMDD') AND mtl.gl_date < to_date('$end_date','YYYYMMDD')
    AND mtl.settl_flag = 'Y'
    AND mtl.tid NOT   IN ('010003005141','010003005143')
    GROUP BY TRUNC(mtl.GL_Date, 'MM'),
      mtl.posting_entity_id,
      mtl.entity_id,
      ae.ENTITY_DBA_NAME,
      ae.actual_Start_date,
      ae2.ENTITY_DBA_NAME
    HAVING SUM(CASE WHEN mtl.mas_code IN ('00AMAINT', '00PCICOMP','00PCINONCOMP','00EQPPUR','00SHPFEE') THEN 
      amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) <> 0
    OR SUM(CASE WHEN mtl.TID IN ('010003005141','010003005142','010003005143','010003005144') THEN 
      amt_billing * (CASE WHEN mtl.tid_settl_method = 'C' THEN 1 ELSE -1 END) ELSE 0 END) <> 0
    OR SUM(CASE WHEN mtl.tid LIKE '010004%' AND mtl.mas_code NOT IN ('00AMAINT', '00PCICOMP','00PCINONCOMP','00EQPPUR','00SHPFEE') THEN 
      amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) <> 0
    OR SUM(CASE WHEN mtl.mas_code IN ('00AMAINT','00EQPPUR','00SHPFEE','00PCICOMP','00PCINONCOMP','06ECNFEE','02CHGBCKFEE','04CHGBCKFEE','05CHGBCKFEE','08CHGBCKFEE',
         '03CHGBCKFEE','00ACTSET','CW_DAF','00GATEFEE','00POSCLUB','00HDMONT','00FEECREDIT','MC_ANNUAL_NW') THEN amt_billing * (CASE WHEN mtl.tid_settl_method = 'D' THEN 1 ELSE -1 END) ELSE 0 END) <> 0
ORDER 
  BY mtl.posting_entity_id
   ) sub1
  ORDER BY 2 ASC
  ) sub1
  ORDER BY 2 ASC"

puts $Query_sql
  
orasql $residual_sql $Query_sql

while {[orafetch $residual_sql -dataarray residual_query -indexbyname] != 1403 } {

  ######################
  # Add Residual Rec
  #######################      
  append body "$residual_query(GL_MONTH),"
  append body "'$residual_query(POSTING_ENTITY_ID)',"
  append body "$residual_query(POST_NAME),"
  append body "'$residual_query(ENTITY_ID)',"
  append body "$residual_query(ENTITY_DBA_NAME),"
  append body "$residual_query(ACTUAL_START_DATE),"
  append body "$residual_query(MER_FEE),"
  append body "$residual_query(CONV_AMT),"
  append body "$residual_query(IC_DA),"
  append body "$residual_query(MAINTENANCE_FEE),"
  append body "$residual_query(PCICOMP_FEE),"
  append body "$residual_query(PCINONCOMP_FEE),"
  append body "$residual_query(OTHER_FEE)"

  ######################
  # Write to File
  #######################      
  exec echo $body >> $fileName
  set body ""

}

if { $rpt_type == "D" } {
   exec echo "Please see attached." | mutt  -a "$fileName" -s "Daily Convenience Merchant Residuals" -- "clearing@jetpay.com, accounting@jetpay.com, jeff.brown@jetpay.com, jose.alvarado@jetpay.com"
   
} else {
   exec echo "Please see attached." | mutt  -a "$fileName" -s "Month End Convenience Merchant Residuals" -- "clearing@jetpay.com, accounting@jetpay.com, jeff.brown@jetpay.com, jose.alvarado@jetpay.com"
}

exec mv $fileName ./ARCHIVE

exit 0 
