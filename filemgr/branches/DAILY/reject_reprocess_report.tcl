#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: reject_reprocess_report.tcl 3681 2016-02-19 22:17:42Z bjones $
# $Rev: 3681 $
################################################################################
#
#    File Name   -  reject_reprocess_report.tcl
#
#    Description -  This script generates the association and reprocess
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

proc arg_parse {} {
   global argv date_arg 

   #scan for Date
   if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
         puts " Date argument:   $arg_date"
         set date_arg $arg_date
   }
}

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

proc do_association_report {inst} {
    
    global curdate requested_date today filedate  
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to 

    set file_name     "$sql_inst.Association_Reject_Report.$filedate.csv"
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

    set query_string1 "
        SELECT ep.EP_EVENT_ID,
               ep.TRANS_SEQ_NBR,
               substr(ind.merch_id,1,6)                         as isono,
               ind.REASON_CD                                    as REASON,
               replace(ind.AMT_TRANS, ',', '') /100             as AMOUNT,
               ep.pan                                           as ACCT,
               ep.EVENT_LOG_DATE                                as A_DATE,
               ep.institution_id,
               ep.CARD_SCHEME,
               ind.ACTIVITY_DT,
               trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
               ind.tid,
               tid.TID_SETTL_METHOD                             as INDICATOR,
               TID.DESCRIPTION                                  as TRAN_CODE
        FROM  ep_event_log ep, in_draft_main ind, tid
        WHERE ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
          AND ind.tid = tid.tid
          AND ep.CARD_SCHEME in ('03', '04', '05', '08')
          AND ep.EMS_ITEM_TYPE in ('CR1','CR2','PR1')
          AND ep.Event_log_date >= to_date('$today', 'DD-MON-YY')
          AND ep.Event_log_date <  to_date('$today', 'DD-MON-YY') + 1
          AND ep.institution_id in ('$sql_inst')
          AND ind.in_file_nbr in (select in_file_nbr 
                                  from  in_file_log 
                                  where end_dt >= to_date('$today', 'DD-MON-YY')
                                    and end_dt <  to_date('$today', 'DD-MON-YY') + 1 )
        ORDER BY ep.TRANS_SEQ_NBR "

#   puts "Association Query: $query_string1"

    orasql $fetch_cursor1 $query_string1

    while {[orafetch $fetch_cursor1 -dataarray s -indexbyname] != 1403} {
            set iso $s(ISONO)
            if  {$s(CARD_SCHEME) == "03"} {
                 lappend axlist $s(EP_EVENT_ID) 
            } elseif {$s(CARD_SCHEME) == "04"} {
                 lappend vslist $s(EP_EVENT_ID)
            } elseif {$s(CARD_SCHEME) == "05"} {
                 lappend mclist $s(EP_EVENT_ID)
            } elseif {$s(CARD_SCHEME) == "08"} {
                 lappend dslist $s(EP_EVENT_ID)                    
            } 
             
            set EPID                  $s(EP_EVENT_ID)
            set TRANS_SEQ_NBR($EPID)  $s(TRANS_SEQ_NBR)
            set ACCOUNT_NBR($EPID)    [string replace $s(ACCT) 5 13 xxxxxxxxx ]
            set DATE($EPID)           $s(A_DATE)
            set REASON($EPID)         $s(REASON)
            set AMOUNT($EPID)         $s(AMOUNT)
            set INDICATOR($EPID)      $s(INDICATOR)
            set REF_NO($EPID)         $s(ARN)
            set TRAN_CODE($EPID)      $s(TRAN_CODE)
            set CARD_TYPE($EPID)      $s(CARD_SCHEME)
    }

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    puts $cur_file "Visa,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach EPNO $vslist {
         if {$AMOUNT($EPNO) != "0" } {
             puts $cur_file ",$ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO),$$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO),$INDICATOR($EPNO)"
             if {$INDICATOR($EPNO) == "C"} {
                 set VS_C_TOTAL [expr $VS_C_TOTAL + $AMOUNT($EPNO)]
             } elseif {$INDICATOR($EPNO) == "D"} {
                 set VS_D_TOTAL [expr $VS_D_TOTAL + $AMOUNT($EPNO)]
             }
         }
    }

    puts $cur_file "Association Rejects Debit Subtotal:,,, $$VS_D_TOTAL "
    puts $cur_file "Association Rejects Credit Subtotal:,,, $$VS_C_TOTAL "
    puts $cur_file "     "
    puts $cur_file "     "

    puts $cur_file "Master Card,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach EPNO $mclist {
         if {$AMOUNT($EPNO) != "0" } {
             puts $cur_file ",$ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO),$$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO),$INDICATOR($EPNO)"
             if {$INDICATOR($EPNO) == "C"} {
                 set MC_C_TOTAL [expr $MC_C_TOTAL + $AMOUNT($EPNO)]
             } elseif {$INDICATOR($EPNO) == "D"} {
                 set MC_D_TOTAL [expr $MC_D_TOTAL + $AMOUNT($EPNO)]
             }
         }
    }

    puts $cur_file "Association Rejects Debit Subtotal:,,, $$MC_D_TOTAL "
    puts $cur_file "Association Rejects Credit Subtotal:,,, $$MC_C_TOTAL"
    puts $cur_file "     "
    puts $cur_file "     "

    puts $cur_file "Discover,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach EPNO $dslist {
         if {$AMOUNT($EPNO) != "0" } {
            puts $cur_file ",$ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO),$$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO),$INDICATOR($EPNO)"
            if {$INDICATOR($EPNO) == "C"} {
                set DS_C_TOTAL [expr $DS_C_TOTAL + $AMOUNT($EPNO)]
            } elseif {$INDICATOR($EPNO) == "D"} {
                set DS_D_TOTAL [expr $DS_D_TOTAL + $AMOUNT($EPNO)]
            }
         }
    }

    puts $cur_file "Association Rejects Debit Subtotal:,,, $$DS_D_TOTAL "
    puts $cur_file "Association Rejects Credit Subtotal:,,, $$DS_C_TOTAL "
    puts $cur_file "     "
    puts $cur_file "     "

    puts $cur_file "Amex,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach EPNO $axlist {
         if {$AMOUNT($EPNO) != "0" } {
             puts $cur_file ",$ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO),$$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO),$INDICATOR($EPNO)"
             if {$INDICATOR($EPNO) == "C"} {
                 set AX_C_TOTAL [expr $AX_C_TOTAL + $AMOUNT($EPNO)]
             } elseif {$INDICATOR($EPNO) == "D"} {
                 set AX_D_TOTAL [expr $AX_D_TOTAL + $AMOUNT($EPNO)]
             }
         }
    }

    puts $cur_file "Association Rejects Debit Subtotal:,,, $$AX_D_TOTAL "
    puts $cur_file "Association Rejects Credit Subtotal:,,, $$AX_C_TOTAL "
    puts $cur_file "    "
    puts $cur_file "    "

    close $cur_file

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"

    exec mv $file_name ./ARCHIVE
}

#===============================================================================
#=====================      REPROCESSED REJECT      ============================
#===============================================================================

proc do_reprocessed_report {inst} {

    global curdate requested_date yesterday filedate
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to 

    set file_name     "$sql_inst.Reprocessed_Reject_Report.$filedate.csv"
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

    set query_string2 " 
        SELECT replace(ind.AMT_TRANS, ',', '')/100              as AMOUNT,
               ind.SEC_DEST_INST_ID                             as INSTID,
               substr(ind.merch_id,1,6)                         as ISONO,
               ind.TRANS_SEQ_NBR,
               ind.pan                                          as ACCT,
               ind.activity_dt                                  as I_DATE,
               ind.card_scheme,
               trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
               tid.TID_SETTL_METHOD                             as INDICATOR,
               tid.DESCRIPTION                                  as TRAN_CODE
        FROM  in_draft_main ind, tid
        WHERE ind.tid = tid.tid
          AND ind.msg_text_block like '%JPREJECT%'
          AND ind.card_scheme in ('03', '04', '05', '08')
          AND ind.activity_dt >= to_date('$yesterday', 'DD-MON-YY')
          AND ind.activity_dt <  to_date('$yesterday', 'DD-MON-YY') + 1
          AND ind.in_file_nbr in (select in_file_nbr 
                                  from  in_file_log 
                                  where end_dt >= to_date('$yesterday', 'DD-MON-YY')
                                    and end_dt <  to_date('$yesterday', 'DD-MON-YY') + 1)
          AND ind.SEC_DEST_INST_ID in ('$sql_inst')  "

#   puts "Reprocessed Query: $query_string2"

    orasql $fetch_cursor2 $query_string2

    while {[orafetch $fetch_cursor2 -dataarray inr -indexbyname ] != 1403 } {
            set TRANO $inr(TRANS_SEQ_NBR)
            set ISO   $inr(ISONO)
            if  {$inr(CARD_SCHEME) == "03"} {
                 lappend axlist $TRANO
            } elseif {$inr(CARD_SCHEME) == "04"} {
                 lappend vslist $TRANO                    
            } elseif {$inr(CARD_SCHEME) == "05"} {
                 lappend mclist $TRANO                    
            } elseif {$inr(CARD_SCHEME) == "08"} {
                 lappend dslist $TRANO                    
            }

            set ACCOUNT_NBR($TRANO) [string replace $inr(ACCT) 5 13 xxxxxxxxx ]
            set DATE($TRANO)         $inr(I_DATE)
            set REASON($TRANO)       "NA"
            set AMOUNT($TRANO)       $inr(AMOUNT)
            set REF_NO($TRANO)       $inr(ARN)
            set TRAN_CODE($TRANO)    $inr(TRAN_CODE)
            set INDICATOR($TRANO)    $inr(INDICATOR)
    }        

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    puts $cur_file "Visa,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach tno $vslist {
         if {$AMOUNT($tno) != "0"} {
             puts $cur_file ",$ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno),$INDICATOR($tno)"
             if {$INDICATOR($tno) == "C"} {
                  set VS_C_TOTAL [expr $VS_C_TOTAL + $AMOUNT($tno)]
             } elseif {$INDICATOR($tno) == "D"} {
                  set VS_D_TOTAL [expr $VS_D_TOTAL + $AMOUNT($tno)]
             }
         }
    }

    puts $cur_file "Reprocessed Rejects Debit Subtotal:,,, $$VS_D_TOTAL "
    puts $cur_file "Reprocessed Rejects Credit Subtotal:,,, $$VS_C_TOTAL "
    puts $cur_file "     "
    puts $cur_file "     "

    puts $cur_file "Master Card,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"
      
    foreach tno $mclist {
         if {$AMOUNT($tno) != "0"} {
             puts $cur_file ",$ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno),$INDICATOR($tno)"
             if {$INDICATOR($tno) == "C"} {
                  set MC_C_TOTAL [expr $MC_C_TOTAL    + $AMOUNT($tno)]
             } elseif {$INDICATOR($tno) == "D"} {
                  set MC_D_TOTAL [expr $MC_D_TOTAL + $AMOUNT($tno)]            
             }
         }
    }

    puts $cur_file "Reprocessed Rejects Debit Subtotal:,,, $$MC_D_TOTAL "
    puts $cur_file "Reprocessed Rejects Credit Subtotal:,,, $$MC_C_TOTAL " 
    puts $cur_file "      "
    puts $cur_file "      "

    puts $cur_file "Discover,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach tno $dslist {
         if {$AMOUNT($tno) != "0"} {
             puts $cur_file ",$ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno),$INDICATOR($tno)"
             if {$INDICATOR($tno) == "C"} {
                  set DS_C_TOTAL [expr $DS_C_TOTAL + $AMOUNT($tno)]
             } elseif {$INDICATOR($tno) == "D"} {
                  set DS_D_TOTAL [expr $DS_D_TOTAL + $AMOUNT($tno)]
             }
         }
    }

    puts $cur_file "Reprocessed Rejects Debit Subtotal:,,, $$DS_D_TOTAL "
    puts $cur_file "Reprocessed Rejects Credit Subtotal:,,, $$DS_C_TOTAL "
    puts $cur_file "      "
    puts $cur_file "      "

    puts $cur_file "Amex,ACCOUNT NUMBER,TRAN CODE,AMOUNT,REFERENCE NUMBER,DATE,REASON CODE,INDICATOR"

    foreach tno $axlist {
         if {$AMOUNT($tno) != "0"} {
             puts $cur_file ",$ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno),$INDICATOR($tno)"
             if {$INDICATOR($tno) == "C"} {
                  set AX_C_TOTAL [expr $AX_C_TOTAL + $AMOUNT($tno)]
             } elseif {$INDICATOR($tno) == "D"} {
                  set AX_D_TOTAL [expr $AX_D_TOTAL + $AMOUNT($tno)]
             }
         }
    }

    puts $cur_file "Reprocessed Rejects Debit Subtotal:,,, $$AX_D_TOTAL "
    puts $cur_file "Reprocessed Rejects Credit Subtotal:,,, $$AX_C_TOTAL "
    puts $cur_file "     "
    puts $cur_file "     "

    close $cur_file


   # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"
	
    if {$mode == "TEST"} {
        if { [catch { exec echo "Please see attached." | \
                mutt -a "$file_name" -s "$file_name" -- "$env(SCRIPT_USER)@jetpay.com" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
    } else  {
        if { [catch { exec echo "Please see attached." | \
                mutt -a "$file_name" -s "$file_name" -- "$mail_to" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
}

    exec mv $file_name ./ARCHIVE
}

##########
# MAIN
##########

readCfgFile

connect_to_db
global mode

#mode declaration
#set mode "TEST"
set mode "PROD"

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
     do_reprocessed_report $sql_inst
}

oraclose $fetch_cursor1

oraclose $fetch_cursor2

oralogoff $clr_logon_handle

