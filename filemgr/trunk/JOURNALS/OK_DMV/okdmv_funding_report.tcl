#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: okdmv_funding_report.tcl

# $Id: okdmv_funding_report.tcl 2317 2013-05-23 22:15:45Z bjones $

################################################################################
#
#    File Name -okdmv_funding_report.tcl
#
#    Description -This s a funding report for Jetpay to balance OKDMV
#
#    Arguments - $1 Date to run the report.
#                If no argument, the default is today's date.  EX. 20130204
#
################################################################################

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


    set cfg_file_name OK_DMV.cfg

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

puts "okdmv_funding_report.tcl Started"
if { [lindex $argv 0] == "" } {
    set run_date [clock format [clock scan "-1 day" ]  -format "%Y%m%d"]
} else {
    set run_date [lindex $argv 0]
}

set today_date    "[clock format [clock scan  $run_date        ] -format "%Y%m%d"]060000"
set tomorrow_date "[clock format [clock scan "$run_date +1 day"] -format "%Y%m%d"]060000"

puts "today (run day): $today_date"
puts "tomorrow: $tomorrow_date"
set Query_sql "SELECT th.mid,
        m.long_name,
        m.visa_id,
        substr(settle_date, 0, 8) as SETTLE_DATE,
        substr(shipdatetime, 0, 8) as SHIP_DATE,
       SUM(CASE WHEN card_type = 'AX' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS AX_AMOUNT,
       SUM(CASE WHEN card_type = 'AX' THEN 1 ELSE 0 END)AS AX_Count,
       SUM(CASE WHEN card_type = 'DS' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS DS_AMOUNT,
       SUM(CASE WHEN card_type = 'DS' THEN 1 ELSE 0 END)AS DS_count,
       SUM(CASE WHEN card_type = 'MC' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS MC_AMOUNT,
       SUM(CASE WHEN card_type = 'MC' THEN 1 ELSE 0 END)AS MC_count,
       SUM(CASE WHEN card_type = 'VS' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS VS_AMOUNT,
       SUM(CASE WHEN card_type = 'VS' THEN 1 ELSE 0 END)AS VS_count,
       SUM(CASE WHEN card_type = 'DB' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS DB_AMOUNT,
       SUM(CASE WHEN card_type = 'DB' THEN 1 ELSE 0 END)AS DB_count,
       sum(amount * decode(substr(request_type, 1, 2), '04', -1, 1)) as Total_amount,
       sum(fee_amount *
            decode(substr(request_type, 1, 2), '04', -1, 1)) as Convenience_amount,
       sum(amount * decode(substr(request_type, 1, 2), '04', -1, 1)) -
            sum(fee_amount * decode(substr(request_type, 1, 2), '04', -1, 1))
                                                                    as Net_amount
    FROM   teihost.tranhistory th, merchant m
    where m.mmid in (SELECT mmid FROM master_merchant WHERE shortname = 'OKDMV')
    and settle_date >= '$today_date'
    and settle_date < '$tomorrow_date'
    and th.mid = m.mid
    GROUP BY th.mid, m.long_name, m.visa_id,
            substr(settle_date, 0, 8), substr(shipdatetime, 0, 8)
    ORDER BY m.visa_id"

#puts $Query_sql
#set today_date [string range $today_date 0 7]
set fileName "OKDMV-Funding-$run_date.csv"

readCfgFile
connect_to_db
set auth_sql [oraopen $auth_logon_handle]
set mas_sql [oraopen $mas_logon_handle]

set    header "MID,Name,VISA ID,Settle Date,Ship Date,Amex Amount,Amex Count,"
append header "Disc Amount,Disc Count,MC Amount,MC Count,Visa Amount,Visa Count,"
append header "Debit Amount,Debit Count,Transaction Amount,Convenience Amount,Net Amount"
set body ""
orasql $auth_sql $Query_sql
while {[orafetch $auth_sql -dataarray auth_query -indexbyname] != 1403 } {
    set info    "$auth_query(MID),$auth_query(LONG_NAME),$auth_query(VISA_ID),"
    append info "$auth_query(SETTLE_DATE),$auth_query(SHIP_DATE),"
    append info "$auth_query(AX_AMOUNT),$auth_query(AX_COUNT),"
    append info "$auth_query(DS_AMOUNT),$auth_query(DS_COUNT),"
    append info "$auth_query(MC_AMOUNT),$auth_query(MC_COUNT),"
    append info "$auth_query(VS_AMOUNT),$auth_query(VS_COUNT),"
    append info "$auth_query(DB_AMOUNT),$auth_query(DB_COUNT),"
    append info "$auth_query(TOTAL_AMOUNT),$auth_query(CONVENIENCE_AMOUNT),"
    append info "$auth_query(NET_AMOUNT)\r\n"
    append body $info
}

exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a $fileName \
    -s "OKDMV funding Report for $run_date" \
    -- accounting@jetpay.com reports-clearing@jetpay.com  < $fileName
exec mv $fileName ARCHIVE
set body ""

puts "okdmv_funding_report.tcl for amex only Started"

set Query_sql "SELECT th.mid,
        m.long_name,
        m.visa_id,
        substr(settle_date,0,8) as settle_date,
        substr(shipdatetime,0,8) as ship_date,
        SUM(CASE WHEN card_type = 'AX' THEN amount *
            decode(substr(request_type, 1, 2), '04', -1, 1) ELSE 0 END) AS AX_AMOUNT,
        SUM(CASE WHEN card_type = 'AX' THEN 1 ELSE 0 END) AS AX_Count
    FROM   teihost.tranhistory th, merchant m
    where m.mmid in (SELECT mmid FROM master_merchant WHERE shortname = 'OKDMV')
    and settle_date >= '$today_date'
    and settle_date < '$tomorrow_date'
    and th.mid = m.mid
    GROUP BY th.mid, m.long_name, m.visa_id, substr(settle_date,0,8),
        substr(shipdatetime,0,8)
    ORDER BY m.visa_id"

#puts $Query_sql
#set today_date [string range $today_date 0 7]
set fileName "OKDMV-AMEX-Funding-$run_date.csv"

set header "MID,Name,VISA ID,Settle Date,Ship Date,Amex Amount,Amex Count"
orasql $auth_sql $Query_sql
while {[orafetch $auth_sql -dataarray auth_query -indexbyname] != 1403 } {
    set    info "$auth_query(MID),$auth_query(LONG_NAME),$auth_query(VISA_ID),"
    append info "$auth_query(SETTLE_DATE),$auth_query(SHIP_DATE),"
    append info "$auth_query(AX_AMOUNT),$auth_query(AX_COUNT)\r\n"

    append body $info
}

exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a $fileName \
    -s "OKDMV AMEX funding Report for $run_date" \
    -- gary@megawat.com reports-clearing@jetpay.com < $fileName
exec mv $fileName ARCHIVE

exit 0
