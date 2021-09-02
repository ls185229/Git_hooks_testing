#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#New code for qualification summary for institution 101
#Code version # 7.3
#Written by Jannette at 20070301
#Tested on QA since 20070323
#Implemneted in production on 20070330 by rifat 
#Update and implimented by Rifat for Fee collection and Header info modification on 20080417
#

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
  exec echo "merchant statement failed to run" | mailx -r clearing@jetpay.com -s "Merchant statement" reports-clearing@jetpay.com
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
set name_date_month [clock format [clock scan "-0 month"] -format %B]
set name_date_year [clock format [clock scan "-0 month"] -format %y]
set date_day [clock format [clock scan "-0 day"] -format %d]
set month_date [clock format [clock scan "-0 month"] -format %m]
set header_date [clock format [clock scan "-0 month"] -format %Y]
puts $name_date_year
puts $date_day
puts $month_date 

if {$argc == 3} {
set name_date_year [lindex $argv 0]
set date_day [lindex $argv 1]
set month_date [lindex $argv 2]
}

set new_file_name "./ARCHIVE/101.QUALIFICATION-SUMM_$fdate.tex"
set pdf_file_name "101.QUALIFICATION-SUMM_$fdate.pdf"
set new_file [open "$new_file_name" w]


set line_count 0
set page_number 1

set nextent_id " "
set trn_cnt 0
set trn_amt 0
set trn_int_amt 0
set trn_net_amt 0

set vs_tot_amt 0
set vs_tot_cnt 0
set vs_tot_net 0
set vs_tot_int 0

set mc_tot_amt 0
set mc_tot_cnt 0
set mc_tot_net 0
set mc_tot_int 0

set vs_gtot_amt 0
set vs_gtot_cnt 0
set vs_gtot_net 0
set vs_gtot_int 0

set mc_gtot_amt 0
set mc_gtot_cnt 0
set mc_gtot_net 0
set mc_gtot_int 0


set gtot_amt 0
set gtot_cnt 0
set gtot_net 0 
set gtot_int 0


set sql_string "select t.ENTITY_ID, a.entity_name, t.MAS_CODE, m.mas_desc, t.card_scheme, count(t.trans_seq_nbr) as CNT, sum(t.PRINCIPAL_AMT) as AMT, sum(t.AMT_ORIGINAL) as INT,  t.TID_SETTL_METHOD, t.ACTIVITY_DATE_TIME, t.tid from mas_trans_log t, mas_code m, acq_entity a where t.institution_id = '101' and to_char(t.activity_date_time, 'DD') = $date_day AND to_char(t.activity_date_time, 'MM') = $month_date AND to_char(t.activity_date_time, 'YY') = $name_date_year and T.tid in ('010004020000','010004020005') and m.mas_code=t.mas_code and t.entity_id=a.entity_id and a.institution_id=t.institution_id group by t.ENTITY_ID, a.entity_name, t.card_scheme, t.TID_SETTL_METHOD, t.MAS_CODE, m.mas_desc,t.ACTIVITY_DATE_TIME,t.tid order by t.ENTITY_ID, t.card_scheme"

puts $sql_string
orasql $test_cursor1 $sql_string

set putvtot 0
set putmtot 0
set cs "04"
set m_tot_amt 0
set m_tot_cnt 0
set m_tot_net 0
set m_tot_int 0
set v_tot_amt 0
set v_tot_cnt 0
set v_tot_net 0
set v_tot_int 0


puts $new_file "\\documentclass\[10pt, a4papar\]{article}"
puts $new_file "\\usepackage{lscape}"
puts $new_file "\\usepackage{color}"
puts $new_file "\\pagenumbering{arabic}"

puts $new_file "\\setlength{\\oddsidemargin}{-.6in}"
puts $new_file "\\setlength{\\textwidth}{7.9in}"

#puts $new_file "\\setlength{\\columnsep}{0.5in}"
#puts $new_file "\\setlength{\\columnseprule}{1pt}"

puts $new_file "\\setlength{\\textheight}{10.5in}"
puts $new_file "\\setlength{\\topmargin}{-.9in}"
#puts $new_file "\\setlength{\\headsep}{.5in}"

#puts $new_file "\\setlength{\\parskip}{1.2ex}"
puts $new_file "\\setlength{\\parindent}{0mm}"

puts $new_file "\\setlength{\\evensidemargin}{.9in}"
#puts $new_file "\\setlength{\\headheight}{.5cm}"
#puts $new_file "\\setlength{\\topskip}{1cm}"


puts $new_file "\\begin{document}"
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center} "
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file "\\begin{tabular}{p{5cm}p{5cm}rrrrl} \\"
puts $new_file "\\noindent"

puts $new_file "\\parbox{4cm}{MERCHANT} & \\parbox{4cm}{QUALIFICATION} & \\parbox{1cm}{COUNT} & \\parbox{2.4cm}{TRANS AMOUNT} & \\parbox{2cm}{INTERCHANGE} & \\parbox{2cm}{NET AMOUNT} & \\parbox{1cm}{} \\\\"

set line_count 7

proc pgbrk {ln_cnt} {
global line_count page_number new_file name_date_month date_day header_date t skip
set line_count $ln_cnt
set fxdln [expr 56 - $line_count]
#puts $fxdln
  if {$line_count >= 56} {
	set lp 0
        if {$fxdln > 0} {
           while {$fxdln > $lp} {
                puts $new_file "  \\\\"
                set lp [expr $lp + 1]
           }
        }
    puts $new_file "\\end{tabular}"
    puts $new_file "\\begin{center} Page $page_number \\end{center}"
    puts $new_file "\\pagebreak"
    puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
    puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
    puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"
    puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
    puts $new_file "\\begin{tabular}{p{5cm}p{5cm}rrrrl} \\"
    puts $new_file "\\noindent"

puts $new_file "\\parbox{4cm}{MERCHANT} & \\parbox{4cm}{QUALIFICATION} & \\parbox{1cm}{COUNT} & \\parbox{2.4cm}{TRANS AMOUNT} & \\parbox{2cm}{INTERCHANGE} & \\parbox{2cm}{NET AMOUNT} & \\parbox{1cm}{} \\\\"

    set page_number [expr $page_number + 1]
    puts $new_file " $t(ENTITY_NAME)\\\\"
    puts $new_file " $t(ENTITY_ID)\\\\"
    set skip "y"

 }
}

proc pgbrk2 {ln_cnt} {
global line_count page_number new_file name_date_month date_day header_date t skip
set line_count $ln_cnt
set fxdln [expr 56 - $line_count]
#puts $fxdln
  if {$line_count >= 56} {
        set lp 0
        if {$fxdln > 0} {
           while {$fxdln > $lp} {
                puts $new_file "  \\\\"
                set lp [expr $lp + 1]
           }
        }
    puts $new_file "\\end{tabular}"
    puts $new_file "\\begin{center} Page $page_number \\end{center}"
    puts $new_file "\\pagebreak"
    puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
    puts $new_file "\\begin{center} DAILY INTERCHANGE QUALIFICATION REPORT \\end{center}"
    puts $new_file "\\begin{center} $name_date_month $date_day, $header_date\\end{center}"
    puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
    puts $new_file "\\begin{tabular}{p{5cm}p{5cm}rrrrl} \\"
    puts $new_file "\\noindent"

puts $new_file "\\parbox{4cm}{MERCHANT} & \\parbox{4cm}{QUALIFICATION} & \\parbox{1cm}{COUNT} & \\parbox{2.4cm}{TRANS AMOUNT} & \\parbox{2cm}{INTERCHANGE} & \
\parbox{2cm}{NET AMOUNT} & \\parbox{1cm}{} \\\\"

    set page_number [expr $page_number + 1]
   # set skip "y"

 }
}
#set skip "n"

while {[set k [orafetch $test_cursor1 -dataarray t -indexbyname]] != 1403} {
set skip "n"

if {$t(ENTITY_ID) != $nextent_id} {
set putmtot 1
} else {
set putmtot 2
}

if {$t(ENTITY_ID) != $nextent_id || $t(CARD_SCHEME) != $cs} {
set putvtot 1
} else {
set putvtot 2
}

if {$putvtot == "1"} {
if {$vs_tot_cnt != "0"} {
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file " & {\\bfseries VS TOTAL} & {\\bfseries $vs_tot_cnt} & {\\bfseries $vs_tot_amt} & {\\bfseries $vs_tot_int} & {\\bfseries $vs_tot_net} \\\\"
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
set line_count [expr $line_count + 1]
if {$line_count >= 56} {
pgbrk2 $line_count
puts $new_file $e_name
puts $new_file $e_id
set line_count 7
}
set vs_tot_amt 0
set vs_tot_cnt 0
set vs_tot_net 0
set vs_tot_int 0
}
}

if {$putmtot == "1"} {
if {$mc_tot_cnt != "0"} {
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file " & {\\bfseries MC TOTAL} & {\\bfseries $mc_tot_cnt} & {\\bfseries $mc_tot_amt} & {\\bfseries $mc_tot_int} & {\\bfseries $mc_tot_net} \\\\"
puts $new_file "\\\\ & {\\bfseries TOTAL} & {\\bfseries [expr $v_tot_cnt + $m_tot_cnt]} & {\\bfseries [expr $v_tot_amt + $m_tot_amt]} & {\\bfseries [expr $v_tot_int + $m_tot_int]} & {\\bfseries [expr $v_tot_net + $m_tot_net]} \\\\"
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
set skip "n"
set line_count [expr $line_count + 1]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set mc_tot_amt 0
set mc_tot_cnt 0
set mc_tot_net 0
set mc_tot_int 0
set m_tot_amt 0
set m_tot_cnt 0
set m_tot_net 0
set m_tot_int 0
set v_tot_amt 0
set v_tot_cnt 0
set v_tot_net 0
set v_tot_int 0
}
}

if {$t(ENTITY_ID) != $nextent_id} {
if {[expr $v_tot_cnt + $m_tot_cnt] != 0} {
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file "\\\\ & {\\bfseries TOTAL} & {\\bfseries [expr $v_tot_cnt + $m_tot_cnt]} & {\\bfseries [expr $v_tot_amt + $m_tot_amt]} & {\\bfseries [expr $v_tot_int + $m_tot_int]} & {\\bfseries [expr $v_tot_net + $m_tot_net]} \\\\"
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set v_tot_amt 0
set v_tot_cnt 0
set v_tot_net 0
set v_tot_int 0

}
set line_count [expr $line_count + 1]

if {$skip == "n" && $line_count != "54"} {
set e_name " $t(ENTITY_NAME)\\\\"
set e_id " $t(ENTITY_ID)\\\\"
puts $new_file " $t(ENTITY_NAME)\\\\"
puts $new_file " $t(ENTITY_ID)\\\\"
} else {
set skip "n"
}

if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}

set nextent_id $t(ENTITY_ID)
set trn_cnt 0
set trn_amt 0
set trn_int_amt 0
set trn_net_amt 0
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}

}



if {$t(TID_SETTL_METHOD) == "C"} {
   set t(AMT) [expr $t(AMT) * -1]
   set t(INT) [expr $t(INT) * -1]
} 
if {[string range $t(TID) 0 7] == "01000402"} {
set trn_net_amt [expr $t(AMT) - $t(INT)]
} else {
set t(AMT) 0
set t(CNT) 0
set trn_net_amt [expr $t(AMT) - $t(INT)]
} 

set t(MAS_DESC) [string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} "$t(MAS_DESC)"]


puts $new_file " & $t(MAS_DESC) & $t(CNT) & $t(AMT) & $t(INT) & $trn_net_amt \\\\"
set line_count [expr $line_count + 1]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
#puts " & $t(MAS_DESC) & $t(CNT) & $t(AMT) & $t(INT) & $trn_net_amt \\\\"



if {$t(CARD_SCHEME) == "04"} {
set vs_tot_amt [expr $vs_tot_amt + $t(AMT)]
set vs_tot_cnt [expr $vs_tot_cnt + $t(CNT)]
set vs_tot_int [expr $vs_tot_int + $t(INT)]
set vs_tot_net [expr $vs_tot_net + $trn_net_amt]
set vs_gtot_amt [expr $vs_gtot_amt + $t(AMT)]
set vs_gtot_cnt [expr $vs_gtot_cnt + $t(CNT)]
set vs_gtot_int [expr $vs_gtot_int + $t(INT)]
set vs_gtot_net [expr $vs_gtot_net + $trn_net_amt]
set v_tot_amt [expr $v_tot_amt + $t(AMT)]
set v_tot_cnt [expr $v_tot_cnt + $t(CNT)]
set v_tot_int [expr $v_tot_int + $t(INT)]
set v_tot_net [expr $v_tot_net + $trn_net_amt]
} elseif {$t(CARD_SCHEME) == "05"} {
set mc_tot_amt [expr $mc_tot_amt + $t(AMT)]
set mc_tot_cnt [expr $mc_tot_cnt + $t(CNT)]
set mc_tot_int [expr $mc_tot_int + $t(INT)]
set mc_tot_net [expr $mc_tot_net + $trn_net_amt]
set mc_gtot_amt [expr $mc_gtot_amt + $t(AMT)]
set mc_gtot_cnt [expr $mc_gtot_cnt + $t(CNT)]
set mc_gtot_int [expr $mc_gtot_int + $t(INT)]
set mc_gtot_net [expr $mc_gtot_net + $trn_net_amt]
set m_tot_amt [expr $m_tot_amt + $t(AMT)]
set m_tot_cnt [expr $m_tot_cnt + $t(CNT)]
set m_tot_int [expr $m_tot_int + $t(INT)]
set m_tot_net [expr $m_tot_net + $trn_net_amt]

}

}
if {$mc_tot_cnt != "0"} {
puts $new_file "\\fontsize{7}{\\baselineskip}\\selectfont"
puts $new_file " & {\\bfseries MC TOTAL} & {\\bfseries $mc_tot_cnt} & {\\bfseries $mc_tot_amt} & {\\bfseries $mc_tot_int} & {\\bfseries $mc_tot_net} \\\\"
#puts $new_file " & MC TOTAL & $mc_tot_cnt & $mc_tot_amt & $mc_tot_int & $mc_tot_net \\\\"
set line_count [expr $line_count + 1]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
#set mc_tot_amt 0
#set mc_tot_cnt 0
#set mc_tot_net 0
}
if {$vs_tot_cnt != "0"} {
puts $new_file " & {\\bfseries VS TOTAL} & {\\bfseries $vs_tot_cnt} & {\\bfseries $vs_tot_amt} & {\\bfseries $vs_tot_int} & {\\bfseries $vs_tot_net} \\\\"
#puts $new_file " & VS TOTAL & $vs_tot_cnt & $vs_tot_amt & $vs_tot_int & $vs_tot_net \\\\"
set line_count [expr $line_count + 1]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
#set vs_tot_amt 0
#set vs_tot_cnt 0
#set vs_tot_net 0
}



if {$vs_tot_cnt != "0" || $mc_tot_cnt != "0"} {
puts $new_file "\\\\ & {\\bfseries TOTAL} & {\\bfseries [expr $v_tot_cnt + $m_tot_cnt]} & {\\bfseries [expr $v_tot_amt + $m_tot_amt]} & {\\bfseries [expr $v_tot_int + $m_tot_int]} & {\\bfseries [expr $v_tot_net + $m_tot_net]} \\\\"
#puts $new_file "\\\\ & TOTAL & [expr $vs_tot_cnt + $mc_tot_cnt] & [expr $vs_tot_amt + $mc_tot_amt] & [expr $vs_tot_int + $mc_tot_int] & [expr $vs_tot_net + $mc_tot_net] \\\\"
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set vs_tot_amt 0
set vs_tot_cnt 0
set vs_tot_net 0
set vs_tot_int 0
}

if {$vs_gtot_cnt != "0"} {
puts $new_file "\\\\ & {\\bfseries VS GRAND TOTAL} & {\\bfseries $vs_gtot_cnt} & {\\bfseries $vs_gtot_amt} & {\\bfseries $vs_gtot_int} & {\\bfseries $vs_gtot_net} \\\\"
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set vs_tot_amt 0
set vs_tot_cnt 0
set vs_tot_net 0
set vs_tot_int 0
}
if {$mc_gtot_cnt != "0"} {
puts $new_file "\\\\ & {\\bfseries MC GRAND TOTAL} & {\\bfseries $mc_gtot_cnt} & {\\bfseries $mc_gtot_amt} & {\\bfseries $mc_gtot_int} & {\\bfseries $mc_gtot_net} \\\\"
set line_count [expr $line_count + 2]
if {$line_count >= 56} {
pgbrk $line_count
set line_count 7
}
set mc_tot_amt 0
set mc_tot_cnt 0
set mc_tot_net 0
set mc_tot_int 0
}

if {$mc_gtot_cnt != "0"} {
puts $new_file "\\\\ & {\\bfseries GRAND TOTAL} & {\\bfseries [expr $mc_gtot_cnt + $vs_gtot_cnt]} & {\\bfseries [expr $mc_gtot_amt + $vs_gtot_amt]} & {\\bfseries [expr $mc_gtot_int + $vs_gtot_int]} & {\\bfseries [expr $mc_gtot_net + $vs_gtot_net]} \\\\"
set line_count [expr $line_count + 2]
set mc_tot_amt 0
set mc_tot_cnt 0
set mc_tot_net 0
set mc_tot_int 0
}

puts $new_file "\\\\"
set line_count [expr $line_count + 1]
set fxdln [expr 56 - $line_count]
set lp 0
        if {$fxdln > 0} {
           while {$fxdln >= $lp} {
                puts $new_file "  \\\\"
                set lp [expr $lp + 1]
           }
        }
puts $new_file "\\end{tabular}"
puts $new_file "\\begin{center} Page $page_number \\end{center}"
puts $new_file "\\end{document}"

close $new_file

exec pdflatex -interaction nonstopmode $new_file_name

#exec scp $pdf_file_name filemgr@dfw-prd-trn-06:./IQR
catch {exec scp  $pdf_file_name filemgr@dfw-adm-web-07:./IQR } resultiqr
if  { [string range $resultiqr 0 5 ] == "Kernel"} {
    puts $resultiqr
} else {
  puts "scp  $pdf_file_name filemgr@dfw-adm-web-07:./IQR "
}

exec uuencode $pdf_file_name "/$pdf_file_name" > dummy.uuencode

exec cat body.txt dummy.uuencode | mailx -r clearing@jetpay.com -s "101-QUALIFICATION Summary Reports for $fdate" clearing@jetpay.com
#josh@jetpay.com veronica@jetpay.com
exec mv ./$pdf_file_name ./ARCHIVE/$pdf_file_name
exec rm 101.QUALIFICATION-SUMM_$fdate.aux 101.QUALIFICATION-SUMM_$fdate.log
exec rm $new_file_name


