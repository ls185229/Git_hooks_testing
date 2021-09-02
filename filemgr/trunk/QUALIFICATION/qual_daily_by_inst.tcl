#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#===========================      MODIFICATION HISTORY   =========================
#
# Version 1.00 Sunny Yang 10-07-2008
# ------------ Report sumary of Qualification for each institution
# ------------ including chargebacks
# ------------ When script run without argument, it will report on all 101 107 and
# ------------ 105 institutions. Also, it gives option run on individual institution
# ------------ on any given day.
#
#=================================================================================
#
#
#==============================  Environment Variables  ==========================

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(SEC_DB)
#set authdb $env(RPT_DB)
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

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#===================================================================================

package require Oratcl
    if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
      exec echo "Qual.INST.Daily.Report failed to run" | mailx -r clearing@jetpay.com -s "Qual.INST.Daily.Report" reports-clearing@jetpay.com
      exit
    }

set qual_cursor1 [oraopen $handler]
set qual_cursor2 [oraopen $handler]
set qual_cursor3 [oraopen $handler]
set qual_cursor4 [oraopen $handler]
set qual_cursor5 [oraopen $handler]
set qual_cursor6 [oraopen $handler]

    
    
    if {$argc == 2} {
          set inst_id   [lindex $argv 0]
          set rpt_date  [lindex $argv 1]
          set rpt_date  [string toupper [clock format [clock scan "$rpt_date -0 month"] -format %d-%b-%y]]
          set name_date [clock format [clock scan "$rpt_date -0 month"] -format %Y%m%d]
    } elseif {$argc == 1 } {
        if {[string length [lindex $argv 0]] == 3} {
            set inst_id    [lindex $argv 0]
            set rpt_date   [string toupper [clock format [clock scan " -0 day "] -format %d-%b-%y]]
            set name_date  [clock format [clock scan "-0 month"] -format %Y%m%d]
        } elseif {[string length [lindex $argv 0]] == 8 } {
            set inst_id    "ALL"
            set rpt_date   [lindex $argv 0]
            set rpt_date   [string toupper [clock format [clock scan "$rpt_date -0 month"] -format %d-%b-%y]]
            set name_date  [clock format [clock scan "$rpt_date -0 month"] -format %Y%m%d]
        }
    } else {
          puts "to run this report on certain date: put in yyyymmdd"
          puts "to run this report for certian inst: put in inst no (xxx)"
          set rpt_date  [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]
          set name_date [clock format [clock scan "-0 day"] -format %Y%m%d]
    }

proc inst_qual {inst} {
    global qual_cursor1 qual_cursor2 qual_cursor3 qual_cursor4 qual_cursor5 qual_cursor6
    global rpt_date name_date
    
    set qual_file_name "/clearing/filemgr/QUALIFICATION/INST_$inst/ARCHIVE/$inst.QUAL.$name_date.csv"
    set qual_file_name "$inst.QUAL.$name_date.csv"
    set qual_file      [open "$qual_file_name" w]
    
    puts $qual_file "Summary Qual report for institution $inst "
    puts $qual_file "Date: ,$rpt_date"
    puts $qual_file "MAS CODE, DESCRIPTION, CARD TYPE, COUNT, PRINCIPAL, FEE AMOUNT, SETTLE METHOD, ACT DATE, TID DETAIL"


    set sql_string "select t.MAS_CODE as MAS_CODE,
                           m.mas_desc as MAS_DESC, 
                           t.card_scheme as CARD_TYPE,
                           count(t.trans_seq_nbr) as TOTAL_CNT, 
                           sum(t.PRINCIPAL_AMT) as TOTAL_AMT, 
                           sum(t.AMT_ORIGINAL) as TOTAL_INT,  
                           decode(t.TID_SETTL_METHOD, 'C', 'Credit', 'D', 'Debit' ) as SETTLE_METHOD,
                           t.ACTIVITY_DATE_TIME as ACT_DATE,
                           decode(t.tid, '010004020000', 'Interchange Fee',
                                         '010004020005', 'Interchange Fee Refunded',
                                         '010004160000', 'Chargeback Fee',
                                         '010004160001', 'Reversal Chargeback Fee') as TID_DETAIL
                   from mas_trans_log t, mas_code m, acq_entity a 
                   where t.institution_id = '$inst' and 
                         substr(t.activity_date_time, 1, 9) = '$rpt_date' and  
                         T.tid in ('010004020000','010004020005', '010004160000', '010004160001') and 
                         m.mas_code=t.mas_code and
                         t.entity_id=a.entity_id and 
                         a.institution_id=t.institution_id 
                   group by t.card_scheme, t.TID_SETTL_METHOD, t.MAS_CODE, m.mas_desc,t.ACTIVITY_DATE_TIME,t.tid 
                   order by mas_code "
    puts $sql_string
    orasql $qual_cursor1 $sql_string
    while {[orafetch $qual_cursor1 -dataarray qual -indexbyname] != 1403} { 
            puts $qual_file "$qual(MAS_CODE), $qual(MAS_DESC),$qual(CARD_TYPE), $qual(TOTAL_CNT), $qual(TOTAL_AMT), $qual(TOTAL_INT), $qual(SETTLE_METHOD), $qual(ACT_DATE), $qual(TID_DETAIL) "
    }
    
    close $qual_file 
    catch {exec scp  $qual_file_name filemgr@dfw-adm-web-07:./IQR } resultiqr
    if  { [string range $resultiqr 0 5 ] == "Kernel"} {
        puts $resultiqr
    } else {
        puts "scp  $qual_file_name filemgr@dfw-adm-web-07:./IQR "
    } 
    exec uuencode $qual_file_name $qual_file_name | mailx -r clearing@jetpay.com -s $qual_file_name clearing@jetpay.com
}

if { $argc == 0 } {
  
    puts "INSTITUTION 101 "    
    inst_qual 101
    
    puts "INSTITUTION 105 "    
    inst_qual 105

    puts "INSTITUTION 107 "    
    inst_qual 107
    
} elseif { $argc == 1 } {
  
    if { $inst_id == "ALL" } {
        
          puts "INSTITUTION 101 "    
          inst_qual 101
          
          puts "INSTITUTION 105 "    
          inst_qual 105
      
         puts "INSTITUTION 107 "    
         inst_qual 107
    } else {
          puts "INSTITUTION $inst_id "  
          inst_qual $inst_id
      
          exit 0
    }
        
} else  {
  
    puts "INSTITUTION $inst_id "  
    inst_qual $inst_id

    exit 0
} 

oraclose $qual_cursor1
oraclose $qual_cursor2
oraclose $qual_cursor3
oraclose $qual_cursor4
oraclose $qual_cursor5
oraclose $qual_cursor6


