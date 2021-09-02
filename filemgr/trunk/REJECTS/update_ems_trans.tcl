#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: update_ems_trans.tcl 3597 2015-12-01 21:27:00Z bjones $

package require Oratcl


#######################################################################################################################

#Environment veriables.......

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
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts $e_date

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb sysinfo

    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "Reject check code could not logon to DB : Msg sent from $env(PWD)/rejeck_chk.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db


set tbl_ep_event_log "EP_EVENT_LOG"
set tbl_in_draft_main "IN_DRAFT_MAIN"


connect_to_db


set get [oraopen $db_logon_handle]
set updtepsts [oraopen $db_logon_handle]


proc chk_update_inst_id {} {
	global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb tbl_ep_event_log tbl_in_draft_main sysinfo e_date

	set getmi [oraopen $db_logon_handle]
	set updtmi [oraopen $db_logon_handle]
	set ERR_MSG "updated merchant id and name info"

		set get_mis_info "select unique \
				ep.institution_id, \
				ep.trans_seq_nbr, \
				ep.trans_seq_nbr_orig, \
                                idm.merch_id as IDM_MERCH_ID, \
                                ep.merch_id as EP_MERCH_ID, \
                                (select unique MERCH_ID from in_draft_main where trans_seq_nbr = ep.trans_seq_nbr_orig) as MERCH_ID, \
                                (select unique MERCH_NAME from in_draft_main where trans_seq_nbr = ep.trans_seq_nbr_orig) as MERCH_NAME, \
				(select unique substr(MERCH_ID, 1, 6) from $tbl_in_draft_main where trans_seq_nbr = ep.trans_seq_nbr_orig) as src_bin, \
				(select unique src_inst_id from $tbl_in_draft_main where trans_seq_nbr = ep.trans_seq_nbr_orig) as src_inst_id, \
				idm.arn, \
				ep.receive_id, \
				idm.PRI_DEST_INST_ID, \
				idm.PRI_DEST_FILE_TYPE, \
				idm.PRI_DEST_CLR_MODE, \
				idm.FORWARDING_INST_ID, \
				idm.RECEIVING_INST_ID, \
				idm.trans_dest, \
				ep.event_log_date, \
				ep.rowid as ep_rowid, \
				idm.rowid as idm_rowid \
				 from $tbl_ep_event_log ep, $tbl_in_draft_main idm \
				where  \
				ep.ems_item_type in ('CB1','CB2','RR1','RR2') \
				and ep.arn = idm.arn \
				and ep.trans_seq_nbr = idm.trans_seq_nbr \
                                and ep.event_log_date like '$e_date%' \
				and ep.institution_id = (select src_inst_id from $tbl_in_draft_main where trans_seq_nbr = ep.trans_seq_nbr_orig)"

		puts $get_mis_info
		orasql $getmi $get_mis_info

		set mbody ""
		set result ""
		set result1 ""
		set err_sqls ""

		while {[set mis [orafetch $getmi -dataarray mis_info -indexbyname]] == 0} {

		    if {$mis_info(MERCH_ID) != $mis_info(EP_MERCH_ID) && $mis_info(MERCH_ID) != $mis_info(IDM_MERCH_ID)} {
			set update_idm "update $tbl_in_draft_main set MERCH_ID = '$mis_info(MERCH_ID)' where rowid = '$mis_info(IDM_ROWID)'"
			catch {orasql $updtmi $update_idm} result
			set update_ep "update $tbl_ep_event_log set MERCH_ID = '$mis_info(MERCH_ID)' where rowid = '$mis_info(EP_ROWID)'"
			catch {orasql $updtmi $update_ep} result1
			if {$result != 0} {
			  set err_sqls "$err_sqls \n Err: $result \n $update_idm"
			}
			if {$result1 != 0} {
                          set err_sqls "$err_sqls \n Err: $result1 \n $update_ep"
                        }
			set mbody "$mbody \n $update_idm \n $update_ep"
                    }
		}
              
###	if $mbody != "" 
###	exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l - $ERR_MSG" clearing@jetpay.com 
###	
	if {$err_sqls != ""} {
	exec echo "$mbody_h $sysinfo $err_sqls" | mailx -r $mailfromlist -s "$msubj_h - sql update failed" clearing@jetpay.com
	}
}

### MAIN ####

chk_update_inst_id

oracommit $db_logon_handle

after 12000

set er_sqls ""
set result3 ""
set mbody ""

set stsusql "update ep_event_log set event_status = 'NEW' where institution_id = '108' and event_status = 'NOTIFY' and event_log_date like '$e_date%'"

puts $stsusql

catch {orasql $updtepsts $stsusql} result3

puts [oramsg $updtepsts rows]

                        if {$result3 != 0} {
                          set er_sqls "$er_sqls \n Err: $result3 \n $stsusql"
                        }

        if {$er_sqls != ""} {
        exec echo "$mbody_h $sysinfo $er_sqls" | mailx -r $mailfromlist -s "$msubj_h - sql update failed" clearing@jetpay.com
        }

set stsusql "update ep_event_log set event_status = 'NOTIFY' where institution_id <> '108' and event_status = 'NEW' and event_log_date like '$e_date%'"

puts $stsusql

catch {orasql $updtepsts $stsusql} result3

puts [oramsg $updtepsts rows]

                        if {$result3 != 0} {
                          set er_sqls "$er_sqls \n Err: $result3 \n $stsusql"
                        }

        if {$er_sqls != ""} {
        exec echo "$mbody_h $sysinfo $er_sqls" | mailx -r $mailfromlist -s "$msubj_h - sql update failed" clearing@jetpay.com
        }

oracommit $db_logon_handle
