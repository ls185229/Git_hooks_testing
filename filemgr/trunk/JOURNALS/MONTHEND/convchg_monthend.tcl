#!/usr/bin/env tclsh

package require Oratcl

global db_logon_handle_

global log_file
global log_file_name
set log_file_name "./LOG/convchg_monthend.log"

global mail_file
set mail_filename "convchg_monthend.mail"

######################################################################
# process convchg Month End Report
######################################################################
proc do_report {} {

   global env
   global argv
   global sql_date
   global month_year
   global is_sales_tids
   global is_return_tids
   global is_dispute_tids
   global inst_id
   global qry
   global cursor_C
   global db_logon_convchg
   global db_login_handle_convchg
   global qry
   global convchg_rec
   global month_year
   global start_date
   global end_date

   set clrdb $env(IST_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_convchg [oralogon masclr/masclr@$clrdb]} result]} {
        puts "Encountered error $result while trying to connect to the $clrdb database for convchg Monthly query" 
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_convchg]} result]} {
        puts "Encountered error $result while trying to create convchg database handle"
        exit
    }

    set counter 0

   puts "Start date = $start_date"
   puts "End date = $end_date"

   set qry "SELECT gl_date,entity_id,POSTING_ENTITY_ID,tid_settl_method as DbCr,COUNT(*) as rcount,SUM(amt_billing) as amt_billing
   FROM masclr.mas_trans_log WHERE posting_entity_id in ('454045211000234') AND gl_date >= to_date($start_date,'YYYYMMDD') AND gl_date < to_date($end_date,'YYYYMMDD')  
   and tid LIKE '010004%' AND tid_settl_method = 'D' GROUP BY gl_date,entity_id,POSTING_ENTITY_ID ,tid_settl_method ORDER BY gl_date, entity_id"

    global convchg_rec
    global month_year

    set convchg_rec "GL Date,Entity ID,Posting Entity ID,DrCr,Count,Amount Billing"

    set totals(AMTBILLING) 0
    set totals(COUNT) 0

    orasql $cursor_C $qry 
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
        ####################################
        # Add current line to report output
        ####################################
        append convchg_rec "$row(GL_DATE)," 
        # append convchg_rec {="} "$row(ENTITY_ID)" {",} 
        append convchg_rec "'$row(ENTITY_ID),"
        append convchg_rec "'$row(POSTING_ENTITY_ID),"
        append convchg_rec "$row(DBCR),"
        append convchg_rec "$row(RCOUNT),"
        append convchg_rec "$row(AMT_BILLING)\n"
    
        set totals(AMTBILLING) [expr $totals(AMTBILLING) + $row(AMT_BILLING)]
        set totals(COUNT) [expr $totals(COUNT) + $row(RCOUNT)]
        incr counter
    }


    set temp_msg [format "Convenience Charge Month Ends Report contains %d record(s)" $counter]
    write_log_message $temp_msg  

    append convchg_rec "TOTALS:,,$totals(AMTBILLING),$totals(COUNT)\n"
    #set month_year [clock format [clock seconds] -format "%m%Y"]
    set month_year [string range $start_date 0 5]
    set file_name "convchg_monthend.$month_year.csv"
    set fl [open $file_name w]
  
    puts $fl $convchg_rec
    
    close $fl
    
    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "accounting@jetpay.com,reports-clearing@jetpay.com" 
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
        puts stderr "Cannot open file $mail_filename for SBC American Express settlement mail."
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
}; # end arg_parse

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

  set start_date [clock format [clock scan "$val"] -format %Y%m01]
  puts "Start date is >=  $start_date "

  set end_date [clock format [clock scan "$val +1 month"] -format %Y%m01]
  puts "End date is <  $end_date "

  set file_date [clock format [clock scan "$val"] -format %Y%m]
  puts "File date: $file_date"

  set report_month [clock format [clock scan "$val"] -format %b_%Y]
  puts " Report Month: $report_month"
};# end init_dates

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

write_log_message "START Convenience Charge Month End Report ***"
open_mail_file
write_log_message "Select Convenience Charge Month End Records ***"
do_report
write_log_message "END  Convenience Charge Month End Report ***"
close_log_file
oraclose $cursor_C
