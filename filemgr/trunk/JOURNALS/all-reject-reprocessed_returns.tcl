#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: all-reject-reprocessed_returns.tcl 4213 2017-06-26 14:36:17Z bjones $
# $Rev: 4213 $
################################################################################
#
# File Name:  all-reject-reprocessed_returns.tcl
#
# Description:  This program generates reprocessed reject reports by 
#               institution.
#              
# Script Arguments:  inst_id = Instution ID (ALL or individual institution.  
#							   Required.
#                    today = Run date (e.g., YYYYMMDD).  Optional.  
#                            Defaults to current date.
#
# Output:  Reprocessed reject reports by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(IST_DB)
#set authdb $env(ATH_DB)
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

# Just comment out the TEST set mode to run in production
set mode "PROD"
#set mode "TEST"

package require Oratcl
if {[catch {set handlerM [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo "all-reject-return.tcl failed to run" | mailx -r $mailfromlist -s "$box: all-reject-return.tcl failed to run" $mailtolist
  exit
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
      set inst_id          "ALL"
      set today            [string toupper  [clock format [clock scan "today"]  -format  %d-%b-%y ]]
      set tomorrow         [string toupper  [clock format [clock scan "+1 day"] -format %d-%b-%y]]
      set yesterday        [string toupper [clock format [clock scan "-1 day"] -format %d-%b-%y]]
      set filedate         [clock format [clock scan "today"] -format %Y%m%d]
      set CUR_SET_TIME     [clock seconds]
      set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]

   } elseif {$argc == 1 } {
      set input [lindex $argv 0]
      if { $input == "ROLLUP" || $input == "105" || $input == "ALL" } {
            set inst_id  [lindex $argv 0]
            set today    [clock format [ clock scan "-0 day" ] -format %Y%m%d]          
      } elseif { [string length $input ] == 8 } {
            set today    [lindex $argv 0]
            set inst_id  "ALL"
      } elseif {[string length $input ] != 3 && [string length $input ] != 8} {            
        puts "REPORT DATE SHOULD BE 8 DIGITS"
        puts "REPORT INST SHOULD BE 3 DIGITS"
        exit 0        
      }
      set report_date         [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%y ]]   ;# 02-APR-08 as of 20080402
      set tomorrow            [string toupper  [clock format [clock scan " $today +1 day"] -format %d-%b-%y]]
      set yesterday           [string toupper [clock format [clock scan "$today -1 day"] -format %d-%b-%y]]
      set filedate             [string toupper [clock format [ clock scan " $today -0 day " ] -format %Y%m%d ]]
      set today                [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]
   } elseif {$argc == 2 } {
      set inst_id  [lindex $argv 0]
      set today    [lindex $argv 1]
      if { $inst_id != "ROLLUP" && $inst_id != "105" && $inst_id != "ALL" } {
            puts "options for inst are: ROLLUP, 105 or ALL"
            exit
      }
      if { [string length $today ] != 8 } {       
        puts "REPORT DATE SHOULD BE 8 DIGITS"
        exit 0        
      }
      set report_date         [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%y ]]   ;# 02-APR-08 as of 20080402
      set tomorrow            [string toupper  [clock format [clock scan " $today +1 day"] -format %d-%b-%y]]
      set yesterday           [string toupper [clock format [clock scan "$today -1 day"] -format %d-%b-%y]]
      set filedate             [string toupper [clock format [ clock scan " $today -0 day " ] -format %Y%m%d ]]
      set today                [string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]
   } else {
      exit
   }

#JNC - Expediency is the rationale.  Just updating the institution list of ALL to add the new ISOs
      if {$inst_id == "ALL"} {
            set value "'101', '105', '107', '111', '117', '121'"
      } elseif {$inst_id == "ROLLUP"} {
            set value "'101', '107'"
      } elseif {$inst_id == "105"} {
            set value "'105'"
      } elseif {$inst_id == "106"} {
            set value "'106'"
      } elseif {$inst_id == "111"} {
            set value "'111'"
      } elseif {$inst_id == "117"} {
            set value "'117'"
      } elseif {$inst_id == "121"} {
            set value "'121'"
      }
puts "inst_id : $inst_id"
puts "...value is :$value"

#JNC - Expediency excuse again.  Cloning filename setup in ALL with new ISOs
      if {$mode == "TEST"} {
            if { $inst_id == "ALL" } {
                set cur_file_name_105    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set file_name_105        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set cur_file_105         [open "$cur_file_name_105" w]
          
                set cur_file_name_105_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set file_name_l05_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set cur_file_105_in        [open "$cur_file_name_105_in" w]
                
                set cur_file_name_106    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set file_name_106        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set cur_file_106         [open "$cur_file_name_106" w]
          
                set cur_file_name_106_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set file_name_l06_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set cur_file_106_in        [open "$cur_file_name_106_in" w]
                
                set cur_file_name    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set cur_file         [open "$cur_file_name" w]
          
                set cur_file_name2   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set file_name2       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set cur_file2        [open "$cur_file_name2" w]  

                set cur_file_name_112    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.112.TEST.csv"
                set file_name_112        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.112.TEST.csv"
                set cur_file_112         [open "$cur_file_name_112" w]
          
                set cur_file_name_112_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.112.TEST.csv"
                set file_name_112_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.112.TEST.csv"
                set cur_file_112_in        [open "$cur_file_name_112_in" w]


                set cur_file_name_113    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.113.TEST.csv"
                set file_name_113        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.113.TEST.csv"
                set cur_file_113         [open "$cur_file_name_113" w]
          
                set cur_file_name_113_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.113.TEST.csv"
                set file_name_113_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.113.TEST.csv"
                set cur_file_113_in        [open "$cur_file_name_113_in" w]

                set cur_file_name_114    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.114.TEST.csv"
                set file_name_114        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.114.TEST.csv"
                set cur_file_114         [open "$cur_file_name_114" w]
          
                set cur_file_name_114_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.114.TEST.csv"
                set file_name_114_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.114.TEST.csv"
                set cur_file_114_in        [open "$cur_file_name_114_in" w]

                set cur_file_name_115    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.115.TEST.csv"
                set file_name_115        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.115.TEST.csv"
                set cur_file_115         [open "$cur_file_name_115" w]
          
                set cur_file_name_115_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.115.TEST.csv"
                set file_name_115_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.115.TEST.csv"
                set cur_file_115_in        [open "$cur_file_name_115_in" w]

                set cur_file_name_116    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.116.TEST.csv"
                set file_name_116        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.116.TEST.csv"
                set cur_file_116         [open "$cur_file_name_116" w]
          
                set cur_file_name_116_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.116.TEST.csv"
                set file_name_116_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.116.TEST.csv"
                set cur_file_116_in        [open "$cur_file_name_116_in" w]

            } elseif {$inst_id == "105"} {
                set cur_file_name_105    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set file_name_105        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set cur_file_105         [open "$cur_file_name_105" w]
          
                set cur_file_name_105_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set file_name_l05_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.105.TEST.csv"
                set cur_file_105_in        [open "$cur_file_name_105_in" w]                           
            } elseif {$inst_id == "106"} {
                set cur_file_name_106    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set file_name_106        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set cur_file_106         [open "$cur_file_name_106" w]
          
                set cur_file_name_106_in   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set file_name_106_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.106.TEST.csv"
                set cur_file_106_in        [open "$cur_file_name_106_in" w]                           
            } elseif {$inst_id == "ROLLUP"} {
                set cur_file_name    "./ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set cur_file         [open "$cur_file_name" w]
          
                set cur_file_name2   "./ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set file_name2       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.TEST.csv"
                set cur_file2        [open "$cur_file_name2" w]                    
            }
      } elseif {$mode == "PROD"} {
            if { $inst_id == "105" } {
                set cur_file_name_105    "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set file_name_105        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set cur_file_105         [open "$cur_file_name_105" w]
          
                set cur_file_name_105_in   "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set file_name_l05_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set cur_file_105_in        [open "$cur_file_name_105_in" w]          
            } elseif { $inst_id == "106" } {
                set cur_file_name_106    "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set file_name_106        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set cur_file_106         [open "$cur_file_name_106" w]
          
                set cur_file_name_106_in   "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set file_name_l06_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set cur_file_106_in        [open "$cur_file_name_106_in" w]          
            } elseif {$inst_id == "ROLLUP"} {
                set cur_file_name    "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set cur_file         [open "$cur_file_name" w]
          
                set cur_file_name2   "./ROLLUP/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set file_name2       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set cur_file2        [open "$cur_file_name2" w]          
            } elseif {$inst_id == "ALL"} {
                set cur_file_name_105    "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set file_name_105        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set cur_file_105         [open "$cur_file_name_105" w]
          
                set cur_file_name_105_in   "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set file_name_l05_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.105.001.csv"
                set cur_file_105_in        [open "$cur_file_name_105_in" w]
                
                set cur_file_name    "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set cur_file         [open "$cur_file_name" w]
          
                set cur_file_name2   "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set file_name2       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
                set cur_file2        [open "$cur_file_name2" w]
                      
                set cur_file_name_106    "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set file_name_106        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set cur_file_106         [open "$cur_file_name_106" w]
          
                set cur_file_name_106_in   "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set file_name_l06_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
                set cur_file_106_in        [open "$cur_file_name_106_in" w]          

                set cur_file_name_112    "/clearing/filemgr/JOURNALS/INST_112/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.112.001.csv"
                set file_name_112        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.112.001.csv"
                set cur_file_112         [open "$cur_file_name_112" w]
          
                set cur_file_name_112_in   "/clearing/filemgr/JOURNALS/INST_112/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.112.001.csv"
                set file_name_112_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.112.001.csv"
                set cur_file_112_in        [open "$cur_file_name_112_in" w]          

                set cur_file_name_113    "/clearing/filemgr/JOURNALS/INST_113/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.113.001.csv"
                set file_name_113        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.113.001.csv"
                set cur_file_113         [open "$cur_file_name_113" w]
          
                set cur_file_name_113_in   "/clearing/filemgr/JOURNALS/INST_113/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.113.001.csv"
                set file_name_113_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.113.001.csv"
                set cur_file_113_in        [open "$cur_file_name_113_in" w]          

                set cur_file_name_114    "/clearing/filemgr/JOURNALS/INST_114/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.114.001.csv"
                set file_name_114        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.114.001.csv"
                set cur_file_114         [open "$cur_file_name_114" w]
          
                set cur_file_name_114_in   "/clearing/filemgr/JOURNALS/INST_114/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.114.001.csv"
                set file_name_114_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.114.001.csv"
                set cur_file_114_in        [open "$cur_file_name_114_in" w]          

                set cur_file_name_115    "/clearing/filemgr/JOURNALS/INST_115/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.115.001.csv"
                set file_name_115        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.115.001.csv"
                set cur_file_115         [open "$cur_file_name_115" w]
          
                set cur_file_name_115_in   "/clearing/filemgr/JOURNALS/INST_115/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.115.001.csv"
                set file_name_115_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.115.001.csv"
                set cur_file_115_in        [open "$cur_file_name_115_in" w]          

                set cur_file_name_116    "/clearing/filemgr/JOURNALS/INST_116/UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.116.001.csv"
                set file_name_116        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.116.001.csv"
                set cur_file_116         [open "$cur_file_name_116" w]
          
                set cur_file_name_116_in   "/clearing/filemgr/JOURNALS/INST_116/UPLOAD/ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.116.001.csv"
                set file_name_116_in       "ROLLUP.REPROCESSED_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.116.001.csv"
                set cur_file_116_in        [open "$cur_file_name_116_in" w]          

            }
      }
      

#===============================================================================
#=====================      OUTGOING REJECT      ===============================
#===============================================================================

# Expediency again.  Cloned the variables for the other institutions

set mclist101  ""
set vslist101  ""
set dslist101  ""
set MC_C_TOTAL101 0
set MC_D_TOTAL101 0
set DS_C_TOTAL101 0
set DS_D_TOTAL101 0
set VS_C_TOTAL101 0
set VS_D_TOTAL101 0

set mclist105  ""
set vslist105  ""
set dslist105  ""
set MC_C_TOTAL105 0
set MC_D_TOTAL105 0
set VS_C_TOTAL105 0
set VS_D_TOTAL105 0
set DS_C_TOTAL105 0
set DS_D_TOTAL105 0

set mclist107  ""
set vslist107  ""
set dslist107  ""
set MC_C_TOTAL107 0
set MC_D_TOTAL107 0
set VS_C_TOTAL107 0
set VS_D_TOTAL107 0
set DS_C_TOTAL107 0
set DS_D_TOTAL107 0

set mclist440339  ""
set vslist440339  ""
set dslist440339  ""
set MC_C_TOTAL440339 0
set MC_D_TOTAL440339 0
set VS_C_TOTAL440339 0
set VS_D_TOTAL440339 0
set DS_C_TOTAL440339 0
set DS_D_TOTAL440339 0

set mclist111  ""
set vslist111  ""
set dslist111  ""
set MC_C_TOTAL111 0
set MC_D_TOTAL111 0
set VS_C_TOTAL111 0
set VS_D_TOTAL111 0
set DS_C_TOTAL111 0
set DS_D_TOTAL111 0

set mclist112  ""
set vslist112  ""
set dslist112  ""
set MC_C_TOTAL112 0
set MC_D_TOTAL112 0
set VS_C_TOTAL112 0
set VS_D_TOTAL112 0
set DS_C_TOTAL112 0
set DS_D_TOTAL112 0

set mclist113  ""
set vslist113  ""
set dslist113  ""
set MC_C_TOTAL113 0
set MC_D_TOTAL113 0
set VS_C_TOTAL113 0
set VS_D_TOTAL113 0
set DS_C_TOTAL113 0
set DS_D_TOTAL113 0

set mclist114  ""
set vslist114  ""
set dslist114  ""
set MC_C_TOTAL114 0
set MC_D_TOTAL114 0
set VS_C_TOTAL114 0
set VS_D_TOTAL114 0
set DS_C_TOTAL114 0
set DS_D_TOTAL114 0

set mclist115  ""
set vslist115  ""
set dslist115  ""
set MC_C_TOTAL115 0
set MC_D_TOTAL115 0
set VS_C_TOTAL115 0
set VS_D_TOTAL115 0
set DS_C_TOTAL115 0
set DS_D_TOTAL115 0

set mclist116  ""
set vslist116  ""
set dslist116  ""
set MC_C_TOTAL116 0
set MC_D_TOTAL116 0
set VS_C_TOTAL116 0
set VS_D_TOTAL116 0
set DS_C_TOTAL116 0
set DS_D_TOTAL116 0

set mclist117  ""
set vslist117  ""
set dslist117  ""
set MC_C_TOTAL117 0
set MC_D_TOTAL117 0
set VS_C_TOTAL117 0
set VS_D_TOTAL117 0
set DS_C_TOTAL117 0
set DS_D_TOTAL117 0

set mclist121  ""
set vslist121  ""
set dslist121  ""
set MC_C_TOTAL121 0
set MC_D_TOTAL121 0
set VS_C_TOTAL121 0
set VS_D_TOTAL121 0
set DS_C_TOTAL121 0
set DS_D_TOTAL121 0


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
                                trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
                                ind.tid,
                                tid.TID_SETTL_METHOD as INDICATOR,
                                TID.DESCRIPTION AS TRAN_CODE
                         FROM  ep_event_log ep, in_draft_main ind, tid
                         WHERE ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
                              AND ind.tid = tid.tid
                              AND ep.CARD_SCHEME in ('05', '04', '08')
                              AND ep.EMS_ITEM_TYPE in ('CR1','CR2','PR1')
                              AND ep.Event_log_date like '$today%'
                              AND ep.institution_id  in ($value)
                              AND ind.in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$today%')
                       ORDER BY ep.TRANS_SEQ_NBR "
      puts $query_stringM1
      orasql $fetch_cursorM1 $query_stringM1
      while {[orafetch $fetch_cursorM1 -dataarray s -indexbyname] != 1403} {
            set iso $s(ISONO)
            if {$s(CARD_SCHEME) == "05"} {
                if {$s(INSTITUTION_ID) == "105"} {
                    lappend mclist105 $s(EP_EVENT_ID) 
                } elseif {$s(INSTITUTION_ID) == "101"} {
                    lappend mclist101 $s(EP_EVENT_ID) 
                } elseif {$s(INSTITUTION_ID) == "107"} {
                    lappend mclist107 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "111"} {
                    lappend mclist111 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "112"} {
                    lappend mclist112 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "113"} {
                    lappend mclist113 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "114"} {
                    lappend mclist114 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "115"} {
                    lappend mclist115 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "116"} {
                    lappend mclist116 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "116"} {
                    lappend mclist117 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "117"} {
                    lappend mclist121 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "121"} {
                  if {$iso == "440339"} {
                    lappend mclist440339 $s(EP_EVENT_ID)
                  }                    
                }                                  
            } elseif {$s(CARD_SCHEME) == "04"} {
                if {$s(INSTITUTION_ID) == "105"} {
                    lappend vslist105 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "101"} {
                    lappend vslist101 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "107"} {
                    lappend vslist107 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "111"} {
                    lappend vslist111 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "112"} {
                    lappend vslist112 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "113"} {
                    lappend vslist113 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "114"} {
                    lappend vslist114 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "115"} {
                    lappend vslist115 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "116"} {
                    lappend vslist116 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "117"} {
                    lappend vslist117 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "121"} {
                    lappend vslist121 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "106"} {
                  if {$iso == "440339"} {
                    lappend vslist440339 $s(EP_EVENT_ID)
                  }                    
                }    
            } elseif {$s(CARD_SCHEME) == "08"} {
                if {$s(INSTITUTION_ID) == "105"} {
                    lappend dslist105 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "101"} {
                    lappend dslist101 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "107"} {
                    lappend dslist107 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "112"} {
                    lappend dslist112 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "113"} {
                    lappend dslist113 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "114"} {
                    lappend dslist114 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "115"} {
                    lappend dslist115 $s(EP_EVENT_ID)
                }  elseif {$s(INSTITUTION_ID) == "116"} {
                    lappend dslist116 $s(EP_EVENT_ID)
                } elseif {$s(INSTITUTION_ID) == "106"} {
                  if {$iso == "440339"} {
                    lappend dslist440339 $s(EP_EVENT_ID)
                  }                    
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
#====  writing 105 out-going reject report =====================================
if {[file exists $cur_file_name_105]} {
      puts $cur_file_105 "ISO:,105"
      puts $cur_file_105  "JETPAY"
      puts $cur_file_105  "ISO OUTGOING REJECT REPORT"
      puts $cur_file_105  "REPORT DATE: , $today "
      puts $cur_file_105  "       "
      puts $cur_file_105  "       "
      puts $cur_file_105 "PLAN TYPE:  , MASTER CARD"
      puts $cur_file_105  "       "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL105 [expr $MC_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL105 [expr $MC_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL105 "
      puts $cur_file_105 " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL105"
      puts $cur_file_105 "     "
      puts $cur_file_105 "     "
      puts $cur_file_105 "PLAN TYPE: ,  VISA"
      puts $cur_file_105 "    "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file_105 "     "
      
      foreach EPNO $vslist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL105 [expr $VS_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL105 [expr $VS_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL105 "
      puts $cur_file_105 " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL105 "
      puts $cur_file_105 "    "
      puts $cur_file_105 "    "
      puts $cur_file_105 "PLAN TYPE: ,  DISCOVER"
      puts $cur_file_105 "    "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO) "
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL105 [expr $DS_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL105 [expr $DS_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL105 "
      puts $cur_file_105 " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL105 "

      puts $cur_file_105  "       "
      puts $cur_file_105  "       "
      puts $cur_file_105  "       "
      puts $cur_file_105  "ISO:,ALL"
      puts $cur_file_105  "JETPAY"
      puts $cur_file_105  "ISO OUTGOING REJECT REPORT"
      puts $cur_file_105  "REPORT DATE: , $today "
      puts $cur_file_105  "       "
      puts $cur_file_105  "       "
      puts $cur_file_105 "PLAN TYPE:  , MASTER CARD"
      puts $cur_file_105 "     "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL105 [expr $MC_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL105 [expr $MC_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL105 "
      puts $cur_file_105 " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL105"
      puts $cur_file_105 "  "
      puts $cur_file_105 "     "
      puts $cur_file_105 "PLAN TYPE: ,  VISA"
      puts $cur_file_105 "     "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file_105 "     "
      
      foreach EPNO $vslist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL105 [expr $VS_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL105 [expr $VS_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL105 "
      puts $cur_file_105 " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL105 "
      puts $cur_file_105 "  "
      puts $cur_file_105 "    "
      puts $cur_file_105 "PLAN TYPE: ,  DISCOVER"
      puts $cur_file_105 "     "
      puts $cur_file_105 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist105 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_105 " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)\r\n"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL105 [expr $DS_C_TOTAL105 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL105 [expr $DS_D_TOTAL105 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_105 "     "
      puts $cur_file_105 "TOTAL"
      puts $cur_file_105 "     "
      puts $cur_file_105 " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL105 "
      puts $cur_file_105 " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL105 "   
      
      close $cur_file_105
} else {
      puts "not outgoing reject file created for INST 105"
}

#==== Writing Merrick out-going reject report ==================================
if {[file exists $cur_file_name]} {
      puts $cur_file "ISO:,101"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file  "       "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL101 [expr $MC_C_TOTAL101 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL101 [expr $MC_D_TOTAL101 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL101 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL101 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL101 [expr $VS_C_TOTAL101 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL101 [expr $VS_D_TOTAL101 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL101 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL101 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL101 [expr $DS_C_TOTAL101 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL101 [expr $DS_D_TOTAL101 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL101 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL101 "

      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 
      puts $cur_file "ISO:,107"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL107 [expr $MC_C_TOTAL107 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL107 [expr $MC_D_TOTAL107 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL107 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL107 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL107 [expr $VS_C_TOTAL107 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL107 [expr $VS_D_TOTAL107 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL107 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL107 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL107 [expr $DS_C_TOTAL107 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL107 [expr $DS_D_TOTAL107 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL107 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL107 "
     
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 
      puts $cur_file "ISO:,112"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL112 [expr $MC_C_TOTAL112 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL112 [expr $MC_D_TOTAL112 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL112 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL112 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL112 [expr $VS_C_TOTAL112 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL112 [expr $VS_D_TOTAL112 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL112 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL112 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL112 [expr $DS_C_TOTAL112 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL112 [expr $DS_D_TOTAL112 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL112 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL112 "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 

      puts $cur_file "ISO:,113"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL113 [expr $MC_C_TOTAL113 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL113 [expr $MC_D_TOTAL113 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL113 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL113 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL113 [expr $VS_C_TOTAL113 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL113 [expr $VS_D_TOTAL113 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL113 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL113 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL113 [expr $DS_C_TOTAL113 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL113 [expr $DS_D_TOTAL113 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL113 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL113 "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 

      puts $cur_file "ISO:,114"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL114 [expr $MC_C_TOTAL114 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL114 [expr $MC_D_TOTAL114 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL114 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL114 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL114 [expr $VS_C_TOTAL114 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL114 [expr $VS_D_TOTAL114 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL114 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL114 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL114 [expr $DS_C_TOTAL114 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL114 [expr $DS_D_TOTAL114 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL114 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL114 "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 

      puts $cur_file "ISO:,115"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL115 [expr $MC_C_TOTAL115 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL115 [expr $MC_D_TOTAL115 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL115 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL115 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL115 [expr $VS_C_TOTAL115 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL115 [expr $VS_D_TOTAL115 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL115 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL115 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL115 [expr $DS_C_TOTAL115 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL115 [expr $DS_D_TOTAL115 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL115 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL115 "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 

      puts $cur_file "ISO:,116"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
   
      foreach EPNO $mclist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL116 [expr $MC_C_TOTAL116 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL116 [expr $MC_D_TOTAL116 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL116 "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL116 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "



      foreach EPNO $vslist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL116 [expr $VS_C_TOTAL116 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL116 [expr $VS_D_TOTAL116 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL116 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL116 "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  

      foreach EPNO $dslist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL116 [expr $DS_C_TOTAL116 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL116 [expr $DS_D_TOTAL116 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL116 "
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL116 "

      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file  "       " 
      puts $cur_file "ISO:,ROLLUP"
      puts $cur_file  "JETPAY"
      puts $cur_file  "ISO OUTGOING REJECT REPORT"
      puts $cur_file  "REPORT DATE: , $today "
      puts $cur_file  "       "
      puts $cur_file  "       "
      puts $cur_file "PLAN TYPE:  , MASTER CARD"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"
      
      foreach EPNO $mclist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $mclist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $[expr $MC_D_TOTAL101 + $MC_D_TOTAL107 + $MC_D_TOTAL112 + $MC_D_TOTAL113 + $MC_D_TOTAL114 + $MC_D_TOTAL115 + $MC_D_TOTAL116] "
      puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $[expr $MC_C_TOTAL101 + $MC_C_TOTAL107 + $MC_C_TOTAL112 + $MC_C_TOTAL113 + $MC_C_TOTAL114 + $MC_C_TOTAL115 + $MC_C_TOTAL116] "
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  VISA"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file "  "


      foreach EPNO $vslist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      foreach EPNO $vslist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
            }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $[expr $VS_D_TOTAL101 + $VS_D_TOTAL107 + $VS_D_TOTAL112 + $VS_D_TOTAL113 + $VS_D_TOTAL114 + $VS_D_TOTAL115 + $VS_D_TOTAL116] "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $[expr $VS_C_TOTAL101 + $VS_C_TOTAL107 + $VS_C_TOTAL112 + $VS_C_TOTAL113 + $VS_C_TOTAL114 + $VS_C_TOTAL115 + $VS_C_TOTAL116]"
      puts $cur_file "  "
      puts $cur_file "  "
      puts $cur_file "PLAN TYPE: ,  DISCOVER"
      puts $cur_file "     "
      puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "      
  
      foreach EPNO $dslist101 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist107 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist112 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist113 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist114 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist115 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      foreach EPNO $dslist116 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
             }
      }
      puts $cur_file "     "
      puts $cur_file "TOTAL"
      puts $cur_file "     "
      puts $cur_file " Discover Card Outgoing Rejects Debit Subtotal:, $[expr $DS_D_TOTAL101 + $DS_D_TOTAL107 + $DS_D_TOTAL112 + $DS_D_TOTAL113 + $DS_D_TOTAL114 + $DS_D_TOTAL115 + $DS_D_TOTAL116]"
      puts $cur_file " Discover Card Outgoing Rejects Credit Subtotal:, $[expr $DS_C_TOTAL101 + $DS_C_TOTAL107 + $DS_C_TOTAL112 + $DS_C_TOTAL113 + $DS_C_TOTAL114 + $DS_C_TOTAL115 + $DS_C_TOTAL116]"

      close $cur_file
} else {
      puts "no outgoing reject file created for Merrick"
}

#====  writing 106 out-going reject report =====================================
if {[file exists $cur_file_name_106]} {
      puts $cur_file_106 "ISO:,106, ISO NAME:, REVTRAK"
     # puts $cur_file_106 "ISO NAME:, REVTRAK"
      puts $cur_file_106 "JETPAY"
      puts $cur_file_106 "ISO OUTGOING REJECT REPORT"
      puts $cur_file_106 "REPORT DATE: , $today "
      puts $cur_file_106 "       "
      puts $cur_file_106 "       "
      puts $cur_file_106 "PLAN TYPE:  , MASTER CARD"
      puts $cur_file_106 "       "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL440339 [expr $MC_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL440339 [expr $MC_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL440339 "
      puts $cur_file_106 " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL440339"
      puts $cur_file_106 "     "
      puts $cur_file_106 "     "
      puts $cur_file_106 "PLAN TYPE: ,  VISA"
      puts $cur_file_106 "    "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file_106 "     "
      
      foreach EPNO $vslist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL440339 [expr $VS_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL440339 [expr $VS_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL440339 "
      puts $cur_file_106 " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL440339 "
      puts $cur_file_106 "    "
      puts $cur_file_106 "    "
      puts $cur_file_106 "PLAN TYPE: ,  DISCOVER"
      puts $cur_file_106 "    "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO) "
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL440339 [expr $DS_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL440339 [expr $DS_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL440339 "
      puts $cur_file_106 " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL440339 "

      puts $cur_file_106  "       "
      puts $cur_file_106  "       "
      puts $cur_file_106  "       "
      puts $cur_file_106  "ISO:,ROLLUP"
      puts $cur_file_106  "JETPAY"
      puts $cur_file_106  "ISO OUTGOING REJECT REPORT"
      puts $cur_file_106  "REPORT DATE: , $today "
      puts $cur_file_106  "       "
      puts $cur_file_106  "       "
      puts $cur_file_106 "PLAN TYPE:  , MASTER CARD"
      puts $cur_file_106 "     "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

          
      foreach EPNO $mclist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set MC_C_TOTAL440339 [expr $MC_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set MC_D_TOTAL440339 [expr $MC_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL440339 "
      puts $cur_file_106 " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL440339"
      puts $cur_file_106 "  "
      puts $cur_file_106 "     "
      puts $cur_file_106 "PLAN TYPE: ,  VISA"
      puts $cur_file_106 "     "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
      puts $cur_file_106 "     "
      
      foreach EPNO $vslist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)"
                  if {$INDICATOR($EPNO) == "C"} {
                     set VS_C_TOTAL440339 [expr $VS_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set VS_D_TOTAL440339 [expr $VS_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL440339 "
      puts $cur_file_106 " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL440339 "
      puts $cur_file_106 "  "
      puts $cur_file_106 "    "
      puts $cur_file_106 "PLAN TYPE: ,  DISCOVER"
      puts $cur_file_106 "     "
      puts $cur_file_106 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "


      foreach EPNO $dslist440339 {
            if {$AMOUNT($EPNO) != 0 } {
                  puts $cur_file_106 " $ACCOUNT_NBR($EPNO),'$TRAN_CODE($EPNO), $$AMOUNT($EPNO),'$REF_NO($EPNO),'$DATE($EPNO),'$REASON($EPNO), $INDICATOR($EPNO)\r\n"
                  if {$INDICATOR($EPNO) == "C"} {
                     set DS_C_TOTAL440339 [expr $DS_C_TOTAL440339 + $AMOUNT($EPNO)]
                  } elseif {$INDICATOR($EPNO) == "D"} {
                     set DS_D_TOTAL440339 [expr $DS_D_TOTAL440339 + $AMOUNT($EPNO)]
                  }
            }
      }
      puts $cur_file_106 "     "
      puts $cur_file_106 "TOTAL"
      puts $cur_file_106 "     "
      puts $cur_file_106 " Discover Card Outgoing Rejects Debit Subtotal:, $$DS_D_TOTAL440339 "
      puts $cur_file_106 " Discover Card Outgoing Rejects Credit Subtotal:, $$DS_C_TOTAL440339 "   
      
      close $cur_file_106
} else {
      puts "not outgoing reject file created for INST 106"
}

#===============================================================================
#=====================      INCOMING REJECT      ===============================
#===============================================================================
set mclist101  ""
set vslist101  ""
set dslist101  ""
set MC_C_TOTAL101 0
set MC_D_TOTAL101 0
set VS_C_TOTAL101 0
set VS_D_TOTAL101 0
set DS_C_TOTAL101 0
set DS_D_TOTAL101 0

set mclist105  ""
set vslist105  ""
set dslist105  ""
set MC_C_TOTAL105 0
set MC_D_TOTAL105 0
set VS_C_TOTAL105 0
set VS_D_TOTAL105 0
set DS_C_TOTAL105 0
set DS_D_TOTAL105 0

set mclist107  ""
set vslist107  ""
set dslist107  ""
set MC_C_TOTAL107 0
set MC_D_TOTAL107 0
set VS_C_TOTAL107 0
set VS_D_TOTAL107 0
set DS_C_TOTAL107 0
set DS_D_TOTAL107 0

set mclist440339  ""
set vslist440339  ""
set dslist440339  ""
set MC_C_TOTAL440339 0
set MC_D_TOTAL440339 0
set VS_C_TOTAL440339 0
set VS_D_TOTAL440339 0
set DS_C_TOTAL440339 0
set DS_D_TOTAL440339 0

set mclist112  ""
set vslist112  ""
set dslist112  ""
set MC_C_TOTAL112 0
set MC_D_TOTAL112 0
set VS_C_TOTAL112 0
set VS_D_TOTAL112 0
set DS_C_TOTAL112 0
set DS_D_TOTAL112 0

set mclist113  ""
set vslist113  ""
set dslist113  ""
set MC_C_TOTAL113 0
set MC_D_TOTAL113 0
set VS_C_TOTAL113 0
set VS_D_TOTAL113 0
set DS_C_TOTAL113 0
set DS_D_TOTAL113 0

set mclist114  ""
set vslist114  ""
set dslist114  ""
set MC_C_TOTAL114 0
set MC_D_TOTAL114 0
set VS_C_TOTAL114 0
set VS_D_TOTAL114 0
set DS_C_TOTAL114 0
set DS_D_TOTAL114 0

set mclist115  ""
set vslist115  ""
set dslist115  ""
set MC_C_TOTAL115 0
set MC_D_TOTAL115 0
set VS_C_TOTAL115 0
set VS_D_TOTAL115 0
set DS_C_TOTAL115 0
set DS_D_TOTAL115 0

set mclist116  ""
set vslist116  ""
set dslist116  ""
set MC_C_TOTAL116 0
set MC_D_TOTAL116 0
set VS_C_TOTAL116 0
set VS_D_TOTAL116 0
set DS_C_TOTAL116 0
set DS_D_TOTAL116 0

      set query_stringM3 " SELECT replace(ind.AMT_TRANS, ',', '')/100 as AMOUNT,
                                    ind.SEC_DEST_INST_ID as INSTID,
                                    substr(ind.merch_id,1,6) as ISONO,
                                    ind.TRANS_SEQ_NBR,
                                    ind.pan as ACCT,
                                    ind.activity_dt as I_DATE,
                                    ind.card_scheme,
                                    trim(to_char(ind.arn,'99999999999999999999999')) as ARN,
                                    tid.TID_SETTL_METHOD as INDICATOR,
                                    tid.DESCRIPTION as TRAN_CODE
                             FROM in_draft_main ind, tid
                             WHERE ind.tid = tid.tid
                                  AND ind.msg_text_block like '%JPREJECT%'
                                  AND ind.card_scheme in ('04', '05', '08')
                                  AND ind.activity_dt like '$yesterday%'                                 
                                  AND ind.in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$yesterday%')
                                  AND ind.SEC_DEST_INST_ID in ($value)"
      puts "query_stringM3: $query_stringM3"
      orasql $fetch_cursorM3 $query_stringM3
      while {[orafetch $fetch_cursorM3 -dataarray inr -indexbyname ] != 1403 } {
            set TRANO $inr(TRANS_SEQ_NBR)
            set ISO $inr(ISONO)
            if {$inr(CARD_SCHEME) == "05"} {
                if {$inr(INSTID) == "105"} {
                    lappend mclist105 $TRANO
                } elseif {$inr(INSTID) == "101"} {
                    lappend mclist101 $TRANO
                }  elseif {$inr(INSTID) == "107"} {
                    lappend mclist107 $TRANO
                }  elseif {$inr(INSTID) == "112"} {
                    lappend mclist112 $TRANO
                }  elseif {$inr(INSTID) == "113"} {
                    lappend mclist113 $TRANO
                }  elseif {$inr(INSTID) == "114"} {
                    lappend mclist114 $TRANO
                }  elseif {$inr(INSTID) == "115"} {
                    lappend mclist115 $TRANO
                }  elseif {$inr(INSTID) == "116"} {
                    lappend mclist116 $TRANO
                }  elseif {$inr(INSTID) == "106"} {
                     if {$ISO == "440339"} {
                       lappend mclist440339 $TRANO
                     }
                }                                  
            } elseif {$inr(CARD_SCHEME) == "04"} {
                if {$inr(INSTID) == "105"} {
                    lappend vslist105 $TRANO
                } elseif {$inr(INSTID) == "101"} {
                    lappend vslist101 $TRANO
                }  elseif {$inr(INSTID) == "107"} {
                    lappend vslist107 $TRANO
                }  elseif {$inr(INSTID) == "112"} {
                    lappend vslist112 $TRANO
                }  elseif {$inr(INSTID) == "113"} {
                    lappend vslist113 $TRANO
                }  elseif {$inr(INSTID) == "114"} {
                    lappend vslist114 $TRANO
                }  elseif {$inr(INSTID) == "115"} {
                    lappend vslist115 $TRANO
                }  elseif {$inr(INSTID) == "116"} {
                    lappend vslist116 $TRANO
                }  elseif {$inr(INSTID) == "106"} {
                     if {$ISO == "440339"} {
                       lappend vslist440339 $TRANO
                     }
                }  
            }
              set ACCOUNT_NBR($TRANO) [string replace $inr(ACCT) 5 13 xxxxxxxxx ]
              set DATE($TRANO)      $inr(I_DATE)
              set REASON($TRANO)    "NA"
              set AMOUNT($TRANO)    $inr(AMOUNT)
              set REF_NO($TRANO)    $inr(ARN)
              set TRAN_CODE($TRANO) $inr(TRAN_CODE)
              set INDICATOR($TRANO) $inr(INDICATOR)
      }        
#105
if {[file exists $cur_file_name_105_in]} {
      puts $cur_file_105_in "JETPAY, 105"
      puts $cur_file_105_in "ISO INCOMING RETURN REPORT"
      puts $cur_file_105_in "REPORT DATE:  , $today "
      puts $cur_file_105_in "       "
      puts $cur_file_105_in "       "
      puts $cur_file_105_in "       "
      puts $cur_file_105_in "PLAN TYPE: ,MASTER CARD "
      puts $cur_file_105_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      
      foreach tno $mclist105 {
            if {$AMOUNT($tno) != "0"} {
                puts $cur_file_105_in " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL105 [expr $MC_C_TOTAL105 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL105 [expr $MC_D_TOTAL105 + $AMOUNT($tno)]            
                  }
            }
      }
      puts $cur_file_105_in "   "
      puts $cur_file_105_in "TOTAL"
      puts $cur_file_105_in "   "
      puts $cur_file_105_in " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL105 "
      puts $cur_file_105_in " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL105 " 
      puts $cur_file_105_in "  "
      puts $cur_file_105_in "PLAN TYPE: ,VISA"
      puts $cur_file_105_in "   "
      puts $cur_file_105_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      
      foreach tno $vslist105 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file_105_in " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL105 [expr $VS_C_TOTAL105 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL105 [expr $VS_D_TOTAL105 + $AMOUNT($tno)]            
                  } 
            }
      }
      puts $cur_file_105_in "   "
      puts $cur_file_105_in "TOTAL"
      puts $cur_file_105_in "   "
      puts $cur_file_105_in " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL105 "
      puts $cur_file_105_in " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL105 "

      close $cur_file_105_in
} else {
      puts "no incoming reject file created for inst 105"
}
#101
if {[file exists $cur_file_name2]} {
      puts $cur_file2 "JETPAY, 101"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "       "      
      puts $cur_file2 "       "
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "      
      puts $cur_file2 "       "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist101 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL101 [expr $MC_C_TOTAL101 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL101 [expr $MC_D_TOTAL101 + $AMOUNT($tno)]            
                  }      
            }
      }      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"      
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL101 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL101 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"      
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist101 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL101 [expr $VS_C_TOTAL101 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL101 [expr $VS_D_TOTAL101 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL101 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL101 "
#107
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 107"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist107 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL107 [expr $MC_C_TOTAL107 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL107 [expr $MC_D_TOTAL107 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL107 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL107 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist107 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL107 [expr $VS_C_TOTAL107 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL107 [expr $VS_D_TOTAL107 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL107 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL107 "
#112
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 112"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist112 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL112 [expr $MC_C_TOTAL112 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL112 [expr $MC_D_TOTAL112 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL112 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL112 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist112 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL112 [expr $VS_C_TOTAL112 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL112 [expr $VS_D_TOTAL112 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL112 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL112 "

#113
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 113"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist113 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL113 [expr $MC_C_TOTAL113 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL113 [expr $MC_D_TOTAL113 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL113 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL113 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist113 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL113 [expr $VS_C_TOTAL113 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL113 [expr $VS_D_TOTAL113 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL113 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL113 "

#114
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 114"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist114 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL114 [expr $MC_C_TOTAL114 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL114 [expr $MC_D_TOTAL114 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL114 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL114 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist114 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL114 [expr $VS_C_TOTAL114 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL114 [expr $VS_D_TOTAL114 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL114 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL114 "

#115
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 115"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist115 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL115 [expr $MC_C_TOTAL115 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL115 [expr $MC_D_TOTAL115 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL115 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL115 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist115 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL115 [expr $VS_C_TOTAL115 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL115 [expr $VS_D_TOTAL115 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL115 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL115 "

#116
      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, 116"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "     "
      puts $cur_file2 "     "  
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist116 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL116 [expr $MC_C_TOTAL116 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL116 [expr $MC_D_TOTAL116 + $AMOUNT($tno)]            
                  }      
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL116 "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL116 "

      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist116 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL116 [expr $VS_C_TOTAL116 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL116 [expr $VS_D_TOTAL116 + $AMOUNT($tno)]            
                  }      
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL116 "
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL116 "

      puts $cur_file2 "           "
      puts $cur_file2 "           "
      puts $cur_file2 "JETPAY, ROLLUP"
      puts $cur_file2 "ISO INCOMING RETURN REPORT"
      puts $cur_file2 "REPORT DATE:  , $today "
      puts $cur_file2 "       "      
      puts $cur_file2 "       "
      puts $cur_file2 "PLAN TYPE: ,MASTER CARD "     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      foreach tno $mclist101 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"     
            }
      }      
      foreach tno $mclist107 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      foreach tno $mclist112 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      foreach tno $mclist113 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      foreach tno $mclist114 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      foreach tno $mclist115 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      foreach tno $mclist116 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"    
            }
      }     
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $[expr $MC_D_TOTAL101 + $MC_D_TOTAL107 + $MC_D_TOTAL112 + $MC_D_TOTAL113 + $MC_D_TOTAL114 + $MC_D_TOTAL115 + $MC_D_TOTAL116] "
      puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $[expr $MC_C_TOTAL101 +$MC_C_TOTAL107 +$MC_C_TOTAL112 +$MC_C_TOTAL113 +$MC_C_TOTAL114 +$MC_C_TOTAL115 +$MC_C_TOTAL116] "
      puts $cur_file2 "  "
      puts $cur_file2 "PLAN TYPE: ,VISA"     
      puts $cur_file2 "     "
      puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

      foreach tno $vslist101 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist107 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist112 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist113 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist114 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist115 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      foreach tno $vslist116 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file2 " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
            }
      }
      
      puts $cur_file2 "     "
      puts $cur_file2 "TOTAL"     
      puts $cur_file2 "     "
      puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $[expr $VS_D_TOTAL101 + $VS_D_TOTAL107 + $VS_D_TOTAL112 + $VS_D_TOTAL113 + $VS_D_TOTAL114 + $VS_D_TOTAL115 + $VS_D_TOTAL116]"
      puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $[expr $VS_C_TOTAL101 + $VS_C_TOTAL107 + $VS_C_TOTAL112 + $VS_C_TOTAL113 + $VS_C_TOTAL114 + $VS_C_TOTAL115 + $VS_C_TOTAL116]"

      close $cur_file2
} else {
      puts "no incoming reject file created for Merrick"
}
#106
if {[file exists $cur_file_name_106_in]} {
      puts $cur_file_106_in "ISO, 106"
      puts $cur_file_106_in "ISO NAME: REVTRAK"
      puts $cur_file_106_in "ISO INCOMING RETURN REPORT"
      puts $cur_file_106_in "REPORT DATE:  , $today "
      puts $cur_file_106_in "       "
      puts $cur_file_106_in "       "
      puts $cur_file_106_in "       "
      puts $cur_file_106_in "PLAN TYPE: ,MASTER CARD "
      puts $cur_file_106_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      
      foreach tno $mclist440339 {
            if {$AMOUNT($tno) != "0"} {
                puts $cur_file_106_in " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set MC_C_TOTAL440339 [expr $MC_C_TOTAL440339 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set MC_D_TOTAL440339 [expr $MC_D_TOTAL440339 + $AMOUNT($tno)]            
                  }
            }
      }
      puts $cur_file_106_in "   "
      puts $cur_file_106_in "TOTAL"
      puts $cur_file_106_in "   "
      puts $cur_file_106_in " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL440339 "
      puts $cur_file_106_in " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL440339 " 
      puts $cur_file_106_in "  "
      puts $cur_file_106_in "PLAN TYPE: ,VISA"
      puts $cur_file_106_in "   "
      puts $cur_file_106_in "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
      
      foreach tno $vslist440339 {
            if {$AMOUNT($tno) != "0"} {
                  puts $cur_file_106_in " $ACCOUNT_NBR($tno),'$TRAN_CODE($tno),'$$AMOUNT($tno),'$REF_NO($tno),'$DATE($tno),'$REASON($tno), $INDICATOR($tno)"
                  if {$INDICATOR($tno) == "C"} {
                     set VS_C_TOTAL440339 [expr $VS_C_TOTAL440339 + $AMOUNT($tno)]
                  } elseif {$INDICATOR($tno) == "D"} {
                     set VS_D_TOTAL440339 [expr $VS_D_TOTAL440339 + $AMOUNT($tno)]            
                  } 
            }
      }
      puts $cur_file_106_in "   "
      puts $cur_file_106_in "TOTAL"
      puts $cur_file_106_in "   "
      puts $cur_file_106_in " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL440339 "
      puts $cur_file_106_in " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL440339 "

      close $cur_file_106_in
} else {
      puts "no incoming reject file created for inst 106"
}
if {$mode == "TEST"} {
      if {$inst_id == "ALL"} {
            exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
            exec uuencode $cur_file_name2 $file_name2 | mailx -r clearing@jetpay.com -s $file_name2 clearing@jetpay.com
            exec uuencode $cur_file_name_105 $file_name_105 | mailx -r clearing@jetpay.com -s $file_name_105 clearing@jetpay.com
            exec uuencode $cur_file_name_105_in $file_name_l05_in | mailx -r clearing@jetpay.com -s $file_name_l05_in clearing@jetpay.com  
            exec uuencode $cur_file_name_106 $file_name_106 | mailx -r clearing@jetpay.com -s $file_name_106 clearing@jetpay.com
            exec uuencode $cur_file_name_106_in $file_name_l06_in | mailx -r clearing@jetpay.com -s $file_name_l06_in clearing@jetpay.com                
      } elseif {$inst_id == "105"} {
            exec uuencode $cur_file_name_105 $file_name_105 | mailx -r clearing@jetpay.com -s $file_name_105 clearing@jetpay.com
            exec uuencode $cur_file_name_105_in $file_name_l05_in | mailx -r clearing@jetpay.com -s $file_name_l05_in clearing@jetpay.com     
      } elseif  {$inst_id == "ROLLUP"} {
            exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
            exec uuencode $cur_file_name2 $file_name2 | mailx -r clearing@jetpay.com -s $file_name2 clearing@jetpay.com
      } elseif {$inst_id == "106"} { 
            exec uuencode $cur_file_name_106 $file_name_106 | mailx -r clearing@jetpay.com -s $file_name_106 clearing@jetpay.com
            exec uuencode $cur_file_name_106_in $file_name_l06_in | mailx -r clearing@jetpay.com -s $file_name_l06_in clearing@jetpay.com           
      }
} elseif {$mode == "PROD"} {
      if {$inst_id == "ALL"} {
            exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
            exec uuencode $cur_file_name2 $file_name2 | mailx -r clearing@jetpay.com -s $file_name2 clearing@jetpay.com  
            exec uuencode $cur_file_name_105 $file_name_105 | mailx -r clearing@jetpay.com -s $file_name_105 clearing@jetpay.com
            exec uuencode $cur_file_name_105_in $file_name_l05_in | mailx -r clearing@jetpay.com -s $file_name_l05_in clearing@jetpay.com
            exec uuencode $cur_file_name_106 $file_name_106 | mailx -r clearing@jetpay.com -s $file_name_106 clearing@jetpay.com
            exec uuencode $cur_file_name_106_in $file_name_l06_in | mailx -r clearing@jetpay.com -s $file_name_l06_in clearing@jetpay.com
      } elseif {$inst_id == "105"} {
            exec uuencode $cur_file_name_105 $file_name_105 | mailx -r clearing@jetpay.com -s $file_name_105 clearing@jetpay.com
            exec uuencode $cur_file_name_105_in $file_name_l05_in | mailx -r clearing@jetpay.com -s $file_name_l05_in clearing@jetpay.com
      } elseif  {$inst_id == "ROLLUP"} {
            exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
            exec uuencode $cur_file_name2 $file_name2 | mailx -r clearing@jetpay.com -s $file_name2 clearing@jetpay.com  
      } elseif {$inst_id == "106"} {
            exec uuencode $cur_file_name_106 $file_name_106 | mailx -r clearing@jetpay.com -s $file_name_106 clearing@jetpay.com
            exec uuencode $cur_file_name_106_in $file_name_l06_in | mailx -r clearing@jetpay.com -s $file_name_l06_in clearing@jetpay.com
      }
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


