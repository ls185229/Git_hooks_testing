#!/usr/bin/env tclsh

################################################################################
# $Id: auth_settle_counts.tcl 
################################################################################
#
# File Name:  auth_settle_counts.tcl
# Description:  This script generates the monthend auth settle counts Report
# Script Arguments:  
# Output:  Month End Auth Settle Counts Report
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
global db_logon_handle_AuthSetl_a
global db_logon_handle_AuthSetl_s
global AuthSetl_a
global AuthSetl_s
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

set inst_id [string trim [lindex $argv 0]]
set log_file_name "./LOG/$inst_id"
append $log_file_name "_monthend.log"

set mail_filename "$inst_id"
append mail_filename "_monthend.mail"

global julian_file_date

global start_date
global year_month
set run_file_date [clock format [clock seconds] -format "%Y%m%d"]
set julian_file_date [clock format [clock seconds] -format "%Y%j"]

set start_date [clock format [clock second] -format %Y%m01000000]
set Y [string range $julian_file_date 3 3]
set jjj [string range $julian_file_date 4 6]
set year_month [string range $start_date 0 5]
set out_filename "$inst_id"
append out_filename "_monthend_$year_month.csv"
set out_filename [format "$out_filename" $Y $jjj]  

##################################################
# open_output_file
#   Open the output file.
##################################################
proc open_output_file {} {

    global out_filename
    global out_file
    global inst_id
    
    if {[catch {open $out_filename a} out_file]} {
        puts stderr "Cannot open file $out_filename for building $inst_id file."
        return
    }
};# end open_output_file  

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
    global inst_id
    global argv

    set inst_id [string trim [lindex $argv 0]]
    if {[catch {open $mail_filename w} mail_file]} {
        puts stderr "Cannot open file $mail_filename for $inst_id Month End mail."
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
    global db_logon_handle_AuthSetl_a
    global db_logon_handle_AuthSetl_s
    global AuthSetl_a 
    global AuthSetl_s
    global env

    set authdb $env(RPT_DB)   

    #
    # Open WePay Month End Auth query
    #
    if {[catch {set db_logon_handle_AuthSetl_a [oralogon TEIHOST/quikdraw@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to the $authdb database for Auth Settle Month End query"
        exit
    }
    if {[catch {set AuthSetl_a [oraopen $db_logon_handle_AuthSetl_a]} result]} {
        puts "Encountered error $result while trying to create Auth Settle database handle"
        exit
    }

    #
    # Open Auth Settle  Month End query
    #
    if {[catch {set db_logon_handle_AuthSetl_s [oralogon TEIHOST/quikdraw@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to the $authdb database for Auth Settle Month End query"
        exit
    }
    if {[catch {set AuthSetl_s [oraopen $db_logon_handle_AuthSetl_s]} result]} {
        puts "Encountered error $result while trying to create Auth Settle database handle"
        exit
    }
    
};# end open_db

##################################################
# write_log_message
#   Write message to the log file.
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

proc run_query { value inst_id} {
    global start_date
    global end_date
    global AuthSetl_a 
    global AuthSetl_s
    set report_date [clock format [clock seconds] -format "%Y%m"]
    set file_date $report_date
    append report_date "01000000"
    set end_date $report_date
    set start_date [clock format [clock add [clock scan $end_date -format "%Y%m%d000000"] -1 months] -format "%Y%m%d000000"]

    set authsetl_authrec ""
    append authsetl_authrec "INSTITUTION [string range $inst_id 5 7] COUNTS FOR DATES\n"
    append authsetl_authrec "BETWEEN [string range $start_date 0 3]-[string range $start_date 4 5] AND [string range $end_date 0 3]-[string range $end_date 4 5]\n"
    append authsetl_authrec ""

    append authsetl_authrec "\n"
    append authsetl_authrec "======= Auth Counts =======\n"
    append authsetl_authrec "\n" 

    # Header Record
    #
    append authsetl_authrec "Year/Month,Request Type,Card Type,Count,Amount\n"

    #
    # Retrieve Auth records
    #
    set qry_a "SELECT SUBSTR(t.AUTHDATETIME, 1, 6) AS YEARMONTH,
       DECODE(GROUPING(REQUEST_TYPE), 0, REQUEST_TYPE, 1, 'TOTAL') AS REQUESTTYPE,
       DECODE(GROUPING(CARD_TYPE), 0, DECODE(CARD_TYPE, ' ', 'Bad Card Data', 'VS', 'VISA', 'MC', 'MASTERCARD', t.CARD_TYPE), 1, 'Total' ) AS CARDTYPE, 
       TO_CHAR(COUNT(1), '9999999') AS CT,
       TO_CHAR(SUM(AMOUNT),'999999990D00') AS AMOUNT
FROM 
  teihost.transaction t
  JOIN teihost.merchant m ON m.mid = t.mid
  JOIN teihost.master_merchant mm ON mm.mmid = m.mmid WHERE
  (mm.shortname in ($value))
  	AND REQUEST_TYPE IN 
	('0100','0102','0190','0200','0220','0240','0250','0252','0260','0352','0354','0356','0358',
         '0420','0440','0450','0460','0480','0500','0530')
	AND AUTHDATETIME BETWEEN '$start_date' AND '$end_date' 
GROUP BY 
	SUBSTR(AUTHDATETIME, 1, 6),
        CUBE(REQUEST_TYPE, CARD_TYPE)
ORDER BY 
	SUBSTR(AUTHDATETIME, 1, 6),
        REQUEST_TYPE,
        CARD_TYPE"
puts $qry_a 
    orasql $AuthSetl_a $qry_a
    
    while { [orafetch $AuthSetl_a -dataarray row -indexbyname] != 1403 } {
        append authsetl_authrec "$row(YEARMONTH),"
        append authsetl_authrec "$row(REQUESTTYPE),"
        append authsetl_authrec "$row(CARDTYPE),"
        append authsetl_authrec "$row(CT),"
        append authsetl_authrec "$row(AMOUNT)\n"
        if { ( [string match {*Total*} $row(CARDTYPE)] == 1  ) } {
           append authsetl_authrec "\n"  
        }
    }
    
    set auhsetl_setlrec "\n"
    append authsetl_setlrec "======= Settled Counts =======\n"
    append authsetl_setlrec "\n" 

    #
    # Header Record
    #
    append authsetl_setlrec "Year/Month,Request Type,Card Type,Count,Amount\n"

    #
    # Retrieve Settlement records
    #
    set qry_s "SELECT SUBSTR(th.AUTHDATETIME, 1, 6) AS YEARMONTH,
       DECODE(GROUPING(th.REQUEST_TYPE), 0, th.REQUEST_TYPE, 1, 'TOTAL') AS REQUESTTYPE,
       DECODE(GROUPING(th.CARD_TYPE), 0, DECODE(th.CARD_TYPE, ' ', 'Bad Card Data', 'VS', 'VISA', 'MC', 'MASTERCARD', CARD_TYPE), 1, 'Total' ) AS CARDTYPE,
       TO_CHAR(COUNT(1), '9999999') AS CT,
       TO_CHAR(SUM(th.AMOUNT),'999999990D00') AS AMOUNT
FROM 
    teihOST.TRANHISTORY th
    JOIN teihost.merchant m ON m.mid = th.mid
    JOIN teihost.master_merchant mm ON mm.mmid = m.mmid 
WHERE
  (mm.shortname in ($value))
   AND AUTHDATETIME BETWEEN '$start_date' AND '$end_date'
GROUP BY 
	SUBSTR(AUTHDATETIME, 1, 6),
        CUBE(REQUEST_TYPE, CARD_TYPE)
ORDER BY 
	SUBSTR(AUTHDATETIME, 1, 6),
        REQUEST_TYPE,
        CARD_TYPE"
puts $qry_s

    orasql $AuthSetl_s $qry_s    

    while { [orafetch $AuthSetl_s -dataarray row -indexbyname] != 1403 } {
        append authsetl_setlrec "$row(YEARMONTH),"
        append authsetl_setlrec "$row(REQUESTTYPE),"
        append authsetl_setlrec "$row(CARDTYPE),"
        append authsetl_setlrec "$row(CT),"
        append authsetl_setlrec "$row(AMOUNT)\n"
        if { ( [string match {*Total*} $row(CARDTYPE)] == 1  ) } {
           append authsetl_setlrec "\n"
        }
    }
    
    set year_month [string range $start_date 0 5]
    set file_name "$inst_id"
    append file_name "_monthend_$year_month.csv"
    set fl [open $file_name w]
 
    puts $fl $authsetl_authrec 
    puts $fl $authsetl_setlrec
    
    close $fl    
    
    exec echo "Please see attached." | mutt -a "$file_name" -s "Month End Auth Settle Count - Institution [string range $inst_id 5 7]" -- "clearing@jetpay.com, accounting@jetpay.com" 
    exec mv $file_name ./ARCHIVE
}


#########################################################
# select_authsetl
#   Retrieve Auth SettleMonth End records from the
#   Clearing database.
#########################################################
proc select_authsetl { } {

    global daily_start_time
    global run_file_date
    global AuthSetl_a
    global AuthSetl_s
    global argv
    global qry_a
    global qry_s    
    global start_date
    global end_date
    global year_month
    global f1 
    global inst_list
    global logdate
    write_log_message "Run Date = $run_file_date"
    write_log_message "Start = $start_date" 
    write_log_message "End = $end_date"

    set cfg_file_name "auth_settle_counts_monthend.cfg" 

    set logdate [clock seconds]
    set logdate [clock format $logdate -format "%m-%d-%Yd %H:%M"]

    if {[catch {open $cfg_file_name r} file_ptr]} {
      puts " *** File Open Err: Cannot open config file $cfg_file_name"
      exit 1
    }
    set inst_to_run [string trim [lindex $argv 0]] 

    set cur_line  [split [set orig_line [gets $file_ptr] ] ~]

    while {$cur_line != ""} {      
      if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_to_run } {
         set inst_list [lindex $cur_line 1]
      }
      set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    }

    run_query $inst_list $inst_to_run
    exec sleep 4 
    # exec echo "Month End Auth Settle for $inst_to_run at $logdate"  | mutt -s "Month End Auth Settle Count - Institution $inst_to_run" -- reports-clearing@jetpay.com@jetpay.com reports-clearing@jetpay.com@jetpay.com
    #exec echo "Month End Auth Settle for $inst_to_run at $logdate"  | mutt -s "Month End Auth Settle Count - Institution $inst_to_run" -- fcaron@jetpay.com


};# end select_authsetl     
    
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
    global db_logon_handle_AuthSetl_a
    global db_logon_handle_AuthSetl_s    
    global AuthSetl_a
    global AuthSetl_s

    #
    # Close Month End
    #
    oraclose $AuthSetl_a
    if {[catch {oralogoff $db_logon_handle_AuthSetl_a} result]} {
        puts "Encountered error $result while trying to close the $clrdb Auth database connection"
        exit 1
    }
    oraclose $AuthSetl_s
    if {[catch {oralogoff $db_logon_handle_AuthSetl_s} result]} {
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
# close_auth_setl_file
#   Close the output file.
##################################################
proc close_auth_setl_file {} {

    global out_filename
    global out_file
    
    if {[catch {close $out_file} response]} {
        puts stderr "Cannot close file $out_filename.  Changes may not be saved to the file."
        exit 1
    }
};# end close_auth_setl_file

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
write_log_message "START $inst_id Month End report ***"
open_mail_file
open_output_file
open_db

write_log_message " output file name will be $out_filename"
compose_mail_msg "Output filename is $out_filename"

write_log_message " Select $inst_id Month End report"
select_authsetl  

close_db
close_auth_setl_file
close_mail_file
write_log_message "END $inst_id Month End report   ***"
close_log_file

exit 0
