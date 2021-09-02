#!/usr/bin/env tclsh

# $Id: ach_deposit.tcl 2527 2014-01-28 16:33:31Z msanders $

package require Oratcl

global db_logon_handle_

global log_file
global log_file_name
set log_file_name "./LOG/convchg_funding_monthend.log"

global mail_file
set mail_filename "convchg_funding_monthend.mail"

######################################################################
# process Convenience Charge Funding Month End Report
######################################################################
proc do_report {} {

   global env
   global argv
   global sql_date
   global month_year
   global is_sales_tids
   global is_return_tids
   global is_dispute_tids
   global qry
   global cursor_C
   global db_logon_convchg_funding
   global db_login_handle_convchg_funding
   global qry
   global convchg_funding_rec
   global month_year
   global start_date
   global end_date

   set authdb $env(RPT_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_convchg_funding [oralogon teihost/quikdraw@$authdb]} result]} {
        puts "Encountered error $result while trying to connect to the $authdb database for convchg_funding Monthly query" 
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_convchg_funding]} result]} {
        puts "Encountered error $result while trying to create convchg_funding database handle"
        exit
    }

    set counter 0
    
    puts "Start date = $start_date"
    puts "End date = $end_date"
    
   set qry "SELECT mm.shortname,th.mid,m.long_name,m.visa_id,SUBSTR(settle_date, 0, 8) as SETTLE_DATE,SUBSTR(shipdatetime, 0, 8) as SHIP_DATE,
            SUM(CASE WHEN card_type = 'AX' THEN amount * decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS AX_AMOUNT,
            SUM(CASE WHEN card_type = 'AX' THEN 1 ELSE 0 END)AS AX_Count,
            SUM(CASE WHEN card_type = 'DS' THEN amount * decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS DS_AMOUNT,
            SUM(CASE WHEN card_type = 'DS' THEN 1 ELSE 0 END)AS DS_count,
            SUM(CASE WHEN card_type = 'MC' THEN amount * decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS MC_AMOUNT,
            SUM(CASE WHEN card_type = 'MC' THEN 1 ELSE 0 END)AS MC_count,
            SUM(CASE WHEN card_type = 'VS' THEN amount * decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS VS_AMOUNT,
            SUM(CASE WHEN card_type = 'VS' THEN 1 ELSE 0 END)AS VS_count,
            SUM(CASE WHEN card_type = 'DB' THEN amount * decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS DB_AMOUNT,
            SUM(CASE WHEN card_type = 'DB' THEN 1 ELSE 0 END)AS DB_count,
            SUM(amount * decode(substr(request_type, 1, 2), '04', -1, 1)) as Total_amount,
            SUM(fee_amount * decode(substr(request_type, 1, 2), '04', -1, 1)) as Convenience_amount,
            SUM(amount * decode(substr(request_type, 1, 2), '04', -1, 1)) - SUM(fee_amount * decode(substr(request_type, 1, 2), '04', -1, 1)) AS Net_amount
        FROM
            teihost.tranhistory th, 
            teihost.merchant m
            JOIN teihost.master_merchant mm ON m.mmid = mm.mmid
        WHERE 
            m.mmid in (SELECT mmid FROM teihost.master_merchant WHERE shortname like 'CNV%107%') AND
            (settle_date >= '$start_date' AND settle_date < '$end_date') AND
            th.mid = mm.mmid
        GROUP BY 
            mm.shortname,th.mid,m.long_name,m.visa_id,SUBSTR(settle_date, 0, 8),SUBSTR(shipdatetime, 0, 8)
        ORDER BY 
            m.visa_id"
    
    global convchg_funding_rec
    global month_year

    set convchg_funding_rec "Short Name,MID,Long Name,Visa ID,Settle Date, Ship Date, AX Amount,AX Count,"
    append convchg_funding_rec "DS Amount,DS Count,MC Amount,MC Count,VS Amount,VS Count,DB Amount,DB Count"
    append convchg_funding_rec "Total Amount,Conv Amount,Net Amt\n"

    set totals(AXAMOUNT) 0
    set totals(AXCOUNT) 0
    set totals(DSAMOUNT) 0
    set totals(DSCOUNT) 0
    set totals(MCAMOUNT) 0
    set totals(MCCOUNT) 0
    set totals(VSAMOUNT) 0
    set totals(VSCOUNT) 0
    set totals(DBAMOUNT) 0
    set totals(DBCOUNT) 0
    set totals(TOTALCOUNT) 0
    set totals(CONVENIENCE_AMOUNT) 0
    set totals(NET_AMOUNT) 0
    orasql $cursor_C $qry 
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
        ####################################
        # Add current line to report output
        ####################################
        append convchg_funding_rec "$row(SHORTNAME)," 
        append convchg_funding_rec "$row(MID)," 
        append convchg_funding_rec "$row(LONG_NAME),"
        append convchg_funding_rec "$row(VISA_ID),"
        append convchg_funding_rec "$row(SETTLE_DATE),"
        append convchg_funding_rec "$row(SHIP_DATE),"
        append convchg_funding_rec "$row(AX_AMOUNT),"
        append convchg_funding_rec "$row(AX_COUNT),"
        append convchg_funding_rec "$row(DS_AMOUNT),"
        append convchg_funding_rec "$row(DS_COUNT),"
        append convchg_funding_rec "$row(MC_AMOUNT),"
        append convchg_funding_rec "$row(MC_COUNT),"
        append convchg_funding_rec "$row(VS_AMOUNT),"
        append convchg_funding_rec "$row(VS_COUNT),"
        append convchg_funding_rec "$row(DB_AMOUNT),"
        append convchg_funding_rec "$row(DB_COUNT),"
        append convchg_funding_rec "$row(CONVENIENCE_AMOUNT),"
        append convchg_funding_rec "$row(NET_AMOUNT)\n"
    
        set totals(AXAMOUNT) [expr $totals(AXAMOUNT) + $row(AX_AMOUNT)]
        set totals(AXCOUNT)  [expr $totals(AXCOUNT) + $row(AX_COUNT)]
        set totals(DSAMOUNT) [expr $totals(DSAMOUNT) + $row(DS_AMOUNT)]
        set totals(DSCOUNT)  [expr $totals(DSCOUNT) + $row(DS_COUNT)]
        set totals(MCAMOUNT) [expr $totals(MCAMOUNT) + $row(MC_AMOUNT)]
        set totals(MCCOUNT)  [expr $totals(MCCOUNT) + $row(MC_COUNT)]
        set totals(VSAMOUNT) [expr $totals(VSAMOUNT) + $row(VS_AMOUNT)]
        set totals(VSCOUNT)  [expr $totals(VSCOUNT) + $row(VS_COUNT)]
        set totals(DBAMOUNT) [expr $totals(DBAMOUNT) + $row(DB_AMOUNT)]
        set totals(DBCOUNT)  [expr $totals(DBCOUNT) + $row(DB_COUNT)]
        #set totals(TOTALCOUNT) [expr $totals(TOTALCOUNT) + $row(TOTALCOUNT)]
        set totals(CONVENIENCE_AMOUNT) [expr $totals(CONVENIENCE_AMOUNT) + $row(CONVENIENCE_AMOUNT)]
        set totals(NET_AMOUNT) [expr $totals(NET_AMOUNT) + $row(NET_AMOUNT)]

        incr counter
    }

    append convchg_funding_rec "TOTALS:,,,,,,$totals(AXAMOUNT),$totals(AXCOUNT),"
    append convchg_funding_rec "$totals(DSAMOUNT),$totals(DSCOUNT),"
    append convchg_funding_rec "$totals(MCAMOUNT),$totals(MCCOUNT),"
    append convchg_funding_rec "$totals(VSAMOUNT),$totals(VSCOUNT),"
    append convchg_funding_rec "$totals(DBAMOUNT),$totals(DBCOUNT),"
    append convchg_funding_rec "$totals(DBAMOUNT),$totals(DBCOUNT),"
    append convchg_funding_rec "$totals(TOTALCOUNT),$totals(CONVENIENCE_AMOUNT),$totals(NET_AMOUNT)\n"

    set temp_msg [format "Convenience Charge Funding Month Ends Report contains %d record(s)" $counter]
    write_log_message $temp_msg  

    #set month_year [clock format [clock seconds] -format "%m%Y"]
    set month_year [string range $start_date 0 5]
    set file_name "convchg_funding_monthend_$month_year.csv"
    set fl [open $file_name w]
  
    puts $fl $convchg_funding_rec
    
    close $fl
    
    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" --  "accounting@jetpay.com,reports-clearing@jetpay.com" 
    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "fcaron@jetpay.com" 
    exec mv $file_name ./ARCHIVE
}

########################################################################
# open_log_file
########################################################################
proc open_log_file {} {

    global log_file_name
    global log_file
    
    if {[catch {open $log_file_name a} log_file]} {
        puts stderr "Cannot open file $log_file_name for logging."
        return
    }
    
};# end open_log_file

##################################################
# open_mail_file
##################################################
proc open_mail_file {} {

    global mail_file
    global mail_filename
    
    if {[catch {open $mail_filename w} mail_file]} {
        puts stderr "Cannot open file $mail_filename for Convenience Charge Funding settlement mail."
        return
    }
    
};# end open_mail_file

##################################################
# write_log_message
##################################################
proc write_log_message { log_msg_text } {

    global log_file

    if { [catch {puts $log_file "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg"
    }
    flush $log_file

};# end log_message

#################################################
# close_log_file
##################################################
proc close_log_file {} {

    global log_file_name
    global log_file
    
    if {[catch {close $log_file} response]} {
        puts stderr "Cannot close file $log_file_name.  Changes may not be saved to the file."
        exit 1
    }
    
};# end close_log_file

##################################################
# close_mail_file
##################################################
proc close_mail_file {} {

    global mail_file_name
    global mail_file
    
    if {[catch {close $mail_file} response]} {
        puts stderr "Cannot close file $mail_filename.  Changes may not be saved to the file."
        exit 1
    }
    
};# end close_mail_file

############################################
# Parse arguments if given
############################################

proc arg_parse {} { 
    
    global date_given argv
    # scan for Date
    if { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
     puts "Date entered: $date_given"
  }
}

##############################################
# Initialize dates - if date passed base on  
# current date, otherwise use previous month.
# Calculate start date, end date, file date 
# and report year/month
##############################################

proc init_dates {val} {
  global start_date end_date file_date curdate report_month
  set curdate [clock format [clock seconds] -format %d-%b-%Y]
  puts "Date Generated: $curdate"         

  set start_date [clock format [clock scan "$val"] -format %Y%m01000000]
  puts "Start date is >=  $start_date "

  set end_date [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
  puts "End date is <  $end_date "

  set file_date [clock format [clock scan "$val"] -format %Y%m]
  puts "File date: $file_date"

  set report_month [clock format [clock scan "$val"] -format %b_%Y]
  puts " Report Month: $report_month"
}

#################################################
#  MAIN
#################################################

arg_parse

if {[info exists date_given]} {
  init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]
}

open_log_file

write_log_message "START Convenience Charge Funding Month End Report ***"
open_mail_file
write_log_message "Select Convenience Charge Month Funding End Records ***"
do_report
write_log_message "END  Convenience Charge Month Funding End Report ***"
close_log_file
oraclose $cursor_C
