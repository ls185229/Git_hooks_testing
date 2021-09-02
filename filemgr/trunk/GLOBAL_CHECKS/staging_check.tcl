#!/usr/bin/env tclsh
# Script to pull the TSYS CDF file apart
# At present only pulls the merchant header record for
# research for boarding and clearing

# $Id: staging_check.tcl 3420 2015-09-11 20:05:17Z bjones $

# Version 0.0 01/23/12 Joe Cloud

# Strip leading zeros off of numbers, so that they are not
# interpredted to be OCTAL

#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
set authdb $env(ATH_DB)

set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(IST_DB)

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


set UNIQUE_ID_COUNTER 1
set Settle_date [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set sqldate [string toupper [clock format [clock scan "-0 day"] -format "%d-%b-%y"]]
puts "settle date:$Settle_date"

set tcl_precision 17
set Email_body " "

package require Oratcl

set db_logon_handle ""
set Visa_ID ""

proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct

proc connect_to_db {} {
    global db_logon_handle mas_logon_handle
    global authuser authpwd authdb clruser clrpwd clrdb 

                if {[catch {set db_logon_handle [oralogon $authuser/$authpwd@$authdb]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }

                if {[catch {set mas_logon_handle [oralogon $clruser/$clrpwd@$clrdb]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }
};# end connect_to_db




connect_to_db
set auth_sql [oraopen $db_logon_handle]
set second_auth_sql [oraopen $db_logon_handle]
set clearing_sql [oraopen $mas_logon_handle]
set second_clearing_sql [oraopen $mas_logon_handle]

set i 0

set error_flag 0
set body "Staging Tables are not clear.  Contact on call engineer."
set Tranhistory_Query_sql "Select * from capture_Staging"
orasql $second_auth_sql $Tranhistory_Query_sql
if {[orafetch $second_auth_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
    set error_flag 1
}
if {$error_flag == 1} {
  exec echo $body | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}

oracommit $db_logon_handle

exit 0
