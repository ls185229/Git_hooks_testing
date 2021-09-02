#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: $
# $Rev: $
################################################################################
#
# File Name:  vs_mc_mas_dwngrde_file.tcl
#
# Description:  This program generates a MAS interchange downgrade file for the
#               institution
#              
# Script Arguments:  s_name = ISO shortname associated with the institution.
#                             Required.
#                    inst_id = Institution ID.  Required.
#                    currdate = Run date (YYYYMMDD).  Required.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
package provide random 1.0

set s_name [lindex $argv 0]
set inst_id [string trim [lindex $argv 1]]
set currdate [lindex $argv 2]
set ins_id $inst_id

set ins_id $inst_id
set inst_dir "INST_$inst_id"
set subroot "MAS"
set locpth "/clearing/filemgr/$subroot/$inst_dir"

#Environment variables
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

#System information variables
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

set fname "VSMCRCLS"
set dot "."
set jdate ""
set s_name [string toupper $s_name]

puts "========================================================================================" 

#Table names
set dbhost "teihost"
set dbhost1 "masclr"

set tblnm_mm "$dbhost.master_merchant"
set tblnm_mr "$dbhost.merchant"
set tblnm_tn "$dbhost.transaction"
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"

set sdate [clock format [ clock scan "$currdate 1 day"] -format %Y%m%d]
set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %b-%y]]
set lydate [clock format [ clock scan "$currdate" ] -format %m]

set begint "000000"
set endt "000000"
set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]

set begintime "000000"
set endtime "000000"

set begintime "to_char(last_day(sysdate - (to_char(sysdate, 'DD') + 2)), 'DD-MON-YYYY')"
set endtime "to_char(last_day(sysdate), 'DD-MON-YYYY')"

append batchtime $sdate $begint
puts "Transaction count between $begintime :: $endtime"


#Proc for array
proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set y 0

#Opening connection to db
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

#All the sql logon handles
set m_code_sql [oraopen $db_login_handle]
set auth_get [oraopen $db_logon_handle]
set clr_get [oraopen $db_login_handle]
set clr_get1 [oraopen $db_login_handle]
set clr_get2 [oraopen $db_login_handle]
set clr_get3 [oraopen $db_login_handle]
set clr_get4 [oraopen $db_login_handle]
set clr_get5 [oraopen $db_login_handle]

#Temp variable for output file name 
set f_seq 5
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

Creating output file name
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile

while {$hk == 1} {
	if {[set ex [file exists $env(PWD)/$outfile]] == 1} {
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
}

#Defining tcr records type , lenght and description below 
#Mas file Header Record 
set tcr(FH) {
	fhtrans_type			 2 a {File Header Transmission Type}
	file_type				 2 a {File Type}
	file_date_time			16 x {File Date and Time}
	activity_source			16 a {Activity Source}
	activity_job_name		 8 a {Activity Job name}
	suspend_level			 1 a {Suspend Level}
}

#Mas Batch Header Record  
set tcr(BH) {
	bhtrans_type			 2 a {Batch Header Transmission Type}
	batch_curr				 3 a {Currency of the batch}
	activity_date_time_bh	16 x {System date and time}
	merchantid				30 a {ID of the merchant}
	inbatchnbr				 9 n {Batch number}
	infilenbr				 9 n {File number}
	billind					 1 a {Non Activity Batch Header Fee}
	orig_batch_id			 9 a {Original Batch ID}
	orig_file_id			 9 a {Original File ID}
	ext_batch_id			25 a {External Batch ID}
	ext_file_id				25 a {External File ID}
	sender_id				25 a {Merchant ID for the batch}
	microfilm_nbr			30 a {Microfilm Locator number}
	institution_id			10 a {Institution ID}
	batch_capture_dt		16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record 
set tcr(BT) {
	bttrans_type			 2 a {Batch Trailer Transmission Type}
	batch_amt				12 n {Total Transaction Amount in a Batch}
	batch_cnt				10 n {Total Transaction count in a Batch}
	batch_add_amt1			12 n {Total additional1 amount in a Batch}
	batch_add_cnt1			10 n {Total additional1 count in a Batch}
	batch_add_amt2			12 n {Total additional2 amount in a Batch}
	batch_add_cnt2			10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record
set tcr(FT) {
	fttrans_type			 2 a {File Trailer Transmission Type}
	file_amt				12 n {Total Transaction Amount in a File}
	file_cnt				10 n {Total Transaction count in a File}
	file_add_amt1			12 n {Total additional1 amount in a File}
	file_add_cnt1			10 n {Total additional1 count in a File}
	file_add_amt2			12 n {Total additional2 amount in a File}
	file_add_cnt2			10 n {Total additional2 count in a File}
}

#Mas Massage Detail Record
set tcr(01) {
	mgtrans_type			 2 a {Message Deatail Transmission Type}
	trans_id				12 a {Unique Transmission identifier}
	entity_id				18 a {Internal entity id}
	card_scheme				 2 a {Card Scheme identifier}
	mas_code				25 a {Mas Code}
	mas_code_downgrade		25 a {Mas codes for Downgraded Transaction}
	nbr_of_items			10 n {Number of items in the transaction record}
	amt_original			12 n {Original amount of a Transaction}
	add_cnt1				10 n {Number of items included in add_amt1}
	add_amt1				12 n {Additional Amount 1}
	add_cnt2				10 n {Number of items included in add_amt2}
	add_amt2				12 n {Additional Amount 2}
	external_trans_id		25 a {The extarnal transaction id}
	trans_ref_data			23 a {Reference Data}
	suspend_reason			 2 a {The Suspend reason code}
}


#Procedure to construct TCR records with the above definitions
proc write_tcr {aname} {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}

    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
        switch -- $ftype {
            a { if {![info exists  a($fname)]} {
					set  a($fname) {}
                }
                set t [format "%-${flength}.${flength}s" $a($fname)]
                set result "$result$t"
              }
            n { if {![info exists  a($fname)] || ($fname == "filler")} {
                    set  a($fname) 0
                }
                set t [format "%0${flength}.${flength}d" $a($fname)]
                set result "$result$t"
              }
			x { if {![info exists  a($fname)]} {
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


#Procedure print_tcr Not used at the moment 
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
	set rec(institution_id) $a(institution_id)
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
	set rec(mas_code_downgrade) $a(mas_code_downgrade)
	set rec(nbr_of_items) $a(nbr_of_items)
	set rec(amt_original) $a(amt_original)
	set rec(add_cnt1) "0000000000"
	set rec(add_amt1) "000000000000"
	set rec(add_cnt2) "0000000000"
	set rec(add_amt2) "000000000000"
	set rec(trans_ref_data) $a(trans_ref_data)
	set rec(suspend_reason) [format %-2s " "]
	set rec(external_trans_id) $a(external_trans_id)

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
	puts stderr "Cannot open /duplog : $fileid"
	exit 1
}


#Procedure to control Batch numbers for Mas file
proc pbchnum {} {
	# get and bump the file number
	set batch_num_file [open "/clearing/filemgr/MAS/mas_batch_num.txt" "r+"]
	gets $batch_num_file bchnum
	seek $batch_num_file 0 start

	if {$bchnum >= 999999999} {
		puts $batch_num_file 1
	} else {
		puts $batch_num_file [expr $bchnum + 1]
	}
	close $batch_num_file
return $bchnum
}


############
### MAIN ###
############

###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database
set get_ent "select * from in_draft_main where (tid = '010133005101' or tid = '010133005102') and activity_dt >= $begintime and activity_dt < $endtime and sec_dest_inst_id = '$inst_id' and trans_clr_status is null"
puts $get_ent
orasql $clr_get1 $get_ent

###### Writing File Header into the Mas file
set rec(file_date_time) $batchtime
set rec(activity_source) "JETPAYLLC"
set rec(activity_job_name) "MAS"

write_fh_record $fileid rec

###### Declaring variables and intializing 
set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
set loop 1
set chk 0

###### While Loop for to fetch records gathered by Sql Select get_info
while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
	set chk 1
	
	if {$a(MAS_CODE) != "MAS001" || $a(MAS_CODE_DOWNGRADE) != "MAS001"} {
		###### Writing Batch Header Or Batch Trailer
		set chkmidt $a(MERCH_NAME)
		set totcnt 0
		set totamt 0
		set trlcnt 1
	
		set rec(batch_curr) "$a(TRANS_CCD)"
		set rec(activity_date_time_bh) $batchtime
		set rec(merchantid) "$a(MERCH_ID)"
		set rec(inbatchnbr) [pbchnum] 
		set rec(infilenbr)  1
		set rec(batch_capture_dt) $batchtime
		set rec(sender_id) $a(MERCH_NAME)
		set rec(institution_id) $a(SEC_DEST_INST_ID)
	
		write_bh_record $fileid rec
	
		###### Writing Massage Detail records
		set rec(entity_id) $a(MERCH_ID)
		set rec(card_scheme) $a(CARD_SCHEME)
		set rec(external_trans_id) $a(TRANS_SEQ_NBR)
		set rec(trans_ref_data) $a(ARN)
	
		if {$a(TID) == "010133005101"} {
			set mas_tid "010003005101"
		} elseif {$a(TID) == "010133005102"} {
			set mas_tid "010003005102"
		}

		set rec(trans_id) $mas_tid
		set rec(mas_code) $a(MAS_CODE)
		set rec(mas_code_downgrade) $a(MAS_CODE_DOWNGRADE)
		set rec(nbr_of_items) "1"
		set rec(amt_original) $a(AMT_TRANS)
	
		write_md_record $fileid rec
	
		set totcnt [expr $totcnt + 1]
		set totamt [expr $totamt + $a(AMT_TRANS)]
	
		set ftotcnt [expr $ftotcnt + 1]
		set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
	
		###### Writing last batch Trailer Record
		if {$trlcnt == 1} {
			set rec(batch_amt) $totamt
			set rec(batch_cnt) $totcnt
			write_bt_record $fileid rec
			set totcnt 0
			set totamt 0
		}
	} else {
		puts "TRANS_SEQ_NBR = $a(TRANS_SEQ_NBR)\nMAS_CODE = $a(MAS_CODE)\nMAS_CODE_DOWNGRADE = $a(MAS_CODE_DOWNGRADE)\n"
	}
}

###### Writing File Trailer Record
set rec(file_amt) $ftotamt
set rec(file_cnt) $ftotcnt

write_ft_record $fileid rec

###### Closing Output file 
close $fileid

puts $loop

if {$loop == 1403 && $chk == 0} {
    puts "No Txn"
    exec rm $outfile
    exit 0
} else {
	exec chmod 775 $outfile
}

set result1 ""

if {$result1 == ""} {
	set err ""
	if {$err != ""} {
		set mbody "ERROR ON EXECUTING sch_cmd.tcl: \n $err"
		exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
	}
}

puts "==============================================END OF FILE=============================================================="

