#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#package require Oratcl
package require Oratcl
package provide random 1.0

##################################################################################



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


#Institution Profile Information-------------------------------------------------
                set inst_name [open "./inst_profile.cfg" "r+"]
                set line [split [set orig_line [gets $inst_name] ] ,]
                set inst_id [string trim [lindex $line 0]]
                set vbin [string trim [lindex $line 1]]
                set mbin [string trim [lindex $line 2]]
                set ica [string trim [lindex $line 3]]
                set cib [string trim [lindex $line 4]]
                set edpt [string trim [lindex $line 5]]
                puts "$inst_id $vbin $mbin $ica $cib $edpt"



set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)


#Opening connection to db--------------------------------------------------
if {[catch {set db_logon_handle [oralogon teihost/quikdraw@$authdb]} result]} {
        puts "$authdb efund boarding failed to run"
        set mbody "$authdb efund boarding failed to run"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
}


#All the sql logon handles -------------------------------------------------
set auth_get [oraopen $db_logon_handle]

#CHECKING FEB ON LEAP YEAR AND STOP RUNNING ON FEB 28

set chklpyear [clock seconds]
set chklpyear [clock format $chklpyear -format "%m%d"]

if {$chklpyear == "0228"} {
set get_dt "select to_char(last_day(sysdate), 'MMDD') as leap_yr_dt  from DUAL"
orasql $auth_get $get_dt
orafetch $auth_get -dataarray lp -indexbyname

        if {$lp(LEAP_YR_DT) == "0229"} {
                puts "leap year exiting recyling run. This will be ran on tomorrow at Feb 29"
                set mbody "leap year exiting recyling run. This will be ran on tomorrow at Feb 29"
                exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
                exit 0
        }
}

if {[file exists /clearing/filemgr/process.stop]} {
exec echo "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : Msg sent from Counting Script send_recyling_file.tcl" | mailx -r clearing@jetpay.com -s "PROD: MAS: URGENT!!! CALL SOMEONE :: PREVIOUS PROCESS NOT COMPLETED" clearing@jetpay.com assist@jetpay.com
exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}


set x ""
set y ""


catch {set y [exec find $env(PWD)/MAS_FILES -mtime 0 | grep $inst_id.RECYLING.01*]} result 

if {$y == ""} {
exec echo "NO FILE FOUND" | mailx -r clearing@jetpay.com -s "PROD: MAS: RECYCLING file not found in MAS folder" clearing@jetpay.com assist@jetpay.com
catch {file delete /clearing/filemgr/process.stop} result
exit 1
}
set i 0
if {[llength $y] >=  2} {
exec echo $x | mailx -r clearing@jetpay.com -s "PROD: MAS: Multiple RECYCLING file found in MAS folder" clearing@jetpay.com assist@jetpay.com
exit 1
}

if {[llength $y] ==  1} {
exec cp -p [lindex $y 0] .
}
puts $y
set recyling [string range [lindex $y 0] 41 end]
puts $recyling

exec chmod 775 $env(PWD)/$recyling 
set dummy ""
set dummy [exec cp -p $env(PWD)/$recyling $maspath/data/in]
puts $dummy
if {$dummy != ""} {
exec echo $y | mailx -r clearing@jetpay.com -s "PROD: MAS: Files not transfered to MASADMIN" clearing@jetpay.com assist@jetpay.com
} else {
#exec echo $y | mailx -r clearing@jetpay.com -s "PROD: MAS: Files transfered to MASADMIN" rkhan@jetpay.com clearing@jetpay.com assist@jetpay.com
}


set err [exec mv MAS_FILES/$recyling ARCHIVE]
if {$err == ""} {
exec rm $recyling
}
catch {file delete /clearing/filemgr/process.stop} result

catch {exec $env(PWD)/sch_cmd.tcl $inst_id 100 >> LOG/task.log} result
puts $result
