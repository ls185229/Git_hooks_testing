#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#######################################################################################
# $Id: mas_amex_settlement_file.tcl 4490 2018-02-22 23:14:58Z skumar $
# $Rev: 4490 $
#######################################################################################
#
# File Name:  mas_amex_settlement_file.tcl
#
# Description:  This program creates a MAS file for PIN DEBIT transactions.
#               Settlement Reporting Entity (SRE).
#
# Script Arguments:  shortname (e.g. JETPAYIS).  Required.
#                    institution_id (e.g. 107).  Required.
#                    date (YYMMDD, e.g. 20150913) Optional, defaults to today
#
# Output:  MAS file under ~/MAS/MAS_FILES/inst_id.AMEXTRAN.01.Jdate.Seq
#                                   e.g.: 107.AMEXTRAN.01.3267.978
#
# Return:   0 = Success
#          !0 = Exit with errors
#
#######################################################################################


# Older version 35.0
# Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size
# for MSG detail to 200 bytes.
# revised 20060426 with expected version of 36.0


package require Oratcl
#package require Oratcl
package provide random 1.0

set fname "AMEXTRAN"
set dot "."
set jdate ""

puts "========================================================================================"

#DB SID NAME--------------------------------------------------
global authdb
global base2db
global dbhost
global dbhost1
global db_userid db_pwd auth_db_userid auth_db_pwd

set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)
set db_userid $env(IST_DB_USERNAME)
set db_pwd $env(IST_DB_PASSWORD)
set auth_db_userid $env(ATH_DB_USERNAME)
set auth_db_pwd $env(ATH_DB_PASSWORD)
set dbhost teihost
set dbhost1 masclr
set i 0


#TABLE NAMES-----------------------------------------------------


set tblnm_mm "$dbhost.master_merchant"
set tblnm_mr "$dbhost.merchant"
#puts $tblnm_mr
set tblnm_tn "$dbhost.TRANHISTORY"
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"
global adate
global sdate
global rdate
global jdate

#INPUT VARIABLES-------------------

if {$argc != 2 && $argc != 3 } {
    puts "Usage: mas_amex_settlement_file.tcl MMSN INSTUTION_ID"
    puts "MMSN is the Master_Merchant ShortNames to be processed for this file."
    exit 1
}

set s_name [lindex $argv 0]

set inst_id [lindex $argv 1]
if {$argc == 3 } {
    set sdate [lindex $argv 2]
} else {
    set sdate [clock format [ clock scan "-0 day" ] -format %Y%m%d]
}

set adate [clock format [ clock scan "-0 day" ] -format %Y%m%d]
#puts "$sdate $adate $rdate \n"

puts "date: $sdate "

set begint "000000"
set endt "00000"

set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
#puts $rightnow

set jdate [ clock scan "-0 day"  -base [clock seconds] ]
#puts $jdate
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]
#puts $jdate

######################################
# Jobs Times Table Globals - NPP-7450
######################################
set job_script_name "mas_amex_settlement_file.tcl"
set job_source "TRANHISTORY"
set job_dest ""
set job_id_seq_gen_name "SEQ_JOB_EVENT_REC_ID"
set tran_id_seq_gen_name "SEQ_TRAN_EVENT_REC_ID"

#DB SID NAME--------------------------------------------------


#DATE setup for file header batch header and output file with Jdate--------

set jdate [ clock scan "-0 days"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]

#TIME setup for file header and output file
set begint ""
set endt ""

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set begint 000000

puts "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set endt 000000

append begintime $adate $begint
append endtime $sdate $endt
puts "Transaction count between $begintime :: $endtime"


# NPP-7450 ->
###############################################################################
# Procedure Name - generate_job_id
# Description    - Gets next job id from auth sequencer
###############################################################################
proc generate_job_id {} {
   global jte_job_id_crsr
   global job_id_seq_gen_name
   global job_id

   # set seq_name
   set seq_name $job_id_seq_gen_name
   
   set job_id_seq_query "select $seq_name.NEXTVAL from dual"

   if {[catch {orasql $jte_job_id_crsr $job_id_seq_query} result]} {
            puts "ERROR:- The sequence query did not run successfully. Please check the DB"
            puts "query - $job_id_seq_query, ERROR-$result"
   }
   if { [catch {orafetch $jte_job_id_crsr -datavariable result} failure] } {
      puts "Failed to get next Job ID using seqencer $seq_name, error: $failure"
   }
   set job_id $result
};# end generate_job_id


################################################################################
# Procedure Name - insert_tran_event
# Description    - Inserts Transaction Event Record into
#                  'Transaction_Events' Table
###############################################################################
proc insert_tran_event { other_data4 } {
   global jte_tran_insert_crsr
   global job_id
   global tran_id_seq_gen_name

   # set seq_name
   set seq_name $tran_id_seq_gen_name
   
   set insert_tran_event_sql "INSERT INTO TRANSACTION_EVENTS (
                    SEQ_ID, UNIQUE_ID, JOB_ID, 
                    TRANSACTION_TIMESTAMP
                    ) 
                  VALUES 
                    (
                    $seq_name.NEXTVAL, '$other_data4', 
                    '$job_id', CURRENT_TIMESTAMP
                    )"
    if { [catch {orasql $jte_tran_insert_crsr $insert_tran_event_sql} failure ] } {
       puts "Transaction Event Table SQL Insert Failure: $failure"
    }

};# insert_tran_event


################################################################################
# Procedure Name - insert_job_start_record
# Description    - performs sql insert to 'Transaction_Jobs' Table
###############################################################################
proc insert_job_record_start {} {
    global jte_job_insert_crsr
    global job_id
    global job_script_name
    global job_source
    global job_dest
   
    set insert_job_start_sql "INSERT INTO Transaction_Jobs (
                    Job_id, Job_Name, Source, Destination,
                    Start_time
                    ) 
                  VALUES 
                    (
                    '$job_id', '$job_script_name', 
                    '$job_source', '$job_dest', CURRENT_TIMESTAMP
                    )"
    if { [catch {orasql $jte_job_insert_crsr $insert_job_start_sql} failure ] } {
       puts "Job Start Event SQL Insert Failure: $failure"
    }

};# insert_job_start_record

################################################################################
# Procedure Name - update_job_start_record
# Description    - performs sql insert to 'Transaction_Jobs' Table
###############################################################################
proc update_job_record_end {} {
    global jte_job_update_crsr
    global job_id
   
    set update_job_end_sql "UPDATE Transaction_Jobs 
                            set End_Time = CURRENT_TIMESTAMP
                            where job_id = '$job_id'"

    if { [catch {orasql $jte_job_update_crsr $update_job_end_sql} failure ] } {
       puts "Job End Event SQL Update Failure: $failure"
    }

};# update_job_start_record
# NPP-7450 <-

#Proc for array---------------------------------------------------------
proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set y 0

#Opening connection to db--------------------------------------------------
if {[catch {set db_auth_handle [oralogon $auth_db_userid/$auth_db_pwd@$authdb]} result]} {
    puts "$authdb logon failed"
    exit
}
if {[catch {set db_masclr_handle [oralogon $db_userid/$db_pwd@$clrdb]} result]} {
    puts "$clrdb logon failed"
    exit
}

#All the sql logon handles -------------------------------------------------
#Updating sequence number in $tblnm_sc.
set update_seq [oraopen $db_masclr_handle]
#pulling merchant information from teihost.merchant
set pull_mer_from_mer [oraopen $db_auth_handle]
#pulling master merchant information from teihost.master_merchant
set pull_mer_from_m_mer [oraopen $db_auth_handle]
set chk_sum [oraopen $db_auth_handle]
set entity_from_efund [oraopen $db_auth_handle]
set batch_count_sql [oraopen $db_auth_handle]
set batch_sum_sql [oraopen $db_auth_handle]
set entityefund [oraopen $db_auth_handle]
set test_id [oraopen $db_masclr_handle]
set mas_addr_sql [oraopen $db_masclr_handle]
set tt_bin_sql [oraopen $db_auth_handle]
set m_code_sql [oraopen $db_masclr_handle]
set inputtable $tblnm_tn
# Jobs Times Table Cursors - NPP-7450
set jte_job_id_crsr        [oraopen $db_auth_handle]
set jte_job_insert_crsr    [oraopen $db_auth_handle]
set jte_job_update_crsr    [oraopen $db_auth_handle]
set jte_tran_insert_crsr   [oraopen $db_auth_handle]
set jte_trans_other4_crsr  [oraopen $db_auth_handle]

#Card type list-and sequence type list---------------------------------------
#set card_type { DB VS MC AX DS DC JC }
set card_type { AX }
set seq_type { batch_id file_id }

#Temp variable for total sum (tot) and total count (totitm)
set tot 0
set totitm 0
set totbchamt 0
set bchcnt 0
set f_seq 1
set fileno $f_seq
set fileno [format %03s $f_seq]
set one "01"
set pth "/clearing/filemgr/DEBIT/UPLOAD/"

# NPP-7450 ->
generate_job_id
insert_job_record_start
# NPP-7450 <-
#creating output file name----------------------
set flag 1
while {$flag == 1} {

    append filename "/clearing/filemgr/MAS/ARCHIVE/" $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno "*"
    puts $filename
    set filelist [glob -nocomplain $filename]
    set flag 0
    foreach file $filelist {
        set flag 1
        set f_seq [expr $f_seq + 1]
        set fileno $f_seq
        set fileno [format %03s $f_seq]
        set filename ""
    }
    puts "flag:$flag"
}

set filename ""
append filename $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno

while {[set ex [file exists /clearing/filemgr/MAS/MAS_FILES/$filename]] == 1} {
    puts "/clearing/filemgr/MAS/MAS_FILES/$filename"
    set f_seq [expr $f_seq + 1]
    set fileno $f_seq
    set fileno [format %03s $f_seq]
    set filename ""
    append filename $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
}

append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno

#FILE HEADER--------------------------------------------------------
#Initializing total file amount and count
set totfileamt 0
set totfilecnt 0

#File header variables declared-----------------------------------
set fhtrans_type [format %02s "FH"]
set file_type [format %-2s "01"]
set file_date_time [format %-016s $rightnow]
puts $file_date_time
set activity_source [format %-16s "TTLCSYSTEM"]
set activity_job_name [format %-8s "AMEXTRN"]
set suspend_level [format %-1s "T"]

#Creating the File Header string length 45 -----
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
        #puts $fh
        close $fileid
    }
}

#Transaction Request type list and action code list---
set r_type { 0200 0250 0220 0420}
set act_code { A D }
#set s_name JETPAYSQ


#-------------------------BATCH BODY------------------------------------------------

#Pulling MMID MID VISA_ID from merchant table for each MMID got under SHORTNAME in Master merchant table.---
set temp_sql "
    SELECT m.MMID, m.MID, m.VISA_ID, m.DEBIT_ID
    from merchant m 
    join master_merchant mm ON mm.MMID = m.MMID
    WHERE mm.SHORTNAME = '$s_name'"
puts $temp_sql
orasql $pull_mer_from_mer $temp_sql

while {[set loop1 [orafetch $pull_mer_from_mer -dataarray mid -indexbyname]] == 0} {
    #load_array mid $x $mer_cols
    #puts $x

    set chk_sql "
        select count(amount) ckct, sum(amount) cksm
        from $tblnm_tn
        where mid = '$mid(MID)'
        and card_type = 'AX'
        and status is not null
        and status <> 'AMX'
        and status <> 'CNA'
        and settle_date like '$sdate%'"
    
    puts $chk_sql
    orasql $chk_sum $chk_sql
    set c [orafetch $chk_sum -dataarray chktot -indexbyname]
    
    #puts "Myke1 $chktot(CKCT)"
    #BATCH HEADER-------------------------------------------------------------------
    if {$chktot(CKCT) != 0} {
        #puts "Myke1 $chktot(CKCT)"
        #Formating batch header batch sequence number------------------------------------------------------
        if {$mid(MMID) != ""} {
            # get and bump the file number
            set batch_num_file [open "/clearing/filemgr/DEBIT/mas_batch_num.txt" "r+"]
            gets $batch_num_file bchnum
            seek $batch_num_file 0 start
            if {$bchnum >= 999999999} {
                #puts $batch_num_file 1
            } else {
                #puts $batch_num_file [expr $bchnum + 1]
            }
            close $batch_num_file
            puts "Using batch seq num: $bchnum"

            #BATCH variables declared-----------------------
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
    }
        #Declared temp card scheme---------------------------
        set c_sch ""

        #END OF HEADER MYKE
        #puts "myke"
        #Nested FOR LOOP to get total transaction count and sum from each merchant transaction according to their card type
        #request type and approved or declined. ---------------------------------------------------------------------------
        foreach {type} $card_type {
            puts "$type"
            foreach {r_typ} $r_type {
                puts "$r_typ"
                foreach {act_typ} $act_code {
                    #puts "$act_typ"
                    #IF statement is for Approved the use one set of sql stmt or else other sets of sql stmt--
                    if {$act_typ == "A"} {
                        #Sql string command for transaction count--------------------------------------------------------------------------
                        set sql "
                            select *
                            from $tblnm_tn
                            where mid = '$mid(MID)'
                                and action_code = '000'
                                and request_type = '$r_typ'
                                and card_type = '$type'
                                and settle_date like '$sdate%'
                                and status is not null
                                and status <> 'AMX'
                                and status <> 'CNA'"
                        puts $sql
                        orasql $batch_count_sql $sql
							
                        while {[set loop [orafetch $batch_count_sql -dataarray efcs -indexbyname]] == 0} {
                            #A switch to convert card types----------------
                            set c_sch "03"
                            #Sql string command for to fetch mascode for apropriate transaction request type, card type, action code type----
                            #puts "select mas_code from $tblnm_mfcg where card_scheme = '$c_sch' and request_type = '$r_typ' and action = '$act_typ'"
                            #Setup mas_codes
                            orasql $chk_sum "select * from merchant where mid = '$mid(MID)'"
                            puts "select * from merchant where mid = '$mid(MID)'"
                            orafetch $chk_sum -dataarray mcd -indexbyname

                            # Declared TID for efund fee package---------------
                            switch [string range $efcs(REQUEST_TYPE) 0 1]  {
                                "02"    {set tid "010003005101"}
                                "04"    {set tid "010003005102"}
                                default {set tid "010003005101"}
                            }

                            #puts $efcs(OTHER_DATA2)
                            set first [string first NI: $efcs(OTHER_DATA2)]

                            if {$first != -1} {
                                set end [string first ";" $efcs(OTHER_DATA2) $first]
                                set network_id [string range $efcs(OTHER_DATA2) [expr $first + 3 ] [expr $end - 1]]
                            }
                            set mas_code "0103AX"

                            # Declared variables for MSG DETAIL section of MAS FILE---
                            set 25spcs [format %-25s " "]
                            set 23spcs [format %-23s " "]
                            set mgtrans_type [format %02s "01"]
                            set trans_id [format %-12s $tid]
                            set entity_id [format %-18s $mid(VISA_ID)]
                            set card_scheme $c_sch
                            set mas_code [format %-25s $mas_code]
                            set mas_code_downgrade $25spcs
                            set nbr_of_items [format %010s 1]
                            set amt_original [format %012d [expr wide(round($efcs(AMOUNT) * 100))]]
                            set add_cnt1 "0000000000"
                            set add_amt1 "000000000000"
                            set add_cnt2 "0000000000"
                            set add_amt2 "000000000000"
                            #set trans_ref_data [string range $efcs(ARN) 0 22]
                            set trans_ref_data [format %-25s $efcs(ARN)]
                            set suspend_reason [format %-2s " "]
                            set external_trans_id $25spcs
                            #Creating MSG DETAIL mas log string lenght  200
                            append b $mgtrans_type $trans_id $entity_id $card_scheme $mas_code $mas_code_downgrade $nbr_of_items $amt_original $add_cnt1 $add_amt1 $add_cnt2 $add_amt2 $external_trans_id $trans_ref_data $suspend_reason
                            #puts $b
                            #puts [string length $b]
                            #Sending info to out file----------------------------------------------
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
                            #Calculation totals from sum amount and transaction counts -----------------------
                            set tot [expr $tot + $efcs(AMOUNT)]
                            #puts "AMOUNT $tot"
                            set totbchamt $tot
                            set totitm [expr $totitm + 1]
                            #puts "CNT $totitm"
                            set bchcnt $totitm
                            set b ""

                            # NPP-7450 ->
                            insert_tran_event $efcs(OTHER_DATA4)
                            # NPP-7450 <-
                        }
                        #Closing db connection ----------------------------------------------------------
                        oracommit $db_auth_handle

                    }
                }
            }
        }

        #BATCH TRAILER-------------------------------------------------------------
        #Batch trailer variables---------------------------------------
        set totbchamt [expr wide([expr round($totbchamt * 100)])]
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
                #puts $bt
                close $fileid
            }
        }
        #calculating total for file trailer---------------------------------------
        set totfileamt [expr $totfileamt + $tot]
        set totfilecnt [expr $totfilecnt + $totitm]
        set tot 0
        set totitm 0
        set totbchamt 0
        set bchcnt 0
        set bt ""
        set y [expr $y + 1]
    }
}
#FILE TRAILER ----------------------------------------------------------------------------
set totfileamt [expr wide([expr round($totfileamt * 100)])]
set totfilecnt [expr wide($totfilecnt)]

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
						
# Update database 

# NPP-7450 ->
update_job_record_end
oracommit $db_auth_handle
# NPP-7450 <-

if {[catch {set update_query_handle [oraopen $db_auth_handle]} result]} {
	puts "Encountered error $result while creating db handle for update - update_query_handle"
	exit 3 
}

if {[catch {set select_query_handle [oraopen $db_auth_handle]} result]} {
	puts "Encountered error $result while creating db handle for select - select_query_handle"
	exit 3 
}

puts "\nUPDATING DATABASE..."
# As a pair, arn and other_data4 create a unique identifier fo
set query "
	SELECT 
		m.MMID, m.MID, t.ARN, t.OTHER_DATA4, t.CARD_TYPE
	FROM merchant m 
	JOIN master_merchant mm ON mm.mmid = m.mmid
	JOIN tranhistory t ON t.mid = m.mid
	WHERE mm.shortname = '$s_name'
		AND m.active = 'A'
		AND t.card_type = 'AX'
		AND t.status is not null
		AND t.status <> 'AMX'
		AND t.status <> 'CNA'
		AND t.settle_date like '$sdate%'
	ORDER BY m.visa_id, t.shipdatetime"
	
puts "\n\nquery: \n$query\n\n"

orasql $select_query_handle $query

# Declare update query. :arn and :other_data4 represent SQL bind variables. Binding 
# variables allows for more efficiency because Oracle can parse the SQL statement once 
# and then use it multiple times to perform similar actions.
set update_query "
	UPDATE tranhistory
	SET status = 
		CASE
			WHEN status = 'CNV' THEN 'CNA' 
			ELSE 'AMX'
		END
	WHERE arn = :arn
	AND other_data4 = :other_data4"

# Send the update query statement to the DB to be parsed. 
if { [catch {oraparse $update_query_handle $update_query} result]} {
	puts "ERROR: - Unsuccessful parsing of the update query."
	puts "ERROR: $result"
	exit 3
}
# orafetch returns 1403 when there are no more rows to fetch
while {[orafetch $select_query_handle -dataarray arr -indexbyname] != 1403} {
	
	# bind relevant variables in update query statement  
	if { [catch {orabind $update_query_handle :arn $arr(ARN) :other_data4 $arr(OTHER_DATA4)} result]} {
		switch $result {
			"1003" {
				puts "ERROR: orabind command unsuccessful."
				puts "Return code 1003: Binding placeholders do not match 
					the parsed SQL or the SQL statement has not been parsed."
			}
			"1008" {
				puts "ERROR: orabind command unsuccessful."
				puts "Return code 1008: Not all SQL bind variables have been specified."
			}
			default {
				puts "ERROR: orabind command unsuccessful."
				puts "ERROR: $result"
			}
		}
		exit 3
	}
	
	set stmt [string map [list :arn $arr(ARN) :other_data4 $arr(OTHER_DATA4)] $update_query]
	puts "\nupdate query: $stmt"
	
	if { [catch {oraexec $update_query_handle } result] } {
		puts "ERROR:- oraexec command unsuccessful. Query did not alter DB."
		puts "query - $query_text, ERROR:- $result"
		exit 3
	}
}
# Commit changes to database
oracommit $db_auth_handle
oracommit $db_masclr_handle

# Disconnect DB session 
oralogoff $db_auth_handle
oralogoff $db_masclr_handle
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
#catch {exec  mv $outfile /clearing/filemgr/DEBIT/INST_$inst_id/UPLOAD/.} result myke
catch {exec mv $outfile /clearing/filemgr/MAS/MAS_FILES/.} result myke

puts "File: $outfile move complete to archive"
puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================
