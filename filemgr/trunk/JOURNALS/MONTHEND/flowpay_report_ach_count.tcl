#!/usr/bin/env tclsh

# $Id: flowpay_report_ach_count.tcl 2490 2014-01-06 20:37:38Z mitra $

############################
# Flowpay ACH Count Report
# This scripts can run with or without a date. If no date provided it will use start and end of the last month.
# With one date argument, the script will calculatethe month start and end based on the given date.
############################

package require Oratcl

#set authdb auth4
set authdb $env(TSP4_DB) 

proc arg_parse {} {
    global date_given argv

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
        puts "Date entered: $date_given"
    }
}

proc init_dates {val} {
    global  start_date end_date file_date curdate report_month
    
    set curdate [clock format [clock seconds] -format %d-%b-%Y]
    puts " Date Generated: $curdate"         

    set start_date   [clock format [clock scan "$val"] -format %Y%m01000000]
    puts " start date is >=  $start_date "

    set end_date     [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
    puts " end date is    <  $end_date "

    set file_date  [clock format [clock scan "$val"] -format %Y%m]
    puts " file date: $file_date"

    set report_month  [clock format [clock scan "$val"] -format %b_%Y]
    puts " Report Month: $report_month"
}

if {[catch {set handleA [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
    puts "$argv0 failed to run\n$result"
    exit
}

set cursor_A    [oraopen $handleA]

proc do_report {} {
    global cursor_A start_date end_date file_date curdate report_month

    ### ACH Request types:
    ### '0668' Void
    ### '0660' Credit
    ### '0662' Debit
    ### '0679' Credit Reject
    ### '0680' Debit Reject

    set qry "SELECT ach.mid MERCHANT_ID, m.visa_id ENTITY_ID, m.long_name MERCHANT_NAME,
                SUM(CASE WHEN ach.request_type = '0660' THEN 1 ELSE 0 END) AS NUMBER_CREDITS,
                SUM(CASE WHEN ach.request_type = '0660' THEN ach.amount ELSE 0 END) AS AMOUNT_CREDITS,
                SUM(CASE WHEN ach.request_type = '0662' THEN 1 ELSE 0 END) AS NUMBER_DEBITS,
                SUM(CASE WHEN ach.request_type = '0662' THEN -ach.amount ELSE 0 END) AS AMOUNT_DEBITS,
                SUM(CASE WHEN ach.request_type = '0679' THEN 1 ELSE 0 END) AS Number_Credit_Rejects,
                SUM(CASE WHEN ach.request_type = '0680' THEN 1 ELSE 0 END) AS Number_Debit_Rejects,
                COUNT(CASE WHEN ach.request_type IN ('0660', '0662', '0679', '0680') THEN 1 END) AS TOTAL_NUMBER_TRANS,
                SUM(CASE WHEN ach.request_type in ('0660','0662') THEN ach.amount ELSE 0 END) AS TOTAL_GROSS_AMOUNT
             FROM teihost.achv3_history ach
             JOIN teihost.merchant m
             ON ach.mid = m.mid
             WHERE ach.mid in (SELECT mid from merchant
                               WHERE visa_id like '402529_2108%')
                                   AND ach.COMPLETION_DATE >= '$start_date'
                                   AND ach.COMPLETION_DATE <  '$end_date'
                                   AND ach.request_type in ('0660','0662','0679','0680')
                                   AND ach.status = 'CMP'
                               GROUP BY ach.mid, m.visa_id, m.long_name
                               ORDER BY m.visa_id, ach.mid"


    orasql $cursor_A $qry

    set rpt "  Date Generated: $curdate \n"
    set rpt "${rpt}  Report Month: $report_month \n\n"
    set rpt "${rpt}MERCHANT ID,ENTITY ID,MERCHANT NAME,Number Credits,Amount Credits,Number Debits,\
             Amount Debits,Total Number Trans,Total Gross Amount\n"

    set totals(NUMBER_CREDITS) 0
    set totals(AMOUNT_CREDITS) 0
    set totals(NUMBER_DEBITS) 0
    set totals(AMOUNT_DEBITS) 0
    set totals(TOTAL_NUMBER_TRANS) 0
    set totals(TOTAL_GROSS_AMOUNT) 0
    
    while { [orafetch $cursor_A -dataarray row -indexbyname] != 1403 } {

        ### Add current line to report output

        set ENT_NAME [string map {, " "} $row(MERCHANT_NAME)]      

        set rpt "$rpt$row(MERCHANT_ID),$row(ENTITY_ID),$ENT_NAME,$row(NUMBER_CREDITS),$row(AMOUNT_CREDITS),\
                 $row(NUMBER_DEBITS),$row(AMOUNT_DEBITS),$row(TOTAL_NUMBER_TRANS),$row(TOTAL_GROSS_AMOUNT)\n"

        set totals(NUMBER_CREDITS)     [expr $totals(NUMBER_CREDITS) + $row(NUMBER_CREDITS)]
        set totals(AMOUNT_CREDITS)     [expr $totals(AMOUNT_CREDITS) + $row(AMOUNT_CREDITS)]
        set totals(NUMBER_DEBITS)      [expr $totals(NUMBER_DEBITS) + $row(NUMBER_DEBITS)]
        set totals(AMOUNT_DEBITS)      [expr $totals(AMOUNT_DEBITS) + $row(AMOUNT_DEBITS)]
        set totals(TOTAL_NUMBER_TRANS) [expr $totals(TOTAL_NUMBER_TRANS) + $row(TOTAL_NUMBER_TRANS)]
        set totals(TOTAL_GROSS_AMOUNT) [expr $totals(TOTAL_GROSS_AMOUNT) + $row(TOTAL_GROSS_AMOUNT)]

    }

    set rpt "${rpt}\nTOTALS:,,,$totals(NUMBER_CREDITS),$totals(AMOUNT_CREDITS),$totals(NUMBER_DEBITS),    \
                               $totals(AMOUNT_DEBITS),$totals(TOTAL_NUMBER_TRANS),$totals(TOTAL_GROSS_AMOUNT)"
    
    set file_name "FLOWPAY.REPORT.ACH.COUNT_$file_date.csv"

    set fl [open $file_name w]

    puts $fl $rpt

    close $fl

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "Reports-clearing@jetpay.com,accounting@jetpay.com"

    exec mv $file_name ./ARCHIVE
}

#######
# MAIN
#######

arg_parse

if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]                             
}

do_report

oraclose $cursor_A
oralogoff $handleA

