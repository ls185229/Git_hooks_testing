#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
package provide random 1.0

##################################################################################

#Environment variables.......

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


if {[file exists /clearing/filemgr/process.stop]} {
  puts "file found"
exec echo "Clearing, Please check when the file was created. Then check crontab to see which part of process created the file. Check the log files at LOG dir under that directory to find which code broke. If you cant find the problem contact Rifat ASAP. If issue resolved remove the process.stop" | mailx -r $mailfromlist -s "ATTENTION PROCESS.STOP FILE EXISTS" $mailtolist
} else {
#exec echo "process.stop file not found. We are good to go for tonight." | mailx -r clearing@jetpay.com -s "PROCESS.STOP NOT FOUND" clearing@jetpay.com assist@jetpay.com
  puts "file found"
}

