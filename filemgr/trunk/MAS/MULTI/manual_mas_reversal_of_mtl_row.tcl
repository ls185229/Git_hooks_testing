#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

###
#  $Id: manual_mas_reversal_of_mtl_row.tcl 3828 2016-07-26 18:45:26Z bjones $
###

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

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

#######################################################################################################################

####################### UPDATE BELOW FOR NEW INST ###############################

global inst_id rightnow jdate fileid batchtime

set s_name [lindex $argv 0]
set inst_id [string trim [lindex $argv 1]]
set currdate [lindex $argv 2]

####################### CHANGES STOPS HERE ######################################

# set inst_id $inst_id
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

set fname "REVERSAL"
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

set begintime "000000"
set endtime "000000"

set    batchtime $sdate
append batchtime $begint
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

#CHECKING FEB ON LEAP YEAR AND STOP RUNNING ON FEB 28

set chklpyear [clock seconds]
set chklpyear [clock format $chklpyear -format "%m%d"]

#Creating output file name----------------------
# append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
# puts $outfile
# puts $hk
#
# while {$hk == 1} {
#     puts $hk
#     if {[set ex [file exists $env(PWD)/$outfile]] == 1} {
#         puts $ex
#         set f_seq [expr $f_seq + 1]
#         set fileno $f_seq
#         set fileno [format %03s $f_seq]
#         set one "01"
#         set pth ""
#         exec mv $outfile TEMP
#         set outfile ""
#         append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
#         puts $outfile
#         set hk 1
#     } else {
#         set hk 0
#     }
# }

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

proc open_mas_file {inst aname} {
    upvar aname a
    global rightnow jdate fileid
    ###### Writing File Header into the Mas file

    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "MAS"
    set fname "REVERSAL"
    #append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
    set outfile [exec build_filename.py -i $inst -f $fname -j $jdate ]
    #Opening Output file to write to

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
    }

    write_fh_record $fileid rec
    return $fileid
}

proc open_batch {fileid inst_id ent ent_name curr_code} {

    global batchtime
    ###### Writing Batch Header Or Batch Trailer

    set chkmidt $ent
    set totcnt 0
    set totamt 0

    set rec(batch_curr) "$curr_code"
    set rec(activity_date_time_bh) $batchtime
    set rec(merchantid) "$ent"
    set rec(inbatchnbr) [pbchnum]
    set rec(infilenbr)  1
    set rec(batch_capture_dt) $batchtime
    set rec(sender_id) $ent_name
    set rec(institution_id) $inst_id

    write_bh_record $fileid rec

}

proc close_batch {fileid cnt amt aname} {
    if { $fileid == "" } {
        return
    }
    upvar aname a
    set rec(batch_amt)  $amt
    set rec(batch_cnt) $cnt
    write_bt_record $fileid rec
}

proc close_mas_file {fileid cnt amt} {
    if { $fileid == "" } {
        return
    }
    set rec(file_amt) $amt
    set rec(file_cnt) $cnt

    write_ft_record $fileid rec
    close $fileid
}

###################################
#####################################################################################
### MAIN ###############################################################################################################
########################################################################################################################


###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database

set get_ent "
    SELECT
        mtl.INSTITUTION_ID INSTITUTION_ID,
        mtl.TRANS_SEQ_NBR TRANS_SEQ_NBR,
        mtl.TRANS_SUB_SEQ TRANS_SUB_SEQ,
        mtl.TID TID,
        mtl.MAS_CODE MAS_CODE,
        mtl.CARD_SCHEME CARD_SCHEME,
        mtl.AMT_ORIGINAL * 100 AMT_ORIGINAL,
        mtl.CURR_CD_ORIGINAL CURR_CD_ORIGINAL,
        mtl.NBR_OF_ITEMS NBR_OF_ITEMS,
        mtl.ENTITY_ID ENTITY_ID,
        mtl.TRANS_REF_DATA TRANS_REF_DATA,
        ae.ENTITY_DBA_NAME ENTITY_DBA_NAME
    FROM mas_trans_log mtl
    JOIN acq_entity ae
    ON  mtl.INSTITUTION_ID = ae.INSTITUTION_ID
    AND mtl.ENTITY_ID      = ae.ENTITY_ID
    WHERE
        trans_seq_nbr IN (
            '0'
        )
    order by mtl.institution_id, mtl.entity_id"

puts $get_ent
orasql $clr_get1 $get_ent


###### Declaring Variables and intializing

set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
set loop 1

set curr_inst ""
set curr_ent ""
set fileid ""
###### While Loop for to fetch records gathered by Sql Select get_info

while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {

    if { $a(AMT_ORIGINAL) <= 0 } {
        continue
    }
    if {$curr_inst != $a(INSTITUTION_ID)} {
        close_batch $fileid $totcnt $totamt a
        incr ftotcnt $totcnt
        set ftotamt [expr $ftotamt + $totamt]
        set totcnt 0
        set totamt 0
        close_mas_file $fileid $ftotcnt $ftotamt

        set ftotcnt 0
        set ftotamt 0

        set curr_inst $a(INSTITUTION_ID)
        set curr_code $a(CURR_CD_ORIGINAL)
        set fileid [open_mas_file $curr_inst a]

        open_batch $fileid $a(INSTITUTION_ID) $a(ENTITY_ID) $a(ENTITY_DBA_NAME) $curr_code
    }

    if {$curr_ent != $a(ENTITY_ID)} {
        close_batch $fileid $totcnt $totamt a
        incr ftotcnt $totcnt
        set ftotamt [expr $ftotamt + $totamt ]
        set totcnt 0
        set totamt 0
        set curr_ent $a(ENTITY_ID)
        set curr_code $a(CURR_CD_ORIGINAL)
        open_batch $fileid $a(INSTITUTION_ID) $a(ENTITY_ID) $a(ENTITY_DBA_NAME) $curr_code
    }



    ###### Writing Massage Detail records


    set rec(entity_id) $a(ENTITY_ID)
    set rec(card_scheme) $a(CARD_SCHEME)
    set rec(external_trans_id) $a(TRANS_SEQ_NBR)
    set rec(trans_ref_data) $a(TRANS_REF_DATA)


    #
    # set mas_tid "010003005201"
    #

    #
    # Check for TID and set mas_tid accordingly
    #
    set mas_tid $a(TID)

    set rec(mas_code) $a(MAS_CODE)

    set rec(trans_id) $mas_tid
    set rec(nbr_of_items) $a(NBR_OF_ITEMS)
    set rec(amt_original) $a(AMT_ORIGINAL)

    write_md_record $fileid rec

    set totcnt [expr $totcnt + 1]
    set totamt [expr $totamt + $a(AMT_ORIGINAL)]

    #set ftotcnt [expr $ftotcnt + 1]
    #set ftotamt [expr $ftotamt + $a(AMT_ORIGINAL)]
    puts "$totamt $ftotamt $totcnt $ftotcnt"

}
###### Writing File Trailer Record

close_batch $fileid $totcnt $totamt rec
incr ftotcnt $totcnt
set ftotamt [expr $ftotamt + $totamt]
close_mas_file $fileid $ftotcnt $ftotamt

###### Closing Output file


# puts $loop
#
# if {$loop == 1403 && $chk == 0} {
#     puts "No Txn"
#     #    exec rm $outfile
#     exit 0
# } else {
#     exec chmod 775 $outfile
#
# }


##########################################################################################################################
#################################### END CODE ############################################################################
##########################################################################################################################

puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================
