#!/usr/bin/env tclsh

################################################################################
# $Id: reject-email-loader.tcl 4080 2017-03-02 20:11:41Z bjones $
################################################################################

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

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Get the DB variables
#
#    Arguments -
#
#    Return -
#
###############################################################################
proc readCfgFile {} {
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db


   set cfg_file_name REJECTS.cfg

   set clr_db_logon ""
   set clr_db ""
   set auth_db_logon ""
   set auth_db ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB" {
            set auth_db [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 2
   }

}


################################################################################

#################################
# connect_to_db
#  handles connections to the database
#################################

proc connect_to_db {} {
    global auth_logon_handle mas_logon_handle
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db


                if {[catch {set auth_logon_handle [oralogon $auth_db_logon@$auth_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "Connected"
                }
                if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "Connected"
                }

};# end connect_to_db


################################################################################


set tcl_precision 17

package require Oratcl

set auth_logon_handle ""

readCfgFile
connect_to_db

set auth_sql [oraopen $auth_logon_handle]
set clearing_sql [oraopen $mas_logon_handle]

set i 0

set Reject_query "select eel.institution_id as Inst
     , substr(in_draft_main.merch_id,1,15) as MerchID
     , substr(in_draft_main.merch_name,1,20) as MerchName
     , to_char(in_draft_main.trans_dt, 'dd-MON-yy') as TranDate
     , to_char(in_draft_main.activity_dt, 'dd-MON-yy') as SettleDate
     , substr(card_scheme.card_scheme_name,1,10) as CardType
     , substr(in_draft_main.pan,1,6)||'xxxxxx'|| substr(in_draft_main.pan,13,4) as PAN
     , in_draft_main.arn
     , in_draft_main.auth_cd as AuthCode
     , (in_draft_main.amt_trans/100) as Amount
     , substr(tid.description,1,30) as TranType
     , err_rcds.err_cd
     , err_rcds.err_msg
from in_draft_main
   , card_scheme
   , tid
   , ep_event_log eel
   , (select card_scheme, trans_seq_nbr, err_cd, err_msg
      from assoc_reject_msgs
         , ipm_reject_msg irm
      where err_cd = substr(msg_error_ind, 8, 4)
        and err_cd not in ('0566', '0521')
      union
      select visa_rtn_rclas_adn.card_scheme, visa_rtn_rclas_adn.trans_seq_nbr, err_cd, err_msg
      from visa_rtn_rclas_adn
         , assoc_reject_msgs
      where trim(return_reason_cd1) =  err_cd
      union
      select eel.card_scheme, trans_seq_nbr, arm.err_cd, arm.err_msg
      from ep_event_log eel
         , assoc_reject_msgs arm
      where eel.event_reason = 'ERET'
        and trim(to_char(eel.reason_cd, '0009')) = err_cd
      ) err_rcds
where in_draft_main.card_scheme = card_scheme.card_scheme
  AND in_draft_main.tid = tid.tid
  and in_draft_main.trans_seq_nbr = err_rcds.trans_seq_nbr(+)
  AND in_draft_main.tid like '010123005%'
  AND in_draft_main.trans_seq_nbr = eel.trans_seq_nbr"

set Clearing_sus_query "select substr(in_draft_main.src_inst_id,1,4) as Inst
     , substr(in_draft_main.merch_id,1,15) as MerchID
     , substr(in_draft_main.merch_name,1,20) as MerchName
     , to_char(in_draft_main.trans_dt, 'dd-MON-yy') as TranDate
     , to_char(in_draft_main.activity_dt, 'dd-MON-yy') as SettleDate
     , substr(card_scheme.card_scheme_name,1,10) as CardType
     , substr(in_draft_main.pan,1,6)||'xxxxxx'|| substr(in_draft_main.pan,13,4) as PAN
     , in_draft_main.arn
     , in_draft_main.auth_cd as AuthCode
     , in_draft_main.amt_trans/100 as Amount
     , substr(tid.description,1,30) as TranType
     , trans_err_cd
     , ec.description err_desc
 from in_draft_main
   , card_scheme
   , tid
   , trans_err_log tel
   , err_cd ec
where in_draft_main.card_scheme = card_scheme.card_scheme
  AND in_draft_main.tid = tid.tid
  and trans_err_cd not in ('ENR', 'CES007')
  and tel.trans_seq_nbr = in_draft_main.trans_seq_nbr
  and tel.trans_err_cd = ec.err_reason_cd(+)
  AND in_draft_main.trans_seq_nbr in (select trans_seq_nbr from suspend_log where suspend_status = 'S')
  AND in_draft_main.in_file_nbr in (select in_file_nbr
                                    from in_file_log
                                    where external_file_name like '%tc57%'"

set Mas_query "select substr(mas_trans_suspend.institution_id,1,4) as Inst
     , substr(mas_trans_suspend.entity_id,1,15) as MerchID
     , to_char(mas_trans_suspend.activity_date_time, 'dd-MON-yy') as ActivityDate
     , to_char(mas_trans_suspend.gl_date, 'dd-MON-yy') as GLDate
     , substr(card_scheme.card_scheme_name,1,10) as CardType
     , mas_trans_suspend.trans_ref_data as ARN
     , (mas_trans_suspend.amt_original) as Amount
     , substr(tid.description,1,30) as TranType
     , suspend_reason
from (select *
     from mas_trans_suspend
     union
     select *
     from mas_trans_suspend_wip) mas_trans_suspend
   , card_scheme
   , tid
where mas_trans_suspend.card_scheme = card_scheme.card_scheme
  AND mas_trans_suspend.tid = tid.tid"

#allows the rejects to be ran for a previous day.

if { [lindex $argv 0] == "" } {
  set clr_date_j [clock format [clock scan "-0 day"] -format %y%j ]
  set fileNameDate [clock format [clock scan "-0 day"] -format %m-%d-%Y]
  set Settle_date "[clock format [ clock scan "-1 day" ] -format %Y%m%d]050000"
  set sqldate [string toupper [clock format [clock scan "-0 day"] -format "%d-%b-%y"]]
  append Reject_query " and trunc(in_draft_main.activity_dt) = trunc(sysdate)"
  append Clearing_sus_query " and to_char(end_dt,'YYYYMMDDHH24MISS') > $Settle_date"
  append Mas_query " and trunc(suspend_date) = trunc(sysdate)"
} else {
  set the_date [clock scan [lindex $argv 0] -format "%Y%m%d"]
  set clr_date_j [clock format $the_date -format %y%j ]
  set fileNameDate [clock format $the_date -format %m-%d-%Y]
  set Settle_date "[clock format $the_date -format %Y%m%d]050000"
  set previous_date "[clock format [expr $the_date - 1] -format %Y%m%d]050000"
  set sqldate [string toupper [clock format $the_date -format "%d-%b-%y"]]
  append Reject_query " and trunc(in_draft_main.activity_dt) = '$sqldate'"
  #append Clearing_sus_query " and trunc(end_dt) ='$sqldate'"
  append Clearing_sus_query "and to_char(end_dt,'YYYYMMDDHH24MISS') < $Settle_date"
  append Clearing_sus_query "and to_char(end_dt,'YYYYMMDDHH24MISS') > $previous_date"
  append Mas_query " and trunc(suspend_date) = '$sqldate'"
}

append Mas_query " order by substr(mas_trans_suspend.institution_id,1,4),
         substr(mas_trans_suspend.entity_id,1,15)"

append Clearing_sus_query " and in_file_status like 'P%')
order by substr(in_draft_main.src_inst_id,1,4)
       , substr(in_draft_main.merch_id,1,15)
       , in_draft_main.card_scheme"

append Reject_query " order by  eel.institution_id,
          substr(in_draft_main.merch_id,1,15)"

puts "settle date:$Settle_date"

set fileExtension "_Rejects_and_suspends.xls"
set fileName "$fileNameDate$fileExtension"
puts $fileName

#Setting up the header for the file.
#This is the reject section

set error_flag 0
set body1 ""
set body2 ""
set Header1 "1.  The following are rejects for $Settle_date\r\n"
append Header1 " \r\n"
append Header1 "Inst ID\tMerch ID\tMerch Name\tTran Date\tSettle Date\tCard Type\tPan\tARN"
append Header1 "\tAuth Code\tAmount\tTrans Type\tErrr Code\tError Message\tResolution Date\tResolution Engineer\tResolution Notes\tReversed out of mas\r\n"

orasql $clearing_sql $Reject_query
while {[orafetch $clearing_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
    set error_flag 1
    append body "$SettlementQuery(INST)"
    append body "\t$SettlementQuery(MERCHID)\t$SettlementQuery(MERCHNAME)\t$SettlementQuery(TRANDATE)"
    append body "\t$SettlementQuery(SETTLEDATE)\t$SettlementQuery(CARDTYPE)\t$SettlementQuery(PAN)"
    append body "\t'$SettlementQuery(ARN)'\t$SettlementQuery(AUTHCODE)\t$SettlementQuery(AMOUNT)\t$SettlementQuery(TRANTYPE)"
    append body "\t$SettlementQuery(ERR_CD)\t$SettlementQuery(ERR_MSG)\r\n"
    puts "Loading $SettlementQuery(ARN) into reject tables"

    #Loading transactions from tranhistory into the reject table.

    set query_sql "select count(1) as COUNT from reject_processing where arn = '$SettlementQuery(ARN)'"
    orasql $auth_sql $query_sql
    orafetch $auth_sql -dataarray RejectQuery -indexbyname
    if {$RejectQuery(COUNT) < 1} {
        set insert_sql "Insert into reject_processing select * from teihost.tranhistory where arn = '$SettlementQuery(ARN)'"
        #puts $insert_sql
        #orasql $auth_sql $insert_sql
        set insert_sql "update reject_processing set status = 'XXX' where arn = '$SettlementQuery(ARN)'"
        #puts $insert_sql
        #orasql $auth_sql $insert_sql
    }
}
puts "Rejects processed"
append body " "
set Header2 "2.  The following transactions suspended.\r\n"
append Header2 " \r\n"
append Header2 "Inst ID\tMerch ID\tMerch Name\tTran Date\tSettle Date\tCard Type"
append Header2 "\tPan\tARN\tAuth Code\tAmount\tTrans Typ\tError code\tError Messagee\tResolution Date\tResolution Engineer\tResolution Notes\tReversed  outof MAS\r\n"

orasql $clearing_sql $Clearing_sus_query
while {[orafetch $clearing_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
    set error_flag 1
    append body1 "$SettlementQuery(INST)\t$SettlementQuery(MERCHID)\t$SettlementQuery(MERCHNAME)"
    append body1 "\t$SettlementQuery(TRANDATE)\t$SettlementQuery(SETTLEDATE)\t$SettlementQuery(CARDTYPE)"
    append body1 "\t$SettlementQuery(PAN)\t'$SettlementQuery(ARN)'\t$SettlementQuery(AUTHCODE)\t$SettlementQuery(AMOUNT)"
    append body1 "\t$SettlementQuery(TRANTYPE)\t$SettlementQuery(TRANS_ERR_CD)\t$SettlementQuery(ERR_DESC)\r\n"
}
puts "clearing suspends finished"
append body1 " "
set Header3 "3.  The following transactions suspended in MAS.\r\n"
append Header3 " \r\n"
append Header3 "Inst ID\tMerch ID\tActivity Date\tGL Date\tCard Type"
append Header3 "\tARN\tAmount\tTrans Typ\tError Messagee\tResolution Date\tResolution Engineer\tResolution Notes\tReversed out of MAS\r\n"

orasql $clearing_sql $Mas_query
while {[orafetch $clearing_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
    set error_flag 1
    append body2 "$SettlementQuery(INST)\t$SettlementQuery(MERCHID)"
    append body2 "\t$SettlementQuery(ACTIVITYDATE)\t$SettlementQuery(GLDATE)\t$SettlementQuery(CARDTYPE)"
    append body2 "\t'$SettlementQuery(ARN)'\t$SettlementQuery(AMOUNT)"
    append body2 "\t$SettlementQuery(TRANTYPE)\t$SettlementQuery(SUSPEND_REASON)\r\n"
}

exec echo $Header1 >> $fileName
exec echo $body >> $fileName
set body ""
exec echo "" >> $fileName
exec echo $Header2 >> $fileName
exec echo $body1 >> $fileName
exec echo "" >> $fileName
exec echo $Header3 >> $fileName
exec echo $body2 >> $fileName
exec echo "" >> $fileName

  exec mutt -a /clearing/filemgr/REJECTS/$fileName -s "ON-CALL SUMMARY FOR $Settle_date" \
    -- accounting@jetpay.com operations@jetpay.com notifications-clearing@jetpay.com < $fileName
oracommit $auth_logon_handle
  exec mv $fileName ARCHIVE

exit 0
