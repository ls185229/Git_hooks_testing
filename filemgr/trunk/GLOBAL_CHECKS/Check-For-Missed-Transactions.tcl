#!/usr/bin/env tclsh
# Script to pull the TSYS CDF file apart
# At present only pulls the merchant header record for
# research for boarding and clearing

# $Id: Check-For-Missed-Transactions.tcl 3420 2015-09-11 20:05:17Z bjones $

# Version 0.0 01/23/12 Joe Cloud

# Strip leading zeros off of numbers, so that they are not
# interpredted to be OCTAL

#Environment Variables
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
set authdb $env(ATH_DB)

set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(IST_DB)

set UNIQUE_ID_COUNTER 1
set Settle_date [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set sqldate [string toupper [clock format [clock scan "-0 day"] -format "%d-%b-%y"]]
puts "settle date:$Settle_date"

set tcl_precision 17
set Email_body " "

package require Oratcl

set db_logon_handle ""
set Visa_ID ""

proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct

proc connect_to_db {} {
    global db_logon_handle mas_logon_handle
    global authuser authpwd authdb clruser clrpwd clrdb

                if {[catch {set db_logon_handle [oralogon $authuser/$authpwd@$authdb]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }
               if {[catch {set mas_logon_handle [oralogon $clruser/$clrpwd@$clrdb]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }
};# end connect_to_db




connect_to_db
set auth_sql [oraopen $db_logon_handle]
set second_auth_sql [oraopen $db_logon_handle]
set clearing_sql [oraopen $mas_logon_handle]
set second_clearing_sql [oraopen $mas_logon_handle]

set i 0

set error_flag 0
set body "TRANSACTION_ID,MID,AMOUNT"
set Tranhistory_Query_sql "Select transaction_id,mid,amount from settlement where card_type in ('VS','MC','DS','DB') and mid in (select mid from merchant where mmid in (select mmid from master_merchant where shortname in ('JETPAYIP','JETPAY','JETPAYSQ','PINNACLE','BANKCCTL','INBREVWW','JETPAYIS','SECUREBC'))) and other_data4 not in (select other_data4 from fraud_history where release_time like '$Settle_date%')"
orasql $auth_sql $Tranhistory_Query_sql
while {[orafetch $auth_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
  set error_flag 1
  set body "$body\r\n $SettlementQuery(TRANSACTION_ID), $SettlementQuery(MID), $SettlementQuery(AMOUNT)"

}
if {$error_flag == 1} {
  exec echo $body | mailx -s "Missed transactions in Settlement" clearing@jetpay.com reports-clearing@jetpay.com
}

set error_flag 0
set body "TRANSACTION_ID,MID,AMOUNT"
set Tranhistory_Query_sql "Select arn,transaction_id,mid,amount from Tranhistory where card_type in ('VS','MC','DS','DB') and mid in (select mid from merchant where mmid in (select mmid from master_merchant where shortname in ('JETPAYMD','JETPAYIP','JETPAY','JETPAYSQ','PINNACLE','BANKCCTL','INBREVWW','JETPAYIS','SECUREBC'))) and settle_date like '$Settle_date%' and arn is null"
orasql $auth_sql $Tranhistory_Query_sql
while {[orafetch $auth_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
  set error_flag 1
  set body "$body\r\n $SettlementQuery(TRANSACTION_ID), $SettlementQuery(MID), $SettlementQuery(AMOUNT)"
}
if {$error_flag == 1} {
  exec echo $body | mailx -s "Missed transactions in Tranhistory" clearing@jetpay.com reports-clearing@jetpay.com
}

set error_flag 0
set body "ARN,trans rec id"
set Tranhistory_Query_sql "Select arn,trans_rec_id from precs_transaction_detail where card_type in ('VS','MC','DS') and trans_dt like '$sqldate' and request_type not in ('0100','0200','0400') and arn is null"
orasql $second_clearing_sql $Tranhistory_Query_sql
while {[orafetch $second_clearing_sql -dataarray SettlementQuery -indexbyname] != 1403  } {
    set error_flag 1
    set body "$body\r\n $SettlementQuery(ARN),$SettlementQuery(TRANS_REC_ID)"
}
if {$error_flag == 1} {
  exec echo $body | mailx -s "ARN is null in PRECS" clearing@jetpay.com reports-clearing@jetpay.com
}

oracommit $db_logon_handle

exit 0
