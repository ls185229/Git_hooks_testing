#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
#
#=========================== Modification History ==============================
# Version 0.02 Sunny Yang 04-06-2010
# ------- Correct wrong heading on Merrick's ARI report
#
# Version 0.01 Sunny Yang 11-09-2009
# ------- Generate ARI reports for both Merrick and IPS
#
# Version 0.00 Sunny Yang 08-10-2009
# Based on the Discover "Acquirer Report Interface R9.1.pdf"
#
#===============================================================================
puts "BEGIN acquirer_report_ari.tcl File"
package require Oratcl
#==========================   Environment variables  ==========================

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

set sysinfo "System: $box\n Location: /clearing/filemgr/RETURN_FILES/DISCOVER/DNLOAD \n\n"

##==============================================================================
package require Oratcl
##==============================================================================
#set mode "TEST"
set mode "PROD"
    if {$mode == "TEST"} {
        set inpath      "/clearing/filemgr/RETURN_FILES/DISCOVER/DNLOAD/"
        set rptpath     "./UPLOAD/"  
        set rptsusqpath "./UPLOAD/"
        set rptipspath  "./UPLOAD/"
        set aipspath    "./ARCHIVE/"    
	set rptpath106  "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/"
    } elseif {$mode == "PROD"} {
        set inpath      "/clearing/filemgr/RETURN_FILES/DISCOVER/DNLOAD/"
        set rptpath     "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/"
        set rptsusqpath     "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/"
        set rptipspath   "/clearing/filemgr/PTI/UPLOAD/"
        set aipspath     "/clearing/filemgr/PTI/ARCHIVE/"
	set rptpath106  "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/"
    }
    set CUR_J     [string range [clock format [ clock scan "-0 day " ] -format "%y%j"] 1 4]
    set rpt_date  [string toupper [clock format [ clock scan "-0 day " ] -format %b-%d-%y ]]
    set proc_date [string toupper [clock format [ clock scan "-0 day " ] -format %b-%d-%y ]]
    set any_day   [clock format [ clock scan "-0 day" ] -format %Y%m%d ]
    set fname     "INDS.NERSARI8.$any_day"  ;#disc_confirmation
    set fname     "$inpath$fname"
    eval [list exec ls -l] [glob $fname*] > $fname.txt
    set txtf "$fname.txt"
    set infile  [open $fname.txt r]
    set infile_line [set inf_line [gets $infile]]

    if {$infile_line != ""} {
        if {$mode == "TEST"} {
            #set ari "INDS.NERSARI8.20091105091030.000"
            #set ari "INDS.NERSARI8.20091103091021.000"
            #set ari "INDS.NERSARI8.20091106091020.000"
            # set ari "INDS.NERSARI8.20091107091021.000"
            # set ari "INDS.NERSARI8.20091108091020.000"
             set ari "INDS.NERSARI8.20091108091020.000"
        } elseif {$mode == "PROD"} {
            set ari [string range $infile_line 101 end]
        }
    }
    close $infile
    set acqners   "$inpath$ari"
    set timestamp [string range $ari 14 27]
    set input     [open $acqners r]
    puts "input is $acqners"
    set file_name       "ROLLUP.DISC.ARI.REPORT.$timestamp.csv"
    set file_name_ips   "IPS.DISC.ARI.REPORT.$timestamp.csv"
    set file_name_susq   "105.DISC.ARI.REPORT.$timestamp.csv"
    set file_name_rv       "106.REVTRAK.DISC.ARI.REPORT.$timestamp.csv"
    set file_name_md       "117.MERIDIAN.DISC.ARI.REPORT.$timestamp.csv"
    set cur_file_name   "$rptpath$file_name"
    set cur_file_name_ips   "$rptipspath$file_name_ips"
    set cur_file_name_susq   "$rptsusqpath$file_name_susq"
    set cur_file_name_rv   "$rptpath106$file_name_rv"
    set cur_file_name_md   "$rptpath106$file_name_md"
    set cur_line       [set orig_line [gets $input] ]
    set cur_file       [open $cur_file_name w]
    set cur_file_ips   [open $cur_file_name_ips w]
    set cur_file_susq   [open $cur_file_name_susq w]
    set cur_file_rv       [open $cur_file_name_rv w]
    set cur_file_md       [open $cur_file_name_md w]
    
    proc cobp {value} {
      return [string map { \{ 0 A 1 B 2 C 3 D 4 E 5 F 6 G 7 H 8 I 9} $value]
    }

    proc cobn {value} {
       return [string map { \} 0 J 1 K 2 L 3 M 4 N 5 O 6 P 7 Q 8 R 9} $value]
    }
    set netamt 0
    set netcnt 0
    set over  1
    set stop  ""
    puts  $cur_file "DISCOVER NETWORK"
    puts  $cur_file "ACQUIRER DAILY SUMMARY REPORT"
    puts  $cur_file " "
    puts  $cur_file "PROGRAM NAME:,NERSARI8"
    puts  $cur_file "SYSTEM DATE:,$rpt_date"

    puts  $cur_file_ips "DISCOVER NETWORK"
    puts  $cur_file_ips "ACQUIRER DAILY SUMMARY REPORT"
    puts  $cur_file_ips " "
    puts  $cur_file_ips "PROGRAM NAME:,NERSARI8"
    puts  $cur_file_ips "SYSTEM DATE:,$rpt_date"

    puts  $cur_file_susq "DISCOVER NETWORK"
    puts  $cur_file_susq "ACQUIRER DAILY SUMMARY REPORT"
    puts  $cur_file_susq " "
    puts  $cur_file_susq "PROGRAM NAME:,NERSARI8"
    puts  $cur_file_susq "SYSTEM DATE:,$rpt_date"

    puts  $cur_file_rv "DISCOVER NETWORK"
    puts  $cur_file_rv "ACQUIRER DAILY SUMMARY REPORT"
    puts  $cur_file_rv " "
    puts  $cur_file_rv "PROGRAM NAME:,NERSARI8"
    puts  $cur_file_rv "SYSTEM DATE:,$rpt_date"


    puts  $cur_file_md "DISCOVER NETWORK"
    puts  $cur_file_md "ACQUIRER DAILY SUMMARY REPORT"
    puts  $cur_file_md " "
    puts  $cur_file_md "PROGRAM NAME:,NERSARI8"
    puts  $cur_file_md "SYSTEM DATE:,$rpt_date"

    
    if {[string range $cur_line 0 0] == "1" } {
          set H_RECORD_TYPE  [string range $cur_line 0 0]
          set ACT_END_DATE   [string range $cur_line 1 8]
          set MAIL_BOX       [string range $cur_line 9 16]        
          set ACT_END_DATE   [string toupper [clock format [ clock scan "$ACT_END_DATE -0 day " ] -format %b-%d-%y ]]
          puts  $cur_file "PROCESSING DATE:,$ACT_END_DATE"             
          puts $cur_file " "
          puts $cur_file " "
          
          puts $cur_file_ips "PROCESSING DATE:,$ACT_END_DATE"             
          puts $cur_file_ips " "
          puts $cur_file_ips " "
          
          puts $cur_file_susq "PROCESSING DATE:,$ACT_END_DATE"             
          puts $cur_file_susq " "
          puts $cur_file_susq " " 
    }
     set cur_line   [set orig_line [gets $input] ]
     while {[string range $cur_line 0 0] != "9"} {
	### adding this as a failsafe to prevent endless loops
	### using the flags that are built into the script for ending the loop
	    if { [eof $input] } {
		set stop "N"
		set over 2"
	    }
            if {[string range $cur_line 0 0] == "2"} {
                set RECORD_TYPE        [string range $cur_line 0 0]
                set ACT_END_DATE       [string range $cur_line 1 8]
                set MAIL_BOX           [string range $cur_line 9 16]
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                set VERSION_IND        [string range $cur_line 68 72]
                if {[string trimleft [string range $cur_line 17 27] 0] == "620254"} {
                    puts $cur_file_ips " "
                    puts $cur_file_ips " "
                    puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                    puts $cur_file_ips " "
                    puts $cur_file_ips " "
                    puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {                             
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "650343"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357" 
											|| [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
											|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
											|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "650434"} {
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file_rv "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "650431"} {
                                    puts $cur_file_md " "
                                    puts $cur_file_md " "
                                    puts $cur_file_md "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file_md "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                    puts $cur_file_md " "
                                    puts $cur_file_md " "
                                    puts $cur_file_md ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file_ips "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file_ips "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file_ips "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file_ips "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file_ips "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file_ips "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file_ips " "
                               puts $cur_file_ips " "
                               puts $cur_file_ips "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file_ips " "
                               puts $cur_file_ips " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }
                
                }
set stop ""                
                #===MERRICK 101=====================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "620297"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] 
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                             if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }                       
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357"
										 || [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										 || [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										 || [string trimleft $F_RECIPIENT_ID 0] == "620268"} {
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file " "
                               puts $cur_file " "
                               puts $cur_file "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file " "
                               puts $cur_file " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"                            
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }              
                } 
                #===============================================================
set stop ""
 #===MERRICK 107=================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650357"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] ;# try
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                        if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                        }                        
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357" 
										|| [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {} {
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file " "
                               puts $cur_file " "
                               puts $cur_file "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file " "
                               puts $cur_file " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }
                } 
                #===============================================================
set stop ""
                #===MERRICK 112=====================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650343"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] 
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                             if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }                       
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357"
                                || [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {} {
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file " "
                               puts $cur_file " "
                               puts $cur_file "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file " "
                               puts $cur_file " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"                            
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }              
                } 
                #===============================================================
set stop ""
               
  #===MERRICK 113=====================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650344"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                    puts $cur_file " "
                    puts $cur_file " "
                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] 
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                             if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }                       
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq " "
                                   puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips " "
                                   puts $cur_file_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif  {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {} {
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                                    puts $cur_file " "
                                    puts $cur_file " "
                                    puts $cur_file ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file " "
                               puts $cur_file " "
                               puts $cur_file "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file " "
                               puts $cur_file " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"                            
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }              
                } 
                #===============================================================
set stop ""              
               
               
               
                #===MERIDIAN 117 461084 =================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650431"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file_md " "
                    puts $cur_file_md " "
                    puts $cur_file_md "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file_md "ACQUIRER NAME,$F_RECIPIENT_NAME"
                    puts $cur_file_md " "
                    puts $cur_file_md " "
                    puts $cur_file_md ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] ;# try
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file_md " "
                               puts $cur_file_md " "
                               puts $cur_file_md "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file_md " "
                               puts $cur_file_md " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }

                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                        if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O"||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file_md "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file_md "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file_md "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file_md "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file_md "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file_md "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                        } 
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_md_susq " "
                                   puts $cur_file_md_susq " "
                                   puts $cur_file_md_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_md_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                   puts $cur_file_md_susq " "
                                   puts $cur_file_md_susq " "
                                   puts $cur_file_md_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_md_ips " "
                                   puts $cur_file_md_ips " "
                                   puts $cur_file_md_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_md_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                   puts $cur_file_md_ips " "
                                   puts $cur_file_md_ips " "
                                   puts $cur_file_md_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif  {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650431"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {} {
                                    puts $cur_file_md " "
                                    puts $cur_file_md " "
                                    puts $cur_file_md "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file_md "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                    puts $cur_file_md " "
                                    puts $cur_file_md " "
                                    puts $cur_file_md ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O"||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file_md "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file_md "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file_md "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file_md "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file_md "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file_md "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file_md " "
                               puts $cur_file_md " "
                               puts $cur_file_md "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file_md " "
                               puts $cur_file_md " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }
                }
                #===============================================================
set stop ""
                #===MERIDIAN 106 440339 =================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650434"} {
                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                    puts $cur_file_rv " "
                    puts $cur_file_rv " "
                    puts $cur_file_rv "ACQUIRER ID:,$F_RECIPIENT_ID"
                    puts $cur_file_rv "ACQUIRER NAME,$F_RECIPIENT_NAME"
                    puts $cur_file_rv " "
                    puts $cur_file_rv " "
                    puts $cur_file_rv ",Card Transaction Count,Card Transaction Volume"
                    set cur_line   [set orig_line [gets $input] ] ;# try
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file_rv " "
                               puts $cur_file_rv " "
                               puts $cur_file_rv "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file_rv " "
                               puts $cur_file_rv " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }
                    while {[string range $cur_line 0 0] != "8" && $stop != "Y" && $over != "2"} {
                        set stop "N"
                        if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O"||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file_rv "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file_rv "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file_rv "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file_rv "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file_rv "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file_rv "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                        }
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 0] == "2"} {
                                set RECORD_TYPE        [string range $cur_line 0 0]
                                set ACT_END_DATE       [string range $cur_line 1 8]
                                set MAIL_BOX           [string range $cur_line 9 16]
                                set F_RECIPIENT_ID     [string range $cur_line 17 27]
                                set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                                set VERSION_IND        [string range $cur_line 68 72]
                                if {[string trimleft $F_RECIPIENT_ID 0] == "650381"} {
                                   puts $cur_file_rv_susq " "
                                   puts $cur_file_rv_susq " "
                                   puts $cur_file_rv_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_rv_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                   puts $cur_file_rv_susq " "
                                   puts $cur_file_rv_susq " "
                                   puts $cur_file_rv_susq ",Card Transaction Count,Card Transaction Volume"
                                } elseif {[string trimleft $F_RECIPIENT_ID 0] == "620254"} {
                                   puts $cur_file_rv_ips " "
                                   puts $cur_file_rv_ips " "
                                   puts $cur_file_rv_ips "ACQUIRER ID:,$F_RECIPIENT_ID"
                                   puts $cur_file_rv_ips "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                   puts $cur_file_rv_ips " "
                                   puts $cur_file_rv_ips " "
                                   puts $cur_file_rv_ips ",Card Transaction Count,Card Transaction Volume"
                                } elseif  {[string trimleft $F_RECIPIENT_ID 0] == "620297" || [string trimleft $F_RECIPIENT_ID 0] == "650357"
									 	|| [string trimleft $F_RECIPIENT_ID 0] == "650343" || [string trimleft $F_RECIPIENT_ID 0] == "650344"
										|| [string trimleft $F_RECIPIENT_ID 0] == "650347" || [string trimleft $F_RECIPIENT_ID 0] == "650351"
										|| [string trimleft $F_RECIPIENT_ID 0] == "620268"} {} {
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv "ACQUIRER ID:,$F_RECIPIENT_ID"
                                    puts $cur_file_rv "ACQUIRER NAME,$F_RECIPIENT_NAME"
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv " "
                                    puts $cur_file_rv ",Card Transaction Count,Card Transaction Volume"
                                }
                            }
                            if {[string range $cur_line 0 3] == "5011"} {
                               set RECORD_TYPE            [string range $cur_line 0 0]
                               set SECTION_CD          [string range $cur_line 1 2]
                               set SUB_SEC_CD          [string range $cur_line 3 3]
                               set ACTIVITY_TYPE       [string range $cur_line 4 33]
                               set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                               if {[string length $ACTIVITY_CNT] == "0"} {
                                    set ACTIVITY_CNT 0
                               }
                               set ACTIVITY_AMT        [string range $cur_line 45 59]
                               set PNIND               [string range $cur_line 59 59]
                               puts "PNIND: $PNIND"
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O"||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               }
                               if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                   puts $cur_file_rv "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                   puts $cur_file_rv "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                   puts $cur_file_rv "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                   puts $cur_file_rv "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                   puts $cur_file_rv "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                   puts $cur_file_rv "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                   set netamt [expr $netamt + $ACTIVITY_AMT]
                                   set netcnt [expr $netcnt + $ACTIVITY_CNT]
                               }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                               puts $cur_file_rv " "
                               puts $cur_file_rv " "
                               puts $cur_file_rv "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                               puts $cur_file_rv " "
                               puts $cur_file_rv " "
                               set cur_line   [set orig_line [gets $input] ]
                               set stop "Y"
                               set netcnt 0
                               set netamt 0
                            }
                           if {[string range $cur_line 0 0] == "9"} {
                              set stop "Y"
                              set over "2"
                           }
                        }
                    }
                }
                #===============================================================
set stop ""
               
                #===105========================================================
                if {[string trimleft [string range $cur_line 17 27] 0] == "650381"} {
                    if {[string range $cur_line 0 0] != "2"} {
                       set cur_line   [set orig_line [gets $input] ] 
                    }
                    if {[string range $cur_line 0 0] == "2"} {
                        set RECORD_TYPE        [string range $cur_line 0 0]
                        set ACT_END_DATE       [string range $cur_line 1 8]
                        set MAIL_BOX           [string range $cur_line 9 16]
                        set F_RECIPIENT_ID     [string range $cur_line 17 27]
                        set F_RECIPIENT_NAME   [string range $cur_line 28 67]
                        set VERSION_IND        [string range $cur_line 68 72]
                                
                        puts $cur_file_susq " "
                        puts $cur_file_susq " "
                        puts $cur_file_susq "ACQUIRER ID:,$F_RECIPIENT_ID"
                        puts $cur_file_susq "ACQUIRER NAME,$F_RECIPIENT_NAME"   
                        puts $cur_file_susq " "
                        puts $cur_file_susq " "
                        puts $cur_file_susq ",Card Transaction Count,Card Transaction Volume"
                        set cur_line   [set orig_line [gets $input] ]
                    }
                    set over  1
                    while {[string range $cur_line 0 0] != "8" && $over == "1" && [string range $cur_line 0 0] != "2"} {
                        if {[string range $cur_line 0 3] == "5011"} {
                                 set RECORD_TYPE            [string range $cur_line 0 0]
                                 set SECTION_CD          [string range $cur_line 1 2]
                                 set SUB_SEC_CD          [string range $cur_line 3 3]
                                 set ACTIVITY_TYPE       [string range $cur_line 4 33]
                                 set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                                 if {[string length $ACTIVITY_CNT] == "0"} {
                                      set ACTIVITY_CNT 0
                                 }
                                 set ACTIVITY_AMT        [string range $cur_line 45 59]
                                 puts "PNIND: $PNIND"
                                 #set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                               set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               } 
                                 if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                     puts $cur_file_susq "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                     puts $cur_file_susq "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                     puts $cur_file_susq "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                     puts $cur_file_susq "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                     puts $cur_file_susq "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                     puts $cur_file_susq "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 }
                            }
                        set stop "N"
                        while {$stop == "N"} {
                            set cur_line   [set orig_line [gets $input] ]
                            if {[string range $cur_line 0 3] == "5011"} {
                                 set RECORD_TYPE            [string range $cur_line 0 0]
                                 set SECTION_CD          [string range $cur_line 1 2]
                                 set SUB_SEC_CD          [string range $cur_line 3 3]
                                 set ACTIVITY_TYPE       [string range $cur_line 4 33]
                                 set ACTIVITY_CNT        [string trimleft [string range $cur_line 34 44] 0]
                                 if {[string length $ACTIVITY_CNT] == "0"} {
                                      set ACTIVITY_CNT 0
                                 }
                                 set ACTIVITY_AMT        [string range $cur_line 45 59]
                                 set PNIND               [string range $cur_line 59 59]
                               if {$PNIND == "\{" || $PNIND == "A" ||$PNIND == "B" ||$PNIND == "C" ||$PNIND == "D" ||$PNIND == "E" ||$PNIND == "F" ||$PNIND == "G" ||$PNIND == "H" ||$PNIND == "I" } {
                                   set ACTIVITY_AMT        [string trimleft [cobp $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/100.00]]
                               } elseif {$PNIND == "\}" || $PNIND == "J" ||$PNIND == "K" ||$PNIND == "L" ||$PNIND == "M" ||$PNIND == "N" ||$PNIND == "O" ||$PNIND == "P" ||$PNIND == "Q" ||$PNIND == "R" } {
                                   set ACTIVITY_AMT        [string trimleft [cobn $ACTIVITY_AMT] 0]
                                   set ACTIVITY_AMT        [format "%0.2f" [expr $ACTIVITY_AMT/-100.00]]
                               } 
                                 if {[string trimright $ACTIVITY_TYPE " "] == "CARD TRANSACTIONS"} {
                                     puts $cur_file_susq "Card Sales, $ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "DISPUTES"} {
                                     puts $cur_file_susq "Disputes,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER INTERCHANGE ASSESSED"} {
                                     puts $cur_file_susq "Acquirer Interchange,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER ASSESSMENTS"} {
                                     puts $cur_file_susq "Acquirer Assessments,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "ACQUIRER FEES"} {
                                     puts $cur_file_susq "Acquirer Fees,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 } elseif {[string trimright $ACTIVITY_TYPE " "] == "CORRECTIONS"} {
                                     puts $cur_file_susq "Miscellaneous,$ACTIVITY_CNT, $$ACTIVITY_AMT "
                                     set netamt [expr $netamt + $ACTIVITY_AMT]
                                     set netcnt [expr $netcnt + $ACTIVITY_CNT]
                                 }
                            }
                            if {[string range $cur_line 0 0] == "8"} {
                                 puts $cur_file_susq " "
                                 puts $cur_file_susq " "
                                 puts $cur_file_susq "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                                 puts $cur_file_susq " "
                                 puts $cur_file_susq " "
                                 set stop "Y"
                                 set netcnt 0
                                 set netamt 0
                                 set cur_line   [set orig_line [gets $input] ]
                            }
                            if {[string range $cur_line 0 0] == "9"} {
                                 set stop "Y"
                                 set over 2
                            }
                        }
                    }

                    if {[string range $cur_line 0 0] == "8"} {
                        puts $cur_file_susq " "
                        puts $cur_file_susq " "
                        puts $cur_file_susq "TOTAL NET SETTLEMENT, $netcnt,$$netamt"
                        puts $cur_file_susq " "
                        puts $cur_file_susq " "
                        set stop "Y"
                        set netcnt 0
                        set netamt 0
                        set cur_line   [set orig_line [gets $input] ]
		    }
                }                
            }
     }     
     
    
#===============================================================================
    close $cur_file
    close $cur_file_ips
    close $cur_file_susq 
    close $cur_file_rv
    close $cur_file_md

    if {$mode == "PROD"} {
        exec uuencode $cur_file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com
        exec uuencode $cur_file_name_ips $file_name_ips | mailx -r reports-clearing@jetpay.com -s $file_name_ips reports-clearing@jetpay.com
        exec uuencode $cur_file_name_susq $file_name_susq | mailx -r reports-clearing@jetpay.com -s $file_name_susq reports-clearing@jetpay.com
        exec uuencode $cur_file_name_rv $file_name_rv | mailx -r reports-clearing@jetpay.com -s $file_name_rv reports-clearing@jetpay.com
        exec uuencode $cur_file_name_md $file_name_md | mailx -r reports-clearing@jetpay.com -s $file_name_md reports-clearing@jetpay.com
		exec uuencode $cur_file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com
		exec uuencode $cur_file_name_ips $file_name_ips | mailx -r reports-clearing@jetpay.com -s $file_name_ips reports-clearing@jetpay.com
		exec uuencode $cur_file_name_susq $file_name_susq | mailx -r reports-clearing@jetpay.com -s $file_name_susq clearing@jetpay.com
		exec uuencode $cur_file_name_rv $file_name_rv | mailx -r reports-clearing@jetpay.com -s $file_name_rv reports-clearing@jetpay.com
		exec uuencode $cur_file_name_md $file_name_md | mailx -r reports-clearing@jetpay.com -s $file_name_md reports-clearing@jetpay.com

#        IPS files needs to be zipped and encrypted
        set arizip "$cur_file_name_ips.zip"
        set file_name_ips "$cur_file_name_ips"
        exec zip  $arizip  $file_name_ips
        exec gpg --no-secmem-warning --encrypt-files -r rdelfinado@integritypaymentsystems.com -r clearing@jetpay.com $arizip
        set arif "$arizip.gpg"
        exec mv  $arizip $aipspath
        exec rm  $file_name_ips
        exec mv $acqners /clearing/filemgr/RETURN_FILES/DISCOVER/ARCHIVE    
        exec rm $txtf
    } elseif {$mode == "TEST"} {
        exec uuencode $cur_file_name $file_name | mailx -r test-clearing@jetpay.com -s $file_name test-clearing@jetpay.com
        exec uuencode $cur_file_name_ips $file_name_ips | mailx -r test-clearing@jetpay.com -s $file_name_ips test-clearing@jetpay.com
        exec uuencode $cur_file_name_susq $file_name_susq | mailx -r test-clearing@jetpay.com -s $file_name_susq test-clearing@jetpay.com
        exec uuencode $cur_file_name_rv $file_name_rv | mailx -r test-clearing@jetpay.com -s $file_name_rv test-clearing@jetpay.com
        exec uuencode $cur_file_name_md $file_name_md | mailx -r test-clearing@jetpay.com -s $file_name_md test-clearing@jetpay.com
    }

#===============================================================================
#                                  THE  END
#===============================================================================

