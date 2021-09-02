#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#######################################################################################################################

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

#######################################################################################################################

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
  exec echo "merchant statement failed to run" | mailx -r clearing@jetpay.com -s "Merchant statement" clearing@jetpay.com reports-clearing@jetpay.com
  exit
}

set fetch_cursor [oraopen $handler]
set ach_cursor [oraopen $handler]
set test_cursor [oraopen $handler]
set test_cursor1 [oraopen $handler]
set settle_cursor [oraopen $handler]
set update_cursor [oraopen $handler]
set fdate [clock format [clock scan "-0 day"] -format %d-%b-%y]
set date [clock format [clock scan "-0 day"] -format %b-%y]
set name_date_month [clock format [clock scan "-0 day"] -format %B]
set name_date_year [clock format [clock scan "-0 day"] -format %y]
set date_day [clock format [clock scan "-0 day"] -format %d]
set month_date [clock format [clock scan "-0 day"] -format %m]
set header_date [clock format [clock scan "-0 day"] -format %Y]
puts $name_date_year
puts $date_day
puts $month_date

set new_file_name "./ARCHIVE/107.QUALIFICATION-$fdate.tex"
set pdf_file_name "./107.QUALIFICATION-$fdate.pdf"
set new_file [open "$new_file_name" w]

puts $new_file "\\documentclass\[10pt, a4paper\]{report}"
puts $new_file "\\usepackage{lscape}"
puts $new_file "\\usepackage{color}"
#puts $new_file "\\pagenumbering{arabic}"

puts $new_file "\\setlength{\\oddsidemargin}{-.9in}"
puts $new_file "\\setlength{\\textwidth}{8.2in}"

puts $new_file "\\setlength{\\columnsep}{0.5in}"
puts $new_file "\\setlength{\\columnseprule}{1pt}"

puts $new_file "\\setlength{\\textheight}{10.85in}"
puts $new_file "\\setlength{\\topmargin}{-0.5in}"
puts $new_file "\\setlength{\\headsep}{0in}"

puts $new_file "\\setlength{\\parskip}{1.2ex}"
puts $new_file "\\setlength{\\parindent}{0mm}"

puts $new_file "\\setlength{\\evensidemargin}{-.9in}"
puts $new_file "\\setlength{\\headheight}{.5cm}"
puts $new_file "\\setlength{\\topskip}{1cm}"


puts $new_file "\\begin{document}"
puts $new_file "\\noindent"
puts $new_file "\\begin{landscape}"
puts $new_file "\\noindent"
puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"

set sql_string "select mas_trans_log.entity_id,
       acq_entity.entity_dba_name,
       mas_trans_log.activity_date_time,
       mas_trans_log.payment_seq_nbr,
       mas_trans_log.trans_seq_nbr,
       mas_trans_log.trans_sub_seq,
       mas_trans_log.mas_code,
       mas_code.mas_desc,
       mas_trans_log.card_scheme,
       card_scheme.card_scheme_name,
       mas_trans_log.fee_pkg_id,
       fee_pkg.fee_pkg_name,
       mas_trans_log.non_act_fee_pkg_id,
       to_char(mas_trans_log.amt_original, '999999.99') as amount,
       tid.tid_settl_method,
       mas_trans_log.trans_ref_data
from mas_trans_log LEFT OUTER JOIN fee_pkg on mas_trans_log.fee_pkg_id = fee_pkg.fee_pkg_id,
     acq_entity,
     entity_acct,
     mas_code,
     card_scheme,
     tid
where mas_trans_log.entity_acct_id = entity_acct.entity_acct_id AND
      acq_entity.entity_id = entity_acct.owner_entity_id AND
      mas_trans_log.mas_code = mas_code.mas_code AND
      mas_trans_log.card_scheme = card_scheme.card_scheme AND
      mas_trans_log.tid = tid.tid AND
      NOT mas_code.mas_desc LIKE '%ALL%' AND
      NOT mas_code.mas_desc LIKE '%AUTH%' AND
      NOT mas_code.mas_desc LIKE '%SALE' AND
      mas_trans_log.fee_pkg_id = 0 AND
      to_char(mas_trans_log.activity_date_time, 'DD') = $date_day AND
      to_char(mas_trans_log.activity_date_time, 'MM') = $month_date AND
      to_char(mas_trans_log.activity_date_time, 'YY') = $name_date_year AND
      mas_trans_log.tid like '%300510%' AND
      mas_trans_log.institution_id = '107' AND
      acq_entity.institution_id = '107' AND
      entity_acct.institution_id = '107'
group by entity_acct.owner_entity_id,
         mas_trans_log.entity_id,
         acq_entity.entity_dba_name,
         mas_trans_log.activity_date_time,
         mas_trans_log.payment_seq_nbr,
         mas_trans_log.trans_seq_nbr,
         mas_trans_log.trans_sub_seq,
         mas_trans_log.mas_code,
         mas_code.mas_desc,
         mas_trans_log.card_scheme,
         card_scheme.card_scheme_name,
         mas_trans_log.fee_pkg_id,
         fee_pkg.fee_pkg_name,
         mas_trans_log.non_act_fee_pkg_id,
         mas_trans_log.amt_original,
         tid.tid_settl_method,
         mas_trans_log.trans_ref_data
order by acq_entity.entity_dba_name,
         mas_trans_log.activity_date_time,
         card_scheme.card_scheme_name,
         mas_code.mas_desc,
         mas_trans_log.fee_pkg_id,
         fee_pkg.fee_pkg_name,
         mas_trans_log.non_act_fee_pkg_id,
         mas_trans_log.payment_seq_nbr,
         mas_trans_log.trans_seq_nbr,
         mas_trans_log.trans_sub_seq,
         mas_trans_log.amt_original"
puts $sql_string
orasql $test_cursor1 $sql_string
set entity_id " "
set activity_data_time " "
set entity_dba_name " "
set payment_seq_nbr " "
set trans_seq_nbr " "
set trans_sub_seq " "
set mas_code " "
set mas_desc " "
set card_scheme " "
set card_scheme_name " "
set fee_pkg_id " "
set fee_pkg_name " "
set non_act_fee_pkg_id " "
set amount " "
set tid_settl_method " "
set total 0
set fee_total 0
set qual_total 0
set qual_fee_total 0
set grand_total 0
set line_count 5
set mc_total 0
set visa_total 0
set mc_fee_total 0
set visa_fee_total 0
set mc_g_total 0
set mc_fee_g_total 0
set visa_g_total 0
set visa_fee_g_total 0
set page_number 1 

puts $new_file "\\begin{tabular}{lllrrrl} \\"
puts $new_file "\\noindent"
puts $new_file "\\\\"
puts $new_file "\\parbox{7cm}{MERCHANT} & \\parbox{5cm}{QUALIFICATION} & \\parbox{3cm}{CARD TYPE} & \\parbox{3cm}{\\hfill TRANS AMOUNT} & \\parbox{3.5cm}{\\hfill INTERCHANGE} & \\parbox{3cm}{\\hfill NET AMOUNT} & \\parbox{5cm}{ }\\\\"
while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$line_count >= 39} {
    puts $new_file "\\end{tabular}"
    puts $new_file "\\begin{center} Page $page_number \\end{center}"
    puts $new_file "\\pagebreak"
    puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
    puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"
    puts $new_file "\\begin{tabular}{lllrrrl} \\"
    puts $new_file "\\noindent"
puts $new_file "\\parbox{7cm}{MERCHANT} & \\parbox{5cm}{QUALIFICATION} & \\parbox{3cm}{CARD TYPE} & \\parbox{3cm}{\\hfill TRANS AMOUNT} & \\parbox{3.5cm}{\\hfill INTERCHANGE} & \\parbox{3cm}{\\hfill NET AMOUNT} & \\parbox{5cm}{ }\\\\"
    set line_count 3
    set page_number [expr $page_number + 1]
    set entity_id "YES"
  }
  set body " "
#  puts "total:$total + Trans Total:$t(AMOUNT) $t(MAS_DESC) $t(ENTITY_ID)"
  if {$mas_desc != $t(MAS_DESC) && $qual_total != 0 } {
    puts $new_file "\\cline{4-6}"
    puts $new_file "& Qualification Sub Total & & [format "%0.2f" $qual_total] & [format "%0.2f" $qual_fee_total]& [format "%0.2f" [expr $qual_total - $qual_fee_total]]\\\\"
    puts $new_file "\\\\"
    set qual_total 0
    set qual_fee_total 0
    set line_count [expr $line_count + 2]
  }
  if {$entity_dba_name == $t(ENTITY_DBA_NAME)} {
    if {$entity_id == "NEW"} {
      set entity_id "YES"
    }
  } else {
    if {$entity_id == "NEW"} {
      puts $new_file "\\parbox{7cm}{$t(ENTITY_ID)} & \\\\" 
    } 
    if {$entity_dba_name != " "} {
      if {$line_count >= 39} {
        puts $new_file "\\end{tabular}"
        puts $new_file "\\begin{center} Page $page_number \\end{center}"
        puts $new_file "\\pagebreak"
        puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
        puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"
        puts $new_file "\\begin{tabular}{lllrrrl} \\"
        puts $new_file "\\noindent"
        puts $new_file "\\parbox{7cm}{MERCHANT} & \\parbox{5cm}{QUALIFICATION} & \\parbox{3cm}{CARD TYPE} & \\parbox{3cm}{\\hfill TRANS AMOUNT} & \\parbox{3.5cm}{\\hfill INTERCHANGE} & \\parbox{3cm}{\\hfill NET AMOUNT} & \\parbox{5cm}{ }\\\\"
        set line_count 3
        set page_number [expr $page_number + 1]
        set entity_id "YES"
      }
      puts $new_file " &VISA Total & & [format "%0.2f" $visa_total] & [format "%0.2f" $visa_fee_total] & [format "%0.2f" [expr $visa_total - $visa_fee_total]]\\\\"
      puts $new_file "\\\\"
      puts $new_file " &MC Total & & [format "%0.2f" $mc_total] & [format "%0.2f" $mc_fee_total] & [format "%0.2f" [expr $mc_total - $mc_fee_total]]\\\\"
      puts $new_file "\\\\"
      puts $new_file "\\cline{4-6}"
      puts $new_file " &Total & & [format "%0.2f" $total] & [format "%0.2f" $fee_total] & [format "%0.2f" [expr $total - $fee_total]]\\\\"
      set line_count [expr $line_count + 4]
      set visa_total 0
      set visa_fee_total 0
      set mc_total 0
      set mc_fee_total 0
      set total 0
      set fee_total 0
      set mas_desc ""
    }
    puts $new_file "\\\\"
    set line_count [expr $line_count + 1]
    set grand_total [expr $grand_total + $total]
    set total 0
    set body "$body $t(ENTITY_DBA_NAME)"
    set entity_id "NEW"
  }
  if {$entity_id == "YES"} {
    set body "\\parbox{7cm}{$t(ENTITY_ID)} &"
    set entity_id "NO"
  } else { 
    set body "$body &"
  }

  if {$mas_desc == $t(MAS_DESC)} {
    set body "$body &"
  } else {
    set body "$body $t(MAS_DESC)&"
  }
  if {$card_scheme_name == $t(CARD_SCHEME_NAME)} {
    set body "$body &"
  } else {
    set body "$body $t(CARD_SCHEME_NAME)&"
  }
  set sql_string "select to_char(sum(AMT_ORIGINAL), '999999.99') as fee from mas_trans_log where mas_code = '$t(MAS_CODE)' and trans_ref_data = '$t(TRANS_REF_DATA)' and FEE_PKG_ID != 0 and trans_seq_nbr = '$t(TRANS_SEQ_NBR)' and institution_id = '107'"
 # set sql_string "select to_char(sum(AMT_ORIGINAL), '999999.99') as fee from mas_trans_log where mas_code = '$t(MAS_CODE)' and trans_ref_data = '$t(TRANS_REF_DATA)' and FEE_PKG_ID != 0"
  orasql $test_cursor $sql_string
  orafetch $test_cursor -dataarray s -indexbyname
  if {$s(FEE) == ""} {
        set s(FEE) 0
  }
  if {$t(TID_SETTL_METHOD) != "C"} {
    set t(AMOUNT) [expr $t(AMOUNT) * -1]
    set s(FEE) [expr $s(FEE) * -1]
  }

  if {$t(CARD_SCHEME_NAME) == "VISA"} {
    set visa_total [expr $visa_total + $t(AMOUNT)]
#puts "$visa_fee_total + >$s(FEE)<"
    set visa_fee_total [expr $visa_fee_total + $s(FEE)]
    set visa_g_total [expr $visa_g_total + $t(AMOUNT)]
    set visa_fee_g_total [expr $visa_fee_g_total + $s(FEE)]
  } else {
    set mc_total [expr $mc_total + $t(AMOUNT)]
    set mc_fee_total [expr $mc_fee_total + $s(FEE)]
    set mc_g_total [expr $mc_g_total + $t(AMOUNT)]
    set mc_fee_g_total [expr $mc_fee_g_total + $s(FEE)]
  }

#  if {$amount == $t(AMOUNT)} {
#    set body "$body &"
#  } else {
    set body "$body [format "%0.2f" $t(AMOUNT)] & [format "%0.2f" $s(FEE)] & [format "%0.2f" [expr $t(AMOUNT) - $s(FEE)]]"
#  }
  set qual_total [expr $qual_total + $t(AMOUNT)]
  set qual_fee_total [expr $qual_fee_total + $s(FEE)]
  
  puts $new_file "$body \\\\"
  set line_count [expr $line_count + 1]

  set total [expr $total + $t(AMOUNT)]
  set fee_total [expr $fee_total + $s(FEE)]
  set activity_data_time $t(ACTIVITY_DATE_TIME)
  set entity_dba_name $t(ENTITY_DBA_NAME)
  set payment_seq_nbr $t(PAYMENT_SEQ_NBR)
  set trans_seq_nbr $t(TRANS_SEQ_NBR)
  set trans_sub_seq $t(TRANS_SUB_SEQ)
  set mas_code $t(MAS_CODE)
  set mas_desc $t(MAS_DESC)
  set card_scheme $t(CARD_SCHEME)
  set card_scheme_name $t(CARD_SCHEME_NAME)
  set fee_pkg_id $t(FEE_PKG_ID)
  set fee_pkg_name $t(FEE_PKG_NAME)
  set non_act_fee_pkg_id $t(NON_ACT_FEE_PKG_ID)
  set amount $t(AMOUNT)
  set tid_settl_method $t(TID_SETTL_METHOD)
}
if {$line_count >= 23} {
  puts $new_file "\\end{tabular}"
  puts $new_file "\\begin{center} Page $page_number \\end{center}"
  puts $new_file "\\pagebreak"
  puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
  puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"
  puts $new_file "\\begin{tabular}{lllrrrl} \\"
  puts $new_file "\\noindent"
puts $new_file "\\parbox{7cm}{MERCHANT} & \\parbox{5cm}{QUALIFICATION} & \\parbox{3cm}{CARD TYPE} & \\parbox{3cm}{\\hfill TRANS AMOUNT} & \\parbox{3.5cm}{\\hfill INTERCHANGE} & \\parbox{3cm}{\\hfill NET AMOUNT} & \\parbox{5cm}{ }\\\\"
  set line_count 0
  set page_number [expr $page_number + 1]
  set entity_id "YES"
} else {
  set entity_id "NO"
}
puts $new_file "\\\\"
puts $new_file "\\cline{4-6}"
if {$entity_id == "YES"} {
  puts $new_file "$t(ENTITY_DBA_NAME)& Qualification Sub Total & & [format "%0.2f" $qual_total] & [format "%0.2f" $qual_fee_total]& [format "%0.2f" [expr $qual_total - $qual_fee_total]]\\\\"
  puts $new_file "$t(ENTITY_ID)\\\\"
} else {
  puts $new_file "& Qualification Sub Total & & [format "%0.2f" $qual_total] & [format "%0.2f" $qual_fee_total]& [format "%0.2f" [expr $qual_total - $qual_fee_total]]\\\\"
}
puts $new_file "\\\\"
puts $new_file " &VISA Total & & [format "%0.2f" $visa_total] & [format "%0.2f" $visa_fee_total] & [format "%0.2f" [expr $visa_total - $visa_fee_total]]\\\\"
puts $new_file "\\\\"
puts $new_file " &MC Total & & [format "%0.2f" $mc_total] & [format "%0.2f" $mc_fee_total] & [format "%0.2f" [expr $mc_total - $mc_fee_total]]\\\\"
puts $new_file "\\\\"
puts $new_file "\\cline{4-6}"
puts $new_file " &Total & & [format "%0.2f" $total] & [format "%0.2f" $fee_total] & [format "%0.2f" [expr $total - $fee_total]]\\\\"
puts $new_file " &VISA Grand Total & & [format "%0.2f" $visa_g_total] & [format "%0.2f" $visa_fee_g_total] & [format "%0.2f" [expr $visa_g_total - $visa_fee_g_total]]\\\\"
puts $new_file "\\\\"
puts $new_file " &MC Grand Total & & [format "%0.2f" $mc_g_total] & [format "%0.2f" $mc_fee_g_total] & [format "%0.2f" [expr $mc_g_total - $mc_fee_g_total]]\\\\"
puts $new_file "\\\\"
set grand_total [expr $visa_g_total + $mc_g_total]
set grand_fee_total [expr $visa_fee_g_total + $mc_fee_g_total]
puts $new_file "\\cline{4-6}"
puts $new_file " &Grand Total & & [format "%0.2f" $grand_total] & [format "%0.2f" $grand_fee_total]& [format "%0.2f" [expr $grand_total - $grand_fee_total]]\\\\"
puts $new_file "\\\\"
puts $new_file "\\end{tabular}"
puts $new_file "\\begin{center} Page $page_number \\end{center}"
puts $new_file "\\end{landscape}"
puts $new_file "\\end{document}"

close $new_file

exec pdflatex -interaction nonstopmode $new_file_name
#exec scp $pdf_file_name filemgr@dfw-prd-trn-06:./IQR


catch {exec scp $pdf_file_name filemgr@dfw-adm-web-07:./IQR } resultiqr
if  { [string range $resultiqr 0 5 ] == "Kernel"} {
    puts $resultiqr
} else {
  puts "scp  $pdf_file_name filemgr@dfw-adm-web-07:./IQR "
}


#puts "scp $pdf_file_name filemgr@dfw-prd-trn-06:./IQR"
#exec uuencode $pdf_file_name "/$pdf_file_name" > dummy.uuencode
#exec cat body.txt dummy.uuencode | mailx -r clearing@jetpay.com -s "107-QUALIFICATION Detailed Reports for $fdate" clearing@jetpay.com accounting@jetpay.com
#josh@jetpay.com veronica@jetpay.com
exec mv ./$pdf_file_name ./ARCHIVE/$pdf_file_name
exec rm 107.QUALIFICATION-$fdate.aux 107.QUALIFICATION-$fdate.log
exec rm $new_file_name
