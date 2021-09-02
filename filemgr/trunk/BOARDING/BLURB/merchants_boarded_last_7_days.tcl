#!/usr/bin/env tclsh

package require Oratcl 4.3

# $Id: merchants_boarded_last_7_days.tcl 2329 2013-06-11 16:40:50Z bjones $

#################################################################
# globals
#################################################################

#############################
# database connections
#############################
global masclr_cursor
global masclr_logon_handle
global core_cursor
global core_logon_handle
global teihost_cursor
global teihost_logon_handle
global port_cursor
global port_logon_handle
global database_name_masclr
global database_name_teihost
global database_name_core
global database_name_port

#############################
# input/output
#############################
global use_input_file_string
global use_input_file
global input_file_name
global output_file
global output_file_name
global std_out_channel

global email_to_list
global email_from_list
global report_file
global report_file_name

#############################
# usage options
#############################
global run_as_test
global run_as_test_string


#############################
# common globals
#############################
global current_entity_id

#################################################################
# procs
#################################################################

proc open_db_connections {} {
# Only include the database connections that you need
    global masclr_cursor
    global masclr_logon_handle
    global core_cursor
    global core_logon_handle
    global teihost_cursor
    global teihost_logon_handle
    global port_cursor
    global port_logon_handle

    if {[catch {set masclr_logon_handle [oralogon masclr/masclr@transqa]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set masclr_cursor [oraopen $masclr_logon_handle]

    if {[catch {set core_logon_handle [oralogon boardqa/boardqa1@transqa]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set core_cursor [oraopen $core_logon_handle]

    if {[catch {set teihost_logon_handle [oralogon boardqa/boardqa1@transqa]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set teihost_cursor [oraopen $teihost_logon_handle]

    if {[catch {set port_logon_handle [oralogon port/tawny@transqa]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set port_cursor [oraopen $port_logon_handle]
}

proc close_db_connections {} {
# Only include the database connections that you need
    global masclr_cursor
    global masclr_logon_handle
    global core_cursor
    global core_logon_handle
    global teihost_cursor
    global teihost_logon_handle
    global port_cursor
    global port_logon_handle

    oraclose $masclr_cursor
    oraclose $core_cursor
    oraclose $teihost_cursor
    oraclose $port_cursor
    oralogoff $masclr_logon_handle
    oralogoff $core_logon_handle
    oralogoff $teihost_logon_handle
    oralogoff $port_logon_handle
}

proc open_output_file {} {
    global report_file
    global report_file_name

    if {[catch {open $report_file_name {RDWR CREAT TRUNC}} report_file]} {
        puts "Cannot open file $report_file_name. "
        return
    }
}

proc close_output_file {} {
    global report_file
    global report_file_name

    if {[catch {close $report_file} response]} {
        puts "Cannot close file $report_file_name.  Changes may not be saved."
        return
    }
}

proc parse_arguments {} {
    global arguments
    global argv

    # command line arguments like

    foreach {argument value} $argv {
        set arguments($argument) $value
        puts "arguments($argument) = $arguments($argument)"
    }
}


proc my_proc {} {
    global core_cursor
    global report_file
    global report_file_name
    global lookback_days

    global masclr_cursor


    # look in core to see which merchants have a boarded date >= the lookback date
    # core.merchant board_date
    set lookback_date [string toupper [clock format [clock scan "$lookback_days days ago"] -format "%d-%h-%y"]]


    puts $report_file "Merchants boarded since $lookback_date"
    puts $report_file ""

    puts $report_file "Merchant ID,Visa ID,Legal Name,DBA Name,MCC,Board Date"
    set    get_board_date_sql "select mid, visa_id, me_legal_name, me_dba_name, "
    append get_board_date_sql "SIC_CODE, to_char(board_date, 'MON-DD-YYYY') as BOARD_DATE "
    append get_board_date_sql "from core.merchant@boardqa_trnclr1 "
    append get_board_date_sql "where board_date >= '$lookback_date' "
    append get_board_date_sql "order by board_date"
    orasql $core_cursor $get_board_date_sql
    while {1} {
        if {[catch {orafetch $core_cursor -dataarray core_merchant_arr -indexbyname} result_code]} {
           puts stderr "Error with $get_board_date_sql"
           puts stderr "[oramsg $core_cursor rc] [oramsg $core_cursor error]"
           # break or exit or ignore
        }
        if {[oramsg $core_cursor rc] != 0} break
        # do something
        set outline    "$core_merchant_arr(MID),"
        append outline "'[expr {$core_merchant_arr(VISA_ID) == {} ? {ACH ONLY} : $core_merchant_arr(VISA_ID)}]',"
        append outline "$core_merchant_arr(ME_LEGAL_NAME),"
        append outline "$core_merchant_arr(ME_DBA_NAME),"
        append outline "$core_merchant_arr(SIC_CODE),"
        append outline "$core_merchant_arr(BOARD_DATE)"
        puts $report_file $outline

    }
    puts $report_file ""
    puts $report_file "Merchants deactivated since $lookback_date"
    puts $report_file "Merchant ID, Visa ID, Legal Name, DBA Name, MCC, Termination Date"
    # find clearing merchants with termination dates of 90 days greater than the lookback date
    set term_date [string toupper [clock format [clock scan "[expr 90 - $lookback_days] days"] -format "%d-%h-%y"]]

    puts "looking for term date >= $term_date"
    set get_term_merchants_sql "select entity_id,termination_date from acq_entity@masclr_trnclr1 where termination_date >= '$term_date'"
    orasql $masclr_cursor $get_term_merchants_sql
    while {1} {
        if {[catch {orafetch $masclr_cursor -dataarray current_entity_arr -indexbyname} result_code]} {
           puts stderr "Error with $get_term_merchants_sql"
           puts stderr "[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
           # break or exit or ignore
        }
        if {[oramsg $masclr_cursor rc] != 0} break
        # get the inf from core
        set get_term_info_sql "select mid, visa_id, me_legal_name, me_dba_name, SIC_CODE from core.merchant@boardqa_trnclr1 where visa_id = '$current_entity_arr(ENTITY_ID)'"
        orasql $core_cursor $get_term_info_sql
        while {1} {
            if {[catch {orafetch $core_cursor -dataarray core_merchant_arr -indexbyname} result_code]} {
               puts stderr "Error with $get_term_info_sql"
               puts stderr "[oramsg $core_cursor rc] [oramsg $core_cursor error]"
               # break or exit or ignore
            }
            if {[oramsg $core_cursor rc] != 0} break
            # do something
            puts $report_file "$core_merchant_arr(MID), '[expr {$core_merchant_arr(VISA_ID) == {} ? {ACH ONLY} : $core_merchant_arr(VISA_ID)}]', $core_merchant_arr(ME_LEGAL_NAME), $core_merchant_arr(ME_DBA_NAME), $core_merchant_arr(SIC_CODE),[string toupper [clock format [clock scan "-90 days" -base [clock scan $current_entity_arr(TERMINATION_DATE)]] -format "%b-%d-%Y"]]"

        }
        # do something

    }
    puts $report_file ""
    puts $report_file "End of data"

}

proc pad_string { field_length string_to_pad } {

    if { [string length $string_to_pad] >= $field_length } {
        return [string range $string_to_pad 0 [expr $field_length - 1]]
    } else {
        return [ append string_to_pad [string repeat " " [expr {$field_length} - {[string length [string range $string_to_pad 0 [expr $field_length - 1]]]}]]                 ]
    }

}

proc usage_statement {} {

    puts stdout "Usage: [info script] ?-use_input_file? ?-run_as_test? "
    puts stdout "  where -use_input_file indicates that a file called #CHANGME should be used as input"
    puts stdout "  If -run_as_test is used, output files will not be sent by email."
    exit 1
}

#################################################################
# main
#################################################################

########################
# setup
########################
set std_out_channel stdout
set database_name_masclr(PROD) "@masclr_trnclr1"
set database_name_masclr(QA) ""
set database_name_teihost(PROD) "@boardqa_transp1"
set database_name_teihost(QA) ""
set database_name_port(PROD) "@boardqa_trnclr4"
set database_name_core(PROD) "@boardqa_trnclr1"
set database_name_core(QA) ""
#set email_to_list "reports-clearing@jetpay.com isoapps@jetpayiso.com risk@jetpay.com"
set    email_to_list "reports-clearing@jetpay.com isoapps@jetpayiso.com "
append email_to_list "risk@jetpay.com compliance@jetpay.com operations@jetpay.com "
set lookback_days 7

set run_as_test ""
set use_input_file 0

set today [clock format [clock seconds] -format "%Y%b%d"]

set command_string "[info script]"
foreach argument $argv {
    append command_string " $argument"
}

open_db_connections
#open_input_file

parse_arguments

if { [info exists arguments(-run_as_test)] } {
    set run_as_test 1
    puts $std_out_channel "running as test"
}

if { [info exists arguments(-lookback)] } {
    set lookback_days $arguments(-lookback)
}
set start_date [clock format [clock scan "-$lookback_days days"] -format "%Y%b%d"]
set report_file_name "merchants-boarded-$start_date-to-$today"
append report_file_name ".csv"
open_output_file

my_proc

close_output_file

set mutt_report_file_name "$report_file_name"
set mutt_subject_line "\"Merchants boarded last $lookback_days days\""

#######################
# should check return value
# and log an error if there is a problem sending
# should also send a simple message (no attachment, etc) with mailx if mutt fails
#######################
proc send_file { email_to_list {email_subject ""} {email_body ""} {email_file_attachments_list ""} } {

    global std_out_channel

    set attachment_string ""
    if { [ llength $email_file_attachments_list ] } {
        foreach filename $email_file_attachments_list {
            if { [ file exists $filename ] } {
                append attachment_string "-a $filename "
            }
        }
    }

    set mailpipe [open "| mutt -s $email_subject $attachment_string $email_to_list" w ]
    if { [info exists mailpipe] } {
        if { [ catch {
            puts $mailpipe $email_body
            close $mailpipe
        } result ] } {
            puts $std_out_channel $result

        }
    }

}

if {$run_as_test == 1} {
} else {

    send_file $email_to_list $mutt_subject_line "" $mutt_report_file_name

}

close_db_connections
file delete $mutt_report_file_name
