#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#added visa reject report to be email to clearing 20071120


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
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
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

set outfile "CB_Report"

set goback 120
set mgoback 121


set get [oraopen $db_logon_handle]
set get1 [oraopen $db_logon_handle]
set get2 [oraopen $db_logon_handle]
set get3 [oraopen $db_logon_handle]
set get4 [oraopen $db_logon_handle]
set get20 [oraopen $db_logon_handle]
set get21 [oraopen $db_logon_handle]
set get22 [oraopen $db_logon_handle]
set get23 [oraopen $db_logon_handle]

#Opening Output file to write to

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid1] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
}

set sql3 "select * from tid"
orasql $get3 $sql3

while {[set y [orafetch $get3 -dataarray t -indexbyname]] == 0} {

       set tid($t(TID)) $t(DESCRIPTION)

}

set sql2 "select * from in_draft_main where tid in (
'010103005301',
'010103005302',
'010103005303',
'010103005304',
'010103005305',
'010103005306',
'010103005307',
'010103005308',
'010103005309',
'010103005321',
'010103005501',
'010103005502',
'010103005401',
'010103005402',
'010103005403',
'010103005404',
'010103005405',
'010103005406',
'010103005407',
'010103005408',
'010103005409',
'010103005421',
'010103005601',
'010103005602',
'010103015301',
'010103015302',
'010103015303',
'010103015304',
'010103015305',
'010103015306',
'010103015307',
'010103015308',
'010103015309',
'010103015321',
'010103015501',
'010103015502',
'010103015201',
'010103015202',
'010103015203',
'010103015204',
'010103015205',
'010103015206',
'010103015207',
'010103015208',
'010103015209',
'010103015221',
'010103015401',
'010103015402',
'010103015403',
'010103015404',
'010103015405',
'010103015406',
'010103015407',
'010103015408',
'010103015409',
'010103015421',
'010103015601',
'010103015602'
)
and activity_dt >= sysdate - $goback and activity_dt <= sysdate" 

orasql $get2 $sql2

while {[set z [orafetch $get2 -dataarray r -indexbyname]] == 0} {

set rep($r(ARN)) "$r(AMT_TRANS),$tid($r(TID)),$r(ACTIVITY_DT)"

}

set sql4 "select * from mas_trans_log where tid in (
'010003005301',
'010003005302'
) and gl_date >= sysdate - $mgoback and gl_date  <= sysdate order by gl_date"

orasql $get4 $sql4

while {[set m [orafetch $get2 -dataarray m -indexbyname]] == 0} {

set mrep($m(TRANS_REF_DATA)) "$r(AMT_ORIGINAL),$tid($m(TID)),$m(GL_DATE)"

}





set sql1 "select tid,src_inst_id, merch_id,card_scheme,arn,amt_trans,activity_dt from in_draft_main where tid in (
'010103015101',
'010103015102',
'010103015103',
'010103015104',
'010103015105',
'010103015106',
'010103015107',
'010103015108',
'010103015109',
'010103015121')
and activity_dt >= sysdate - $goback and activity_dt <= sysdate order by activity_dt"

orasql $get1 $sql1


while {[set x [orafetch $get1 -dataarray a -indexbyname]] == 0} { 

catch {set val $rep($a(ARN))} chk


if {[string range $chk 0 9] != "can't read"} {

set results $chk

} else {

set results "Not Processed"

}

catch {set mval $mrep($a(ARN))} mchk


if {[string range $mchk 0 9] != "can't read"} {

set mresults $mchk

} else {

set mresults "Not Processed"

}

puts "$tid($a(TID)),$a(MERCH_ID),$a(CARD_SCHEME),$a(AMT_TRANS),$a(ACTIVITY_DT),$results,,$mresults"

}
