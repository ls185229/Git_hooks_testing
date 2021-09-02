#!/usr/bin/env tclsh

# $Id: trans_sus_err_chk.tcl 3595 2015-12-01 21:25:04Z bjones $

#===============================================================================
#=========================== Modification History ==============================
#===============================================================================
# Version 2.01 Keith Myatt 07-17-2012
# --------- : Major rewrite to move the records from the mas_trans_error
#             and mas_trans_suspend tables when the count and amount is small
#             insted of stopping all processes.

##################################################################################

package require Oratcl

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_process_lib.tcl


#Environment variables.......

#set box $env(SYS_BOX)
set box "$env(SYS_BOX)"
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
#set mailtolist $env(MAIL_TO)
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
set MASCLR::DEBUG_LEVEL 3
MASCLR::log_message "starting trans_sus_err_chk.tcl" 1

###########################################################################################################

#declaring variables for commandline arguments.

global db_logon_handle

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - open, parse and close the config file
#
#    Arguments - None
#
#    Return - exit 2, if required parameters not found
#
###############################################################################
proc readCfgFile {} {
    global cnt_limit amt_limit

    if {[catch {open trans_sus_err_chk.cfg} filePtr]} {
        MASCLR::log_message "File Open Err:trans_sus_err_chk.cfg Cannot open output file trans_sus_err_chk.cfg"
        exit 2
    }

    while { [set line [gets $filePtr]] != {}} {
      set lineParms [split $line =]
      switch -exact -- [lindex  $lineParms 0] {
            "CNT_LIMIT" {
                set cnt_limit [lindex $lineParms 1]
            }
            "AMT_LIMIT" {
                set amt_limit [lindex $lineParms 1]
            }
         default {
            MASCLR::log_message "Unknown config parameter [lindex $lineParms 0]"
          }
       }
    }

    close $filePtr
}

proc connect_to_db {} {
    global db_logon_handle box clrdb env
    if {[catch {set db_logon_handle [oralogon masclr/masclr@$env(IST_DB)]} result] } {
        MASCLR::log_message "Encountered error $result while trying to connect to DB"
    }
    return $db_logon_handle
}

proc check_counts {table handle} {
    global msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global box  clrpath  maspath  mailtolist  mailfromlist cnt_limit amt_limit mbody

    set sql3 "select count(1) susct, sum(amt_original) susamt from $table"
    MASCLR::log_message $sql3
    orasql $handle $sql3
    orafetch $handle -dataarray suscnt -indexbyname

    if {$suscnt(SUSCT) == 0} {
        MASCLR::log_message "$table count is $suscnt(SUSCT), amount $suscnt(SUSAMT)"
    } else {
        MASCLR::log_message "$table count is $suscnt(SUSCT), amount $suscnt(SUSAMT)"
        if {$suscnt(SUSCT) < $cnt_limit && $suscnt(SUSAMT) < $amt_limit} {
            set sqlcpy [format "insert into %s_wip select * from %s" $table $table]
            MASCLR::log_message "$sqlcpy"
            if {[catch {orasql $handle $sqlcpy} result]} {
                append mbody "Encountered oracle error while transferring records to the $table wip table"
                append mbody "Oracle error: [oramsg $handle all]"
                MASCLR::log_message [oramsg $handle all]
                # exit 3
            } else {
                MASCLR::log_message [oramsg $handle all]
            }

            if {$table == "MAS_TRANS_SUSPEND"} {
                set table_adn "MAS_TRANS_SUS_ADDN"
                set sqlcpy [format "insert into %s_wip select * from %s" $table_adn $table_adn]
                MASCLR::log_message "$sqlcpy"
                if {[catch {orasql $handle $sqlcpy} result]} {
                    append mbody "Encountered oracle error while transferring records to the $table_adn wip table"
                    append mbody "Oracle error: [oramsg $handle all]"
                    MASCLR::log_message [oramsg $handle all]
                    # exit 3
                } else {
                    MASCLR::log_message [oramsg $handle all]
                }

                set sqldel [ format "
                    delete %s
                    where (INSTITUTION_ID, trans_seq_nbr) in (
                        select INSTITUTION_ID, trans_seq_nbr
                        from %s_wip)
                    " $table_adn $table_adn ]
                MASCLR::log_message $sqldel
                if {[catch {orasql $handle $sqldel} result]} {
                    set emsg "Error deleting records from $table_adn"
                    MASCLR::log_message "[oramsg $handle all]"
                    append mbody "Encountered oracle error while deleting reords from the $table_adn table"
                    append mbody "Oracle error: [oramsg $handle all]"
                    # exit 3
                } else {
                    MASCLR::log_message [oramsg $handle all]
                }
            }

            set sqldel [ format "
                delete %s
                where (INSTITUTION_ID, trans_seq_nbr) in (
                    select INSTITUTION_ID, trans_seq_nbr
                    from %s_wip)
                " $table $table ]
            MASCLR::log_message $sqldel
            if {[catch {orasql $handle $sqldel} result]} {
                set emsg "Error deleting records from $table"
                MASCLR::log_message "[oramsg $handle all]"
                append mbody "Encountered oracle error while deleting reords from the $table table"
                append mbody "Oracle error: [oramsg $handle all]"
                exit 3
            } else {
                MASCLR::log_message [oramsg $handle all]
            }           
            
            MASCLR::log_message "$table count is $suscnt(SUSCT), amount is $suscnt(SUSAMT)"
            append mbody "Transactions found in $table: count $suscnt(SUSCT), amount $suscnt(SUSAMT)\n"
            append mbody "Moved to "
            append mbody $table
            append mbody "_wip table.\n\n"
            append mbody "Since, count($suscnt(SUSCT)) < $cnt_limit and amount($suscnt(SUSAMT)) < $amt_limit, continuing process for now. \n"
            append mbody "Suspends will be researched at day time and processed next day."
        } else {
            set mailtolist "notifications-clearing@jetpay.com assist@jetpay.com"
            MASCLR::log_message "$table count is $suscnt(SUSCT), amount is $suscnt(SUSAMT)"
            exec echo "Transactions found in $table : count $suscnt(SUSCT), amount is $suscnt(SUSAMT)" >> /clearing/filemgr/process.stop
            set mbody "A process.stop file generated in /clearing/filemgr/. \nACH and all Process stopped.\n Transaction found in $table: count $suscnt(SUSCT), amount is $suscnt(SUSAMT)"
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        }
    }
}; # end check_counts

#Declared few variables
global clrdb_handle

set mbody ""

readCfgFile

#Opening connection handle to DB
connect_to_db

set clrdb_handle [oraopen $db_logon_handle]

check_counts "MAS_TRANS_ERROR" $clrdb_handle
check_counts "MAS_TRANS_SUSPEND" $clrdb_handle
MASCLR::log_message "mbody length: [string length $mbody] "
if {[string length $mbody] > 0 } {
    set mailtolist "notifications-clearing@jetpay.com"        
    if {[catch {oracommit $db_logon_handle} result]} {
        oraroll $db_logon_handle
        set mbody "Encountered oracle error while commiting. Rolling back.\n"
        append mbody "Oracle error: [oramsg $db_logon_handle all]"
        MASCLR::log_message "Encountered oracle error while commiting. Rolling back."        
    } else {
        MASCLR::log_message "Commit successful."
    }
    exec echo "$mbody_m $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_m" $mailtolist
}
