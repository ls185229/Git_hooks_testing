#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: amex_prefunding_report.tcl 4059 2017-02-10 21:06:19Z millig $
# $Rev: 4059 $
################################################################################
#
#    File Name   - amex_prefunding_report.tcl
#
#    Description - This is a custom report for counting AMEX transactions that 
#                  were generated between 1:00 AM and 6:00 AM
#
#    Arguments   -i institution id
#                -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
################################################################################
package require Oratcl


#System variables
set box $env(SYS_BOX)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"
set clr_db $env(CLR4_DB)
set clr_db_username $env(IST_DB_USERNAME)
set clr_db_password $env(IST_DB_PASSWORD)


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
   global report_date_offset
   global report_start_time
   global report_end_time
   global argv 

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"  
   } else {
          set cfg_file_name amex_prefunding.cfg
          puts " Default Config File: $cfg_file_name"
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts "File Open Err:Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "REPORT_DATE_OFFSET" {
            set report_date_offset [lindex $line_parms 1]
         }
         "REPORT_START_TIME" {
            set report_start_time [lindex $line_parms 1]
         }
         "REPORT_END_TIME" {
            set report_end_time [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global mas_logon_handle
   global clr_db
   global clr_db_username
   global clr_db_password
   
   if {[catch {set mas_logon_handle [oralogon $clr_db_username/$clr_db_password@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
   } else {
        puts " Connected clr_db"
   }
}

proc arg_parse {} {
    global date_given argv institution_arg sql_inst

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
        puts " Date entered: $date_given"
    }

    #scan for Institution
    set institution_arg ""

    if { [regexp -- {(-[iI])[ ]+([0-9]{3})} $argv dummy1 dummy2 institution_arg] } {
          puts " Institution argument: $institution_arg"
          set sql_inst $institution_arg
    }
}

proc init_dates {val} {
    global  curdate
    global  end_date
    global  report_date_offset
    global  requested_date
    global  start_date

    set curdate [clock format [clock seconds] -format %b-%d-%Y]
    puts " Report Generated on: $curdate"         

    set start_date [clock format [ clock scan "$val -$report_date_offset day" ] -format %Y%m%d]
    puts " start date is >=  $start_date "

    set end_date [clock format [clock scan "$val"] -format %Y%m%d]
    puts " end date is    <  $end_date "
    
    set requested_date [clock format [clock scan "$val"] -format %b-%d-%Y]
    puts " Report Request Date: $requested_date"
}

proc do_report {} {
    global curdate 
    global date_given
    global end_date
    global in_draft_main_select_query
    global mas_sql
    global report_start_time
    global report_end_time
    global requested_date
    global sql_inst
    global start_date

    set mailto "Reports-clearing@jetpay.com,accounting@jetpay.com"
     
    set in_draft_main_select_query "
        SELECT substr(idm.src_inst_id,1,4) as INSTITUTION_ID,
               sum(CASE WHEN(idm.tid = '010103005101') then 1 else 0 end) as AMEX_SALE_COUNT,
               sum(CASE WHEN(idm.tid = '010103005101') then (idm.amt_trans/100) else 0 end) as AMEX_SALE_AMOUNT,
               sum(CASE WHEN(idm.tid = '010103005102') then 1 else 0 end) as AMEX_REFUND_COUNT,
               sum(CASE WHEN(idm.tid = '010103005102') then (idm.amt_trans/100) else 0 end) as AMEX_REFUND_AMOUNT,
               sum(CASE WHEN(idm.tid = '010103005102') then (idm.amt_fees/100) else 0 end) as AMEX_C_FEE,
               sum(CASE WHEN(idm.tid = '010103005101') then (idm.amt_fees/100) else 0 end) as AMEX_D_FEE
          FROM in_draft_main idm
         WHERE idm.in_file_nbr in (SELECT in_file_nbr 
                                     FROM in_file_log 
                                    WHERE trunc(incoming_dt) BETWEEN to_date('$start_date$report_start_time','YYYYMMDDHH24MI') AND to_date('$end_date$report_end_time','YYYYMMDDHH24MI')
                                      AND institution_id = '$sql_inst' 
                                      AND file_type = '01')
           AND idm.card_scheme = '03'
         GROUP BY substr(idm.src_inst_id,1,4)
         ORDER BY substr(idm.src_inst_id,1,4)"

    if { [catch {orasql $mas_sql $in_draft_main_select_query} result] } {
          puts "Failed - $result"
          puts "Query - $in_draft_main_select_query"
          exit 1
    }
    
    set rpt "  Institution:, $sql_inst \n"
    append rpt "  Date Generated:, $curdate \n"
    append rpt "  Requested Date:, $requested_date \n\n\n"
    append rpt "Institution ID,Amex Sales Count,Amex Sales Amount,Amex Refund Count,Amex Refund Amount,Amex Fee Credit,Amex Fee Debit\n"

    
    while { [orafetch $mas_sql -dataarray row -indexbyname] != 1403 } {
        ### Add current line to report output
        append rpt "$row(INSTITUTION_ID),$row(AMEX_SALE_COUNT),$row(AMEX_SALE_AMOUNT),$row(AMEX_REFUND_COUNT),$row(AMEX_REFUND_AMOUNT),$row(AMEX_C_FEE),$row(AMEX_D_FEE)\n"
    }

    set file_name "$sql_inst.AMEX_PreFunding_Report.$date_given.csv"
    set fl [open $file_name w]
    puts $fl $rpt

    close $fl

    if { [catch { exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- $mailto } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
    if {$sql_inst == 121} {
		exec cp $file_name ../INST_$sql_inst/UPLOAD/
	}
    exec mv $file_name ./ARCHIVE
}

#######
# MAIN
#######

readCfgFile

connect_to_db

set mas_sql [oraopen $mas_logon_handle]

arg_parse

if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %Y%m%d]     
} else {
    init_dates [clock format [clock seconds] -format %Y%m%d] 
    set date_given [clock format [clock seconds] -format %Y%m%d]                         
}

do_report

oraclose $mas_sql

oralogoff $mas_logon_handle 
