#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#######################################################################################
# $Id: mas_debit_settlement_file.tcl 3512 2015-09-22 21:33:12Z bjones $
# $Rev: 3512 $
#######################################################################################
#
# File Name:  mas_debit_settlement_file.tcl
#
# Description:  This program creates a MAS file for PIN DEBIT transactions.
#               Settlement Reporting Entity (SRE).
#
# Script Arguments:  shortname (e.g. JETPAYIS).  Required.
#                    institution_id (e.g. 107).  Required.
#                    date (YYMMDD, e.g. 20150913) Optional, defaults to today
#
# Output:  MAS file under ~/MAS/MAS_FILES/inst_id.DEBITRAN.01.Jdate.Seq
#                                   e.g.: 101.DEBITRAN.01.3267.978
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  DO NOT RUN THIS CODE TWICE, as it will create duplicate file contents.
#
#######################################################################################

#package require Oratcl
package require Oratcl
package provide random 1.0

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib

MASCLR::set_debug_level 3

set fname "DEBITRAN"
set dot "."
set jdate ""

MASCLR::log_message "========================================================================================"

#DB SID NAME--------------------------------------------------
global authdb
global base2db
global dbhost
global dbhost1

global SWITCHES UPDATE_C UPDATE_S SETTLE_DATE FLAGS settlement_arn OD4 TABLE_NAME TESTING INSTITUTION_ID temp_crsr1 FILE_NUM_MONEY_TRANS CURRENCY_CODE
global setl_cnt tn_ins
set clrdb $env(CLR4_DB)

set authdb $env(TSP4_DB)
set prod_db $env(IST_DB)
#set dbhost teihost
set dbhost $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
#set dbhost1 masclr
set dbhost1 $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set i 0
set FILE_NUM_MONEY_TRANS 0


#TABLE NAMES-----------------------------------------------------


set tblnm_mm "$dbhost.master_merchant"

set tblnm_mr "$dbhost.merchant"
MASCLR::log_message "tblnm_mr = $tblnm_mr" 2
set tblnm_tn "$dbhost.TRANHISTORY"
set tblnm_set "$dbhost.SETTLEMENT"
set tblnm_e2a "$dbhost1.ENTITY_TO_AUTH"

set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP"
global adate
global sdate
global rdate
global jdate

#INPUT VARIABLES-------------------

if {$argc != 2 && $argc != 3 } {
    puts "Usage: mas_debit_settlement_file.tcl MMSN INSTUTION_ID"
    puts "MMSN is the Master_Merchant ShortNames to be processed for this file."
    exit 1
}
#set s_name JETPAYSQ
set s_name [lindex $argv 0]

set inst_id [lindex $argv 1]
if {$argc == 3 } {
    set sdate [lindex $argv 2]
} else {
    set sdate [clock format [ clock scan "-0 day" ] -format %Y%m%d%H%M%S]
}


set adate [clock format [ clock scan "-0 day" ] -format %Y%m%d]
MASCLR::log_message "sdate $sdate adate $adate" 3


set begint "000000"
set endt "00000"
MASCLR::log_message "sdate $sdate adate $adate" 3
set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
MASCLR::log_message $rightnow 2

set jdate [ clock scan "-0 day"  -base [clock seconds] ]
MASCLR::log_message "jdate $jdate" 2
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]
MASCLR::log_message "jdate $jdate" 2





#DB SID NAME--------------------------------------------------


#DATE set up for file header batch header and output file with Jdate--------

set jdate [ clock scan "-0 days"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]


#TIME set up for file header and output file
set begint ""
set endt ""

MASCLR::log_message "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set begint 000000

MASCLR::log_message  "ENTER BEGIN TIME IN 24 HOUR CLOCK (FORMATED AS SUCH HHMMSS = 162459)"
set endt 000000

set begintime ""
set endtime ""

append begintime $adate $begint
if {[string length $sdate] == 8} {
    append endtime $sdate $endt
} else {
    set endtime $sdate
}

MASCLR::log_message  "Transaction count between $begintime :: $endtime"



#Proc for array---------------------------------------------------------

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

##################################################
# make_acq_ref_num
#   Generates the acquirer reference number (ARN).
##################################################
proc make_acq_ref_num { bin disc_acq_id date film card_type tran_type currency} {

    switch $card_type {
        "VS"    {if {$tran_type == "0420" || $currency != "840"} {
            set format_code 7
        } else {
            set format_code 2}}

        "MC"    {set format_code 1}

        "DS"    {set format_code 8

            if {[string range $disc_acq_id 0 0] != ""} {
                set bin [string range $disc_acq_id 5 10]
            } else {
                set bin "123456"}}

        "DB"    {set format_code 0}

        default {}
        }

    set s1 [format "%d%06.6s%04.4s%011.11s" $format_code $bin $date $film]
    set c {0 1 2 3 4 5 6 7 8 9 0 2 4 6 8 1 3 5 7 9}
    set phase 0
    set sum 0

    if {$card_type == "DB"} {
        set s1 [string range $s1 1 24]
    }

    foreach v [split $s1 {}] {
        set vv [lindex $c [expr {$v + 10 * $phase}]]
        set sum [expr {$sum + $vv}]
        set phase [expr {$phase ^ 1}]
    }

    set ch [expr {(10 - $sum %10) %10}]

    if {$card_type == "DB"} {
        set s1 "F$s1"
    }

    set s1 "$s1$ch"

};# end make_acq_ref_num

set y 0

#Opening connection to db--------------------------------------------------
if {[catch {set db_auth_handle [oralogon $dbhost/$authpwd@$authdb]} result]} {
    MASCLR::log_message "Failed to connect to auth database"
    exit
} else {
    puts "COnnected"
}
if {[catch {set db_mas_handle [oralogon $dbhost1/$clrpwd@$prod_db]} result]} {
    MASCLR::log_message "Failed to connect to MASCLR database"
    exit
} else {
    puts "COnnected"
}


#All the sql logon handles -------------------------------------------------
#Updating sequence number in $tblnm_sc.
set update_seq [oraopen $db_mas_handle]
#pulling merchant information from teihost.merchant
set pull_mer_from_mer [oraopen $db_auth_handle]
#pulling master merchant information from teihost.master_merchant
set pull_mer_from_m_mer [oraopen $db_auth_handle]
set chk_sum [oraopen $db_auth_handle]
set entity_from_efund [oraopen $db_auth_handle]
set batch_count_sql [oraopen $db_auth_handle]
set batch_sum_sql [oraopen $db_auth_handle]
set entityefund [oraopen $db_auth_handle]
set test_id [oraopen $db_mas_handle]
set mas_addr_sql [oraopen $db_mas_handle]
set tt_bin_sql [oraopen $db_auth_handle]
set m_code_sql [oraopen $db_mas_handle]
set mfl_tb [oraopen $db_mas_handle]
set UPDATE_C [oraopen $db_auth_handle]
set UPDATE_S [oraopen $db_auth_handle]
set temp_crsr1 [oraopen $db_mas_handle]
set tn_cnt [oraopen $db_auth_handle]
set set_cnt [oraopen $db_auth_handle]
set set_tn [oraopen $db_auth_handle]
set inputtable $tblnm_set

#Card type list-and sequence type list---------------------------------------
#set card_type { DB VS MC AX DS DC JC }
set card_type { DB }
set seq_type { batch_id file_id }

#Temp variable for total sum (tot) and total count (totitm)
set tot 0
set totitm 0
set totbchamt 0
set bchcnt 0
set f_seq 0
# set fileno $f_seq
# set fileno [format %03s $f_seq]
set one "01"

set pth "/clearing/filemgr/DEBIT/"
set dupFlag 1

while {$dupFlag == 1} {
    incr f_seq
    set fileno [format %03s $f_seq]
    set filename ""
    append filename $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno

    ### check mfl table for duplicate file
    set query "select count(1) as cnt
       from mas_file_log
       where institution_id = '$inst_id'
      and file_name in ('$filename')"

    MASCLR::log_message "mfl query \n       $query \n" 3
    orasql $mfl_tb $query
    orafetch $mfl_tb -dataarray mfl -indexbyname

     if {$mfl(CNT) != 0} {
        set dupFlag 1
    } else {
        set dupFlag 0
    }

    ### Check the ARCHIVE folder
    if {$dupFlag == 0} {
        set tempFileName ""
        append tempFileName /clearing/filemgr/MAS/ARCHIVE/$filename "*"
        if { [glob -nocomplain "$tempFileName"] != "" } {
            set dupFlag 1
        } else {
            set dupFlag 0
        }
    }

    ### Check for MAS FILES folder
    if {$dupFlag == 0} {
        if { [file exists /clearing/filemgr/MAS/MAS_FILES/$filename] == 1 } {
            set dupFlag 1
        } else {
            set dupFlag 0
        }
    }

} ;#end of while dupFlag

set outfile ""
append outfile $pth $filename
MASCLR::log_message "outfile = $outfile"

#FILE HEADER--------------------------------------------------------
#Initializing total file amount and count
set totfileamt 0
set totfilecnt 0

#File header variables declared-----------------------------------
set fhtrans_type [format %02s "FH"]
set file_type [format %-2s "01"]
set file_date_time [format %-016s $rightnow]
MASCLR::log_message "file_date_time $file_date_time"
set activity_source [format %-16s "TTLCSYSTEM"]
set activity_job_name [format %-8s "DEBITRN"]
set suspend_level [format %-1s "B"]

#Creating the File Header string length 45 -----
append fh $fhtrans_type $file_type $file_date_time $activity_source $activity_job_name $suspend_level
if {[set l [string length $fh]] != 45} {
    MASCLR::log_message "FILE HEADER LENGTH DID NO MATCH $fh"
    exit 1
} else {
    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 2
    } else {
        puts $fileid $fh
        MASCLR::log_message "fh  $fh" 3
        close $fileid
    }
}
#Transaction Request type list and action code list---
set r_type { 0260 0262 0460 462}
set act_code { A D }

set DATE_OFFSET 0
set TZ_OFFSET [expr 3600 * 9]
set cur_local_time [clock seconds ]
set cur_local_time [expr {$cur_local_time + $DATE_OFFSET * 86400}]
set CUR_SET_TIME $cur_local_time

orasql $UPDATE_C "UPDATE $tblnm_set set
                    SETTLE_DATE = '$sdate'
                    WHERE CARD_TYPE = 'DB'
                    AND (REQUEST_TYPE like '026%' or request_type like '046%'
                    AND STATUS IS NOT NULL)"
oracommit $db_auth_handle

# -------------------------BATCH BODY------------------------------------------------

# Pulling MMID MID VISA_ID from merchant table for each MMID got under SHORTNAME in Master merchant table.---
set temp_sql "
    select MMID, MID, VISA_ID, DEBIT_ID from $tblnm_mr
    where mmid in (
        select mmid from $tblnm_mm
        where shortname = '$s_name') and debit_id not like ' %'"

MASCLR::log_message "temp_sql\n$temp_sql" 3
orasql $pull_mer_from_mer $temp_sql

while {[set loop1 [orafetch $pull_mer_from_mer -dataarray mid -indexbyname]] == 0} {
    #load_array mid $x $mer_cols
    #puts $x
    set chk_sql "
        select count(amount) ckct, sum(amount) cksm from $tblnm_set
        where mid = '$mid(MID)'
        and (request_type like '026%' or request_type like '046%')
        and status is not null and card_type = 'DB' and settle_date like '$sdate%'"

    MASCLR::log_message "chk_sql \n$chk_sql" 3
    orasql $chk_sum $chk_sql
    set c [orafetch $chk_sum -dataarray chktot -indexbyname]
    MASCLR::log_message  "c: $c chktot(CKCT): $chktot(CKCT)" 2
    #BATCH HEADER-------------------------------------------------------------------
    if {$chktot(CKCT) != 0} {
    puts "Total Count = $chktot(CKCT)"

        #Formatting batch header batch sequence number------------------------------------------------------
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
            #puts "Using batch seq num: $bchnum"

            #BATCH variables declared-----------------------
            set 25spcs [format %-25s " "]
            set 23spcs [format %-23s " "]
            set bhtrans_type [format %02s "BH"]
            set batch_curr [format %-3s "840"]
            set activity_date_time_bh [format %-016s $endtime]
            if {[string trim $mid(VISA_ID)] != {}} {
                set merchantid [format %-30s $mid(VISA_ID)]
            } else {
                set merchantid [format %-30s $mid(DEBIT_ID)]
            }
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
            append bh $bhtrans_type $batch_curr $activity_date_time_bh
            append bh $merchantid $inbatchnbr $infilenbr $billind $orig_batch_id
            append bh $orig_file_id $ext_batch_id $ext_file_id $sender_id
            append bh $microfilm_nbr $institution_id $batch_capture_dt

            if {[set l [string length $bh]] != 219} {
                puts "BATCH HEADER LENGTH DID NO MATCH $bh"
            } else {
                if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                    puts stderr "Cannot open : $fileid"
                } else {
                    puts $fileid $bh
                    #puts $bh
                    MASCLR::log_message "bh  $bh" 3
                    set bh ""
                }
                close $fileid
            }
        }

        #Declared temp card scheme---------------------------
        set c_sch ""
        #END OF HEADER MYKE

        # Julian data for ARN
        set CUR_JULIAN_DATE [clock format $CUR_SET_TIME -format "%y%j"]
        set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]

        #puts "myke"
        #Nested FOR LOOP to get total transaction count and sum from each merchant transaction according to their card type
        #request type and approved or declined. ---------------------------------------------------------------------------
        foreach {type} $card_type {
            MASCLR::log_message "card_type $type"
            foreach {r_typ} $r_type {
                MASCLR::log_message "r_typ $r_typ" 1
                foreach {act_typ} $act_code {
                    MASCLR::log_message "act_typ $act_typ" 2
                    #IF statement is for Approved the use one set of sql stmt or else other sets of sql stmt--
                    if {$act_typ == "A"} {

                        set query_string "select MID, VISA_BIN, MC_BIN, ENTITY_ID, DISCOVER_ACQ_ID
                            from $tblnm_e2a where status = 'A' and
                            INSTITUTION_ID = '$inst_id' and MID = '$mid(MID)'"

                        MASCLR::log_message "entity_to_auth query \n$query_string\n" 3
                        orasql $temp_crsr1 $query_string
                        orafetch $temp_crsr1 -dataarray bins -indexbyname

                        set VISA_DEST_BIN $bins(VISA_BIN)
                        set VISA_SOURCE_BIN $bins(VISA_BIN)
                        set MC_DEST_BIN $bins(MC_BIN)
                        set MC_SOURCE_BIN $bins(MC_BIN)
                        set ENTITY_ID $bins(ENTITY_ID)
                        set DISC_ACQ_ID $bins(DISCOVER_ACQ_ID)

                        switch $type {
                        "VS"  {set DEST_BIN $VISA_DEST_BIN
                               set SOURCE_BIN $VISA_SOURCE_BIN}

                        "MC"  {set DEST_BIN $MC_DEST_BIN
                               set SOURCE_BIN $MC_SOURCE_BIN}

                        "DS"  {set DEST_BIN $VISA_DEST_BIN
                               set SOURCE_BIN $VISA_SOURCE_BIN}

                        "DB"  {set DEST_BIN $VISA_DEST_BIN
                               set SOURCE_BIN $VISA_SOURCE_BIN}

                        default {set DEST_BIN "000000"
                             set SOURCE_BIN "000000"}
                        }

                            #Sql string command for transaction count--------------------------------------------------------------------------
                            # FC use Settlement instead of TranHistory
                        set sql "
                                select * from $tblnm_set
                                where mid = '$mid(MID)'
                                    and action_code = '000'
                                    and request_type = '$r_typ'
                                    and card_type = '$type'
                                    and card_type = 'DB'
                                    and settle_date like '$sdate%'"
                        MASCLR::log_message "sql \n$sql" 3
                        orasql $batch_count_sql $sql

                        while {[set loop [orafetch $batch_count_sql -dataarray efcs -indexbyname]] == 0} {
                            #A switch to convert card types----------------
                            set c_sch "02"
                            #Sql string command for to fetch mascode for appropriate transaction request type, card type, action code type----
                            #puts "select mas_code from $tblnm_mfcg where card_scheme = '$c_sch' and request_type = '$r_typ' and action = '$act_typ'"
                            #Set up mas_codes
                            orasql $chk_sum "select * from merchant where mid = '$mid(MID)'"
                            #puts "select * from merchant where mid = '$mid(MID)'"
                            MASCLR::log_message "chk_sum \n$chk_sum" 3
                            orafetch $chk_sum -dataarray mcd -indexbyname
                            #Declared temp TID for efund fee package---------------
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
                            #puts $network_id
                            switch -- $network_id {
                                00 {set mas_code "0102VISASMS"}
                                02 {set mas_code "0102VISASMS"}
                                08 {set mas_code "0102STARSMS"}
                                10 {set mas_code "0102STARSMS"}
                                11 {set mas_code "0102STARSMS"}
                                12 {set mas_code "0102STARSMS"}
                                15 {set mas_code "0102STARSMS"}
                                09 {set mas_code "0102PULSESMS"}
                                19 {set mas_code "0102PULSESMS"}
                                17 {set mas_code "0102PULSESMS"}
                                27 {set mas_code "0102NYCESMS"}
                                18 {set mas_code "0102NYCESMS"}
                                03 {set mas_code "0102INTRLKSMS"}
                                16 {set mas_code "0102MSTROSMS"}
                                04 {set mas_code "0102PULSESMS"}
                                13 {set mas_code "0102AFFNSMS"}
                                20 {
                                    if {$mcd(SIC_CODE) == "4511" && ( $mcd(SIC_CODE) < "3000" || $mcd(SIC_CODE) > "3300" ) } {
                                        set mas_code "0102ACCLSMS"
                                    } else {
                                        set mas_code "0102ACCLSMS_AL"
                                    }
                                }
                                23 {set mas_code "0102NETSSMS"}
                                24 {set mas_code "0102CU24SMS"}
                                25 {set mas_code "0102ALSKOPSMS"}
                                28 {set mas_code "0102SHAZAMSMS"}
                                29 {set mas_code "0102EBTSMS"}

                            }
                            MASCLR::log_message "network_id: $network_id mas_code: $mas_code" 2

                            #Declared variables for MSG DETAIL section of MAS FILE----------------------------------------------------------
                            set 25spcs [format %-25s " "]
                            set 23spcs [format %-23s " "]
                            set mgtrans_type [format %02s "01"]
                            set trans_id [format %-12s $tid]
                            if {[string trim $mid(VISA_ID)] != {}} {
                               set entity_id [format %-18s $mid(VISA_ID)]
                            } else {
                                 set entity_id [format %-18s $mid(DEBIT_ID)]
                            }
                            set card_scheme $c_sch
                            set mas_code [format %-25s $mas_code]
                            set mas_code_downgrade $25spcs
                            set nbr_of_items [format %010s 1]
                            set amt_original [format %012d [expr wide(round($efcs(AMOUNT) * 100))]]
                            set add_cnt1 "0000000000"
                            set add_amt1 "000000000000"
                            set add_cnt2 "0000000000"
                            set add_amt2 "000000000000"

                            #FC Update Settlement table with ARN and print in file
                            set CUR_PID [pid]
                            incr FILE_NUM_MONEY_TRANS
                            set temp [format "%05s%06s" $CUR_PID $FILE_NUM_MONEY_TRANS]
                            set settlement_arn [make_acq_ref_num $SOURCE_BIN $DISC_ACQ_ID $CUR_JULIAN_DATEX $temp $type $r_typ $efcs(CURRENCY_CODE)]

                            orasql $UPDATE_S "UPDATE $tblnm_set
                            SET ARN = '$settlement_arn',
                            STATUS = '$inst_id'
                            WHERE MID = '$mid(MID)'
                            AND ACTION_CODE = '000'
                            AND REQUEST_TYPE = '$r_typ'
                            AND CARD_TYPE = '$type'
                            AND OTHER_DATA4 = '$efcs(OTHER_DATA4)'"


                            set trans_ref_data [string range $settlement_arn 0 23]
                            set suspend_reason [format %-2s " "]
                            set external_trans_id $25spcs

                            #Creating MSG DETAIL mas log string length  200
                            append b $mgtrans_type $trans_id $entity_id $card_scheme $mas_code $mas_code_downgrade
                            append b $nbr_of_items $amt_original $add_cnt1 $add_amt1 $add_cnt2 $add_amt2
                            append b $external_trans_id $trans_ref_data $suspend_reason

                            MASCLR::log_message "b: $b" 4
                            #puts [string length $b]
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
                            set tot [expr $tot + $efcs(AMOUNT)]
                            set totbchamt $tot
                            set totitm [expr $totitm + 1]
                            set bchcnt $totitm
                            set b ""
                        }
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

#creating file trailer string length 68----------------------------------------------
append ft $fttrans_type $file_amt $file_cnt $file_add_amt1 $file_add_cnt1 $file_add_amt2 $file_add_cnt2

#closing db connection --------------------------------------
#oracommit $db_mas_handle

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

global SOURCE_BIN VISA_DEST_BIN VISA_SOURCE_BIN MC_DEST_BIN MC_SOURCE_BIN ENTITY_ID DISC_ACQ_ID

# count number of records processed from Settlement
set chk_set "select count(amount) CNT from $tblnm_set WHERE (STATUS='$inst_id') and CARD_TYPE = 'DB' and SETTLE_DATE like '$sdate%'"
MASCLR::log_message "chk_set $chk_set" 3
orasql $set_cnt $chk_set
orafetch $set_cnt -dataarray x -indexbyname

set setl_cnt $x(CNT)
puts "Settlement Count = $setl_cnt"

# FC Insert records into TranHistory from Settlement
orasql $UPDATE_C "INSERT INTO $tblnm_tn
                      (MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,
                       EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,
                       PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,
                       ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,
                       CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,
                       CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,
                       SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,
                       CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,
                       ARN,MARKET_TYPE,VV_RESULT,CARD_PRESENT,AUTHORIZATION_AUTHORITY)
                  SELECT
                       MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,
                       EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,
                       PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,
                       ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,
                       CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,
                       CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,
                       SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,
                       CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,
                       ARN,MARKET_TYPE,VV_RESULT,CARD_PRESENT,AUTHORIZATION_AUTHORITY
             FROM $tblnm_set
             WHERE (STATUS='$inst_id') and card_type = 'DB' and SETTLE_DATE = '$sdate'"

    orasql $UPDATE_C "DELETE FROM $tblnm_set WHERE STATUS='$inst_id' and card_type = 'DB' and SETTLE_DATE = '$sdate'"
set UPDATE_C [oraopen $db_auth_handle]

# count number of records inserted into TranHistory
set chk_tn "select count(amount) CNT from $tblnm_tn WHERE (STATUS='$inst_id') and card_type = 'DB' and SETTLE_DATE like '$sdate%'"

MASCLR::log_message "chk_tn $chk_tn" 3
orasql $set_tn $chk_tn
orafetch $set_tn -dataarray y -indexbyname

set tn_ins $y(CNT)
puts "TranHistory Count = $tn_ins"

# check to see if record count in Settlement matches record count in TranHistory to commit or roll back transactions
if {$setl_cnt == $tn_ins} {
    oracommit $db_auth_handle
    catch {exec mv $outfile /clearing/filemgr/MAS/MAS_FILES/.} result myke
    MASCLR::log_message "Debit file generated $outfile"
} else {
    oraroll $db_auth_handle
    file move $outfile ./ARCHIVE/$outfile.killed
    MASCLR::log_message "Debit file deleted $outfile"
}

oraclose $UPDATE_C


puts "File: $outfile move complete to archive"

puts "==============================================  END OF FILE =================================================================="
#===================================================  END PROGRAM ==================================================================
