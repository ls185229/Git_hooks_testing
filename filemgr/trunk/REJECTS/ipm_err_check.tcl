#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: ipm_err_check.tcl 3597 2015-12-01 21:27:00Z bjones $

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

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################


set logdate [clock seconds]
set day [string toupper [clock format $logdate -format "%a"]]
if {$day == "RHKMON"} {
set e_date [string toupper [clock format [clock scan "-2 day"] -format %d-%b-%y]]
} else {
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
}
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

### override e_date if valid argument is supplied
if { $argc > 0 &&  [catch {set e_date [clock format [clock scan [lindex $argv 0]] -format "%d-%b-%y"]} failure]} {
    puts "Argument [lindex $argv 0] could not be scanned as a date value.: $failure"
    exit 1
} else {
    ### we got here, the date scan of the argument worked.  Set the log date as well
    set logdate [clock format [clock scan [lindex $argv 0]] -format "%Y%m%d%H%M%S"]
}

#set adate [string toupper [clock format [ clock scan "0 day" ] -format "%d-%b-%y"]]
puts $e_date

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb

    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "Reject check code could not logon to DB : Msg sent from $env(PWD)/rejeck_chk.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db


connect_to_db


set get [oraopen $db_logon_handle]
set get1 [oraopen $db_logon_handle]
set get2 [oraopen $db_logon_handle]
set get3 [oraopen $db_logon_handle]
set get4 [oraopen $db_logon_handle]
set get20 [oraopen $db_logon_handle]
set get21 [oraopen $db_logon_handle]
set get22 [oraopen $db_logon_handle]

set outfile "Priorty.IPM.ERROR.Notification.Details.$logdate.txt"

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
}


#Pulling ems codes description and building an array for later use.

set s "select * from IPM_REJECT_MSG where src_file_ref_date >= '$e_date'"
set s "select irm.* from IPM_REJECT_MSG irm
join in_draft_main idm on idm.trans_seq_nbr = irm.trans_seq_nbr
join in_file_log ifl on ifl.in_file_nbr = idm.in_file_nbr
where trunc(ifl.incoming_dt) = '$e_date'"
puts $s

orasql $get $s

while {[set y [orafetch $get -dataarray mscd -indexbyname]] == 0} {

puts $fileid "REJECT\nTRANS_SEQ_NBR:	$mscd(TRANS_SEQ_NBR)\nFUNCTION_CODE:	$mscd(FUNCTION_CD)\nMSG_NBR:	$mscd(MSG_NBR)\nMSG_TEXT:	$mscd(MSG_TEXT)\n"
puts $fileid "-----------------------------------------------------------------------" 
puts "TRANS_SEQ_NBR:    $mscd(TRANS_SEQ_NBR)\nFUNCTION_CODE:    $mscd(FUNCTION_CD)\nMSG_NBR:    $mscd(MSG_NBR)\nMSG_TEXT:       [string range $mscd(MSG_TEXT) 0 4]\n"

}

close $fileid

if {[file size $outfile] == 0} {
	puts "NO IPM REJECT ALERT"
	exec rm $outfile
} else {
	set mbody "We have IPM error Rejects. Please, look in attachment and in Table IPM_REJECT_MSG for detail"
	exec mutt -a $outfile -s "IPM REJECT ALERT" clearing@jetpay.com < body1.txt
	after 500
	exec mv $outfile ARCHIVE/
}

