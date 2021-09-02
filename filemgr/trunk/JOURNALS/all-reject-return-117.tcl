#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#===============================================================================
# Version g3.00 Sunny Yang 08-11-2010
# ----- Updated to make this version capable of handling Meridian/Revtrak
#
# Version g2.00 Sunny Yang 04-07-2010
# ----- Performance tuning and report format updating
#
# Version g1.00 Sunny Yang 04-16-2009
# ----- Start to use global version for all institution now
#
# Version 0.01 Sunny Yang 02-20-2008
# ----- it is possible for one reject has two reason codes.
# ----- change made to take off duplication
#
# Version 0.01 Sunny Yang 12-10-2007
#
#
#===============================================================================

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(IST_DB)
#set authdb $env(ATH_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(CLR4_DB)
#set clrdb $env(IST_DB)
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

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

##################################################################################

#set mode "TEST"

set mode "PROD"

package require Oratcl
if {[catch {set handlerM [oralogon $clruser/$clrpwd@$clrdb]} result]} {
  exec echo "JETPAY_ISO_REJECT_RETURN.tcl failed to run" | mailx -r $mailfromlist -s "$box: JETPAY_ISO_REJECT_RETURN.tcl failed to run" $mailtolist
  exit
 } else {
    puts "COnnected"
 }

set fetch_cursorM1 [oraopen $handlerM]
set fetch_cursorM2 [oraopen $handlerM]
set fetch_cursorM3 [oraopen $handlerM]
set fetch_cursorM4 [oraopen $handlerM]
set fetch_cursorM5 [oraopen $handlerM]
set fetch_cursorM6 [oraopen $handlerM]
set fetch_cursorM7 [oraopen $handlerM]
set fetch_cursorM8 [oraopen $handlerM]

#********       Time Setting      *********
 if { $argc == 0 } {
      set inst_id          "117"
      set today            [string toupper  [clock format [clock scan "today"]  -format  %d-%b-%Y ]]
      set tomorrow         [string toupper  [clock format [clock scan "+1 day"] -format %d-%b-%Y]]
      set yesterday        [string toupper [clock format [clock scan "-1 day"] -format %d-%b-%Y]]
      set filedate         [clock format [clock scan "today"] -format %Y%m%d]
      set CUR_SET_TIME     [clock seconds]
      set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]

   } elseif {$argc == 1 } {
      set input [lindex $argv 0]
     
     if { [string length $input ] == 8 } {
            set today    [lindex $argv 0]
            set inst_id  "117"
      } elseif {[string length $input ] != 3 && [string length $input ] != 8} {            
        puts "REPORT DATE SHOULD BE 8 DIGITS 20100710"
        
        exit 0        
      }
      set report_date         [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%Y ]]   ;# 02-APR-08 as of 20080402
      set tomorrow            [string toupper  [clock format [clock scan " $today +1 day"] -format %d-%b-%Y]]
      set yesterday           [string toupper [clock format [clock scan "$today -1 day"] -format %d-%b-%Y]]
      set filedate             [string toupper [clock format [ clock scan " $today -0 day " ] -format %Y%m%d ]]
      set today                [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%Y ]]
      set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]
   } 
      set value "'117'"
    
      
puts "inst_id : $inst_id"
puts "...value is :$value"
      if {$mode == "TEST"} {
            if { $inst_id == "117" } {
                set cur_file_name    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.SBC.TEST.csv"
                set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.SBC.TEST.csv"
                set cur_file         [open "$cur_file_name" w]
                
                set cur_file_name_in   "/clearing/filemgr/JOURNALS/INST_SBC/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate-TEST.SBC.001.csv"
                set file_name_in       "ROLLUP.INCOMING_RETURN.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.SBC-TEST.001.csv"
                set cur_file_in        [open "$cur_file_name_in" w] 
          
              
            }
      } elseif {$mode == "PROD"} {
            if { $inst_id == "117" } {
                set cur_file_name	   "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.117.001.csv"
                set file_name	        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.117.001.csv"
                set cur_file	         [open "$cur_file_name" w]
          
                set cur_file_name_in   "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.117.001.csv"
                set file_name_in       "ROLLUP.INCOMING_RETURN.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.117.001.csv"
                set cur_file_in        [open "$cur_file_name_in" w]          
            
            }
      }
      

#===============================================================================
#=====================      OUTGOING REJECT      ===============================
#===============================================================================


set mclist  ""
set vslist  ""
set dslist  ""
set MC_C_TOTAL 0
set MC_D_TOTAL 0
set VS_C_TOTAL 0
set VS_D_TOTAL 0
set DS_C_TOTAL 0
set DS_D_TOTAL 0


     set query_stringM1 "SELECT ep.EP_EVENT_ID,
                                ep.TRANS_SEQ_NBR,
                                substr(ind.merch_id,1,6) as isono,
                                ind.REASON_CD  as REASON,
                                replace(ind.AMT_TRANS, ',', '') /100 as AMOUNT,
                                ep.pan as ACCT,
                                ep.EVENT_LOG_DATE as A_DATE,
                                ep.institution_id,
                                ep.CARD_SCHEME,
                                ind.ACTIVITY_DT,
                                ind.arn as ARN,
                                ind.tid,
                                tid.TID_SETTL_METHOD as INDICATOR,
                                TID.DESCRIPTION AS TRAN_CODE
                         FROM  ep_event_log ep, in_draft_main ind, tid
                         WHERE ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
                              AND ind.tid = tid.tid
                              AND ep.CARD_SCHEME in ('05', '04', '08')
                              AND ep.EMS_ITEM_TYPE in ('CR1','CR2','PR1')
                              AND ep.Event_log_date >= '$today' and ep.Event_log_date < '$tomorrow'
                              AND ep.institution_id  in ($value)
                              AND ind.in_file_nbr in (select in_file_nbr from in_file_log where end_dt >= '$today' and end_dt < '$tomorrow')
                       ORDER BY ep.TRANS_SEQ_NBR "
                       
      puts $query_stringM1
      orasql $fetch_cursorM1 $query_stringM1
      
      
      while {[orafetch $fetch_cursorM1 -dataarray s -indexbyname] != 1403} {
		  
           set iso $s(ISONO) 
            if {$s(CARD_SCHEME) == "05"} {
                if {$s(INSTITUTION_ID) == "117"} {
                    lappend mclist $s(EP_EVENT_ID) 
                }                                                      
            } elseif {$s(CARD_SCHEME) == "04"} {
                if {$s(INSTITUTION_ID) == "117"} {
                    lappend vslist $s(EP_EVENT_ID)
                
                  }                        
            } elseif {$s(CARD_SCHEME) == "08"} {
                if {$s(INSTITUTION_ID) == "117"} {
                    lappend dslist $s(EP_EVENT_ID)

                  }                    
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
#            
#    puts 	"EPID                  $EPID"
#    puts    "TRANS_SEQ_NBR($EPID)  $TRANS_SEQ_NBR($EPID)"
#    puts   	"ACCOUNT_NBR($EPID)    $ACCOUNT_NBR($EPID)"
#    puts	"DATE($EPID)           $DATE($EPID)"
#    puts    "REASON($EPID)         $REASON($EPID)"
#    puts    "AMOUNT($EPID)         $AMOUNT($EPID)"
#    puts    "INDICATOR($EPID)      $INDICATOR($EPID)"
#    puts    "REF_NO($EPID)         $REF_NO($EPID)"
#	puts	"TRAN_CODE($EPID)      $TRAN_CODE($EPID)"
#    puts    "CARD_TYPE($EPID)      $CARD_TYPE($EPID)"
#    puts ""        
     
#====  writing 117 out-going reject report =====================================
if {[file exists $cur_file_name]} {
      puts $cur_file "ISO:,117"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file  "       "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL [expr $MC_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL [expr $MC_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL"
      puts $cur_file "     "
      puts $cur_file "     "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "    "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "     "
      
      foreach EPNO $vslist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL [expr $VS_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL [expr $VS_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL "
      puts $cur_file "    "
      puts $cur_file "    "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "    "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO) "
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL [expr $DS_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL [expr $DS_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL "

      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "ISO:,ALL"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL[expr $MC_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL [expr $MC_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL"
      puts $cur_file "  "
      puts $cur_file "     "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "     "
      
      foreach EPNO $vslist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL [expr $VS_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL [expr $VS_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL"
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL"
      puts $cur_file "  "
      puts $cur_file "    "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)\r\n"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL [expr $DS_C_TOTAL + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL [expr $DS_D_TOTAL + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL "   
      
      close $cur_file
} else {
      puts "no outgoing reject file created for INST 117"
}


#Does not have imports to MAS
#===============================================================================
#=====================      INCOMING REJECT      ===============================
#===============================================================================
#set mclist  ""
#set vslist  ""
#set dslist  ""
#set MC_C_TOTAL 0
#set MC_D_TOTAL 0
#set VS_C_TOTAL 0
#set VS_D_TOTAL 0
#set DS_C_TOTAL 0
#set DS_D_TOTAL 0
#
#      set query_stringM3 " SELECT replace(ind.AMT_TRANS, ',', '')/100 as AMOUNT,
#                                    ind.SEC_DEST_INST_ID as INSTID,
#                                    substr(ind.merch_id,1,6) as ISONO,
#                                    ind.TRANS_SEQ_NBR,
#                                    ind.pan as ACCT,
#                                    ind.activity_dt as I_DATE,
#                                    ind.card_scheme,
#                                    ind.arn as ARN,
#                                    tid.TID_SETTL_METHOD as INDICATOR,
#                                    tid.DESCRIPTION as TRAN_CODE
#                             FROM in_draft_main ind, tid
#                             WHERE ind.tid = tid.tid
#                                  AND ind.msg_text_block like '%JPREJECT%'
#                                  AND ind.card_scheme in ('04', '05', '08')
#                                  AND ind.activity_dt like '$yesterday%'                                 
#                                  AND ind.in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$yesterday%')
#                                  AND ind.SEC_DEST_INST_ID in ($value)"
#      puts "query_stringM3: $query_stringM3"
#      orasql $fetch_cursorM3 $query_stringM3
#      while {[orafetch $fetch_cursorM3 -dataarray inr -indexbyname ] != 1403 } {
#            set TRANO $inr(TRANS_SEQ_NBR)
#            set ISO $inr(ISONO)
#            if {$inr(CARD_SCHEME) == "05"} {
#                if {$inr(INSTID) == "117"} {
#                    lappend mclist $TRANO
#                
#                }                                  
#            } elseif {$inr(CARD_SCHEME) == "04"} {
#                if {$inr(INSTID) == "117"} {
#                    lappend vslist $TRANO
#                } 
#                  
#            } elseif {$inr(CARD_SCHEME) == "08"} {
#                if {$inr(INSTID) == "117"} {
#                    lappend dslist $TRANO
#                }
#            }
#              set ACCOUNT_NBR($TRANO) [string replace $inr(ACCT) 5 13 xxxxxxxxx ]
#              set DATE($TRANO)      $inr(I_DATE)
#              set REASON($TRANO)    "NA"
#              set AMOUNT($TRANO)    $inr(AMOUNT)
#              set REF_NO($TRANO)    $inr(ARN)
#              set TRAN_CODE($TRANO) $inr(TRAN_CODE)
#              set INDICATOR($TRANO) $inr(INDICATOR)
#        
#}      
##117
#if {[file exists $cur_file_name_in]} {
#      puts $cur_file_in "JETPAY, 117"
#      puts $cur_file_in "ISO REPROCESSED REJECT REPORT"
#      puts $cur_file_in "REPORT DATE:  , $today "
#      puts $cur_file_in "       "
#      puts $cur_file_in "       "
#      puts $cur_file_in "       "
#      puts $cur_file_in "PLAN TYPE: ,MASTER CARD "
#      puts $cur_file_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
#      
#      foreach tno $mclist {
#            if {$AMOUNT($tno) != "0"} {
#                puts $cur_file_in " $ACCOUNT_NBR($tno),$TRAN_CODE($tno),$$AMOUNT($tno),$REF_NO($tno),$DATE($tno),$REASON($tno), $INDICATOR($tno)"
#                  if {$INDICATOR($tno) == "C"} {
#                     set MC_C_TOTAL [expr $MC_C_TOTAL + $AMOUNT($tno)]
#                  } elseif {$INDICATOR($tno) == "D"} {
#                     set MC_D_TOTAL [expr $MC_D_TOTAL + $AMOUNT($tno)]            
#                  }
#            }
#      }
#      puts $cur_file_in "   "
#      puts $cur_file_in "TOTAL"
#      puts $cur_file_in "   "
#      puts $cur_file_in " Master Card Reprocessed Reject Debit Subtotal:, $$MC_D_TOTAL "
#      puts $cur_file_in " Master Card Reprocessed Reject Credit Subtotal:, $$MC_C_TOTAL " 
#      puts $cur_file_in "  "
#      puts $cur_file_in "PLAN TYPE: ,VISA"
#      puts $cur_file_in "   "
#      puts $cur_file_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
#      
#      foreach tno $vslist {
#            if {$AMOUNT($tno) != "0"} {
#                  puts $cur_file_in " $ACCOUNT_NBR($tno),$TRAN_CODE($tno),$$AMOUNT($tno),$REF_NO($tno),$DATE($tno),$REASON($tno), $INDICATOR($tno)"
#                  if {$INDICATOR($tno) == "C"} {
#                     set VS_C_TOTAL[expr $VS_C_TOTAL + $AMOUNT($tno)]
#                  } elseif {$INDICATOR($tno) == "D"} {
#                     set VS_D_TOTAL[expr $VS_D_TOTAL + $AMOUNT($tno)]            
#                  } 
#            }
#      }
#      puts $cur_file_in "   "
#      puts $cur_file_in "TOTAL"
#      puts $cur_file_in "   "
#      puts $cur_file_in " Visa Card Reprocessed Reject Debit Subtotal:, $$VS_D_TOTAL "
#      puts $cur_file_in " Visa Card Reprocessed Reject Credit Subtotal:, $$VS_C_TOTAL "
#      puts $cur_file_in "  "
#      puts $cur_file_in "PLAN TYPE: ,DISCOVER"
#      puts $cur_file_in "   "
#      puts $cur_file_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"    
#
#	  foreach tno $dslist {
#            if {$AMOUNT($tno) != "0"} {
#                puts $cur_file_in " $ACCOUNT_NBR($tno),$TRAN_CODE($tno),$$AMOUNT($tno),$REF_NO($tno),$DATE($tno),$REASON($tno), $INDICATOR($tno)"
#                  if {$INDICATOR($tno) == "C"} {
#                     set DS_C_TOTAL [expr $DS_C_TOTAL + $AMOUNT($tno)]
#                  } elseif {$INDICATOR($tno) == "D"} {
#                     set DS_D_TOTAL [expr $DS_D_TOTAL + $AMOUNT($tno)]            
#                  }
#            }
#      }
#      puts $cur_file_in "   "
#      puts $cur_file_in "TOTAL"
#      puts $cur_file_in "   "
#      puts $cur_file_in " Discover Card Reprocessed Reject Debit Subtotal:, $$DS_D_TOTAL "
#      puts $cur_file_in " Discover Card Reprocessed Reject Credit Subtotal:, $$DS_C_TOTAL " 
#      puts $cur_file_in "  "
#
#							} else {
#
#      puts "no incoming reject file created for inst 117"
#}


if {$mode == "TEST"} {
	exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name reports-clearing@jetpay.com 
	exec uuencode $cur_file_name_in $file_name_in | mailx -r clearing@jetpay.com -s $file_name_in reports-clearing@jetpay.com     

      
} elseif {$mode == "PROD"} {
	exec uuencode $cur_file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com
	exec uuencode $cur_file_name_in $file_name_in | mailx -r reports-clearing@jetpay.com -s $file_name_in reports-clearing@jetpay.com
}



oraclose $fetch_cursorM1
oraclose $fetch_cursorM2
oraclose $fetch_cursorM3
oraclose $fetch_cursorM4
oraclose $fetch_cursorM5
oraclose $fetch_cursorM6
oraclose $fetch_cursorM7
oraclose $fetch_cursorM8
oralogoff $handlerM


