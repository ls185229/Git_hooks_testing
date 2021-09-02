#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

##################################################################################



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

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

####################################################################################################################

package require Oratcl

#declearing variables for commandline arguments.

set box "$env(SYS_BOX)"

#declearing all the date format required.

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set curdate [clock seconds]
set curtime [clock format $curdate -format "%H%M%S"]
set curdate [clock format $curdate -format "%Y%m%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]


proc connect_to_db {} {
    global db_logon_handle db_connect_handle box clrdb
    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
    }
};# end connect_to_db

#Opening connection handle to DB

connect_to_db

#Decleared few variables 

global get
global lupdate
set get [oraopen $db_logon_handle]
set lupdate [oraopen $db_logon_handle]


		set sql3 "select count(1) susct from MAS_TRANS_ERROR"
puts $sql3
		orasql $lupdate $sql3	  
orafetch $lupdate -dataarray suscnt -indexbyname

if {$suscnt(SUSCT) == 0} {
        puts "Mas trans error count is $suscnt(SUSCT)"
} else {
	puts "Mas trans error count is $suscnt(SUSCT)"
	exec echo "Trnasaction found in MAS_TRANS_ERROR : count $suscnt(SUSCT)" >> /clearing/filemgr/process.stop
	set mbody "A process.stop file generated in /clearing/filemgr/. \nACH and all Process stopped.\n Trnasaction found in MAS_TRANS_ERROR : count $suscnt(SUSCT)"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}

                set sql3 "select count(1) susct from MAS_TRANS_SUSPEND"
puts $sql3
                orasql $lupdate $sql3
orafetch $lupdate -dataarray suscnt -indexbyname

if {$suscnt(SUSCT) == 0} {
        puts "Suspended count is $suscnt(SUSCT)"
} else {
	 set mbody "A process.stop file generated in /clearing/filemgr/. \nACH and all Process stopped.\n Trnasaction found in MAS_TRANS_SUSPEND : count $suscnt(SUSCT)"
	exec echo "Trnasaction found in MAS_TRANS_SUSPEND : count $suscnt(SUSCT)" >> /clearing/filemgr/process.stop
        puts "Suspended count is $suscnt(SUSCT)"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}

