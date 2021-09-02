#!/usr/bin/env tclsh

################################################################################
# $Id: Esquire_monthend.tcl 
################################################################################
#
# File Name:  esquire_monthend.tcl
# Description:  This script generates the monthend Esquire Report
# Script Arguments:  institution id
# Output:  Esquire Month End Report
# Return:   0 = Success
#          !0 = Exit with errors
# Notes:  start & end date are calculated
#
#################################################################################
package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib
global db_logon_handle_esquire
global log_file
global log_file_name
set log_file_name "./LOG/esquire_monthend.log"

global mail_file
set mail_filename "esquire_monthend.mail"
######################################################################
# process Esquire Month End Report
######################################################################
proc do_report {} {

   global env
   global argv
   global sql_date
   global month_year
   global is_sales_tids
   global is_return_tids
   global is_dispute_tids
   global dt_start
   global dt_end
   global inst_id
   global qry
   global cursor_C
   global db_logon_esquire
   global db_login_handle_esquire
   global qry
   global esquire_rec
   global month_year

   set clrdb $env(IST_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_esquire [oralogon masclr/masclr@$clrdb]} result]} {
        puts "Encountered error $result while trying to connect to the $clrdb database for Esquire Monthly query" 
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_esquire]} result]} {
        puts "Encountered error $result while trying to create Esquire database handle"
        exit
    }

    set counter 0

    set inst_id [expr [lindex $argv 0 ]]
    
   set qry "SELECT '8847' AS Bank, 
   mtl.ENTITY_ID AS EntityID, 
   ae.ENTITY_DBA_NAME AS EntityDBAName,
   ae.ENTITY_NAME AS EntityName, 
   ae.DEFAULT_MCC AS MCC,
   SUM(CASE WHEN tid in ('010003005101', '010003005103', '010003005104', '010003005105', '010003005106', '010003005107', '010003005109', '010003005121', 
                        '010003005141', '010003005142', '010008000001', '010008000102', '010103005101', '010103005102', '010103005103', '010103005104', 
                        '010103005105', '010103005106', '010103005107', '010103005108', '010103005109') AND mtl.CARD_SCHEME = '04' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS VisaSalesAmount,                  
   SUM(CASE WHEN tid in ('010003005101', '010003005103', '010003005104', '010003005105', '010003005106', '010003005107', '010003005109', '010003005121', 
                        '010003005141', '010003005142', '010008000001', '010008000102', '010103005101', '010103005102', '010103005103', '010103005104', 
                        '010103005105', '010103005106', '010103005107', '010103005108', '010103005109') AND mtl.CARD_SCHEME = '04'
            THEN 1 ELSE 0 END) AS VisaSalesCount,                    
   SUM(CASE WHEN tid in ('010003005102', '010003005108', '010003005143', '010003005144', '010003005201', '010003005202', '010003005203', '010003005204', 
                        '010003005205', '010003005207', '010003005208', '010003005209', '010003005221', '010008000002', '010008000101', '010123005101', 
                        '010123005102', '010123005103', '010123005104', '010123005105', '010123005106', '010123005107', '010123005108', '010123005109', 
                        '010123005121') AND mtl.CARD_SCHEME = '04' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS VisaReturnsAmount,                    
   SUM(CASE WHEN tid IN ('010003005102', '010003005108', '010003005143', '010003005144', '010003005201', '010003005202', '010003005203', '010003005204', 
                        '010003005205', '010003005207', '010003005208', '010003005209', '010003005221', '010008000002', '010008000101', '010123005101', 
                        '010123005102', '010123005103', '010123005104', '010123005105', '010123005106', '010123005107', '010123005108', '010123005109', 
                        '010123005121') AND mtl.CARD_SCHEME = '04' 
            THEN 1 ELSE  0 END) AS VisaReturnsCount,
   SUM(CASE WHEN tid IN ('010003005101', '010003005103', '010003005104', '010003005105', '010003005106', '010003005107', '010003005109', '010003005121', 
                '010003005141', '010003005142', '010008000001', '010008000102', '010103005101', '010103005102', '010103005103', '010103005104', 
                '010103005105', '010103005106', '010103005107', '010103005108', '010103005109') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS MCSalesAmount,                    
   SUM(CASE WHEN tid IN ('010003005101', '010003005103', '010003005104', '010003005105', '010003005106', '010003005107', '010003005109', '010003005121', 
                        '010003005141', '010003005142', '010008000001', '010008000102', '010103005101', '010103005102', '010103005103', '010103005104', 
                        '010103005105', '010103005106', '010103005107', '010103005108', '010103005109') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE 0 END) AS MCSalesCount,                    
   SUM(CASE WHEN tid IN ('010003005102', '010003005108', '010003005143', '010003005144', '010003005201', '010003005202', '010003005203', '010003005204', 
                        '010003005205', '010003005207', '010003005208', '010003005209', '010003005221', '010008000002', '010008000101', '010123005101', 
                        '010123005102', '010123005103', '010123005104', '010123005105', '010123005106', '010123005107', '010123005108', '010123005109', 
                        '010123005121') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS MCReturnsAmount,                    
   SUM(CASE WHEN tid IN ('010003005102', '010003005108', '010003005143', '010003005144', '010003005201', '010003005202', '010003005203', '010003005204', 
                        '010003005205', '010003005207', '010003005208', '010003005209', '010003005221', '010008000002', '010008000101', '010123005101', 
                        '010123005102', '010123005103', '010123005104', '010123005105', '010123005106', '010123005107', '010123005108', '010123005109', 
                        '010123005121') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE  0 END) AS MCReturnsCount,
   SUM(CASE WHEN mtl.CARD_SCHEME = '05' AND UPPER(mc.MAS_DESC) LIKE '%INTL%' AND tid in ('010003005101', '010003005103', '010003005104', '010003005105', 
                        '010003005106', '010003005107', '010003005109', '010003005121', '010003005141', '010003005142', '010008000001', '010008000102', 
                        '010103005101', '010103005102', '010103005103', '010103005104', '010103005105', '010103005106', '010103005107', '010103005108', 
                        '010103005109') 
            THEN CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE 0 END * AMT_ORIGINAL END) AS MCIntSales,
   SUM(CASE WHEN mtl.CARD_SCHEME = '05' AND UPPER(mc.MAS_DESC) LIKE '%INTL%' AND tid IN ('010003005102', '010003005108', '010003005143', '010003005144', 
                        '010003005201', '010003005202', '010003005203', '010003005204', '010003005205', '010003005207', '010003005208', '010003005209', 
                       '010003005221', '010008000002', '010008000101', '010123005101', '010123005102', '010123005103', '010123005104', '010123005105', 
                       '010123005106', '010123005107', '010123005108', '010123005109', '010123005121') 
            THEN CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE 0 END * AMT_ORIGINAL END)   AS MCIntReturns,
   SUM(CASE WHEN mtl.CARD_SCHEME = '05' AND UPPER(mc.MAS_DESC) LIKE '%INTL%' AND tid IN ('010003005101', '010003005103', '010003005104', '010003005105', 
                      '010003005106', '010003005107', '010003005109', '010003005121', '010003005141', '010003005142', '010008000001', '010008000102', 
                      '010103005101', '010103005102', '010103005103', '010103005104', '010103005105', '010103005106', '010103005107', '010103005108', '010103005109') 
            THEN mtl.NBR_OF_ITEMS END) AS MCIntSalesCount,
    SUM(CASE WHEN mtl.CARD_SCHEME = '05' AND UPPER(mc.MAS_DESC) LIKE '%INTL%' AND tid IN ('010003005102', '010003005108', '010003005143', '010003005144', '010003005201', 
                      '010003005202', '010003005203', '010003005204', '010003005205', '010003005207', '010003005208', '010003005209', '010003005221', 
                      '010008000002', '010008000101', '010123005101', '010123005102', '010123005103', '010123005104', '010123005105', '010123005106', 
                      '010123005107', '010123005108', '010123005109', '010123005121')  
            THEN mtl.NBR_OF_ITEMS END) AS MCIntReturnsCount,
   SUM(CASE WHEN tid IN ('010003005301', '010003005401', '010003005402', '010003010101', '010003010102', '010003015101', '010003015102', '010003015106', 
                        '010003015201', '010003015202', '010003015210', '010003015301', '010008010001', '010008010101', '010008010101') AND mtl.CARD_SCHEME = '04' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS VisaDisputesAmount,                    
   SUM(CASE WHEN tid IN ('010003005301', '010003005401', '010003005402', '010003010101', '010003010102', '010003015101', '010003015102', '010003015106', 
                        '010003015201', '010003015202', '010003015210', '010003015301', '010008010001', '010008010101', '010008010101') AND mtl.CARD_SCHEME = '04' 
            THEN 1 ELSE  0 END) AS VisaDisputesCount,
   SUM(CASE WHEN tid IN ('010003005301', '010003005401', '010003005402', '010003010101', '010003010102', '010003015101', '010003015102', '010003015106', 
                        '010003015201', '010003015202', '010003015210', '010003015301', '010008010001', '010008010101', '010008010101') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE  0 END * CASE WHEN mtl.TID_SETTL_METHOD = 'C' THEN 1 ELSE -1 END * mtl.AMT_ORIGINAL) AS MCDisputesAmount,                    
   SUM(CASE WHEN tid IN ('010003005301', '010003005401', '010003005402', '010003010101', '010003010102', '010003015101', '010003015102', '010003015106', 
                        '010003015201', '010003015202', '010003015210', '010003015301', '010008010001', '010008010101', '010008010101') AND mtl.CARD_SCHEME = '05' 
            THEN 1 ELSE  0 END) AS MCDisputesCount   
   FROM 
       masclr.MAS_TRANS_LOG mtl
       JOIN masclr.MAS_CODE mc ON (mtl.mAS_code = mc.mAS_code AND mtl.card_scheme = mc.card_scheme)                                           
       JOIN masclr.ACQ_ENTITY ae ON ( mtl.INSTITUTION_ID = ae.INSTITUTION_ID AND mtl.ENTITY_ID = ae.ENTITY_ID)
    WHERE
        mtl.TID like '010003%' AND
        mtl.card_scheme in ('04', '05') AND
        mtl.gl_date >= to_date($start_date,'YYYYMMDD') AND      
        mtl.gl_date <  to_date($end_date,'YYYYMMDD') AND
        mtl.SETTL_FLAG = 'Y' AND
        mtl.INSTITUTION_ID = $inst_id
    GROUP BY
        mtl.ENTITY_ID, 
        ae.ENTITY_DBA_NAME, 
        ae.ENTITY_NAME, 
        ae.DEFAULT_MCC
    ORDER BY 
        mtl.ENTITY_ID"

    global esquire_rec
    global month_year

    set esquire_rec "Bank,Entity ID,Entity DBA Name,Entity Name,MCC,Visa Sales Amount,Visa Sales Count,Visa Returns Amount,"
    append esquire_rec "Visa Returns Count,MC Sales Amount,MC Sales Count,MC Returns Amount,MC Returns Count,MC Int. Sales,"
    append esquire_rec "MC Int. Returns,MC Int. Sales Count,MC Int. Returns Count,Visa Disputes Amount,Visa Disputes Count,"
    append esquire_rec "MC Disputes Amount,MC Disputes Count\n"  

    set totals(TOTVISASALESAMOUNT) 0
    set totals(TOTVISASALESCOUNT) 0
    set totals(TOTVISARETURNSAMOUNT) 0
    set totals(TOTVISARETURNSCOUNT) 0
    set totals(TOTMCSALESAMOUNT) 0
    set totals(TOTMCSALESCOUNT) 0
    set totals(TOTMCRETURNSAMOUNT) 0
    set totals(TOTMCRETURNSCOUNT) 0
    set totals(TOTMCINTSALES) 0  
    set totals(TOTMCINTRETURNS) 0
    set totals(TOTMCINTSALESCOUNT) 0
    set totals(TOTMCINTRETURNSCOUNT) 0
    set totals(TOTVISADISPUTESAMOUNT) 0
    set totals(TOTVISADISPUTESCOUNT) 0
    set totals(TOTMCDISPUTESAMOUNT) 0
    set totals(TOTMCDISPUTESCOUNT) 0

    orasql $cursor_C $qry 
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
	####################################
        # Add current line to report output
        ####################################
        append esquire_rec "$row(BANK)," 
        #append esquire_rec {="} "$row(ENTITYID)" {",}  
        append esquire_rec "'$row(ENTITYID),"
        append esquire_rec "$row(ENTITYDBANAME),"
        append esquire_rec "$row(ENTITYNAME),"
        append esquire_rec "$row(MCC),"
        append esquire_rec "$row(VISASALESAMOUNT),"
        append esquire_rec "$row(VISASALESCOUNT),"
        append esquire_rec "$row(VISARETURNSAMOUNT),"
        append esquire_rec "$row(VISARETURNSCOUNT),"
        append esquire_rec "$row(MCSALESAMOUNT),"
        append esquire_rec "$row(MCSALESCOUNT),"
        append esquire_rec "$row(MCRETURNSAMOUNT),"
        append esquire_rec "$row(MCRETURNSCOUNT),"
        append esquire_rec "$row(MCINTSALES),"
        append esquire_rec "$row(MCINTRETURNS),"
        append esquire_rec "$row(MCINTSALESCOUNT),"
        append esquire_rec "$row(MCINTRETURNSCOUNT),"
        append esquire_rec "$row(VISADISPUTESAMOUNT),"
        append esquire_rec "$row(VISADISPUTESCOUNT),"
        append esquire_rec "$row(MCDISPUTESAMOUNT),"
        append esquire_rec "$row(MCDISPUTESCOUNT)\n" 
    
        set totals(TOTVISASALESAMOUNT) [expr $totals(TOTVISASALESAMOUNT) + $row(VISASALESAMOUNT)]
        set totals(TOTVISASALESCOUNT) [expr $totals(TOTVISASALESCOUNT) + $row(VISASALESCOUNT)]
        set totals(TOTVISARETURNSAMOUNT) [expr $totals(TOTVISARETURNSAMOUNT) + $row(VISARETURNSAMOUNT)]
        set totals(TOTVISARETURNSCOUNT) [expr $totals(TOTVISARETURNSCOUNT) + $row(VISARETURNSCOUNT)]
        set totals(TOTMCSALESAMOUNT) [expr $totals(TOTMCSALESAMOUNT) + $row(MCSALESAMOUNT)]
        set totals(TOTMCSALESCOUNT) [expr $totals(TOTMCSALESCOUNT) + $row(MCSALESCOUNT)]
        set totals(TOTMCRETURNSAMOUNT) [expr $totals(TOTMCRETURNSAMOUNT) + $row(MCRETURNSAMOUNT)]
        set totals(TOTMCRETURNSCOUNT) [expr $totals(TOTMCRETURNSCOUNT) + $row(MCRETURNSCOUNT)]
        set totals(TOTMCINTSALES) [expr $totals(TOTMCINTSALES) + $row(MCINTSALES)]
        set totals(TOTMCINTRETURNS) [expr $totals(TOTMCINTRETURNS) + $row(MCINTRETURNS)]
        set totals(TOTMCINTSALESCOUNT) [expr $totals(TOTMCINTSALESCOUNT) + $row(MCINTSALESCOUNT)]
        set totals(TOTMCINTRETURNSCOUNT) [expr $totals(TOTMCINTRETURNSCOUNT) + $row(MCINTRETURNSCOUNT)]
        set totals(TOTVISADISPUTESAMOUNT) [expr $totals(TOTVISADISPUTESAMOUNT) + $row(VISADISPUTESAMOUNT)]
        set totals(TOTVISADISPUTESCOUNT) [expr $totals(TOTVISADISPUTESCOUNT) + $row(VISADISPUTESCOUNT)]
        set totals(TOTMCDISPUTESAMOUNT) [expr $totals(TOTMCDISPUTESCOUNT) + $row(MCDISPUTESCOUNT)]
        set totals(TOTMCDISPUTESCOUNT) [expr $totals(TOTMCDISPUTESCOUNT) + $row(MCDISPUTESCOUNT)]

        incr counter
    }

    append esquire_rec "TOTALS:,,,,,$totals(TOTVISASALESAMOUNT),$totals(TOTVISASALESCOUNT),$totals(TOTVISARETURNSAMOUNT),$totals(TOTVISARETURNSCOUNT),"
    append esquire_rec "$totals(TOTMCSALESAMOUNT),$totals(TOTMCSALESCOUNT),$totals(TOTMCRETURNSAMOUNT),$totals(TOTMCRETURNSCOUNT),$totals(TOTMCINTSALES),"
    append esquire_rec "$totals(TOTMCINTRETURNS),$totals(TOTMCINTSALESCOUNT),$totals(TOTMCINTRETURNSCOUNT),$totals(TOTVISADISPUTESAMOUNT),$totals(TOTVISADISPUTESCOUNT),"
    append esquire_rec "$totals(TOTMCDISPUTESAMOUNT),$totals(TOTMCDISPUTESCOUNT)\n"

    set temp_msg [format "Esquire Month End Report contains %d record(s)" $counter]
    write_log_message $temp_msg  

    set year_month [clock format [clock seconds] -format "%Y%m"]
    set file_name "Esquire_Monthly_Report_$year_month_$inst_id.csv"
    set fl [open $file_name w]
  
    puts $fl $esquire_rec
    
    close $fl
    
    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" "accounting@jetpay.com,reports-clearing@jetpay.com" 
	 MASCLR::mutt_send_mail "fcaron@jetpay.com"  "$file_name" "Please see attached." "$file_name"
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

proc arg_parse {} 
{
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

open_log_file

write_log_message "START Esquire Month End Report ***"
open_mail_file
write_log_message "Select Esquire Month End Records ***"
do_report
write_log_message "END Esquire Month End Report ***"
close_log_file
oraclose $cursor_C
