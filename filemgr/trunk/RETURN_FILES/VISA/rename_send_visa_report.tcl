#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
#package require Oratcl
package provide random 1.0


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


set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

set jdate [ clock scan $curdate  -base [clock seconds] ]
#puts $jdate
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]

#set curdate [clock format [ clock scan "-1 day" ] -format %Y-%m-%d]
puts "                                                            "
puts "----- NEW LOG -------------- $logdate ----------------------"
set pth "/home/rkhan/IPMFILES"
set x ""
set y ""
set ctf ""
set x7 ""

catch {set x [exec find . -name INCTF*]} result

if {$x == ""} {
        exec echo "NO VISA CTF FILES FOUND" | mailx -r clearing@jetpay.com -s "No Visa report files found in visa report folder" clearing@jetpay.com assist@jetpay.com
#clearing@jetpay.com assist@jetpay.com
        exit 1
}

if {[llength $x] >= 2} {
        exec echo "MULTIPLE VISA CTF FILES FOUND" | mailx -r clearing@jetpay.com -s "Mulitple files found in windows incoming/CTF folder \n $x" clearing@jetpay.com assist@jetpay.com 
#clearing@jetpay.com assist@jetpay.com
        exit 1
}
puts $x

foreach ctf $x {
	set ctf [string range $ctf 2 end]
	set x7 [string range $ctf 2 6]
	set seq "[format %03s [string range $ctf 5 6]]"
			set rename "INVS.$box$x7.$jdate.$seq"
			set rename1 "$box-$rename"
			exec cp $ctf $rename 
                        exec cp $ctf $rename1
                        exec mv $rename1 ARCHIVE
			exec chmod 775 $rename
		if {$seq == "001"} {
			exec cp -p $rename $env(CLR_OSITE_DATA)/in/base2
		}
			puts $ctf 
			puts $rename
			puts $rename1
			exec rm $ctf

}
set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "------END OF IPM REPORT FILES-------$logdate-------------"
puts "                                                          "
