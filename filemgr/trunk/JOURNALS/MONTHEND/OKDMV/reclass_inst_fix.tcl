#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: $
# $Rev: 2533 $
################################################################################
#
#    File Name   - reclass_mascode_fix.tcl
#
#    Description - assigns mas codes to reclasses that dont have one
#
################################################################################


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
set locpath "/clearing/filemgr/JOURNALS/MONTHEND/OKDMV"
set mailtolist "Reports-clearing@jetpay.com,accounting@jetpay.com"

#######################################################################################################################

package require OratclOratcl

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
  global Shortname_list
   
  set cfg_file_name reclass.cfg

  set clr_db_logon ""
  set clr_db ""

  if {[catch {open $cfg_file_name r} file_ptr]} {
    puts "File Open Err:Cannot open config file $cfg_file_name"
    exit 1
  }

  while { [set line [gets $file_ptr]] != {}} {
    set line_parms [split $line ,]
    switch -exact -- [lindex  $line_parms 0] {
       "CLR_DB_LOGON" {
          set clr_db_logon [lindex $line_parms 1]
       }
       "CLR_DB" {
          set clr_db [lindex $line_parms 1]
       }
       "SHORTNAME_LIST" {
          set Shortname_list [lindex $line_parms 1]
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

puts "reclass_mascode_fix.tcl Started"

if { $argc == 0 } {
  set base [clock format [clock seconds] -format "%Y%m%d"]
} else {
  set base [clock format [clock scan [lindex $argv 0] -format "%Y%m%d"] -format "%Y%m%d"]
}

puts "Report date: $base"
set begin_date [clock format [clock add [clock scan $base -format "%Y%m%d"] -34 day] -format "%d-%b-%Y"]

puts "Begin Date: $begin_date"

set Query_sql "select substr(in_draft_main.pri_dest_inst_id,1,4),
  substr(in_draft_main.sec_dest_inst_id,1,4),
  substr(in_draft_main.merch_id,1,15),
  substr(in_draft_main.merch_name,1,20),
  substr(tid.description,1,30),
  in_draft_main.arn,
  in_draft_main.trans_seq_nbr,
  in_draft_main.msg_text_block
from in_draft_main, card_scheme, tid
where in_draft_main.card_scheme = card_scheme.card_scheme AND
  in_draft_main.tid = tid.tid AND
  in_draft_main.pri_dest_inst_id in ('105','117','121') AND
  in_draft_main.in_file_nbr in (select in_file_nbr from in_file_log where trunc(incoming_dt) = trunc(sysdate) and substr(external_file_name,1,6) in ('INMC.T','INVS.P'))
  order by in_draft_main.pri_dest_inst_id,
  in_draft_main.merch_id"


readCfgFile
connect_to_db
set mas_sql [oraopen $mas_logon_handle]
set mas_sql1 [oraopen $mas_logon_handle]

orasql $mas_sql $Query_sql

while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  set Query_sql "select trans_seq_nbr, 
      pri_dest_inst_id, 
      sec_dest_inst_id,
      merch_name,
      merch_id
    from masclr.in_draft_main
    where arn = '$mas_query(ARN)'
    order by trans_seq_nbr asc"
  orasql $mas_sql1 $Query_sql
  if {[orafetch $mas_sql1 -dataarray mas_query1 -indexbyname] != 1403 } {
 
    set sec_dest_inst_id $mas_query1(SEC_DEST_INST_ID)
    set merch_name $mas_query1(MERCH_NAME)
    set merch_id $mas_query1(MERCH_ID)

    set Query_sql "update masclr.in_draft_main
    set sec_dest_inst_id = $sec_dest_inst_id,
      merch_name = '$merch_name',
      merch_id = $merch_id
    where trans_seq_nbr = $mas_query(TRANS_SEQ_NBR)"
    #orasql $mas_sql1 $Query_sql
    set Query_sql "update ep_event_log
    set institution_id = '$sec_dest_inst_id',
      merch_id = $merch_id
    where trans_seq_nbr = $mas_query(TRANS_SEQ_NBR)"
    #orasql $mas_sql1 $Query_sql

  } else {
    puts "could not find matching trans for $mas_query(TRANS_SEQ_NBR)"
  }

}
#oracommit $mas_logon_handle

exit 0 
