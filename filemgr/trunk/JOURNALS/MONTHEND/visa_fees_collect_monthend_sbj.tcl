#!/usr/bin/env tclsh

################################################################################
# $Id: visa_fees_collect_monthend.tcl
################################################################################
#
# File Name:  visa_fees_collect_monthend.tcl
# Description:  This script generates the Visa month end Fees Collected Report
# Script Arguments:  institution id
# Output:  Month End Fees Collected Report
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  start & end date are calculated
#
#################################################################################

package require Oratcl

source $env(MASCLR_LIB)/mas_process_lib.tcl

global db_logon_handle_

global log_file
global log_file_name
set log_file_name "./LOG/visa_fee_collect_monthend_sbj.log"

global mail_file
set mail_filename "visa_fee_collect_monthend.mail"

######################################################################
# process Visa Fee Collection Month End Report
######################################################################
proc do_report {} {

   global env
   global argv
   global sql_date
   global month_year
   global qry
   global cursor_C
   global db_logon_visa_fee_collect
   global db_login_handle_visa_fee_collect
   global qry
   global visa_fee_collect_rec
   global month_year
   global start_date
   global end_date
   global inst_id

   set clrdb $env(IST_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_visa_fee_collect [oralogon masclr/masclr@$clrdb]} result]} {
        puts "Encountered error $result while trying to connect to the $clrdb database for visa_fee_collect Monthly query"
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_visa_fee_collect]} result]} {
        puts "Encountered error $result while trying to create visa_fee_collect database handle"
        exit
    }

    set inst_id [lindex $argv 0]
    set inst_id [string trim $inst_id]
    set counter 0

    set qry "
    SELECT SUBSTR(idm.pri_dest_inst_id,1,4) AS Inst,
           SUBSTR(idm.merch_id,1,15)          AS MerchID,
           SUBSTR(idm.merch_name,1,20)        AS MerchName,
           SUBSTR(idm.trans_dt,1,11)          AS TransDate,
           SUBSTR(idm.activity_dt,1,11)       AS SettleDate,
           SUBSTR(cs.card_scheme_name,1,10)   AS CardType,
           SUBSTR(idm.pan,1,6)||'xxxxxx'|| SUBSTR(idm.pan,13,4)  AS PAN,
           idm.arn                            AS ARN,
           idm.auth_cd                        AS AuthCode,
           idm.amt_recon/100                  AS Amount,
           SUBSTR(tid.description,1,30)       AS TranType,
           idm.forwarding_inst_id             AS BINFROM,
           idm.receiving_inst_id              AS BINTO,
           replace(idm.msg_text_block,',',' ') AS MessageText,
           idm.recon_ccd                      AS CurrencyCode
    FROM masclr.in_draft_main idm
         INNER JOIN masclr.card_scheme cs ON idm.card_scheme = cs.card_scheme
         INNER JOIN masclr.tid ON idm.tid = tid.tid
         INNER JOIN masclr.in_file_log ifl ON idm.in_file_nbr = ifl.in_file_nbr
    WHERE idm.tid BETWEEN '010103010100' AND '010103010109'
      AND idm.card_scheme = '04'
      AND idm.pri_dest_inst_id = CAST ($inst_id AS VARCHAR2(10))
      AND (ifl.incoming_dt >= to_date($start_date,'YYYYMMDDHH24MISS')
      AND ifl.incoming_dt < to_date($end_date,'YYYYMMDDHH24MISS'))
    ORDER BY idm.pri_dest_inst_id"

    global visa_fee_collect_rec
    global month_year

    set visa_fee_rec "Inst,Merch ID,Merch Name,Trans Date,Settle Date,Card Type,PAN,"
    append visa_fee_rec "ARN,Auth Code,Amount,Tran Type,Bin From,Bin To,Message Text,Currency Code\n"

    set totals(AMOUNT) 0

    orasql $cursor_C $qry
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
        ####################################
        # Add current line to report output
        ####################################
        append visa_fee_rec "$row(INST),"
        append visa_fee_rec "$row(MERCHID),"
        append visa_fee_rec "$row(MERCHNAME),"
        append visa_fee_rec "$row(TRANSDATE),"
        append visa_fee_rec "$row(SETTLEDATE),"
        append visa_fee_rec "$row(CARDTYPE),"
        append visa_fee_rec "$row(PAN),"
        append visa_fee_rec "$row(ARN),"
        append visa_fee_rec "$row(AUTHCODE),"
        append visa_fee_rec "$row(AMOUNT),"
        append visa_fee_rec "$row(TRANTYPE),"
        append visa_fee_rec "$row(BINFROM),"
        append visa_fee_rec "$row(BINTO),"
        append visa_fee_rec "MASCLR::mask_card($row(MESSAGETEXT)),"
        append visa_fee_rec "$row(CURRENCYCODE)\n"

        set totals(AMOUNT) [expr $totals(AMOUNT) + $row(AMOUNT)]

        incr counter
    }

    append visa_fee_rec "TOTALS:,,,,,,,,,$totals(AMOUNT)\n"

    set temp_msg [format "Visa Fee Collection Month Ends Report contains %d record(s)" $counter]
    write_log_message $temp_msg

    set year_month [string range $start_date 0 5]
    set file_name "Visa_Fee_Collection_$year_month.$inst_id.csv"
    set fl [open $file_name w]

    puts $fl $visa_fee_rec

    close $fl

    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "accounting@jetpay.com,reports-clearing@jetpay.com"
   # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "fcaron@jetpay.com"
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
        puts stderr "Cannot open file $mail_filename for Visa Fee Collection settlement mail."
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

#############################################
# Parse arguments if given
############################################
proc arg_parse {} {
    global date_given inst_given inst_id argv

    #scan for Date
    if  { [regexp -- {-[iI][ ]+([0-9]{3})} $argv 1 dummy inst_given] } {
        puts "Inst entered: $inst_given"
        set inst_id [string trim $inst_given]
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

write_log_message "START Visa Fee Collection Month End Report ***"
open_mail_file
write_log_message "Select Visa Fee Collection Month End Records ***"
do_report
write_log_message "END Visa Fee Collection Funding End Report ***"
close_log_file
oraclose $cursor_C
