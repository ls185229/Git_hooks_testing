#!/usr/bin/env tclsh
# ###############################################################################
# $Id: cmd_138_v2.tcl 4254 2017-07-27 20:13:04Z skumar $
# $Rev: 4254 $
# ###############################################################################
#
# File Name:  cmd_138_v2.tcl
#
# Description:  This script updates item_to_accum99 and item_to_accum table 
#               using item_to_accum_view
#
#    Shell Arguments - None
#
# ###############################################################################

package require Oratcl


set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M"]
puts " "
puts "----- LOG Date $logdate ----------------------"
puts "----- JetPay task 138 --------------------------------------"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

if {[file exists /clearing/filemgr/process.stop]} {
  exec echo "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPPED : Msg sent from cmd_138_v2.tcl" | mailx -r reports-clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PREVIOUS PROCESS NOT COMPLETED" reports-clearing@jetpay.com
  exit 1
} else {
  catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

#####################################
proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    global env
    if {[catch {set db_logon_handle [oralogon masclr/masclr@$env(IST_DB)]} result]} {
        puts "Encountered error $result while trying to connect to DB"
        exec echo "ALL PROCESSES STOPED SINCE cmd_138_v2.tcl could not logon to DB : Msg sent from cmd_138_v2.tcl" | mailx -r reports-clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PROCESS NOT COMPLETED" reports-clearing@jetpay.com
        exit 1
    }
};# end connect_to_db

#####################################
proc run_query { value } {
    global cnt mbody
    global get
    global lupdate
    global inst_id 
    global ora_status
    global db_logon_handle
    global mail_err
    global mail_to
    set inst_id ""
    set inst_id $value
    global sql1
    global status
    set status 1
    set sql1 ""
    
    if { [catch {
 
        set get [oraopen $db_logon_handle]
        
        set sql1 "MERGE INTO masclr.item_to_accum99 dest
        USING
            (SELECT
                INSTITUTION_ID      ,
                ENTITY_ID           ,
                TID_TO_ACCUM        ,
                MAS_CODE_TO_ACCUM   ,
                TID_SRC_TO_ACCUM    ,
                CARD_SCH_TO_ACCUM   ,
                CURR_CODE_TO_ACCUM  ,
                CONVERT_TO_CURR     ,
                FEE_PKG_ID          ,
                PAYMENT_CYCLE
            FROM masclr.ITEM_TO_ACCUM_VIEW
            WHERE institution_id = '$inst_id') src
            ON (
                src.INSTITUTION_ID    = dest.INSTITUTION_ID     AND
                src.ENTITY_ID         = dest.ENTITY_ID          AND
                src.TID_TO_ACCUM      = dest.TID_TO_ACCUM       AND
                src.MAS_CODE_TO_ACCUM = dest.MAS_CODE_TO_ACCUM  AND
                src.TID_SRC_TO_ACCUM  = dest.TID_SRC_TO_ACCUM   AND
                src.CARD_SCH_TO_ACCUM = dest.CARD_SCH_TO_ACCUM  AND
                src.FEE_PKG_ID        = dest.FEE_PKG_ID         AND
                src.PAYMENT_CYCLE     = dest.PAYMENT_CYCLE )
            WHEN NOT MATCHED THEN
            INSERT
                (
                INSTITUTION_ID      ,
                ENTITY_ID           ,
                TID_TO_ACCUM        ,
                MAS_CODE_TO_ACCUM   ,
                TID_SRC_TO_ACCUM    ,
                CARD_SCH_TO_ACCUM   ,
                CURR_CODE_TO_ACCUM  ,
                CONVERT_TO_CURR     ,
                FEE_PKG_ID          ,
                PAYMENT_CYCLE
                )
            VALUES
                (
                src.INSTITUTION_ID      ,
                src.ENTITY_ID           ,
                src.TID_TO_ACCUM        ,
                src.MAS_CODE_TO_ACCUM   ,
                src.TID_SRC_TO_ACCUM    ,
                src.CARD_SCH_TO_ACCUM   ,
                src.CURR_CODE_TO_ACCUM  ,
                src.CONVERT_TO_CURR     ,
                src.FEE_PKG_ID          ,
                src.PAYMENT_CYCLE
                )"
        
        orasql $get $sql1
        oracommit $db_logon_handle
        
        set sql1 ""
        set sql1 "INSERT INTO masclr.ITEM_TO_ACCUM
            (
              SELECT * FROM masclr.ITEM_TO_ACCUM99 WHERE institution_id = '$inst_id'
              MINUS
              SELECT * FROM masclr.ITEM_TO_ACCUM WHERE institution_id = '$inst_id'
            )"
        orasql $get $sql1
        oracommit $db_logon_handle
        puts "ITEM_TO_ACCUM table is updated for inst : $inst_id"
        set status 0
    } failure] } {
        set mbody "Error parsing, binding or executing sql query: $failure \n $sql1"
        exec echo "$mbody" | mailx -r $mail_err -s "URGENT!!! cmd_138_v2.tcl failed for INST $inst_id" $mail_err
        set status 1
    }
};

proc free_db_dandle {} {
    global get
    global db_logon_handle
    global env mbody
    global mail_err
    global mail_to
    
    # close all the DB connections
    oraclose $get
    if { [catch {oralogoff $db_logon_handle } result ] } {
       set mbody "Encountered error $result while trying to close DB handles"
       exec echo "$mbody" | mailx -r $mail_err -s "URGENT!!! cmd_138_v2.tcl failed for INST $inst_id" $mail_err
    }
};

#####################################
#MAIN#
#####################################
global cfg_file_name
global line
global file_ptr
global inst_list
global mail_err
global mail_to
global sql_inst
global logdate
global status
#Calling Procedure
connect_to_db

set cfg_file_name "inst_138_cmd.cfg" 

if {[catch {open $cfg_file_name r} file_ptr]} {
  puts " *** File Open Err: Cannot open config file $cfg_file_name"
  exit 1
}

while { [set line [gets $file_ptr]] != {}} {
  set line_parms [split $line ~]
      
  switch -exact -- [lindex  $line_parms 0] {
    "MAIL_ERR" 
    {
      set mail_err [lindex $line_parms 1]
      puts " mail to err : $mail_err"
    }
    "MAIL_TO" 
    {
      set mail_to [lindex $line_parms 1]
      puts " mail_to: $mail_to"
    }
    "INST_LIST" 
    {
      set inst_list [lindex $line_parms 1]
      puts " inst_list: $inst_list"
    }
    default 
    {
      puts "Unknown config parameter [lindex $line_parms 0]"
    }
  }
}

foreach sql_inst $inst_list {
  run_query $sql_inst
  if { $status == 0} {
  exec sleep 30 
  puts "Command 138 Complete for $sql_inst at $logdate"
  } else {
  exec sleep 30
  exec echo "Command 138 failed for $sql_inst at $logdate"  | mutt -s "JetPay Task 138 - Institution $sql_inst" -- $mail_err
  }
}

free_db_dandle

catch {file delete /clearing/filemgr/process.stop} result
puts "------------------------------ COMPLETE --------------------------------"
puts " "
