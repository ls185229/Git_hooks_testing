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

set endpoint [lindex $argv 0]

if {$argc == 0 || [lindex $argv 0] == ""} {
    puts "No Endpoint selected to archive files. Such as code.tcl 0078965"
    #   exit 1
}

set logdate [clock seconds]
set rundate [clock format $logdate -format "%Y%m%d"]
set curdate [clock format $logdate -format "%Y-%m-%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

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
set seq 0
set tskrun "n"
catch {set x [exec find . -name TT884T0*]} result

if {$x == ""} {
    set mbody "No T884 files found in IPM folder"
    exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
    puts "$mbody_h $sysinfo $mbody" 
    exit 1
}


set i 0
set dummy ""
set dummy1 ""
foreach file $x {
    puts "Found file $file"
    set len [string length $file]
    catch {exec grep "NO ACTIVITY" $file} nact
    puts $nact
    if {[string range $nact 0 30]  == "child process exited abnormally"} {

        if {$len > 13} {
            set ipm [string range [lindex $x $i] 2 end]
            set seq [string range [lindex $x $i] 10 12]
            set seq1 [format %03s $seq]
            set fdt [string range $file 12 19]
            puts $fdt
            set xfile "MCRC.TT884T0.[string range [clock format [clock scan $fdt -base [clock seconds]] -format "%y%j"] 1 5].$seq1"
            set rename [string map {TT PD} "$file-[clock format [clock scan $rundate -base [clock seconds]] -format "%Y%m%d"]"]
        } else {
            set ipm [string range [lindex $x $i] 2 end]
            set seq [string range [lindex $x $i] 10 end] 
            set seq1 [format %03s $seq]
            set xfile "MCRC.TT884T0.[string range [clock format [file mtime $file] -format "%y%j"] 1 5].$seq1"
            set rename [string map {TT PD} "$file-[clock format [file mtime $file] -format "%Y%m%d"]"]

        }
        exec cp $ipm $rename
        exec cp $ipm $xfile
        exec chmod 775 $xfile
        catch {exec cp -p $xfile /$clrpath/data/in/ipm/.} err1
        if {$err1 == ""} {
            file delete $rename
            exec mv $xfile ./EDPT0079893/ARCHIVE/
            puts "$ipm :: $xfile"
            file delete $ipm
            set tskrun "y"
        }
    } else {
        if {$len > 13} {
            set ipm [string range [lindex $x $i] 2 end]
            set seq [string range [lindex $x $i] 10 12]
            set seq1 [format %03s $seq]
            set fdt [string range $file 12 19]
            puts $fdt
            set xfile "MCRC.TT884T0.[string range [clock format [clock scan $fdt -base [clock seconds]] -format "%y%j"] 1 5].$seq1"
            set rename [string map {TT PD} "$file-[clock format [clock scan $rundate -base [clock seconds]] -format "%Y%m%d"]"]
        } else {
            set ipm [string range [lindex $x $i] 2 end]
            set seq [string range [lindex $x $i] 10 end]
            set seq1 [format %03s $seq]
            set xfile "MCRC.TT884T0.[string range [clock format [file mtime $file] -format "%y%j"] 1 5].$seq1"
            set rename [string map {TT PD} "$file-[clock format [file mtime $file] -format "%Y%m%d"]"]

        }
        exec cp $ipm $rename
        exec cp $ipm $xfile
        exec chmod 775 $xfile
        file delete $rename 
        exec mv $xfile ./EDPT0079893/ARCHIVE/
        puts "$ipm :: $xfile :: [string range $nact 0 30]"
        file delete $ipm
    }
    set i [expr $i + 1]
}

if {$tskrun == "y"} {

    catch {exec ./sch_cmd.tcl 05 256 >> ./LOG/task.log} tskresult

    if {$tskresult == ""} {
        puts "task update completed" 
    } else {
        set mbody "sch_cmd.tcl 05 256 failed"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
    }
}

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "------END OF IPM REPORT FILES-------$logdate-------------"
puts "                                                          "
