#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
package require Oratcl

proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    if {[catch {set db_logon_handle [oralogon teihost/quikdraw@transbpk]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
    }
};# end connect_to_db

connect_to_db

set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
puts "-----------NEW LOG------------------- $curdate ---------"

set sname [lindex $argv 0]

set tblnm_cap "CAPTURE"
set tblnm_set "SETTLEMENT"
set tblnm_mer "MERCHANT"
set tblnm_mm "MASTER_MERCHANT"
set linsert [oraopen $db_logon_handle]
set lupdate [oraopen $db_logon_handle]
set ldelete [oraopen $db_logon_handle]

set insert_sql "insert into $tblnm_set select mid, tid, transaction_id, request_type, transaction_type, cardnum, exp_date, amount, orig_amount, incr_amount, fee_amount, tax_amount,process_code, status, authdatetime, auth_timer, auth_code, auth_source, action_code, shipdatetime, ticket_no, network_id, addendum_bitmap, capture, pos_entry, card_id_method, retrieval_no, avs_response, aci, cps_auth_id, cps_tran_id, cps_validation_code, currency_code, clerk_id, shift, hub_flag, billing_type, batch_no, item_no, other_data, settle_date, card_type, cvv, pc_type, currency_rate, other_data2, other_data3, other_data4, 'sysdate' from $tblnm_cap where mid in (select mid from $tblnm_mer where mmid in (select mmid from $tblnm_mm where shortname = '$sname')) and status='N'"
orasql $linsert $insert_sql

set updt_sql "update $tblnm_set set retrieval_no = to_char(sysdate,'YYMMDD')||substr('000000'||rownum,-6,6) where retrieval_no = ' ' and mid in (select mid from $tblnm_mer where mmid in (select mmid from $tblnm_mm where shortname = '$sname'))"
orasql $lupdate $updt_sql

oracommit $db_logon_handle

puts "Transaction move complete"

set chk "select count(amount) CNT from $tblnm_set where mid in (select mid from $tblnm_mer where mmid in (select mmid from $tblnm_mm where shortname = '$sname'))"
puts $chk
orasql $lupdate $chk
orafetch $lupdate -dataarray x -indexbyname
puts $x(CNT)

if {$x(CNT) == 0} {

exec echo "No transaction in settlement for $sname" | mailx -r filemgr@jetpay.com -s "TC57 file did not run" clearing@jetpay.com 
exit 1
} else {
set del_sql "delete from $tblnm_cap where mid in (select mid from $tblnm_mer where mmid in (select mmid from $tblnm_mm where shortname = '$sname'))"
puts $del_sql
#orasql $ldelete $del_sql
oracommit $db_logon_handle
exec tc57_maker_v13.tcl-test 100.tc57 JTPYTEST 447474 526309 >> TC57log.txt

}

oracommit $db_logon_handle

