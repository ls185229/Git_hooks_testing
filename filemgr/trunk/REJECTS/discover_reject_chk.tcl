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
set e_date [string toupper [clock format [ clock scan "-1 day" ] -format "%d-%b-%y"]]
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

set outfile "Priorty.DISC.REJECT.Notification.Details.$logdate.txt"

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
}


#Pulling ems codes description and building an array for later use.

set s "select * from EP_EVENT_LOG where event_log_date like '$e_date%' and card_scheme = '08'"
puts $s

orasql $get $s

puts $fileid "INSTITUTION_ID	TRANS_SEQ_NBR	TRANS_SEQ_NBR_ORIG	CARD_SCHEME	AMT_TRANS	ARN"

while {[set y [orafetch $get -dataarray mscd -indexbyname]] == 0} {

puts $fileid "$mscd(INSTITUTION_ID)	 		$mscd(TRANS_SEQ_NBR)	 	$mscd(TRANS_SEQ_NBR_ORIG)			$mscd(CARD_SCHEME)		$mscd(AMT_TRANS)		 $mscd(ARN)\n"

}

close $fileid

if {[file size $outfile] < 100} {
	puts "NO DISCOVER REJECT ALERT"
	exec rm $outfile
} else {
	set mbody "We have DISCOVER Rejects. Please, look in attachment and in Table DISCOVER_REJECT_MSG for detail"
	exec mutt -a $outfile -s "DISCOVER REJECT ALERT" notifications-clearing@jetpay.com < body1.txt
	after 500
	exec mv $outfile ARCHIVE/
}

