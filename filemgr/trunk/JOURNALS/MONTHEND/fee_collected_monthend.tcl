#!/usr/bin/env tclsh

################################################################################
# $Id: fees_collected_monthend.tcl 
################################################################################
#
# File Name:  fees_collected_monthend.tcl
# Description:  This script generates the monthend Fees Collected Report
# Script Arguments:  institution id
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
global db_logon_handle_fees_collect
global fees_collect_c
global run_file_date
global inst_id
global log_file
global log_file_name
global mail_file
global mail_filename

global out_file
global out_filename
global year_month
global start_date

#Global variables for file processing
global STD_OUT_CHANNEL
set STD_OUT_CHANNEL stderr

set inst_id [expr [lindex $argv 0]]
set log_file_name "./LOG/fees_collected_monthend.log"
set mail_filename "fees_collected_monthend.mail"

# global julian_file_date
set start_date [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]
set run_file_date [clock format [clock seconds] -format "%Y%m%d"]
# set julian_file_date [clock format [clock seconds] -format "%Y%j"]
set year_month [string range $start_date 0 5]

set out_filename [format "fees_collected_monthend_$year_month.$inst_id.csv"]

##################################################
#
# open_fee_file
#   Open the output file.
##################################################
proc open_fee_file {} {

    global out_filename
    global out_file
    
    if {[catch {open $out_filename a} out_file]} {
        puts stderr "Cannot open file $out_filename for building fees collected file."
        return
    }
};# end open_fee_file

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
        puts stderr "Cannot open file $mail_filename for SBC Fees Collected Month End mail."
        return
    }
};# end open_mail_file

########################################
# open_db
#   Connect to the Clearing database.
########################################
proc open_db {} {

    global clrdb
    global clr_db_logon
    global db_logon_handle_fees_collect
    global fees_collect_c
    global env

    set clrdb $env(IST_DB)   

    #
    # Open Fees Collected Month End query
    #
    if {[catch {set db_logon_handle_fees_collect [oralogon MASCLR/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for Fees Collected Month End query"
        exit
    }
    if {[catch {set fees_collect_c [oraopen $db_logon_handle_fees_collect]} result]} {
        puts "Encountered error $result while trying to create fees_collect database handle"
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
# select_fees  
#   Retrieve Fees Collected Month End records from the
#   Clearing database.
#########################################################
proc select_fees { } {

    global daily_start_time
    global run_file_date
    global fees_collect_c
    global argv
    global start_date
    global end_date
    global out_file
 
    #set end_date [clock format [clock scan $run_file_date -format "%Y%m%d"] -format "%Y%m%d"]
    #set start_date [expr $end_date - 1 month]

    write_log_message "Run Date = $run_file_date"
    write_log_message "Start = $start_date" 
    write_log_message "End = $end_date"

    set inst_id [expr [lindex $argv 0]]
    #
    # Retrieve the Fees Collected
    #
    set fees_collect_query "SELECT pl.institution_id INST_ID, ea.owner_entity_id MERCH_ID, ea.customer_name MERCH_NAME,
     trunc(pl.payment_proc_dt) Date_to_Bank,
     pl.payment_amt AMOUNT, 
     aad.amt_pay AMOUNT_PAY,
     aad.amt_fee AMOUNT_FEE, 
     aad.orig_settl_date ORIG_SETTLE_DATE, 
     pl.payment_seq_nbr PSQ_NO,
     aad.payment_status PAY_STAT, 
     pl.trans_routing_nbr ABA,
     pl.acct_nbr DDA
     FROM 
     masclr.payment_log pl
    JOIN masclr.entity_acct ea ON ea.institution_id  = pl.institution_id AND ea.entity_acct_id  = pl.entity_acct_id
    JOIN masclr.acct_accum_det aad ON aad.institution_id  = pl.institution_id and aad.payment_seq_nbr = pl.payment_seq_nbr and aad.payment_proc_dt = pl.payment_proc_dt
   WHERE 
   aad.institution_id in ('$inst_id') AND
   pl.payment_proc_dt >= to_date($start_date,'YYYYMMDDHH24MISS') AND
   pl.payment_proc_dt  < to_date($end_date,'YYYYMMDDHH24MISS')
   ORDER BY 
    pl.payment_proc_dt"

    orasql $fees_collect_c $fees_collect_query
    
};# end select_fees     

##################################################
# output_fee
#   Write all Fees Collected Month End records to the
#   settlement file.
##################################################
proc output_fee { } {

    global fees_collect_c
    global out_file year_month inst_id
    set counter 0
    global out_filename 
    set totals(AMOUNT) 0
    set totals(AMOUNT_PAY) 0
    set totals(AMOUNT_FEE) 0
    set out_filename [format "fees_collected_monthend_$year_month.$inst_id.csv"] 

    set fee_record "Inst ID,Merchant ID,Merchant Name,Date to Bank,Amount,Amount Pay,Amount Fee,Orig. Settle Date,Pmt. Seq. Nbr,Pmt. Status,ABA,DDA\n"

    while { [orafetch $fees_collect_c -dataarray fees_collect -indexbyname] != 1403 } {
        append fee_record "$fees_collect(INST_ID),"
        append fee_record "$fees_collect(MERCH_ID),"
        append fee_record "$fees_collect(MERCH_NAME),"
        append fee_record "$fees_collect(DATE_TO_BANK),"
        append fee_record "$fees_collect(AMOUNT),"
        append fee_record "$fees_collect(AMOUNT_PAY),"
        append fee_record "$fees_collect(AMOUNT_FEE),"
        append fee_record "$fees_collect(ORIG_SETTLE_DATE),"
        append fee_record "$fees_collect(PSQ_NO),"
        append fee_record "$fees_collect(PAY_STAT),"
        append fee_record "$fees_collect(ABA),"
        append fee_record "$fees_collect(DDA)"
        
        puts $out_file $fee_record
        set fee_record ""
     
        incr counter
    }

    append fee_record "TOTALS:,,,,$totals(AMOUNT),$totals(AMOUNT_PAY),$totals(AMOUNT_FEE)\n"

    puts $out_file $fee_record
 
    flush $out_file

    set temp_msg [format " Fees Collected Month End report contains %d record(s)" $counter]
    write_log_message $temp_msg
    compose_mail_msg $temp_msg

    exec echo "Please see attached." | mutt -a "$out_filename" -s "$out_filename" -- "accounting.JetPayTX@ncr.com,reports-clearing.JetPayTX@ncr.com" 
    exec mv $out_filename ./ARCHIVE

};# end output_fee  

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
    global db_logon_handle_fees_collect
    global fees_collect_c

    #
    # Close Fees Collected Month End
    #
    oraclose $fees_collect_c
    if {[catch {oralogoff $db_logon_handle_fees_collect} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection"
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
# close_fee_file
#   Close the output file.
##################################################
proc close_fee_file {} {

    global out_filename
    global out_file
    
    if {[catch {close $out_file} response]} {
        puts stderr "Cannot close file $out_filename.  Changes may not be saved to the file."
        exit 1
    }
};# end close_fee_file

############################################
# Parse arguments if given
############################################
proc arg_parse {} {
    global date_given argv

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
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

arg_parse

if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]                             
}

open_log_file
write_log_message "START Fees Collected Month End report ***"
open_mail_file
open_fee_file
open_db

write_log_message " output file name will be $out_filename"
compose_mail_msg "Output filename is $out_filename"

write_log_message " Select Fees Collected Month End report"
select_fees  
output_fee 

close_db
close_fee_file
close_mail_file
write_log_message "END Fees Collected Month End report   ***"
close_log_file

exit 0
