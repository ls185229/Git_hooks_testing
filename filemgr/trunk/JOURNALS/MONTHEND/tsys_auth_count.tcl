#!/usr/bin/env tclsh

# $Id: tsys_auth_count.tcl 1933 2012-12-26 20:04:15Z mitra $

###
# TSYS Authorization Count
# This scripts can run with or without a date. If no date provided it will use start and end of the current month.
# With one date argument, the script will calculatethe month start and end based on the given date.

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
    global  start_date  end_date generated_date file_date
     
    set generated_date $val
    puts "Report date: $val"
     
    set start_date    [clock format [clock scan "$val"] -format %Y%m01000000]
    puts " start date is :  $start_date "

    set end_date     [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
    puts " end date is :  $end_date "

    set file_date  [clock format [clock scan "$val"] -format %b_%Y]
    puts " file date: $file_date"
}

if {[catch {set handleA [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
    puts "$argv0 failed to run\n$result"
    exit
}

set cursor_A    [oraopen $handleA]

proc do_report {} {
    global cursor_A start_date end_date generated_date file_date

    set qry "SELECT m.visa_id MERCHANT_ID, m.long_name MERCHANT_NAME, tr.tid, 
                    substr(authdatetime, 1, 4) || '/' || substr(authdatetime, 5, 2) as AUTH_MONTH,
                    count(1) as AUTH_COUNT
             FROM   teihost.merchant m, teihost.transaction tr
             WHERE  m.mid = tr.mid
                    AND tr.request_type = '0100'
                    AND tr.authdatetime >= $start_date
                    AND tr.authdatetime < $end_date
                    AND substr(tr.tid,1,4) = 'JSYS'
             GROUP BY m.visa_id, m.long_name, tr.tid, substr(tr.authdatetime, 1, 4) || '/' || substr(tr.authdatetime, 5, 2)
             ORDER BY m.visa_id, m.long_name, tr.tid, substr(tr.authdatetime, 1, 4) || '/' || substr(tr.authdatetime, 5, 2)"

    orasql $cursor_A $qry

    set rpt "  Date Generated: $generated_date \n"
    set rpt "${rpt}  Report Month: $file_date \n\n"
    set rpt "${rpt}MERCHANT ID,MERCHANT NAME,TID,AUTH MONTH,AUTH COUNT\n"

    set totals(AUTH_COUNT) 0
    
    while { [orafetch $cursor_A -dataarray row -indexbyname] != 1403 } {

        ### Add current line to report output
       
        set E_NAME [string map {, " "} $row(MERCHANT_NAME)]
        set rpt "$rpt$row(MERCHANT_ID),$E_NAME,$row(TID),$row(AUTH_MONTH),$row(AUTH_COUNT)\n"
        
        ###

        puts "$row(MERCHANT_ID),$E_NAME,$row(TID),$row(AUTH_COUNT),$row(AUTH_MONTH)"
        puts "$row(MERCHANT_ID),$E_NAME,$row(TID),$row(AUTH_MONTH),$row(AUTH_COUNT)"

        set totals(AUTH_COUNT) [expr $totals(AUTH_COUNT) + $row(AUTH_COUNT)]

    }

    set rpt "${rpt}TOTALS:,,,,$totals(AUTH_COUNT)"
    
    set file_name "tsys_auth_count_$file_date.csv"
    set fl [open $file_name w]

    puts $fl $rpt

    close $fl

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "reports-clearing@jetpay.com,accounting@jetpay.com"

    exec mv $file_name ./ARCHIVE
}

#######
# MAIN
#######

arg_parse

if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock seconds] -format %d-%b-%Y]
}

do_report

oraclose $cursor_A
oralogoff $handleA

