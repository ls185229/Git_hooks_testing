#!/usr/bin/env tclsh
#/home/rkhan/.profile


set user [lindex $argv 0]
set pw [lindex $argv 1]

set user1 [lindex $argv 2]
set pw1 [lindex $argv 3]

set inst_id [lindex $argv 4]

set host "MASCLR"
set host1 "jpboarding"

set dbr "@trnclr1"
set dbt "@ttsett01"

if { $argc < 5 } {
   puts "5 arguments required to run script"
   puts "in order of: userid pw for core userid pw for efund intitution id"
   puts "try again please"
     exec echo "core_to_efund.tcl failed to run" | mailx -r teiprod@jetpay.com -s "CORE TO EFUND" rkhan@jetpay.com
     exit 
}

set currdate [clock seconds]
set currdate [clock format $currdate -format "%d/%b/%y"]
puts $currdate
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
set zt "01"
set xt [clock format [clock scan "next month"] -format "%Y%m"]
set dt $xt$zt
set yt [clock scan $dt]
set yt [clock format $yt -format "%d/%b/%y"]


#procedure for array
proc load_array {aname str lst} {
    upvar $aname a
    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string toupper [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array


package require Oratcl
package provide random 1.0

#Database login handle to ttsett01. 

if {[catch {set db_logon_handle [oralogon $user$dbt/$pw]} result]} {
        puts "ttset01 efund boarding failed to run"
        exit
}

#if {[catch {set db_logon_handle [oralogon $user@transb/$pw]} result]} {
#        puts "transr efund boarding failed to run"
#        exit
#}


#Database login handle to transr/efund

if {[catch {set db_login_handle [oralogon $user1$dbr/$pw1]} result]} {
        puts "$result : transr efund boarding failed to run"
        exit
}

#initialization of variables------

set failed 0

set crd_schm "NULL"
set cs_mer_id "NULL"
set clr_flg "*"
set pr_lin_flg "*"
set t_ind "*"
set allwid "1"
set calander_id "1"
set iata_no "555"
set addy2 ""
set sp_id 1
set sdate $yt
set country "UNITED STATES"
set ph1_ext ""
set ph2 ""
set cell ""
set prnt_id "447474000000000"
set c_date $currdate
set ex_date $currdate
set acct_date $currdate
set effdate $currdate
set act_date $currdate
set mcg_id ""
set state ""
set process_type "CP"
set strn "031101114"
set sacno "0011088518"


#Decleared variables for all database tables required to transfer data from db ttsett01.

set host_mmer "$host1.MASTER_MERCHANT"
set host_mer "jpboarding.MERCHANT"
set host_terminal "$host1.TERMINAL"


#Declared variables for all database tables required to transfer data to db transr.
#Tables for sequence control------------------------------------------------

set tblnm_seq_ctrl "$host.SEQ_CTRL$dbr"
set tblnm_g_seq_ctrl "$host.GLOBAL_SEQ_CTRL$dbr"

set host_province "$host.PROVINCE$dbr"
set host_country "$host.COUNTRY$dbr"


#Table group for Acq entity-------------------------------------------------
set TABLENAME "$host.ACQ_ENTITY_TBL"
set TABLENAME2 "$host.MASTER_ADDRESS_TBL"
set TABLENAME3 "$host.ACQ_ENTITY_ADDRESS_TBL"
set TABLENAME4 "$host.ACQ_ENTITY_CONTACT_TBL"
set TABLENAME5 "$host.MASTER_CONTACT_TBL"
set TABLENAME7 "$host.ALT_MERCHANT_ID_TBL"

#These needs to be setup for entity------------------------------------------------------

set tblnm_app "$host.ACCT_POSTING_PLAN_TEST$dbr"
set tblnm_ea "$host.ENTITY_ACCT_TBL"
set tblnm_efp "$host.ENTITY_FEE_PKG_TEST$dbr"
set tblnm_enfp "$host.ENT_NONACT_FEE_PKG_TEST$dbr"
set tblnm_allow "$host.ALLOWANCE_TEST$dbr"
set tblnm_fp "$host.FEE_PKG_TEST$dbr"
set tblnm_seq "$host.SEQ_CTRL_TBL"

#these needs to be setup for settlement-------------------------------------------------




#----------------------------------------------------------------------------

#Declared variables from orasql strings and opened db connections.

set insert_data [oraopen $db_login_handle]
set get_data [oraopen $db_logon_handle]
set seek_data [oraopen $db_login_handle]
set update_core [oraopen $db_logon_handle]
set update_efund [oraopen $db_login_handle]
set get [oraopen $db_login_handle]

set check_mer_exist [oraopen $db_login_handle]

# pulls merchant information from ttsett01
set pull_mer_from_mer [oraopen $db_logon_handle]

# pulls merchant contact info from ttsett01.
set pull_mer_cont_from_tbl [oraopen $db_login_handle]

#pulls address Id to check for duplicates
set test_id [oraopen $db_login_handle]

#inserts address information to efund DB.
set mas_addr_sql [oraopen $db_login_handle]

#inserts address information to efund DB.
set mas_cont_sql [oraopen $db_login_handle]

#inserts bin information to efund DB
set tt_bin_sql [oraopen $db_logon_handle]

#Pulls full state name and country code information and inserts into efund DB.
set get_state_from_ef [oraopen $db_login_handle]
set get_country_from_ef [oraopen $db_login_handle]

#pulls alt_merchant_id info from SOMEPLACE
#set pull_alt_m_id [oraopen $db_logon_handle]

#pulls contact name, phone no and email from tbl Master marchant and terminal
set pull_mer_no_from_ter [oraopen $db_logon_handle]
set pull_mer_cont2_from_mm [oraopen $db_logon_handle]

#Sql select statment to pull infromation from ttsett01 


orasql $pull_mer_from_mer "select MID,MMID,AUTH_STATUS,ACTIVE,LEGAL_NAME,DBA_NAME,REPORT_GROUP,ADDRESS1,ADDRESS2,CITY,STATE_CD,ZIP_CD,PHONE_NO,CUST_SERVICE,TECH_CONTACT_NO,MERCHANT_TYPE,SIC_CODE,FED_TAX_ID,BATCH_RECORD_FORMAT,PRE_PROCESS_BATCH,REJECT_RECYCLE_DAYS,REJECT_FORCEPOST,SETTLE_TIME,SETTLE_IMMEDIATE,SETTLE_REAUTH,VISA_ID,MASTERCARD_ID,DISCOVER_ID,DISCOVER_NSI,AMEX_SE_NO,DINERS_ID,JCB_ID,DEBIT_ID,OTHER_ID,ACQUIRING_ID,CURRENCY_CODE,COUNTRY,ACQUIRER_COUNTRY,CLIENT_BILL_CODE,AMEX_INVBATCH,AMEX_INVSUBCODE,PCARD_SUPPORT,CCARD_SUPPORT,NO_BATCH_PROCESSING,RETURNS_ALLOWED,SETTLE_MASTER_CARD,SETTLE_VISA,SETTLE_AMEX,SETTLE_DISCOVER,SETTLE_DINERS,SETTLE_JCB,SETTLE_DEBIT,SETTLE_OTHER,AVS_REJECT,CHARGE_DESCRIPTION,FRAUD_FLAG,FLAGS,BILL_ADDRESS1,BILL_ADDRESS2,BILL_CITY,BILL_STATE_CD,BILL_ZIP_CD,PUSH_RETURN,LAST_MODIFIED_DATE,LAST_MODIFIED_BY,MERCHANT_HASH,CONTACT_LAST_NAME,CONTACT_ADDRESS1,CONTACT_ADDRESS2,CONTACT_CITY,CONTACT_STATE_CD,CONTACT_ZIP_CD,CONTACT_PHONE,CONTACT_FAX,MAS_ACH_NAME,MAS_ACH_ROUTING,MAS_ACH_ACCOUNT,MAS_ACH_ACCOUNT_TYPE,ALT_CITY_DESCRIPTOR,CONTACT_FIRST_NAME,CONTACT_MIDDLE_NAME,CLR_STL_STATUS,REPORTING_STATUS,TICKETING_STATUS,MERCH_RISK_TYPE from $host_mer where CLR_STL_STATUS = 'AP'"


#Setting up colunm headers from the information pulled from ttsett01.merchant
set mer_cols [oracols $pull_mer_from_mer]


set process_typ { VISA_ID MASTERCARD_ID AMEX_SE_NO DISCOVER_ID DINERS_ID JCB_ID DEBIT_ID OTHER_ID }

#====================================================================================================

set yk 0
while {[set x [orafetch $pull_mer_from_mer -dataarray mid -indexbyname]] != 0} {

#Adding merchant info to an array
#load_array mid $x $mer_cols
orasql $check_mer_exist "select ENTITY_ID from $TABLENAME where ENTITY_ID = '$mid(VISA_ID)'"
set chk_mer [oracols $check_mer_exist]
orafetch $check_mer_exist -dataarray ch_m -indexbyname
puts $ch_m
if {$ch_m == ""} {


#pulling available address_id from efund seq_ctrl table
set sq_list { address_id contact_id entity_acct_id }

set addy_id ""
set cont_id ""
set e_acct_id ""
set ck 1

foreach sq_name $sq_list {
set get1 "select LAST_SEQ_NBR, MAX_SEQ_NBR from $tblnm_seq where institution_id = '$inst_id' and SEQ_NAME = '$sq_name'"
orasql $get $get1
set a_cols [oracols $get]
orafetch $get -datavariable x
load_array seq_ctl $x $a_cols

switch $sq_name {
        "address_id" {set addy_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
        "contact_id" {set cont_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
        "entity_acct_id" {set e_acct_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
}
if {$seq_ctl(MAX_SEQ_NBR) < $addy_id} {
puts "needs to increase max address sequence control number"
exit 1
}

if {$seq_ctl(MAX_SEQ_NBR) < $cont_id} {
puts "needs to increase max contact sequence control number"
exit 1
}
if {$seq_ctl(MAX_SEQ_NBR) < $e_acct_id} {
puts "needs to increase max e_acct_id sequence control number"
exit 1
}

if {$sq_name == "address_id"} {
set updt_sq "update $tblnm_seq set LAST_SEQ_NBR = '$addy_id' where institution_id = '$inst_id' and seq_name = 'address_id'"
set g_seq_sql "UPDATE $tblnm_g_seq_ctrl SET MAX_SEQ_NBR = '$addy_id' WHERE INSTITUTION_ID = '$inst_id' and SEQ_NAME = 'address_id'"
#orasql $update_efund $g_seq_sql
#orasql $get $updt_sq
}
if {$sq_name == "contact_id"} {
set updt_sq "update $tblnm_seq set LAST_SEQ_NBR = '$cont_id' where institution_id = '$inst_id' and seq_name = 'contact_id'"
set g_seq_sql "UPDATE $tblnm_g_seq_ctrl SET MAX_SEQ_NBR = '$cont_id' WHERE INSTITUTION_ID = '$inst_id' and SEQ_NAME = 'contact_id'"
#orasql $update_efund $g_seq_sql
#orasql $get $updt_sq
}
if {$sq_name == "entity_acct_id"} {
set updt_sq "update $tblnm_seq set LAST_SEQ_NBR = '$e_acct_id' where institution_id = '$inst_id' and seq_name = 'entity_acct_id
'"
#orasql $get $updt_sq
}

}
####################################################################################



#Matching full state name with state abbreviations.
orasql $get_state_from_ef "select PROVINCE_STATE from $host_province where PROV_STATE_ABBREV = '$mid(STATE_CD)' and CNTRY_CODE = '$mid(COUNTRY)'"
set state_cols [oracols $get_state_from_ef]
[orafetch $get_state_from_ef -datavariable st]
if {$oramsg(rc) == 1403} {
set pro_state(PROVINCE_STATE) ""
}
load_array pro_state $st $state_cols  

#Matching full state name with state abbreviations.
set get_cont_state_from_ef "select PROVINCE_STATE from $host_province where PROV_STATE_ABBREV = '$mid(STATE_CD)' and CNTRY_CODE = '$mid(COUNTRY)'"
orasql $seek_data $get_cont_state_from_ef
set cstate_cols [oracols $seek_data]
[orafetch $seek_data -datavariable cst]
if {$oramsg(rc) == 1403} {
set cont_pro_state(PROVINCE_STATE) ""
}
load_array cont_pro_state $cst $cstate_cols


#Matching Full conuntry name with country code.
orasql $get_country_from_ef "select CNTRY_NAME from $host_country where CNTRY_CODE = '$mid(COUNTRY)'"
set cntry_cols [oracols $get_country_from_ef]
[orafetch $get_country_from_ef -datavariable cntry]
if {$oramsg(rc) == 1403} {
set cntry_name(CNTRY_NAME) ""
}

load_array cntry_name $cntry $cntry_cols 

#Pulling BIN numbers for appropriate merchants.
orasql $tt_bin_sql "select BIN_NUMBER from $host_mmer where MMID = '$mid(MMID)'"
set bin_cols [oracols $tt_bin_sql]
[orafetch $tt_bin_sql -datavariable b]
load_array bin_num $b $bin_cols

#Adding Address information in MASTER_ADDRESS and ACQ_ENTITY_ADDRESS tables.
orasql $mas_addr_sql "INSERT INTO $TABLENAME2 (INSTITUTION_ID, ADDRESS1, ADDRESS2, CITY, PROV_STATE_ABBREV, PROVINCE_STATE, CNTRY_CODE, COUNTRY,POSTAL_CD_ZIP, ADDRESS_ID, PHONE1, PHONE2, FAX, EMAIL_ADDRESS, URL, ADDRESS3, ADDRESS4) VALUES ('$inst_id', '$mid(ADDRESS1)', '$mid(ADDRESS2)', '$mid(CITY)', '$mid(STATE_CD)', '$pro_state(PROVINCE_STATE)', '840', '$cntry_name(CNTRY_NAME)', '$mid(ZIP_CD)', '$addy_id', '$mid(CONTACT_PHONE)', NULL, '$mid(CONTACT_PHONE)', NULL, NULL, NULL, NULL)"

orasql $mas_addr_sql "INSERT INTO $TABLENAME3 (INSTITUTION_ID, ENTITY_ID, ADDRESS_ID, ADDRESS_ROLE, EFFECTIVE_DATE) VALUES ('$inst_id', '$mid(VISA_ID)', '$addy_id', 'LOC', '$currdate')"

#Adding contact informations in MASTER_CONTACT and ACQ_ENTITY_CONTACT tables.

orasql $mas_cont_sql "INSERT INTO $TABLENAME5 (INSTITUTION_ID, SALUTATION, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PROFESSIONAL_TITLE, PHONE1, PHONE_EXT, PHONE2, CELLULAR, FAX, EMAIL_ADDRESS, URL, ADDRESS1, ADDRESS2, CITY, PROV_STATE_ABBREV, PROVINCE_STATE, CNTRY_CODE, COUNTRY, POSTAL_CD_ZIP, CONTACT_ID) VALUES ('$inst_id', ' ', '$mid(CONTACT_FIRST_NAME)', '$mid(CONTACT_MIDDLE_NAME)', '$mid(CONTACT_LAST_NAME)', ' ', '$mid(CONTACT_PHONE)', ' ', ' ', ' ', '$mid(CONTACT_FAX)', ' ', ' ', '$mid(CONTACT_ADDRESS1)', '$mid(CONTACT_ADDRESS2)', '$mid(CONTACT_CITY)', '$mid(CONTACT_STATE_CD)', '$cont_pro_state(PROVINCE_STATE)', ' ', '$cntry_name(CNTRY_NAME)', '$mid(CONTACT_ZIP_CD)', '$cont_id')"

orasql $mas_cont_sql "INSERT INTO $TABLENAME4 (INSTITUTION_ID, ENTITY_ID, CONTACT_ID, CONTACT_ROLE) VALUES ('$inst_id', '$mid(VISA_ID)', '$cont_id', 'DEF')"


set $sp_id 1
#Adding Entity information in ACQ_ENTITY table.

orasql $mas_addr_sql "INSERT INTO $TABLENAME (INSTITUTION_ID, ENTITY_ID, ENTITY_LEVEL, ENTITY_NAME, ENTITY_DBA_NAME, SETTL_PLAN_ID, ENTITY_STATUS, PARENT_ENTITY_ID, ALLW_ID, EXTERNAL_ENTITY_ID, CAL_ACTIVITY_ID, CREATION_DATE, EXP_START_DATE, ACTUAL_START_DATE, ALW_NON_QUAL_UPGRD, NON_QUAL_IND, ALW_RECLASS_UPGRD, RSRV_FUND_STATUS, COMPANY_TYPE, PROCESSING_TYPE, BILLING_TYPE, TAX_ID, RECLASS_IND, DEFAULT_MCC, LANGUAGE_CODE, COMPANY_ID, ACCT_PPLAN_ID) VALUES ('$inst_id', '$mid(VISA_ID)', '70', '$mid(LEGAL_NAME)', '$mid(DBA_NAME)', '$sp_id', 'A', '$prnt_id', '1', '$mid(MID)', 'CLEARING-DAYS', '$c_date', '$ex_date', '$act_date', 'Y', 'Y', 'Y', 'F', '1', '$process_type', 'PT', '$mid(FED_TAX_ID)', 'S', $mid(SIC_CODE), 'EN', '', '1')"



#----ALT_MERCHANT Table----- 
set cs_mer_id $mid(VISA_ID)

set process_typ { VISA_ID MASTERCARD_ID AMEX_SE_NO DISCOVER_ID DINERS_ID JCB_ID DEBIT_ID OTHER_ID }

foreach type $process_typ {

     switch $type {
	"VISA_ID" {set ctype 04}
	"MASTERCARD_ID" {set ctype 05}
	"AMEX_SE_NO" {set ctype 03}
	"DISCOVER_ID" {set ctype 08}
	"DINERS_ID" {set ctype 07}
	"JCB_ID" {set ctype 09}
	"DEBIT_ID" {set ctype "00"}
	"OTHER_ID" {set ctype 06}
    }

	if {$mid($type) != ""} {
	orasql $mas_addr_sql "INSERT INTO $TABLENAME7 (INSTITUTION_ID, ENTITY_ID, CARD_SCHEME, CS_MERCHANT_ID, CLEARING_FLAG, PROP_LICENCE_FLAG, TIER_IND) VALUES ('$inst_id', '$cs_mer_id', '$ctype', '$cs_mer_id', '$clr_flg', '$pr_lin_flg', '$t_ind')"
	}

} 
set cust_name [string range $mid(LEGAL_NAME) 0 25]
set sql10 "insert into ENTITY_ACCT_TBL (INSTITUTION_ID, ENTITY_ACCT_ID, OWNER_ENTITY_ID, ENTITY_ACCT_CURR, TRANS_ROUTING_NBR, ACCT_NBR, ACCT_TYPE, CUSTOMER_NAME, SETTL_ROUTING_NBR, SETTL_ACCT_NBR, OPEN_INV_AMT, INV_CREDIT_AMT, REL_PAY_AMT, REL_FEE_AMT, POST_PAY_AMT, POST_FEE_AMT, ENTITY_ACCT_DESC, GL_GROUP_TYPE, ACCT_POSTING_TYPE, EFFECTIVE_DATE) VALUES ('$inst_id', '$e_acct_id', '$mid(VISA_ID)', '840', '$mid(MAS_ACH_ROUTING)', '$mid(MAS_ACH_ACCOUNT)', '$mid(MAS_ACH_ACCOUNT_TYPE)', '$cust_name', '$strn', '$sacno', '0', '0', '0', '0', '0', '0', '$mid(DBA_NAME)', 'G', 'A', '$c_date')"
puts $sql10
orasql $update_efund $sql10 



#Update status in core to CS-------------------------------------------------------

set mm "update $host_mmer set CLR_STL_STATUS = 'CS' where MMID = '$mid(MMID)'"
orasql $update_core $mm
set mr "update $host_mer set CLR_STL_STATUS = 'CS' where MID = '$mid(MID)'"
orasql $update_core $mr
set tr "update $host_terminal set CLR_STL_STATUS = 'CS' where MID = '$mid(MID)'"
orasql $update_core $tr

#Update sequence control tables----------------------------------------------------------




#Closing open connection to the database.
oracommit $db_login_handle 
oracommit $db_logon_handle

#Counter for number of inserts done to the database. 
set yk [expr $yk + 1]
puts $yk
set $ch_m ""
} else {
	if [catch {open duplog$curdate.txt {WRONLY CREAT APPEND}} fileid] {
		puts stderr "Cannot open /duplog : $fileid" 
	} else { 
		puts -nonewline $fileid "$x \n"
		puts "MERCHANT ALREADY EXISTS ::: $x "
		close $fileid
		set failed 1
	}
}
}
if {$failed == 1} {
  exec echo "Merchants failed to be boarded" | mailx -r teiprod@jetpay.com -s "Merchants failed to be boarded" rkhan@jetpay.com
}
#End of Boarding .
puts "End of Merchant Boarding"

