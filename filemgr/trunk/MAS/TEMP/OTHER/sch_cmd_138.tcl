#!/usr/bin/env tclsh

package require Oratcl


set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts " "
puts "----- NEW LOG -------------- $logdate ----------------------"
puts "----- Updating MAS task 138 --------------------------------------"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set r_hr [clock seconds]
set r_hr [clock format $r_hr -format "%H"]
set r_min [clock seconds]
set r_min [clock format $r_min -format "%M"]

set clrpath "/clearing/clradmin/pdir20051024/ositeroot/data"
set maspath "/clearing/masadmin/pdir20051024/ositeroot/data"

if {[file exists /clearing/filemgr/process.stop]} {
exec echo "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : Msg sent from cmd_138.tcl" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PREVIOUS PROCESS NOT COMPLETED" clearing@jetpay.com
exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}



if {$r_min > 54} {
switch $r_min {
     "55" {set r_min 1 
		set r_hr [expr $r_hr + 1]}
     "56" {set r_min 2 
		set r_hr [expr $r_hr + 1]}
     "57" {set r_min 3 
		set r_hr [expr $r_hr + 1]}
     "58" {set r_min 4 
		set r_hr [expr $r_hr + 1]}
     "59" {set r_min 5 
		set r_hr [expr $r_hr + 1]}
 }
}


set r_min [expr $r_min + 2]

set r_hr [format %2d $r_hr]
set r_min [format %2d $r_min]


proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    if {[catch {set db_logon_handle [oralogon masclr/masclr@masclr]} result] } {
        puts "Encountered error $result while trying to connect to DB"
	exec echo "ALL PROCESSES STOPED SINCE cmd_138.tcl could not logon to DB : Msg sent from cmd_138.tcl" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PROCESS NOT COMPLETED" clearing@jetpay.com
        exit 1
    }
};# end connect_to_db

connect_to_db
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


#checking server status

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


######
#MAIN#
######


#Calling Procedure

chk_sts


puts "tigr: $tigr, cnt: $cnt, lp: $lp"
				if {$cnt == 10} {
						set cdate [clock seconds]
						set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

                                                set sql4 "update tasks set run_hour = '', run_min = '' where institution_id = '447474'"
                                                orasql $lupdate $sql4
                                                puts "SERVER STATUS IS NOT IDLE after 20 munites at $cdate"
                                                exec echo "SERVER STATUS IS NOT IDLE after 20 munites: Tasks reseted to NULL at $cdate" | mailx -r clearing@jetpay.com -s "CMD 138 Failed" clearing@jetpay.com

                                                oracommit $db_logon_handle
							if {[file exists /clearing/filemgr/process.stop]} {
								exit 1
							} else {
								catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
							}

                                                exit 1

				}



if {$tigr == 0} {
#updateting mas tasks
		set sql3 "update tasks set run_hour='$r_hr',run_min='$r_min', CMD_PARAM = '-i447474 -d$curdate -c1'  where institution_id = '447474' and task_nbr = '74740138'"
		orasql $lupdate $sql3	  
#	exec echo "UPDATE MAS TASK 74740138: $r_hr:$r_min" | mailx -r clearing@jetpay.com -s "MAS TASK UPDATED FOR CMD 138" clearing@jetpay.com clearing@jetpay.com
                puts "Task 138 set to run_hour= $r_hr ,run_min= $r_min"
  		oracommit $db_logon_handle

}
catch {file delete /clearing/filemgr/process.stop} result
puts "------------------------------ COMPLETE --------------------------------"
puts " "
