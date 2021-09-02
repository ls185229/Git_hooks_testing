#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: drv_america_daily_report.tcl 4662 2018-08-16 13:53:24Z lmendis $

##################################################################################

## **************   Modification History  ******************
## Version 1.00 Rifat Khan 11-15-2010

## USAGE: script name with no argument
## NOTE: CODE NEED FIX to ALLOW AMEX ONLY Transaction ENTRY.

##################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(ml2_alerts)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(IST_DB)
#set authdb $env(ATH_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(CLR4_DB)
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
set authdb $env(TSP4_DB)
#set clrdb "trnclr1"
#set authdb "transp1"

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

####################################################################################################################


package require Oratcl
if {[catch {set handler [oralogon $clruser/$clrpwd@$clrdb]} result]} {
  exec echo "drv_america_daily_report.tcl failed to connect to $clrdb" | mailx -r mailfromlist -s "drv_america_daily_report.tcl" $mailtolist
  exit
} else {
    puts "COnnected"
}

if {[catch {set teihosthandler [oralogon $authuser/$authpwd@$authdb]} result]} {
  exec echo "drv_america_daily_report.tcl failed to connect to $authdb" | mailx -r mailfromlist -s "drv_america_daily_report.tcl" $mailtolist
  exit
} else {
    puts "COnnected" 
}

set fetch_cursor [oraopen $handler]
set get_cursor [oraopen $teihosthandler]

set dt [lindex $argv 0]
# set ml_list "Reports-clearing@jetpay.com,Jetpay.support@drive-america.com,Kelsey.Madkin@driven-solutions.com,Patty.Baker@driven-solutions.com"
set ml_list "Reports-clearing@jetpay.com,Jetpay.support@drive-america.com"

set fdate [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]
set date  [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]
set yhdate  [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set ymdate [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set filedate [clock format [clock scan "$dt -0 day"] -format %Y%m%d]
set rundate [clock format [clock scan seconds] -format  %d-%b-%y]
set tstmp [clock format [clock scan seconds] -format %M%H%S]


set CUR_JULIAN_DATEX [string range [clock format [clock scan "$rundate -0 day"] -format "%y%j"] 1 4]


set ax_vid_totals(vid-s_date) 0

set card_list {VS MC DS AX OT}

set file_name "DRIVE-AMERICA.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv"

if {[file exists $file_name]} {
    exec mv $file_name ./INST_101/ARCHIVE/DRIVE-AMERICA.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv-reran.$rundate
    set file_name "DRIVE-AMERICA.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv"
}

if {[file exists ./INST_101/ARCHIVE/$file_name]} {
        exec mv ./INST_101/ARCHIVE/$file_name ./INST_101/ARCHIVE/DRIVE-AMERICA.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv-reran.$rundate
        set file_name "DRIVE-AMERICA.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.csv"
}
set cur_file [open "$file_name" w]

set sql3 "
    SELECT
        to_char(MIN(settl_date),'YYYYMMDD') as mindt,
        to_char(MAX(settl_date),'YYYYMMDD') as maxdt
    FROM
        acct_accum_det a,
        entity_acct e
    WHERE
        TRUNC(a.payment_proc_dt, 'DDD') = TRUNC(to_date('$fdate','DD-MON-YYYY'),'DDD')
    AND a.institution_id   = '101'
    AND e.owner_entity_id IN (
        '447474200000362', '447474200000365', '447474200000366', '447474200000367',
        '447474200000368', '447474200000369', '447474200000370', '447474200000371',
        '447474200000372', '447474200000382' )
    AND e.ENTITY_ACCT_ID = a.ENTITY_ACCT_ID
    AND e.institution_id = a.institution_id
    AND a.payment_status = 'P'"

#puts $sql3

orasql $fetch_cursor $sql3

if {[set z [orafetch $fetch_cursor -dataarray sdts -indexbyname]] == 0} {
 set ax_min_dt $sdts(MINDT)
 set ax_max_dt $sdts(MAXDT)
} else {
 set ax_min_dt $yhdate
 set ax_max_dt $yhdate
}


set sql2 "
    select
    m.visa_id,
    substr(t.settle_date, 1,8 ) as s_date,
    nvl(sum(case
          WHEN t.request_type = '0420'
          THEN t.amount * -1
          ELSE t.amount
        end
    ), 0) as ax_sales
    from tranhistory t, merchant m
    where t.mid in (
        select mid from merchant where visa_id
        IN (
            '447474200000362', '447474200000365', '447474200000366', '447474200000367',
            '447474200000368', '447474200000369', '447474200000370', '447474200000371',
            '447474200000372', '447474200000382'
        )
    )
    and t.mid = m.mid
    and substr(t.settle_date, 1, 8) >= '$ax_min_dt'
    and substr(t.settle_date, 1, 8) <= '$ax_max_dt'
    and card_type = 'AX'
    group by
    m.visa_id,
    substr(t.settle_date, 1, 8)"

#puts $sql2

orasql $get_cursor $sql2


while {[set y [orafetch $get_cursor -dataarray axsl -indexbyname]] == 0} {

	set ax_vid_totals($axsl(VISA_ID)-$axsl(S_DATE)) $axsl(AX_SALES)

}




set sql1 "
    SELECT
        mas_trans_log.posting_entity_id AS VISA_ID,
        (
            select e.entity_dba_name
            from acq_entity e
            where e.entity_id = mas_trans_log.posting_entity_id
            and e.institution_id = '101'
        ) as DBA_NM,
        acct_accum_det.settl_date AS SETTLE_DATE,
        acct_accum_det.PAYMENT_PROC_DT AS PAYMENT_DATE,
    nvl(SUM(
        CASE
        WHEN mas_trans_log.tid = '010003005101' AND tid_settl_method  = 'C'
        THEN mas_trans_log.amt_billing
        WHEN mas_trans_log.tid = '010003005102' AND tid_settl_method  = 'D'
        THEN mas_trans_log.amt_billing * -1
        ELSE 0
        END), 0) AS NET_SALES,
    nvl(SUM(
        CASE
            WHEN mas_trans_log.tid in (
                '010003005301', '010003005401', '010003010102', '010003010101',
                '010003015201', '010003015102', '010003015101', '010003015210'
                ) AND tid_settl_method  = 'C'
            THEN mas_trans_log.amt_billing
            WHEN mas_trans_log.tid in (
                '010003005301', '010003005401', '010003010102', '010003010101',
                '010003015201', '010003015102', '010003015101', '010003015210'
                ) AND tid_settl_method  = 'D'
            THEN mas_trans_log.amt_billing * -1
            ELSE 0
        END), 0) AS CBRP,
    nvl(SUM(
        CASE
            WHEN SUBSTR(mas_trans_log.tid,1,6) = '010004'
                AND tid_settl_method                      = 'C'
            THEN mas_trans_log.amt_billing
            WHEN SUBSTR(mas_trans_log.tid,1,6) = '010004'
                AND tid_settl_method                      = 'D'
            THEN mas_trans_log.amt_billing * -1
            ELSE 0
        END), 0) AS FEES,
    nvl(SUM(
        CASE
        WHEN
            (mas_trans_log.tid IN (
                '010003005101', '010003005102','010003005301', '010003005401',
                '010003010102', '010003010101','010003015201', '010003015102',
                '010003015101', '010003015210'
            )
            or SUBSTR(mas_trans_log.tid,1,6) = '010004'
        )
        THEN 0
        ELSE (case when tid_settl_method = 'C'
                   then mas_trans_log.amt_billing
                   else mas_trans_log.amt_billing * -1 end)
        END), 0) AS ADJUSTMENTS
    FROM
        mas_trans_log mas_trans_log,
        acct_accum_det acct_accum_det
    WHERE
        mas_trans_log.payment_seq_nbr IN (
            SELECT payment_seq_nbr
            FROM acct_accum_det
            WHERE TRUNC(payment_proc_dt, 'DDD') = TRUNC(to_date('$fdate','DD-MON-YYYY'),'DDD')
            AND institution_id = '101'
        )
    AND mas_trans_log.institution_id     = '101'
    AND mas_trans_log.posting_entity_id IN (
        '447474200000362', '447474200000365', '447474200000366', '447474200000367',
        '447474200000368', '447474200000369', '447474200000370', '447474200000371',
        '447474200000372', '447474200000382'
    )
    AND mas_trans_log.payment_seq_nbr    = acct_accum_det.payment_seq_nbr
    AND mas_trans_log.institution_id     = acct_accum_det.institution_id
    and acct_accum_det.PAYMENT_STATUS = 'P'
    GROUP BY
        mas_trans_log.posting_entity_id,
        acct_accum_det.settl_date,
        acct_accum_det.PAYMENT_PROC_DT
    order by
        mas_trans_log.posting_entity_id,
        acct_accum_det.settl_date,
        acct_accum_det.PAYMENT_PROC_DT"

#puts $sql1

orasql $fetch_cursor $sql1

puts $cur_file "RUN DATE:,,,,DAILY,FUNDING,REPORT"
puts $cur_file "$rundate"
puts $cur_file " "
puts $cur_file " "

puts $cur_file ",,,,,CHARGEBACK/,,,"
puts $cur_file "VISA ID,DBA NAME,SETTLE DATE,PAYMENT DATE,NET SALES,REPRESENTMENTS,ADJUSTMENTS,FEES,DEPOSITS,AMEX SALES"

while {[set x [orafetch $fetch_cursor -dataarray s -indexbyname]] == 0} {
    set sdate [string toupper [clock format [clock scan "$s(SETTLE_DATE) -0 day"] -format %Y%m%d]]
    #puts $sdate
    set ndeposit [expr $s(NET_SALES) + $s(CBRP) + $s(FEES) + $s(ADJUSTMENTS)]
    if {[info exists ax_vid_totals($s(VISA_ID)-$sdate)]} {
        set ax_sales_tot $ax_vid_totals($s(VISA_ID)-$sdate)
    } else {
        set ax_sales_tot 0

    }
puts $cur_file "$s(VISA_ID),$s(DBA_NM),$s(SETTLE_DATE),$s(PAYMENT_DATE),$s(NET_SALES),$s(CBRP),$s(ADJUSTMENTS),$s(FEES),$ndeposit,$ax_sales_tot"

}

oraclose $fetch_cursor
oraclose $get_cursor
close $cur_file

  exec mutt -a $file_name -s "$file_name" -- $ml_list < generic_funding_report_email_body.txt

  exec mv $file_name ./INST_101/ARCHIVE/
