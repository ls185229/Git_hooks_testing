#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: mas_debit_fee_file.tcl 3512 2015-09-22 21:33:12Z bjones $ 

#Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size for MSG detail to 200 bytes.
#revised 20060426 with expected version of 36.0 

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(IST_DB)
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
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


proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct



package require Oratcl
#package require Oratcl
package provide random 1.0

set fname "DEBITFEE"
set dot "."
set jdate ""
set totbchamt2 0

puts "========================================================================================" 

#DB SID NAME--------------------------------------------------
global authdb 
global base2db 
global dbhost 
global dbhost1

set base2db $env(IST_DB)
set authdb $env(ATH_DB)
#set dbhost "teihost"
set dbhost $env(ATH_DB_USERNAME)
#set dbhost1 "masclr"
set dbhost1 $env(IST_DB_USERNAME)


set i 0


#TABLE NAMES-----------------------------------------------------

#set authdb "@transp4"
#set base2db "@trnclr1"
#set dbhost1 "masclr"

set tblnm_mm "$dbhost.master_merchant"

set tblnm_mr "$dbhost.merchant"
#puts $tblnm_mr
set tblnm_tn "$dbhost.SETTLEMENT"
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"
set currdate [clock format [ clock scan "-0 day" ] -format %Y%m%d]
global currdate
global adate
global sdate
global rdate
global jdate


set sdate [clock format [ clock scan "$currdate" ] -format %m%d%y]
set adate [clock format [ clock scan "$currdate" ] -format %Y%m%d]


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
#set authdb "@transp4"
#set base2db "@transr"
#set dbhost "teihost"
#set dbhost1 "DATABASE"


#DATE setup for file header batch header and output file with Jdate--------
set currdate ""

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]


#TIME setup for file header and output file
set begint ""
set endt ""

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set begint 000000

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set endt 000000


}


append begintime $adate $begint
append endtime $adate $endt
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
if {[catch {set db_logon_handle [oralogon $authuser/$authpwd@$authdb]} result]} {
        puts "$authdb efund boarding failed to run"
        exit
} else {
        puts "COnnected"
}
if {[catch {set db_login_handle [oralogon $clruser/$clrpwd@$clrdb]} result]} {
        puts "$authdb efund boarding failed to run"
        exit
} else {
        puts "COnnected"
}


#All the sql logon handles -------------------------------------------------
#Updating sequence number in $tblnm_sc.
set update_seq [oraopen $db_login_handle]
#pulling merchant information from teihost.merchant
set pull_mer_from_mer [oraopen $db_logon_handle]
#pulling master merchant information from teihost.master_merchant
set pull_mer_from_m_mer [oraopen $db_login_handle]
set chk_sum [oraopen $db_login_handle]
set entity_from_efund [oraopen $db_logon_handle]
set batch_count_sql [oraopen $db_login_handle]
set batch_count_sql1 [oraopen $db_logon_handle]
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
set pth "/clearing/filemgr/DEBIT/"
set ins_id [lindex $argv 1]
set shortname [lindex $argv 0]



#creating output file name----------------------
append outfile $pth $ins_id $dot $fname $dot $one $dot $jdate $dot $fileno
puts $outfile


#FILE HEADER--------------------------------------------------------
#Initializing total file amount and count
set totfileamt 0
set totfileamt2 0
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
puts "creating file header"
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
#Pulling VISA_ID from sms_transaction_information -----
set temp_sql "select unique card_acceptor_id,unique_id from sms_transaction_information where settlement_date = '$sdate' and card_acceptor_id in (select entity_id from entity_to_auth where file_group_id = '$shortname' and institution_id = '$ins_id' and status = 'A') order by card_acceptor_id"
puts $temp_sql
orasql $pull_mer_from_m_mer $temp_sql
#set mmer_cols [oracols $pull_mer_from_m_mer]
set flag 1

#-------------------------BATCH BODY------------------------------------------------
#WHILE LOOP for each visa_id that can be found-------------
while {[set loop [orafetch $pull_mer_from_m_mer -dataarray visaid -indexbyname]] == 0} {
set flag 0

#Pulling MMID MID VISA_ID from merchant table for each MMID got under SHORTNAME in Master merchant table.---
set temp_sql "select MMID, MID, VISA_ID from $tblnm_mr where visa_id = '$visaid(CARD_ACCEPTOR_ID)'"
puts $temp_sql
orasql $pull_mer_from_mer $temp_sql

if {[set loop1 [orafetch $pull_mer_from_mer -dataarray mid -indexbyname]] == 0} {
#load_array mid $x $mer_cols
#puts $x

set chk_sql "select count(reimbursement_fee) ckct, sum(reimbursement_fee) cksm from sms_transaction_information where card_acceptor_id = '$visaid(CARD_ACCEPTOR_ID)' and settlement_date = '$sdate'"
puts $chk_sql
orasql $chk_sum $chk_sql
set c [orafetch $chk_sum -dataarray chktot -indexbyname]
#BATCH HEADER-------------------------------------------------------------------
if {$chktot(CKCT) != 0} {
#Formating batch header batch sequence number------------------------------------------------------
if {$mid(MMID) != ""} {
                # get and bump the file number
                set batch_num_file [open "/clearing/filemgr/DEBIT/mas_batch_num.txt" "r+"]
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
set sender_id [format %-25s " "]
#set sender_id [format %-25s $mid(MID)]
set microfilm_nbr [format %-30s " "]
set institution_id [format %-10s " "]
set batch_capture_dt [format %-016s $endtime]
puts "creating batch header"
#Creating Batch Header line string length 64-------------
append bh $bhtrans_type $batch_curr $activity_date_time_bh $merchantid $inbatchnbr $infilenbr $billind $orig_batch_id $orig_file_id $ext_batch_id $ext_file_id $sender_id $microfilm_nbr $institution_id $batch_capture_dt
        if {[set l [string length $bh]] != 219} {
        puts "BATCH HEADER LENGTH DID NO MATCH $bh"
        } else {
		if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                	puts stderr "Cannot open : $fileid"
        	} else {
                	puts $fileid $bh
                	puts $bh
			set bh ""
		}
          		close $fileid
}
	}
#Decleared temp card scheme---------------------------
set c_sch ""

#END OF HEADER MYKE

#Nested FOR LOOP to get total transaction count and sum from each merchant transaction according to their card type 
#request type and approved or declined. ---------------------------------------------------------------------------
				#IF statement is for Approved the use one set of sql stmt or else other sets of sql stmt--
#Sql string command for transaction count--------------------------------------------------------------------------
					set sql "select * from sms_transaction_information where card_acceptor_id = '$visaid(CARD_ACCEPTOR_ID)' and unique_id = '$visaid(UNIQUE_ID)'" 
puts $sql
orasql $batch_count_sql $sql
					while {[set loop [orafetch $batch_count_sql -dataarray efcs -indexbyname]] == 0} {
					#A switch to convert card types----------------
					     set c_sch "02"
					#Decleared temp TID for efund fee package---------------
					set tid "010003025101" 
                                        if {$efcs(DEBIT_CREDIT) == "D"} {
                                          set tid "010003025102"
                                        }

                                        set sql "select * from tranhistory where retrieval_no = '$efcs(RETR_REF_NUMBER)'"
                                        puts $sql
                                        orasql $batch_count_sql1 $sql
                                        if {[orafetch $batch_count_sql1 -dataarray efcs1 -indexbyname] != "" } {
                                          puts $efcs1(OTHER_DATA2)
                                          set first [string first NI: $efcs1(OTHER_DATA2)]

                                          if {$first != -1} {
                                            set end [string first ";" $efcs1(OTHER_DATA2) $first]
                                            set network_id [string range $efcs1(OTHER_DATA2) [expr $first + 3 ] [expr $end - 1]]
                                          }
                                        } else {
                                          set network_id 02
                                        }
                                        puts $network_id
                                        switch -- $network_id {
                                          02 {set mas_code "0102STARFEE"}
                                          08 {set mas_code "0102STARFEE"}
                                          10 {set mas_code "0102STARFEE"}
                                          11 {set mas_code "0102STARFEE"}
                                          12 {set mas_code "0102STARFEE"}
                                          15 {set mas_code "0102STARFEE"}
                                          09 {set mas_code "0102PULSEFEE"}
                                          19 {set mas_code "0102PULSEFEE"}
                                          17 {set mas_code "0102PULSEFEE"}
                                          27 {set mas_code "0102NYCEFEE"}
                                          18 {set mas_code "0102NYCEFEE"}
                                          03 {set mas_code "0102INTRLKFEE"}
                                          16 {set mas_code "0102MSTROFEE"}
					  04 {set mas_code "0102PULSEFEE"}
                                          13 {set mas_code "0102AFFNFEE"}
                                          20 {
                                                if {$mcd(SIC_CODE) == "4511" && ( $mcd(SIC_CODE) < "3000" || $mcd(SIC_CODE) > "3300" ) } {
                                                        set mas_code "0102ACCLFEE"
                                                } else {
                                                        set mas_code "0102ACCLFEE_AL"
                                                }
                                             }
                                          23 {set mas_code "0102NETSFEE"}
                                          24 {set mas_code "0102CU24FEE"}
                                          25 {set mas_code "0102ALSKOPFEE"}
                                          28 {set mas_code "0102SHAZAMFEE"}
                                          29 {set mas_code "0102EBTFEE"}
                                        }

#Dcleared variables for MSG DETAIL section of MAS FILE----------------------------------------------------------
			set 25spcs [format %-25s " "]
			set 23spcs [format %-23s " "]
			set mgtrans_type [format %02s "01"]
			set trans_id [format %-12s $tid]
			set entity_id [format %-18s $mid(VISA_ID)]
			set card_scheme "02"
			set mas_code [format %-25s $mas_code]
			set mas_code_downgrade $25spcs
			set nbr_of_items [format %010s 1]
                        puts [unoct $efcs(REIMBURSEMENT_FEE)]
			set amt_original [format %012d [unoct $efcs(TRANSACTION_AMOUNT)]]
			set add_cnt1 "0000000000"
			set add_amt1 "000000000000"
			set add_cnt2 "0000000001"
			set add_amt2 [format %012d [unoct $efcs(REIMBURSEMENT_FEE)]]
			set trans_ref_data $23spcs "$efcs(ARN)"
			set suspend_reason [format %-2s " "]
			set external_trans_id $25spcs
				#Creating MSG DETAIL mas log string lenght  200
				append b $mgtrans_type $trans_id $entity_id $card_scheme $mas_code $mas_code_downgrade $nbr_of_items $amt_original $add_cnt1 $add_amt1 $add_cnt2 $add_amt2 $external_trans_id $trans_ref_data $suspend_reason
puts $b
puts [string length $b]
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
set tot [expr $tot + [unoct $efcs(TRANSACTION_AMOUNT)]]
set totbchamt $tot
set totbchamt2 [expr [unoct $add_amt2]]
set totitm [expr $totitm + 1]
set bchcnt $totitm
set b ""
#Closing db connection----------------------------------------------------------
oracommit $db_logon_handle

}
puts "TEMP"
#BATCH TRAILER-------------------------------------------------------------
#Batch trailer variables---------------------------------------
set totbchamt [expr int([expr $totbchamt * 1])]
set bttrans_type [format %-2s "BT"]
set batch_amt [format %012d $totbchamt]
set batch_cnt [format %010d $bchcnt]
set batch_add_amt1 [format %012d "0"]
set batch_add_cnt1 [format %010d "0"]
set batch_add_amt2 [format %012d $totbchamt2]
set batch_add_cnt2 [format %010d $bchcnt]

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
set totfileamt2 [expr $totfileamt2 + $totbchamt2]
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
set totfileamt [expr int([expr $totfileamt * 1])]
set totfilecnt [expr int($totfilecnt)]

#Variables for file trailer-----------------------------------------------------------
set fttrans_type [format %-2s "FT"]
set file_amt [format %012d $totfileamt]
set file_cnt [format %010d $totfilecnt]
set file_add_amt1 [format %012d "0"]
set file_add_cnt1 [format %010d "0"]
set file_add_amt2 [format %012d $totfileamt2]
set file_add_cnt2 [format %010d $totfilecnt]

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
if {$flag == 1 } {
  exec rm $outfile
  set mbody "Script mas_debit_fee_file.tcl $shortname $ins_id Was not able to find any Debit fees"
###  exec echo "$mbody_l $sysinfo $mbody" | mailx -r clearing@jetpay.com -s "$msubj_l" clearing@jetpay.com
  exec echo "No Transaction" >> /clearing/filemgr/DEBIT/INST_$ins_id/UPLOAD/debit.skip
} else {
  catch {exec mv $outfile /clearing/filemgr/DEBIT/INST_$ins_id/UPLOAD/.} result
}

puts "File: $outfile move complete to upload" 
puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================
