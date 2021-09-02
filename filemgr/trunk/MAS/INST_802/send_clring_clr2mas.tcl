#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
package provide random 1.0

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

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

###Script argument variable and check ################

set inst_id [string trim [lindex $argv 0]]
if {$argc != 1} {
   puts "Needs the INSTITUTION ID as argument to execute this script"
   exit 1
}

if {[file exists $env(PWD)/STOP/process.skip]} {
puts "logged: There is no transaction found. skipped process. DateTime: $logdate"
exit 0
}

###### Check previous process completed and no process.stop file genarated ##################

if {[file exists /clearing/filemgr/process.stop]} {
    set mbody "PREVIOUS PROCESS NOT COMPLETED-PROCESSES STOPED:\n process.stop file found at /clearing/filemgr/ \n Msg sent from send_clring_clr2mas.tcl and script did not run"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

##### Procedure to connect to DB ############

proc connect_to_db {} {
    global msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l
    global box clrpath maspath mailtolist mailfromlist clrdb authdb sysinfo
    global db_logon_handle db_connect_handle
    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
    set mbody "DB Connection Failed. \n A process.stop file genarated. \n ERROR: \n\n $result"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db

##### Opening connection to DB ######

connect_to_db

##### Some Variable Decleared ##############

set err ""
set tblnm_ifl "OUT_FILE_LOG"
set tblnm_fvc "FIELD_VALUE_CTRL"
set tigr 1
set cnt 0
set lp 1
global get
global lupdate
global tblnm_fvc
set cnt 0
set tigr 1
set lp 0


#### Setting up connection cursors ############

set get [oraopen $db_logon_handle]
set lupdate [oraopen $db_logon_handle]


#####Procedure for Checking CS server status #########

proc chk_sts {} {
global msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l
global sysinfo box clrpath maspath mailtolist mailfromlist clrdb authdb
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



#######Calling Server Check Procedure ###############

chk_sts

###### Printing all the triggers for debuging #############

puts "tigr: $tigr, cnt: $cnt, lp: $lp"

##### Checking Server status for 20 minutes to see if it goes to IDLE from BUSY ##############

                                if {$cnt == 10} {
                                                set cdate [clock seconds]
                                                set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]

                                                set sql4 "update tasks set run_hour = '', run_min = '' where institution_id = '$inst_id'"
                                                orasql $lupdate $sql4
                                                puts "SERVER STATUS IS NOT IDLE after 20 munites at $cdate"
                        set mbody "SERVER STATUS IS NOT IDLE after 20 munites: Tasks reseted to NULL at $cdate \n File xfer stoped because of server is BUSY"
                        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist

                                                oracommit $db_logon_handle
                                                        if {[file exists /clearing/filemgr/process.stop]} {
                                                                exit 1
                                                        } else {
                                                                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
                                                        }

                                                exit 1

                                }



##### More variables Decleared ##########

set x ""
set y ""
set i 0
set clearing ""
set fsize ""

###### Looking for exported CLEARING FILE ###################


catch {set x [exec find $clrpath/data/out/mas -name $inst_id.CLEARING.01* -atime 0]} result


##### Few Checks done below such as if file exist or mutiple file exist or 0 byte file exist and action taken according to the findings. ######

if {$x == ""} {
    catch {file delete /clearing/filemgr/process.stop} result
    set mbody "NO FILE FOUND $result \n CLEARING file not found in MAS folder \n Code location:\n $env(PWD)"
#RHK#
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" clearing@jetpay.com
#$mailtolist
    exit 0
}

if {[llength $x] >=  2} {

  set mbody "Multiple CLEARING file found in MAS folder\n $x"
  exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist

  foreach clrfile $x {
    set fsize [file size $clrfile]
    if {$fsize != 0} {
        exec cp -p [lindex $x $i] .
        set i [expr $i + 1]
        set clearing [string range [lindex $x 0] 55 end]
        puts "$clearing : Size = $fsize"
    } else {
        set mbody "Multiple MAS file Found.\n NOT xfered : $clrfile size $fsize"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
    }
  }
}

if {[llength $x] ==  1} {
 set fsize [file size $x]
puts $x
    if {$fsize != 0} {
        exec cp -p [lindex $x 0] .
        set getfile 1
    } else {
        set mbody "NOT xfered : $x size $fsize"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
    }

    set clearing [string range [lindex $x 0] 55 end]
    puts "$clearing : Size = $fsize"
}
exec chmod 775 $clearing

set dummy ""
set dummy1 ""

#################################################################################################################################
##### Set getfile to 1 in order to move file to MASADMIN for MAS import or set it to fail to stop transfer to MASADMIN. #########
#################################################################################################################################

if {$getfile == 1} {

   set dummy [exec cp -p $clearing $maspath/data/in/.]

    if {$dummy != ""} {
        set mbody "Files not transfered to MASADMIN: \n $x"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        catch {file delete /clearing/filemgr/process.stop} result
        exit 3
    } else {
#       set mbody "Files transfered to MASADMIN \n $x size $fsize"
#       exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
        exec rm -f $clrpath/data/out/mas/$clearing
        exec mv $env(PWD)/$clearing ARCHIVE
        catch {file delete /clearing/filemgr/process.stop} result
        set err ""
        set err [exec $env(PWD)/sch_cmd.tcl $inst_id 100 >> $env(PWD)/LOG/task.log]
            if {$err != ""} {
                set mbody "ERROR ON EXECUTING sch_cmd.tcl: \n $err"
                exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
            }
    }
}

##################################################################################################################################

if {[file exists $env(PWD)/$clearing]} {
    exec mv $env(PWD)/$clearing ARCHIVE
    exec rm -f $clrpath/data/out/mas/$clearing
}

