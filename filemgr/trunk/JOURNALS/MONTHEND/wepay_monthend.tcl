#!/usr/bin/env tclsh

################################################################################
# $Id: WePay_monthend.tcl 
################################################################################
#
# File Name:  WePay_monthend.tcl
# Description:  This script generates the monthend WePay Report
# Script Arguments:  
# Output:  Month End Fees Collected Report
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  start & end date are calculated
#
#################################################################################

package require Oratcl

#System variables
global argv
global env
global db_logon_handle_WePay_a
global db_logon_handle_WePay_s
global Wepay_a
global Wepay_s
global run_file_date
global inst_id
global log_file
global log_file_name
global mail_file
global mail_filename
global cfg_file
global cfg_filename
global out_file
global out_filename
global qry 
global start_date
global year_month

#Global variables for file processing
global STD_OUT_CHANNEL
set STD_OUT_CHANNEL stderr

set log_file_name "./LOG/WePay_monthend.log"
set mail_filename "WePay_monthend.mail"

global julian_file_date

global start_date
global year_month
set run_file_date [clock format [clock seconds] -format "%Y%m%d"]
set julian_file_date [clock format [clock seconds] -format "%Y%j"]

set start_date [clock format [clock second] -format %Y%m01000000]
set Y [string range $julian_file_date 3 3]
set jjj [string range $julian_file_date 4 6]
set year_month [string range $start_date 0 5]
set out_filename [format "WePay_monthend_$year_month.csv" $Y $jjj]

##################################################
# open_wepay_file
#   Open the output file.
##################################################
proc open_wepay_file {} {

    global out_filename
    global out_file
    
    if {[catch {open $out_filename a} out_file]} {
        puts stderr "Cannot open file $out_filename for building WePay file."
        return
    }
};# end open_wepay_file

##################################################
# open_log_file
#   Open the Fees Collected log file.
##################################################
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
#   Open Fees Collected mail file.
##################################################
proc open_mail_file {} {

    global mail_file
    global mail_filename
    
    if {[catch {open $mail_filename w} mail_file]} {
        puts stderr "Cannot open file $mail_filename for WePay Month End mail."
        return
    }
};# end open_mail_file

########################################
# open_db
#   Connect to the Clearing database.
########################################
proc open_db {} {

    global authdb
    global auth_db_logon
    global db_logon_handle_WePay_a
    global db_logon_handle_WePay_s
    global Wepay_a
    global Wepay_s
    global env

    set authdb $env(RPT_DB)   

    #
    # Open WePay Month End Auth query
    #
    if {[catch {set db_logon_handle_WePay_a [oralogon TEIHOST/quikdraw@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to the $authdb database for WePay Auth Month End query"
        exit
    }
    if {[catch {set Wepay_a [oraopen $db_logon_handle_WePay_a]} result]} {
        puts "Encountered error $result while trying to create WePay database handle"
        exit
    }

    #
    # Open WePay Month End Settle query
    #
    if {[catch {set db_logon_handle_WePay_s [oralogon TEIHOST/quikdraw@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to the $authdb database for WePay Settle Month End query"
        exit
    }
    if {[catch {set Wepay_s [oraopen $db_logon_handle_WePay_s]} result]} {
        puts "Encountered error $result while trying to create WePay database handle"
        exit
    }
    
};# end open_db

##################################################
# write_log_message
#   Write message to the Merlin log file.
##################################################
proc write_log_message { log_msg_text } {

    global log_file

    if { [catch {puts $log_file "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg"
    }
    flush $log_file
};# end log_message

##################################################
# compose_mail_msg
#   Compose a mail message to Clearing with basic
#   transaction data.
##################################################
proc compose_mail_msg { mail_rec } {

    global mail_file
   
    puts $mail_file "$mail_rec\n"
    flush $mail_file
 
};# end compose_mail_msg

#########################################################
# select_wepays  
#   Retrieve WePay Month End records from the
#   Clearing database.
#########################################################
proc select_wepay { } {

    global daily_start_time
    global run_file_date
    global Wepay_a
    global Wepay_s
    global argv
    global qry_a
    global qry_s    
    global start_date
    global end_date
    global year_month
    global f1 
    write_log_message "Run Date = $run_file_date"
    write_log_message "Start = $start_date" 
    write_log_message "End = $end_date"

    set wepay_authrec ""
    append wepay_auth`rec "WEPAY COUNTS FOR DATES BETWEEN $start_date AND $end_date\n"
    append wepay_authrec ""

    append wepay_authrec "\n"
    append wepay_authrec "======= Auth Counts =======\n"
    append wepay_authrec "\n" 

    # Header Record
    #
    append wepay_authrec "Year/Month,Request Type,Card Type,Count,Amount\n"

    #
    # Retrieve Auth records
    #
    set qry_a "SELECT   SUBSTR(AUTHDATETIME, 1, 6) AS YearMonth, 
                 DECODE(GROUPING(REQUEST_TYPE),
	              0, REQUEST_TYPE,
	              1, 'TOTAL') AS RequestType, 
                 DECODE(GROUPING(CARD_TYPE), 
	              0, DECODE(CARD_TYPE, ' ', 'Bad Card Data', 'VS', 'VISA', 'MC', 'MASTERCARD', 'AX', 'AMEX',CARD_TYPE),
	              1, 'Total') AS CardType,
	         COUNT(1) as CT, SUM(AMOUNT) AS Amount
	FROM  teihost.TRANSACTION 
        WHERE MID LIKE 'WEPAYCA-%' 
          AND REQUEST_TYPE IN ('0100', '0102', '0190', '0200', '0220', '0240', '0250','0252', '0260', '0352', '0354', '0356', '0358', '0420','0440', '0450', '0460', '0480', '0500', '0530')
          AND AUTHDATETIME >= '$start_date' AND AUTHDATETIME < '$end_date'
	GROUP BY SUBSTR(AUTHDATETIME, 1, 6), CUBE(REQUEST_TYPE, CARD_TYPE) 
	ORDER BY SUBSTR(AUTHDATETIME, 1, 6), REQUEST_TYPE, CARD_TYPE"
 
    orasql $Wepay_a $qry_a
    
    while { [orafetch $Wepay_a -dataarray row -indexbyname] != 1403 } {
        append wepay_authrec "$row(YEARMONTH),"
        append wepay_authrec "$row(REQUESTTYPE),"
        append wepay_authrec "$row(CARDTYPE),"
        append wepay_authrec "$row(CT),"
        append wepay_authrec "$row(AMOUNT)\n"
    }
    
    set wepay_setlrec "\n"
    append wepay_setlrec "======= Settled Counts =======\n"
    append wepay_setlrec "\n" 

    #
    # Header Record
    #
    append wepay_setlrec "Year/Month,Request Type,Card Type,Count,Amount\n"

    #
    # Retrieve Settlement records
    #
    set qry_s "	SELECT SUBSTR(AUTHDATETIME, 1, 6) AS YearMonth, 
	         DECODE(GROUPING(REQUEST_TYPE),
	              0, REQUEST_TYPE,
	              1, 'TOTAL') AS RequestType, 
	         DECODE(GROUPING(CARD_TYPE), 
	              0, DECODE(CARD_TYPE, ' ', 'Bad Card Data', 'VS', 'VISA', 'MC', 'MASTERCARD', 'AX', 'AMEX', CARD_TYPE),
	              1, 'Total') AS CardType,
	         COUNT(1) as CT, SUM(AMOUNT) AS Amount
	FROM  teihost.TRANHISTORY 
        WHERE MID LIKE 'WEPAYCA-%' 
          AND AUTHDATETIME BETWEEN '$start_date' AND '$end_date'
	GROUP BY SUBSTR(AUTHDATETIME, 1, 6), CUBE(REQUEST_TYPE, CARD_TYPE) 
	ORDER BY SUBSTR(AUTHDATETIME, 1, 6), REQUEST_TYPE, CARD_TYPE"


    orasql $Wepay_s $qry_s    

    while { [orafetch $Wepay_s -dataarray row -indexbyname] != 1403 } {
        append wepay_setlrec "$row(YEARMONTH),"
        append wepay_setlrec "$row(REQUESTTYPE),"
        append wepay_setlrec "$row(CARDTYPE),"
        append wepay_setlrec "$row(CT),"
        append wepay_setlrec "$row(AMOUNT)\n"
    }
    
    set year_month [string range $start_date 0 5]
    set file_name "WePay_$year_month.csv"
    set fl [open $file_name w]
 
    puts $fl $wepay_authrec 
    puts $fl $wepay_setlrec
    
    close $fl    
    
    #exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "accounting@jetpay.com,reports-clearing@jetpay.com" 
    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "fcaron@jetpay.com" 
    exec mv $file_name ./ARCHIVE
};# end select_wepay     
    
##################################################
# close_mail_file
#   Close reclass mail file.
##################################################
proc close_mail_file {} {

    global mail_file_name
    global mail_file
    
    if {[catch {close $mail_file} response]} {
        puts stderr "Cannot close file $mail_filename.  Changes may not be saved to the file."
        exit 1
    }
};# end close_mail_file

########################################
# close_db
#   Connect to the Clearing database.
########################################
proc close_db {} {

    global clrdb
    global db_logon_handle_WePay_a
    global db_logon_handle_WePay_s    
    global Wepay_a
    global Wepay_s

    #
    # Close WePay Month End
    #
    oraclose $Wepay_a
    if {[catch {oralogoff $db_logon_handle_WePay_a} result]} {
        puts "Encountered error $result while trying to close the $clrdb Auth database connection"
        exit 1
    }
    oraclose $Wepay_s
    if {[catch {oralogoff $db_logon_handle_WePay_s} result]} {
        puts "Encountered error $result while trying to close the $clrdb Settle database connection"
        exit 1
    }

};# end close_db

##################################################
# close_log_file
#   Close Fees Collected FTP log file.
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
# close_wepay_file
#   Close the output file.
##################################################
proc close_wepay_file {} {

    global out_filename
    global out_file
    
    if {[catch {close $out_file} response]} {
        puts stderr "Cannot close file $out_filename.  Changes may not be saved to the file."
        exit 1
    }
};# end close_wepay_file

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

    set start_date   [clock format [clock scan "$val"] -format %Y%m01000000]
    puts "Start date is >=  $start_date "

    set end_date     [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
    puts "End date is    <  $end_date "

    set file_date  [clock format [clock scan "$val"] -format %Y%m]
    puts "File date: $file_date"

    set report_month  [clock format [clock scan "$val"] -format %b_%Y]
    puts " Report Month: $report_month"
}

##################################################
# MAIN #
##################################################
if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]                             
}

open_log_file
write_log_message "START WePay Month End report ***"
open_mail_file
open_wepay_file
open_db

write_log_message " output file name will be $out_filename"
compose_mail_msg "Output filename is $out_filename"

write_log_message " Select WePay Month End report"
select_wepay  

close_db
close_wepay_file
close_mail_file
write_log_message "END WePay Month End report   ***"
close_log_file

exit 0
