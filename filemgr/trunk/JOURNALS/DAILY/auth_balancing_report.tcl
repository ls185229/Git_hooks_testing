#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: auth_balancing_report.tcl 4025 2017-01-16 20:15:51Z fcaron $
# $Rev: 4025 $
################################################################################
#
#    File Name   -  auth_balancing_report.tcl
#
#    Description -  This is a custom report used by accounting for 
#                   daily balancing of Auth by institution and card type.
#    
#                   The window used for this report is from: 05 AM yesterday
#                   to 05 AM today.
#
#                   For the list of request types please see:
#                   sysnet.jetpay.com/wiki/Message_Types
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
source $env(MASCLR_LIB)/masclr_tcl_lib
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
   global port_db_logon
   global port_db
   global shortname_list
   global sql_inst
   global argv mail_to mail_err

   set port_db_logon ""
   set port_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name auth_balancing.cfg
          puts " Default Config File: $cfg_file_name"
   }
   
   #scan for Institution
   set institution_arg ""

   if { [regexp -- {(-[iI])[ ]+([0-9]{3})} $argv dummy1 dummy2 institution_arg] } {
         set sql_inst $institution_arg
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " *** File Open Err: Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "PORT_DB_LOGON" {
            set port_db_logon [lindex $line_parms 1]
         }
         "PORT_DB" {
            set port_db [lindex $line_parms 1]
         }
         "MAIL_ERR" {
            set mail_err [lindex $line_parms 1]
         }
         "MAIL_TO" {
            set mail_to [lindex $line_parms 1]
         }
         "INST_LINE" {
            set inst [lindex $line_parms 1]
            
            if { $inst == $sql_inst }  {
                 puts " institution: $sql_inst"
                              
                 set shortname_list [lindex $line_parms 2]
                 puts " shortnames: $shortname_list"
            }
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }
   close $file_ptr

   if {$port_db_logon == ""} {
       puts "Unable to find PORT_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global port_logon_handle 
   global port_db_logon
   global port_db

   if {[catch {set port_logon_handle [oralogon $port_db_logon@$port_db]} result] } {
        puts "Encountered error $result while trying to connect to PORT_DB"
        exit 1
   } else {
        puts " Connected to port_db"
   }
}

proc arg_parse {} {
    global date_given argv 

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
        puts " Date entered: $date_given"
    }
}

proc init_dates {val} {
    global  curdate start_date end_date requested_date date_given 

    set curdate        [clock format [clock seconds] -format %b-%d-%Y]
    puts " Report Generated on: $curdate"

    set start_date     [clock format [clock scan "$val -1 day"] -format %Y%m%d05] 
    puts " start date is >=  $start_date "

    set end_date       [clock format [clock scan "$val"] -format %Y%m%d05]
    puts " end date is    <  $end_date "

    set requested_date [clock format [clock scan "$val"] -format %b-%d-%Y]
    puts " Report Request Date: $requested_date"
}

proc do_report {} {
    global curdate start_date end_date requested_date date_given
    global port_sql main_query sql_inst mail_to mail_err
    global shortname_list v_shortname

    set v_shortname ""
    foreach item $shortname_list {
        set v_shortname "${v_shortname}'$item',"
    }
    set v_shortname [string trim $v_shortname {,}]

    set main_query "
        select
          to_date(substr('$end_date', 1, 8), 'YYYYMMDD')                                     as SETTLE_DATE,
          cts.card_type                                                                      as CARD_TYPE,
          cts.settle_type                                                                    as SETTLE_TYPE,
          count(trans.request_type)                                                          as TOTAL_COUNT,
          nvl(sum(trans.amount),0)                                                           as TOTAL_AMOUNT,
          nvl(sum(case when trans.request_type = '02' then 1            end),0)              as SALES_COUNT,
          nvl(sum(case when trans.request_type = '02' then trans.amount end),0)              as SALES_AMOUNT,
          nvl(sum(case when trans.request_type = '04' then 1            end),0)              as REFUND_COUNT,
          nvl(sum(case when trans.request_type = '04' then trans.amount end),0)              as REFUND_AMOUNT,
          nvl(sum(case when trans.request_type not in ('02', '04') then 1            end),0) as OTHER_COUNT,
          nvl(sum(case when trans.request_type not in ('02', '04') then trans.amount end),0) as OTHER_AMOUNT
        from port.card_type_settle cts
             left outer join ( select
                                 mm.shortname,
                                 t.card_type,
                                 case when t.card_type = 'VS' then m.settle_visa
                                      when t.card_type = 'MC' then m.settle_master_card
                                      when t.card_type = 'DS' then m.settle_discover
                                      when t.card_type = 'DB' then 
                                           case when m.settle_debit = ' ' then 'JTPY' else m.settle_debit end 
                                      when t.card_type = 'AX' and mm.shortname = 'OKDMV' then 'CAPN_JTPY'
                                      when t.card_type = 'AX' then m.settle_amex
                                      else t.card_type end settle_type,
                                 substr(t.request_type, 1, 2)  request_type,
                                 (case when substr(t.request_type, 1, 2) = '02' then 1 else -1 end * amount) amount
                               from port.tranhistory              t
                                    join port.tei_merchant        m
                                         on m.mid = t.mid
                                    join port.tei_master_merchant mm
                                         on mm.mmid = m.mmid
                               where t.settle_date >= '$start_date'   and
                                     t.settle_date <  '$end_date'     and
                                     mm.shortname in  ($v_shortname)  and                              
                                     ( t.card_type != 'DS' or 
                                       t.mid not in ( select eta.entity_name mid
                                                      from acq_entity ae
                                                      join entity_to_port eta
                                                           on  eta.institution_id = ae.institution_id and
                                                               eta.entity_id = ae.entity_id
                                                      where ae.disc_qual_ind = 'N'          and
                                                            ae.institution_id = '$sql_inst' and
                                                            ae.entity_status = 'A'          and
                                                            ae.entity_level = 70 
                                                    )                 
                                     )
         
                             ) trans
        on cts.card_type = trans.card_type  and
           cts.settle_type = trans.settle_type
        group by cts.card_type, cts.settle_type, cts.sort_order
        order by cts.sort_order
        "

#   puts $main_query

    if { [catch {orasql $port_sql $main_query} result] } {
          puts "Failed - $result"
          puts "Query - $main_query"
          exit 1
    }

    set rpt "  Institution:, $sql_inst \n"
    append rpt "  Date Generated:, $curdate \n"
    append rpt "  Requested Date:, $requested_date \n\n\n"
    append rpt "Settle Date,Crad Type,Settle Type,Total Count,Total Amount,Sales Count,\
                Sales Amount,Refund Count,Refund Amount,Other Count,Other Amount\n"

    while { [orafetch $port_sql -dataarray row -indexbyname] != 1403 } {
        ### Add current line to report output

        append rpt "$row(SETTLE_DATE),$row(CARD_TYPE),$row(SETTLE_TYPE),$row(TOTAL_COUNT),\
                    $row(TOTAL_AMOUNT),$row(SALES_COUNT),$row(SALES_AMOUNT),$row(REFUND_COUNT),\
                    $row(REFUND_AMOUNT),$row(OTHER_COUNT),$row(OTHER_AMOUNT)\n"
    }

    set file_name "$sql_inst.Auth_Balancing_Report.$date_given.csv"

    set fl [open $file_name w]

    puts $fl $rpt

    close $fl

	MASCLR::mutt_send_mail $mail_to  "$file_name" "Please see attached." "$file_name"
    exec mv $file_name ./ARCHIVE
}

#######
# MAIN
#######

readCfgFile

connect_to_db

set port_sql  [oraopen $port_logon_handle]

arg_parse

if {[info exists date_given]} {
     init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %Y%m%d]
} else {
     init_dates [clock format [clock seconds] -format %Y%m%d]
     set date_given [clock format [clock seconds] -format %Y%m%d]
}

do_report

oraclose $port_sql

oralogoff $port_logon_handle
