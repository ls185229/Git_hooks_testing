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

set sysinfo "System: $box\n Location: /clearing/filemgr/TC57/ARCHIVE \n\n"

#######################################################################################################################

set logdate [clock format [clock seconds] -format "%Y%m%d"]
set err ""

if {$argc == 1} {

set logdate [string trim [lindex $argv 0]]

}

exec echo "Log Date: $logdate" >> ./LOG/base2.epd.rpt.log

proc chk_err {errorv errmsg} {

global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo err

	if {$errorv == ""} {
		#exec echo "\n Done -- $errmsg \n " >> ./LOG/base2.epd.rpt.log
	} else {
		puts "Err: \n $errmsg \n $errorv"
	        set mbody "Err: \n $errmsg \n $errorv \n"
        	exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        	exit 1	
	}

}

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

#set trknbr_list {1000306697 1000306698 1000306699 1000306700 1000306701 1000306702 1000306703 1000306704 1000306706 1000306709}
#set trknbr_list {1000307766 1000319610 1000153362 1000183652 1000064351 1000182273 1000109788 1000108993 1000108962 1000323869 }
set trknbr_list {}



proc get_cfg {cfg_pth} {
        global arr_cfg trknbr_list
        set cfg_file "base2.epd.cfg"
        set in_cfg [open $cfg_pth/$cfg_file r]
        set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
        while {$cur_line != ""} {
                if {[string toupper [string trim [lindex $cur_line 0]]] != "" && [string toupper [string range [lindex $cur_line 0] 0 0]] != "#"} {
			lappend trknbr_list [lindex $cur_line 0]
			set arr_cfg(inst_id.[lindex $cur_line 0]) [lindex $cur_line 1]
			set arr_cfg(network.[lindex $cur_line 0]) [lindex $cur_line 2]
#			puts "$trknbr_list $arr_cfg(inst_id.[lindex $cur_line 0]) $arr_cfg(network.[lindex $cur_line 0])"
                }
        set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
        }
return arr_cfg
}

get_cfg ./CFG
if {$argc == 1} {
catch {exec ./recv_file_ftp.exp $logdate >> ./LOG/base2.epd.rpt.log} err
chk_err $err "./recv_file_ftp.exp >> ./LOG/base2.epd.rpt.log"
} else {
catch {exec ./recv_file_ftp.exp >> ./LOG/base2.epd.rpt.log} err
chk_err $err "./recv_file_ftp.exp >> ./LOG/base2.epd.rpt.log"
}

set nlist ""
set i 1

foreach trknbr $trknbr_list {
set l 1
set infile "EP27ST.EPD"
set outfile "SRE$trknbr"
set input [open $infile r]

exec echo "\n $outfile \n" >> ./LOG/base2.epd.rpt.log

while {! [eof $input]} {

set cur_line0 [set orig_line [gets $input]]
set line1 [string range [string trim $cur_line0] 1 9]

if {$line1 == "REPORT ID"} {
set cur_line2 [set orig_line [gets $input]]

set line2 [string range [string trim $cur_line2] 20 29]
if {$line2 == "$trknbr"} {

        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                puts stderr "Cannot open /duplog : $fileid"
        } else {
			if {$l == 1} {
                        puts $fileid "[string range $cur_line0 1 end]"
			incr l
			} else { 
			puts $fileid "$cur_line0"
			incr l
			}
	
                        close $fileid
        }
        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                puts stderr "Cannot open /duplog : $fileid"
        } else {
                        puts $fileid $cur_line2
                        close $fileid
        }

  set x 1
  while {$x == 1} {
	set cur_line2  [set orig_line [gets $input]]
        #puts "$cur_line2"
        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                puts stderr "Cannot open /duplog : $fileid"
        } else {
                        puts $fileid $cur_line2
                        close $fileid
        }
           if {[eof $input]} {
               set x 5
           }
  }
}
}
}

close $input

                        set inst_id "$arr_cfg(inst_id.$trknbr)"
                        set network "$arr_cfg(network.$trknbr)"
						set pdffilename "VSReport-$outfile-$logdate.epd"
                        exec cp $outfile $pdffilename
puts "outfile: $outfile"
puts "pdf filename: $pdffilename"
                        set zipfolder "VSDailyReports-$inst_id-$network-$logdate"
puts "zipfolder: $zipfolder"
                        catch {exec mkdir $zipfolder >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "mkdir $zipfolder >> ./LOG/base2.epd.rpt.log"
                        catch {exec cp $pdffilename $zipfolder >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "cp $pdffilename $zipfolder >> ./LOG/base2.epd.rpt.log"
                        catch {exec zip -r $zipfolder $zipfolder >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "zip -r $zipfolder $zipfolder >> ./LOG/base2.epd.rpt.log"
                        catch {exec rm -r $zipfolder >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "rm -r $zipfolder >> ./LOG/base2.epd.rpt.log"
                        catch {exec email_reports.tcl $zipfolder.zip $inst_id $network $logdate >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "email_reports.tcl $zipfolder.zip $inst_id $network $logdate >> ./LOG/base2.epd.rpt.log"
                        catch {exec mv $pdffilename ./INST_$inst_id/ARCHIVE/ >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "mv $pdffilename ./INST_$inst_id/ARCHIVE/ >> ./LOG/base2.epd.rpt.log"
                        catch {exec mv $zipfolder.zip ./INST_$inst_id/UPLOAD/ >> ./LOG/base2.epd.rpt.log} err
                        chk_err $err "mv $zipfolder.zip ./INST_$inst_id/UPLOAD/ >> ./LOG/base2.epd.rpt.log"
#                        catch {exec ./INST_$inst_id/UPLOAD/upload.exp ./INST_$inst_id/UPLOAD/$zipfolder.zip >> ./LOG/base2.epd.rpt.log} err
#                        chk_err $err "./INST_$inst_id/UPLOAD/upload.exp ./INST_$inst_id/UPLOAD/$zipfolder.zip >> ./LOG/base2.epd.rpt.log"
#                        if {$err == ""} {
#                               set renm "PD-$zipfolder.zip"
#                                catch {exec mv ./INST_$inst_id/UPLOAD/$zipfolder.zip ./INST_$inst_id/ARCHIVE/$renm >> ./LOG/base2.epd.rpt.log} err
#						chk_err $err "./INST_$inst_id/UPLOAD/$zipfolder.zip ./INST_$inst_id/ARCHIVE/$renm >> ./LOG/base2.epd.rpt.log"
#                        }
                        
file delete $outfile
};#end of foreach
exec echo "------------------------------" >> ./LOG/base2.epd.rpt.log
