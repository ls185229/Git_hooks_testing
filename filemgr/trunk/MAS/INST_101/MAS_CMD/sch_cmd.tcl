#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl

#declearing variables for commandline arguments.

set inst_id [lindex $argv 0]
set tsk_nbr [lindex $argv 1]
set cyl [lindex $argv 2]

#######################################################################################################################

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

#declearing all the date format required.

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set curdate [clock seconds]
set curtime [clock format $curdate -format "%H%M%S"]
set lg_ck_dt [string toupper [clock format $curdate -format "%d-%b-%y"]]
set curdate [clock format $curdate -format "%Y%m%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

#standered out for log tracking.

puts " "
puts "----- NEW LOG -------------- $logdate ----------------------"
puts "----- Updating MAS task CMD : $tsk_nbr --------------------------------------"


#declearing few variables.

set r_hr [clock seconds]
set r_hr [clock format $r_hr -format "%H"]
set r_min [clock seconds]
set r_min [clock format $r_min -format "%M"]
set cparam ""
set tsk_usage "OTHER"

#Checking we have required command line arguments.

if {$argc < 3} {
if {($tsk_nbr < 200 && $tsk_nbr > 100) && $tsk_nbr != 106} {
puts "REQUIRED arguments missing: E.G. argv 0) institution_id, 1) task_nbr 2) Payment Cycle"
exit 1
} else {
set cyl 0
}
}

#Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists. If the the stop file do not exist
#create the stop file while running this script, so that other process do not start if this scripts completes successfully and removes the stop file at
#the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : Msg sent from sch_cmd.tcl\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr"
exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

#Declearing a switch to remove zero from infront of time variable to avoid octal format.

switch $r_hr {
    "01" {set t_hr 1}
    "02" {set r_hr 2}
    "03" {set r_hr 3}
    "04" {set r_hr 4}
    "05" {set r_hr 5}
    "06" {set r_hr 6}
    "07" {set r_hr 7}
    "08" {set r_hr 8}
    "09" {set r_hr 9}
      default {set r_hr $r_hr}
}

#Declearing a switch to remove zero from infront of time variable to avoid octal format.

switch $r_min {
    "00" {set r_min 1}
    "01" {set r_min 2}
    "02" {set r_min 3}
    "03" {set r_min 4}
    "04" {set r_min 5}
    "05" {set r_min 6}
    "06" {set r_min 7}
    "07" {set r_min 8}
    "08" {set r_min 9}
    "09" {set r_min 10}
      default {set r_min $r_min}
}


#If current minute is 59 rolling the time to next hour with 1st minute.

if {$r_min > 57} {
switch $r_min {
     "58" {set r_min 1
                set r_hr [expr $r_hr + 1]}
     "59" {set r_min 1
        set r_hr [expr $r_hr + 1]}
 }
}

#Adding 2 additional minutes for any updates to complete.

set r_min [expr $r_min + 2]



#Making sure format is correct.

set r_hr [format %2d $r_hr]
set r_min [format %2d $r_min]

#Procedure for connecting to DB.

proc connect_to_db {} {
    global db_logon_handle db_connect_handle box clrdb authdb
    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
    set mbody "ALL PROCESSES STOPED SINCE sch_cmd.tcl could not logon to DB : Msg sent from sch_cmd.tcl\n $result"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db

#Opening connection handle to DB

connect_to_db

#Decleared few variables

set err ""
set tblnm_ifl "OUT_FILE_LOG"
set tblnm_fvc "FIELD_VALUE_CTRL"
set tigr 1
set cnt 0
set lp 1
global get
global lupdate
set get [oraopen $db_logon_handle]
set lupdate [oraopen $db_logon_handle]
set getaba [oraopen $db_logon_handle]

#setting up procedure for time out will take one argument in munber of munites.

proc timeout {{t 5}} {
set mxrotation [expr $t * 60]
set i 0
while {$i < $mxrotation} {
after 20000
puts -nonewline stdout "."
flush stdout
set i [expr $i + 20]
}
puts stdout " "
}

#procedure to delete process.stop file

proc del_psst {} {
global cnt inst_id lg_ck_dt mbody_c sysinfo mailfromlist msubj_c mailtolist
catch {file delete /clearing/filemgr/process.stop} result
        if {$result != ""} {
                set mbody "sch_cmd.tcl could not delete process.stop file from switch. Please, if you recived this mail delete the process.stop file from filemgr then try again."
                exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist

        }
}

#Procedure for checking task_log for MAS

proc chk_tlg {} {
global cnt inst_id lg_ck_dt mbody_c sysinfo mailfromlist msubj_c mailtolist
global tigr
global lp
global get
global lupdate

set ck_lg "select * from task_log where institution_id = '$inst_id' and usage = 'MAS' and cmd_nbr in ('107','110','109','138') and result = 'EXECUTED' and ACTUAL_START_DT like '$lg_ck_dt%'"

orasql $get $ck_lg


if {[orafetch $get -dataarray cklg -indexbyname] == 0} {
set mbody "CMD_NBR: $cklg(CMD_NBR) for INST_ID: $inst_id is still running and RESULT is $cklg(RESULT)\nStoping all processes."
exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
exit 1
} else {
puts "There are no MAS task running at this time. Continuing process update task table"
}

}

if {$tsk_nbr > 100 && $tsk_nbr < 200} {

set get_abadda "select * from BRD_SETTL_ACCT_TO_PMTCYL where institution_id = '$inst_id' and payment_cycle = '[string range $cyl 2 2]'"

puts $get_abadda

orasql $getaba $get_abadda

if {[orafetch $getaba -dataarray set_acct -indexbyname] != 0} {
if {$tsk_nbr == "102"} {
set mbody "CMD_NBR: $tsk_nbr INST_ID: $inst_id and PMT_CYCL: $cyl :: Could not find ABA DDA \nStoping all processes."
exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
exit 1
}
}
}




#Procedure for checking server status

proc chk_sts {} {
global tblnm_fvc
set tblnm_fvc "FIELD_VALUE_CTRL"
global cnt
global tigr
global lp
global get
global lupdate
    set tigr 1
    set cnt 0
    set lp 0

    while {$cnt < 10} {
    set sql1 "select * from $tblnm_fvc where FIELD_NAME like '%R_STATUS'"
    orasql $get $sql1
    puts $cnt
    set cnt [expr $cnt + 1]
    while {[orafetch $get -dataarray z -indexbyname] == 0} {
        puts "$z(FIELD_NAME) = $z(FIELD_VALUE1)"
        set val [string trim $z(FIELD_VALUE1)]
            if {$val != "IDLE"} {
            set tigr 1
            set lp 1
            }
    }

    if {$lp == 1} {
        after 120000
        set lp 0
    } else {
                        set tigr 0
                        set cnt 15
                        set lp 0
    }
    }

}


#Procedure for check gl date status.

proc chk_gl_date {seq {dt $curdate}} {

    global inst_id tsk_nbr chk_sql chk_sql2 get curdate box clrpath maspath mailtolist mailfromlist msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    set chk_sql "select to_char(MAX(GL_DATE), 'YYYYMMDD') as MAXDT, to_char(MIN(GL_DATE), 'YYYYMMDD') as MINDT from gl_chart_of_acct where institution_id='$inst_id'"
    set chk_sql2 "select field_value1 from field_value_ctrl where field_name = 'GL_DATE' and institution_id = '$inst_id'"

    orasql $get $chk_sql
    orafetch $get -dataarray gl_chk -indexbyname
        if {[oramsg $get rc]} {
            set mbody "$box GL_DATE is null\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE value is set to null in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMIDIATELY."
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }

        if {$gl_chk(MAXDT) != $gl_chk(MINDT)} {
            set mbody "$box GL_DATE DO not match\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n MAX GL_DATE $gl_chk(MAXDT) and MIN GL_DATE $gl_chk(MINDT) values found in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMIDIATELY."
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }

        if {$gl_chk(MAXDT) == $gl_chk(MINDT)} {
            if {$gl_chk(MAXDT) == $dt} {
            return 0
            }
        }

orasql $get $chk_sql2
orafetch $get -dataarray gl_chk2 -indexbyname

        if {[oramsg $get rc]} {
            set mbody "$box GL_DATE is null\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE value is set to null in table field_value_ctrl and FIELD : field_value1. Exited GL_EXPORT. CALL Clearing Group IMMIDIATELY."
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }

        if {$gl_chk(MAXDT) != $gl_chk2(FIELD_VALUE1)} {
            set mbody "$box GL_DATE DO not match\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n MAX GL_DATE $gl_chk(MAXDT) and FIELD_VALUE1 GL_DATE $gl_chk2(FIELD_VALUE1) values found in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMIDIATELY."
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }

    if {$seq == 2} {
            if {$gl_chk(MAXDT) == $curdate} {
                puts "FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE is not set for tomorrow.  GL_DATE = $gl_chk(MAXDT). Running GL_EXPORT"
                set mbody "$box GL_EXPORT FAILED\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_EXPORT FAILED.  GL_DATE = $gl_chk(MAXDT)."
                exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                return 1
            }
    }

    if {$seq == 1} {
        if {$gl_chk(MAXDT) < $curdate} {
            set mbody "$box GL_EXPORT is not complete.\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE is not correct.  GL_DATE = $gl_chk(MAXDT) is less Current date: $curdate"
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }
    }


    if {$seq == 2} {
        if {$gl_chk(MAXDT) < $curdate} {
            set mbody "$box GL_EXPORT is not complete.\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE is still not correct.  GL_DATE = $gl_chk(MAXDT) is less that Current date: $curdate"
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
        }
    }



    if {$gl_chk(MAXDT) > $curdate} {
        set adate [clock format [ clock scan "+1 day" ] -format %Y%m%d]
      if {$seq == 1} {
        if {$gl_chk(MAXDT) == $adate} {
         puts "FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n Alerady has the correct GL_DATE. GL_DATE = $gl_chk(MAXDT)"
#            exec echo "FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n Alerady has the correct GL_DATE. GL_DATE = $gl_chk(MAXDT)" | mailx -r $mailfromlist -s "$box GL_EXPORT DONE" $mailtolist
             return 2
            } else {
        set mbody "$box GL_DATE s greater than $adate\n\n FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE is not correct. GL_DATE = $gl_chk(MAXDT) which is greater than $adate"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            return 1
            }
     }

      if {$seq == 2} {
        if {$gl_chk(MAXDT) == $adate} {
         puts "FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE UPDATED SUCCSESSFULLY.  GL_DATE = $gl_chk(MAXDT)"
#        exec echo "FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr.\n GL_DATE UPDATED SUCCSESSFULLY.  GL_DATE = $gl_chk(MAXDT)" | mailx -r $mailfromlist -s "$box GL_EXPORT DONE" $mailtolist
         return 2
        }
      }
       }

}

set cyl [string range $cyl 2 2]

switch $tsk_nbr {
  "100"     {set cparam "-i$inst_id"; # Start File Recognition; ; }
  "102"     {set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime -oN -f$set_acct(SETTL_ROUTING_NBR)"; # ACH Payment; }
  "103"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime -oY -wY -f$set_acct(SETTL_ROUTING_NBR)"; # Wire; }
  "104"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime -oY -f$set_acct(SETTL_ROUTING_NBR)"; # Manual Wire; }
  "105"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime -oY -bY -f$$set_acct(SETTL_ROUTING_NBR)"; # Invoice Generation; }
  "106"     {set cparam "-i$inst_id -d$curdate -t$curtime "; # GL Export; }
  "107"     {set cparam "-i$inst_id -d$curdate"; # Transaction Counting; }
  "108"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -c$cyl"; # Rate Re-assessment; }
  "109"     {set cparam "-i$inst_id -d$curdate -c$cyl"; # Calculate Next Settlement Date; }
  "110"     {set cparam "-i$inst_id -d$curdate -c$cyl"; # Non-Activity Fees; }
  "111"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -t$curtime"; # Remittance; }
  "112"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -t$curtime"; # Aging; }
  "113"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Adjustment; }
  "114"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Fee Group Rate Update; }
  "115"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate"; # Mas Fee Future Effective Date; }
  "116"     {set cparam "-i$inst_id -ba"; # Resubmit Suspended Batch; }
  "117"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -t<Time(HHMM)>"; # Expected Merchant's Transmission; }
  "118"     {set cparam "-i$inst_id -cN>"; # Cycle Balancing; }
  "119"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d<Monthly Period(YYYYMM)>"; # Payment Count; }
  "120"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -f<File Name>"; # Reprocess Lost Transactions; }
  "121"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run>"; # MAS Outbounder File; }
  "122"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run> -bY -f$set_acct(SETTL_ROUTING_NBR)"; # Re-generate Invoice; }
  "123"     {set cparam "-i$inst_id"; # EOD Balancing; }
  "124"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d<Monthly Period(YYYYMM)>"; # Monthly Summary; }
  "125"     {set cparam "-i$inst_id"; # Submit Mas_trans_error; }
  "126"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)"; # Re-generate ACH; }
  "127"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)"; # Re-generate Wire; }
  "128"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)"; # Re-generate Manual Wire; }
  "129"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -d$curdate -r<Payment Run>"; # Generate Payment Log File; }
  "130"     {set cparam "-i$inst_id -c$cyl"; # Cycle Balancing Report; }
  "131"     {set cparam "-i$inst_id -d$curdate"; # EOD Balancing Report; }
  "132"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-c<Command>"; # System Call; }
  "133"     {set cparam "-i$inst_id"; # Write-Off Suspend Transactions; }
  "134"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-c<Command>"; # System Call w/ StopFR; }
  "135"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # Undo ACH; }
  "136"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # Undo Wire; }
  "137"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # Undo Manual Wire; }
  "138"     {set cparam "-i$inst_id -d$curdate -c$cyl"; # Build Item to Accum; }
  "139"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Delete Entity; }
  "140"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate"; # Undo Invoice; }
  "200"     {set cparam "-i$inst_id"; # Stop File Recognition; }
  "301"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch Cycle 00 ACH; }
  "302"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch Cycle 21 Inv/Wire; }
  "303"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch Cycle 00/21 ACH/Inv/Wire; }
  "304"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch Cycle 00 ACH/Inv; }
  "305"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch EOD phase 1; }
  "306"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch EOD type 1; }
  "307"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id"; # Batch EOD type 2; }
  "501"     {set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # End of Cycle; }
  "502"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # End of Cycle (Month End); }
  "503"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # End of Day; }
  "551"     {set cparam "-i$inst_id -c$cyl"; # End of Cycle; }
  "552"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl"; # End of Cycle (Month End); }
  "553"     {puts "!! NOT ALLOWED !!"; del_psst ; exit 0 ;  set cparam "-i$inst_id -c$cyl"; # End of Day; }
  "701"     {set cparam "-i$inst_id -c$cyl -d$curdate -t$curtime"; # End of Cycle (No Ach); }
  "751"     {set cparam "-i$inst_id -c$cyl"; # End of Cycle (No Ach); }
  "901"     {set cparam "-i$inst_id"; # Flush Servers Read Caches; }
  "201"     {set tsk_usage "CLR"}
  "321"     {set tsk_usage "CLR"}
  "341"     {set tsk_usage "CLR"}
  "355"     {set tsk_usage "CLR"}
  "241"         {set tsk_usage "CLR"}
  "255"         {set tsk_usage "CLR"}
  "256"         {set tsk_usage "CLR"}
  default   {puts "TASK NUMBER NOT FOUND: TASK SWITCH FAILED: SCRIPT EXITED WITH ERROR"; del_psst;
        exit 0
        }
}


######
#MAIN#
######


#Calling status check Procedure to check server status is Idle.

if {$tsk_usage != "CLR"} {
chk_tlg
chk_sts
} else {
set tigr 0
}


puts "tigr: $tigr, cnt: $cnt, lp: $lp"
                if {$cnt == 10} {
                        set cdate [clock seconds]
                        set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

                                                set sql4 "update tasks set run_hour = '', run_min = '' where institution_id = '$inst_id'"
                                                orasql $lupdate $sql4
                                                puts "SERVER STATUS IS NOT IDLE after 20 munites at $cdate"
                        set mbody "$box FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr. Failed\n\n SERVER STATUS IS NOT IDLE after 20 munites: Tasks reseted to NULL at $cdate"
                        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist

                                                oracommit $db_logon_handle
                            if {[file exists /clearing/filemgr/process.stop]} {
                                exit 1
                            } else {
                                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
                            }

                                                exit 1

                }
#This sections updates Task table in db according to task number. Depending on which tasks needs updating that part of the section gets invoked.

if {$tsk_nbr == "106"} {

#This section for gl export 106

  if {$tigr == 0} {
    global lupdate

    set x [chk_gl_date 1]

    switch $x {
        "0" {puts "Running Gl export"}
        "1" {puts "Error see email for details."
             exec /clearing/filemgr/MAS/INST_101/MAS_CMD/reset_task.tcl >> /clearing/filemgr/MAS/INST_101/MAS_CMD/task.log
             exit 1}
        "2" {puts "Already has the correct GL date."
             catch {file delete /clearing/filemgr/process.stop} result
             exit 0
            }
    }

#updateting mas tasks
        set sql3 "update tasks set run_hour='$r_hr',run_min='$r_min', CMD_PARAM = '$cparam'  where institution_id = '$inst_id' and task_nbr = '$tsk_nbr'"
        puts $sql3
        orasql $lupdate $sql3
#   exec echo "UPDATE TASK for FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr : $r_hr:$r_min" | mailx -r $mailfromlist -s "$box MAS TASK UPDATED FOR CMD $tsk_nbr" $mailtolist
                puts "Time set to run_hour= $r_hr ,run_min= $r_min"
        oracommit $db_logon_handle

   }

    timeout

    set y [chk_gl_date 2]

        switch $y {
                "0"     {puts "Gl Export did not complete. Please see email."
             exec /clearing/filemgr/MAS/MAS_CMD/reset_task.tcl >> /clearing/filemgr/MAS/MAS_CMD/task.log
             exit 0
            }
                "1"     {puts "Error see email for details."
                         exec /clearing/filemgr/MAS/MAS_CMD/reset_task.tcl >> /clearing/filemgr/MAS/MAS_CMD/task.log
                         exit 0}
                "2"     {puts "GL EXPORT SUCCESSFULL."
                        }
        }

} else {

#This section is for all other tasks.

  if {$tigr == 0} {
   global lupdate tsk_usage
    if {$tsk_usage == "CLR"} {
#       updateting mas tasks

                set sql4 "update tasks set run_hour='$r_hr',run_min='$r_min' where institution_id = '$inst_id' and task_nbr = '$tsk_nbr'"
        puts $sql4
                orasql $lupdate $sql4
        puts "UPDATE TASK FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr : $r_hr:$r_min"
                oracommit $db_logon_handle
        set tsk_usage "OTHER"

    } else {
#       updateting mas tasks

                set sql3 "update tasks set run_hour='$r_hr',run_min='$r_min', CMD_PARAM = '$cparam'  where institution_id = '$inst_id' and task_nbr = '$tsk_nbr'"
        puts $sql3
                orasql $lupdate $sql3
        puts "UPDATE TASK FOR INST ID: $inst_id :: CMD NBR : $tsk_nbr : $r_hr:$r_min"
                oracommit $db_logon_handle
    }
  }
}


catch {file delete /clearing/filemgr/process.stop} result
    if {$result != ""} {
        set mbody "sch_cmd.tcl could not delete process.stop file at the end of the script. Please, if you recived this mail delete the process.stop file from filemgr."
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist

    }
puts "------------------------------ COMPLETE --------------------------------"
puts " "
