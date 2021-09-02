#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


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

set mbody_c "ASSIST :: \n Contact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \n Contact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \n Inform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \n Inform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \n Assign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: /clearing/filemgr/IPM/INST_101 \n\n"

#######################################################################################################################

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
set inst_id [lindex $argv 0]

set ind_on_105 1
set ind_on_101 1
set ind_on_107 1
set ind_on_108 1

switch $inst_id {
        "101"   {
			set ind_on_$inst_id 0
                }
        "107"   {
                        set ind_on_$inst_id 0
                }
        "105"   {
                        set ind_on_$inst_id 0
                }
        "108"   {
                        set ind_on_$inst_id 0
                }
        default {puts "Invalid $inst_id institution id"; exit 1}
}


foreach infile $x {
set input [open $infile r]
set i 1
set chk2 0
set brk 1
set chk4 6
set prnt 1
set oprt 1
set skp 1
set replacepan "N"

while {! [eof $input]} {


set cur_line(0) [set orig_line [gets $input]]
set cr_line  [split $orig_line \ ]
set chk1 "[lindex $cr_line 43] [lindex $cr_line 44]"
set chkfpan "[lindex $cr_line 0]"
set chkpan "[lindex $cr_line 17]"
if {$chkpan == "D0002"} {
set cur_line(0) "[string range $cur_line(0) 0 34]XXXXXXXX[string range $cur_line(0) 43 end]" 
set chkpan ""
}
if {$chkfpan == "1IP142110-AA"} {
set replacepan "Y"
} elseif {[string trim $cur_line(0)] == "NO DATA TO REPORT"} {
set replacepan "N"
} else {
set replacepan $replacepan
}

if {$replacepan == "Y"} {
	set fpan "[string trim [string range $cur_line(0) 111 end]]"
	if {$fpan > "300000000" && [string is digit $fpan]} {
		set cur_line(0) "[string range $cur_line(0) 0 114]XXXXXXXX[string range $cur_line(0) 123 end]"
	} else {
		set cur_line(0) $cur_line(0)
	}
}

if {$oprt == 0 && $chk1 != "MASTERCARD WORLDWIDE"} {
    exec echo $cur_line(0) >> "$infile-test"
}
if {$chk1 == "MASTERCARD WORLDWIDE"} {
set i 1 
	while {$chk4 >= $i} {
		set cur_line($i) [set orig_line [gets $input]]
		set chk [string range [string trim $cur_line($i)] 0 21]
		set errdt [string range [string trim $cur_line($i)] 0 11]
		if {$errdt == "ERROR DETAIL" && $skp == 0} {
			exec echo $cur_line(0) >> "$infile-test"
			exec echo $cur_line(1) >> "$infile-test"
			set oprt 0
			set prnt 1
			break
		}
		switch $chk {
			"MEMBER ID: 00000004013"	{set i [expr $i + 1]; set prnt $ind_on_101; set oprt $ind_on_101; set skp $ind_on_101; break}
			"MEMBER ID: 00000010279"	{set i [expr $i + 1]; set prnt $ind_on_107; set oprt $ind_on_107; set skp $ind_on_107; break}
			"MEMBER ID: 00000008183"	{set i [expr $i + 1]; set prnt 1; set oprt 1; set skp 1; break}
			"MEMBER ID: 00000005165"	{set i [expr $i + 1]; set prnt $ind_on_105; set oprt $ind_on_105; set skp $ind_on_105; break}
                        "MEMBER ID: 00000008106"        {set i [expr $i + 1]; set prnt $ind_on_108; set oprt $ind_on_108; set skp $ind_on_108; break}
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
#exec mv $infile-test $infile

}



