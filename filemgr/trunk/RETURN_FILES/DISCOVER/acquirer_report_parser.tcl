#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
#
# Version 0.00 Sunny Yang 08-10-2009
# Based on the Discover "Acquirer Report Interface R9.1.pdf"

puts "BEGIN acquirer_report_parser.tcl File"
package require Oratcl

##==========================   Environment variables  ==========================

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
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

set sysinfo "System: $box\n Location: /clearing/filemgr/DISCOVER \n\n"

##==============================================================================
package require Oratcl
##==============================================================================
    set path      "/clearing/filemgr/RETURN_FILES/DISCOVER/DNLOAD \n"
    set CUR_J     [string range [clock format [clock seconds] -format "%y%j"] 1 4]
    set emsg      ""
    set acqners   [lindex $argv 0]
    set timestamp [string range $acqners 14 27]
    set input     [open $acqners r]
    set file_name  "aquirer_report.$timestamp.rtf"
    set cur_line   [set orig_line [gets $input] ]
    set cur_file   [open $file_name w]

    proc cobp {value} {
       return [string map { \{ 0 A 1 B 2 C 3 D 4 E 5 F 6 G 7 H 8 I 9} $value]
    }

    proc cobn {value} {
       return [string map { \} 0 J 1 K 2 L 3 M 4 N 5 O 6 P 7 Q 8 R 9} $value]
    }    
    while {$cur_line != ""} {      
          set max_len       "300"
         
#===============================================================================
#=== File Header ===========
#===============================================================================
                   
      if {[string range $cur_line 0 0] == "1" } {
          set H_RECORD_TYPE  [string range $cur_line 0 0]
          set ACT_END_DATE   [string range $cur_line 1 8]
          set MAIL_BOX       [string range $cur_line 9 16]
          
          puts  $cur_file "Destination Header Record"
          puts  $cur_file "Record Type: >>$H_RECORD_TYPE<<"
          puts  $cur_file "Activity Ending Date: >>$ACT_END_DATE<<"
          puts  $cur_file "Destination Mail Box: >>$MAIL_BOX<<"
          puts  $cur_file " "
          puts  $cur_file " "
      }
       set cur_line   [set orig_line [gets $input] ]
#===============================================================================         
#=== File Confirmation Total Record ====
#===============================================================================
      if {[string range $cur_line 0 0] == "2"} {
           set RECORD_TYPE        [string range $cur_line 0 0]
           set ACT_END_DATE       [string range $cur_line 1 8]
           set MAIL_BOX           [string range $cur_line 9 16]
           set F_RECIPIENT_ID     [string range $cur_line 17 27]
           set F_RECIPIENT_NAME   [string range $cur_line 28 67]
           set VERSION_IND        [string range $cur_line 68 72]          
           
           #set emsg " Number of Rejected Batches: $NUM_OF_REJ_BATCH \r\n "
           #set emsg "$emsg Rejected Detail Record Cnt: $REJ_DETAIL_REC_CNT \r\n "
           
           puts $cur_file "File Header Record"
           puts $cur_file "Record Type: >>$RECORD_TYPE<<"
           puts $cur_file "Activitiy Ending Date: >>$ACT_END_DATE<<"
           puts $cur_file "Destination Mailbox: >>$MAIL_BOX<<"
           puts $cur_file "File Recipient ID: >>$F_RECIPIENT_ID<<"
           puts $cur_file "File Recipient Name: >>$F_RECIPIENT_NAME<<"
           puts $cur_file "Version Indicator: >>$VERSION_IND<<"
           puts $cur_file " "
           puts $cur_file " "
     }
     
#===============================================================================
#=== File Confirmation File Reject Record ===========
#===============================================================================
set SACTIVITY_TYPE ""
 
      if {[string range $cur_line 0 0] == "5"} {
          set RECORD_TYPE            [string range $cur_line 0 0]
          set SECTION_CD          [string range $cur_line 1 2]
          if {$SECTION_CD == "01"} {
             set SUB_SEC_CD          [string range $cur_line 3 3]
             if {$SUB_SEC_CD == "1"} {
                  set ACTIVITY_TYPE       [string range $cur_line 4 33]
                  set ACTIVITY_CNT        [string range $cur_line 34 44]
                  set ACTIVITY_AMT        [string range $cur_line 45 59]
                 puts $cur_file "Section Record"
                 puts $cur_file "Settlement Summary"
                 puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                 puts $cur_file "Section Code: >>$SECTION_CD<<"
                 puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                 puts $cur_file "Activity Type: >>$SACTIVITY_TYPE<<"
                 puts $cur_file "Activity Count: >>$ACTIVITY_CNT<<"
                 if {$ACTIVITY_AMT > 0} {
                    puts $cur_file "Activity Amount: >>$ACTIVITY_AMT<<"
                 } elseif {$ACTIVITY_AMT < 0} {
                    puts $cur_file "Activity Amount: >>$ACTIVITY_AMT<<"   
                 }
                 puts $cur_file " "
                 puts $cur_file " "
             } elseif {$SUB_SEC_CD == "2"} {
                  set SETTLE_AMT          [string range $cur_line 4 18]
                  set BANK_ACCT_NBR       [string range $cur_line 19 35]
                  set BANK_NAME           [string range $cur_line 36 65]
                 puts $cur_file "Section Record"
                 puts $cur_file "Settlement Banking Information Record"
                 puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                 puts $cur_file "Section Code: >>$SECTION_CD<<"
                 puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                 if {$SETTLE_AMT > 0} {
                    puts $cur_file "Settlement Amount: >>$SETTLE_AMT<<"
                 } elseif {$SETTLE_AMT < 0} {
                    puts $cur_file "Settlement Amount: >>$SETTLE_AMT<<"   
                 }
                 puts $cur_file "Bank Account Number: >>$BANK_ACCT_NBR<<"
                 puts $cur_file "Bank Name: >>$BANK_NAME<<"                 
                 puts $cur_file " "
                 puts $cur_file " "               
             }
             
          } elseif {$SECTION_CD == "02"} {
             set SUB_SEC_CD          [string range $cur_line 3 3]
             if {$SUB_SEC_CD == "0"} {
                  set TXN_LEVEL_CD        [string range $cur_line 4 4]
                  if {$TXN_LEVEL_CD == "1"} {
                     set FILE_CREATE_DT      [string range $cur_line 5 12]
                     set FILE_XFER_DT        [string range $cur_line 13 22]
                     set ACCEPTED_CNT        [string range $cur_line 23 29]
                     set ACCEPTED_AMT        [string range $cur_line 30 43]
                     set ACCEPTED_AMT_LAST   [string range $cur_line 44 44]
                     set FILE_REF_ID         [string range $cur_line 45 53]
                     
                    puts $cur_file "Section Record"
                    puts $cur_file "Accepted Card Transactions Section Records"
                    puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                    puts $cur_file "Section Code: >>$SECTION_CD<<"
                    puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                    puts $cur_file "Transacton Level Code(file): >>$TXN_LEVEL_CD<<"
                    puts $cur_file "File Creation Date: >>$FILE_CREATE_DT<<"
                    puts $cur_file "File Transmission Date&Time: >>$FILE_XFER_DT<<"
                    puts $cur_file "Accepted Count: >>$ACCEPTED_CNT<<"             
                    if {$ACCEPTED_AMT > 0} {
                       puts $cur_file "Accepted Amount: >>$ACCEPTED_AMT[cobp $ACCEPTED_AMT_LAST]<<"
                    } elseif {$ACCEPTED_AMT < 0} {
                       puts $cur_file "Accepted Amount: >>$ACCEPTED_AMT[cobn $ACCEPTED_AMT_LAST]<<"   
                    }
                    puts $cur_file "File Reference ID: >>$FILE_REF_ID<<"
                    puts $cur_file " "
                    puts $cur_file " "
                  } elseif {$TXN_LEVEL_CD == "3"} {
                      set BATCH_CREATION_DT   [string range $cur_line 5 12]
                      set BATCH_XFER_DT       [string range $cur_line 13 22]
                      set PROCESS_ID_SUBMIT   [string range $cur_line 28 38]
                      set PROCESS_NAME_SUBMIT [string range $cur_line 39 78]
                      set ACQUIRER_ID         [string range $cur_line 79 89]
                      set ACQUIRER_NAME       [string range $cur_line 90 129]
                      set DISC_ID             [string range $cur_line 130 144]
                      set CURRENCY_CODE       [string range $cur_line 145 147]
                      set COUNTRY_CODE        [string range $cur_line 148 150]
                      set ACCEPTED_CNT        [string range $cur_line 151 157]
                      set ACCEPTED_AMT        [string range $cur_line 158 171]
                      set ACCEPTED_AMT_LAST        [string range $cur_line 172 172]
                      set BATCH_SEQ_NBR       [string range $cur_line 173 181]
                      set BATCH_REF_ID        [string range $cur_line 182 189]
                     
                      puts $cur_file "Section Record"
                      puts $cur_file "Accepted Card Transactions Section Records"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Transacton Level Code(batch): >>$TXN_LEVEL_CD<<"
                      puts $cur_file "Batch Creation Date: >>$BATCH_CREATION_DT<<"
                      puts $cur_file "Batch Transmission Date&Time: >>$BATCH_XFER_DT<<"
                      puts $cur_file "Processor ID Submitting Batch: >>$PROCESS_ID_SUBMIT<<"
                      puts $cur_file "Processor Name Submitting Batch: >>$PROCESS_NAME_SUBMIT<<"
                      puts $cur_file "Acquirer ID: >>$ACQUIRER_ID<<"
                      puts $cur_file "Acquirer Name: >>$ACQUIRER_NAME<<"
                      puts $cur_file "Discover ID: >>$DISC_ID<<"
                      puts $cur_file "Currency Code: >>$CURRENCY_CODE<<"
                      puts $cur_file "Country Code: >>$COUNTRY_CODE<<"
                      puts $cur_file "Accepted Count: >>$ACCEPTED_CNT<<"
                    if {$ACCEPTED_AMT > 0} {
                       puts $cur_file "Accepted Amount: >>$ACCEPTED_AMT[cobp $ACCEPTED_AMT_LAST]<<"
                    } elseif {$ACCEPTED_AMT < 0} {
                       puts $cur_file "Accepted Amount: >>$ACCEPTED_AMT[cobn $ACCEPTED_AMT_LAST]<<"   
                    }
                      puts $cur_file "Batch Sequence Number: >>$BATCH_SEQ_NBR<<"
                      puts $cur_file "Batch Reference ID: >>$BATCH_REF_ID<<"
                      puts $cur_file " "
                      puts $cur_file " "                       
                  } elseif {$TXN_LEVEL_CD == "4"} {
                      set CARD_NBR                     [string range $cur_line 5 23]
                      set TXN_DATE                     [string range $cur_line 24 31]
                      set TXN_TIME                     [string range $cur_line 32 37]
                      set TOT_TXN_AMT                  [string range $cur_line 38 48]
                      set TOT_TXN_AMT_LAST             [string range $cur_line 49 49]
                      set CASH_AMT                     [string range $cur_line 50 61]
                      set CASH_AMT_LAST                [string range $cur_line 61 61]
                      set TXN_ID                       [string range $cur_line 62 77]
                      set TXN_TYPE                     [string range $cur_line 78 79]
                      set PROCESSION_CODE              [string range $cur_line 80 85]
                      set AUTH_MATCH                   [string range $cur_line 86 86]
                      set ACQ_INTERCHG                 [string range $cur_line 87 90]
                      set ACQ_INTERCHG_AMT_SUBMIT      [string range $cur_line 91 101]
                      set ACQ_INTERCHG_AMT_SUBMIT_LAST [string range $cur_line 102 102]
                      set ACQ_INTERCHG_AMT_ASSES       [string range $cur_line 103 105]
                      set ACQ_INTERCHG_AMT_ASSES_LAST  [string range $cur_line 106 106]
                      set ACQ_INTERCHG_AMT_ASSES_RATE  [string range $cur_line 107 117]
                      set ACQ_INTERCHG_AMT_ASSES_RATE_LAST  [string range $cur_line 118 118]
                      set ACQ_INTERCHG_AMT_ASSES_PTF   [string range $cur_line 119 129]
                      set ACQ_INTERCHG_AMT_ASSES_PTF_LAST   [string range $cur_line 130 130]
                      set TOT_ACQ_INCHG_AMT_ASSES      [string range $cur_line 131 141]
                      set TOT_ACQ_INCHG_AMT_ASSES_LAST      [string range $cur_line 142 142]
                      set ACQ_INCHG_MIN_MAX            [string range $cur_line 143 145]
                      set TIMELINESS_TEST              [string range $cur_line 146 150]
                      set TRACK_DATA_TEST              [string range $cur_line 151 152]
                      set MCC_TEST                     [string range $cur_line 153 153]
                      set AMT_TOLERANCE_TEST           [string range $cur_line 154 154]
                      set FOREIGN_CUR_AMT              [string range $cur_line 155 165]
                      set FOREIGN_CUR_AMT_LAST         [string range $cur_line 166 166]
                      set FOREIGN_CONVERT_RATE         [string range $cur_line 167 181]
                      set FOREIGN_CUR_NAME             [string range $cur_line 182 221]
                      set LOCAL_TXN_DATE               [string range $cur_line 222 229]
                      set LOCAL_TXN_TIME               [string range $cur_line 230 235]
                      set BATCH_REF_ID                 [string range $cur_line 236 243]
                      set ACQ_REF_NBR                  [string range $cur_line 244 266]
                      set NETWORK_REF_ID               [string range $cur_line 268 281]
                      set PROGRAM_VERIF_ID             [string range $cur_line 282 291]
                      puts $cur_file "Section Record"
                      puts $cur_file "Accepted Card Transactions Section Records"
                      puts $cur_file "Accepted Detail - Card Sales Transactions Record"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Transacton Level Code(Detail sales): >>$TXN_LEVEL_CD<<"
                      puts $cur_file "Card Number: >>$CARD_NBR<<"
                      puts $cur_file "Transaction Date : >>$TXN_DATE<< "
                      puts $cur_file "Transaction Time : >>$TXN_TIME<< "
                      if {$TOT_TXN_AMT > 0} {
                          puts $cur_file "Total Transaction Amount : >>$TOT_TXN_AMT[cobp $TOT_TXN_AMT_LAST]<< "
                      } elseif {$TOT_TXN_AMT < 0} {
                          puts $cur_file "Total Transaction Amount : >>$TOT_TXN_AMT[cobn $TOT_TXN_AMT_LAST]<< "
                      }
                      if {$CASH_AMT > 0} {
                      puts $cur_file "Cash Over Amount : >>$CASH_AMT[cobp $CASH_AMT_LAST]<< "
                      } elseif {$CASH_AMT < 0} {
                      puts $cur_file "Cash Over Amount : >>$CASH_AMT[cobn $CASH_AMT_LAST]<< "
                      } 
                      puts $cur_file "Transaction ID : >>$TXN_ID<< "
                      puts $cur_file "Transaction Type : >>$TXN_TYPE<< "
                      puts $cur_file "Processing Code : >>$PROCESSION_CODE<< "
                      puts $cur_file "Auth Match Found : >>$AUTH_MATCH<< "
                      puts $cur_file "Acquirer Interchange Program Submitted : >>$ACQ_INTERCHG<< "               
                      if {$ACQ_INTERCHG_AMT_SUBMIT > 0} {
                      puts $cur_file "Acquirer Interchange Amount Submitted : >>$ACQ_INTERCHG_AMT_SUBMIT[cobp $ACQ_INTERCHG_AMT_SUBMIT_LAST]<< "
                      } elseif {$ACQ_INTERCHG_AMT_SUBMIT < 0} {
                      puts $cur_file "Acquirer Interchange Amount Submitted : >>$ACQ_INTERCHG_AMT_SUBMIT[cobn $ACQ_INTERCHG_AMT_SUBMIT_LAST]<< "
                      }
                      if {$ACQ_INTERCHG_AMT_ASSES > 0} {
                      puts $cur_file "Acquirer Interchange Program Assessed : >>$ACQ_INTERCHG_AMT_ASSES[cobp $ACQ_INTERCHG_AMT_ASSES_LAST]<< "
                      } elseif {$ACQ_INTERCHG_AMT_ASSES < 0} {
                      puts $cur_file "Acquirer Interchange Program Assessed : >>$ACQ_INTERCHG_AMT_ASSES[cobn $ACQ_INTERCHG_AMT_ASSES_LAST]<< "
                      }
                      if {$ACQ_INTERCHG_AMT_ASSES_RATE > 0} {
                      puts $cur_file "Acquirer Interchange Amount Assessed(Rate based): >>$ACQ_INTERCHG_AMT_ASSES_RATE[cobp $ACQ_INTERCHG_AMT_ASSES_RATE_LAST]<< "
                      } elseif {$ACQ_INTERCHG_AMT_ASSES_RATE < 0} {
                      puts $cur_file "Acquirer Interchange Amount Assessed(Rate based): >>$ACQ_INTERCHG_AMT_ASSES_RATE[cobn $ACQ_INTERCHG_AMT_ASSES_RATE_LAST]<< "
                      }
                      if { $ACQ_INTERCHG_AMT_ASSES_PTF > 0} {
                      puts $cur_file "Acquirer Interchange Amount Assessed(PTF based) : >>$ACQ_INTERCHG_AMT_ASSES_PTF[cobp $ACQ_INTERCHG_AMT_ASSES_PTF_LAST]<< "
                      } elseif { $ACQ_INTERCHG_AMT_ASSES_PTF < 0} {
                      puts $cur_file "Acquirer Interchange Amount Assessed(PTF based) : >>$ACQ_INTERCHG_AMT_ASSES_PTF[cobn $ACQ_INTERCHG_AMT_ASSES_PTF_LAST]<< "
                      }
                      if {$TOT_ACQ_INCHG_AMT_ASSES > 0 } {
                      puts $cur_file "Total Acquirer Interchange Amount Assessed : >>$TOT_ACQ_INCHG_AMT_ASSES[cobp $TOT_ACQ_INCHG_AMT_ASSES_LAST]<< "
                      } elseif {$TOT_ACQ_INCHG_AMT_ASSES < 0 } {
                      puts $cur_file "Total Acquirer Interchange Amount Assessed : >>$TOT_ACQ_INCHG_AMT_ASSES[cobn $TOT_ACQ_INCHG_AMT_ASSES_LAST]<< "
                      }
                      puts $cur_file "Acquirer Interchange Min/Max Used : >>$ACQ_INCHG_MIN_MAX<< "
                      puts $cur_file "Timeliness Test : >>$TIMELINESS_TEST<< "
                      puts $cur_file "Track Data Condition Code Test : >>$TRACK_DATA_TEST<< "
                      puts $cur_file "MCC Match Test : >>$MCC_TEST<< "
                      puts $cur_file "Amount Tolerance Percentage Test : >>$AMT_TOLERANCE_TEST<< "
                      if {$FOREIGN_CUR_AMT > 0} {
                      puts $cur_file "Foreign Currency Amount : >>$FOREIGN_CUR_AMT[cobp $FOREIGN_CUR_AMT_LAST]<< "
                      } elseif {$FOREIGN_CUR_AMT < 0} {
                      puts $cur_file "Foreign Currency Amount : >>$FOREIGN_CUR_AMT[cobn $FOREIGN_CUR_AMT_LAST]<< "
                      }
                      puts $cur_file "Foreign Currency Conversion Rate : >>$FOREIGN_CONVERT_RATE<< "
                      puts $cur_file "Foreign Currency Name : >>$FOREIGN_CUR_NAME<< "
                      puts $cur_file "Local Transaction Date : >>$LOCAL_TXN_DATE<< "
                      puts $cur_file "Local Transaction Time : >>$LOCAL_TXN_TIME<< "
                      puts $cur_file "Batch Reference ID : >>$BATCH_REF_ID<< "
                      puts $cur_file "Acquirer Reference Number: >>$ACQ_REF_NBR<< "
                      puts $cur_file "Network Reference ID : >>$NETWORK_REF_ID<< "
                      puts $cur_file "Program Verification ID : >>$PROGRAM_VERIF_ID<< "
                  } elseif {$TXN_LEVEL_CD == "5"} {
                           
                      set CARD_NBR                     [string range $cur_line 5 23]
                      set TXN_DATE                     [string range $cur_line 24 31]
                      set TXN_TIME                     [string range $cur_line 32 37]
                      set TOT_TXN_AMT                  [string range $cur_line 38 49]
                      set TXN_ID                       [string range $cur_line 50 65]
                      set TXN_TYPE                     [string range $cur_line 66 67]
                      set PROCESSION_CODE              [string range $cur_line 68 73]
                      set AUTH_MATCH                   [string range $cur_line 74 74]
                      set CASH_REIM_AMT_ASSES_RATE     [string range $cur_line 75 86]
                      set CASH_REIM_AMT_ASSES_PTF      [string range $cur_line 87 98]
                      set TOT_CASH_REIM_AMT_ASSES      [string range $cur_line 99 110]
                      set CASH_REIM_MIN_MAX            [string range $cur_line 111 113]
                      set FOREIGN_CUR_AMT              [string range $cur_line 114 125]
                      set FOREIGN_CONVERT_RATE         [string range $cur_line 126 140]
                      set FOREIGN_CUR_NAME             [string range $cur_line 141 180]
                      set LOCAL_TXN_DATE               [string range $cur_line 180 188]
                      set LOCAL_TXN_TIME               [string range $cur_line 189 194]
                      set BATCH_REF_ID                 [string range $cur_line 195 202]
                      set ACQ_REF_NBR                  [string range $cur_line 203 225]
                      set NETWORK_REF_ID               [string range $cur_line 226 240]
                      set PROGRAM_VERIF_ID             [string range $cur_line 241 250]
                      
                      puts $cur_file "Section Record"
                      puts $cur_file "Accepted Card Transactions Section Records"
                      puts $cur_file "Accepted Detail - Cash Advance Transactions Record"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Transacton Level Code(Detail sales): >>$TXN_LEVEL_CD<<"
                      puts $cur_file "Card Number: >>$CARD_NBR<<"
                      puts $cur_file "Transaction Date : >>$TXN_DATE<< "
                      puts $cur_file "Transaction Time : >>$TXN_TIME<< "
                      puts $cur_file "Total Transaction Amount : >>$TOT_TXN_AMT<< "
                      puts $cur_file "Transaction ID : >>$TXN_ID<< "
                      puts $cur_file "Transaction Type : >>$TXN_TYPE<< "
                      puts $cur_file "Processing Code : >>$PROCESSION_CODE<< "
                      puts $cur_file "Auth Match Found : >>$AUTH_MATCH<< "
                      puts $cur_file "Cash Reimbursement Amount Assessed(Rate Based): >>$CASH_REIM_AMT_ASSES_RATE<<"
                      puts $cur_file "Cash Reimbursement Amount Assessed(PTF Based) : >>$CASH_REIM_AMT_ASSES_PTF<< "
                      puts $cur_file "Total Cash Reimbursement Amount : >>$TOT_CASH_REIM_AMT_ASSES<< "
                      puts $cur_file "Cash Reimbursement Min/Max Used : >>$CASH_REIM_MIN_MAX<< "                      
                      puts $cur_file "Foreign Currency Amount : >>$FOREIGN_CUR_AMT<< "
                      puts $cur_file "Foreign Currency Conversion Rate : >>$FOREIGN_CONVERT_RATE<< "
                      puts $cur_file "Foreign Currency Name : >>$FOREIGN_CUR_NAME<< "
                      puts $cur_file "Local Transaction Date : >>$LOCAL_TXN_DATE<< "
                      puts $cur_file "Local Transaction Time : >>$LOCAL_TXN_TIME<< "
                      puts $cur_file "Batch Reference ID : >>$BATCH_REF_ID<< "
                      puts $cur_file "Acquirer Reference Number: >>$ACQ_REF_NBR<< "
                      puts $cur_file "Network Reference ID : >>$NETWORK_REF_ID<< "
                      puts $cur_file "Program Verification ID : >>$PROGRAM_VERIF_ID<< "
                      
                  } elseif {$TXN_LEVEL_CD == "6"} {
                      set CARD_NBR                     [string range $cur_line 5 23]
                      set TXN_DATE                     [string range $cur_line 24 31]
                      set TXN_TIME                     [string range $cur_line 32 37]
                      set TOT_TXN_AMT                  [string range $cur_line 38 49]
                      set TXN_ID                       [string range $cur_line 50 65]
                      set TXN_TYPE                     [string range $cur_line 66 67]
                      set PROCESSION_CODE              [string range $cur_line 68 73]
                      set PRICING_PROG_SUBMIT          [string range $cur_line 74 77] 
                      set AMT_SUBMIT                   [string range $cur_line 78 89] 
                      set PRICING_PROG_ASSESS          [string range $cur_line 90 93] 
                      set PRICING_PROG_ASSESS_RATE     [string range $cur_line 94 105] 
                      set PRICING_PROG_ASSESS_PTF      [string range $cur_line 106 117] 
                      set TOT_AMT_ASSESS               [string range $cur_line 118 129] 
                      set MIN_MAX_USED                 [string range $cur_line 130 132] 
                      set FOREIGN_CURR_AMT             [string range $cur_line 133 144] 
                      set FOREIGN_CURR_CONVER_RATE     [string range $cur_line 145 159] 
                      set FOREIGN_CURR_NAME            [string range $cur_line 160 199] 
                      set LOCAL_TXN_DATE               [string range $cur_line 200 207] 
                      set LOCAL_TXN_TIME               [string range $cur_line 208 213] 
                      set BATCH_REF_ID                 [string range $cur_line 214 221] 
                      set ACQ_REF_NBR                  [string range $cur_line 222 244] 
                      set NETWORK_REF_ID               [string range $cur_line 245 259] 
                      set PROG_VERIF_ID                [string range $cur_line 260 269]
                      puts $cur_file "Section Record"
                      puts $cur_file "Accepted Card Transactions Section Records"
                      puts $cur_file "Accepted Detail - Reversal/Credit Transactions Record"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Transacton Level Code(Detail sales): >>$TXN_LEVEL_CD<<"
                      puts $cur_file "Card Nmber : >>$CARD_NBR<< "  
                      puts $cur_file "Transaction Date : >>$TXN_DATE<< "                    
                      puts $cur_file "Transaction Time : >>$TXN_TIME<< "                    
                      puts $cur_file "Total Transaction Amount : >>$TOT_TXN_AMT<< "                    
                      puts $cur_file "Transaction ID : >>$TXN_ID<< "                    
                      puts $cur_file "Transaction Type : >>$TXN_TYPE<< "                    
                      puts $cur_file "Processing Code : >>$PROCESSION_CODE<< "                    
                      puts $cur_file "Pricing Program Submitted : >>$PRICING_PROG_SUBMIT<< "                    
                      puts $cur_file "Amount Submitted : >>$AMT_SUBMIT<< "                    
                      puts $cur_file "Pricing Program Assessed : >>$PRICING_PROG_ASSESS<< "                    
                      puts $cur_file "Pricing Program Assessed (Rate based) : >>$PRICING_PROG_ASSESS_RATE<< "                    
                      puts $cur_file "Pricing Program Assessed (PTF Based) : >>$PRICING_PROG_ASSESS_PTF<< "                    
                      puts $cur_file "Total Amount Assessed : >>$TOT_AMT_ASSESS<< "                    
                      puts $cur_file "Min/Max Used : >>$MIN_MAX_USED<< "                    
                      puts $cur_file "Foreign Currency Amount : >>$FOREIGN_CURR_AMT<< "                    
                      puts $cur_file "Foreign Currency Conversion Rate: >>$FOREIGN_CURR_CONVER_RATE<< "                    
                      puts $cur_file "Foreign Currency Name: >>$FOREIGN_CURR_NAME<< "                    
                      puts $cur_file "Local Transaction Date : >>$LOCAL_TXN_DATE<< "                    
                      puts $cur_file "Local Transaction Time : >>$LOCAL_TXN_TIME<< "                    
                      puts $cur_file "Batch Reference ID : >>$BATCH_REF_ID<< "                    
                      puts $cur_file "Acquirer Reference Number : >>$ACQ_REF_NBR<< "                    
                      puts $cur_file "Network Reference ID : >>$NETWORK_REF_ID<< "                 
                      puts $cur_file "Program Verification ID : >>$PROG_VERIF_ID<< "  
                      puts $cur_file " "
                      puts $cur_file " "                                                                  
                      
                  }
             }
          } elseif {$SECTION_CD == "03"} {
                       set SUB_SEC_CD                   [string range $cur_line 3 3]
                       set DISPUTE_DATE                 [string range $cur_line 4 11]
                       set DISPUTE_DESC                 [string range $cur_line 12 51] 
                       set DISPUTE_REASON_CD            [string range $cur_line 52 55]
                       set CARD_NBR                     [string range $cur_line 56 74]
                       set DISC_ID                      [string range $cur_line 75 89]
                       set MCC                          [string range $cur_line 90 93]
                       set MERCH_ST_COUNTRY_CD          [string range $cur_line 94 96]
                       set TXN_DATE                     [string range $cur_line 97 104]
                       set DISPUTE_AMT                  [string range $cur_line 105 116]
                       set TXN_ID                       [string range $cur_line 117 132]
                       set CASE_NBR                     [string range $cur_line 133 142]
                       set PRICING_PROG_ASSESS          [string range $cur_line 143 146]
                       set PRICING_PROG_ASSESS_RATE     [string range $cur_line 147 158]
                       set PRICING_PROG_ASSESS_PTF      [string range $cur_line 159 170]
                       set TOT_ASSESS_AMT               [string range $cur_line 171 182]
                       set MIN_MAX_USED                 [string range $cur_line 183 185]
                       set CASH_REIM_AMT_ASSESS_RATE    [string range $cur_line 186 197]
                       set CASH_REIM_AMT_ASSESS_PTF     [string range $cur_line 198 209]
                       set TOT_CASH_REIM_AMT_ASSESS     [string range $cur_line 210 221]
                       set CASH_REIM_AMT_MIN_MAX        [string range $cur_line 222 224]
                       set LOCAL_TXN_DATE               [string range $cur_line 225 232]
                       set LOCAL_TXN_TIME               [string range $cur_line 233 238]
                       set TXN_TYPE                     [string range $cur_line 239 240]
                       set MSG_TYPE                     [string range $cur_line 241 244]
                       set ACQ_REF_NBR                  [string range $cur_line 245 267]
                       set NETWORK_REF_ID               [string range $cur_line 268 282]
                      puts $cur_file "Section Record"
                      puts $cur_file "Disputes Section Records"
                      puts $cur_file "The Disputes Record identifies a Chargeback, Representment, Pre_Arbitration"
                      puts $cur_file "or Arbitration processed by Discover Network for Settlement"
                      puts $cur_file "This record is for both Acquirer and Acquirer Processors."
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Dispute Date : >>$DISPUTE_DATE<< "
                      puts $cur_file "Dispute Description : >>$DISPUTE_DESC<< "
                      puts $cur_file "Dispute Reason Code : >>$DISPUTE_REASON_CD<< "
                      puts $cur_file "Card Number : >>$CARD_NBR<< "
                      puts $cur_file "Discover ID : >>$DISC_ID<< "
                      puts $cur_file "MCC : >>$MCC<< "
                      puts $cur_file "Merchant State or Country Code : >>$MERCH_ST_COUNTRY_CD<< "
                      puts $cur_file "Transaction Date : >>$TXN_DATE<< "
                      puts $cur_file "Transaction Amount of Dispute : >>$DISPUTE_AMT<< "
                      puts $cur_file "Transaction ID : >>$TXN_ID<< "
                      puts $cur_file "Case Number : >>$CASE_NBR<< "
                      puts $cur_file "Pricing Program Assessed : >>$PRICING_PROG_ASSESS<< "
                      puts $cur_file "Amount Assessed (Rate based) : >>$PRICING_PROG_ASSESS_RATE<< "
                      puts $cur_file "Amount Assessed (PTF based) : >>$PRICING_PROG_ASSESS_PTF<< "
                      puts $cur_file "Total Amount Assessed : >>$TOT_ASSESS_AMT<< "
                      puts $cur_file "MIN/MAX Used : >>$MIN_MAX_USED<< "
                      puts $cur_file "Cash Reimbursement Amount Assessed (Rate Based) : >>$CASH_REIM_AMT_ASSESS_RATE<< "
                      puts $cur_file "Cash Reimbursement Amount Assessed (PTF Based) : >>$CASH_REIM_AMT_ASSESS_PTF<< "
                      puts $cur_file "Total Cash Reimbursement Amount Assessed : >>$TOT_CASH_REIM_AMT_ASSESS<< "
                      puts $cur_file "Cash Reimbursement MIN/MAX Used : >>$CASH_REIM_AMT_MIN_MAX<< "
                      puts $cur_file "Local Transaction Date : >>$LOCAL_TXN_DATE<< "
                      puts $cur_file "Local Transaction Time : >>$LOCAL_TXN_TIME<< "
                      puts $cur_file "Transaction Type : >>$TXN_TYPE<< "
                      puts $cur_file "Message Type : >>$MSG_TYPE<< "
                      puts $cur_file "Acquirer Reference Number : >>$ACQ_REF_NBR<< "
                      puts $cur_file "Network Reference ID : >>$NETWORK_REF_ID<< "
          } elseif {$SECTION_CD == "04"} {
                      set SUB_SEC_CD               [string range $cur_line 3 3]
                      set FEE_SETTL_DATE           [string range $cur_line 4 11]
                      set TOT_ACQ_ASSES_AMT        [string range $cur_line 12 26] 
                      set ASSESS_VOLUME            [string range $cur_line 27 41]
                      set FEE_CLASS_CD             [string range $cur_line 42 46]
                      set FEE_CLASS_DESC           [string range $cur_line 47 86]
                      set FEE_TYPE_CD              [string range $cur_line 87 91]
                      set FEE_TYPE_DESC            [string range $cur_line 92 131]
                      puts $cur_file "Acquirer Assessments Section Record"
                      puts $cur_file "The Acquirer Assessments Section shows the details of the Acquirer Assesments charged to the Acquirer"
                      puts $cur_file "This record is for Acquirers only and will not be included in any reports provided to Acquirer processs"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Fee Settlement Date  : >>$FEE_SETTL_DATE<<"
                      puts $cur_file "Total Acquirer Assessment Amount : >>$TOT_ACQ_ASSES_AMT<<"
                      puts $cur_file "Assessment Volume : >>$ASSESS_VOLUME<<"
                      puts $cur_file "Fee Class Code : >>$FEE_CLASS_CD<<"
                      puts $cur_file "Fee Class Description : >>$FEE_CLASS_DESC<<"
                      puts $cur_file "Fee Type Code : >>$FEE_TYPE_CD<<"
                      puts $cur_file "Fee Type Description : >>$FEE_TYPE_DESC<<"
                     
          } elseif {$SECTION_CD == "05"} {
                      set SUB_SEC_CD               [string range $cur_line 3 3]
                      set FEE_SETTL_DATE           [string range $cur_line 4 11]
                      set TOT_ACQ_FEE_AMT          [string range $cur_line 12 26] 
                      set FEE_CLASS_CD             [string range $cur_line 27 31]
                      set FEE_CLASS_DESC           [string range $cur_line 32 71]
                      set FEE_TYPE_CD              [string range $cur_line 72 76]
                      set FEE_TYPE_DESC            [string range $cur_line 77 116]
                      puts $cur_file "Acquirer Fees Section Record"
                      puts $cur_file "The Acquirer Fees Section shows the details of the Acquirer Fees charged to the Acquirer"
                      puts $cur_file "This record is for Acquirers only and will not be included in any reports provided to Acquirer processs"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Fee Settlement Date  : >>$FEE_SETTL_DATE<<"
                      puts $cur_file "Total Acquirer Fees Amount : >>$TOT_ACQ_FEE_AMT<<"
                      puts $cur_file "Fee Class Code : >>$FEE_CLASS_CD<<"
                      puts $cur_file "Fee Class Description : >>$FEE_CLASS_DESC<<"
                      puts $cur_file "Fee Type Code : >>$FEE_TYPE_CD<<"
                      puts $cur_file "Fee Type Description : >>$FEE_TYPE_DESC<<"
                     
          } elseif {$SECTION_CD == "06"} {
                      set SUB_SEC_CD               [string range $cur_line 3 3]
                      set CORRECTION_SETTL_DATE    [string range $cur_line 4 11]
                      set CORRECTION_AMT           [string range $cur_line 12 26] 
                      set CORRECT_CLASS_CD         [string range $cur_line 27 31]
                      set CORRECT_CLASS_DESC       [string range $cur_line 32 71]
                      set CORRECT_TYPE_CD          [string range $cur_line 72 76]
                      set CORRECT_TYPE_DESC        [string range $cur_line 77 116]
                      puts $cur_file "Corrections Section Record"
                      puts $cur_file "The Corrections Section shows the details of the Corrections charged to the Acquirer"
                      puts $cur_file "This record is for Acquirers only and will not be included in any reports provided to Acquirer processs"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Corrections Settlement Date  : >>$CORRECTION_SETTL_DATE<<"
                      puts $cur_file "Corrections Amount : >>$CORRECTION_AMT<<"
                      puts $cur_file "Corrections Class Code : >>$CORRECT_CLASS_CD<<"
                      puts $cur_file "Corrections Class Description : >>$CORRECT_CLASS_DESC<<"
                      puts $cur_file "Corrections Type Code : >>$CORRECT_TYPE_CD<<"
                      puts $cur_file "Corrections Type Description : >>$CORRECT_TYPE_DESC<<"
                     
          } elseif {$SECTION_CD == "07"} {
                      set SUB_SEC_CD               [string range $cur_line 3 3]               
                      set REJECT_TYPE              [string range $cur_line 4 4]
               if {$REJECT_TYPE == "1"} {
                      set REJECT_REASON_CD         [string range $cur_line 5 8] 
                      set REJECT_DESC              [string range $cur_line 9 48]
                      set REJECT_DATE              [string range $cur_line 49 56]
                      set FILE_TRANS_DATETIME      [string range $cur_line 57 66]
                      
                      puts $cur_file "Processing Rejects Section Record"
                      puts $cur_file "File Reject Record"
                      puts $cur_file "The File Reject Record identifies a Sales Data from an Acquirer"
                      puts $cur_file "This record is for Acquirers processors only and will not be included in any reports provided to Acquirer"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Reject type (Batch Reject) : >>$REJECT_TYPE<<"
                      puts $cur_file "Reject Reason Code : >>$REJECT_REASON_CD<<"
                      puts $cur_file "Reject Description : >>$REJECT_DESC<<"
                      puts $cur_file "Reject Date : >>$REJECT_DATE<<"
                      puts $cur_file "File Transmission Date and Time : >>$FILE_TRANS_DATETIME<<"
               } elseif {$REJECT_TYPE == "3"} {
                      set REJECT_REASON_CD         [string range $cur_line 5 8] 
                      set REJECT_DESC              [string range $cur_line 9 48]
                      set REJECT_DATE              [string range $cur_line 49 56]
                      set PROCESSOR_ID             [string range $cur_line 57 67]
                      set PROCESSOR_NAME           [string range $cur_line 68 107]
                      set BATCH_TRANS_DATETIME     [string range $cur_line 108 117]
                      set ALL_BATCH_RECORD         [string range $cur_line 118 367]
                      
                      puts $cur_file "Processing Rejects Section Record"
                      puts $cur_file "Batch Reject Record"
                      puts $cur_file "The File Reject Record identifies a Sales Data from an Acquirer"
                      puts $cur_file "This record is for both Acquirers processors and Acquirer"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Reject type : >>$REJECT_TYPE<<"
                      puts $cur_file "Reject Reason Code : >>$REJECT_REASON_CD<<"
                      puts $cur_file "Reject Description : >>$REJECT_DESC<<"
                      puts $cur_file "Reject Date : >>$REJECT_DATE<<"
                      puts $cur_file "Processor ID Submitting Batch:  >>$PROCESSOR_ID<<"
                      puts $cur_file "Processor Name: >>$PROCESSOR_NAME<<"
                      puts $cur_file "Batch Transmission Date and Time : >>$BATCH_TRANS_DATETIME<<"
                      puts $cur_file "Entire Batch Record: >>$ALL_BATCH_RECORD<<"
               } elseif {$REJECT_TYPE == "4"} {
                      set REJECT_REASON_CD         [string range $cur_line 5 8] 
                      set REJECT_DESC              [string range $cur_line 9 48]
                      set REJECT_DATE              [string range $cur_line 49 56]
                      set PROCESSOR_ID             [string range $cur_line 57 67]
                      set PROCESSOR_NAME           [string range $cur_line 68 107]
                      set TXN_TRANS_DATETIME     [string range $cur_line 108 117]
                      set DISC_ID                  [string range $cur_line 118 132]
                      set ALL_DETAIL_RECORD        [string range $cur_line 133 382]
                      
                      puts $cur_file "Processing Rejects Section Record"
                      puts $cur_file "Detail Reject Record"
                      puts $cur_file "This record is for both Acquirers processors and Acquirer"
                      puts $cur_file "Record Type: >>$RECORD_TYPE<<"
                      puts $cur_file "Section Code: >>$SECTION_CD<<"
                      puts $cur_file "Sub-Section Code: >>$SUB_SEC_CD<<"
                      puts $cur_file "Reject type : >>$REJECT_TYPE<<"
                      puts $cur_file "Reject Reason Code : >>$REJECT_REASON_CD<<"
                      puts $cur_file "Reject Description : >>$REJECT_DESC<<"
                      puts $cur_file "Reject Date : >>$REJECT_DATE<<"
                      puts $cur_file "Processor ID Submitting Batch:  >>$PROCESSOR_ID<<"
                      puts $cur_file "Processor Name: >>$PROCESSOR_NAME<<"
                      puts $cur_file "Transaction Transmission Date and Time : >>$TXN_TRANS_DATETIME<<"
                      puts $cur_file "Discover Network merchant Number: >>$DISC_ID<<"
                      puts $cur_file "Entire Detail Record: >>$ALL_DETAIL_RECORD<<"
               }
          }

      }
      
#===============================================================================
#=== Trailer Records ===========
#===============================================================================
 
      if {[string range $cur_line 0 0] == "8" } {
          set RECORD_TYPE            [string range $cur_line 0 0]
          set MAIL_BOX               [string range $cur_line 1 8]
          set ACQ_PROCESSOR_ID       [string range $cur_line 9 19]
          set RECORD_CNT             [string range $cur_line 20 30]
          
          puts $cur_file "Trailer Record"
          puts $cur_file "Record Type: >>$RECORD_TYPE<<"
          puts $cur_file "Destination Mailbox: >>$MAIL_BOX<<"
          puts $cur_file "ID of Acquiere or Processor Receiving File: >>$ACQ_PROCESSOR_ID<<"
          puts $cur_file "Detail Record Count: >>$RECORD_CNT<<"
           puts $cur_file " "
           puts $cur_file " "
      }

#===============================================================================
#=== Destination Trailer Record ===========
#===============================================================================      
       if {[string range $cur_line 0 0] == "9" } {
          set RECORD_TYPE            [string range $cur_line 0 0]
          set MAIL_BOX               [string range $cur_line 1 8]
          set RECORD_CNT             [string range $cur_line 9 19]
          set FILE_CNT               [string range $cur_line 20 30]
          
          puts $cur_file "Destination Trailer Record"
          puts $cur_file "Record Type: >>$RECORD_TYPE<<"
          puts $cur_file "Destination Mailbox: >>$MAIL_BOX<<"
          puts $cur_file "Detail Record Count: >>$RECORD_CNT<<"
          puts $cur_file "File Count: >>$FILE_CNT<<"
           puts $cur_file " "
           puts $cur_file " "
      }
      
    }
#===============================================================================    
    close $cur_file

      if {[string length $emsg] != "0"} {
    #  exec  echo "File located at $path \n $emsg" | mailx -r clearing@jetpay.com -s "Discover Batch/File Rejected: $file_name" clearing@jetpay.com
    #  exec  echo "File located at $path \n $emsg" | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
      }
#===============================================================================
#                                  THE  END
#===============================================================================

