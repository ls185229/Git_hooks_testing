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

####################### CHANGES STOPS HERE ######################################

set ins_id $inst_id
set inst_dir "INST_P$inst_id"
set subroot "MAS"
set locpth "/clearing/filemgr/$subroot/$inst_dir"


##################################################################################



#Environment veriables.......

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

set fname "ARBDEBIT"
set ctfname "base2.exp.pd.rp.fd"
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

#set ctfdate [clock format [ clock scan "$currdate 0 day"] -format %m%d]
set sdate [clock format [ clock scan "$currdate 0 day"] -format %Y%m%d]
set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %d-%b-%y]]
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

set ctfdate [ clock scan "$currdate"  -base [clock seconds] ]
set ctfdate [clock format $ctfdate -format "%m%d"]
set ctfdate [string range $ctfdate 1 end]

set begintime "000000"
set endtime "000000"

append batchtime $sdate $begint
puts "Transaction count between $begintime :: $endtime"


array set ARB_ARNS {
24474745053004240139142 7338
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
set ctf "ctf"

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
append out_ctf_file $ctfname $dot $ins_id $dot $jdate $dot $fileno $dot $ctf
puts $outfile
puts $out_ctf_file
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

#Defining tcr records type , lenght and description below 

#Mas file Header Record 

set tcr(FH) {
	fhtrans_type			 2 a {File Header Transmission Type}
	file_type			 2 a {File Type}
	file_date_time			16 x {File Date and Time}
	activity_source			16 a {Activity Source}
	activity_job_name		 8 a {Activity Job name}
	suspend_level			 1 a {Suspend Level}
}

#CTF file Header Record

set tcr(FDH) {
        fdhtransCode                    2 n
        fdhprocessingBin                6 a
	fdhleadyrdigit			1 a
        fdhprocessingDate               4 a
        fdhreserved1                    6 a
        fdhsettlDate                    5 a
        fdhreserved2                    2 a
        fdhreleaseNum                   3 a
        fdhtestOption                   4 a
        fdhreserved3                   29 a
        fdhsecurityCode                 8 a
        fdhreserved4                    6 a
        fdhincomingFileId               3 a
        fdhreserved5                   89 a
}

#Mas Batch Header Record  

set tcr(BH) {
	bhtrans_type			 2 a {Batch Header Transmission Type}
	batch_curr			 3 a {Currency of the batch}
	activity_date_time_bh		16 x {System date and time}
	merchantid			30 a {ID of the merchant}
	inbatchnbr			 9 n {Batch number}
	infilenbr			 9 n {File number}
	billind				 1 a {Non Activity Batch Header Fee}
	orig_batch_id			 9 a {Original Batch ID}
	orig_file_id			 9 a {Original File ID}
	ext_batch_id			25 a {External Batch ID}
	ext_file_id			25 a {External File ID}
	sender_id			25 a {Merchant ID for the batch}
	microfilm_nbr			30 a {Microfilm Locator number}
	institution_id			10 a {Institution ID}
	batch_capture_dt		16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record 
	
set tcr(BT) {
	bttrans_type			 2 a {Batch Trailer Transmission Type}
	batch_amt			12 n {Total Transaction Amount in a Batch}
	batch_cnt			10 n {Total Transaction count in a Batch}
	batch_add_amt1			12 n {Total additional1 amount in a Batch}
	batch_add_cnt1			10 n {Total additional1 count in a Batch}
	batch_add_amt2			12 n {Total additional2 amount in a Batch}
	batch_add_cnt2			10 n {Total additional2 count in a Batch}
}

#CTF Batch Trailer Record

set tcr(FDBT) {
	fdbtransCode			4 a
	fdbtbin				6 n
	fdbtleadyrdigit                 1 n
  	fdbtprocessingDate              4 n
	fdbtdestinationAmount	       15 n
	fdbtmonetaryTransactionNum     12 n
  	fdbtbatchNum89			2 n
	fdbtbatchNum		        4 n
        fdbtnumberOfTCRs	       12 n
	fdbtreserved1            	6 n
	fdbtcenterBatchId80		4 a
	fdbtcenterBatchId       	4 n
	fdbtnumberOfTransactions	9 n
	fdbtreserved2		       18 n
	fdbtsourceAmount	       15 n
	fdbtreserved3                  15 n		
        fdbtreserved4                  15 n
        fdbtreserved5                  15 n
}


#Mas File Trailer Record

set tcr(FT) {
	fttrans_type			 2 a {File Trailer Transmission Type}
	file_amt			12 n {Total Transaction Amount in a File}
	file_cnt			10 n {Total Transaction count in a File}
	file_add_amt1			12 n {Total additional1 amount in a File}
	file_add_cnt1			10 n {Total additional1 count in a File}
	file_add_amt2			12 n {Total additional2 amount in a File}
	file_add_cnt2			10 n {Total additional2 count in a File}
}

#CTF File Trailer Record

set tcr(FDFT) {
	fdftransCode			4 a
	fdftbin				6 n
	fdftleadyrdigit			1 n
	fdftprocessingDate		4 n
	fdftdestinationAmount	       15 n
 	fdftmonetaryTransactionNum     12 n
        fdftbatchNum89                  2 n
        fdftbatchNum                    4 n
        fdftnumberOfTCRs               12 n
        fdftreserved1                   6 n
        fdftcenterBatchId               8 a
        fdftnumberOfTransactions        9 n
        fdftreserved2                  18 n
        fdftsourceAmount               15 n
        fdftreserved3                  15 n
        fdftreserved4                  15 n
        fdftreserved5                  15 n
}


#Mas Massage Detail Record

set tcr(01) {
	mgtrans_type			 2 a {Message Deatail Transmission Type}
	trans_id			12 a {Unique Transmission identifier}
	entity_id			18 a {Internal entity id}
	card_scheme			 2 a {Card Scheme identifier}
	mas_code			25 a {Mas Code}
	mas_code_downgrade		25 a {Mas codes for Downgraded Transaction}
	nbr_of_items			10 n {Number of items in the transaction record}
	amt_original			12 n {Original amount of a Transaction}
	add_cnt1			10 n {Number of items included in add_amt1}
	add_amt1			12 n {Additional Amount 1}
	add_cnt2			10 n {Number of items included in add_amt2}
	add_amt2			12 n {Additional Amount 2}
	external_trans_id		25 a {The extarnal transaction id}
	trans_ref_data			23 a {Reference Data}
	suspend_reason			 2 a {The Suspend reason code}
}

#CTF Message Detail Record

set tcr(02) {
	fd0transCode			4 n
	fd0destinationBin		6 n
	fd0sourceBin			6 n
	fd0reasonCode			4 a
	fd0countryCode			3 a
	fd0eventDate                    4 a
	fd0accountNumber	       16 a
     	fd0accountNumberExtension	3 n
 	fd0destinationAmount           12 n
	fd0destinationCurrencyCode      3 a
	fd0sourceAmount                12 n
	fd0sourceCurrencyCode 		3 n
	fd0arn			       23 a
	fd0messageText                 47 a
	fd0settlementFlag         	1 n
	fd0transIdentifer	       15 a
	fd0reserved1			1 n
	fd0centralProcessingDate    	4 n
	fd0reimbursementAttribute	1 n
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


proc write_tcr_ctf {aname} {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}

    foreach {fname flength ftype} $tcr(${l_tcr}) {
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


proc write_fdh_record {fd aname} {
    global tcr
    upvar $aname a
	set rec(tcr) "FDH"    
	set rec(fdhtransCode) "90"
        set rec(fdhprocessingBin) "457003"
        set rec(fdhleadyrdigit) "1"
        set rec(fdhprocessingDate) "5111"
 	set rec(fdhreserved1) [format %-6s " "]
	set rec(fdhsettlDate) [format %-5s " "]
        set rec(fdhreserved2) [format %-2s " "]
 	set rec(fdhreleaseNum) [format %-3s " "]
	set rec(fdhtestOption) [format %-4s " "]
        set rec(fdhreserved3) [format %-29s " "]
 	set rec(fdhsecurityCode) [format %-8s " "]
	set rec(fdhreserved4) [format %-6s " "]
	set rec(fdhincomingFileId) [ctfpbchnum]
        set rec(fdhreserved5] [format %-89s " "]

puts $fd [write_tcr_ctf rec]
}


proc write_fddet_record {fd aname} {
    global tcr
    upvar $aname a
        set rec(tcr) "02" 
	set rec(fd0transCode) "2000"
        set rec(fd0destinationBin) $a(fd0destinationBin)
        set rec(fd0sourceBin) $a(fd0sourceBin)
        set rec(fd0reasonCode) "0240"
	set rec(fd0countryCode) [format %-3s " "]
	set rec(fd0eventDate) "0421"
        set rec(fd0accountNumber) $a(fd0accountNumber)
   	set rec(fd0accountNumberExtension) [format %003d "0"]
	set rec(fd0destinationAmount) [format %012d "0"]
        set rec(fd0destinationCurrencyCode) [format %-3s " "]
	set rec(fd0sourceAmount) $a(fd0sourceAmount)
        set rec(fd0sourceCurrencyCode) "840"
	set rec(fd0arn) $a(fd0arn)
	set rec(fd0messageText) " FUNDS DISP FOR REPRESENTMENT                  "
	set rec(fd0settlementFlag) "0"
	set rec(fd0transIdentifer) $a(fd0transIdentifer)
	set rec(fd0reserved1) "0"
	set rec(fd0centralProcessingDate) "5111"
	set rec(fd0reimbursementAttribute) "0"

puts $fd [write_tcr_ctf rec]
}

proc write_fdbt_record {fd aname} {
    global tcr
    upvar $aname a
        set rec(tcr) "FDBT"
        set rec(fdbtransCode) "9100"
        set rec(fdbtbin) "457003"
        set rec(fdbtleadyrdigit) "1"
        set rec(fdbtprocessingDate) "5111"
        set rec(fdbtdestinationAmount) [format %015d "0"]
	set rec(fdbtmonetaryTransactionNum) $a(fdbtmonetaryTransactionNum)
	set rec(fdbtbatchNum89) "89"
	set rec(fdbtbatchNum) "5111"
	set rec(fdbtnumberOfTCRs) $a(fdbtnumberOfTCRs)
	set rec(fdbtreserved1) [format %006d "0"]
	set rec(fdbtcenterBatchId80) "0080"
	set rec(fdbtcenterBatchId) "5111"
	set rec(fdbtnumberOfTransactions) $a(fdbtnumberOfTransactions)
	set rec(fdbtreserved2) [format %018d "0"]
	set rec(fdbtsourceAmount) $a(fdbtsourceAmount)
	set rec(fdbtreserved3) [format %015d "0"]
        set rec(fdbtreserved4) [format %015d "0"]
        set rec(fdbtreserved5) [format %015d "0"]

puts $fd [write_tcr_ctf rec]
}


proc write_fdft_record {fd aname} {
    global tcr
    upvar $aname a
        set rec(tcr) "FDFT"
        set rec(fdftransCode) "9200"
        set rec(fdftbin) "457003"
        set rec(fdftleadyrdigit) "1"
        set rec(fdftprocessingDate) "5111"
        set rec(fdftdestinationAmount) [format %015d "0"]
        set rec(fdftmonetaryTransactionNum) $a(fdftmonetaryTransactionNum)
        set rec(fdftbatchNum89) "89"
        set rec(fdftbatchNum) "5111"
        set rec(fdftnumberOfTCRs) $a(fdftnumberOfTCRs)
        set rec(fdftreserved1) [format %006d "0"]
        set rec(fdftcenterBatchId) [format %-8s " "]
        set rec(fdftnumberOfTransactions) $a(fdftnumberOfTransactions)
        set rec(fdftreserved2) [format %018d "0"]
        set rec(fdftsourceAmount) $a(fdftsourceAmount)
        set rec(fdftreserved3) [format %015d "0"]
        set rec(fdftreserved4) [format %015d "0"]
        set rec(fdftreserved5) [format %015d "0"]

puts $fd [write_tcr_ctf rec]
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

if [catch {open $out_ctf_file {WRONLY CREAT APPEND}} fileid2] {
	puts stderr "Cannot open /duplog : $fileid2"
	exit 1
}


if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
}


#Procedure to control Batch numbers for Mas file

proc pbchnum {} {
global inst_dir
                # get and bump the file number
                set batch_num_file [open "./mas_batch_num.txt" "r+"]
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

#Procedure to control CTF Batch numbers for CTF Funds Disbursement File

proc ctfpbchnum {} {
global inst_dir
                # get and bump the file number
                set ctf_batch_num_file [open "./ctf_batch_num.txt" "r+"]
                gets $ctf_batch_num_file ctfbchnum
                seek $ctf_batch_num_file 0 start
                if {$ctfbchnum >= 998} {
                    puts $ctf_batch_num_file 901
                } else {
                puts $ctf_batch_num_file [expr $ctfbchnum + 1]

                }
                close $ctf_batch_num_file
                puts "Using batch seq num: $ctfbchnum"
return $ctfbchnum
}



########################################################################################################################
### MAIN ###############################################################################################################
########################################################################################################################


###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database


set get_ent " select in_draft_main.src_inst_id,
        in_draft_main.TRANS_SEQ_NBR,
        in_draft_baseii.ISS_BIN,
        in_draft_baseii.ACQ_BIN,
        in_draft_main.merch_id,
        in_draft_main.merch_name,
        in_draft_main.amt_trans,
        in_draft_main.PAN,
        in_draft_main.ARN,
        in_draft_baseii.TRANS_ID,
        in_draft_baseII.REIMB_ATTRIB,
        in_draft_main.TRANS_CCD,
        in_draft_main.SEC_DEST_INST_ID,
        in_draft_main.CARD_SCHEME
 from in_draft_main,
      in_draft_baseii
 where in_draft_main.trans_seq_nbr = in_draft_baseii.trans_seq_nbr AND
       in_draft_main.arn in ('24474745053004240139142')
and in_draft_baseii.ACQ_BIN is not null"

puts $get_ent

orasql $clr_get1 $get_ent


###### Writing File Header into the Mas file

set rec(file_date_time) $rightnow
set rec(activity_source) "JETPAYLLC"
set rec(activity_job_name) "MAS"

write_fh_record $fileid rec

###### Writing CTF File Header into the CTF file

write_fdh_record $fileid2 rec

###### Declearing Variables and intializing 

set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
set loop 1
set chk 0
set totmonetarycnt 0
set tottcrs 0
set tottxns 0
set totsrcamt 0
###### While Loop for to fetch records gathered by Sql Select get_info

while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
set chk 1

#set get_sale "select * from in_draft_main where ARN = '$a(ARN)' and MSG_TYPE = '500'"
#puts $get_sale
#orasql $clr_get2 $get_sale
#
#orafetch $clr_get2 -dataarray b -indexbyname

###### Get the pre-arb amount

set ARBAMT [array names ARB_ARNS -exact $a(ARN)]


###### Writing Batch Header Or Batch Trailer


	set chkmidt $a(MERCH_NAME)
	set totcnt 0
	set totamt 0
	set trlcnt 1

    set rec(batch_curr) "$a(TRANS_CCD)"
puts $rec(batch_curr)
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
    


    set mas_tid "010003010101"
    set rec(mas_code) "04ARBDBT"  

	
    set rec(trans_id) $mas_tid
    set rec(nbr_of_items) "1"
    set rec(amt_original) $ARB_ARNS($ARBAMT)

	write_md_record $fileid rec

    set totcnt [expr $totcnt + 1]
    set totamt [expr $totamt + $ARB_ARNS($ARBAMT)]

    set ftotcnt [expr $ftotcnt + 1]
    set ftotamt [expr $ftotamt + $ARB_ARNS($ARBAMT)]
    puts "$totamt $ftotamt $totcnt $ftotcnt"


###### Writing last batch Trailer Record
    if {$trlcnt == 1} {
        set rec(batch_amt) $totamt
        set rec(batch_cnt) $totcnt
        write_bt_record $fileid rec
        set totcnt 0
        set totamt 0
    }

####### Writing Message Detail Records for CTF

     set rec(fd0destinationBin) $a(ISS_BIN)
puts $a(ISS_BIN)
     set rec(fd0sourceBin) $a(ACQ_BIN)
     set rec(fd0accountNumber) $a(PAN)
     set rec(fd0sourceAmount)  $ARB_ARNS($ARBAMT)
     set rec(fd0arn) $a(ARN)
     set rec(fd0transIdentifer) $a(TRANS_ID)

	write_fddet_record $fileid2 rec

     set totmonetarycnt [expr $totmonetarycnt + 1]
     set tottcrs [expr $tottcrs + 1]
     set tottxns [expr $tottxns + 1]
     set totsrcamt [expr $totsrcamt + $ARB_ARNS($ARBAMT)]
	
}
###### Writing File Trailer Record

        set rec(file_amt) $ftotamt
        set rec(file_cnt) $ftotcnt

	write_ft_record $fileid rec

###### Writing Batch Trailer for CTF record

     	set tottcrs [expr $tottcrs + 1]
        set tottxns [expr $tottxns + 1]

	set rec(fdbtmonetaryTransactionNum) $totmonetarycnt
        set rec(fdbtnumberOfTCRs) $tottcrs
	set rec(fdbtnumberOfTransactions) $tottxns
	set rec(fdbtsourceAmount) $totsrcamt

	   write_fdbt_record $fileid2 rec

###### Writing File Trailer for CTF record

        set tottcrs [expr $tottcrs + 1]
        set tottxns [expr $tottxns + 1]

        set rec(fdftmonetaryTransactionNum) $totmonetarycnt
        set rec(fdftnumberOfTCRs) $tottcrs
        set rec(fdftnumberOfTransactions) $tottxns
        set rec(fdftsourceAmount) $totsrcamt

           write_fdft_record $fileid2 rec


###### Closing Output file 

close $fileid
close $fileid2

puts $loop

if {$loop == 1403 && $chk == 0} {
    puts "No Txn"
#    exec rm $outfile
    exit 0
} else {
exec chmod 775 $outfile

}


##########################################################################################################################
#################################### END CODE ############################################################################
##########################################################################################################################

puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================

