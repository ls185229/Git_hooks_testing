#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: mas_code_check.tcl 3420 2015-09-11 20:05:17Z bjones $
# $Rev: 3420 $
################################################################################
#
# File Name:  check_esquire_upload_files.tcl
#
# Description:  This program checks for successful file uploads to Esquire Bank.
#
# Script Arguments:  inst_id = Institution ID.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl


#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
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
set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set inst_id [lindex $argv 0]

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb
    global clruser clrpwd 

    if {[catch {set db_logon_handle [oralogon $clruser/$clrpwd@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
        puts "COnnected"
    }
};# end connect_to_db


connect_to_db

set logdate [clock seconds]
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
if {$argc == 2} {
set e_date [string toupper [clock format [ clock scan [lindex $argv 1]] -format "%d-%b-%y"]]
}
set curdate [clock format $logdate -format "%Y%m%d"]


set get [oraopen $db_logon_handle]
set l_update [oraopen $db_logon_handle]


set sql2 "update in_draft_main set mas_code =  \
				CASE \
					WHEN irfp = '49US360001BB' THEN '0104INTLMB' \
					WHEN irfp = '59US911000104021' THEN '0105IEI' \
                                        WHEN irfp = '59US911000104011' THEN '0105IEI' \
                                        WHEN irfp = '59US9110001031' THEN '0105IEI' \
					ELSE mas_code \
				END \
			WHERE in_file_nbr in
					(select in_file_nbr from in_file_log where
										end_dt like '$e_date%'
										and in_file_status in ('C','P')
										and institution_id = '$inst_id')
				and mas_code = 'MAS001'
				and nvl(trans_clr_status, 'NULL') <> 'S'"

puts $sql2

catch {orasql $l_update $sql2} result

set result1 [oramsg $l_update rows]

puts $result1

if {$result != 0} {
	set mbody "$sql2 \n failed to complete. \n $result"
	exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist

}

if {$result1 > 0} {
        set mbody "$sql2 \nnumber of  rows updated $result1\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
        puts "number of  rows updated $result1"
}

oracommit $db_logon_handle

set result ""
if {$inst_id == "101"} {

#set sql3 "update in_draft_baseii set REIMB_ATTRIB = '0' where trans_seq_nbr in (select trans_seq_nbr from in_draft_main where activity_dt like sysdate and src_inst_id = '101' and card_scheme = '04' and merch_id in ('447474310000100','447474310000102') and in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$e_date%' and in_file_status in ('C','P') and institution_id = $inst_id) and nvl(trans_clr_status, 'NULL') <> 'S') and REIMB_ATTRIB = 'J'"

set sql3 "update in_draft_baseii set REIMB_ATTRIB = '0'
where trans_seq_nbr
in (SELECT trans_seq_nbr
FROM in_draft_baseii
WHERE trans_seq_nbr IN
  (SELECT trans_seq_nbr
   FROM in_draft_main
   WHERE activity_dt LIKE '$e_date%'
   AND src_inst_id = '101'
   AND card_scheme = '04'
   AND merch_id IN('447474310000100',    '447474310000102')
   AND in_file_nbr IN
    (SELECT in_file_nbr
     FROM in_file_log
     WHERE end_dt LIKE '$e_date%'
     AND in_file_status IN('C',    'P')
     AND institution_id = '101')
  AND nvl(trans_clr_status,    'NULL') <> 'S')
AND reimb_attrib = 'J'

minus

select trans_seq_nbr from PASSEN_TRAN_ADN where trans_seq_nbr in (SELECT trans_seq_nbr
FROM in_draft_baseii
WHERE trans_seq_nbr IN
  (SELECT trans_seq_nbr
   FROM in_draft_main
   WHERE activity_dt LIKE '$e_date%'
   AND src_inst_id = '101'
   AND card_scheme = '04'
   AND merch_id IN('447474310000100',    '447474310000102')
   AND in_file_nbr IN
    (SELECT in_file_nbr
     FROM in_file_log
     WHERE end_dt LIKE '$e_date%'
     AND in_file_status IN('C',    'P')
     AND institution_id = '101')
  AND nvl(trans_clr_status,    'NULL') <> 'S')
AND reimb_attrib = 'J'))"

puts $sql3
catch {orasql $l_update $sql3} result
set result1 [oramsg $l_update rows]
puts $result1
if {$result != 0} {
        set mbody "$sql3 \n Failed\n [oramsg $l_update all]"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
}
if {$result1 > 0} {
        puts "number of  rows updated $result1"
	if {$result1 >= 100} {
	oraroll $db_logon_handle
	catch {exec echo "Number of rows with J = $result1" >> /clearing/filemgr/process.stop} err
        set mbody "REIMB_ATTRIB = 'J' is not updated to REIMB_ATTRIB = '0' in in_draft_baseII. Number of rows with J = $result1 which is >= threshold of 100. Update is rolled back."
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
	} else {
	set mbody "REIMB_ATTRIB = 'J' updated to REIMB_ATTRIB = '0' in in_draft_baseII. Number of rows updated = $result1"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
	}
}

}

if {$inst_id == "107"} {

set sql6 "update VISA_ADN set MOTO_E_COM_IND = '7' where trans_seq_nbr in \
(select trans_seq_nbr from in_draft_baseii where trans_seq_nbr in \
(select trans_seq_nbr from in_draft_main where merch_id = '454045274000183' and src_inst_id = '107' and card_scheme = '04' and in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$e_date%') \
) and AUTH_CHARSTICS_IND = 'N' \
) and MOTO_E_COM_IND in ('5','6')"

puts $sql6

catch {orasql $l_update $sql6} result
set result1 [oramsg $l_update rows]
puts $result

if {$result1 > 0} {
        set mbody "$sql6 \n number of MOTO_E_COM_IND is $result1 for 454045274000183\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
        puts "number of  rows updated $result1"
}


}


oracommit $db_logon_handle


# before April 16, 2010, VI -> VIR
# as of April 16, 2010, country code 850, state of ' ', ' ' -> VIR
puts "Updating VI state code to VIR country code for Discover transactions."
set update_virgin_islands_state_code "update in_draft_main
set MERCH_PROV_STATE =
case
when MERCH_PROV_STATE = 'VI' then 'VIR'
when merch_cntry_cd_num = '850' then 'VIR'
end
where card_scheme = '08'
and
(merch_cntry_cd_num in ('850') or MERCH_PROV_STATE in ('VI'))
and in_file_nbr in
(select in_file_nbr from in_file_log where end_dt like '$e_date%' and institution_id = '$inst_id')"

if { [ catch { orasql $l_update $update_virgin_islands_state_code } failure ] } {
    set mbody "Could not execute $update_virgin_islands_state_code: $failure\n"
    exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
} else {
    set rows_updated [oramsg $l_update rows]
    if { $rows_updated > 0 } {
        set mbody "Updated $rows_updated rows for institution $inst_id.  State code changed to VIR country for Discover transactions prior to export.\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
    }
    if { [catch {oracommit $db_logon_handle} failure] } {
        set mbody "Could not commit changes: $failure\n"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
    }
}
puts "Discover VI state code update finished."


# before April 16, 2010, PR -> PRI
# as of April 16, 2010, country code 630, state of ' ', ' ' -> PRI
puts "Updating PR state code to PRI country code for Discover transactions."
set update_puerto_rico_state_code "update in_draft_main
set MERCH_PROV_STATE =
case
when MERCH_PROV_STATE = 'PR' then 'PRI'
when merch_cntry_cd_num = '630' then 'PRI'
end
where card_scheme = '08'
and
(merch_cntry_cd_num in ('630') or MERCH_PROV_STATE in ('PR'))
and in_file_nbr in
(select in_file_nbr from in_file_log where end_dt like '$e_date%' and institution_id = '$inst_id')"

if { [ catch { orasql $l_update $update_puerto_rico_state_code } failure ] } {
    set mbody "Could not execute $update_puerto_rico_state_code: $failure\n"
    exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
} else {
    set rows_updated [oramsg $l_update rows]
    if { $rows_updated > 0 } {
        set mbody "Updated $rows_updated rows for institution $inst_id.  State code changed to PRI country for Discover transactions prior to export.\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
    }
    if { [catch {oracommit $db_logon_handle} failure] } {
        set mbody "Could not commit changes: $failure\n"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
    }
}
puts "Discover PR state code update finished."



# before April 16, 2010, GU -> GUM
# as of April 16, 2010, country code 316, state of ' ', ' ' -> GUM
puts "Updating GU state code to GUM country code for Discover transactions."
set update_guam_state_code "update in_draft_main
set MERCH_PROV_STATE =
case
when MERCH_PROV_STATE = 'GU' then 'GUM'
when merch_cntry_cd_num = '316' then 'GUM'
end
where card_scheme = '08'
and
(merch_cntry_cd_num in ('316') or MERCH_PROV_STATE in ('GU'))
and in_file_nbr in
(select in_file_nbr from in_file_log where end_dt like '$e_date%' and institution_id = '$inst_id')"

if { [ catch { orasql $l_update $update_guam_state_code } failure ] } {
    set mbody "Could not execute $update_guam_state_code: $failure\n"
    exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
} else {
    set rows_updated [oramsg $l_update rows]
    if { $rows_updated > 0 } {
        set mbody "Updated $rows_updated rows for institution $inst_id.  State code changed to GUM country for Discover transactions prior to export.\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
    }
    if { [catch {oracommit $db_logon_handle} failure] } {
        set mbody "Could not commit changes: $failure\n"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
    }
}
puts "Discover GUM state code update finished."



puts "Updating reimb_attrib = K to 0 where MCC = 5411 for card_scheme 04"

set updt_reimb_attrib "update in_draft_baseii set reimb_attrib = '0' WHERE trans_seq_nbr IN (SELECT trans_seq_nbr FROM in_draft_main WHERE in_file_nbr IN  (SELECT in_file_nbr   FROM in_file_log   WHERE end_dt LIKE '$e_date%' AND file_type = '01' and institution_id = '$inst_id'  AND mcc = '5411' and card_scheme = '04')) AND reimb_attrib = 'K'"

if { [ catch { orasql $l_update $updt_reimb_attrib } failure ] } {
    set mbody "Could not execute $updt_reimb_attrib: $failure\n"
    exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
} else {
    set rows_updated [oramsg $l_update rows]
    if { $rows_updated > 0 } {
        set mbody "Updated $rows_updated rows for institution $inst_id. reimb_attrib = K to 0 where MCC = 5411 for card_scheme 04.\n"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com
    }
    if { [catch {oracommit $db_logon_handle} failure] } {
        set mbody "Could not commit changes: $failure\n"
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" clearing@jetpay.com
    }
}

puts "reimb_attrib = K to 0 where MCC = 5411 for card_scheme 04 update finished"





set sql1 "select count(1) from in_draft_main where mas_code = 'MAS001' and card_scheme in ('04','05') and msg_type in ('500','600') and in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$e_date%' and in_file_status in ('C','P') and institution_id = '$inst_id') and nvl(trans_clr_status, 'NULL') <> 'S'"
puts $sql1
orasql $get $sql1

catch {orafetch $get -datavariable mscd} result

if {$result != 0} {
        set mbody "$sql1 \n failed to complete. \n $result"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist

}
puts [lindex $mscd 0]
if {[lindex $mscd 0] != 0} {
set mbody "We have MAS001 mas code assigned in in_draft_main. Count = $mscd"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        puts "count $mscd"
} else {
puts "We are good"
}



oralogoff $db_logon_handle
