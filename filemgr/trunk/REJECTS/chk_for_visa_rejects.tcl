#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

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


set TCR {
    {Record Type}
    {Record Count}
    {Accepted Financial Count}
    {Accepted Finamcial Amount}
    {Accepted Non-Financial Count}
    {Rejected Financial Count}
    {Rejected Finamcial Amount}
    {Rejected Non-Financial Count}
    {Rejected Transaction Warning}
};# end set TCR(FH)

set infile "EP110F.EPD"
set outfile "DT$logdate-$infile"
set input [open "$infile" r]
set cur_line  [split [set orig_line [gets $input]] \ ]
set len [string length $cur_line]
set sline [string range $orig_line 0 4]
set sline [string trim $sline]
set nlist ""
while {! [eof $input]} {
	if {$sline == "BATCH"} {
		foreach entry $cur_line {
			  if {$entry != " " && $entry != ""} {
				  set blist [lappend blist $entry] 
  			  }
		}
	}

        if {$sline == "FILE"} {
                foreach entry $cur_line {
                          if {$entry != " " && $entry != ""} {
                                  set flist [lappend flist $entry]
                          }
                }
        }
        if {$sline == "RUN"} {
                foreach entry $cur_line {
                          if {$entry != " " && $entry != ""} {
                                  set rlist [lappend rlist $entry]
                          }
                }
        }

	


set cur_line  [split [set orig_line [gets $input] ] \ ]
set len [string length $cur_line]
set sline [string range $orig_line 0 4]
set sline [string trim $sline]
}
puts " "
puts $blist
puts $flist
puts $rlist


        if {[lindex $blist 6] != "0.00" || [lindex $flist 6] != "0.00" || [lindex $rlist 6] != "0.00"} {
                puts "Reject info BATCH AMOUNT = [lindex $blist 6] :  FILE AMOUNT = [lindex $flist 6] :  RUN AMOUNT = [lindex $rlist 6]"
		set sbody "Some transaction rejected. Please, review attached file.\n Transation Amount :\n BATCH = [lindex $blist 6] :  FILE = [lindex $flist 6] :  RUN = [lindex $rlist 6]"
#		exec echo "$sysinfo $mbody_h $sbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
		catch {exec mutt -a $infile -s "$msubj_h" $mailtolist << [exec echo "$sysinfo $mbody_h $sbody"]} result
		puts ">$result<"
	        if {$result != ""} {
                put "email not sent correctly"
                exit 1
	        }

        }

        if {[lindex $blist 5] != 0 || [lindex $flist 5] != 0 || [lindex $rlist 5] != 0} {
		puts "Reject info BATCH  = [lindex $blist 5] :  FILE  = [lindex $flist 5] :  RUN  = [lindex $rlist 5]"
                set sbody "Some transaction rejected. Please, review attached file.\n Transaction Count :\n BATCH = [lindex $blist 5] :  FILE  = [lindex $flist 5] : RUN = [lindex $rlist 5]"
#               exec echo "$sysinfo $mbody_h $sbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
		catch {exec mutt -a $infile -s "$msubj_h" $mailtolist << [exec echo "$sysinfo $mbody_h $sbody"]} result
		puts ">$result<"
	        if {$result != ""} {
                put "email not sent correctly"
                exit 1
	        }

        }

        if {[lindex $blist 8] != "" || [lindex $flist 8] != "" || [lindex $rlist 8] != ""} {
                puts "Duplicate transaction count. BATCH  = [lindex $blist 8] :  FILE  = [lindex $flist 8] :  RUN  = [lindex $rlist 8]"
                set sbody "Visa Edit Package detected duplicate transactions. Please, review attached file.\n Transaction Count :\n BATCH = [lindex $blist 8] :  FILE  = [lindex $flist 8] : RUN = [lindex $rlist 8]"
#               exec echo "$sysinfo $mbody_h $sbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
		catch {exec mutt -a $infile -s "$msubj_h" $mailtolist << [exec echo "$sysinfo $mbody_h $sbody"]} result
		puts ">$result<"
	        if {$result != ""} {
                put "email not sent correctly"
                exit 1
	        }

        }
exec mv $infile $outfile
exec mv $outfile ARCHIVE
