#!/usr/bin/env tclsh
# ###############################################################################
# $Id: gen_on_call_summary.tcl 4770 2018-11-14 20:53:25Z skumar $
# $Rev: 4770 $
# ###############################################################################
#
# File Name:  gen_on_call_summary.tcl
#
# Description:  This script creates the summary of rejects and suspends 
#               occurred in the CLEARING and MAS system and emails the same.
#
# Running options:
#                d = date in YYYYMMDD format (optional)
#                v = debug level (optional)
#
#    Example - gen_on_call_summary.tcl -d 20161026
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - syntax error/Invalid argument
#           2 - Code logic
#           3 - DB error
#
# ###############################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib
global MODE
set MODE "PROD"

proc usage {} {
    global programName
    puts stderr "Usage: $programName -d <YYYYMMDD> -t -v"
    puts stderr "       d - date"
    puts stderr "       v - verbosity level of debug information output"
    exit 1
};

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE cfgname
    global opt_type mailtolist inst_id currdate
    set inst_id ""
    set currdate "[clock format [clock seconds] -format "%Y%m%d"]"
    while { [ set err [ getopt $argv "h:d:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               d {set currdate $optarg}
               t {
                   set mailtolist "clearing@jetpay.com"
                   set MODE "TEST"
                 }
               v {incr MASCLR::DEBUG_LEVEL}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
};

#Procedure to create database login handle
proc connect_to_dbs {} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath 
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global db_userid db_pwd

    if {[catch {set db_login_handle [oralogon $db_userid/$db_pwd@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to open the database connection handle
proc open_cursor_masclr {cursr} {
    global db_login_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global $cursr

    if {[catch {set $cursr [oraopen $db_login_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

proc free_db_dandle {} {
    global clr_get
    global db_login_handle
    # close all the DB connections
    oraclose $clr_get
    
    if { [catch {oralogoff $db_login_handle } result ] } {
       error "Encountered error $result while trying to close DB handles"
    }
};

#Procedure to initialize the variables during the startup
proc init {} {
    global fname dot jdate begintime endtime batchtime currdate
    global sdate adate edate fyear fmnth
    global rightnow
    set sdate [clock format [ clock scan "$currdate -1 day"] -format %Y%m%d110000]
    set edate [clock format [ clock scan "$currdate 0 day" ] -format %Y%m%d110000]
    set fyear [clock format [ clock scan "$currdate" ] -format %Y]
    set fmnth [clock format [ clock scan "$currdate" ] -format %m.%y]
    set begintime "000000"
    set endtime "000000"
    
    append batchtime $sdate $begintime
    puts "fyear: $fyear fmonth : $fmnth"
    MASCLR::log_message "Transaction count between $begintime :: $endtime "  3
};

#Procedure to create SQL query
proc get_sql {} {
    global mas_query clr_sus_query clr_rej_query edate sdate
    set clr_rej_query "
        select 
           eel.institution_id                                        as INST_ID,
           idm.merch_id                                              as Merch_ID,
           idm.merch_name                                            as Merch_Name,
           to_char(idm.trans_dt, 'dd-MON-yy')                        as TranDate,
           to_char(idm.activity_dt, 'dd-MON-yy')                     as SettleDate,
           substr(cs.card_scheme_name,1,10)                          as CardType,
           substr(idm.pan,1,6)||'xxxxxx'|| substr(idm.pan,13,4)      as PAN,
           idm.arn                                                   as ARN,
           idm.auth_cd                                               as AuthCode,
           (idm.amt_trans/100)                                       as Amount,
           substr(tid.description,1,30)                              as TranType,
           err_rcds.err_cd                                           as err_cd,
           err_rcds.err_msg                                          as err_desc
        from in_draft_main idm
             join  card_scheme cs on idm.card_scheme = cs.card_scheme
             join  tid on idm.tid = tid.tid
             join  ep_event_log eel on idm.trans_seq_nbr = eel.trans_seq_nbr
             left outer join  (
                 select arm.card_scheme, irm.trans_seq_nbr, arm.err_cd, arm.err_msg
                 from assoc_reject_msgs arm , ipm_reject_msg irm
                 where 
                    arm.err_cd = substr(irm.msg_error_ind, 8, 4)
                    and arm.err_cd not in ('0566', '0521')
                 union
                 select vrra.card_scheme, vrra.trans_seq_nbr, arm.err_cd, arm.err_msg
                 from visa_rtn_rclas_adn vrra, assoc_reject_msgs arm
                 where 
                    trim(vrra.return_reason_cd1) =  arm.err_cd
                 union
                 select eel.card_scheme, eel.trans_seq_nbr, arm.err_cd, arm.err_msg
                 from ep_event_log eel, assoc_reject_msgs arm
                 where 
                    eel.event_reason = 'ERET'
                    and trim(to_char(eel.reason_cd, '0009')) = arm.err_cd
              ) err_rcds on idm.trans_seq_nbr = err_rcds.trans_seq_nbr
        where 
          idm.tid like '010123005%'
          and to_char(idm.activity_dt, 'YYYYMMDDHH24MISS') >= '$sdate'
          and to_char(idm.activity_dt, 'YYYYMMDDHH24MISS') <  '$edate'
        order by  eel.institution_id,
                  substr(idm.merch_id,1,15)
    "
    set clr_sus_query "
        select 
           idm.src_inst_id                                                 as Inst_ID,
           idm.merch_id                                                    as Merch_ID,
           idm.merch_name                                                  as Merch_Name,
           to_char(idm.trans_dt, 'dd-MON-yy')                              as TranDate, 
           to_char(idm.activity_dt, 'dd-MON-yy')                           as SettleDate, 
           substr(cs.card_scheme_name,1,10)                                as CardType, 
           substr(idm.pan,1,6)||'xxxxxx'|| substr(idm.pan,13,4)            as PAN, 
           idm.arn                                                         as ARN, 
           idm.auth_cd                                                     as AuthCode, 
           idm.amt_trans/100                                               as Amount, 
           substr(tid.description,1,30)                                    as TranType, 
           trans_err_cd                                                    as err_cd,
           ec.description                                                  as err_desc
        from  in_draft_main idm
              join in_file_log ifl on ifl.in_file_nbr = idm.in_file_nbr
              join  card_scheme cs on idm.card_scheme = cs.card_scheme
              join  tid on idm.tid = tid.tid
              join trans_err_log tel on tel.trans_seq_nbr = idm.trans_seq_nbr
              join suspend_log sl    on sl.trans_seq_nbr = idm.trans_seq_nbr 
              left outer join err_cd ec on tel.trans_err_cd = ec.err_reason_cd
        where 
          trans_err_cd not in ('ENR', 'CES007')
          and sl.suspend_status = 'S'
          and ifl.external_file_name like '%tc57%'
          and to_char(ifl.end_dt, 'YYYYMMDDHH24MISS') >= '$sdate'
          and to_char(ifl.end_dt, 'YYYYMMDDHH24MISS') < '$edate'
          and ifl.in_file_status like 'P%'
        order by substr(idm.src_inst_id,1,4)
              , substr(idm.merch_id,1,15)
              , idm.card_scheme
    "
    set mas_query "
        select 
           mts.institution_id                                       as INST_ID,
           mts.entity_id                                            as MERCH_ID,
           ae.entity_dba_name                                       as Merch_Name,
           to_char(mts.activity_date_time, 'dd-MON-YY')             as ActivityDate,
           to_char(mts.gl_date, 'dd-MON-YY')                        as GLDate,
           substr(cs.card_scheme_name,1,10)                         as CardType,
           mts.trans_ref_data                                       as ARN,
           mts.amt_original                                         as AMOUNT,
           substr(tid.description,1,30)                             as TranType,
           suspend_reason                                           as err_cd,
           substr(fvc.FIELD_VALUE_DESC,1,75)                        as err_desc
        from (select * from masclr.mas_trans_suspend     union
              select * from masclr.mas_trans_suspend_wip union
              select * from masclr.mas_trans_error       union
              select * from masclr.mas_trans_error_wip) mts
           join masclr.card_scheme cs on mts.card_scheme = cs.card_scheme
           join masclr.tid on  mts.tid = tid.tid
           left outer join masclr.field_value_ctrl fvc on fvc.field_value1 = mts.suspend_reason
                and mts.institution_id = fvc.institution_id
           join masclr.acq_entity ae on ae.institution_id = mts.institution_id 
                and ae.entity_id = mts.entity_id
        where 
          to_char(mts.suspend_date, 'YYYYMMDDHH24MISS') >= '$sdate'
          and to_char(mts.suspend_date, 'YYYYMMDDHH24MISS') < '$edate'
        order by substr(mts.institution_id,1,4),
                 substr(mts.entity_id,1,15) 
    "
};

proc gen_report {} {
    global clr_get cday
    global db_login_handle mas_code_repair_sql 
    global inst_list sql_string
    global mailtolist mailfromlist msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody
    global mas_query clr_sus_query clr_rej_query currdate colval
    global chkinstid tot_clr_rej_amt insttotamt insttotcnt clr_rej tot_clr_rej_cnt del
    global fyear fmnth

    set col_list "INST_ID,MERCH_ID,MERCH_NAME,TRANDATE,SETTLEDATE,CARDTYPE,PAN,ARN,AUTHCODE,AMOUNT,TRANTYPE,ERR_CD,ERR_DESC"
    set chkinstid " "
    set tot_clr_rej_amt 0

    set insttotamt 0
    set insttotcnt 0
    set tot_clr_rej_cnt 0
    set clr_rej " "
    set del "_"

    set mbody "\n 1.  Following are clearing rejects for $currdate \n"
    if { [catch { 
        MASCLR::log_message "inside gen_report clearing reject query_string: \n$clr_rej_query\n\n" 3
        orasql $clr_get $clr_rej_query

        MASCLR::log_message "No of rows from clr_rej_query: $col_list" 3
        while {[orafetch $clr_get -dataarray s -indexbyname] != 1403} {
            set colval "$s(INST_ID),'$s(MERCH_ID)',$s(MERCH_NAME),$s(TRANDATE),$s(SETTLEDATE),\
            $s(CARDTYPE),'$s(PAN)','$s(ARN)',$s(AUTHCODE),$s(AMOUNT),$s(TRANTYPE),$s(ERR_CD),$s(ERR_DESC)"
            set tot_clr_rej_amt [format "%.02f" [expr $tot_clr_rej_amt + $s(AMOUNT)]]
            incr tot_clr_rej_cnt
            if { $chkinstid != $s(INST_ID) } {
               set insttotamt 0
               set insttotcnt 0
               set chkinstid $s(INST_ID)
               set insttotamt [format "%.02f" $s(AMOUNT)]
               incr insttotcnt
               dict set clr_rej $s(INST_ID) "$insttotcnt$del$insttotamt"
            } else {
               set insttotamt [format "%.02f" [expr $insttotamt + $s(AMOUNT)]]
               incr insttotcnt
               dict set clr_rej $s(INST_ID) "$insttotcnt$del$insttotamt"
            }
            MASCLR::log_message " clearing reject Inst id : $s(INST_ID) count : $insttotcnt  Amount : $insttotamt" 5
        }            
    } failure] } {
        set mbody "Error parsing, binding or executing gen_report sql query : $failure \n $clr_rej_query"
        error $mbody
        return 1
    }
    if { $clr_rej != " "} {
       foreach inst [lsort [dict keys $clr_rej]] {
           set val [split [dict get $clr_rej $inst] $del]
           MASCLR::log_message " Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] " 3
           append mbody "\n\t Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] "
       }
    }
    MASCLR::log_message " Total clearing reject count : $tot_clr_rej_cnt amount : $tot_clr_rej_amt" 3
    append mbody " \n\t Total clearing reject count : $tot_clr_rej_cnt amount : $tot_clr_rej_amt \n"
    
    global clr_sus tot_clr_sus_amt tot_clr_sus_cnt
    set tot_clr_sus_amt 0
    set tot_clr_sus_cnt 0
    set clr_sus " "
    set chkinstid " "
    
    if { [catch { 
        MASCLR::log_message "inside gen_report clearing suspend query_string: \n$clr_sus_query\n\n" 3
        orasql $clr_get $clr_sus_query
        append mbody "\n 2.  Following are clearing suspend for $currdate \n"
        MASCLR::log_message "No of rows from clr_sus_query: $col_list" 3
        while {[orafetch $clr_get -dataarray s -indexbyname] != 1403} {
            set colval "$s(INST_ID),'$s(MERCH_ID)',$s(MERCH_NAME),$s(TRANDATE),$s(SETTLEDATE),\
            $s(CARDTYPE),'$s(PAN)','$s(ARN)',$s(AUTHCODE),$s(AMOUNT),$s(TRANTYPE),$s(ERR_CD),$s(ERR_DESC)"
            set tot_clr_sus_amt [format "%.02f" [expr $tot_clr_sus_amt + $s(AMOUNT)]]
            incr tot_clr_sus_cnt
            if { $chkinstid != $s(INST_ID) } {
               set insttotamt 0
               set insttotcnt 0
               set chkinstid $s(INST_ID)
               set insttotamt [format "%.02f" $s(AMOUNT)]
               incr insttotcnt
               dict set clr_sus $s(INST_ID) "$insttotcnt$del$insttotamt"
            } else {
               set insttotamt [format "%.02f" [expr $insttotamt + $s(AMOUNT)]]
               incr insttotcnt
               dict set clr_sus $s(INST_ID) "$insttotcnt$del$insttotamt"
            }
            MASCLR::log_message " clearing suspend Inst id : $s(INST_ID) count : $insttotcnt Amount : $insttotamt" 5
        }            
    } failure] } {
        set mbody "Error parsing, binding or executing gen_report sql query : $failure \n $clr_sus_query"
        error $mbody
        return 1
    }
    if { $clr_sus != " " } {
       foreach inst [lsort [dict keys $clr_sus]] {
           set val [split [dict get $clr_sus $inst] $del]
           MASCLR::log_message " Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] " 3
           append mbody "\n\t Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] "
       }
    }
    MASCLR::log_message " Total Clearing suspend count: $tot_clr_sus_cnt amount : $tot_clr_sus_amt" 3
    append mbody "\n\t Total Clearing suspend count: $tot_clr_sus_cnt amount : $tot_clr_sus_amt \n"
    global mas_sus tot_mas_sus_amt tot_mas_sus_cnt
    set tot_mas_sus_amt 0
    set tot_mas_sus_cnt 0
    set col_list "INST_ID,MERCH_ID,MERCH_NAME,ACTIVITYDATE,GLDATE,CARDTYPE,PAN,ARN,AUTHCODE,AMOUNT,TRANTYPE,ERR_CD,ERR_DESC"
    set chkinstid " "
    set mas_sus " "
    if { [catch { 
        MASCLR::log_message "inside gen_report mas suspend query_string: \n$mas_query\n\n" 3
        orasql $clr_get $mas_query
        append mbody " \n 3.  Following are mas suspend for $currdate \n"
        MASCLR::log_message "No of rows from mas_query: $col_list" 3
        while {[orafetch $clr_get -dataarray s -indexbyname] != 1403} {
            set colval "$s(INST_ID),'$s(MERCH_ID)',$s(MERCH_NAME),$s(ACTIVITYDATE),$s(GLDATE),\
            $s(CARDTYPE),,'$s(ARN)',,$s(AMOUNT),$s(TRANTYPE),$s(ERR_CD),$s(ERR_DESC)"
            set tot_mas_sus_amt [format "%.02f" [expr $tot_mas_sus_amt + $s(AMOUNT)]]
            incr tot_mas_sus_cnt
            if { $chkinstid != $s(INST_ID) } {
               set insttotamt 0
               set insttotcnt 0
               set chkinstid $s(INST_ID)
               set insttotamt [format "%.02f" $s(AMOUNT)]
               incr insttotcnt
               dict set mas_sus $s(INST_ID) "$insttotcnt$del$insttotamt"
            } else {
               set insttotamt [format "%.02f" [expr $insttotamt + $s(AMOUNT)]]
               incr insttotcnt
               dict set mas_sus $s(INST_ID) "$insttotcnt$del$insttotamt"
            }
            MASCLR::log_message " MAS suspend Inst id : $s(INST_ID) Count : $insttotcnt Amount : $insttotamt" 5
        }            
    } failure] } {
        set mbody "Error parsing, binding or executing gen_report sql query : $failure \n $mas_query"
        error $mbody
        return 1
    }
    
    if { $mas_sus != " " } {
       foreach inst [lsort [dict keys $mas_sus]] {
           set val [split [dict get $mas_sus $inst] $del]
           MASCLR::log_message " Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] " 3
           append mbody "\n\t Inst id : $inst Count : [lindex $val 0] Amount : [lindex $val 1] "
       }
    }
    MASCLR::log_message " Total MAS suspend count : $tot_mas_sus_cnt amount : $tot_mas_sus_amt" 3
    append mbody "\n\t Total MAS suspend count : $tot_mas_sus_cnt amount : $tot_mas_sus_amt \n"

    set filePath "Tracking/Production\ Deposit\ Tracking/$fyear/$fmnth/OOB\ Tracking"
    append mbody "\n\n Note: Report is available in the Clearing Docs drive under $filePath directory\n\n"
    return 0

};

proc send_report {} {
    global currdate fileName programName mbody_h sysinfo mbody
    global mbody mailfromlist  mailtolist msubj_h
    global fyear fmnth
    if {[catch {exec echo "ON-CALL SUMMARY FOR $currdate \n $mbody " | \
           mutt -s "ON-CALL SUMMARY FOR $currdate" \
           -- accounting@jetpay.com operations@jetpay.com notifications-clearing@jetpay.com } result ] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
              set mbody "Unable to send the ON-CALL SUMMARY FOR $currdate: $result in $programName"
              puts $mbody
              exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
              exit 1
          }
    } else {
        MASCLR::log_message "ON-CALL SUMMARY mail successfully sent" 3
    }
};
# ##########################################################################################################

#Environment veriables.......
global db_userid db_pwd clrdb
set box $env(SYS_BOX)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)
set db_userid $env(IST_DB_USERNAME)
set db_pwd $env(IST_DB_PASSWORD)

global programName

set programName [file tail $argv0]
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

###########################################################################################################
### MAIN ##################################################################################################
###########################################################################################################
proc main {} {
    #GLOBALS
    
    global arr_cfg s_name fname dot cnt_type run_mnth run_year db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb
    global msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    #set_var
    arg_parse
    init

    #sql logon handles #################################################

    connect_to_dbs
    open_cursor_masclr clr_get
    get_sql
    gen_report
    send_report
    free_db_dandle
    MASCLR::close_all_and_exit_with_code 0
};

main
