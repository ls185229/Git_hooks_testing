#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: dfw_report_4_acct.tcl 4213 2017-06-26 14:36:17Z bjones $

##################################################################################
## **************   Modification History  ******************
## Version 1.00 Rifat Khan 05-13-2010
## USAGE: script name with no argument
##################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(IST_DB)
#set authdb $env(ATH_DB)
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

####################################################################################################################


package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo "dfw_report_4_acct.tcl failed to run" | mailx -r mailfromlist -s "dfw_report_4_acct.tcl" $mailtolist
  exit
}

if {[catch {set porthandler [oralogon port/tawny@trnclr4]} result]} {
  exec echo "dfw_report_4_acct.tcl failed to run" | mailx -r mailfromlist -s "dfw_report_4_acct.tcl" $mailtolist
  exit
}

set fetch_cursor [oraopen $porthandler]
set test_cursor1 [oraopen $porthandler]

set get_cursor [oraopen $handler]
set test_cursor1 [oraopen $handler]

set dt [lindex $argv 0]

set fdate [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%y]]
set date  [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%y]]
set yhdate  [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set ymdate [string toupper [clock format [clock scan "$dt -0 day"] -format %Y%m%d]]
set filedate [clock format [clock scan "$dt -0 day"] -format %Y%m%d]


set CUR_JULIAN_DATEX [string range [clock format [clock scan "$dt -0 day"] -format "%y%j"] 1 4]

set mid_list {DFW-ACCESS-CONTR DFW-GROUND-TRAN DFW_PARKING_NP DFW_PARKING_NS DFW_PARKING_SP DFW_PARKING_SS DFW_PARKING_AD DFW-PARKING-PRIV  DFW-PARKING-ETC1 DFW-FINANCE-ADMN DFW-DPS-FIRE-TRA DFW-DPS-GUN-RANG DFW_PARKING_AD1 DFW_PARKING_OL DFW-PARKING-FIN1 D-FW-PARKING-RJ DFW_PARKING_4W DFW_PARKING_PCS DFW-FOUNDERS-001}

set sqlmidlist "
'DFW-ACCESS-CONTR',
'DFW-DPS-FIRE-TRA',
'DFW-DPS-GUN-RANG',
'DFW-GROUND-TRAN',
'D-FW-PARKING-RJ',
'DFW_PARKING_AD',
'DFW_PARKING_AD1',
'DFW_PARKING_NP',
'DFW_PARKING_NS',
'DFW_PARKING_SP',
'DFW_PARKING_SS',
'DFW_PARKING_4W',
'DFW-PARKING-ETC1',
'DFW-PARKING-FIN1',
'DFW_PARKING_OL',
'DFW-PARKING-PRIV',
'DFW-FINANCE-ADMN',
'DFW_PARKING_PCS',
'DFW-FOUNDERS-001'
"

set ent_id_list "
'447474410000126', 
'447474410000123', 
'447474410000125',
'447474410000124', 
'447474410000122', 
'447474410000129',
'447474410000132', 
'447474410000133', 
'447474410000128',
'447474410000130',
'447474200000128',
'447474400000316'
"

set card_list {VS MC DS AX OT}

set file_name "DFW.REPORT.DAILY.$CUR_JULIAN_DATEX.$filedate.101.001.csv"
if {[file exists $file_name]} {
	file delete $file_name
}
set cur_file [open "$file_name" w]


set sql1 "select
 tranhistory.mid,
 mas_trans_log.card_scheme,
 sum(case when masclr.mas_trans_log.tid = '010003005101' then 1 else 0 end) as Sale_count,
 sum(case when masclr.mas_trans_log.tid = '010003005101' then masclr.mas_trans_log.amt_billing else 0 end) as Sales_amount,
 sum(case when masclr.mas_trans_log.tid = '010003005102' then 1 else 0 end) as Refund_count,
 sum(case when masclr.mas_trans_log.tid = '010003005102' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as Refund_amount,
 sum(case when masclr.mas_trans_log.tid in ('010003005101','010003005102')  then 1 else 0 end) as TOTAL_COUNT,
 sum(case when masclr.mas_trans_log.tid = '010003005101' then masclr.mas_trans_log.amt_billing else 0 end) + sum(case when masclr.mas_trans_log.tid = '010003005102' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as TOTAL_AMOUNT,
 sum(case when masclr.mas_trans_log.tid = '010004020000' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as INTERCHANGE,
 sum(case when masclr.mas_trans_log.tid = '010004030000' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as assessment,
 sum(case when masclr.mas_trans_log.tid = '010004120000' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as ToTAL_PER_ITEM,
 sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' and masclr.mas_trans_log.tid not in ('010004020000','010004030000','010004120000') then masclr.mas_trans_log.amt_original * -1 else 0 end) as OTHER_FEE,
 sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as ToTAL_FEE,
 sum(case when masclr.mas_trans_log.tid = '010003005101' then masclr.mas_trans_log.amt_billing else 0 end) + sum(case when masclr.mas_trans_log.tid = '010003005102' then masclr.mas_trans_log.amt_billing * -1 else 0 end) + sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' then masclr.mas_trans_log.amt_billing * -1 else 0 end) as total
 from masclr.mas_trans_log mas_trans_log, tranhist tranhistory where masclr.mas_trans_log.file_id in (select file_id from masclr.mas_file_log where trunc(RECEIVE_DATE_TIME, 'DDD') = trunc(to_date('$date','DD-MON-YY'),'DDD') and institution_id = '101')
 and mas_trans_log.institution_id = '101'
 and mas_trans_log.posting_entity_id in (select unique entity_id from masclr.entity_to_auth where mid in ($sqlmidlist) and status = 'A')
and 
tranhistory.arn =  mas_trans_log.trans_ref_data
and tranhistory.mid in ($sqlmidlist)
and tranhistory.card_type not in ('AX')
and tranhistory.settle_date like '$ymdate%'
group by
tranhistory.mid,
mas_trans_log.card_scheme
order by
tranhistory.mid,
mas_trans_log.card_scheme"

orasql $fetch_cursor $sql1

while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
	set vmd($s(MID)-[string map {"04" "VS" "05" "MC" "03" "AX" "08" "DS" "02" "OT" "06" "OT" "09" "OT" "11" "OT" "12" "OT" "07" OT"} $s(CARD_SCHEME)]) "[string map {"04" "VS" "05" "MC" "03" "AX" "08" "DS" "02" "OT" "06" "OT" "09" "OT" "11" "OT" "12" "OT" "07" OT"} $s(CARD_SCHEME)],$s(SALE_COUNT),$s(SALES_AMOUNT),$s(REFUND_COUNT),$s(REFUND_AMOUNT),$s(TOTAL_COUNT),$s(TOTAL_AMOUNT),$s(INTERCHANGE),$s(ASSESSMENT),$s(TOTAL_PER_ITEM),$s(OTHER_FEE),$s(TOTAL_FEE),$s(TOTAL)" 
}

set sql2 "select
 mas_trans_log.trans_ref_data,
 mas_trans_log.card_scheme,
 sum(case when masclr.mas_trans_log.tid = '010070010020' then NBR_OF_ITEMS else 0 end) as Sale_count,
 sum(case when masclr.mas_trans_log.tid = '010070010020' then masclr.mas_trans_log.amt_original else 0 end) as Sales_amount,
 sum(case when masclr.mas_trans_log.tid = '010070010021' then NBR_OF_ITEMS else 0 end) as Refund_count,
 sum(case when masclr.mas_trans_log.tid = '010070010021' then masclr.mas_trans_log.amt_original * -1 else 0 end) as Refund_amount,
 sum(case when masclr.mas_trans_log.tid in ('010070010020','010070010021')  then NBR_OF_ITEMS else 0 end) as TOTAL_COUNT,
 sum(case when masclr.mas_trans_log.tid = '010070010020' then masclr.mas_trans_log.amt_original else 0 end) + sum(case when masclr.mas_trans_log.tid = '010070010021' then masclr.mas_trans_log.amt_original * -1 else 0 end) as TOTAL_AMOUNT,
 sum(case when masclr.mas_trans_log.tid = '010004010000' then masclr.mas_trans_log.amt_original * -1 
          when masclr.mas_trans_log.tid = '010004010005' then masclr.mas_trans_log.amt_original  else 0 end) as INTERCHANGE,
 sum(case when masclr.mas_trans_log.tid = '010004030000' then masclr.mas_trans_log.amt_original * -1 else 0 end) as assessment,
 sum(case when masclr.mas_trans_log.tid = '010004120000' then masclr.mas_trans_log.amt_original * -1 else 0 end) as ToTAL_PER_ITEM,
 sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' and masclr.mas_trans_log.tid not in ('010004010000','010004010005','010004030000','010004120000') then masclr.mas_trans_log.amt_original * -1 else 0 end) as OTHER_FEE,
 sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' then masclr.mas_trans_log.amt_original * -1 else 0 end) as ToTAL_FEE,
 sum(case when masclr.mas_trans_log.tid = '010070010020' then masclr.mas_trans_log.amt_original else 0 end) + sum(case when masclr.mas_trans_log.tid = '010070010021' then masclr.mas_trans_log.amt_original * -1 else 0 end) + sum(case when substr(masclr.mas_trans_log.tid,1,6) = '010004' then masclr.mas_trans_log.amt_original * -1 else 0 end) as total
 from masclr.mas_trans_log mas_trans_log where masclr.mas_trans_log.file_id in (
 select file_id from masclr.mas_file_log where trunc(RECEIVE_DATE_TIME, 'DDD') = trunc(trunc(to_date('$fdate','DD-MON-YY'),'DDD'), 'DDD') and file_name like '101.DFWAMEXC%' and institution_id = '101'
 )
group by
mas_trans_log.trans_ref_data,
mas_trans_log.card_scheme
order by
mas_trans_log.trans_ref_data,
mas_trans_log.card_scheme"

#puts $sql2


orasql $get_cursor $sql2

while {[orafetch $get_cursor -dataarray s -indexbyname] != 1403} {
        set vmd($s(TRANS_REF_DATA)-[string map {"04" "VS" "05" "MC" "03" "AX" "08" "DS" "02" "OT" "06" "OT" "09" "OT" "11" "OT" "12" "OT" "07" OT"} $s(CARD_SCHEME)]) "[string map {"04" "VS" "05" "MC" "03" "AX" "08" "DS" "02" "OT" "06" "OT" "09" "OT" "11" "OT" "12" "OT" "07" OT"} $s(CARD_SCHEME)],$s(SALE_COUNT),$s(SALES_AMOUNT),$s(REFUND_COUNT),$s(REFUND_AMOUNT),$s(TOTAL_COUNT),$s(TOTAL_AMOUNT),$s(INTERCHANGE),$s(ASSESSMENT),$s(TOTAL_PER_ITEM),$s(OTHER_FEE),$s(TOTAL_FEE),$s(TOTAL)"
}

set  S_SALE_COUNT 0
set  S_SALES_AMOUNT 0
set  S_REFUND_COUNT 0
set  S_REFUND_AMOUNT 0
set  S_TOTAL_COUNT 0
set  S_TOTAL_AMOUNT 0
set  S_INTERCHANGE 0
set  S_ASSESSMENT 0
set  S_TOTAL_PER_ITEM 0
set  S_OTHER_FEE 0
set  S_TOTAL_FEE 0
set  S_TOTAL 0
  
set  G_SALE_COUNT 0
set  G_SALES_AMOUNT 0
set  G_REFUND_COUNT 0
set  G_REFUND_AMOUNT 0
set  G_TOTAL_COUNT 0
set  G_TOTAL_AMOUNT 0
set  G_INTERCHANGE 0
set  G_ASSESSMENT 0
set  G_TOTAL_PER_ITEM 0
set  G_OTHER_FEE 0
set  G_TOTAL_FEE 0
set  G_TOTAL 0


puts $cur_file ",,,,,,DFW,FUNDING,REPORT"
puts $cur_file "VS/MC/DS/AX/OT,SETTLEMENT DATE:,$date"
puts $cur_file " "
puts $cur_file " "

foreach mid $mid_list {

set  S_SALE_COUNT 0
set  S_SALES_AMOUNT 0
set  S_REFUND_COUNT 0
set  S_REFUND_AMOUNT 0
set  S_TOTAL_COUNT 0
set  S_TOTAL_AMOUNT 0
set  S_INTERCHANGE 0
set  S_ASSESSMENT 0
set  S_TOTAL_PER_ITEM 0
set  S_TOTAL_FEE 0
set  S_OTHER_FEE 0
set  S_TOTAL 0

puts $cur_file ",MID:,$mid"
puts $cur_file " "
puts $cur_file ",,,CARD TYPE,SALES COUNT,SALES AMOUNT,REFUND COUNT,REFUND AMOUNT,GROSS COUNT,GROSS AMOUNT,INTERCHANGE,ASSESSMENTS,PER ITEM FEE,OTHER FEES,TOTAL FEES,NET AMOUNT"

	foreach card $card_list {
	      if {[info exists vmd($mid-$card)]} {
		puts $cur_file ",,,$vmd($mid-$card)"
				set vdata [split $vmd($mid-$card) ,]
                                        set S_SALE_COUNT [ expr $S_SALE_COUNT + [lindex $vdata 1]]
                                        set S_SALES_AMOUNT [ expr $S_SALES_AMOUNT + [lindex $vdata 2]]
                                        set S_REFUND_COUNT [ expr $S_REFUND_COUNT + [lindex $vdata 3]]
                                        set S_REFUND_AMOUNT [ expr $S_REFUND_AMOUNT + [lindex $vdata 4]]
                                        set S_TOTAL_COUNT [ expr $S_TOTAL_COUNT + [lindex $vdata 5]]
                                        set S_TOTAL_AMOUNT [ expr $S_TOTAL_AMOUNT + [lindex $vdata 6]]
                                        set S_INTERCHANGE [ expr $S_INTERCHANGE + [lindex $vdata 7]]
                                        set S_ASSESSMENT [ expr $S_ASSESSMENT + [lindex $vdata 8]]
                                        set S_TOTAL_PER_ITEM [ expr $S_TOTAL_PER_ITEM + [lindex $vdata 9]]
                                        set S_OTHER_FEE [expr $S_OTHER_FEE + [lindex $vdata 10]]
                                        set S_TOTAL_FEE [ expr $S_TOTAL_FEE + [lindex $vdata 11]]
                                        set S_TOTAL [ expr $S_TOTAL + [lindex $vdata 12]]
		
                                        set G_SALE_COUNT [ expr $G_SALE_COUNT + [lindex $vdata 1]]
                                        set G_SALES_AMOUNT [ expr $G_SALES_AMOUNT + [lindex $vdata 2]]
                                        set G_REFUND_COUNT [ expr $G_REFUND_COUNT + [lindex $vdata 3]]
                                        set G_REFUND_AMOUNT [ expr $G_REFUND_AMOUNT + [lindex $vdata 4]]
                                        set G_TOTAL_COUNT [ expr $G_TOTAL_COUNT + [lindex $vdata 5]]
                                        set G_TOTAL_AMOUNT [ expr $G_TOTAL_AMOUNT + [lindex $vdata 6]]
                                        set G_INTERCHANGE [ expr $G_INTERCHANGE + [lindex $vdata 7]]
                                        set G_ASSESSMENT [ expr $G_ASSESSMENT + [lindex $vdata 8]]
                                        set G_TOTAL_PER_ITEM [ expr $G_TOTAL_PER_ITEM + [lindex $vdata 9]]
                                        set G_OTHER_FEE [expr $G_OTHER_FEE + [lindex $vdata 10]]
                                        set G_TOTAL_FEE [ expr $G_TOTAL_FEE + [lindex $vdata 11]]
                                        set G_TOTAL [ expr $G_TOTAL + [lindex $vdata 12]]
	      } else {
		puts $cur_file ",,,$card,0,0,0,0,0,0,0,0,0,0,0,0"
	      }
	}
	puts $cur_file ",,,SUBTOTAL,$S_SALE_COUNT,$S_SALES_AMOUNT,$S_REFUND_COUNT,$S_REFUND_AMOUNT,$S_TOTAL_COUNT,$S_TOTAL_AMOUNT,$S_INTERCHANGE,$S_ASSESSMENT,$S_TOTAL_PER_ITEM,$S_OTHER_FEE,$S_TOTAL_FEE,$S_TOTAL"
puts $cur_file " "

}

puts $cur_file ",,,GRANDTOTAL,$G_SALE_COUNT,$G_SALES_AMOUNT,$G_REFUND_COUNT,$G_REFUND_AMOUNT,$G_TOTAL_COUNT,$G_TOTAL_AMOUNT,$G_INTERCHANGE,$G_ASSESSMENT,$G_TOTAL_PER_ITEM,$G_OTHER_FEE,$G_TOTAL_FEE,$G_TOTAL"


puts $cur_file " "
puts $cur_file " "
puts $cur_file "MONTHLY FEES"
puts $cur_file " "
puts $cur_file ",FUNDING_ENTITY_ID, PASSTHROUGH ASF, OTHER FEES/ADJUST"

set sql3 "SELECT
  posting_entity_id,
  SUM(
    CASE
      WHEN tid_settl_method = 'C'  AND tid NOT IN ('010004020000','010004030000','010004120000') and mas_code = 'ZZACQSUPPORTFEE' THEN amt_billing
      WHEN tid_settl_method = 'D'  AND tid NOT IN ('010004020000','010004030000','010004120000') and mas_code = 'ZZACQSUPPORTFEE' THEN amt_billing * -1
      ELSE 0
    END) as ASF,
  SUM(
    CASE
      WHEN tid_settl_method = 'C'  AND tid NOT IN ('010004020000','010004030000','010004120000') and mas_code <> 'ZZACQSUPPORTFEE' THEN amt_billing
      WHEN tid_settl_method = 'D'  AND tid NOT IN ('010004020000','010004030000','010004120000') and mas_code <> 'ZZACQSUPPORTFEE' THEN amt_billing * -1
      ELSE 0
    END) as OT_FEE
FROM
  mas_trans_log m
WHERE
  m.payment_seq_nbr IN
  (
    SELECT
      payment_seq_nbr
    FROM
      acct_accum_gldate
    WHERE
      entity_id IN ( $ent_id_list )
    AND TRUNC(gl_date,'DDD') = '$date'
  )
AND m.institution_id = '101'
AND m.card_scheme    = '00'
AND tid  like '010004%'
GROUP BY
posting_entity_id
order by 
posting_entity_id"

orasql $get_cursor $sql3

while {[orafetch $get_cursor -dataarray otf -indexbyname] != 1403} {
puts $cur_file ",$otf(POSTING_ENTITY_ID),$otf(ASF),$otf(OT_FEE)"

}


close $cur_file

exec mutt -a $file_name -s "$file_name" -- clearing@jetpay.com accounting@jetpay.com operations@jetpay.com < dfw.txt
#exec mutt -a $file_name -s "TEST $file_name" clearing@jetpay.com < dfw.txt

exec mv $file_name ./INST_101/ARCHIVE/


oraclose $fetch_cursor
oraclose $get_cursor


