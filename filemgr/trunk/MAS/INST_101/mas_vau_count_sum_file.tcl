#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Written By Rifat Khan
#Jetpay LLC
#Older internal vertion 1.0 , Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size for MSG detail to 200 bytes.
#revised 20060426 with internal version 1.1 , expected version of 36.0
#
#Changed the complete code reformated for perfomance issue.
#revised 20061201 with internal verion 2.0
#


package require Oratcl
package provide random 1.0

#######################################################################################################################

####################### UPDATE BELOW FOR NEW INST ###############################

set s_name [lindex $argv 0]
set inst_id [string trim [lindex $argv 1]]
set currdate [lindex $argv 2]
#set inst_id "101"
#set ins_id $inst_id
#set s_name "JETPAY"
#set currdate "20061128"

####################### CHANGES STOPS HERE ######################################

set ins_id $inst_id
set inst_dir "INST_$inst_id"
set subroot "MAS"
set locpth "/clearing/filemgr/$subroot/$inst_dir"

##################################################################################



#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

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

set fname "VAUCOUNT"
set dot "."
set jdate ""
set s_name [string toupper $s_name]

puts "========================================================================================"

#TABLE NAMES-----------------------------------------------------

set dbhost "teihost"
set dbhost1 "masclr"

set tblnm_mm "$dbhost.master_merchant"
set tblnm_mr "$dbhost.merchant"
set tblnm_tn "$dbhost.transaction"
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"


set sdate [clock format [ clock scan "$currdate" ] -format %Y%m%d]
set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
set lydate [clock format [ clock scan "$currdate" ] -format %m]
#set rdate [clock format [ clock scan "$currdate -2 day" ] -format %Y%m%d]
#puts "$sdate $adate $rdate \n"


set begint "000000"
set endt "000000"
set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
#puts $rightnow

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
#puts $jdate
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]
#puts $jdate


#INPUT VARIABLES-------------------

if {$argc != 3} {

#DB SID NAME--------------------------------------------------

puts "Total number of arguments needed is 3 got $argc"
puts "Short name, institution_id, date"
puts ""
puts ""

puts "ENTER SHORT NAME FOR THE MERCHANT"
set s_name [gets stdin]
set s_name [string toupper $s_name]

puts "ENTER INSTITUTION ID PLEASE:"
set ins_id [gets stdin]

#DATE setup for file header batch header and output file with Jdate--------
set currdate ""
puts "ENTER THE BATCH DATE (AS SUCH FORMAT YYYYMMDD = 20051120)"
set currdate [gets stdin]

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]


puts "ENTER BEGIN DATE (AS SUCH FORMAT YYYYMMDD = 20051120)"
set startdate [gets stdin]

puts "ENTER END DATE (AS SUCH FORMAT YYYYMMDD = 20051120)"
set enddate [gets stdin]

set begintime "'$startdate'"
set endtime "'$enddate'"
append batchtime $sdate $begint

} else {

set begintime "to_char(last_day(sysdate - (to_char(sysdate, 'DD') + 2)), 'YYYYMMDD')"
set endtime "to_char(last_day(sysdate), 'YYYYMMDD')"

append batchtime $sdate $begint
puts "Transaction count between $begintime :: $endtime"


}


#Proc for array---------------------------------------------------------

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set y 0

#Opening connection to db--------------------------------------------------
if {[catch {set db_logon_handle [oralogon teihost/quikdraw@$authdb]} result]} {
        puts "$authdb efund boarding failed to run"
    set mbody "$authdb efund boarding failed to run"
    exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
}

if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        puts "$clrdb efund boarding failed to run"
        set mbody "$clrdb efund boarding failed to run"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
}


#All the sql logon handles -------------------------------------------------
set m_code_sql [oraopen $db_login_handle]
set auth_get [oraopen $db_logon_handle]
set auth_get1 [oraopen $db_logon_handle]
set clr_get [oraopen $db_login_handle]
set clr_get1 [oraopen $db_login_handle]

#Temp variable for output file name
set f_seq 1
set fileno $f_seq
set fileno [format %03s $f_seq]
set one "01"
set pth ""
set hk 1

#CHECKING FEB ON LEAP YEAR AND STOP RUNNING ON FEB 28

set chklpyear [clock seconds]
set chklpyear [clock format $chklpyear -format "%m%d"]

if {$chklpyear == "0228"} {
set get_dt "select to_char(last_day(sysdate), 'MMDD') as leap_yr_dt  from DUAL"
orasql $auth_get $get_dt
orafetch $auth_get -dataarray lp -indexbyname
    if {$lp(LEAP_YR_DT) == "0229"} {
        puts "leap year exiting counting run. This will be ran on tomorrow at Feb 29"
        set mbody "leap year exiting counting run. This will be ran on tomorrow at Feb 29"
        exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
        exit 0
    }
}







#Creating output file name----------------------
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile
puts $hk

while {$hk == 1} {
puts $hk
if {[set ex [file exists $env(PWD)/$outfile]] == 1} {
puts $ex
    set f_seq [expr $f_seq + 1]
    set fileno $f_seq
set fileno [format %03s $f_seq]
set one "01"
set pth ""
exec mv $outfile TEMP
set outfile ""
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile
set hk 1
} else {
set hk 0
}

if {[set ux [file exists $env(PWD)/MAS_FILES/$outfile]] == 1} {
        set f_seq [expr $f_seq + 1]
        set fileno $f_seq
set fileno [format %03s $f_seq]
set one "01"
set pth ""
exec mv $env(PWD)/MAS_FILES/$outfile $env(PWD)/TEMP
set outfile ""
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile
set hk 1
} else {
set hk 0
}
}


#Defining tcr records type , lenght and description below

#Mas file Header Record

set tcr(FH) {
    fhtrans_type             2 a {File Header Transmission Type}
    file_type            2 a {File Type}
    file_date_time          16 x {File Date and Time}
    activity_source         16 a {Activity Source}
    activity_job_name        8 a {Activity Job name}
    suspend_level            1 a {Suspend Level}
}

#Mas Batch Header Record

set tcr(BH) {
    bhtrans_type             2 a {Batch Header Transmission Type}
    batch_curr           3 a {Currency of the batch}
    activity_date_time_bh       16 x {System date and time}
    merchantid          30 a {ID of the merchant}
    inbatchnbr           9 n {Batch number}
    infilenbr            9 n {File number}
    billind              1 a {Non Activity Batch Header Fee}
    orig_batch_id            9 a {Original Batch ID}
    orig_file_id             9 a {Original File ID}
    ext_batch_id            25 a {External Batch ID}
    ext_file_id         25 a {External File ID}
    sender_id           25 a {Merchant ID for the batch}
    microfilm_nbr           30 a {Microfilm Locator number}
    institution_id          10 a {Institution ID}
    batch_capture_dt        16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record

set tcr(BT) {
    bttrans_type             2 a {Batch Trailer Transmission Type}
    batch_amt           12 n {Total Transaction Amount in a Batch}
    batch_cnt           10 n {Total Transaction count in a Batch}
    batch_add_amt1          12 n {Total additional1 amount in a Batch}
    batch_add_cnt1          10 n {Total additional1 count in a Batch}
    batch_add_amt2          12 n {Total additional2 amount in a Batch}
    batch_add_cnt2          10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record

set tcr(FT) {
    fttrans_type             2 a {File Trailer Transmission Type}
    file_amt            12 n {Total Transaction Amount in a File}
    file_cnt            10 n {Total Transaction count in a File}
    file_add_amt1           12 n {Total additional1 amount in a File}
    file_add_cnt1           10 n {Total additional1 count in a File}
    file_add_amt2           12 n {Total additional2 amount in a File}
    file_add_cnt2           10 n {Total additional2 count in a File}
}

#Mas Massage Detail Record

set tcr(01) {
    mgtrans_type             2 a {Message Deatail Transmission Type}
    trans_id            12 a {Unique Transmission identifier}
    entity_id           18 a {Internal entity id}
    card_scheme          2 a {Card Scheme identifier}
    mas_code            25 a {Mas Code}
    mas_code_downgrade      25 a {Mas codes for Downgraded Transaction}
    nbr_of_items            10 n {Number of items in the transaction record}
    amt_original            12 n {Original amount of a Transaction}
    add_cnt1            10 n {Number of items included in add_amt1}
    add_amt1            12 n {Additional Amount 1}
    add_cnt2            10 n {Number of items included in add_amt2}
    add_amt2            12 n {Additional Amount 2}
    external_trans_id       25 a {The extarnal transaction id}
    trans_ref_data          23 a {Reference Data}
    suspend_reason           2 a {The Suspend reason code}
}

#Procedure for construct tcr records according to above definitions.

proc write_tcr {aname} {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}

    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
        switch -- $ftype {
            a {
                if {![info exists  a($fname)]} {
                    set  a($fname) {}
                }
                set t [format "%-${flength}.${flength}s" $a($fname)]
                set result "$result$t"
            }
            n {
                if {![info exists  a($fname)] || ($fname == "filler")} {
                    set  a($fname) 0
                }
                set t [format "%0${flength}.${flength}d" $a($fname)]
                set result "$result$t"
            }
        x {
                if {![info exists  a($fname)]} {
                    set  a($fname) {}
                }
                set t [format "%-0${flength}.${flength}s" $a($fname)]
                set result "$result$t"
            }

        }

    }
    return $result
}

#Procedure read_tcr Not use at the moment

proc read_tcr {inrec aname } {
    global tcr
    upvar $aname a
    set l_tcr [string range $inrec 0 1]
    set cur_pos 0
    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
        set a [string range $cur_pos [expr $cur_pos + $flength - 1] ]
        set cur_pos [expr $cur_pos + $flength ]
    }
}

#Precedure print_tcr Not used at the moment

proc print_tcr {fd aname}  {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}
    foreach {fname flength ftype fdesc} $trc(${l_tcr}) {
        puts $fd [format "%25.25s >%s<" $fdesc $a($fname) ]
    }
}


#Below all Procedures write_??_record to assign values to the tcr fields and call write_tcr to constuct the tcr records

proc write_fh_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "FH"
    set rec(fhtrans_type) "FH"
    set rec(file_type) "01"
    set rec(file_date_time) $a(file_date_time)
    set rec(activity_source) $a(activity_source)
    set rec(activity_job_name) $a(activity_job_name)
    set rec(suspend_level) "B"
puts $fd [write_tcr rec]
}

proc write_bh_record {fd aname} {
    global tcr
    upvar $aname a
    set 25spcs [format %-25s " "]
    set 23spcs [format %-23s " "]
        set rec(tcr) "BH"
    set rec(bhtrans_type) "BH"
    set rec(batch_curr) $a(batch_curr)
    set rec(activity_date_time_bh) $a(activity_date_time_bh)
    set rec(merchantid) $a(merchantid)
    set rec(inbatchnbr) $a(inbatchnbr)
    set rec(infilenbr) $a(infilenbr)
    set rec(billind) "N"
    set rec(orig_batch_id) "         "
    set rec(orig_file_id) "         "
    set rec(ext_batch_id) $25spcs
    set rec(ext_file_id) $25spcs
    set rec(sender_id) $a(sender_id)
    set rec(microfilm_nbr) [format %-30s " "]
    set rec(institution_id) [format %-10s " "]
    set rec(batch_capture_dt) $a(batch_capture_dt)

    puts $fd [write_tcr rec]
}

proc write_md_record {fd aname} {
    global tcr
    upvar $aname a
    set 25spcs [format %-25s " "]
    set 23spcs [format %-23s " "]
    set rec(tcr) "01"
    set rec(mgtrans_type) "01"
    set rec(trans_id) $a(trans_id)
    set rec(entity_id) $a(entity_id)
    set rec(card_scheme) $a(card_scheme)
    set rec(mas_code) $a(mas_code)
    set rec(mas_code_downgrade) $25spcs
    set rec(nbr_of_items) $a(nbr_of_items)
    set rec(amt_original) $a(amt_original)
        set rec(add_cnt1) "0000000000"
        set rec(add_amt1) "000000000000"
        set rec(add_cnt2) "0000000000"
        set rec(add_amt2) "000000000000"
        set rec(trans_ref_data) $23spcs
        set rec(suspend_reason) [format %-2s " "]
        set rec(external_trans_id) $25spcs

    puts $fd [write_tcr rec]
}

proc write_bt_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "BT"
    set rec(bttrans_type) "BT"
    set rec(batch_amt) $a(batch_amt)
    set rec(batch_cnt) $a(batch_cnt)
    set rec(batch_add_amt1) [format %012d "0"]
    set rec(batch_add_cnt1) [format %010d "0"]
    set rec(batch_add_amt2) [format %012d "0"]
    set rec(batch_add_cnt2) [format %010d "0"]

    puts $fd [write_tcr rec]
}

proc write_ft_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "FT"
    set rec(fttrans_type) "FT"
    set rec(file_amt) $a(file_amt)
    set rec(file_cnt) $a(file_cnt)
    set rec(file_add_amt1) [format %012d "0"]
    set rec(file_add_cnt1) [format %010d "0"]
    set rec(file_add_amt2) [format %012d "0"]
    set rec(file_add_cnt2) [format %010d "0"]

    puts $fd [write_tcr rec]
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#Pulling Mas codes and building an array for later use.

set s "select * from MAS_FILE_CODE_GRP order by CARD_SCHEME, REQUEST_TYPE, ACTION"

orasql $m_code_sql $s

while {[set y [orafetch $m_code_sql -datavariable mscd]] == 0} {
set ms_cd [lindex $mscd 0]
set ind_cs [lindex $mscd 1]
set ind_rt [lindex $mscd 2]
set ind_ac [lindex $mscd 3]
set mas_cd($ind_cs-$ind_rt-$ind_ac) $ms_cd
}

#Opening Output file to write to

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
    puts stderr "Cannot open $outfile : $fileid"
    exit 1
}

#Procedure to control Batch numbers for Mas file

proc pbchnum {} {
                # get and bump the file number
                set batch_num_file [open "/clearing/filemgr/MAS/INST_101/mas_batch_num.txt" "r+"]
                gets $batch_num_file bchnum
                seek $batch_num_file 0 start
                if {$bchnum >= 999999999} {
                    puts $batch_num_file 1
                } else {
                puts $batch_num_file [expr $bchnum + 1]

                }
                close $batch_num_file
#                puts "Using batch seq num: $bchnum"
return $bchnum
}

set mid_list ""

########################################################################################################################
### MAIN ###############################################################################################################
########################################################################################################################


###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database

set get_ent "select mid, visa_id, mastercard_id, currency_code from $tblnm_mr where mmid in (select mmid from $tblnm_mm where shortname = '$s_name')"
orasql $auth_get $get_ent

while {[set x [orafetch $auth_get -dataarray  ent -indexbyname]] == 0} {
    set amid $ent(MID)
    set vs_id $ent(VISA_ID)
    set mc_id $ent(MASTERCARD_ID)
    set cur_cd $ent(CURRENCY_CODE)

    if {$vs_id == " " || $vs_id == ""} {
    if {$mc_id == " " || $mc_id == ""} {
        puts "$amid -- Merchant do not process VS or MC"
        #exit 1
    }
    set entity_id($amid) $mc_id
    set curr_cd($amid) $ent(CURRENCY_CODE)
    } else {
    set entity_id($amid) $vs_id
        set curr_cd($amid) $ent(CURRENCY_CODE)
    }

}

set get_mids "select mid from MERCHANT_FEE_FLAGS where STATUS = 'A' and VAU = 'Y' and institution_id = '$inst_id'"
catch {orasql $clr_get1 $get_mids} result

set i1 0


while {[set z [orafetch $clr_get1  -dataarray  mid1 -indexbyname]] == 0} {

      if {$i1 == 0} {
        append mid_list "'$mid1(MID)'"
        set i1 [expr $i1 + 1]
      } else {
        append mid_list ",'$mid1(MID)'"
        set i1 [expr $i1 + 1]
      }
}

if {$mid_list == ""} {
        puts "No merchants found with VAU = 'Y'."
        exec rm $outfile
        exit 0
} else {
puts $mid_list
}

set get_tids "select tid from TERMINAL where mid in ($mid_list)"
catch {orasql $auth_get1 $get_tids} result


set i2 0

while {[set q [orafetch $auth_get1 -dataarray tid1 -indexbyname]] == 0} {

      if {$i2 == 0} {
        append tid_list "'$tid1(TID)'"
        set i2 [expr $i2 + 1]
      } else {
        append tid_list ",'$tid1(TID)'"
        set i2 [expr $i2 + 1]
      }
}


###### Sql Select to get all merchants daily transations count and sum amount with grouped by  mid, card_type, request_type, decode (action_code,'000','A',
###### 'D') ond rder by mid

#set get_info "select mid, count(amount) as cnt, sum(amount) as amt, card_type, request_type, decode (action_code,'000','A','D') as status, substr(transaction_id, -3, 3) as recyl_num from $tblnm_tn where mid in ($mid_list) and authdatetime >= $begintime || '$begint' and authdatetime < $endtime || '$endt' and shipdatetime < $endtime || '$endt' and transaction_id like 'B00000%' and transaction_id like '%00_' and transaction_id like '%002' group by mid, card_type, request_type, decode (action_code,'000','A','D'), substr(transaction_id, -3, 3) order by mid"

#set get_info "select mid, count(1) as cnt, sum(amount) as amt, '00' as card_type, '0200' as request_type, 'A' as status, substr(authdatetime, 1, 8) as b_date from transaction where mid in (select mid from merchant where visa_id like '454045_85%' and active = 'A') and authdatetime >= '20071031000000' and authdatetime < '20071130000000' and shipdatetime < '20071130000000' group by mid, substr(authdatetime, 1, 8) order by mid"

#set get_info "select mid, count(unique substr(authdatetime, 1, 8)) as cnt, sum(amount) as amt, '00' as CARD_TYPE, '0200' as REQUEST_TYPE, 'A' as status from transaction where mid in ($mid_list) and authdatetime >= $begintime || '$begint' and authdatetime < $endtime || '$endt' and shipdatetime < $endtime || '$endt' and request_type in ('0100','0200','0220','0250','0400','0420')  group by mid order by mid"

set get_info "select (select mid from terminal where tid = f.mid) as mid,count(1) as cnt, sum(amount) as amt, '00' as CARD_TYPE, '0200' as REQUEST_TYPE, 'A' as status from batch_transaction b, batch_file f where b.job_id = f.job_id and b.job_id in (select unique job_id from batch_transaction where vau_reason <> ' ' and job_id in (select job_id from batch_file where submission_datetime >= $begintime || '$begint' and submission_datetime < $endtime || '$endt')) and b.vau_reason in ('V','A','C','E','Q') and f.mid in ($tid_list) group by mid order by mid"

puts $get_info

orasql $auth_get $get_info


###### Writing File Header into the Mas file

        set rec(file_date_time) $rightnow
        set rec(activity_source) "JETPAYLLC"
        set rec(activity_job_name) "AUTHCNT"

write_fh_record $fileid rec

###### Declaring Variables and intializing

set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
set onebatch a
###### While Loop for to fetch records gathered by Sql Select get_info

while {[set loop [orafetch $auth_get -dataarray a -indexbyname]] == 0} {
set onebatch 0

###### Writing Batch Header Or Batch Trailer
puts $a(MID)
 if {$chkmid != $a(MID)} {
   if {$chkmid != " "} {

        set rec(batch_amt) [expr int([expr $totamt * 100])]
        set rec(batch_cnt) $totcnt
    write_bt_record $fileid rec
    set chkmidt $a(MID)
    set totcnt 0
    set totamt 0
    set trlcnt 1
    set onebatch 1
    }

        set rec(batch_curr) "$curr_cd($a(MID))"
        set rec(activity_date_time_bh) $batchtime
        set rec(merchantid) "$entity_id($a(MID))"
        set rec(inbatchnbr) [pbchnum]
        set rec(infilenbr)  1
        set rec(batch_capture_dt) $batchtime
        set rec(sender_id) $a(MID)

 write_bh_record $fileid rec
 set chkmid $a(MID)
 }

###### Writing Massage Detail records

    set mas_tid "010070010008"

        set rec(trans_id) $mas_tid
        set rec(entity_id) $entity_id($a(MID))
#A switch to convert card types----------------
            switch $a(CARD_TYPE) {
              "VS" {set c_sch "04"}
              "MC" {set c_sch "05"}
              "AX" {set c_sch "03"}
              "DS" {set c_sch "08"}
              "DC" {set c_sch "07"}
              "JC" {set c_sch "09"}
                 default  {set c_sch "00"}
            }
        set rec(card_scheme) $c_sch
if {[set mcdchk $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))] != "IGNORE"} {
        set rec(mas_code) $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))
        set rec(nbr_of_items) $a(CNT)
        set rec(amt_original) [expr int([expr $a(AMT) * 100])]

    write_md_record $fileid rec

    set totcnt [expr $totcnt + $a(CNT)]
    set totamt [expr $totamt + $a(AMT)]

    set ftotcnt [expr $ftotcnt + $a(CNT)]
    set ftotamt [expr $ftotamt + $a(AMT)]
}
}

###### Writing last batch Trailer Record
if {$trlcnt == 1 || $onebatch == 0} {
        set rec(batch_amt) [expr int([expr $totamt * 100])]
        set rec(batch_cnt) $totcnt
        write_bt_record $fileid rec
        set totcnt 0
        set totamt 0
puts ">> here"
}
###### Writing File Trailer Record

        set rec(file_amt) [expr int([expr $ftotamt * 100])]
        set rec(file_cnt) $ftotcnt

    write_ft_record $fileid rec

###### Closing Output file

close $fileid

##########################################################################################################################
#################################### END CODE ############################################################################
##########################################################################################################################
catch {exec  mv $outfile $env(PWD)/MAS_FILES/.} result

puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================

