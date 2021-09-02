#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: reclass_mascode_fix.tcl 2552 2014-02-25 16:41:05Z msanders $
# $Rev: 2552 $
################################################################################
#
#    File Name   - reclass_mascode_fix.tcl
#
#    Description - assigns mas codes to reclasses that dont have one
#
################################################################################

#System variables
set box $env(SYS_BOX)
set clr_db $env(IST_DB)
set auth_db $env(ATH_DB)
set clearing_in_file_loc $env(CLR_OSITE_DATA)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set log_filename "/clearing/filemgr/RETURN_FILES/LOG/move.log.[clock format [ clock scan "-0 day" ] -format %Y%m]"

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"
set locpath "/clearing/filemgr/RETURN_FILES"
set mailtolist "Reports-clearing@jetpay.com,accounting@jetpay.com"

#######################################################################################################################

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
  global clr_db
   
  set cfg_file_name reclass.cfg

  set clr_db_logon ""
  set clr_db ""

  if {[catch {open $cfg_file_name r} file_ptr]} {
    puts "File Open Err:Cannot open config file $cfg_file_name"
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

################################################################################
#
# Procedure Name:  openLogFile
#
# Description:     Opens the log file for this program
# Error Return:    21 [Log file cannot be opened]
#
################################################################################
proc openLogFile {} {

   global log_file_ptr
   global log_filename

   if {[catch {open $log_filename a} log_file_ptr]} {
      puts stderr "Cannot open file $log_filename for logging."
      exit 21
   }

};# end openLogFile


################################################################################
#
# Procedure Name:  writeLogMsg
#
# Description:     Writes messages to the log file
# Error Return:    22 [Write to log file failed]
#
################################################################################
proc writeLogMsg { log_msg_text } {

    global log_file_ptr

    if {[catch {puts $log_file_ptr "[clock format [clock seconds] -format "%Y-%m-%d %T"] $log_msg_text"}]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg_text"
        exit 22
    }

};# end writeLogMsg

################################################################################
#
# Procedure Name:  closeLogFile
#
# Description:     Closes the log file used by the program
# Error Return:    23 [Log file cannot be closed]
#
################################################################################
proc closeLogFile {} {

   global log_file_ptr
   global log_filename

   if {[catch {close $log_file_ptr} response]} {
       puts stderr "Cannot close file $log_filename."
       exit 23
   }

};# end closeLogFile

#######################################
# connect_to_db
# handles connections to the database
#######################################

proc connect_to_db {} {
  global mas_logon_handle
  global clr_db_logon
  global clr_db


  if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
     puts "Encountered error $result while trying to connect to clr DB"
     exit 1
  } else {
     puts "Connected to clr DB"
  }

};# end connect_to_db


######################
# MAIN
######################

readCfgFile
openLogFile
connect_to_db

set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
writeLogMsg "-----------NEW LOG------------------- $curdate ---------"


writeLogMsg "reclass_mascode_fix.tcl Started"

if { $argc == 0 } {
  set base [clock format [clock seconds] -format "%Y%m%d"]
} else {
  set base [clock format [clock scan [lindex $argv 0] -format "%Y%m%d"] -format "%Y%m%d"]
}

set begin_date [clock format [clock add [clock scan $base -format "%Y%m%d"] -0 day] -format "%d-%b-%Y"]

set Query_sql "SELECT trans_seq_nbr
FROM masclr.in_draft_main
WHERE trunc(activity_dt) > '$begin_date' and     
  tid = '010133005101' and
  mas_code = 'MAS001'"


set main_mas_sql [oraopen $mas_logon_handle]
set mas_sql1 [oraopen $mas_logon_handle]

orasql $main_mas_sql $Query_sql

while {[orafetch $main_mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  puts $mas_query(TRANS_SEQ_NBR)
  set Query_sql "select trans_seq_nbr, 
      submt_fee_prog_ind, 
      asses_fee_prog_ind 
    from visa_rtn_rclas_adn
    where trans_seq_nbr = '$mas_query(TRANS_SEQ_NBR)'"
  orasql $mas_sql1 $Query_sql
  if {[orafetch $mas_sql1 -dataarray mas_query1 -indexbyname] != 1403} {
    set submitted $mas_query1(SUBMT_FEE_PROG_IND)
    set received $mas_query1(ASSES_FEE_PROG_IND)
    writeLogMsg "$submitted:$received"
    set Query_sql "select mas_code
      from MASCLR.flmgr_interchange_rates 
      where fpi_ird = '$received' 
        and usage = 'INTERCHANGE'"
    orasql $mas_sql1 $Query_sql
    if {[orafetch $mas_sql1 -dataarray mas_query1 -indexbyname] != 1403 } {
      set mas_code $mas_query1(MAS_CODE)
      set Query_sql "select mas_code
        from MASCLR.flmgr_interchange_rates
        where fpi_ird = '$submitted'
          and usage = 'INTERCHANGE'"
      orasql $mas_sql1 $Query_sql
      if {[orafetch $mas_sql1 -dataarray mas_query1 -indexbyname] != 1403 } {
        set mas_code_downgrade $mas_query1(MAS_CODE)
        writeLogMsg "$mas_code:$mas_code_downgrade"
          set Query_sql "update masclr.in_draft_main
          set mas_code = '$mas_code',
            mas_code_downgrade = '$mas_code_downgrade'
          where trans_seq_nbr = '$mas_query(TRANS_SEQ_NBR)'"
        orasql $mas_sql1 $Query_sql
      } else {
        writeLogMsg "No interchange found for $submitted"
        exec echo "No interchange found for $submitted for a reclass transaction" | mutt -s "reclass_mascode_fix.tcl: Problem with fixing reclass transactions" clearing@jetpay.com
      }
    } else {
      writeLogMsg "No interchange found for $received"
      exec echo "No interchange found for $submitted for a reclass transaction" | mutt -s "reclass_mascode_fix.tcl: Problem with fixing reclass transactions" clearing@jetpay.com
    }
  } else {
    writeLogMsg "No interchange information found for $mas_query(TRANS_SEQ_NBR)"
    exec echo "No interchange information found for $mas_query(TRANS_SEQ_NBR)" | mutt -s "reclass_mascode_fix.tcl: Problem with fixing reclass transactions"clearing@jetpay.com
  }
}
oracommit $mas_logon_handle
closeLogFile

exit 0 
