#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: reserve_report.tcl 3681 2016-02-19 22:17:42Z bjones $
# $Rev: 3681 $
################################################################################
#
#    File Name   -  reserve_report.tcl
#
#    Description -  This script generates reserve reports by institution.
#
#    Arguments   -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  reserve_report.tcl -D yyyymmdd -F config_file.cfg
#
#                   e.g.   reserve_report.tcl -d 2015032 -f test.cfg
#
################################################################################

package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib
################################################################################

proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global argv mail_to mail_err inst_list

   set clr_db_logon ""
   set clr_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name reserve_report.cfg 
          puts " Default Config File: $cfg_file_name"
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " *** File Open Err: Cannot open config file $cfg_file_name"
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
            puts " mail_to: $mail_to"
         }
         "INST_LIST" {
            set inst_list [lindex $line_parms 1]
            puts " inst_list: $inst_list"
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

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global clr_logon_handle
   global clr_db_logon
   global clr_db

   if {[catch {set clr_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts " Connected to clr_db"
   }
}

proc arg_parse {} {
   global argv date_arg 

   #scan for Date
   if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
         puts " Date argument:   $arg_date"
         set date_arg $arg_date
   }
}

proc init_dates {val} {
    global curdate requested_date today tomorrow filedate  

    set curdate        [clock format   [clock seconds] -format %b-%d-%Y]
    set requested_date [clock format   [clock scan "$val"] -format %b-%d-%Y]

    set today          [string toupper [clock format [clock scan "$val" -format %Y%m%d] -format %d-%b-%Y]]   
    set tomorrow       [string toupper [clock format [clock scan "$today +1 day"] -format %d-%b-%Y]]

    set filedate       [clock format   [clock scan "$today"] -format %Y%m%d]                                
    
    puts " Generated Date:  $curdate" 
    puts " Requested Date:  $requested_date" 
    puts " Start Date:      $today" 
    puts " End Date:        $tomorrow"
}

proc do_report {value} {
    global curdate requested_date today tomorrow filedate sql_inst mail_to
    global fetch_cursor1 fetch_cursor2 cur_file rollup_cur_file

    set file_name     "$sql_inst.Reserve_Report.$filedate.csv"
    set cur_file      [open "$file_name" w]

    set entlist ""
    set qry_instit ""
    set qry_instit "'$value'"
    set qry_instit [string trimright $qry_instit ,]

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "  "
    puts $cur_file "  "

    puts $rollup_cur_file "  "
    puts $rollup_cur_file "  Institution:, $sql_inst"

    puts $cur_file        "Parent Merchant ID,Merchant ID,Merchant Name,Status Code,Contract Date,Pay Status,Reserve,CBR Rate"
    puts $rollup_cur_file "Parent Merchant ID,Merchant ID,Merchant Name,Status Code,Contract Date,Pay Status,Reserve,CBR Rate"
 
    set entity_str "
        select unique ae.institution_id,
               ae.entity_id,
               ae.rsrv_percentage,
               ae.parent_entity_id,
               ae.entity_dba_name,
               ae.creation_date,
               ae.rsrv_fund_status,
               substr(aea.user_defined_1,1,7) as flag,
               ae.entity_status
        from  acq_entity ae, acq_entity_add_on aea
        where ae.entity_id = aea.entity_id
          and substr(aea.user_defined_1,1,7) in ('ROLLING','RESERVE')
          and ae.institution_id in ($qry_instit)
        order by ae.institution_id, ae.entity_id  "

#   puts " Reserve Query: $entity_str"

    orasql $fetch_cursor1 $entity_str

    while {[orafetch $fetch_cursor1 -dataarray s -indexbyname] != 1403} {
            set ent $s(ENTITY_ID)
            lappend sql_entlist '$s(ENTITY_ID)',
            lappend entlist $s(ENTITY_ID)

            set NAME($ent)          $s(ENTITY_DBA_NAME)
            set CONTRACT_DATE($ent) $s(CREATION_DATE)
            set STATUS_CODE($ent)   $s(RSRV_FUND_STATUS)
            set CBR_RATE($ent)      $s(RSRV_PERCENTAGE)
            set PARENT($ent)        $s(PARENT_ENTITY_ID)

            if {$s(ENTITY_STATUS)  == "A"} {
                if {$STATUS_CODE($ent) != "F"} {
                    set PAY_STATUS($ent) ACTIVE
                } else {
                    set PAY_STATUS($ent) FULFILLED
                }
            } else {
                    set PAY_STATUS($ent) INACTIVE
            }
    }

    if {[string length $entlist] == "0"} {
         puts " Nothing to report for $qry_instit"
         puts $cur_file " Nothing to report for this institution. "
         puts $rollup_cur_file " Nothing to report for this institution. "
         close $cur_file

		 MASCLR::mutt_send_mail $mail_to  "$file_name" "Please see attached." "$file_name"
         exec mv $file_name ./ARCHIVE
         return
    }

    set sql_entlist  [string trimright $sql_entlist ,]
      
    set detail_str "
        select mtl.entity_id, 
               sum(CASE WHEN( mtl.tid_settl_method = 'C' ) 
                        then mtl.AMT_ORIGINAL else 0 end)      AS RELEASE_C,
               sum(CASE WHEN( mtl.tid_settl_method <> 'C' ) 
                        then -1*mtl.AMT_ORIGINAL else 0 end)   AS RELEASE_D
        from  mas_trans_log mtl
        where (mtl.institution_id, mtl.payment_seq_nbr) 
                   in (select institution_id, payment_seq_nbr
                       from  acct_accum_det 
                       where (institution_id, entity_acct_id) 
                              in (select institution_id, entity_acct_id
                                  from  entity_acct 
                                  where OWNER_ENTITY_ID in ($sql_entlist) 
                                    and acct_posting_type = 'R')
                         and (payment_status is null or payment_status='C' or 
                             (payment_status='P' and trunc(payment_proc_dt) > '$today')))
          and mtl.gl_date < '$tomorrow'
          and mtl.tid in ('010007050000')
          and mtl.ENTITY_ID in ($sql_entlist)
        group by mtl.entity_id"
        
#   puts " Detail Query: $detail_str" 

    orasql $fetch_cursor2 $detail_str

    while {[orafetch $fetch_cursor2 -dataarray amt -indexbyname] != 1403} {
            set  MID $amt(ENTITY_ID)
            set  RESERVE($MID) [expr $amt(RELEASE_C) + $amt(RELEASE_D)]
            # puts " RESERVE($MID): $RESERVE($MID)"
    }

    set cnt 0

    foreach eid $entlist {
        set eid [string trimright $eid ,]
        if {![info exists RESERVE($eid)]} {
              set RESERVE($eid) 0 
        }
        if {$RESERVE($eid) != 0} {
            incr cnt
            puts $cur_file        "$PARENT($eid),$eid,$NAME($eid),$STATUS_CODE($eid),$CONTRACT_DATE($eid),$PAY_STATUS($eid),$RESERVE($eid),$CBR_RATE($eid)"
            puts $rollup_cur_file "$PARENT($eid),$eid,$NAME($eid),$STATUS_CODE($eid),$CONTRACT_DATE($eid),$PAY_STATUS($eid),$RESERVE($eid),$CBR_RATE($eid)"
        }
    }

    if {$cnt == 0} {
        puts                  " Nothing to report for institution: $sql_inst"
        puts $cur_file        " Nothing to report for this institution. "
        puts $rollup_cur_file " Nothing to report for this institution. "
    }

    close $cur_file


    MASCLR::mutt_send_mail $mail_to  "$file_name" "Please see attached." "$file_name"
    exec mv $file_name ./ARCHIVE

}      

##########
# MAIN
##########

readCfgFile

connect_to_db

set fetch_cursor1 [oraopen $clr_logon_handle]

set fetch_cursor2 [oraopen $clr_logon_handle]

arg_parse

if {![info exists date_arg]} {
      init_dates [clock format [clock seconds] -format %Y%m%d]
} else {
      init_dates $date_arg
}

## Set ups for Rollup Report
set rollup_file_name  "Rollup_Reserve_Report.$filedate.csv"
set rollup_cur_file   [open "$rollup_file_name" w]

puts $rollup_cur_file "  Date Generated:, $curdate"
puts $rollup_cur_file "  Requested Date:, $requested_date"
puts $rollup_cur_file "  "
###

foreach sql_inst $inst_list {
     do_report $sql_inst
}

close $rollup_cur_file

MASCLR::mutt_send_mail $mail_to  "$rollup_file_name" "Please see attached." "$rollup_file_name"
exec mv $rollup_file_name ./ARCHIVE

oraclose $fetch_cursor1

oraclose $fetch_cursor2

oralogoff $clr_logon_handle

