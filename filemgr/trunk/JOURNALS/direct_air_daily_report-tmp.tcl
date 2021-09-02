#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: direct_air_daily_report-tmp.tcl 4213 2017-06-26 14:36:17Z bjones $
#
##################################################################################
#
## **************   Modification History  ******************
## Version 1.00 broadus jones 06.15.2012
#
## USAGE: script name with no argument runs for current month cummulatively
##        one argument indicates single day
##        two arguments indicates date range
#
## Note:  currently only 0 argument method works (06.15.2012 12:01:15)
#
##################################################################################

#Environment veriables......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(ml2_alerts)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

set ml_list "reports-clearing@jetpay.com,senjeti@jetpay.com,dchester@jetpay.com"
#set ml_list "bjones@jetpay.com"

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

############################################################################################################


package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo "direct_air_daily_report.tcl failed to connect to $clrdb" | mailx -r mailfromlist -s "direct_air_daily_report.tcl" $mailtolist
  exit
}

set fetch_cursor [oraopen $handler]

set dt      [lindex $argv 0]
if {$dt == ""} {
    set dt [clock  format  [clock scan seconds] -format  %Y%m%d]
}
set dt_end  [lindex $argv 1]

set fdate       [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]
set date        [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]
set yhdate      [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set ymdate      [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set filedate    [clock  format  [clock scan "$dt -0 day"] -format %Y%m%d]
set rundate     [clock  format  [clock scan seconds] -format  %d-%b-%y]
set tstmp       [clock  format  [clock scan seconds] -format %M%H%S]

set CUR_JULIAN_DATEX [string range [clock format [clock scan "$rundate -0 day"] -format "%y%j"] 1 4]

set file_name "DIRECT-AIR.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv"

if {[file exists $file_name]} {
    set new_file_name "$file_name-reran.$rundate-$tstmp"
    exec mv $file_name ./INST_107/ARCHIVE/$new_file_name
}

if {[file exists ./INST_107/ARCHIVE/$file_name]} {
    set new_file_name "$file_name-reran.$rundate-$tstmp"
    exec mv ./INST_107/ARCHIVE/$file_name ./INST_107/ARCHIVE/$new_file_name
}
set cur_file [open "$file_name" w]

set sql1 "
        SELECT
            substr(mtl.posting_entity_id,1,15)          as Entity_id,
            ae.entity_dba_name                          as dba_name,
            to_char(gl_date,'DD-MON-YY')                as gl_date,
            to_char(pl.payment_proc_dt,'DD-MON-YY')
                                                        as payment_dt,
            COUNT(*)                                    AS Cnt,
            mtl.tid_settl_method                        AS Db_Cr,
            SUM(mtl.amt_billing *
                decode(mtl.tid_settl_method,'C',1,-1))  AS Amt_Billing,
            SUM(mtl.nbr_of_items)                       AS Items,
            mtl.tid                                     AS TID ,
            mtl.mas_code                                AS MAS_Code,
            substr(t.description,1,40)                  AS TID_Description,
            mc.mas_desc                                 AS MAS_Code_Description
        FROM mas_trans_log mtl
        JOIN acq_entity ae
          on  ae.institution_id = mtl.institution_id
          and ae.entity_id = mtl.posting_entity_id
        JOIN tid t
          ON t.tid = mtl.tid
        join mas_code mc
          on mc.mas_code = mtl.mas_code
        left outer join payment_log pl
          on  pl.institution_id = mtl.institution_id
          and pl.payment_seq_nbr = mtl.payment_seq_nbr
        WHERE
            mtl.gl_date           >= trunc(sysdate,'MM')
        and mtl.gl_date           <  last_day(trunc(sysdate))+1
        AND mtl.posting_entity_id =  '454045211000109'
        AND mtl.settl_flag        =  'Y'
        GROUP BY substr(mtl.posting_entity_id,1,15), ae.entity_dba_name, to_char(gl_date,'DD-MON-YY'),
                to_char(pl.payment_proc_dt,'DD-MON-YY'), mtl.tid_settl_method, mtl.tid, mtl.mas_code,
                substr(t.description,1,40), mc.mas_desc
        ORDER BY entity_id, 2, 3, TID"

#puts $sql1

orasql $fetch_cursor $sql1

puts $cur_file "RUN DATE:,,,,DAILY,Direct Air,REPORT"
puts $cur_file "$rundate,$tstmp"
puts $cur_file " "
puts $cur_file " "

set    header_line "ENTITY_ID,DBA_NAME,GL_DATE,PAYMENT_DT,CNT,DB_CR,AMT_BILLING,ITEMS,TID,MAS_CODE,"
append header_line "TID_DESCRIPTION,MAS_CODE_DESCRIPTION"

puts $cur_file $header_line

while {[set x [orafetch $fetch_cursor -dataarray s -indexbyname]] == 0} {

    set    detail_line "$s(ENTITY_ID),$s(DBA_NAME),$s(GL_DATE),$s(PAYMENT_DT),$s(CNT),$s(DB_CR)"
    append detail_line ",$s(AMT_BILLING),$s(ITEMS),$s(TID),$s(MAS_CODE),$s(TID_DESCRIPTION)"
    append detail_line ",$s(MAS_CODE_DESCRIPTION)"

    puts $cur_file "$detail_line"
}

oraclose $fetch_cursor
close $cur_file

  exec mutt -a $file_name -s "$file_name" -- $ml_list < direct_air_report_email_body.txt

  exec mv $file_name ./INST_107/ARCHIVE/
