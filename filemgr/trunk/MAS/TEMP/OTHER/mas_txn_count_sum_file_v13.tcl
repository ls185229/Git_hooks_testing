#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size for MSG detail to 200 bytes.
#revised 20060426 with expected version of 36.0 



#package require Oratcl
package require Oratcl
package provide random 1.0

set user [lindex $argv 0]
set pw [lindex $argv 1]
set user1 [lindex $argv 2]
set pw1 [lindex $argv 3]
set ins_id [lindex $argv 4]
set s_name [lindex $argv 5]
set currdate [lindex $argv 6]

set fname "COUNTING"
set dot "."
set jdate ""
set s_name [string toupper $s_name]

puts "========================================================================================" 

#DB SID NAME--------------------------------------------------
global authdb 
global base2db 
global dbhost 
global dbhost1

#set authdb "@transp1"
#set base2db "@transd"
#set dbhost "teihost"
#set dbhost1 "quikdraw"

set i 0
#DB SID AND SCHEME NAMES-------------------------------------------------
                set schme_sid [open "/clearing/filemgr/DB_SCHME/db_schme_sid_list.txt" "r+"]
                set line [split [set orig_line [gets $schme_sid] ] ,]
                while {$line != {}} {
                        set i 0
                        foreach val $line {
                        set a($i) $val 
                        set i [expr $i + 1]
                        }
                        if {$a(0) == "mas_txn_count_sum_file_v13.tcl"} {
                                set dbhost $a(1)
                                set authdb $a(2)
                                set dbhost1 $a(3)
                                set base2db $a(4)
                        }
                set line  [split [set orig_line [gets $schme_sid] ] ,]
                }


#TABLE NAMES-----------------------------------------------------

#set authdb "@transp1"
#set base2db "@transd"
#set dbhost "teihost"
#set dbhost1 "masclr"

set tblnm_mm "$dbhost.master_merchant"

set tblnm_mr "$dbhost.merchant"
#puts $tblnm_mr
set tblnm_tn "$dbhost.transaction"
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"

global currdate
global adate
global sdate
global rdate
global jdate


set sdate [clock format [ clock scan "$currdate" ] -format %Y%m%d]
set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
#set rdate [clock format [ clock scan "$currdate -2 day" ] -format %Y%m%d]
#puts "$sdate $adate $rdate \n"


set begint "020000"
set endt "015959"

set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
#puts $rightnow

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
#puts $jdate
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]
#puts $jdate


#INPUT VARIABLES-------------------

if {$argc != 7} {

#DB SID NAME--------------------------------------------------
#set authdb "@transp1"
#set base2db "@transr"
#set dbhost "teihost"
#set dbhost1 "DATABASE"


puts "Total number of arguments needed is 9 got $argc"
puts "INST ID , USER, PW , USER, PW, DATE"
puts ""
puts ""

puts "ENTER USER NAME FROM TEIHOST DB"
set user [gets stdin]
puts "ENTER PASSWORD FROM TEIHOST DB"
set pw [gets stdin]
puts "ENTER CONNECTING DATABASE NAME FOR TEIHOST AS \'@TRANSB\'"
set authdb [gets stdin]
puts "ENTER USER NAME FROM EFUND DB"
set user1 [gets stdin]
puts "ENTER PASSWORD FROM EFUND DB"
set pw1 [gets stdin]
puts "ENTER CONNECTING DATABASE NAME FOR EFUND AS \'@TRANSB\'"
set base2db [gets stdin]

puts "ENTER INSTITUTION ID PLEASE:"
set ins_id [gets stdin]
puts "ENTER SHORT NAME FOR THE MERCHANT"
set s_name [gets stdin]
set s_name [string toupper $s_name]

#DATE setup for file header batch header and output file with Jdate--------
set currdate ""
puts "ENTER THE BATCH DATE (AS SUCH FORMAT YYYYMMDD = 20051120)"
set currdate [gets stdin]

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]


#TIME setup for file header and output file
set begint ""
set endt ""

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set begint [gets stdin]

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set endt [gets stdin]


}


append begintime $adate $begint
append endtime $sdate $endt
puts "Transaction count between $begintime :: $endtime"



#Proc for array---------------------------------------------------------

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set y 0

#Opening connection to db--------------------------------------------------
if {[catch {set db_logon_handle [oralogon $user/$pw$authdb]} result]} {
        puts "$authdb efund boarding failed to run"
        exit
}

if {[catch {set db_login_handle [oralogon $user1/$pw1$base2db]} result]} {
        puts "$base2db efund boarding failed to run"
        #puts $user1/$pw1$base2db
        exit
}


#All the sql logon handles -------------------------------------------------
#Updating sequence number in $tblnm_sc.
set update_seq [oraopen $db_login_handle]
#pulling merchant information from teihost.merchant
set pull_mer_from_mer [oraopen $db_logon_handle]
#pulling master merchant information from teihost.master_merchant
set pull_mer_from_m_mer [oraopen $db_logon_handle]
set chk_sum [oraopen $db_logon_handle]
set entity_from_efund [oraopen $db_logon_handle]
set batch_count_sql [oraopen $db_logon_handle]
set batch_sum_sql [oraopen $db_logon_handle]
set entityefund [oraopen $db_logon_handle]
set test_id [oraopen $db_login_handle]
set mas_addr_sql [oraopen $db_login_handle]
set tt_bin_sql [oraopen $db_logon_handle]
set m_code_sql [oraopen $db_login_handle]
set inputtable $tblnm_tn

#Card type list-and sequence type list---------------------------------------
set card_type { " " VS MC AX DS DC JC }
set seq_type { batch_id file_id }

#Temp variable for total sum (tot) and total count (totitm)
set tot 0
set totitm 0
set f_seq 1
set fileno $f_seq 
set fileno [format %03s $f_seq]
set one "01"
set pth "/clearing/filemgr/MAS/"



#creating output file name----------------------
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile


#FILE HEADER--------------------------------------------------------
#Initializing total file amount and count
set totfileamt 0
set totfilecnt 0

#File header variables decleared-----------------------------------
set fhtrans_type [format %02s "FH"]
set file_type [format %-2s "01"]
set file_date_time [format %-016s $rightnow]
puts $file_date_time
set activity_source [format %-16s "TTLCSYSTEM"]
set activity_job_name [format %-8s "AUTHCNT"]
set suspend_level [format %-1s "B"]


#Creating the File Header string lenght 45 -----
append fh $fhtrans_type $file_type $file_date_time $activity_source $activity_job_name $suspend_level 
	if {[set l [string length $fh]] != 45} {
	puts "FILE HEADER LENGTH DID NO MATCH $fh"
	exit 1 
	} else {
		if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                puts stderr "Cannot open /duplog : $fileid"
		exit 2
       		 } else {
                puts $fileid $fh
                puts $fh
         	close $fileid
        	}
	}
#Transaction Request type list and action code list---
set r_type { 0100 0250 0260 0420 0220 0200 0400 0402}
set act_code { A D } 

#Pulling MMID from master merchant for certain SHORTNAME-----
set temp_sql "select mmid from $tblnm_mm where shortname = '$s_name'"
#puts $temp_sql
orasql $pull_mer_from_m_mer $temp_sql
#set mmer_cols [oracols $pull_mer_from_m_mer]


#-------------------------BATCH BODY------------------------------------------------
#WHILE LOOP for each MMID that can be found under same SHORTNAME-------------
while {[set loop [orafetch $pull_mer_from_m_mer -dataarray mmid -indexbyname]] == 0} {

#Pulling MMID MID VISA_ID from merchant table for each MMID got under SHORTNAME in Master merchant table.---
set temp_sql "select MMID, MID, VISA_ID from $tblnm_mr where mmid = '$mmid(MMID)'"
#puts $temp_sql
orasql $pull_mer_from_mer $temp_sql

while {[set loop1 [orafetch $pull_mer_from_mer -dataarray mid -indexbyname]] == 0} {
#load_array mid $x $mer_cols
#puts $x

set chk_sql "select count(amount) ckct, sum(amount) cksm from $tblnm_tn where mid = '$mid(MID)' and authdatetime >= '$begintime' and authdatetime <= '$endtime'"
orasql $chk_sum $chk_sql
set c [orafetch $chk_sum -dataarray chktot -indexbyname]
#BATCH HEADER-------------------------------------------------------------------
if {$chktot(CKCT) != 0} {
#Formating batch header batch sequence number------------------------------------------------------
if {$mmid(MMID) != ""} {
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
                puts "Using batch seq num: $bchnum"


#BATCH veriables decleared-----------------------
set 25spcs [format %-25s " "]
set 23spcs [format %-23s " "]
set bhtrans_type [format %02s "BH"]
set batch_curr [format %-3s "840"]
set activity_date_time_bh [format %-016s $endtime]
set merchantid [format %-30s $mid(VISA_ID)]
set inbatchnbr [format %09d $bchnum]
set infilenbr [format %09d $fileno]
set billind [format %1s "N"]
set orig_batch_id [format %-9s " "]
set orig_file_id [format %-9s " "]
set ext_batch_id $25spcs
set ext_file_id $25spcs 
set sender_id [format %-25s $mid(MID)]
set microfilm_nbr [format %-30s " "]
set institution_id [format %-10s " "]
set batch_capture_dt [format %-016s $endtime]
#Creating Batch Header line string length 64-------------
append bh $bhtrans_type $batch_curr $activity_date_time_bh $merchantid $inbatchnbr $infilenbr $billind $orig_batch_id $orig_file_id $ext_batch_id $ext_file_id $sender_id $microfilm_nbr $institution_id $batch_capture_dt
        if {[set l [string length $bh]] != 219} {
        puts "BATCH HEADER LENGTH DID NO MATCH $bh"
        } else {
		if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                	puts stderr "Cannot open : $fileid"
        	} else {
                	puts $fileid $bh
                	#puts $bh
			set bh ""
		}
          		close $fileid
}
	}
#Decleared temp card scheme---------------------------
set c_sch ""

#Nested FOR LOOP to get total transaction count and sum from each merchant transaction according to their card type 
#request type and approved or declined. ---------------------------------------------------------------------------
	foreach {type} $card_type { 
    		foreach {r_typ} $r_type {
      			foreach {act_typ} $act_code {
				#IF statement is for Approved the use one set of sql stmt or else other sets of sql stmt--
				if {$act_typ == "A"} {
#Sql string command for transaction count--------------------------------------------------------------------------
					set sql "select count(amount) ct, sum(amount) sm from $tblnm_tn where mid = '$mid(MID)' and authdatetime >= '$begintime' and authdatetime <= '$endtime' and action_code = '000' and card_type = '$type' and request_type = '$r_typ'" 
#puts $sql
orasql $batch_count_sql $sql
					orafetch $batch_count_sql -dataarray efcs -indexbyname
					#A switch to convert card types----------------
					switch $type {
					     "VS" {set c_sch "04"}
					     "MC" {set c_sch "05"}
					     "AX" {set c_sch "03"}
					     "DS" {set c_sch "08"}
					     "DC" {set c_sch "07"}
					     "JC" {set c_sch "09"}
					      default  {set c_sch "00"}
					}
#Sql string command for to fetch mascode for apropriate transaction request type, card type, action code type----
					orasql $m_code_sql "select mas_code from $tblnm_mfcg where card_scheme = '$c_sch' and request_type = '$r_typ' and action = '$act_typ'"
					orafetch $m_code_sql -dataarray mcd -indexbyname
					#Decleared temp TID for efund fee package---------------
					set tid "010070010000"
#Dcleared variables for MSG DETAIL section of MAS FILE----------------------------------------------------------
			set 25spcs [format %-25s " "]
			set 23spcs [format %-23s " "]
			set mgtrans_type [format %02s "01"]
			set trans_id [format %-12s $tid]
			set entity_id [format %-18s $mid(VISA_ID)]
			set card_scheme $c_sch
			set mas_code [format %-25s $mcd(MAS_CODE)]
			set mas_code_downgrade $25spcs
			set nbr_of_items [format %010s $efcs(CT)]
			set amt_original [format %012d [expr int([expr $efcs(SM) * 100])]]
			set add_cnt1 "0000000000"
			set add_amt1 "000000000000"
			set add_cnt2 "0000000000"
			set add_amt2 "000000000000"
			set trans_ref_data $23spcs
			set suspend_reason [format %-2s " "]
			set external_trans_id $25spcs
				#Creating MSG DETAIL mas log string lenght  200
				append b $mgtrans_type $trans_id $entity_id $card_scheme $mas_code $mas_code_downgrade $nbr_of_items $amt_original $add_cnt1 $add_amt1 $add_cnt2 $add_amt2 $external_trans_id $trans_ref_data $suspend_reason
				#Sending info to out file----------------------------------------------
                        #IF stmt for to check correct length for msg details------------------------------
                        if {[set l [string length $b]] != 200} {
                                puts "FILE HEADER LENGTH DID NO MATCH $b"
				exit 1
                        } else {
				if {$nbr_of_items != 0 } {
				if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                			puts stderr "Cannot open : $fileid"
					exit 2
        			} else {
                			puts $fileid $b
                			#puts $b
          				close $fileid
        			}
				}
			}
#Calculation totals from sum amount and transaction counts-----------------------
set tot [expr $tot + $efcs(SM)]
#puts "AMOUNT $tot"
set totbchamt $tot
set totitm [expr $totitm + $efcs(CT)]
#puts "CNT $totitm"
set bchcnt $totitm
set b ""
#Closing db connection----------------------------------------------------------
oracommit $db_logon_handle

			#ALL COMMENTS SAME AS ABOVE ONLY ACTION CODE TYPE IS NOT EQUAL TO 000---------------------------
			} else {
			orasql $batch_count_sql "select count(amount) dct, sum(amount) dsm from $tblnm_tn where mid = '$mid(MID)' and authdatetime >= '$begintime' and authdatetime <= '$endtime' and action_code != '000' and card_type = '$type' and request_type = '$r_typ'"
			orafetch $batch_count_sql -dataarray efdcs -indexbyname 
				switch $type {
				     "VS" {set c_sch "04"}
				     "MC" {set c_sch "05"}
				     "AX" {set c_sch "03"}
				     "DS" {set c_sch "08"}
				     "DC" {set c_sch "07"}
				     "JC" {set c_sch "09"}
				      default  {set c_sch "00"}
				}
			orasql $m_code_sql "select mas_code from $tblnm_mfcg where card_scheme = '$c_sch' and request_type = '$r_typ' and action = '$act_typ'"
			orafetch $m_code_sql -dataarray mcd -indexbyname
			
			set tid "010070010000"

			set 25spcs [format %-25s " "]
			set 23spcs [format %-23s " "]
			set mgtrans_type [format %02s "01"]
			set trans_id [format %-12s $tid]
			set entity_id [format %-18s $mid(VISA_ID)]
			set card_scheme $c_sch
			set mas_code [format %-25s $mcd(MAS_CODE)]
			set mas_code_downgrade $25spcs
			set nbr_of_items [format %010s $efdcs(DCT)]
			set amt_original [format %012d [expr int([expr $efdcs(DSM) * 100])]]
			set add_cnt1 "0000000000"
			set add_amt1 "000000000000"
			set add_cnt2 "0000000000"
			set add_amt2 "000000000000"
                        set trans_ref_data $23spcs
                        set suspend_reason [format %-2s " "]
			set external_trans_id $25spcs

			append b $mgtrans_type $trans_id $entity_id $card_scheme $mas_code $mas_code_downgrade $nbr_of_items $amt_original $add_cnt1 $add_amt1 $add_cnt2 $add_amt2 $external_trans_id $trans_ref_data $suspend_reason

                        #IF stmt for to check correct length for msg details------------------------------
                        if {[set l [string length $b]] != 200} {
                                puts "FILE HEADER LENGTH DID NO MATCH $b"
				exit 1
                        } else {
				if {$nbr_of_items != 0} {
				if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
		               		puts stderr "Cannot open /duplog : $fileid"
					exit 2
		        	} else {
		                	puts $fileid $b
		                	#puts $b
         				close $fileid
        			}
				}
			}

#Calculation totals from sum amount and transaction counts-----------------------
			set tot [expr $tot + $efdcs(DSM)]
			#puts "AMOUNT $tot"
			set totbchamt $tot
			set totitm [expr $totitm + $efdcs(DCT)]
			#puts "CNT $totitm"
			set bchcnt $totitm 
			set b ""
			#Closing db connection -------------------------------
			oracommit $db_logon_handle

			}
		}
	}
}
#BATCH TRAILER-------------------------------------------------------------
#Batch trailer variables---------------------------------------
set totbchamt [expr int([expr $totbchamt * 100])]
set bttrans_type [format %-2s "BT"]
set batch_amt [format %012d $totbchamt]
set batch_cnt [format %010d $bchcnt]
set batch_add_amt1 [format %012d "0"]
set batch_add_cnt1 [format %010d "0"]
set batch_add_amt2 [format %012d "0"]
set batch_add_cnt2 [format %010d "0"]

#Creating Batch trailer string length 68
	append bt $bttrans_type $batch_amt $batch_cnt $batch_add_amt1 $batch_add_cnt1 $batch_add_amt2 $batch_add_cnt2
                #IF stmt for to check correct length for msg details------------------------------
                if {[set l [string length $bt]] != 68} {
                        puts "BATCH TRAILER LENGTH DID NO MATCH $bt"
			exit 1
                } else {
			if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
		                puts stderr "Cannot open /duplog : $fileid"
				exit 2
        		} else {
                		puts $fileid $bt
                		puts $bt
          			close $fileid
        		}
		}
#calculating total for file trailer---------------------------------------
set totfileamt [expr $totfileamt + $tot]
set totfilecnt [expr $totfilecnt + $totitm]
set tot 0 
set totitm 0
set $totbchamt 0
set $bchcnt 0
set bt ""
set y [expr $y + 1]
}
}
}
#FILE TRAILER ----------------------------------------------------------------------------
set totfileamt [expr int([expr $totfileamt * 100])]
set totfilecnt [expr int($totfilecnt)]

#Variables for file trailer-----------------------------------------------------------
set fttrans_type [format %-2s "FT"]
set file_amt [format %012d $totfileamt]
set file_cnt [format %010d $totfilecnt]
set file_add_amt1 [format %012d "0"]
set file_add_cnt1 [format %010d "0"]
set file_add_amt2 [format %012d "0"]
set file_add_cnt2 [format %010d "0"]

#creating file trailer string lenght 68----------------------------------------------
append ft $fttrans_type $file_amt $file_cnt $file_add_amt1 $file_add_cnt1 $file_add_amt2 $file_add_cnt2

#closing db connection --------------------------------------
		oracommit $db_login_handle
#IF stmt for to check correct length for msg details------------------------------
                if {[set l [string length $ft]] != 68} {
                        puts "FILE TRAILER LENGTH DID NO MATCH $ft"
			exit 1
                } else {

			if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
       		         	puts stderr "Cannot open /duplog : $fileid"
				exit 2
        		} else {
                		puts $fileid $ft
                		#puts $ft
				set ft ""
          			close $fileid
        		}
		}
catch {exec  mv $outfile /clearing/filemgr/MAS/MAS_FILES/.} result

puts "File: $outfile move complete to archive" 
puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================
