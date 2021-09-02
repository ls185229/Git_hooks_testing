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
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

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

set sysinfo "System: $box\n Location: /clearing/filemgr/REJECTS/ARCHIVE \n\n"

#######################################################################################################################

set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]


proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set brk 0

set infile ""

set infilelist [exec find . -mtime 0 -name TT140T0.*]

foreach infile $infilelist {

set infile [string range $infile 2 end]

set input [open $infile r]
set cur_line  [split [set orig_line [gets $input]] \ ]
set len [string length $cur_line]
set sline [string trim $cur_line]
set nlist ""
while {! [eof $input]} {

                foreach entry $sline {
		    if {$entry == "REJECT"} {
			foreach item $sline {
                          if {$item != " " && $item != ""} {
                                  set blist [lappend blist $item]
			  }
			}
						set brk 1
                    }

                }

#puts "======$cur_line======"

set cur_line  [split [set orig_line [gets $input] ] \ ]
set len [string length $cur_line]
set sline [string trim $cur_line]
}

 if {$brk == 1} {
     close $input
     after 100
     set tempmsg "[lindex $blist 0] [lindex $blist 1] [lindex $blist 2]"
     set sbody "FILE NAME: $infile\n DATE: $curdate\n\n $tempmsg"
     puts [subst {exec mutt -a $infile -s "$msubj_h" $mailtolist << [exec echo "$sysinfo $mbody_h $sbody"]} ]
     puts [exec mutt -a $infile -s "$msubj_h" $mailtolist << [exec echo "$sysinfo $mbody_h $sbody"]]
     set outfile "DT$logdate-$infile"
     exec cp $infile $outfile
     exec mv $outfile ./ARCHIVE/.
     exec rm $infile 
     set infile ""
     set blist ""
     set brk 0
 } else {
     exec rm $infile
     puts "No REJECTS Found in $infile"
     set brk 0
     set infile ""
 }

}
