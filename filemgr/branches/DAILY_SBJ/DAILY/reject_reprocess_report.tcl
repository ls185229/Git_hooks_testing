#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: reject_reprocess_report.tcl 4342 2017-09-13 18:24:38Z fcaron $
# $Rev: 4342 $
################################################################################
#
#    File Name   -  reject_reprocess_report.tcl
#
#    Description -  This script generates the association and reverals
#                   rejects by institution.
#
#    Arguments   -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  reject_reprocess_report.tcl -D yyyymmdd -F config_file.cfg
#
#                   e.g.   reject_reprocess_report.tcl -d 2015032 -f test.cfg
#
################################################################################

package require Oratcl

################################################################################

##########################################
# readCfgFile
##########################################

proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global argv mail_to mail_err inst_list

   set clr_db_logon ""
   set clr_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name reject_reprocess_report.cfg 
          puts " Default Config File: $cfg_file_name"
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " *** File Open Err: Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ~]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "MAIL_ERR" {
            set mail_err [lindex $line_parms 1]
         }
         "MAIL_TO" {
            set mail_to [lindex $line_parms 1]
            puts " mail_to: $mail_to"
         }
         "INST_LIST" {
            set inst_list [lindex $line_parms 1]
            puts " inst_list: $inst_list"
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

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global clr_logon_handle
   global clr_db_logon
   global clr_db
   if {[catch {set clr_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts " Connected to clr_db"
   }
}

##########################################
# arg_parse
##########################################

proc arg_parse {} {
   global argv date_arg 

   #scan for Date
   if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
         puts " Date argument:   $arg_date"
         set date_arg $arg_date
   }
}

##########################################
# init_dates
##########################################

proc init_dates {val} {
    global curdate requested_date yesterday today tomorrow filedate  

    set curdate        [clock format   [clock seconds] -format %b-%d-%Y]
    set requested_date [clock format   [clock scan "$val"] -format %b-%d-%Y]

    set today          [string toupper [clock format [clock scan "$val" -format %Y%m%d] -format %d-%b-%Y]]   
    set yesterday      [string toupper [clock format [clock scan "$today -1 day"] -format %d-%b-%Y]]
    set tomorrow       [string toupper [clock format [clock scan "$today +1 day"] -format %d-%b-%Y]]

    set filedate       [clock format   [clock scan "$today"] -format %Y%m%d]                                

    puts " Generated Date:  $curdate" 
    puts " Requested Date:  $requested_date" 
    puts " Start Date:      $yesterday" 
    puts " End Date:        $today"
}

#===============================================================================
#=====================      ASSOCIATION REJECT      ============================
#===============================================================================

##########################################
# do_association_report
##########################################

proc do_association_report {inst} {
 puts "Inst = $inst"    
    global curdate requested_date today filedate tomorrow  
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to 

    set file_name     "$sql_inst.Association_Reject_Report_v2.$filedate.csv"
    set cur_file      [open "$file_name" w]
    set mclist        ""
    set vslist        ""
    set axlist        ""
    set dslist        ""

    set MC_C_TOTAL    0
    set MC_D_TOTAL    0
    set VS_C_TOTAL    0
    set VS_D_TOTAL    0
    set AX_C_TOTAL    0
    set AX_D_TOTAL    0
    set DS_C_TOTAL    0
    set DS_D_TOTAL    0
    
    set sec_dest_inst_id ""
    set merch_id ""
    set merch_name ""
    set trans_dt ""
    set activity_dt ""
    set card_scheme_name ""
    set pan ""
    set arn ""
    set auth_cd ""
    set amt_trans 0
    set amt_recon 0
    set trans_ccd ""
    set description ""
    set reason_cd ""


#    set query_string1 "
#        SELECT ep.EP_EVENT_ID,
#               ep.TRANS_SEQ_NBR,
#               substr(ind.merch_id,1,6)                         as isono,
#               ind.REASON_CD                                    as REASON,
#               replace(ind.AMT_TRANS, ',', '') /100             as AMOUNT,
#               ep.pan                                           as ACCT,
#               ep.EVENT_LOG_DATE                                as A_DATE,
#               ep.institution_id,
#               ep.CARD_SCHEME,
#               ind.ACTIVITY_DT,
#               trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
#               ind.tid,
#               tid.TID_SETTL_METHOD                             as INDICATOR,
#               TID.DESCRIPTION                                  as TRAN_CODE
#        FROM  ep_event_log ep, in_draft_main ind, tid
#        WHERE ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
#          AND ind.tid = tid.tid
#          AND ep.CARD_SCHEME in ('03', '04', '05', '08')
#          AND ep.EMS_ITEM_TYPE in ('CR1','CR2','PR1')
#          AND ep.Event_log_date >= to_date('$today', 'DD-MON-YY')
#          AND ep.Event_log_date <  to_date('$today', 'DD-MON-YY') + 1
#          AND ep.institution_id in ('$sql_inst')
#          AND ind.in_file_nbr in (select in_file_nbr 
#                                  from  in_file_log 
#                                 where end_dt >= to_date('$today', 'DD-MON-YY')
#                                   and end_dt <  to_date('$today', 'DD-MON-YY') + 1 )
#        ORDER BY ep.TRANS_SEQ_NBR "
#set today '12-JUN-2017'
#set tomorrow '13-JUN-2017'

set query_string1 "
SELECT  
    ep.EP_EVENT_ID,
    ep.TRANS_SEQ_NBR,
    ep.card_scheme,
    substr(idn.sec_dest_inst_id,1,4) sec_dest_inst_id, 
    substr(idn.merch_id,1,15) merch_id, 
    REPLACE(idn.merch_name, ',', '') merch_name, 
    substr(idn.trans_dt,1,9) trans_dt, 
    substr(idn.activity_dt,1,9) activity_dt, 
    substr(cs.card_scheme_name,1,10) card_scheme_name, 
    substr(idn.pan,1,6)||'*'|| substr(idn.pan,13,4) pan, 
    idn.arn arn, 
    idn.auth_cd auth_cd, 
    case when tid.tid_settl_method = 'D' then -1 else 1 end * idn.amt_trans * power(10, -idn.trans_exp) amt_trans, 
    case when tid.tid_settl_method = 'D' then -1 else 1 end * idn.amt_recon * power(10, -idn.recon_exp) amt_recon, 
    idn.trans_ccd trans_ccd, 
    substr(tid.description,1,30) description, 
    idn.reason_cd reason_cd,
    idn.trans_seq_nbr,
    err_rcds.err_cd err_cd,
    replace(err_rcds.err_msg,',',' ') err_desc
from  
    in_draft_main idn 
    join ep_event_log ep on ep.TRANS_SEQ_NBR = idn.trans_seq_nbr 
    join card_scheme cs ON cs.card_scheme = idn.card_scheme 
    join tid on tid.tid = idn.tid and (idn.tid like '010123005%' or idn.tid like '010103005%') 
    left outer join tid_adn on tid_adn.tid = idn.tid 
    left outer join  
    (
        select 
            arm.card_scheme, 
            irm.trans_seq_nbr, 
            arm.err_cd, arm.err_msg
        from 
            assoc_reject_msgs arm , ipm_reject_msg irm
        where 
            arm.err_cd = substr(irm.msg_error_ind, 8, 4) and
            arm.err_cd not in ('0566', '0521')
        union
        select 
            vrra.card_scheme, 
            vrra.trans_seq_nbr, 
            arm.err_cd, 
            arm.err_msg
        from 
            visa_rtn_rclas_adn vrra, assoc_reject_msgs arm, in_draft_main idn
        where 
            trim(vrra.return_reason_cd1) =  arm.err_cd 
        union
        select 
            eel.card_scheme, 
            eel.trans_seq_nbr, 
            arm.err_cd, arm.err_msg
        from 
            ep_event_log eel, assoc_reject_msgs arm
        where 
        eel.event_reason = 'ERET' and
        trim(to_char(eel.reason_cd, '0009')) = arm.err_cd 
   ) err_rcds on idn.trans_seq_nbr = err_rcds.trans_seq_nbr WHERE 
    ep.EMS_ITEM_TYPE in ('CR1','CR2','PR1') and 
    ep.Event_log_date >= to_date('$today', 'DD-MON-YY') and ep.Event_log_date <  to_date('$tomorrow', 'DD-MON-YY') and 
    (substr(idn.pan,1,1) not in ('x','0','') OR idn.pan is not NULL) AND 
    ep.CARD_SCHEME in ('03', '04', '05', '08') and 
    idn.in_file_nbr in (select in_file_nbr from   
    in_file_log where end_dt >= to_date('$today', 'DD-MON-YY') and end_dt <  to_date('$tomorrow', 'DD-MON-YY')) and
    idn.sec_dest_inst_id in ('$sql_inst') 
ORDER BY 
    card_scheme_name, 
    idn.SEC_DEST_INST_ID, 
    idn.TRANS_SEQ_NBR"
    
# puts "Association Query: $query_string1"

    orasql $fetch_cursor1 $query_string1

    while {[orafetch $fetch_cursor1 -dataarray s -indexbyname] != 1403} {
            set TRANO $s(TRANS_SEQ_NBR)
            if  {$s(CARD_SCHEME) == "03"} {
                 lappend axlist $s(EP_EVENT_ID) 
            } elseif {$s(CARD_SCHEME) == "04"} {
                 lappend vslist $s(EP_EVENT_ID)
            } elseif {$s(CARD_SCHEME) == "05"} {
                 lappend mclist $s(EP_EVENT_ID)
            } elseif {$s(CARD_SCHEME) == "08"} {
                 lappend dslist $s(EP_EVENT_ID)                    
            } 
             
        #    set EPID                  $s(EP_EVENT_ID)
        #    set TRANS_SEQ_NBR($EPID)  $s(TRANS_SEQ_NBR)
        #    set ACCOUNT_NBR($EPID)    [string replace $s(ACCT) 5 13 xxxxxxxxx ]
        #    set DATE($EPID)           $s(A_DATE)
        #    set REASON($EPID)         $s(REASON)
        #    set AMOUNT($EPID)         $s(AMOUNT)
        #    set INDICATOR($EPID)      $s(INDICATOR)
        #    set REF_NO($EPID)         $s(ARN)
        #    set TRAN_CODE($EPID)      $s(TRAN_CODE)
        #    set CARD_TYPE($EPID)      $s(CARD_SCHEME)

        set EPID $s(EP_EVENT_ID)    
        set TRANS_SEQ_NBR($EPID) $s(TRANS_SEQ_NBR) 
        set SEC_DEST_INST_ID($EPID) $s(SEC_DEST_INST_ID) 
        set MERCH_ID($EPID) $s(MERCH_ID) 
        set MERCH_NAME($EPID) $s(MERCH_NAME) 
        set TRANS_DT($EPID) $s(TRANS_DT) 
        set ACTIVITY_DT($EPID) $s(ACTIVITY_DT) 
        set CARD_SCHEME_NAME($EPID) $s(CARD_SCHEME_NAME) 
        set PAN($EPID) $s(PAN) 
        set ARN($EPID) $s(ARN) 
        set AUTH_CD($EPID) $s(AUTH_CD) 
        set AMT_TRANS($EPID) $s(AMT_TRANS) 
        set AMT_RECON($EPID) $s(AMT_RECON) 
        set TRANS_CCD($EPID) $s(TRANS_CCD) 
        set DESCRIPTION($EPID) $s(DESCRIPTION)
        set REASON_CD($EPID) $s(REASON_CD) 
        set ERR_CD($EPID) $s(ERR_CD)
        set ERR_DESC($EPID) $s(ERR_DESC)
    }

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    puts -nonewline $cur_file "Visa,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"
    foreach tno $vslist {
         if {$AMT_TRANS($tno) != "0" } {
             puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),'$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
             puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHEME_NAME($tno),'$PAN($tno),'$ARN($tno),$AUTH_CD($tno),"
             puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
             puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno")
         }
    }
    puts $cur_file "     "
    puts $cur_file "     "

    puts -nonewline $cur_file "MasterCard,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"
    foreach tno $mclist {
         if {$AMT_TRANS($tno) != "0" } {
             puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),'$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
             puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHEME_NAME($tno),'$PAN($tno),'$ARN($tno),$AUTH_CD($tno),"
             puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
             puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"
        }
    }
    puts $cur_file "     "
    puts $cur_file "     "

    puts -nonewline $cur_file "Discover,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"
    foreach tno $dslist {
         if {$AMT_TRANS($tno) != "0" } {
             puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),'$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
             puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHEME_NAME($tno),'$PAN($tno),'$ARN($tno),$AUTH_CD($tno),"
             puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
             puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"
         }
    }
    puts $cur_file "     "
    puts $cur_file "     "
    puts -nonewline $cur_file "Amex,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"

    foreach tno $axlist {
         if {$AMT_TRANS($tno) != "0" } {
             puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),'$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
             puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHEME_NAME($tno),'$PAN($tno),'$ARN($tno),$AUTH_CD($tno),"
             puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
             puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"
         }
    }
    puts $cur_file "    "
    puts $cur_file "    "

    close $cur_file

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"

    exec mv $file_name ./ARCHIVE
}

#===============================================================================
#=====================       REVERSAL REJECT        ============================
#===============================================================================

##########################################
# do_reprocessed_report
##########################################

proc do_reversal_report {inst} {

    global curdate requested_date yesterday today filedate
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to 

    set file_name     "$sql_inst.Reversed_Reject_Report_v2.$filedate.csv"
    set cur_file      [open "$file_name" w]

    set mclist        ""
    set vslist        ""
    set axlist        ""
    set dslist        ""

    #set MC_C_TOTAL    0
    #set MC_D_TOTAL    0
    #set VS_C_TOTAL    0
    #set VS_D_TOTAL    0
    #set AX_C_TOTAL    0
    #set AX_D_TOTAL    0
    #set DS_C_TOTAL    0
    #set DS_D_TOTAL    0

    #set query_string2 " 
    #    SELECT replace(ind.AMT_TRANS, ',', '')/100              as AMOUNT,
    #           ind.SEC_DEST_INST_ID                             as INSTID,
    #           substr(ind.merch_id,1,6)                         as ISONO,
    #           ind.TRANS_SEQ_NBR,
    #           ind.pan                                          as ACCT,
    #           ind.activity_dt                                  as I_DATE,
    #           ind.card_scheme,
    #           trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
    #           tid.TID_SETTL_METHOD                             as INDICATOR,
    #           tid.DESCRIPTION                                  as TRAN_CODE
    #    FROM  in_draft_main ind, tid
    #    WHERE ind.tid = tid.tid
    #      AND ind.msg_text_block like '%JPREJECT%'
    #      AND ind.card_scheme in ('03', '04', '05', '08')
    #      AND ind.activity_dt >= to_date('$yesterday', 'DD-MON-YY')
    #      AND ind.activity_dt <  to_date('$yesterday', 'DD-MON-YY') + 1
    #      AND ind.in_file_nbr in (select in_file_nbr 
    #                              from  in_file_log 
    #                              where end_dt >= to_date('$yesterday', 'DD-MON-YY')
    #                                and end_dt <  to_date('$yesterday', 'DD-MON-YY') + 1)
    #      AND ind.SEC_DEST_INST_ID in ('$sql_inst')  "

    set query_string2 "
        SELECT  
        substr(idn.sec_dest_inst_id,1,4) sec_dest_inst_id, 
        substr(idn.merch_id,1,15) merch_id, 
        REPLACE(idn.merch_name, ',', '') merch_name, 
        substr(idn.trans_dt,1,9) trans_dt, 
        substr(idn.activity_dt,1,9) activity_dt, 
        substr(cs.card_scheme_name,1,10) card_scheme_name, 
        substr(idn.pan,1,6)||'*'|| substr(idn.pan,13,4) pan, 
        idn.arn arn, 
        idn.auth_cd auth_cd, 
        case when tid.tid_settl_method = 'D' then -1 else 1 end * idn.amt_trans * power(10, -idn.trans_exp) amt_trans, 
        case when tid.tid_settl_method = 'D' then -1 else 1 end * idn.amt_recon * power(10, -idn.recon_exp) amt_recon, 
        idn.trans_ccd trans_ccd, 
        substr(tid.description,1,30) description, 
        idn.reason_cd reason_cd, 
        err_rcds.err_cd err_cd,
        replace(err_rcds.err_msg,',',' ') err_desc
    from  
        in_draft_main idn 
        join mas_trans_log mtl on mtl.TRANS_REF_DATA = idn.arn
        join ep_event_log ep on ep.TRANS_SEQ_NBR = idn.trans_seq_nbr 
        join card_scheme cs ON cs.card_scheme = idn.card_scheme 
        join tid on tid.tid = idn.tid  
        left outer join tid_adn on tid_adn.tid = idn.tid 
        left outer join  
        (
        select 
            arm.card_scheme, 
            irm.trans_seq_nbr, 
            arm.err_cd, arm.err_msg
        from 
            assoc_reject_msgs arm , ipm_reject_msg irm
        where 
            arm.err_cd = substr(irm.msg_error_ind, 8, 4) and
            arm.err_cd not in ('0566', '0521')
        union
        select 
            vrra.card_scheme, 
            vrra.trans_seq_nbr, 
            arm.err_cd, 
            arm.err_msg
        from 
            visa_rtn_rclas_adn vrra, assoc_reject_msgs arm, in_draft_main idn
        where 
            trim(vrra.return_reason_cd1) =  arm.err_cd 
        union
        select 
            eel.card_scheme, 
            eel.trans_seq_nbr, 
            arm.err_cd, arm.err_msg
        from 
            ep_event_log eel, assoc_reject_msgs arm
        where 
            eel.event_reason = 'ERET' and
            trim(to_char(eel.reason_cd, '0009')) = arm.err_cd 
    ) err_rcds on idn.trans_seq_nbr = err_rcds.trans_seq_nbr  
    WHERE 
       (substr(idn.pan,1,1) not in ('x','0','') OR idn.pan is not NULL)  
       AND idn.tid in ('010003005201','010003005202')
       AND idn.card_scheme in ('03', '04', '05', '08')
       AND idn.in_file_nbr in (select in_file_nbr from   
       in_file_log where end_dt >= to_date('$yesterday', 'DD-MON-YY') and end_dt <  to_date('$today', 'DD-MON-YY')) 
    ORDER BY idn.SEC_DEST_INST_ID, card_scheme_name, idn.TRANS_SEQ_NBR"
    
   # puts "Reprocessed Query: $query_string2"

    orasql $fetch_cursor2 $query_string2

    while {[orafetch $fetch_cursor2 -dataarray inr -indexbyname ] != 1403 } {
            set TRANO $inr(TRANS_SEQ_NBR)
            if  {$inr(CARD_SCHEME) == "03"} {
                 lappend axlist $TRANo
            } elseif {$inr(CARD_SCHEME) == "04"} {
                 lappend vslist $TRANO                    
            } elseif {$inr(CARD_SCHEME) == "05"} {
                 lappend mclist $TRANO                    
            } elseif {$inr(CARD_SCHEME) == "08"} {
                 lappend dslist $TRANO                    
            }

        #    set ACCOUNT_NBR($TRANO) [string replace $inr(ACCT) 5 13 xxxxxxxxx ]
        #    set DATE($TRANO) $inr(I_DATE)
        #    set REASON($TRANO) "NA"
        #    set AMOUNT($TRANO) $inr(AMOUNT)
        #    set REF_NO($TRANO) $inr(ARN)
        #    set TRAN_CODE($TRANO) $inr(TRAN_CODE)
        #    set INDICATOR($TRANO) $inr(INDICATOR)
        
        set TRANO $s(TRANS_SEQ_NBR)
        set SEC_DEST_INST_ID($TRANO) $inr(SEC_DEST_INST_ID)
        set MERCH_ID($TRANO) $inr(MERCH_ID)
        set MERCH_NAME($TRANO) $inr(MERCH_NAME)
        set TRANS_DT($TRANO) $inr(TRANS_DT)
        set ACTIVITY_DT($TRANO) $inr(ACTIVITY_DT)
        set CARD_SCHEME_NAME($TRANO) $inr(CARD_SCHEME_NAME)
        set PAN($TRANO) $inr(PAN)
        set ARN($TRANO) $inr(ARN)
        set AUTH_CD($TRANO) $inr(aUTH_CD)
        set AMT_TRANS($TRANO) $inr(AMT_TRANS)
        set AMT_RECON($TRANO) $inr(AMT_RECON)
        set TRANS_CCD($TRANO) $inr(TRANS_CCD)
        set DESCRIPTION($TRANO) $inr(DESCRIPTION)
        set REASON_CD($TRANO) $inr(REASON_CD)
        set ERR_CD($TRANO) $s(ERR_CD)
        set ERR_DESC($TRANO) $s(ERR_DESC)
}        

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    puts -nonewline $cur_file "Visa,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"

    foreach tno $vslist {
         if {$AMT_TRANS($tno) != "0"} {
             puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
             puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHENE_NAME($tno),$PAN($tno),$ARN($tno),$AUTH_CD($tno),"
             puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
             puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"
         }
    }

    puts $cur_file "     "
    puts $cur_file "     "

    puts -nonewline $cur_file "MaserCard,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"
      
    foreach tno $mclist {
         if {$AMT_TRANS($tno) != "0"} {
           puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
           puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHENE_NAME($tno),$PAN($tno),$ARN($tno),$AUTH_CD($tno),"
           puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
           puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"
         }
    }

    puts $cur_file "      "
    puts $cur_file "      "

    puts -nonewline $cur_file "Discover,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"

    foreach tno $dslist {
         if {$AMT_TRANS($tno) != "0"} {
           puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
           puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHENE_NAME($tno),$PAN($tno),$ARN($tno),$AUTH_CD($tno),"
           puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
           puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"

         }
    }

    puts $cur_file "      "
    puts $cur_file "      "

    puts -nonewline $cur_file "Amex,Inst,Merch Id,Merch Name,Trans Date,Activity Date,Card Scheme,PAN,ARN,"
    puts $cur_file "Auth Code,Amt Trans,Amt Recon,Curr Code,Description,Reason,Err Code,Err Description"

    foreach tno $axlist {
         if {$AMT_TRANS($tno) != "0"} {
           puts -nonewline $cur_file ",$SEC_DEST_INST_ID($tno),$MERCH_ID($tno),$MERCH_NAME($tno),$TRANS_DT($tno),"
           puts -nonewline $cur_file "$ACTIVITY_DT($tno),$CARD_SCHENE_NAME($tno),$PAN($tno),$ARN($tno),$AUTH_CD($tno),"
           puts -nonewline $cur_file "$AMT_TRANS($tno),$AMT_RECON($tno),$TRANS_CCD($tno),$DESCRIPTION($tno),$REASON_CD($tno),"
           puts $cur_file "$ERR_CD($tno),$ERR_DESC($tno)"

         }
    }

    puts $cur_file "     "
    puts $cur_file "     "

    close $cur_file

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"

    exec mv $file_name ./ARCHIVE
}

##########################################
# MAIN
##########################################

readCfgFile

connect_to_db

set fetch_cursor1 [oraopen $clr_logon_handle]
set fetch_cursor2 [oraopen $clr_logon_handle]

arg_parse

if {![info exists date_arg]} {
      init_dates [clock format [clock seconds] -format %Y%m%d]
} else {
      init_dates $date_arg
}

foreach sql_inst $inst_list {
     do_association_report $sql_inst
     do_reversal_report $sql_inst
}

oraclose $fetch_cursor1
oraclose $fetch_cursor2
oralogoff $clr_logon_handle
