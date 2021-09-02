#!/usr/bin/env tclsh
# This script compares today's totals broken down by institution and card type to the previous
# three weeks.  Example  Compares this weeks friday versus , a week ago friday, two weeks ago friday....
# The email alert will only be generated is percent difference is greater than the percentage in the diff file.

# $Id: daily_inst_check.tcl 3819 2016-07-05 16:54:54Z skumar $

# USAGE weekly_inst_check.tcl
# Version 1.0 9/7/2012 Myke Sanders

# GLOBAL VARIABLES

set Settle_date [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set sqldate [string toupper [clock format [clock scan "-0 day"] -format "%d-%b-%y"]]
puts "settle date:$Settle_date"

set tcl_precision 17
set Email_flag 0

set clr_date_j [clock format [clock scan "-0 day"] -format %y%j ]
set tc57_date [string range $clr_date_j 1 4]


package require Oratcl



#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################

#################################
# readCfgFile
#  read configs files
#################################


proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global percentage


   set cfg_file_name cutoff_batch.cfg

   set clr_db_logon ""
   set clr_db ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "PERCENTAGE" {
            set percentage [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 2
   }
}


#######################################################################################################################

#################################
# connect_to_db
#  handles connections to the database
#################################

proc connect_to_db {} {
    global mas_logon_handle
   global clr_db_logon
   global clr_db


                if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "Connected to MAS"
                }

};# end connect_to_db


###############################MAIN#####################################

readCfgFile
connect_to_db

set clearing_sql [oraopen $mas_logon_handle]
set second_clearing_sql [oraopen $mas_logon_handle]

set TodayCutoffBatchQuery "select
		sum(cutoff_amt)/100 as amount,
		sum(cutoff_cnt) as count,
		dest_file_type,
		src_inst_id
	from
		masclr.cutoff_batch
	where
		clr_date_j = '$clr_date_j' and
		dest_file_type = '21'
	group by
		dest_file_type,
		src_inst_id
	order by
		src_inst_id"

#puts $TodayCutoffBatchQuery
set body "File Type 41 is Visa\r\n"
append body "File Type 55 is Mastercard\r\n"
append body "File Type 81 and 83 are Discover\r\n"
append body "File Type 21 is the total\r\n"
append body "\r\n"
append body "This report will display anything with a difference of [expr $percentage * 100]%\r\n"
append body "INST		FILE TYPE	PERCENT DIFF	TODAY		AVERAGE		\r\n"

orasql $clearing_sql $TodayCutoffBatchQuery
while {[orafetch $clearing_sql -dataarray TodayCutoffBatchQueryResult -indexbyname] != 1403  } {
   set inst_id $TodayCutoffBatchQueryResult(SRC_INST_ID)
   set file_type $TodayCutoffBatchQueryResult(DEST_FILE_TYPE)

#in the following query, it pulls three days and the divides by three to come up with an average.  The 300 is to convert to dollars and take an average.
   if {$file_type == 21} {
     set AverageCutoffBatchQuery "select
		sum(file_amt) as amount,
		sum(file_cnt) as count
	from
		masclr.mas_file_log
	where
		Institution_id = '$inst_id' and
		file_name like '$inst_id.CLEARING.01.$tc57_date%1'"
     #puts $AverageCutoffBatchQuery
     orasql $second_clearing_sql $AverageCutoffBatchQuery
     if {[orafetch $second_clearing_sql -dataarray AverageCutoffBatchQueryResult -indexbyname] != 1403  && $AverageCutoffBatchQueryResult(AMOUNT) > 0} {
       set PercentDifference [expr $TodayCutoffBatchQueryResult(AMOUNT) / $AverageCutoffBatchQueryResult(AMOUNT) ]
       if {$PercentDifference < .99 || $PercentDifference > 1.01 } {
         if {$AverageCutoffBatchQueryResult(AMOUNT) != 0 } {
           puts "$inst_id:$file_type:$TodayCutoffBatchQueryResult(AMOUNT)/$AverageCutoffBatchQueryResult(AMOUNT) = $PercentDifference"
           set body "$body\r\n $inst_id     	MAS	      [expr [expr round ([expr 100 * $PercentDifference])] - 100]%			$TodayCutoffBatchQueryResult(AMOUNT)        [expr round($AverageCutoffBatchQueryResult(AMOUNT))]"
           set Email_flag 1
         }
       }
     }
   }

}

set body $body$mbody_h
if {$Email_flag == 1} {
  exec echo $body | mailx -r clearing@jetpay.com -s "$msubj_h" clearing@jetpay.com assist@jetpay.com senjeti@jetpay.com
  #exec echo $body | mailx -r clearing@jetpay.com -s "$msubj_h" clearing@jetpay.com
}

exit 0
