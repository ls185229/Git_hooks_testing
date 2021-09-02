#!/usr/bin/env tclsh
package require Oratcl

# $Id: merchants_boarded_last_7_days.tcl 4074 2017-02-23 17:02:54Z fcaron $

#################################################################
# globals
#################################################################
set port_ro_db $env(PORT_RO_DB)
set port_ro_user $env(PORT_RO_USERNAME)
set port_ro_passwd $env(PORT_RO_PASSWORD)


#############################
# database connections
#############################
global masclr_cursor
global masclr_cursor2
global masclr_logon_handle
global masclr_logon_handle2
global core_cursor
global core_logon_handle
global port_ro_db
global port_ro_user
global port_ro_passwd

#############################
# input/output
#############################
global use_input_file
global output_file
global std_out_channel

global email_to_list
global report_file
global report_file_name

#############################
# usage options
#############################
global run_as_test

#############################
# common globals
#############################
# global current_entity_id

#################################################################
# procs
#################################################################

proc open_db_connections {} {
# Only include the database connections that you need
    global masclr_cursor
    global masclr_logon_handle
    global masclr_cursor2
    global masclr_logon_handle2

    global core_cursor
    global core_logon_handle
    
    global port_ro_db
    global port_ro_user
    global port_ro_passwd

    if {[catch {set masclr_logon_handle [oralogon $port_ro_user/$port_ro_passwd@$port_ro_db]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set masclr_cursor [oraopen $masclr_logon_handle]

    if {[catch {set masclr_logon_handle2 [oralogon $port_ro_user/$port_ro_passwd@$port_ro_db]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set masclr_cursor2 [oraopen $masclr_logon_handle2]

    if {[catch {set core_logon_handle [oralogon $port_ro_user/$port_ro_passwd@$port_ro_db]} result]} {
        puts "Could not open database connections.  Result: $result"
        exit 1
    }
    set core_cursor [oraopen $core_logon_handle]

}

proc close_db_connections {} {
# Only include the database connections that you need
    global masclr_cursor
    global masclr_logon_handle
    global masclr_cursor2
    global masclr_logon_handle2

    global core_cursor
    global core_logon_handle

    oraclose $masclr_cursor
    oraclose $masclr_cursor2
    oraclose $core_cursor
    oralogoff $masclr_logon_handle
    oralogoff $masclr_logon_handle2
    oralogoff $core_logon_handle
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
    global masclr_cursor2

    # look in core to see which merchants have a boarded date >= the lookback date
    # core.merchant board_date
    set lookback_date [string toupper [clock format [clock scan "$lookback_days days ago"] -format "%d-%h-%y"]]

    puts $report_file "Merchants boarded since $lookback_date"
    puts $report_file ""

    puts $report_file "DBA Name, Merchant ID, Visa ID, MCC, Bill Addr, Bill City, Bill St., Bill Zip, Cust Svc Phone, Contact Name, Tax ID, Contact Email, Board Date, Agent ID, Agent Name"

    set    get_board_date_sql "SELECT DISTINCT m.mid, m.visa_id, m.me_legal_name, m.me_dba_name, ar.AGENT_ID as AGENT_ID, "
    append get_board_date_sql "       ar.AGENT_NAME as AGENT_NAME, m.SIC_CODE, to_char(m.board_date, 'MON-DD-YYYY') as BOARD_DATE, "
    append get_board_date_sql "       mc.phone1 as cust_svc_phone "
    append get_board_date_sql "FROM  core.merchant m "
    append get_board_date_sql "      LEFT JOIN(SELECT cp.AGENT_ID, a.AGENT_NAME,mm.mmid "
    append get_board_date_sql "          FROM core.corporate cp "
    append get_board_date_sql "               LEFT JOIN core.iso i ON cp.iso_id = i.iso_id "
    append get_board_date_sql "               LEFT JOIN core.agent a ON cp.agent_id = a.agent_id"
    append get_board_date_sql "               LEFT JOIN core.master_merchant mm ON mm.cp_id = cp.cp_id )ar ON m.mmid = ar.mmid "      
    append get_board_date_sql "      JOIN masclr.acq_entity_contact aec ON aec.entity_id = m.visa_id "
    append get_board_date_sql "      JOIN masclr.master_contact mc ON aec.contact_id = mc.contact_id "
    append get_board_date_sql "             AND mc.INSTITUTION_ID = aec.INSTITUTION_ID "
    append get_board_date_sql "             AND aec.contact_role = 'DEF' "
    append get_board_date_sql "WHERE m.board_date >= '$lookback_date' "
    append get_board_date_sql "ORDER BY BOARD_DATE"
    
    orasql $core_cursor $get_board_date_sql
    
    while {1} {
        if {[catch {orafetch $core_cursor -dataarray core_merchant_arr -indexbyname} result_code]} {
           puts stderr "Error with $get_board_date_sql"
           puts stderr "[oramsg $core_cursor rc] [oramsg $core_cursor error]"
           # break or exit or ignore
        }
        if {[oramsg $core_cursor rc] != 0} break

        ###########################################################################################################################
        ###########################################################################################################################
        set addr_name_sql ""

        set addr_name_sql "SELECT replace(ma.address1,',',' ') bill_addr1,nvl(ma.city,' ') bill_city,nvl(ma.prov_state_abbrev,' ') bill_st,
        nvl(ma.postal_cd_zip,' ') as bill_zip,
        trim(mc.first_name || ' ' || mc.last_name) Contact_Name,trim(nvl(mc.email_address,' ')) email, nvl(ae.tax_id,' ') TAX_ID
        FROM 
        masclr.acq_entity ae 
        JOIN masclr.acq_entity_address aea ON (aea.entity_id = ae.entity_id AND aea.institution_id = ae.institution_id)
        JOIN masclr.acq_entity_contact aec ON (aec.entity_id = ae.entity_id AND aec.institution_id = ae.institution_id)
        JOIN masclr.master_address ma ON (aea.address_id = ma.address_id AND ma.institution_id = ae.institution_id)
        JOIN masclr.master_contact mc ON (aec.contact_id = mc.contact_id AND mc.institution_id = ae.institution_id)
        WHERE ae.ENTITY_ID = '$core_merchant_arr(VISA_ID)' AND aec.contact_role = 'DEF' AND aea.address_role = 'BIL'"
        orasql $masclr_cursor $addr_name_sql

        while {1} {
           if {[catch {orafetch $masclr_cursor -dataarray addr_name_arr -indexbyname} result_code]} {
              puts stderr "Error with $addr_name_sql" 
              puts stderr "[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
              break
           } 
           set outline ""
           if {[oramsg $masclr_cursor rc] != 0} break  

           set outline "$core_merchant_arr(ME_DBA_NAME), "
           append outline    "$core_merchant_arr(MID), "
           append outline "'[expr {$core_merchant_arr(VISA_ID) == {} ? {ACH ONLY} : $core_merchant_arr(VISA_ID)}]', "
           append outline "$core_merchant_arr(SIC_CODE), "
           append outline "$addr_name_arr(BILL_ADDR1), "
           append outline "$addr_name_arr(BILL_CITY), "
           append outline "$addr_name_arr(BILL_ST), "
           append outline "$addr_name_arr(BILL_ZIP), "
           append outline "$core_merchant_arr(CUST_SVC_PHONE), "
           append outline "$addr_name_arr(CONTACT_NAME), "
           # append outline "$core_merchant_arr(ME_LEGAL_NAME), "
           append outline "$addr_name_arr(TAX_ID), "
           append outline "$addr_name_arr(EMAIL), "
           append outline "$core_merchant_arr(BOARD_DATE), "
           append outline "$core_merchant_arr(AGENT_ID), "
           append outline "$core_merchant_arr(AGENT_NAME), "
           # puts -nonewline $report_file $outline
           puts $report_file $outline

        ###########################################################################################################################
        ###########################################################################################################################
        }
    }
    
    puts $report_file ""
    puts $report_file ""
    puts $report_file "Merchants deactivated since $lookback_date"
    puts $report_file ""
    puts $report_file "DBA Name, Merchant ID, Visa ID, MCC, Bill Addr, Bill City, Bill St., Bill Zip, Cust Svc Phone, Contact Name, Tax ID, Contact Email, Termination Date, Close Date, Agent ID, Agent Name"

    # find clearing merchants with termination dates of 90 days greater than the lookback days
    # set term_date [string toupper [clock format [clock scan "[expr 90 - $lookback_days] days"] -format "%d-%h-%y"]]
    # set term_date [string toupper [clock format [clock scan "90 days ago"] -format "%d-%h-%y"]]
    # set term_date [string toupper [clock format [clock scan "180 days"] -format "%d-%h-%y"]]
    
    # find clearing merchants with termination dates six months greater than the lookback days
    set term_date [string toupper [clock format [clock scan "6 months"] -format "%d-%h-%y"]]

    # puts "looking for term date >= $term_date"
    puts "looking for term date <= $term_date"
    # set get_term_merchants_sql "select entity_id, termination_date from masclr.acq_entity where termination_date >= '$term_date'"
    set get_term_merchants_sql "SELECT entity_id, termination_date, ADD_MONTHS(termination_date, -6) as CLOSURE_DATE "
    append get_term_merchants_sql "FROM masclr.acq_entity " 
    append get_term_merchants_sql "WHERE ADD_MONTHS(termination_date, -6) >= sysdate - $lookback_days "
    append get_term_merchants_sql "ORDER BY termination_date"
    
    orasql $masclr_cursor $get_term_merchants_sql
       while {1} {
        if {[catch {orafetch $masclr_cursor -dataarray current_entity_arr -indexbyname} result_code]} {
           puts stderr "Error with $get_term_merchants_sql"
           puts stderr "[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
           # break or exit or ignore
        }
        if {[oramsg $masclr_cursor rc] != 0} break
        # get the info from core

        set    get_term_info_sql "SELECT m.mid, m.visa_id, m.me_legal_name, m.me_dba_name, ar.AGENT_ID as AGENT_ID, "
        append get_term_info_sql "       ar.AGENT_NAME as AGENT_NAME, m.SIC_CODE "
        append get_term_info_sql "FROM  core.merchant m "
        append get_term_info_sql "      LEFT JOIN(SELECT cp.AGENT_ID, a.AGENT_NAME, mm.mmid "
        append get_term_info_sql "          FROM core.corporate cp "
        append get_term_info_sql "               LEFT JOIN core.iso i ON cp.iso_id = i.iso_id "
        append get_term_info_sql "               LEFT JOIN core.agent a ON cp.agent_id = a.agent_id"
        append get_term_info_sql "               LEFT JOIN core.master_merchant mm ON mm.cp_id = cp.cp_id )ar ON m.mmid = ar.mmid "      
        append get_term_info_sql "      JOIN masclr.acq_entity_contact aec ON aec.entity_id = m.visa_id "
        append get_term_info_sql "      JOIN masclr.master_contact mc ON aec.contact_id = mc.contact_id "
        append get_term_info_sql "             AND mc.INSTITUTION_ID = aec.INSTITUTION_ID "
        append get_term_info_sql "             AND aec.contact_role = 'DEF' "
        append get_term_info_sql "WHERE m.visa_id = '$current_entity_arr(ENTITY_ID)' "

        orasql $core_cursor $get_term_info_sql
        while {1} {
            if {[catch {orafetch $core_cursor -dataarray core_merchant_arr -indexbyname} result_code]} {
               puts stderr "Error with $get_term_info_sql"
               puts stderr "[oramsg $core_cursor rc] [oramsg $core_cursor error]"
               # break or exit or ignore
            }
            if {[oramsg $core_cursor rc] != 0} break

            ###########################################################################################################################
            ###########################################################################################################################
            set taddr_name_sql ""

            set taddr_name_sql "SELECT replace(ma.address1,',',' ') bill_addr1,nvl(ma.city,' ') bill_city,nvl(ma.prov_state_abbrev,' ') bill_st,
            nvl(ma.postal_cd_zip,' ') as bill_zip,
            trim(mc.first_name || ' ' || mc.last_name) Contact_Name,trim(nvl(mc.email_address,' ')) email, mc.phone1 as cust_svc_phone, nvl(ae.tax_id,' ') TAX_ID
            FROM
            masclr.acq_entity ae
            JOIN masclr.acq_entity_address aea ON (aea.entity_id = ae.entity_id AND aea.institution_id = ae.institution_id)
            JOIN masclr.acq_entity_contact aec ON (aec.entity_id = ae.entity_id AND aec.institution_id = ae.institution_id)
            JOIN masclr.master_address ma ON (aea.address_id = ma.address_id AND ma.institution_id = ae.institution_id)
            JOIN masclr.master_contact mc ON (aec.contact_id = mc.contact_id AND mc.institution_id = ae.institution_id)
            WHERE ae.ENTITY_ID = '$current_entity_arr(ENTITY_ID)' AND aec.contact_role = 'DEF' AND aea.address_role = 'BIL'"
           
            orasql $masclr_cursor2 $taddr_name_sql

            if {[catch {orafetch $masclr_cursor2 -dataarray taddr_name_arr -indexbyname} result_code]} {
               puts stderr "Error with $taddr_name_sql"
               puts stderr "[oramsg $masclr_cursor2 rc] [oramsg $masclr_cursor2 error]"
               break
            }

            orasql $masclr_cursor2 $taddr_name_sql

            set outline ""
            if {[oramsg $masclr_cursor2 rc] != 0} break

            set outline "$core_merchant_arr(ME_DBA_NAME), "
            append outline "$core_merchant_arr(MID), "
            append outline "'[expr {$core_merchant_arr(VISA_ID) == {} ? {ACH ONLY} : $core_merchant_arr(VISA_ID)}]', "
            append outline "$core_merchant_arr(SIC_CODE), "
            append outline "$taddr_name_arr(BILL_ADDR1), "
            append outline "$taddr_name_arr(BILL_CITY), "
            append outline "$taddr_name_arr(BILL_ST), "
            append outline "$taddr_name_arr(BILL_ZIP), "
            append outline "$taddr_name_arr(CUST_SVC_PHONE), "
            append outline "$taddr_name_arr(CONTACT_NAME), "
            # append outline "$core_merchant_arr(ME_LEGAL_NAME), "
            append outline "$taddr_name_arr(TAX_ID), "
            append outline "$taddr_name_arr(EMAIL), "
            
            # append outline "[string toupper [clock format [clock scan "-90 days" -base [clock scan $current_entity_arr(TERMINATION_DATE)]] -format "%b-%d-%Y"]], "
            append outline "[string toupper [clock format [clock scan $current_entity_arr(TERMINATION_DATE)] -format "%b-%d-%Y"]], "
            # append outline "[string toupper [clock format [clock scan "$current_entity_arr(TERMINATION_DATE) - 180 days"] -format "%b-%d-%Y"]], "
            append outline "[string toupper [clock format [clock scan $current_entity_arr(CLOSURE_DATE)] -format "%b-%d-%Y"]], "
            append outline "$core_merchant_arr(AGENT_ID), "
            append outline "$core_merchant_arr(AGENT_NAME), "
            puts $report_file $outline

            ###########################################################################################################################
            ###########################################################################################################################
            }
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

# set email_to_list "reports-clearing@jetpay.com; risk@jetpay.com; compliance@jetpay.com; operations@jetpay.com; clearing@jetpay.com" 
# Replaced the JetPay email addresses with equivalent NCR email addresses.
set email_to_list "reports-clearing.JetPayTX@ncr.com; risk.payments@NCR.com; PCI.Compliance@ncr.com; Operations.Payments@ncr.com; Clearing.JetPayTX@ncr.com"

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

    set mailpipe [open "| mutt -s $email_subject $attachment_string -- $email_to_list" w ]
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
