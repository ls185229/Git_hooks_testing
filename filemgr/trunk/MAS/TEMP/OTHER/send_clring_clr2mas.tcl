#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#package require Oratcl
package require Oratcl
package provide random 1.0

set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)

if {[file exists /clearing/filemgr/process.stop]} {
exec echo "PREVIOUS PROCESS NOT COMPLETED-PROCESSES STOPED : Msg sent from MAS/send_clring_clr2mas.tcl and script did not run" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PREVIOUS PROCESS NOT COMPLETED" clearing@jetpay.com assist@jetpay.com
exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    if {[catch {set db_logon_handle [oralogon masclr/masclr@masclr]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exec echo "ALL PROCESSES STOPED SINCE $result" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE :: PROCESS NOT COMPLETED" clearing@jetpay.com assist@jetpay.com
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



#Calling Procedure

chk_sts


puts "tigr: $tigr, cnt: $cnt, lp: $lp"
                                if {$cnt == 10} {
                                                set cdate [clock seconds]
                                                set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

                                                set sql4 "update tasks set run_hour = '', run_min = '' where institution_id = '447474'"
                                                orasql $lupdate $sql4
                                                puts "SERVER STATUS IS NOT IDLE after 20 munites at $cdate"
                                                exec echo "SERVER STATUS IS NOT IDLE after 20 munites: Tasks reseted to NULL at $cdate" | mailx -r clearing@jetpay.com -s "File xfer stoped because of server is BUSY Failed" clearing@jetpay.com assist@jetpay.com

                                                oracommit $db_logon_handle
                                                        if {[file exists /clearing/filemgr/process.stop]} {
                                                                exit 1
                                                        } else {
                                                                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
                                                        }

                                                exit 1

                                }




set x ""
set y ""
set i 0
set clearing ""
set fsize ""
catch {set x [exec find $clrpath/data/out/mas -mtime 0 | grep 447474.CLEARING.01*]} result

if {$x == ""} {
exec echo "NO FILE FOUND" | mailx -r clearing@jetpay.com -s "CLEARING file not found in MAS folder" clearing@jetpay.com assist@jetpay.com
catch {file delete /clearing/filemgr/process.stop} result
exit 1
}
if {[llength $x] >=  2} {
exec echo $x | mailx -r clearing@jetpay.com -s "Multiple CLEARING file found in MAS folder" clearing@jetpay.com assist@jetpay.com
foreach clrfile $x {
	set fsize [file size $clrfile]
	if {$fsize != 0} {
		exec cp -p [lindex $x $i] .
		set i [expr $i + 1]
		set clearing [string range [lindex $x 0] 55 end]
		puts "$clearing : Size = $fsize"
	} else { 
	exec echo "NOT xfered : $clrfile size $fsize" | mailx -r clearing@jetpay.com -s "CLEARING file $clrfile size is 0" clearing@jetpay.com assist@jetpay.com
	}	
}
}
if {[llength $x] ==  1} {
 set fsize [file size $x]
	if {$fsize != 0} {
		exec cp -p [lindex $x 0] .
		set i 1
	} else {
		exec echo "$clrfile size $fsize" | mailx -r clearing@jetpay.com -s "NO CLEARING file Xfered size 0" clearing@jetpay.com assist@jetpay.com

	}

	set clearing [string range [lindex $x 0] 55 end] 
	puts "$clearing : Size = $fsize"
}
exec chmod 775 $clearing

set dummy ""
set dummy1 ""
if {$i == 1} {
set dummy [exec cp -p $clearing $maspath/data/in/.]

if {$dummy != ""} {
exec echo $x | mailx -r clearing@jetpay.com -s "Files not transfered to MASADMIN" clearing@jetpay.com assist@jetpay.com
catch {file delete /clearing/filemgr/process.stop} result
exit 3
} else {
#exec echo "$x size $fsize" | mailx -r clearing@jetpay.com -s "Files transfered to MASADMIN" clearing@jetpay.com assist@jetpay.com
exec rm -f $clrpath/data/out/mas/$clearing
exec mv /clearing/filemgr/MAS/$clearing ARCHIVE

catch {file delete /clearing/filemgr/process.stop} result

set err ""
set err [exec /clearing/filemgr/MAS/updt_mas_task.tcl 100 clr2mas_xfer >> /clearing/filemgr/MAS/LOG/task.log]
if {$err != ""} { exec echo $err | mailx -r clearing@jetpay.com -s "ERROR ON EXECUTING updt_mas_task.tcl" clearing@jetpay.com assist@jetpay.com}
}
}
if {[file exists /clearing/filemgr/MAS/$clearing]} {
exec mv /clearing/filemgr/MAS/$clearing ARCHIVE
}

