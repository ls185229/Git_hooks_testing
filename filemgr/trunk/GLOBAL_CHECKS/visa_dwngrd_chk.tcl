#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: visa_dwngrd_chk.tcl 4451 2017-12-19 17:19:07Z bjones $

package require Oratcl

#####################################################################################

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mail_to "reports-clearing@jetpay.com,procstats@jetpay.com"
# set mail_to "bjones@jetpay.com"
set mailfromlist $env(MAIL_FROM)
set mode "PROD"

set clrdb $env(CLR4_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set authdb $env(TSP4_DB)

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

set sysinfo "System: $box\n Location: $env(PWD)\nScript: visa_dwngrd_chk.tcl \n\n"

#####################################################################################

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set inst_id [lindex $argv 0]
set tsk_nbr [lindex $argv 1]

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist
    global mailfromlist clrdb authdb clruser clrpwd 

    if {[catch {set db_logon_handle [oralogon $clruser/$clrpwd@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "Could not connect to DB. Please look at or rerun the script $env(PWD)/visa_dwngrd_chk.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
        puts "COnnected"
    }
};# end connect_to_db

connect_to_db

set logdate [clock seconds]
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
set req_date $e_date
set curdate [clock format $logdate -format "%Y%m%d"]

set get [oraopen $db_logon_handle]
set l_update [oraopen $db_logon_handle]

set x ""
set file_name "Rollup_Visa_Reclass.$curdate.csv"
set cur_file  [open "$file_name" w]

set sql1 "
    select
        idm.merch_id, idm.merch_name,
        idm.trans_seq_nbr, idm.arn, idm.amt_trans,
        idm.trans_dt, idm.activity_dt, idm.mas_code,
        idm.mas_code_downgrade, vrra.fee_prog_ind_rcl_r
    from in_draft_main idm, visa_rtn_rclas_adn vrra
    where idm.trans_seq_nbr = vrra.trans_seq_nbr
    and vrra.src_batch_date >= to_date('$e_date', 'DD-MON-YY')
    and vrra.src_batch_date <  to_date('$e_date', 'DD-MON-YY') + 1
    order by idm.merch_id, idm.trans_seq_nbr"
puts $sql1

set sql2 "
    select
        count(1) cnt, vrra.DERIVED_IRF_DESC, vrra.SETTLED_IRF_DESC,
        vrra.src_batch_date, vrra.PMT_SV_RECL_REASON
    from visa_rtn_rclas_adn vrra
    where vrra.src_batch_date >= to_date('$e_date', 'DD-MON-YY')
    and vrra.src_batch_date <  to_date('$e_date', 'DD-MON-YY') + 1
    and vrra.PMT_SV_RECL_REASON <> ' '
    group by
        vrra.src_batch_date, vrra.DERIVED_IRF_DESC, vrra.SETTLED_IRF_DESC,
        vrra.PMT_SV_RECL_REASON
    order by vrra.src_batch_date"
puts $sql2
catch {orasql $l_update $sql2} result
puts $result

set z "Date Generated:,$e_date\nDate Requested:,$req_date\n Totals:\n\n"
append z "COUNT,DERIVED_IRF_DESC,SETTLED_IRF_DESC,SRC_BATCH_DATE,PMT_SV_RECL_REASON\n"
while {[set y [orafetch $l_update -datavariable x]] == 0} {
    append z "[lindex $x 0],"
    append z "[string trim [lindex $x 1]],"
    append z "[string trim [lindex $x 2]],"
    append z "[lindex $x 3],[lindex $x 4]\n"
}

if {$x != ""} {
    puts $cur_file "$z"

    close $cur_file

    if {$mode == "TEST"} {
        if { [catch { exec echo "Please see attached." | \
                mutt -a "$file_name" -s "$file_name" -- "$env(SCRIPT_USER)@jetpay.com" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
    } elseif {$mode == "PROD"} {
        if { [catch {
                set mbody "Please run the sql for details on the downgraded visa transactions.\n"
                exec echo "$sysinfo $mbody $sql1\n\n" | \
                    mutt -a "$file_name" -s "$file_name" -- "$mail_to" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
    }

    exec mv $file_name ./ARCHIVE

} else {
    puts "No Visa Downgrades"
}

oralogoff $db_logon_handle
