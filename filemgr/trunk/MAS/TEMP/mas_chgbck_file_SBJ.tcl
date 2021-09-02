#!/usr/bin/env tclsh

# $Id: mas_chgbck_file.tcl 3175 2015-07-16 19:46:59Z fcaron $

# Tested 2008-10-23 for reversal chargebacks
#Written By Rifat Khan
#Jetpay LLC
#Older internal vertion 1.0 , Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size
# for MSG detail to 200 bytes.
#revised 20060426 with internal version 1.1 , expected version of 36.0
#
#Changed the complete code reformated for perfomance issue.
#revised 20061201 with internal verion 2.0
#

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

package require Oratcl
package provide random 1.0

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
#Institution Profile Information-------------------------------------------------
#set inst_name [open "$env(PWD)/inst_profile.cfg" "r+"]
#set line [split [set orig_line [gets $inst_name] ] ,]
#set inst_id [string trim [lindex $line 0]]
#set vbin [string trim [lindex $line 1]]
#set mbin [string trim [lindex $line 2]]
#set ica [string trim [lindex $line 3]]
#set cib [string trim [lindex $line 4]]
#set edpt [string trim [lindex $line 5]]
#set prdsn [string trim [lindex $line 6]]
#set tstsn [string trim [lindex $line 7]]
#set psrun [string trim [lindex $line 8]]
#puts "$inst_id $vbin $mbin $ica $cib $edpt $prdsn $tstsn $psrun"

#if {$psrun == "P"} {
#    set s_name $prdsn
#} else {
#    set s_name $tstsn
#}

####################### UPDATE BELOW FOR NEW INST ###############################
#if {$argv == 3} {
#    set s_name [lindex $argv 0]
#    set inst_id [string trim [lindex $argv 1]]
#    set currdate [lindex $argv 2]
#} else
if {$argc == 2} {
    set currdate [lindex $argv 1]
    set inst_id [string trim [lindex $argv 0]]
} else {
    puts "Incorrect arguments: [info script] inst_id curr_date"
    exit 1
}

####################### CHANGES STOPS HERE ######################################

set ins_id $inst_id
set inst_dir "INST_$inst_id"
set subroot "MAS"
set locpth "/clearing/filemgr/$subroot/$inst_dir"

puts "\n\n[clock format [clock seconds] -format "%D %T"] Beginning [info script] $argv"
##################################################################################

set fname "CHARGEBK"
set dot "."
set jdate ""
#set s_name [string toupper $s_name]

puts "========================================================================================"

#TABLE NAMES-----------------------------------------------------

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
set n_date [string toupper [clock format [ clock scan "$currdate -0 day" ] -format %d-%b-%y]]
set lydate [clock format [ clock scan "$currdate" ] -format %m]
#set rdate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
#puts "$sdate $adate $rdate \n"

set begint "000000"
set endt "000000"
set rightnow [clock seconds]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
#puts $rightnow

#set rightnow "[string toupper [clock format [ clock scan "$currdate 1 day" ]
# -format "%Y%m%d"]]000000"

set jdate [ clock scan "$currdate"  -base [clock seconds] ]
#puts $jdate
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]
#puts $jdate

set begintime "000000"
set endtime "000000"

append batchtime $sdate $begint
#set batchtime $rightnow
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

#if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
#    puts "$clrdb efund boarding failed to run"
#    set mbody "$clrdb efund boarding failed to run"
#    exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
# $mailtolist
#    exit 1
#}
if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
    puts "$clrdb MAS chargeback file failed to run"
    set mbody "$clrdb MAS chargeback file failed to run"
    exec echo "$mbody_u $sysinfo $mbody" | mutt -s "$msubj_u" $mailtolist
    exit 1
}

#All the sql logon handles -------------------------------------------------
set m_code_sql [oraopen $db_login_handle]
set clr_get [oraopen $db_login_handle]
set clr_get1 [oraopen $db_login_handle]
set clr_get2 [oraopen $db_login_handle]
set clr_get3 [oraopen $db_login_handle]
set clr_get4 [oraopen $db_login_handle]
set clr_get5 [oraopen $db_login_handle]
set clr_get21 [oraopen $db_login_handle]

#Temp variable for output file name
set f_seq 15
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
    orasql $clr_get $get_dt
    orafetch $clr_get -dataarray lp -indexbyname
    if {$lp(LEAP_YR_DT) == "0229"} {
        puts "leap year exiting counting run. This will be ran on tomorrow at Feb 29"
        set mbody "leap year exiting counting run. This will be ran on tomorrow at Feb 29"
        #   exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l"
        # $mailtolist
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
    puts stderr "Cannot open /duplog : $fileid"
    exit 1
}

#Procedure to control Batch numbers for Mas file

proc pbchnum {} {
    global env
    # get and bump the file number
    set batch_num_file [open "$env(PWD)/mas_batch_num.txt" "r+"]
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

################################################################################
### MAIN
################################################################################

###### Loading Visa/MC id as entity_id into an array with index of MID from the
# Database

set get_ent "
    select idm.tid, nvl(idm.AMT_RECON, 0) amt_recon, epl.*
    from ep_event_log epl
    join in_draft_main idm
    on idm.trans_seq_nbr = epl.trans_seq_nbr
    where
        (   ems_item_type in ('CB1','CB2','RR1','RR2')
        or (ems_item_type in ('CR2')
            and epl.card_scheme = '08')
        )
    and event_log_date >= '$e_date'
    and event_log_date <  '$n_date'
    and event_status in ('NEW', 'NOTIFY', 'PROGRESS')"
puts "query $get_ent"
orasql $clr_get1 $get_ent

###### Writing File Header into the Mas file

set rec(file_date_time) $rightnow
set rec(activity_source) "JETPAYLLC"
set rec(activity_job_name) "MAS"

write_fh_record $fileid rec

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
set sendemail 1
set script_error 0

###### While Loop for to fetch records gathered by Sql Select get_info
if { [catch {
            while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
                set chk 1
                # reset all variables in global array
                set rec(batch_curr) ""
                set rec(merchantid) ""
                set rec(sender_id) ""
                set rec(institution_id) ""
                set rec(entity_id) ""
                set rec(card_scheme) ""
                set rec(external_trans_id) ""
                set rec(trans_ref_data) ""
                set rec(trans_id) ""
                set rec(mas_code) ""

                set get_sale "
                    select * from in_draft_main
                    where ARN = '$a(ARN)'
                    and (MSG_TYPE = '500' or MSG_TYPE = '600')
                    and src_inst_id = '$inst_id'"
                puts $get_sale
                orasql $clr_get2 $get_sale

                orafetch $clr_get2 -dataarray b -indexbyname

                set oerr [oramsg $clr_get2 rc]
                puts $oerr

                if {$oerr != 1403} {

                    # if {$a(INSTITUTION_ID) != $b(SRC_INST_ID)} {
                    #     puts "Instituion_id mismatched between EMS TXN and Original TXN. EMS: $a(INSTITUTION_ID) !=  ORIG: $b(SRC_INST_ID)"
                    #     set sendemail 0
                    #     exec echo "Instituion_id mismatched between EMS TXN and Original TXN. EMS: $a(INSTITUTION_ID) !=  ORIG: $b(SRC_INST_ID)" >> $inst_id.cb.email
                    #     exec echo $get_sale >> $inst_id.cb.email
                    # }

                    set get_sale1 "
                        select * from in_draft_main
                        where ARN = '$a(ARN)'
                        and trans_seq_nbr = $a(TRANS_SEQ_NBR)"
                    puts $get_sale1
                    orasql $clr_get3 $get_sale1

                    orafetch $clr_get3 -dataarray c -indexbyname
                    puts $c(TID)

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
                    puts ">$b(CARD_SCHEME)<"

                    switch $a(EMS_ITEM_TYPE) {
                        "CB1"   {
                            switch $a(TID) {
                                "010103015201" {set mas_tid "010003015201"}
                                "010103015202" {set mas_tid "010003015101"}
                                "010103015107" -
                            "010103015101" {set mas_tid "010003015101"}
                            "010103015102" {set mas_tid "010003015102"}
                            "010103015401" {set mas_tid "010003015201"}
                                default {
                                    error "unknown TID $a(TID)"
                                }
                            }
                        set ms_cd "$b(CARD_SCHEME)CHGBCK"
                        }
                        "CB2"   {
                            switch $a(TID) {
                            "010103015301" {set mas_tid "010003015101"}
                            "010103015302" {set mas_tid "010003015102"}
                            "010103015401" {set mas_tid "010003015201"}
                                default {
                                    error "unknown TID $a(TID)"
                                }
                            }
                        set ms_cd "$b(CARD_SCHEME)CHGBCK"
                        }
                        "RR1" -
                        "RR2"    {
                        set ms_cd "02$b(CARD_SCHEME)RREQ"
                            set mas_tid "010103020102"

                        }
                        "CR2" {
                            switch $b(CARD_SCHEME) {
                                "08" {
                                    set ms_cd $b(MAS_CODE)
                                    switch $a(TID) {
                                    "010103005301" {set mas_tid "010003005301"}
                                    "010103005302" {set mas_tid "010003005302"}
                                    "010103015401" {set mas_tid "010003015201"}
                                        default {
                                            error "unsupported tid for CR2: $a(TID)"
                                        }
                                    }
                                }
                                default {
                                    error "unsupported card scheme for CR2: $b(CARD_SCHEME)"
                                }
                            }
                        }
                        default {puts "EMS_ITEM_TYPE not found >$a(EMS_ITEM_TYPE)<; exit 1"}
                    }
                    puts "a(EMS_ITEM_TYPE): $a(EMS_ITEM_TYPE), a(TRANS_CCD):$a(TRANS_CCD), a(AMT_TRANS):$a(AMT_TRANS), a(AMT_RECON):$a(AMT_RECON) "
                    set rec(trans_id) $mas_tid
                    set rec(mas_code) $ms_cd
                    set rec(nbr_of_items) "1"
                    if {$a(TRANS_CCD) == "840"} {
                        set rec(amt_original) $a(AMT_TRANS)

                        write_md_record $fileid rec

                        set totcnt [expr $totcnt + 1]
                        set totamt [expr $totamt + $a(AMT_TRANS)]

                        set ftotcnt [expr $ftotcnt + 1]
                        set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
                    } else {

                        ##set get_ocb "select nvl(AMT_RECON, 0) from in_draft_main where trans_seq_nbr = '$a(TRANS_SEQ_NBR)'"
                        ##orasql $clr_get21 $get_ocb
                        ##
                        ##orafetch $clr_get21 -dataarray ocb -indexbyname
                        ##
                        ##set oerr [oramsg $clr_get21 rc]
                        ##puts $oerr
                        #if {$oerr == 1403} {
                        #    set recon_amt 0
                        #} else {
                            set recon_amt $a(AMT_RECON)
                        #}
                        puts ""
                        set rec(amt_original) $recon_amt

                        write_md_record $fileid rec

                        set totcnt [expr $totcnt + 1]
                        set totamt [expr $totamt + $recon_amt]

                        set ftotcnt [expr $ftotcnt + 1]
                        set ftotamt [expr $ftotamt + $recon_amt]
                    }
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
        } failure]} {

    puts "Error $failure"
    set script_error 1

}
###### Writing File Trailer Record

set rec(file_amt) $ftotamt
set rec(file_cnt) $ftotcnt

write_ft_record $fileid rec

###### Closing Output file

close $fileid

puts $loop

if {$script_error != 0} {
    exec rm $outfile
    exit 1
}
if {$loop == 1403 && $chk == 0} {
    puts "No Txn"
    exec rm $outfile
    exit 0
} else {
    exec chmod 775 $outfile
    set result1 ""
    catch {exec mv $outfile MAS_FILES} result1
}
#if {$result1 == ""} {
#   catch {exec  mv $outfile $env(PWD)/INST_$inst_id/ARCHIVE} result
#   set err ""
#   set err [exec $env(PWD)/INST_$inst_id/sch_cmd.tcl $inst_id 100 >> $env(PWD)/INST_$inst_id/LOG/MAS.$inst_id.SCH_CMD.log]
#   if {$err != ""} {
#       set mbody "ERROR ON EXECUTING sch_cmd.tcl: \n $err"
#       exec echo "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
#   }
#}
set result2 ""
if {$sendemail == 0} {
    catch {exec mutt -s "$msubj_l" -- clearing@jetpay.com < $inst_id.cb.email} result2
    puts $result2
    if {$result2 == ""} {
        exec rm $inst_id.cb.email
    }

}

################################################################################
#################################### END CODE
################################################################################

puts "[clock format [clock seconds] -format "%D %T"] Ending [info script] $argv"
#===============================================END
# PROGRAM==================================================================