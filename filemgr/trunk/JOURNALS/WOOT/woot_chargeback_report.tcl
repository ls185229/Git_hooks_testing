#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: woot_chargeback_report.tcl 2612 2014-05-12 21:24:35Z mitra $
# $Rev: 2612 $
################################################################################

################################################################################
#
#    File Name   - woot_chargeback_report.tcl
#
#    Description - This s a custom report for woot to help them match 
#                  chargebacks to their transactions.
#
#    Arguments   - $1 Date to run the report.  If no argument, then defaults to 
#                  today's date.  EX.  -d 20130204
#
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

package require Oratcl

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
   global Shortname_list

   set cfg_file_name woot.cfg

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
         "SHORTNAME_LIST" {
            set Shortname_list [lindex $line_parms 1]
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

##########################################
# connect_to_db
# handles connections to the database
##########################################

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
        puts "Connected auth_db"
   }
   if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
   } else {
        puts "Connected clr_db"
   }
}

#####################################
# decode_cb
# transalates CB reason codes
#####################################

proc decode_cb {} {
    global reason_code
      switch -exact -- $reason_code {
         "30" {set message "Service not provided or merchandise not received"}
         "41" {set message "Cancel Recurring transaction"}
         "53" {set message "Not as described or defective merchandise"}
         "57" {set message "Fradualent multiple transactions"}
         "60" {set message "Illegal fulfillment"}
         "62" {set message "Counterfiet transasction"}
         "70" {set message "Card recovery bulletin"}
         "71" {set message "Declined authorization"}
         "72" {set message "No authorization"}
         "73" {set message "Expired Card"}
         "74" {set message "Late presentment"}
         "75" {set message "Transaction not recognized"}
         "76" {set message "Incorrect Currency or Transaction Code or Domestic Transaction Processing Violation"}
         "77" {set message "Non-Matching Account Number"}
         "78" {set message "Service Code Violation"}
         "80" {set message "Incorrect Transaction Amount or Account Number"}
         "81" {set message "Fraud . Card-Present Environment"}
         "82" {set message "Duplicate Processing"}
         "83" {set message "Fraud . Card-Absent Environment"}
         "85" {set message "Credit Not Processed"}
         "86" {set message "Paid by Other Means"}
         "90" {set message "Non-Receipt of Cash or Load Transaction Value at ATM or Load Device"}
         "93" {set message "Merchant Fraud Performance Program"}

         "4502" {set message "Requested item illegible"}
         "4534" {set message "Duplicate Processing"}
         "4535" {set message "Card Not Valid or Expired"}
         "4540" {set message "Fraud Dispute"}
         "4541" {set message "Automatic Payment Dispute"}
         "4542" {set message "Late Presentment"}
         "4550" {set message "Credit Posted as Card Sale"}   
         "4553" {set message "Quality of Goods or Services Dispute"}               
         "4554" {set message "Not Classified"}
         "4555" {set message "Additional Credit Requested"}
         "4563" {set message "Non Reponse"}        
         "4584" {set message "Missing Signature"}
         "4586" {set message "Altered Amount Dispute"}

         "4750" {set message "Airline Transaction Dispute"}
         "4751" {set message "Cash Advance Dispute"}
         "4752" {set message "Declined Authorization"}
         "4753" {set message "Invalid Card Number"}         
         "4754" {set message "No Authorization"}         
         "4755" {set message "Non-receipts of Goods or Services"}
         "4756" {set message "Stored Value Dispute"}
         "4757" {set message "Violation of Operating Regulations"}

         "4801" {set message "Requested Transaction Data Not Received"}
         "4802" {set message "Requested item illegible"}
         "4807" {set message "Warning Bulletin File"}
         "4808" {set message "Requested/Required Authorization Not Obtained"}
         "4812" {set message "Account Number Not on File"}
         "4831" {set message "Transaction Amount Differs"}
         "4834" {set message "Duplicate Processing"}
         "4835" {set message "Card Not Valid or Expired"}
         "4837" {set message "Fraudulent Mail/Phone Order Transaction"}
         "4840" {set message "Fraudulent Processing of Transactions"}
         "4841" {set message "Canceled Recurring Transaction"}
         "4842" {set message "Late Presentment"}
         "4847" {set message "Exceeds Floor Limit, Not Authorized, and Fraud Transactions"}
         "4849" {set message "Questionable Merchant Activity"}
         "4850" {set message "Credit Posted as a Debit"}
         "4853" {set message "Cardholder Dispute Defective/Not as Described"}
         "4854" {set message "Cardholder Dispute-Not Elsewhere (U.S. only)"}
         "4855" {set message "Non-receipt of Merchandise"}
         "4859" {set message "Services Not Rendered"}
         "4860" {set message "Credit Not Processed"}
         "4862" {set message "Counterfeit Transaction Magnetic Stripe POS Fraud"}
         "4863" {set message "Cardholder Does Not Recognize - Potential Fraud"}

         "7030" {set message "Request Transaction Documentation for Card   Not Present Card Transaction"}

         default { set message "Unknown message"}
      }
   return $message
}

puts ""
puts "woot_chargeback_report.tcl Started"

set v_tid      "'010103015101','010103015102','010103015301','010103015302'"
set v_merch_id "'402529211000143','402529211000182','402529211000199','402529211000202',
                '402529211000192','447474200000483','447474200000484'" 

#scan for Date
if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
      puts "Date argument: $arg_date"
      set date_arg $arg_date
}

if {![info exists date_arg]} {
      set today_date [clock format [clock scan "-0 day"] -format %d-%b-%Y]
      set query_date "activity_dt >= '$today_date'" 
} else {
      set today_date    [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
      set tomorrow_date [clock format [clock scan " $date_arg +1 day"] -format %d-%b-%Y]
      set query_date    "activity_dt >= '$today_date' and activity_dt < '$tomorrow_date'"
}

set fileName "Woot-Chargeback-$today_date.xls"

readCfgFile

connect_to_db

set auth_sql [oraopen $auth_logon_handle]

set mas_sql [oraopen $mas_logon_handle]

set body "Merchant Name	Original Amount	Chargeback Amount	Authorization time	ARN	Transaction ID	Processor Case	Account Number	Error code	Error Message\r\n"


##########################################
#              Fetch rows
##########################################

proc fetchRow {} {
     global auth_sql mas_sql Query_sql reason_code body
     
     orasql $mas_sql $Query_sql

     while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
             set Query_sql "select amount, authdatetime, transaction_id, long_name 
                            from tranhistory t, merchant m 
                            where m.mid = t.mid and arn = '$mas_query(ARN)'"
             
             orasql $auth_sql $Query_sql
             
             orafetch $auth_sql -dataarray auth_query -indexbyname

             set reason_code $mas_query(REASON_CD)

             append body "$auth_query(LONG_NAME)	$auth_query(AMOUNT)	$mas_query(AMT_RECON)	$auth_query(AUTHDATETIME)	\'$mas_query(ARN)"
             append body "	\'$auth_query(TRANSACTION_ID)	$mas_query(TRANS_SEQ_NBR)	$mas_query(MERCH_ID)	$mas_query(REASON_CD)	[decode_cb]\r\n"
     }
}


################
####  VISA  ####
################

global Query_sql body

set Query_sql "select substr(idm.pan,0,6)||'******'||substr(idm.pan,13,4) as pan,
                      idm.arn,
                      idm.trans_seq_nbr,
                      idm.merch_id,
                      ae.entity_dba_name as merch_name,
                      idm.amt_recon/100 as amt_recon,
                      vs.mbr_msg_txt,
                      ep.reason_cd
               from in_draft_main idm,
                      visa_adn vs,
                      ep_event_log ep,
                      acq_entity ae
               where tid in ($v_tid)
                     and idm.merch_id in ($v_merch_id)
                     and $query_date
                     and ae.entity_id = idm.merch_id
                     and ep.trans_seq_nbr = idm.trans_seq_nbr
                     and vs.trans_seq_nbr = idm.trans_seq_nbr"

fetchRow

######################
####  MASTERCARD  ####
######################

global Query_sql body

set Query_sql "select substr(idm.pan,0,6)||'******'||substr(idm.pan,13,4) as pan,
                      idm.arn,
                      idm.trans_seq_nbr,
                      idm.merch_id,
                      ae.entity_dba_name as merch_name,
                      idm.amt_recon/100 as amt_recon,
                      em.msg_text,
                      ep.reason_cd
               from in_draft_main idm,
                      in_draft_emc em,
                      acq_entity ae,
                      ep_event_log ep
               where tid in ($v_tid)
                      and idm.merch_id in ($v_merch_id)
                      and ae.entity_id = idm.merch_id
                      and $query_date
                      and ep.trans_seq_nbr = idm.trans_seq_nbr
                      and em.trans_seq_nbr = idm.trans_seq_nbr"

fetchRow

####################
####  DISCOVER  ####
####################

global Query_sql body

set Query_sql "select substr(idm.pan,0,6)||'******'||substr(idm.pan,13,4) as pan,
                      idm.arn,
                      idm.trans_seq_nbr,
                      idm.merch_id,
                      ae.entity_dba_name as merch_name,
                      idm.amt_recon/100 as amt_recon,
                      ep.reason_cd
               from in_draft_main idm,
                      acq_entity ae,
                      ep_event_log ep
               where tid in ($v_tid)
                      and idm.merch_id in ($v_merch_id)
                      and ae.entity_id = idm.merch_id
                      and $query_date
                      and idm.trans_seq_nbr = ep.trans_seq_nbr
                      and idm.card_scheme = '08'"

fetchRow

exec echo $body > $fileName

exec mutt -a $fileName -s "WOOT Chargeback Report $today_date" -- Reports-clearing@jetpay.com < $fileName

exit 0 
