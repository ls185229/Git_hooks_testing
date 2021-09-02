#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: debit_prefunding_report.tcl 4059 2017-02-10 21:06:19Z millig $
# $Rev: 4059 $
################################################################################
#
#    File Name   - debit_prefunding_report.tcl
#
#    Description - This is a custom report for DEBIT transactions that 
#                  were stuck in the capture or tranhistory tables.
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
   global auth_db_logon
   global auth_db
   global shortname_list nextday_list
   global argv sql_inst
   global mail_err mail_to

   set auth_db_logon ""
   set auth_db ""

   #scan for config file
   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"  
   } else {
         set cfg_file_name debit_prefunding.cfg
         puts " Default Config File: $cfg_file_name"
   }

   #scan for Institution
   set institution_arg ""

   if { [regexp -- {(-[iI])[ ]+([0-9]{3})} $argv dummy1 dummy2 institution_arg] } {
         set sql_inst $institution_arg
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts "File Open Err:Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ~]
       switch -exact -- [lindex  $line_parms 0] {
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
               puts " mail_to: $mail_to"
         }
          "INST_LINE" {
               set inst [lindex $line_parms 1]

               if { $sql_inst == $inst }  {
                    puts " inst: $inst"

                    set shortname_list [lindex $line_parms 2]
                    puts " short_name: $shortname_list"

                    set nextday_list [lindex $line_parms 3]
                    puts " next_day: $nextday_list"
               }
         }
         default {
                    puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$auth_db_logon == ""} {
       puts "Unable to find AUTH_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global auth_logon_handle
   global auth_db_logon
   global auth_db
   global sql_inst

   if {[catch {set auth_logon_handle [oralogon $auth_db_logon@$auth_db]} result] } {
        puts "Encountered error $result while trying to connect to AUTH DB"
        exit 1
   } else {
        puts " Connected auth_db"
   }
}

proc arg_parse {} {
    global date_given argv institution_arg sql_inst

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
        puts " Date entered: $date_given"
    }
}

proc init_dates {val} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    
    set curdate          [clock format [clock seconds] -format %b-%d-%Y]
    puts " Report Generated on: $curdate"         

    set start_date_c     [clock format [clock scan "$val -1 day"] -format %Y%m%d040000]
    puts " Capture start date is >=  $start_date_c "

    set end_date_c       [clock format [clock scan "$val"] -format %Y%m%d051400]
    puts " Capture end date is    <  $end_date_c "

    set start_date_t     [clock format [clock scan "$val -1 day"] -format %Y%m%d181500]
    puts " Tranhistory start date is >=  $start_date_t "

    set end_date_t       [clock format [clock scan "$val"] -format %Y%m%d051400]
    puts " Tranhistory end date is    <  $end_date_t "
    
    set requested_date   [clock format [clock scan "$val"] -format %b-%d-%Y]
    puts " Report Request Date: $requested_date"
}


proc do_general_setup {} {
    global curdate requested_date date_given mail_to mail_err
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    set v_shortname ""
    foreach item $shortname_list {
        set v_shortname "${v_shortname}'$item',"
    }
    set v_shortname [string trim $v_shortname {,}]

    set v_nextday ""
    foreach item $nextday_list {
        set v_nextday "${v_nextday}'$item',"
    }
    set v_nextday [string trim $v_nextday {,}]

    set rpt "  Institution:, $sql_inst \n"
    append rpt "  Date Generated:, $curdate \n"
    append rpt "  Requested Date:, $requested_date \n\n\n"

}

proc do_capture_query {} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    set capture_query "
        SELECT SUBSTR(mid,1,16) as MID,
           SUBSTR(request_type,1,4) as REQUEST_TYPE,
           SUBSTR(transaction_id,1,18) as TID,
           SUBSTR(authdatetime,1,14) as AUTH_DATE,
           SUBSTR(shipdatetime,1,14) as SHIP_DATE,
           card_type as CARD_TYPE,
           STATUS as STATUS,
           OTHER_DATA4 as OTHER_DATA4,
           TO_CHAR(amount, '999999.00') as AMOUNT
        FROM capture
        WHERE mid in (select mid
                      from MERCHANT
                      where MMID in (select MMID
                                     from MASTER_MERCHANT
                                     where SHORTNAME in ($v_shortname)))
        AND authdatetime between '$start_date_c' and '$end_date_c'
        AND card_type = 'DB'
        AND ACTION_CODE = '000'
        ORDER BY shipdatetime  "

   #puts "capture_qry = $capture_query"

    if { [catch {orasql $auth_sql $capture_query} result] } {
          puts "Failed - $result"
          puts "Query - $capture_query"
          exit 1
    }
}

proc do_tranhistory_query {} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    set tranhistory_query "
        SELECT SUBSTR(mid,1,16) as MID,
           SUBSTR(request_type,1,4) as REQUEST_TYPE,
           SUBSTR(transaction_id,1,18) as TID,
           SUBSTR(authdatetime,1,14) as AUTH_DATE,
           SUBSTR(shipdatetime,1,14) as SHIP_DATE,
           card_type as CARD_TYPE,
           STATUS as STATUS,
           ARN as ARN,
           TO_CHAR(amount, '999999.00') as AMOUNT
        FROM tranhistory
        WHERE mid in (select mid
                      from MERCHANT
                      where MMID in (select MMID
                                     from MASTER_MERCHANT
                                     where SHORTNAME in ($v_nextday)))
        AND shipdatetime between '$start_date_t' and '$end_date_t'
        AND card_type = 'DB'
        AND ACTION_CODE = '000'
        ORDER BY authdatetime  "

   # puts $tranhistory_query
   
    if { [catch {orasql $auth_sql $tranhistory_query} result] } {
          puts "Failed - $result"
          puts "Query - $tranhistory_query"
          exit 1
    }
}

proc do_totals {} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    do_capture_query

    set totals(Capture_AMOUNT)   0

    while { [orafetch $auth_sql -dataarray row -indexbyname] != 1403 } {
             set totals(Capture_AMOUNT) [expr $totals(Capture_AMOUNT) + $row(AMOUNT)]
    }

    set rpt "${rpt}Total Capture Amount:,$totals(Capture_AMOUNT)\n"

    do_tranhistory_query

    set totals(Tranhistory_AMOUNT)   0

    while { [orafetch $auth_sql -dataarray row -indexbyname] != 1403 } {
             set totals(Tranhistory_AMOUNT) [expr $totals(Tranhistory_AMOUNT) + $row(AMOUNT)]
    }

    set rpt "${rpt}Total Tranhistory Amount:,$totals(Tranhistory_AMOUNT)\n"

    set grand_total [expr $totals(Capture_AMOUNT) + $totals(Tranhistory_AMOUNT)]
    set rpt "${rpt}Grand Total:,$grand_total\n\n\n"
}

proc do_capture_report {} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    do_capture_query

    append rpt "Merchant ID,Request Type,Transaction ID,Auth Date,Ship Date,Card Type,\
                Status,Other_Data4,Amount\n"

    set totals(Capture_AMOUNT)   0

    while { [orafetch $auth_sql -dataarray row -indexbyname] != 1403 } {

        ### Add current line to report output

        append rpt "$row(MID),$row(REQUEST_TYPE),'$row(TID),'$row(AUTH_DATE),'$row(SHIP_DATE),\
                    $row(CARD_TYPE),$row(STATUS),'$row(OTHER_DATA4),$row(AMOUNT)\n"
   
        set totals(Capture_AMOUNT) [expr $totals(Capture_AMOUNT) + $row(AMOUNT)]
    }

    set rpt "${rpt}Capture Totals:,,,,,,,,$totals(Capture_AMOUNT)\n\n\n"

}

proc do_tranhistory_report {} {
    global curdate requested_date date_given
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    do_tranhistory_query

    append rpt "Merchant ID,Request Type,Transaction ID,Auth Date,Ship Date,Card Type,\
                Status,ARN,Amount\n"

    set totals(Tranhistory_AMOUNT)   0

    while { [orafetch $auth_sql -dataarray row -indexbyname] != 1403 } {

        ### Add current line to report output

        append rpt "$row(MID),$row(REQUEST_TYPE),'$row(TID),'$row(AUTH_DATE),'$row(SHIP_DATE),\
                    $row(CARD_TYPE),$row(STATUS),'$row(ARN),$row(AMOUNT)\n"

        set totals(Tranhistory_AMOUNT) [expr $totals(Tranhistory_AMOUNT) + $row(AMOUNT)]
    }

    set rpt "${rpt}Tranhistory Totals:,,,,,,,,$totals(Tranhistory_AMOUNT)\n\n\n"

}

proc print_report {} {
    global curdate requested_date date_given mail_to mail_err
    global start_date_c end_date_c start_date_t end_date_t
    global auth_sql capture_query sql_inst
    global shortname_list nextday_list
    global v_shortname v_nextday rpt

    set file_name "$sql_inst.DEBIT_PreFunding_Report.$date_given.csv"

    set fl [open $file_name w]

    puts $fl $rpt

    close $fl

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"
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

set auth_sql [oraopen $auth_logon_handle]

arg_parse

if {[info exists date_given]} {
     init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %Y%m%d]     
} else {
     init_dates [clock format [clock seconds] -format %Y%m%d] 
     set date_given [clock format [clock seconds] -format %Y%m%d]                         
}

do_general_setup

do_totals

do_capture_report

do_tranhistory_report

print_report

oraclose $auth_sql

oralogoff $auth_logon_handle
