#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl  


set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(IST_DB)
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
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

proc connect_to_db {} {
    global DB_LOGON_HANDLE DB_CONNECT_HANDLE mbody mbody_c sysinfo mailfromlist msubj_c mailtolist authdb
    global authuser authpwd  
    if {[catch {set DB_LOGON_HANDLE [oralogon $authuser/$authpwd@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to DB auth"
        set mbody "Encountered error $result while trying to connect to DB auth"
        #exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
      puts "COnnected"
    }
};# end connect_to_db

proc connect_to_db1 {} {
    global DB_LOGON_HANDLE1 DB_CONNECT_HANDLE1 mbody mbody_c sysinfo mailfromlist msubj_c mailtolist clrdb
    global clruser clrpwd
    if {[catch {set DB_LOGON_HANDLE1 [oralogon $clruser/$clrpwd@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB masclr"
        set mbody "Encountered error $result while trying to connect to DB maasclr"
        #exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
      puts "COnnected"
    }
};# end connect_to_db1

proc close_db {} {
    global DB_LOGON_HANDLE DB_CONNECT_HANDLE
    if {[catch {oralogoff $DB_LOGON_HANDLE} result]} {
    }
};# end close_db

proc close_db1 {} {
    global DB_LOGON_HANDLE1 DB_CONNECT_HANDLE1
    if {[catch {oralogoff $DB_LOGON_HANDLE1} result]} {
    }
};# end close_db1

connect_to_db
connect_to_db1

set amount_flag 000000000000


if { [ catch {
    set merchant_c [oraopen $DB_LOGON_HANDLE]
    set CAPTURE_C [oraopen $DB_LOGON_HANDLE]
    set terminal_c [oraopen $DB_LOGON_HANDLE]
    set tran_c [oraopen $DB_LOGON_HANDLE]
    set UPDATE_C [oraopen $DB_LOGON_HANDLE]
    set EXT_CRSR [oraopen $DB_LOGON_HANDLE]
    set TEMP_CRSR [oraopen $DB_LOGON_HANDLE]
    set temp_crsr1 [oraopen $DB_LOGON_HANDLE1]
    set temp_crsr2 [oraopen $DB_LOGON_HANDLE1]
} result ] } {
    puts "Error $result while creating db handles"
    exit 1
}

#set SMS_file [open "[lindex $argv 0]" r]
set right_now [clock format [ clock scan "-0 day" ] -format %Y%m%d]
#set cur_line [split [set orig_line [gets $old_file] ] ,]

set input_file [open "[lindex $argv 0]" r]
while {[set checksum [gets $input_file line]] != -1 } {
  set counter [string first V23120 $line]  
  if {$counter > 0} {
    set cur_line $line
    gets $input_file line
    set cur_line "$cur_line[string range $line 26 [string length $line]]"
    #set counter [expr $counter + 18 ]
    #Record layout for the v23000-Header
    set cur_line "[string range $cur_line $counter [string length $cur_line]]"
    set Record_type [string range $cur_line 0 5]
    set Funds_transfer_SRE [string range $cur_line 6 15]
    set Processor_ID [string range $cur_line 16 25]
    set Affilate_bin [string range $cur_line 26 35]
    set SRE [string range $cur_line 36 45]
    set SRI [string range $cur_line 46 48]
    set Issuer_interchange_amount [string range $cur_line 49 64]
    set Issuer_interchange_amount_indicator [string range $cur_line 65 65]
    set Acquirer_interchange_amount [string range $cur_line 66 81]
    set Acquirer_interchange_amount_indicator [string range $cur_line 82 82]
    set Other_interchange_amount [string range $cur_line 83 98]
    set Other_interchange_amount_indicator [string range $cur_line 99 99]
    set Gross_interchange_amount [string range $cur_line 100 115]
    set Gross_interchange_amount_indicator [string range $cur_line 116 116]
    set Filler [string range $cur_line 117 129]

    set query_string "select max(unique_id) as unique_id from SMS_FILE_INFORMATION"
    puts $query_string
    orasql $temp_crsr1 $query_string
    while {[orafetch $temp_crsr1 -dataarray q -indexbyname] != 1403 } {
      set file_unique_id $q(UNIQUE_ID)
      set file_unique_id [expr $file_unique_id + 1]
    }
    if {$file_unique_id == ""} {
      set file_unique_id 1
    }
    set query_string "insert into SMS_FILE_INFORMATION values ('$file_unique_id','[string range [lindex $argv 0] 0 15]','$Issuer_interchange_amount','$Issuer_interchange_amount_indicator','$Acquirer_interchange_amount','$Acquirer_interchange_amount_indicator','$Other_interchange_amount','$Other_interchange_amount_indicator','$Gross_interchange_amount','$Gross_interchange_amount_indicator','$file_unique_id')"
    set file_unique_id [expr $file_unique_id + 1]
    puts $query_string
    orasql $temp_crsr1 $query_string
  }
  set counter [string first V23200A $line]
  if {$counter > 0} {
    set cur_line $line
    gets $input_file line
    set cur_line "$cur_line[string range $line 26 [string length $line]]"
    #set counter [expr $counter + 18 ]
    set cur_line "[string range $cur_line $counter [string length $cur_line]]"
    #record layout for v23200- financial record

    set query_string "select max(unique_id) as unique_id from SMS_TRANSACTION_INFORMATION"
    puts $query_string
    orasql $temp_crsr1 $query_string
    while {[orafetch $temp_crsr1 -dataarray q -indexbyname] != 1403 } {
      set unique_id $q(UNIQUE_ID)
      set unique_id [expr $unique_id + 1]
    }
    if {$unique_id == ""} {
      set unique_id 1
    }

    set Record_type [string range $cur_line 0 5]
    set Issuer_acquirer_indicator [string range $cur_line 6 6]
    set ISA_indicator [string range $cur_line 7 7]
    set GIV_flag [string range $cur_line 8 8]
    set Affiliate_BIN [string range $cur_line 9 18]
    set Settlement_date [string range $cur_line 19 24]
    set Validation_code [string range $cur_line 25 28]
    set Retrieval_reference_number [string range $cur_line 29 40]
    set Trace_number [string range $cur_line 41 46]
    set Request_message_type [string range $cur_line 47 50]
    set Response_Code [string range $cur_line 51 52]
    set Processing_code [string range $cur_line 53 58]
    set Message_reason_code [string range $cur_line 59 62]
    set Card_number [string range $cur_line 63 81]
    set Transaction_identifier [string range $cur_line 82 96]
    set Currency_code_transaction_amount [string range $cur_line 97 99]
    set Transaction_amount [string range $cur_line 100 111]
    set Transaction_amount_indicator [string range $cur_line 112 112] 
    set Reimbursement_fee [string range $cur_line 113 119]
    set Reimbursement_fee_indicator [string range $cur_line 120 120]
    set Surcharge_amount [string range $cur_line 121 128]
    set Surcharge_amount_indicator [string range $cur_line 129 129]
    #puts "$Card_number:$Transaction_amount:$Reimbursement_fee:$Reimbursement_fee_indicator"
    gets $input_file line
    gets $input_file line
    gets $input_file line
    set cur_line $line
    gets $input_file line
    set cur_line "$cur_line[string range $line 26 [string length $line]]"
    set cur_line "[string range $cur_line $counter [string length $cur_line]]"
    #puts $cur_line

#set cur_line [split [set orig_line [gets $old_file] ] ,]
    set Record_type [string range $cur_line 0 5]
    set Issuer_affiliate_BIN [string range $cur_line 6 15]
    set Authorization_ID_response_code [string range $cur_line 16 21]
    set Network_id [string range $cur_line 22 25]
    set Reimbursement_attribute [string range $cur_line 26 26]
    set Settlement_service_requested [string range $cur_line 27 27]
    set Settlement_service_selected [string range $cur_line 28 28]
    set Fee_program_indicator [string range $cur_line 29 31]
    set Acquirer_institution_id [string range $cur_line 32 42]
    set Chargeback_right_indicator [string range $cur_line 43 44]
    set Card_acceptor_terminal_ID [string range $cur_line 45 52]
    set Card_acceptor_ID [string range $cur_line 53 67]
    set Card_acceptor_name [string range $cur_line 68 92]
    set Card_acceptor_city [string range $cur_line 93 105]
    set Card_acceptor_country [string range $cur_line 106 107]
    set Geo_state_code [string range $cur_line 108 109]
    set Geo_zip_code5 [string range $cur_line 110 114]
    set Geo_zip_code4 [string range $cur_line 115 118]
    set Geo_country_code [string range $cur_line 119 121]
    set Filler [string range $cur_line 122 129]
    #puts "$Card_number:$Transaction_amount:$Reimbursement_fee:$Fee_program_indicator"
    #puts "$Card_number:$Transaction_amount:$Authorization_ID_response_code:$Retrieval_reference_number"
    if {$amount_flag != $Transaction_amount } {
      set query_string "insert into SMS_TRANSACTION_INFORMATION values ('$Settlement_date','$Retrieval_reference_number','$Card_number','$Transaction_identifier','$Currency_code_transaction_amount','$Transaction_amount','$Transaction_amount_indicator','$Authorization_ID_response_code','$Card_acceptor_ID','$unique_id','$Reimbursement_fee')"
      puts $query_string
      orasql $temp_crsr1 $query_string
      set unique_id [expr $unique_id + 1]
    }

  }
}

close_db
close_db1
