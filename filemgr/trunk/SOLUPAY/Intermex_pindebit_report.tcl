#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: Intermex_pindebit_report.tcl 3811 2016-06-27 15:38:07Z bjones $
#
################################################################################
#
# File Name:  Intermex_pindebit_report.tcl
#
# Description:  This program pulls a report for Solupay's Intermex
#               PIN debit activity.
#
# Script Arguments:  -c = Configuration file name.  Optional.  No default.
#                    -d = Run date (e.g., YYYYMMDD).  Optional.
#                         Defaults to current date.
#                    -l = Log file name.  Required.
#                    -o = Output file name.  Optional.  No default.
#
# Output:  A file containing a report of the Intermex PIN debit activity for the prior week
#           with subtotals and grand totals.  The report containa whether or not the debit
#           transactions are regulated or not.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib

#System variables
set box $env(SYS_BOX)
set auth_db $env(REPORT_ATH_DB)
set clr_db $env(CLR4_DB)
set MASCLR::DEBUG_LEVEL 0

set clearing_in_file_loc $env(CLR_OSITE_DATA)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"



################################################################################
#
# Procedure Name:  initProgram
#
# Description:     Initialize program arguments
# Error Return:    1 [Script error]
#
################################################################################
proc initProgram {} {

    global argv
    global cfg_filename
    global log_filename
    global output_filename
    global run_file_date
    global run_file_julian_date

    set num_script_args [lindex $argv 0]
    set i 1

#
# The options were separated with an incorrect regular expression.
# set numInst [regexp -- {[-i -I][ ]+([0-9]{3})} $argv]
# will match "- 123", "i 123" or "I 123" instead of only "-i 123" and "-I 123"
# This has been changed to
# set numInst [regexp -- {-[iI][ ]+([0-9]{3})} $argv]
#

    while {$i < $num_script_args} {
        set script_arg [string range [string trim [lindex $argv $i]] 1 1]
        set script_arg_val [string range [lindex $argv $i] 2 end]

        switch $script_arg {
            "c" {if {[string length $script_arg_val] != 0} {
                    set cfg_filename $script_arg_val
                } else {
                    puts stdout "Configuration file full path name must be specified if the -c option is envoked"
                    exit 1
                }}

            "d" {if {[string length $script_arg_val] != 0} {
                    set run_file_date $script_arg_val
                } else {
                    set run_file_date [clock format [clock seconds] -format "%Y%m%d"]
                    puts stdout "Date (YYYYMMDD) was not specified with the -d option; run date $run_file_date will be used"
                }
                set yyyy [string range $run_file_date 0 3]
                set mm [string range $run_file_date 4 5]
                set dd [string range $run_file_date 6 7]
                set run_file_julian_date [clock format [clock scan $yyyy-$mm-$dd] -format "%y%j"]
                }

            "l" {if {[string length $script_arg_val] != 0} {
                    set log_filename $script_arg_val
                } else {
                    puts stdout "Log file full path name must be specified with the -l argument"
                    exit 1
                }}

            "o" {if {[string length $script_arg_val] != 0} {
                    set output_filename $script_arg_val
                } else {
                    puts stdout "Output file full path name must be specified if the -o option is envoked"
                    exit 1
                }}

        default {puts stdout "$script_arg is an invalid script argument"
                exit 1
                }
        }
        set i [incr $i]
    }

    if {$i != $num_script_args} {
        puts stdout "Number of script arguments evaluted ($i) does not equal number of expected script arguments ($num_script_args)"
        exit 1
    }

};# end initProgram


################################################################################
#
# Procedure Name:  openLogFile
#
# Description:     Opens the log file for this program
# Error Return:    21 [Log file cannot be opened]
#
################################################################################
proc openLogFile {} {

    global log_file_ptr
    global log_filename

    if {[catch {open $log_filename a} log_file_ptr]} {
        puts stderr "Cannot open file $log_filename for logging."
        exit 21
    }

};# end openLogFile


################################################################################
#
# Procedure Name:  writeLogMsg
#
# Description:     Writes messages to the log file
# Error Return:    22 [Write to log file failed]
#
################################################################################
proc writeLogMsg { log_msg_text } {

    global log_file_ptr

    if {[catch {puts $log_file_ptr "[clock format [clock seconds] -format "%Y-%m-%d %T"] $log_msg_text"}]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg_text"
        exit 22
    }

};# end writeLogMsg


################################################################################
#
# Procedure Name:  readCfgFile
#
# Description:     Obtains the configuration parameters for the program
# Error Return:    11 [Config file cannot be opened]
#                  13 [Config file cannot be closed]
#
################################################################################
proc readCfgFile {} {

    global auth_db_logon
    global clr_db_logon
    global cfg_filename

    if {[catch {open $cfg_filename r} cfg_file_ptr]} {
        puts stderr "Cannot open file $cfg_filename for configurations."
        exit 11
    }

    while {[set line_in [gets $cfg_file_ptr]] != {} } {
        set cfg_element [lindex [split $line_in ,] 0]

        switch $cfg_element {
            "AUTH_DB_LOGON" {set auth_db_logon [lindex [split $line_in ,] 1]}
            "CLR_DB_LOGON"  {set clr_db_logon [lindex [split $line_in ,] 1]}
            default         {}
        }
    }

    if {[catch {close $cfg_file_ptr} response]} {
        puts stderr "Cannot close file $cfg_filename."
        exit 13
    }

};# end readCfgFile


################################################################################
#
# Procedure Name:  openOutputFile
#
# Description:     Opens the output file for writes by the program
# Error Return:    41 [Output file cannot be opened]
#
################################################################################
proc openOutputFile {} {

    global output_file_ptr
    global output_filename

    #
    # Use the "w" option for writes to a file and "a" to append onto an
    # existing file
    #
    if {[catch {open $output_filename w} output_file_ptr]} {
        puts stderr "Cannot open file $output_filename for writes by this program."
        exit 41
    }

};# end openOutputFile


################################################################################
#
# Procedure Name:  openDB
#
# Description:     Connects to the database and open tables used by the program;
#                  A maximum of 25 table cursors may be opened per logon handle
# Error Return:    50 [Database connection failed]
#                  51 [Database table cursor failed]
#
################################################################################
proc openDB {} {

    global auth_db
    global auth_db_logon
    global auth_db_logon_handle
    global bin_cursor
    global clr_db
    global clr_db_logon
    global clr_db_logon_handle
    global merch_info_cursor
    global Solupay_pindebit_totals_cursor
    global tranhistory_cursor

    #
    # Connect to the Auth database
    #
    if {[catch {set auth_db_logon_handle [oralogon $auth_db_logon@$auth_db]} ora_result] } {
        puts "Encountered error $ora_result while trying to connect to the $auth_db database"
        exit 50
    }

    #
    # Connect to the Clearing database
    #
    if {[catch {set clr_db_logon_handle [oralogon $clr_db_logon@$clr_db]} ora_result] } {
        puts "Encountered error $ora_result while trying to connect to the $clr_db database"
        exit 50
    }

    #
    # Open tranhistory table cursor
    #
    if {[catch {set tranhistory_cursor [oraopen $auth_db_logon_handle]} ora_result]} {
        puts "Encountered error $ora_result while trying to create tranhistory_cursor cursor handle"
        exit 51
    }

    #
    # Open bin table cursor
    #
    if {[catch {set bin_cursor [oraopen $clr_db_logon_handle]} ora_result]} {
        puts "Encountered error $ora_result while trying to create bin_cursor cursor handle"
        exit 51
    }

    #
    # Open merchant info table cursor
    #
    if {[catch {set merch_info_cursor [oraopen $clr_db_logon_handle]} ora_result]} {
        puts "Encountered error $ora_result while trying to create merch_info_cursor cursor handle"
        exit 51
    }

    #
    # Open Solupay_pindebit_totals table cursor
    #
    if {[catch {set Solupay_pindebit_totals_cursor [oraopen $auth_db_logon_handle]} ora_result]} {
        puts "Encountered error $ora_result while trying to create Solupay_pindebit_totals_cursor handle"
        exit 51
    }

};# end openDB


################################################################################
#
# Procedure Name:  doProc
#
# Description:      Retrieve pin debit transactions for Solupay merchants
#                   from the Auth database.
# Error Return:    54 [Database select operation failed]
#
################################################################################
proc doProc {} {

    global ent_class_id_for_test
    global ent_group_cursor
    global ent_user_cursor
    global ent_user_id_for_test
    global output_file_ptr
    global output_filename

    writeLogMsg "Writing to the output file $output_filename"
    puts $output_file_ptr "Sample output from the template program: \n"

    #
    # Obtain the entity_group_id and ent_group_desc values from the ent_group table
    #
    set ent_group_select_query "SELECT eg.ent_group_id
                                     , eg.ent_group_desc
                                FROM ent_group eg
                                WHERE eg.ent_class_id = :ent_class_id_var"

    MASCLR::log_message "ent_group_select_query(:ent_class_id_var $ent_class_id_for_test): \n\n\t$ent_group_select_query \n\n" 5
    if {[oraparse $ent_group_cursor $ent_group_select_query
            orabind  $ent_group_cursor :ent_class_id_var "$ent_class_id_for_test"
            oraexec  $ent_group_cursor ] != 0 } {
        writeLogMsg "ENT_GROUP_ID and ENT_GROUP_DESC were not able to be obtained from ent_group"
        writeLogMsg "ent_group_select_query failed with [oramsg $ent_group_cursor rc] [oramsg $ent_group_cursor error]"
        closeDB
        exit 54
    }

    if {[orafetch $ent_group_cursor -dataarray ent_group -indexbyname] != 1403 } {
        puts $output_file_ptr "ENT_GROUP Table Contents:"
        puts $output_file_ptr "ENT_GROUP_ID   = $ent_group(ENT_GROUP_ID)"
        puts $output_file_ptr "ENT_GROUP_DESC = $ent_group(ENT_GROUP_DESC) \n"
    }

    #
    # Obtain the entity_user_id and ent_last_log_dttm values from the ent_group table
    #
    set ent_user_select_query "SELECT eu.ent_user_id
                                    , eu.ent_last_log_dttm
                                FROM ent_user eu
                                WHERE eu.ent_user_id = :ent_user_id_var"

    MASCLR::log_message "ent_user_select_query(:ent_class_id_var $ent_class_id_for_test): \n\n\t$ent_user_select_query \n\n" 5
    if {[oraparse $ent_user_cursor $ent_user_select_query
            orabind  $ent_user_cursor :ent_user_id_var "$ent_user_id_for_test"
            oraexec  $ent_user_cursor ] != 0 } {
        writeLogMsg "ENT_USER, ENT_USER_ID, and ENT_LAST_LOG_DTTM were not able to be obtained from ent_user"
        writeLogMsg "ent_user_select_query failed with [oramsg $ent_user_cursor rc] [oramsg $ent_user_cursor error]"
        closeDB
        exit 54
    }

    if {[orafetch $ent_user_cursor -dataarray ent_user -indexbyname] != 1403 } {
        puts $output_file_ptr "ENT_USER Table Contents:"
        puts $output_file_ptr "ENT_USER_ID       = $ent_user(ENT_USER_ID)"
        puts $output_file_ptr "ENT_LAST_LOG_DTTM = $ent_user(ENT_LAST_LOG_DTTM)"
    }

};# doProc


##################################################
# select_pindebit
#   Retrieve pin debit transactions for Solupay merchants
#   from the Auth database.
##################################################
proc select_pindebit { } {

    global tranhistory_cursor
    global Solupay_pindebit_totals_cursor

    set Solupay_pindebit_query "
        select t.mid,
            decode(t.network_id,
                '03', 'Interlink',
                '08', 'STAR',
                '09', 'PULSE',
                '10', 'STAR',
                '11', 'STAR',
                '12', 'STAR',
                '13', 'AFFN',
                '15', 'STAR',
                '16', 'MAESTRO',
                '17', 'PULSE',
                '18', 'NYCE',
                '19', 'PULSE',
                '20', 'ACCEL',
                '23', 'NETS',
                '24', 'CU24',
                '25', 'Alaska Option',
                '27', 'NYCE',
                '28', 'Shazam',
                '29', 'EBT'
                ) as Network,
            count(*) as Count,
            sum(t.amount) as Amount,
            decode(t.request_type,
                '0260', 'Sale',
                '0460', 'Refund'
                ) as Transaction_Type,
            substr(t.cardnum,1,6) as BIN
        from teihost.tranhistory t
        where t.mid in (select mid from teihost.merchant where substr(short_name,1,8) = 'INTERMEX')
        and t.settle_date between to_char(sysdate - 7, 'YYYYMMDD') and to_char(sysdate, 'YYYYMMDD')
        and t.card_type = 'DB'
        group by t.mid,
            t.network_id,
            t.request_type,
            substr(t.cardnum,1,6)
        order by t.mid,
            t.network_id,
            t.request_type,
            substr(t.cardnum,1,6)"

    MASCLR::log_message "Solupay_pindebit_query: \n\n\t$Solupay_pindebit_query \n\n" 5
    orasql $tranhistory_cursor $Solupay_pindebit_query
    orasql $Solupay_pindebit_totals_cursor $Solupay_pindebit_query

};# end select_pindebit

##################################################
# output_report_header
#   Write Solupay report header
##################################################
proc output_report_header {output_file_ptr} {

    set    header {"Merchant ID","Merchant Name","Network","Regulation","Count",}
    append header {"Count Percent of Total","Amount","Amount Percent of Total","Transaction Type"}

    puts $output_file_ptr $header
    flush $output_file_ptr
};# end output_report_header

##################################################
# get_totals
#   This gets the total record count and grand total of the amounts
#   for use in the output_Solupay_pindebit_report.
##################################################
proc get_totals { } {

    global Solupay_pindebit_totals_cursor
    global record_count
    global total_count
    global total_amount

    set record_count 0
    set total_count 0
    set total_amount 0

    while {[orafetch $Solupay_pindebit_totals_cursor -dataarray pindebit_totals -indexbyname] == 0 } {

        set record_count [expr $record_count + 1]
        set total_count [expr $pindebit_totals(COUNT) + $total_count]
        set total_amount [expr $pindebit_totals(AMOUNT) + $total_amount]

    }
    #puts $record_count
    #puts $total_count
    #puts $total_amount
}

##################################################
# output_Solupay_pindebit_report
#   Write all PIN debit records to the
#   report file.
##################################################
proc output_Solupay_pindebit_report { } {

    global auth_user_cursor
    global tranhistory_cursor
    global TOTAL_RECORD_COUNT
    global output_file_ptr
    global merch_info_cursor
    global bin_cursor
    global record_count
    global total_count
    global total_amount
    global subtotal_count
    global subtotal_amount
    set counter 1

    if {$record_count != 0} {

        while {[orafetch $tranhistory_cursor -dataarray pindebit_report -indexbyname] == 0 } {

            set sql_merch_id_query "
                select entity_to_auth.mid, acq_entity.entity_id, acq_entity.entity_dba_name
                from acq_entity,
                entity_to_auth
                where entity_to_auth.entity_id = acq_entity.entity_id
                and entity_to_auth.mid = '$pindebit_report(MID)'
                group by entity_to_auth.mid,
                acq_entity.entity_id,
                acq_entity.entity_dba_name
                order by entity_to_auth.mid,
                acq_entity.entity_id,
                acq_entity.entity_dba_name"
            #puts $sql_merch_id_query

            MASCLR::log_message "sql_merch_id_query: \n\n\t$sql_merch_id_query \n\n" 5
            orasql $merch_info_cursor $sql_merch_id_query
            if {[orafetch $merch_info_cursor -dataarray merch_id -indexbyname] == 0} {
               set pindebit_report(MID) $merch_id(ENTITY_ID)
               set pindebit_report(MERCH_NAME) $merch_id(ENTITY_DBA_NAME)
            }

            set sql_bin_query "
                select substr(bin.bin_range_low,1,6) AS BIN,
                min(bin.regulated_ind) as REGULATED_IND
                from bin
                where substr(bin.bin_range_low,1,6) = '$pindebit_report(BIN)'
                and bin.acct_fund_src in ('D','P')
                and bin.product_id <> 'VIS'
                group by substr(bin.bin_range_low,1,6)
                order by substr(bin.bin_range_low,1,6)"

            MASCLR::log_message "sql_bin_query: \n\n\t$sql_bin_query \n\n" 5
            orasql $bin_cursor $sql_bin_query
            if {[orafetch $bin_cursor -dataarray bin -indexbyname] == 0} {
                if {$bin(REGULATED_IND) == "Y"} {
                    set pindebit_report(REGULATION) "Regulated"
                } elseif {$bin(REGULATED_IND) == "1"} {
                    set pindebit_report(REGULATION) "Regulated"
                } else {
                    set pindebit_report(REGULATION) "Not Regulated"
                }
            }
            ## code breaks here if there are no records.  Need a check for existence of records.
            ## probably need something like if {$record_count != 0}
            if {$counter == 1} {
                set current_mid $pindebit_report(MID)
                set subtotal_count $pindebit_report(COUNT)
                set subtotal_amount $pindebit_report(AMOUNT)
            } else {
                if {$pindebit_report(MID) == $current_mid} {
                    set subtotal_count [expr $pindebit_report(COUNT) + $subtotal_count]
                    set subtotal_amount [expr $pindebit_report(AMOUNT) + $subtotal_amount]
                } else {
                    set    pd_record ""
                    append pd_record ,""
                    append pd_record ,""
                    append pd_record ,"Merchant Totals:"
                    append pd_record ,$subtotal_count
                    append pd_record ,[format "%.2f" [expr $subtotal_count. / $total_count * 100] ]
                    append pd_record ,$subtotal_amount
                    append pd_record ,[format "%.2f" [expr $subtotal_amount / $total_amount * 100] ]
                    puts $output_file_ptr $pd_record
                    set current_mid $pindebit_report(MID)
                    set subtotal_count $pindebit_report(COUNT)
                    set subtotal_amount $pindebit_report(AMOUNT)
                }
            }

            set pd_record $pindebit_report(MID)
            append pd_record ,$pindebit_report(MERCH_NAME)
            append pd_record ,$pindebit_report(NETWORK)
            append pd_record ,$pindebit_report(REGULATION)
            append pd_record ,$pindebit_report(COUNT)
            append pd_record ,[format "%.2f" [expr $pindebit_report(COUNT). / $total_count * 100] ]
            append pd_record ,$pindebit_report(AMOUNT)
            append pd_record ,[format "%.2f" [expr $pindebit_report(AMOUNT) / $total_amount * 100] ]
            append pd_record ,$pindebit_report(TRANSACTION_TYPE)

            #puts $pd_record
            puts $output_file_ptr $pd_record


            incr counter
            incr TOTAL_RECORD_COUNT

        }

        set    pd_record ""
        append pd_record ,""
        append pd_record ,""
        append pd_record ,"Merchant Totals:"
        append pd_record ,$subtotal_count
        append pd_record ,[format "%.2f" [expr $subtotal_count. / $total_count * 100] ]
        append pd_record ,$subtotal_amount
        append pd_record ,[format "%.2f" [expr $subtotal_amount / $total_amount * 100] ]
        puts $output_file_ptr $pd_record

        set    pd_record ""
        append pd_record ,""
        append pd_record ,""
        append pd_record ,"Grand Total:"
        append pd_record ,$total_count
        append pd_record ,[format "%.2f" [expr $total_count. / $total_count * 100] ]
        append pd_record ,$total_amount
        append pd_record ,[format "%.2f" [expr $total_amount / $total_amount * 100] ]
        puts $output_file_ptr $pd_record

    } else {
        set counter 0
    }
    flush $output_file_ptr
    set log_summary [format " Solupay Pin Debit report contains %d record(s)" $counter]
    writeLogMsg $log_summary

};# end output_Solupay_pindebit_report

################################################################################
#
# Procedure Name:  closeDB
#
# Description:     Connect to the database and open tables used by the program
# Error Return:    52 [Database disconnect failed]
#
################################################################################
proc closeDB {} {

    global auth_db
    global auth_db_logon
    global auth_db_logon_handle
    global bin_cursor
    global clr_db
    global clr_db_logon
    global clr_db_logon_handle
    global merch_info_cursor
    global Solupay_pindebit_totals_cursor
    global tranhistory_cursor

    #
    # Open merchant info table cursor
    #
    oraclose $merch_info_cursor

    #
    # Close bin table cursor
    #
    oraclose $bin_cursor

    #
    # Close tranhistory table cursor
    #
    oraclose $tranhistory_cursor

    #
    # Open Solupay_pindebit_totals table cursor
    #
    oraclose $Solupay_pindebit_totals_cursor

    #
    # Disconnect from the Auth database
    #
    if {[catch {oralogoff $auth_db_logon_handle} ora_result]} {
        puts "Encountered error $ora_result while trying to disconnect from the $auth_db database"
        exit 52
    }

    #
    # Disconnect from the Clearing database
    #
    if {[catch {oralogoff $clr_db_logon_handle} ora_result]} {
        puts "Encountered error $ora_result while trying to disconnect from the $clr_db database"
        exit 52
    }

};# end closeDB


################################################################################
#
# Procedure Name:  closeOutputFile
#
# Description:     Closes the output file written by the program
# Error Return:    43 [Output file cannot be closed]
#
################################################################################
proc closeOutputFile {} {

   global output_file_ptr
   global output_filename

   if {[catch {close $output_file_ptr} response]} {
       puts stderr "Cannot close file $output_filename."
       exit 43
   }

};# end closeOutputFile


################################################################################
#
# Procedure Name:  closeLogFile
#
# Description:     Closes the log file used by the program
# Error Return:    23 [Log file cannot be closed]
#
################################################################################
proc closeLogFile {} {

    global log_file_ptr
    global log_filename

    if {[catch {close $log_file_ptr} response]} {
        puts stderr "Cannot close file $log_filename."
        exit 23
    }

};# end closeLogFile



##########
## MAIN ##
##########
initProgram

openLogFile
readCfgFile
openOutputFile
openDB

writeLogMsg "Starting pin debit report"
writeLogMsg " output file name will be $output_filename"

select_pindebit
output_report_header $output_file_ptr
get_totals
output_Solupay_pindebit_report

closeDB
closeOutputFile
writeLogMsg "Successfully ending pin debit report"
closeLogFile
