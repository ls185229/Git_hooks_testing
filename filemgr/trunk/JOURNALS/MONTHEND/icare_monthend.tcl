#!/usr/bin/env tclsh

################################################################################
# $Id: icare_monthend.tcl 
################################################################################
#
# File Name:  icare_monthend.tcl
# Description:  This script generates the iCare month end Report
# Script Arguments:  
# Output:  iCare month end Report
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  start & end date are calculated
#
#################################################################################

package require Oratcl

global db_logon_handle_

global log_file
global log_file_name
set log_file_name "./LOG/icare_monthend.log"

global mail_file
set mail_filename "icare_monthend.mail"

######################################################################
# process iCare Month End Report
######################################################################
proc do_report {} {
   global env
   global argv
   global sql_date
   global month_year
   global qry
   global cursor_C
   global db_logon_icare
   global db_login_handle_icare
   global qry
   global icare_rec
   global month_year
   global start_date
   global end_date
   global inst_id

   set clrdb $env(IST_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_icare [oralogon masclr/masclr@$clrdb]} result]} {
        puts "Encountered error $result while trying to connect to the $clrdb database for icare Monthly query" 
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_icare]} result]} {
        puts "Encountered error $result while trying to create icare database handle"
        exit
    }

    set counter 0
 
    set qry "SELECT   
                mtl.institution_id            AS INST,  
                mtl.gl_date                   AS gl_date,
                substr(mtl.entity_id, 1, 11)  AS bin_plus,   
                mtl.entity_id                 AS nbr_merchants,   
                mtl.tid                       AS TID,
                mtl.tid_settl_method          AS DB_CR,   
                mtl.amt_original              AS original, 
                t.description                 AS description   
            FROM 
                masclr.mas_trans_log mtl   
                JOIN masclr.tid t ON mtl.tid = t.tid WHERE(( MTL.INSTITUTION_ID = '105' and MTL.ENTITY_ID like '402529_2166%') OR       
                    (MTL.INSTITUTION_ID = '107' AND MTL.ENTITY_ID LIKE '454045_2166%')) AND 
                    (mtl.gl_date >= TO_DATE('20150301000000','YYYYMMDDHH24MISS') AND mtl.gl_date < TO_DATE('20150401000000','YYYYMMDDHH24MISS')) AND 
                mtl.tid LIKE '010004%'   
            ORDER BY 
                mtl.institution_id, substr(mtl.entity_id, 1, 11), mtl.gl_date, mtl.tid"

    global icare_rec
    global month_year

    set icare_rec "Inst,GL Date,Bin Plus,Merchant Nbr,TID,DB/CR,Original Description"

    set totals(AMOUNT) 0

    orasql $cursor_C $qry 
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
        ####################################
        # Add current line to report output
        ####################################
        append icare_rec "$row(INST)," 
        append icare_rec "$row(GL_DATE)," 
        append icare_rec "$row(BIN_PLUS),"
        append icare_rec "$row(NBR_MERCHANTS),"
        append icare_rec "$row(TID),"
        append icare_rec "$row(DB_CR),"
        append icare_rec "$row(ORIGINAL),"
        append icare_rec "$row(DESCRIPTION)\n"
   
        set totals(AMOUNT) [expr $totals(AMOUNT) + $row(ORIGINAL)]

        incr counter
    }

    append icare_rec "TOTALS:,,,,,,,,,$totals(AMOUNT)\n"

    set temp_msg [format "ICARE Month Ends Report contains %d record(s)" $counter]
    write_log_message $temp_msg  

    set year_month [string range $start_date 0 5]
    set file_name "icare_monthend_$year_month.csv"
    set fl [open $file_name w]
  
    puts $fl $icare_rec
    
    close $fl
    
    #exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "accounting@jetpay.com,reports-clearing@jetpay.com" 
    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "fcaron@jetpay.com" 
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
        puts stderr "Cannot open file $mail_filename for ICARE  settlement mail."
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
if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]                             
}

open_log_file

write_log_message "START ICARE Month End Report ***"
open_mail_file
write_log_message "Select ICARE Month End Records ***"
do_report
write_log_message "END ICARE Funding End Report ***"
close_log_file
oraclose $cursor_C
