#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
#package require Oratcl
package provide random 1.0

####################### UPDATE BELOW FOR NEW INST ###############################

set inst_id [string trim [lindex $argv 0]]

####################### CHANGES STOPS HERE ######################################


set inst_dir "INST_$inst_id"
set subroot "BASE2"
set locpth "/clearing/filemgr/$subroot/$inst_dir"

##################################################################################


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



set clrpath "/clearing/clradmin/pdir20060407/ositeroot/data"
set maspath "/clearing/masadmin/pdir20060105/ositeroot/data"


set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
#set curdate [clock format [ clock scan "-1 day" ] -format %Y%m%d]
puts "                                                            "
puts "----- NEW LOG -------------- $logdate ----------------------"
set pth "/home/rkhan/IPMFILES"
set x ""
set y ""
set xfile ""
set yfile ""
set xfsize ""
set yfsize ""
set zerobyte 0
set flder "" 
catch {set x [exec find . -name TT* | grep -v "\.\/.*/"]} result

if {$x == ""} {
	exec echo "NO T140 FILES FOUND" | mailx -r $mailfromlist -s "No T140 files found in IPM folder" $mailtolist
        exit 1
}


set i 0
set dummy ""
set dummy1 ""
set flder "101-MCDailyReports-$curdate"
exec mkdir $flder

if {[llength $x] ==  6} {
		foreach file $x {
			set ipm [string range [lindex $x $i] 2 end]
#			exec cp $ipm /clearing/filemgr/REJECTS/.
			after 200
			set rename "DT$curdate.$ipm"
		 	exec cp $ipm $rename
			exec cp $rename $flder
			puts $ipm 
			puts $rename
			file delete $ipm
			set i [expr $i + 1]
		}
                } else {
                        exec echo $x | mailx -r $mailfromlist -s "IPM report file count is not 7" $mailtolist
			exit 1
                }
exec zip -r $flder $flder
set zipflder $flder.zip
puts $zipflder


catch {exec upload.exp $zipflder >> LOG/xfermfe.log} result2

if {$result2 != ""} {
        puts $result
        set mbody "File upload to Merrick failed.\n\n $result"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
}


catch {exec email_reports.tcl $zipflder >> LOG/xfermfe.log} result1
if {$result1 != ""} {
        set mbody "Script email_reports.tcl failed"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
}

catch {exec scp $zipflder teiprod@192.168.30.69:/mnt/webdav/b/BB/447474/ >> LOG/xfermfe.log} result3

after 1000

exec rm -r $flder
exec mv $zipflder ARCHIVE/$env(SYS_BOX)-$zipflder
set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "------END OF IPM REPORT FILES-------$logdate-------------"
puts "                                                          "
