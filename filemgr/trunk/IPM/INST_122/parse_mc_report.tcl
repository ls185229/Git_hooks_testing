#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: parse_mc_report.tcl 4573 2018-05-18 20:43:39Z bjones $
# $Rev: 4573 $
################################################################################
#
# File Name:  parse_mc_report.tcl
#
# Description:  This program parses the incoming IPM reports by institution.
#              
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl


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

set mbody_c "ASSIST :: \n Contact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \n Contact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \n Inform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \n Inform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \n Assign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: /clearing/filemgr/IPM/INST_101 \n\n"


proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array


catch {set x [exec find . -name TT*]} result

if {$x == ""} {
        set mbody "REPORTS NOT FOUND.\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
}

set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
#set curdate [clock format [ clock scan "-1 day" ] -format %Y%m%d]



foreach infile $x {
set input [open $infile r]
set i 1
set chk2 0
set brk 1
set chk4 6
set prnt 1
set oprt 1
set skp 1


while {! [eof $input]} {


set cur_line(0) [set orig_line [gets $input]]
set cr_line  [split $orig_line \ ]
set chk1 "[lindex $cr_line 43] [lindex $cr_line 44]"
#puts $cur_line(0)
if {$oprt == 0 && $chk1 != "MASTERCARD WORLDWIDE"} {
    exec echo $cur_line(0) >> "$infile-test"
}
if {$chk1 == "MASTERCARD WORLDWIDE"} {
set i 1 
	while {$chk4 >= $i} {
		set cur_line($i) [set orig_line [gets $input]]
		set chk [string range [string trim $cur_line($i)] 0 21]
		set errdt [string range [string trim $cur_line($i)] 0 11]
		puts $chk
		if {$errdt == "ERROR DETAIL" && $skp == 0} {
                        exec echo $cur_line(0) >> "$infile-test"
			exec echo $cur_line(1) >> "$infile-test"
			set oprt 0
			set prnt 1
			break
		}
		switch $chk {
			"MEMBER ID: 00000004013"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			"MEMBER ID: 00000010279"	{set i [expr $i + 1]; set prnt 0; set oprt 0; set skp 0; break}
			"MEMBER ID: 00000008183"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			"MEMBER ID: 00000006919"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			"MEMBER ID: 00000004485"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			"MEMBER ID: 00000014755"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			default {#puts ">>>$chk<<<<"; #puts "$i <> $prnt <> $oprt <> $skp"; set prnt 1; set oprt 1; set skp 1}
		}
		 set i [expr $i + 1]
	}

if {$prnt == 0} {
if {$i == 1} {
exec echo $cur_line(0) >> "$infile-test"
} elseif {$i == 2} {
exec echo $cur_line(0) >> "$infile-test"
exec echo $cur_line(1) >> "$infile-test"
} elseif {$i == 3} {
exec echo $cur_line(0) >> "$infile-test"
exec echo $cur_line(1) >> "$infile-test"
exec echo $cur_line(2) >> "$infile-test"
} elseif {$i == 4} {
exec echo $cur_line(0) >> "$infile-test"
exec echo $cur_line(1) >> "$infile-test"
exec echo $cur_line(2) >> "$infile-test"
exec echo $cur_line(3) >> "$infile-test"
} elseif {$i == 5} {
exec echo $cur_line(0) >> "$infile-test"
exec echo $cur_line(1) >> "$infile-test"
exec echo $cur_line(2) >> "$infile-test"
exec echo $cur_line(3) >> "$infile-test"
exec echo $cur_line(4) >> "$infile-test"
} elseif {$i == 6} {
exec echo $cur_line(0) >> "$infile-test"
exec echo $cur_line(1) >> "$infile-test"
exec echo $cur_line(2) >> "$infile-test"
exec echo $cur_line(3) >> "$infile-test"
exec echo $cur_line(4) >> "$infile-test"
exec echo $cur_line(5) >> "$infile-test"
}
set prnt 1
}
}
}
#set org "orig-[string range $infile 2 end]-$curdate"
#exec cp $infile $org
exec mv $infile-test $infile

}


