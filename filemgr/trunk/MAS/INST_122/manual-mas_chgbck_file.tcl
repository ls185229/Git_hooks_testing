#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: $
# $Rev: $
################################################################################
#
# File Name:  manual-mas_chgbck_file.tcl
#
# Description:  This program generates a MAS chargeback file for the institution
#               through manual prompting.
#              
# Script Arguments:  s_name = ISO shortname associated with the institution.
#                             Required.
#                    inst_id = Institution ID.  Required.
#                    currdate = Run date (YYYYMMDD).  Required.
#
# Output:  MAS chargeback file for the institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
package provide random 1.0

#######################################################################################################################

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

#Institution Profile Information
set inst_name [open "$env(PWD)/inst_profile.cfg" "r+"]
set line [split [set orig_line [gets $inst_name] ] ,]
set inst_id [string trim [lindex $line 0]]
set vbin [string trim [lindex $line 1]]
set mbin [string trim [lindex $line 2]]
set ica [string trim [lindex $line 3]]
set cib [string trim [lindex $line 4]]
set edpt [string trim [lindex $line 5]]
set prdsn [string trim [lindex $line 6]]
set tstsn [string trim [lindex $line 7]]
set psrun [string trim [lindex $line 8]]
puts "$inst_id $vbin $mbin $ica $cib $edpt $prdsn $tstsn $psrun"

if {$psrun == "P"} {
set s_name $prdsn
} else {
set s_name $tstsn
}

if {$argc == 3} {
set s_name [lindex $argv 0]
set inst_id [string trim [lindex $argv 1]]
set currdate [lindex $argv 2]
} elseif {$argc == 2} {
set currdate [lindex $argv 1]
set inst_id [string trim [lindex $argv 0]]
} else {
set currdate [lindex $argv 0]
}

set ins_id $inst_id
set inst_dir "INST_$inst_id"
set subroot "MAS"
set locpth "/clearing/filemgr/$subroot/$inst_dir"
set fname "CHARGEBK"
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

set sdate [clock format [ clock scan "$currdate 0 day"] -format %Y%m%d]
set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %d-%b-%y]]
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


#Creating output file name
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
}


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
	set rec(mas_code_downgrade) $25spcs
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
                set batch_num_file [open "/clearing/filemgr/MAS/INST_101/mas_batch_num.txt" "r+"]
                gets $batch_num_file bchnum
                seek $batch_num_file 0 start
                if {$bchnum >= 999999999} {
                    puts $batch_num_file 1
                } else {
                puts $batch_num_file [expr $bchnum + 1]

                }
                close $batch_num_file
                puts "Using batch seq num: $bchnum"
return $bchnum
}


############
### MAIN ###
############

###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database
set get_ent "select * from ep_event_log where ems_item_type in ('CB1','CB2','RR1') and event_log_date like '$e_date%' and event_status in ('NOTIFY', 'NEW')"
#and event_log_date like '$e_date%'
puts $get_ent
orasql $clr_get1 $get_ent

###### Writing File Header into the Mas file
set rec(file_date_time) $rightnow
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
set sendemail 1

###### While Loop for to fetch records gathered by Sql Select get_info
while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
	set chk 1
	
	set get_sale "select * from in_draft_main where ARN = '$a(ARN)' and (MSG_TYPE = '500' or MSG_TYPE = '600') and src_inst_id = '$inst_id'"
	puts $get_sale
	orasql $clr_get2 $get_sale
	
	orafetch $clr_get2 -dataarray b -indexbyname
	
	set oerr [oramsg $clr_get2 rc]
	puts $oerr
	
	if {$oerr != 1403} {
		if {$a(INSTITUTION_ID) != $b(SRC_INST_ID)} {
				puts "Instituion_id mismatched between EMS TXN and Original TXN. EMS: $a(INSTITUTION_ID) !=  ORIG: $b(SRC_INST_ID) for ARN = '$a(ARN)'"
				set sendemail 0
				exec echo "Instituion_id mismatched between EMS TXN and Original TXN. EMS: $a(INSTITUTION_ID) !=  ORIG: $b(SRC_INST_ID)" >> $inst_id.cb.email
				exec echo $get_sale >> $inst_id.cb.email
		}
	
		###### Writing Batch Header Or Batch Trailer
		set chkmidt $b(MERCH_NAME)
		set totcnt 0
		set totamt 0
		set trlcnt 1
		
		set rec(batch_curr) "$b(TRANS_CCD)"
		set rec(activity_date_time_bh) $batchtime
		set rec(merchantid) "$b(MERCH_ID)"
		set rec(inbatchnbr) [pbchnum] 
		set rec(infilenbr)  1
		set rec(batch_capture_dt) $batchtime
		set rec(sender_id) $b(MERCH_NAME)
		set rec(institution_id) $b(SRC_INST_ID)
		
		write_bh_record $fileid rec
		
		
		###### Writing Massage Detail records
		set rec(entity_id) $b(MERCH_ID)
		set rec(card_scheme) $b(CARD_SCHEME)
		set rec(external_trans_id) $b(TRANS_SEQ_NBR)
		set rec(trans_ref_data) $b(ARN)
		puts ">$a(EMS_ITEM_TYPE)<"
		puts ">$b(CARD_SCHEME)<"
		
			switch $a(EMS_ITEM_TYPE) {
				"CB1"	{if {$b(CARD_SCHEME) == "04"} {
					set ms_cd "04CHGBCK"
					set mas_tid "010003015101"
					} elseif {$b(CARD_SCHEME) == "05"} {
					set mas_tid "010003015101"
					set ms_cd "05CHGBCK"
					}
					}
				"CR1"	{if {$b(CARD_SCHEME) == "04"} {
								set ms_cd "04CHGBCK"
								} elseif {$b(CARD_SCHEME) == "05"} {
								set ms_cd "05CHGBCK"
								}
								}
				"CB2"	{if {$b(CARD_SCHEME) == "04"} {
								set ms_cd "04CHGBCK"
					set mas_tid "010003015101"
								} elseif {$b(CARD_SCHEME) == "05"} {
								set ms_cd "05CHGBCK"
					set mas_tid "010003015101"
								}
					}
				"RR1"	{if {$b(CARD_SCHEME) == "04"} {
								set ms_cd "0204RREQ"
								set mas_tid "010103020102"
								} elseif {$b(CARD_SCHEME) == "05"} {
								set ms_cd "0205RREQ"
								set mas_tid "010103020102"
								}
					}
					default {puts "EMS_ITEM_TYPE not found >$a(EMS_ITEM_TYPE)<; exit 1"}
			}	
			set rec(trans_id) $mas_tid
				set rec(mas_code) $ms_cd
				set rec(nbr_of_items) "1"
				set rec(amt_original) $a(AMT_TRANS)
		
			write_md_record $fileid rec
		
			set totcnt [expr $totcnt + 1]
			set totamt [expr $totamt + $a(AMT_TRANS)]
		
			set ftotcnt [expr $ftotcnt + 1]
			set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
		puts "$totamt $ftotamt $totcnt $ftotcnt"
		
		
		###### Writing last batch Trailer Record
		if {$trlcnt == 1} {
				set rec(batch_amt) $totamt
				set rec(batch_cnt) $totcnt
				write_bt_record $fileid rec
				set totcnt 0
				set totamt 0
		}
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
	set result1 ""
}

if {$result1 == ""} {
catch {exec  mv $outfile $env(PWD)/ARCHIVE} result
	set err ""
	if {$err != ""} {
		set mbody "ERROR ON EXECUTING sch_cmd.tcl: \n $err"
		exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
	}
}

set result2 ""
if {$sendemail == 0} {
	puts $result2
	if {$result2 == ""} {
		exec rm $inst_id.cb.email
	}	 
}

puts "==============================================END OF FILE=============================================================="

