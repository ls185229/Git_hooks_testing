#!/usr/bin/env tclsh

#$Id: $

package require Oratcl

#System variables
set box $env(SYS_BOX)
set clrdb $env(IST_DB)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#Global variables for file processing
global STD_OUT_CHANNEL
set STD_OUT_CHANNEL stderr

global clrDBLogin
global curr_se_num
global db_logon_handle_in_draft_main
global in_draft_main_c
set curr_se_num '0'

#set mode "PROD"
set mode "TEST"


############################################
#  Load Config File
############################################

proc load_config {src} {
    global capIds 
    global clrdb
    global clrDBLogin
    global clrHandle
    global capId_cnfig
    
    set cfg_file [open $src r]
    fconfigure $cfg_file -buffering line
    set line_rd ""
    
    while {[gets $cfg_file line_rd]} {
        if { [string range $line_rd 0 0]!="#"} {
             puts $line_rd
             if {[string range $line_rd 0 11] == "CLR_DB_LOGON" } {
                 set lineParms [split $line_rd ,]
                 set clrDBLogin [lindex $lineParms 1]
                 puts $clrDBLogin
             } else {

               set capId_cnfig [split $line_rd {,}]

               if {[llength $capId_cnfig] > 0} {
                   if {[llength $capId_cnfig] == 5} {
                       foreach cfg_data $capId_cnfig {
                           lappend capIds [string trim $cfg_data]
                       }
               } else {
                      puts "Error. Wrong number of fields. Config line is corrupted: $line_rd"
                }
              }
            }
        }
    }
}


################################################################################
#
#    Procedure Name - initDB
#
#    Description - Setup the DB, tables and handles
#
#    Return - exit 3 if any error
#
###############################################################################
proc initDB {} {
    global clrdb clrDBLogin clrDBLoginHandle db_logon_handle_core_amex_se_map core_amex_se_map_c 

    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$clrdb]} result ] } {
                puts "$clrdb login Err: $result "
                exit 3
    }

    #
    # Open core.amex_se_map 
    #
    if {[catch {set db_logon_handle_core_amex_se_map [oralogon $clrDBLogin@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for core.amex_se_map"
        exit
    }
    if {[catch {set core_amex_se_map_c [oraopen $db_logon_handle_core_amex_se_map]} result]} {
        puts "Encountered error $result while trying to create core.amex_se_map database handle"
        exit
    }

}


################################################################################
#
#    Procedure Name - executeQuery
#
#    Description - The procedure simply executes the query passed
#
#    Return - The query handle
#
###############################################################################
proc executeQuery {query handle} {

    if {[catch {orasql $handle $query} result]} {
                puts "SQL Err:$result"
                puts "$query"
                exit 3
    }
    puts $handle
    return $handle
}



##########################################
#  Parse the file header record
##########################################

proc parse_File_HDr_Rec {rec} {
    global activity_ending_dt 

    if { [string range $rec 0 4] == "DFHDR"} {
         set activity_ending_dt [string toupper [clock format [clock scan "[string range $rec 5 12]" -format %m%d%Y] -format %b-%d-%y]]
    }
    set file_processingDT [string range $rec 1 8 ]
}


#########################################
# Parse Summary Detail Header Record
#########################################

proc parse_Sum_Det_HDr_Rec {rec} {
    global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num 

    set file_processingDT [string toupper [clock format [clock scan "[string range $rec 45 51]" -format %Y%j] -format %b-%d-%y]]
    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]

    puts $curr_acq
    puts $curr_se_num
   
if { $curr_se_num != 2423794213 } { 
    set amex_se_map_query "select institution_id
                               from core.amex_se_map casm
                               where casm.amex_opt_blue_se_number = $curr_se_num"

    orasql $core_amex_se_map_c $amex_se_map_query    

    if {[orafetch $core_amex_se_map_c -dataarray core_amex_se_map_orig -indexbyname] != 1403 } {
       set institution_id        "$core_amex_se_map_orig(INSTITUTION_ID)"
    } else {
        write_log_message "the institution ID not fouund for se_number $curr_se_num"
        exit 1
    }


    set instId_name "INSTITUTION $institution_id"  
    puts $instId_name


    dict set dict_acquirer $curr_acq name $instId_name

   set activityType "210-CARD_SALES"
   set discrip "CARD_SALES"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [string range $rec 182 188]
       set new_count "[string trimleft [string range $new_count 0 end-1] 0][string range $new_count end end]"
       set new_count [cobol_count_convert $new_count]
       set new_count [expr $new_count + $count]

       set new_amt [string range $rec 65 75]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt [string range $rec 76 84]
       set new_damt "[string trimleft [string range $new_damt 0 end-1] 0][string range $new_damt end end]"
       set new_damt [cobol_value_convert $new_damt]
       set new_damt [expr $new_damt + $damt]

       set new_servamt [string range $rec 85 91]
       set new_servamt "[string trimleft [string range $new_servamt 0 end-1] 0][string range $new_servamt end end]"
       set new_servamt [cobol_value_convert $new_servamt]
       set new_servamt [expr $new_servamt + $servamt]

       set new_ntamt [string range $rec 99 109]
       set new_ntamt "[string trimleft [string range $new_ntamt 0 end-1] 0][string range $new_ntamt end end]"
       set new_ntamt [cobol_value_convert $new_ntamt]
       set new_ntamt [expr $new_ntamt + $ntamt]


       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"
   } else {

       set count [string range $rec 182 188]
       set count "[string trimleft [string range $count 0 end-1] 0][string range $count end end]"
       set count [cobol_count_convert $count]

       set amt [string range $rec 65 75]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt [string range $rec 76 84]
       set damt "[string trimleft [string range $damt 0 end-1] 0][string range $damt end end]"
       set damt [cobol_value_convert $damt]

       set servamt [string range $rec 85 91]
       set servamt "[string trimleft [string range $servamt 0 end-1] 0][string range $servamt end end]"
       set servamt [cobol_value_convert $servamt]

       set ntamt [string range $rec 99 109]
       set ntamt "[string trimleft [string range $ntamt 0 end-1] 0][string range $ntamt end end]"
       set ntamt [cobol_value_convert $ntamt]

       puts "count = $count"
       puts "amt = $amt"
       puts "damt = $damt"
       puts "servamt = $servamt"
       puts "ntamt = $ntamt"

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"
   }

}
}
#############################################
# Parse Reject Records
#############################################

proc  parse_Reject_Rec {rec} {
      global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]


    set amex_se_map_query "select institution_id
                               from core.amex_se_map casm
                               where casm.amex_opt_blue_se_number = $curr_se_num"

    orasql $core_amex_se_map_c $amex_se_map_query

    if {[orafetch $core_amex_se_map_c -dataarray core_amex_se_map_orig -indexbyname] != 1403 } {
       set institution_id        "$core_amex_se_map_orig(INSTITUTION_ID)"
    } else {
        write_log_message "the institution ID not fouund for se_number $curr_se_num"
        exit 1
    }


    puts $institution_id
    puts $curr_se_num

    set instId_name "INSTITUTION $institution_id"

    dict set dict_acquirer $curr_acq name $instId_name

   set activityType "220-REJECTS"
   set discrip "REJECTS"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [expr $count + 1]

       set new_amt [string range $rec 76 84]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt [string range $rec 85 93]
       set new_damt "[string trimleft [string range $new_damt 0 end-1] 0][string range $new_damt end end]"
       set new_damt [cobol_value_convert $new_damt]
       set new_damt [expr $new_damt + $damt]

       set new_servamt [string range $rec 94 100]
       set new_servamt "[string trimleft [string range $new_servamt 0 end-1] 0][string range $new_servamt end end]"
       set new_servamt [cobol_value_convert $new_servamt]
       set new_servamt [expr $new_servamt + $servamt]

       set new_ntamt [string range $rec 108 116]
       set new_ntamt "[string trimleft [string range $new_ntamt 0 end-1] 0][string range $new_ntamt end end]"
       set new_ntamt [cobol_value_convert $new_ntamt]
       set new_ntamt [expr $new_ntamt + $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"

   } else {

       set count 1 

       set amt [string range $rec 76 84]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt [string range $rec 85 93]
       set damt "[string trimleft [string range $damt 0 end-1] 0][string range $damt end end]"
       set damt [cobol_value_convert $damt]

       set servamt [string range $rec 94 100]
       set servamt "[string trimleft [string range $servamt 0 end-1] 0][string range $servamt end end]"
       set servamt [cobol_value_convert $servamt]

       set ntamt [string range $rec 108 116]
       set ntamt "[string trimleft [string range $ntamt 0 end-1] 0][string range $ntamt end end]"
       set ntamt [cobol_value_convert $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"
   }

}


#############################################
# Parse ChargeBack Records
#############################################

proc  parse_Chgback_Rec {rec} {
      global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num 


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]


    set amex_se_map_query "select institution_id
                               from core.amex_se_map casm
                               where casm.amex_opt_blue_se_number = $curr_se_num"

    orasql $core_amex_se_map_c $amex_se_map_query

    if {[orafetch $core_amex_se_map_c -dataarray core_amex_se_map_orig -indexbyname] != 1403 } {
       set institution_id        "$core_amex_se_map_orig(INSTITUTION_ID)"
    } else {
        write_log_message "the institution ID not fouund for se_number $curr_se_num"
        exit 1
    }


    puts $institution_id
    puts $curr_se_num
    puts $curr_acq

    set instId_name "INSTITUTION $institution_id"

    dict set dict_acquirer $curr_acq name $instId_name


   set activityType "230-CHARGEBACKS"
   set discrip "CHARGEBACKS"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [expr $count + 1]

       set new_amt [string range $rec 58 66]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt [string range $rec 67 75]
       set new_damt "[string trimleft [string range $new_damt 0 end-1] 0][string range $new_damt end end]"
       set new_damt [cobol_value_convert $new_damt]
       set new_damt [expr $new_damt + $damt]

       set new_servamt [string range $rec 76 82]
       set new_servamt "[string trimleft [string range $new_servamt 0 end-1] 0][string range $new_servamt end end]"
       set new_servamt [cobol_value_convert $new_servamt]
       set new_servamt [expr $new_servamt + $servamt]

       set new_ntamt [string range $rec 90 98]
       set new_ntamt "[string trimleft [string range $new_ntamt 0 end-1] 0][string range $new_ntamt end end]"
       set new_ntamt [cobol_value_convert $new_ntamt]
       set new_ntamt [expr $new_ntamt + $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"

   } else {

       set count 1

       set amt [string range $rec 58 66]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt [string range $rec 67 75]
       set damt "[string trimleft [string range $damt 0 end-1] 0][string range $damt end end]"
       set damt [cobol_value_convert $damt]

       set servamt [string range $rec 76 82]
       set servamt "[string trimleft [string range $servamt 0 end-1] 0][string range $servamt end end]"
       set servamt [cobol_value_convert $servamt]

       set ntamt [string range $rec 90 98]
       set ntamt "[string trimleft [string range $ntamt 0 end-1] 0][string range $ntamt end end]"
       set ntamt [cobol_value_convert $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"
   }

}


#############################################
# Parse Asset Billing Records
#############################################

proc  parse_Asset_Billing_Rec {rec} {
    global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]


    set amexSeMapHandle [executeQuery $amex_se_map_query $clrHandle ]
    orafetch $amexSeMapHandle -dataarray ds -indexbyname
    set institution_id        "$ds(INSTITUTION_ID)"


    puts $institution_id
    puts $curr_se_num
    puts $curr_acq

    set instId_name "INSTITUTION $institution_id"

    dict set dict_acquirer $curr_acq name $instId_name


    set discrip [join [string range $rec 61 125] "_"]
    set discrip [string map { , "" } $discrip]

    set activityType "240-$discrip"
    puts "descrip $discrip"


   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [expr $count + 1]

       set new_amt [string range $rec 52 60]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt 0 
       set new_servamt 0

       set new_ntamt $new_amt 
       set new_ntamt [expr $new_ntamt + $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"

   } else {

       set count 1

       set amt [string range $rec 52 60]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt 0 
       set servamt 0

       set ntamt $amt 

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"

   }

}



#############################################
# Parse Take One Commission Records
#############################################

proc  parse_Take_One_Comm_Rec {rec} {
    global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]


    set amexSeMapHandle [executeQuery $amex_se_map_query $clrHandle ]
    orafetch $amexSeMapHandle -dataarray ds -indexbyname
    set institution_id        "$ds(INSTITUTION_ID)"


    puts $institution_id
    puts $curr_se_num
    puts $curr_acq

    set instId_name "INSTITUTION $institution_id"

    dict set dict_acquirer $curr_acq name $instId_name

    set discrip [join [string range $rec 135 214] "_"]
    set discrip [string map { , "" } $discrip]

    set activityType "241-$discrip"
    puts "descrip $discrip"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [expr $count + 1]

       set new_amt [string range $rec 126 134]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt 0
       set new_servamt 0

       set new_ntamt $new_amt
       set new_ntamt [expr $new_ntamt + $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"

   } else {

       set count 1

       set amt [string range $rec 126 134]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt 0
       set servamt 0

       set ntamt $amt

       dict set dict_acquirer $gbl_state (current_acq) "ACTIVITY_TYPE" $activityType $discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"

   }

}


#############################################
# Parse Other Fee Records
#############################################

proc  parse_Other_Fees_Rec {rec} {
     global dict_acquirer curr_acq file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num 


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]

    set amex_se_map_query "select institution_id
                               from core.amex_se_map casm
                               where casm.amex_opt_blue_se_number = $curr_se_num"

    orasql $core_amex_se_map_c $amex_se_map_query

    if {[orafetch $core_amex_se_map_c -dataarray core_amex_se_map_orig -indexbyname] != 1403 } {
       set institution_id        "$core_amex_se_map_orig(INSTITUTION_ID)"
    } else {
        write_log_message "the institution ID not fouund for se_number $curr_se_num"
        exit 1
    }


    puts $institution_id
    puts $curr_se_num
    puts $curr_acq

    set instId_name "INSTITUTION $institution_id"

    dict set dict_acquirer $curr_acq name $instId_name


   set activityType "250-OTHER-FEES"

    set discrip [join [string range $rec 224 303] "_"] 
    set discrip [string map { , "" } $discrip]

    set activityType "250-$discrip"

#   set discrip [string trimright [string range $rec 224 303] " " ]
puts "descrip $discrip"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {

       set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
       set count [lindex $values 1]
       set amt [lindex $values 2]
       set damt [lindex $values 3]
       set servamt [lindex $values 4]
       set ntamt [lindex $values 5]

       set new_count [expr $count + 1]

       set new_amt [string range $rec 215 223]
       set new_amt "[string trimleft [string range $new_amt 0 end-1] 0][string range $new_amt end end]"
       set new_amt [cobol_value_convert $new_amt]
       set new_amt [expr $new_amt + $amt]

       set new_damt 0
       set new_servamt 0

       set new_ntamt $new_amt
       set new_ntamt [expr $new_ntamt + $ntamt]

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $new_count [format "%.2f" $new_amt] [format "%.2f" $new_damt] [format "%.2f" $new_servamt] [format "%.2f" $new_ntamt]"

   } else {
       set count 1
       set discrip_id 1
       set amt [string range $rec 215 223]
       set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
       set amt [cobol_value_convert $amt]

       set damt 0
       set servamt 0

       set ntamt $amt

       dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]" 
     puts "old section - discrip_id is $discrip_id"
   }

}


#########################################
# Parse Record of Charge for Network Fee
#########################################

proc parse_Network_Fee_Rec {rec} {
    global dict_acquirer file_processingDT clrdb clrDBLogin db_logon_handle_core_amex_se_map core_amex_se_map_c curr_se_num


    set curr_acq [string trimleft [string range $rec 0 9] 0]
    set curr_se_num [string trimleft [string range $rec 10 19] 0]

    puts $curr_acq
    puts $curr_se_num

if { $curr_se_num != 2423794213 } {

    set amex_se_map_query "select institution_id
                               from core.amex_se_map casm
                               where casm.amex_opt_blue_se_number = $curr_se_num"

    orasql $core_amex_se_map_c $amex_se_map_query

    if {[orafetch $core_amex_se_map_c -dataarray core_amex_se_map_orig -indexbyname] != 1403 } {
       set institution_id        "$core_amex_se_map_orig(INSTITUTION_ID)"
    } else {
        write_log_message "the institution ID not fouund for se_number $curr_se_num"
        exit 1
    }


    set instId_name "INSTITUTION $institution_id"
    puts $instId_name


    dict set dict_acquirer $curr_acq name $instId_name

   set activityType "210-CARD_SALES"
   set discrip "CARD_SALES"

   if {[dict exists $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]} {
     set values [dict get $dict_acquirer $curr_acq ACTIVITY_TYPE $activityType]
     set count [lindex $values 1]
     set amt [lindex $values 2]
     set damt [lindex $values 3]
     set servamt [lindex $values 4]
     set ntamt [lindex $values 5]
     set new_damt "0.00"
     set new_servamt "0.00"
     if {[string range $rec 45 46] == "NF" } {
        if {[string range $rec 81 81] == "+" || [string range $rec 81 81] == "-" } {
           set new_damt [string range $rec 82 95]
           set new_damt "[string trimleft [string range $new_damt 0 end-1] 0][string range $new_damt end end]"
           set new_damt [format "%0.2f" [expr $new_damt / 100.00]]
           if {[string range $rec 81 81] == "-" } {
               set new_damt [expr $new_damt * -1]
          }
 puts "new discount amt $new_damt"
               set damt [expr $new_damt + $damt]
 puts "new total discount amt $damt"
        }
        if {[string range $rec 105 105] == "+" || [string range $rec 105 105] == "-" } {
           set new_servamt [string range $rec 106 119]
           set new_servamt "[string trimleft [string range $new_servamt 0 end-1] 0][string range $new_servamt end end]"
           set new_servamt [format "%0.2f" [expr $new_servamt / 100.00]]
           if {[string range $rec 105 105] == "-" } {
               set new_servamt [expr $new_servamt * -1]
           }
puts "new service amt $new_servamt"
               set servamt [expr $new_servamt + $servamt]
puts "new total service amt $servamt"
        }
    }
   dict set dict_acquirer $curr_acq "ACTIVITY_TYPE" $activityType "$discrip $count [format "%.2f" $amt] [format "%.2f" $damt] [format "%.2f" $servamt] [format "%.2f" $ntamt]"
  }
}
}


###################################################
# Convert alpa amount to numeric for dollar amount
###################################################

proc cobol_value_convert {value} {
    set PNIND [string range $value end end]
    
    switch -exact $PNIND {
        "\{"	{return format "%0.2f" [expr "[string range $value 0 end-1]0" / 100.00]}
        "A"		{return format "%0.2f" [expr "[string range $value 0 end-1]1" / 100.00]}
        "B"		{return format "%0.2f" [expr "[string range $value 0 end-1]2" / 100.00]}
        "C"		{return format "%0.2f" [expr "[string range $value 0 end-1]3" / 100.00]}
        "D"		{return format "%0.2f" [expr "[string range $value 0 end-1]4" / 100.00]}
        "E"		{return format "%0.2f" [expr "[string range $value 0 end-1]5" / 100.00]}
        "F"		{return format "%0.2f" [expr "[string range $value 0 end-1]6" / 100.00]}
        "G"		{return format "%0.2f" [expr "[string range $value 0 end-1]7" / 100.00]}
        "H"		{return format "%0.2f" [expr "[string range $value 0 end-1]8" / 100.00]}
        "I"		{return format "%0.2f" [expr "[string range $value 0 end-1]9" / 100.00]}

        "\}"	{return format "%0.2f" [expr "[string range $value 0 end-1]0" / -100.00]}
        "J"		{return format "%0.2f" [expr "[string range $value 0 end-1]1" / -100.00]}
        "K"		{return format "%0.2f" [expr "[string range $value 0 end-1]2" / -100.00]}
        "L"		{return format "%0.2f" [expr "[string range $value 0 end-1]3" / -100.00]}
        "M"		{return format "%0.2f" [expr "[string range $value 0 end-1]4" / -100.00]}
        "N"		{return format "%0.2f" [expr "[string range $value 0 end-1]5" / -100.00]}
        "O"		{return format "%0.2f" [expr "[string range $value 0 end-1]6" / -100.00]}
        "P"		{return format "%0.2f" [expr "[string range $value 0 end-1]7" / -100.00]}
        "Q"		{return format "%0.2f" [expr "[string range $value 0 end-1]8" / -100.00]}
        "R"		{return format "%0.2f" [expr "[string range $value 0 end-1]9" / -100.00]}
        default {puts "ERROR!! Bad value passed to cobol converter: $value"}
    }
}


###################################################
# Convert alpa count variable to numeric
###################################################

proc cobol_count_convert {value} {
    set PNIND [string range $value end end]

    switch -exact $PNIND {
        "\{"    {return format "%-7d" [expr "[string range $value 0 end-1]0"]}
        "A"             {return format "%-7d" [expr "[string range $value 0 end-1]1"]}
        "B"             {return format "%-7d" [expr "[string range $value 0 end-1]2"]}
        "C"             {return format "%-7d" [expr "[string range $value 0 end-1]3"]}
        "D"             {return format "%-7d" [expr "[string range $value 0 end-1]4"]}
        "E"             {return format "%-7d" [expr "[string range $value 0 end-1]5"]}
        "F"             {return format "%-7d" [expr "[string range $value 0 end-1]6"]}
        "G"             {return format "%-7d" [expr "[string range $value 0 end-1]7"]}
        "H"             {return format "%-7d" [expr "[string range $value 0 end-1]8"]}
        "I"             {return format "%-7d" [expr "[string range $value 0 end-1]9"]}

        "\}"    {return format "%-7d" [expr "[string range $value 0 end-1]0" * -1]}
        "J"             {return format "%-7d" [expr "[string range $value 0 end-1]1" * -1]}
        "K"             {return format "%-7d" [expr "[string range $value 0 end-1]2" * -1]}
        "L"             {return format "%-7d" [expr "[string range $value 0 end-1]3" * -1]}
        "M"             {return format "%-7d" [expr "[string range $value 0 end-1]4" * -1]}
        "N"             {return format "%-7d" [expr "[string range $value 0 end-1]5" * -1]}
        "O"             {return format "%-7d" [expr "[string range $value 0 end-1]6" * -1]}
        "P"             {return format "%-7d" [expr "[string range $value 0 end-1]7" * -1]}
        "Q"             {return format "%-7d" [expr "[string range $value 0 end-1]8" * -1]}
        "R"             {return format "%-7d" [expr "[string range $value 0 end-1]9" * -1]}
        default {puts "ERROR!! Bad value passed to cobol converter: $value"}
    }
}



#######################################
# MAIN
#######################################

if {$mode == "PROD"} {
    set inpath "/clearing/filemgr/AMEX/SETTLEMENT/TILR/ARCHIVE/"
    set apath "/clearing/filemgr/AMEX/SETTLEMENT/TILR/ARCHIVE/"
    set cnfig_source "./CONFIG/amex_config.tc"
} else {
    set inpath "./"
    set apath "./"
    set cnfig_source "./CONFIG/amex_test_config.tc"
}

##
# Search for files matching the file for the given day
###
set tilr_infiles ""
set tilr_infiles [glob -nocomplain ${inpath}AMEX_TILR.[clock format [clock seconds] -format %Y%m%d]*]

if {$tilr_infiles == ""} {
    puts "$argv0 did not find the input file matching: ${inpath}AMEX_TILR.[clock format [clock seconds] -format %Y%m%d]*"
##    exec echo "$argv0 could not find today's AMEX_TILR file." | mutt -s "$argv0 - File not found" "clearing@jetpay.com,reports-clearing@jetpay.com"
    exec echo "$argv0 could not find today's AMEX_TILR file." | mutt -s "$argv0 - File not found" "devans@jetpay.com"
    exit 1
}

##
# Normally, there should only be one file. But just in case, we choose
# the file with the highest sequence number by sorting the filelist
###
set amex_infiles [lsort $tilr_infiles]
foreach fl $amex_infiles {
    puts $fl
    set infile_name $fl
}


##
# Use a regex to parse the date from the filename
###
if { [regexp -- {AMEX_TILR.([0-9]{08,08}).} $infile_name dummy1 parsed_infile_dt] } {
        puts "Date parsed from infile name: $parsed_infile_dt"
} else {
    puts "Error parsing date from infile.. $argv0 did not find an input file matching format: AMEX_TILR.([0-9]{14,14}).###"
    exit 1
}

##
# Load the config file
###
load_config "$cnfig_source"

initDB

set rpt_date  [string toupper [clock format [ clock scan "-0 day " ] -format %b-%d-%y ]]

set inFile [open $infile_name r]
fconfigure $inFile -buffering line
set record ""

while {[set record [gets $inFile]] != {} } {
    
    switch -exact [string range $record 42 44] {
       "   "    { parse_File_HDr_Rec $record }
        210     { parse_Sum_Det_HDr_Rec $record }
        220     { parse_Reject_Rec $record }
        230     { parse_Chgback_Rec $record }
        240     { parse_Asset_Billing_Rec $record }
        241     { parse_Take_One_Comm_Rec $record }
        250     { parse_Other_Fees_Rec $record }
        default {}
        
    }
}

##
# Go through the capIds declared in the config file
# Generate each file with whatever data we got for their bins
# The filename scheme and upload path
# for each is also in the config file
###
foreach {Iso bins up_path archive_path gen_filenm} $capIds {
    
    set shortname [string map "yyyymmdd $parsed_infile_dt" $gen_filenm]
    set filename "$up_path$shortname"
    set cur_file [open "$filename" w]

    puts $filename

    puts $cur_file "AMEX NETWORK"
    puts $cur_file "ACQUIRER DAILY SUMMARY REPORT"
    puts $cur_file " "
    puts $cur_file "PROGRAM NAME:,AMEX_TILR"
    puts $cur_file "SYSTEM DATE:,$rpt_date"
    puts $cur_file "PROCESSING DATE:,$activity_ending_dt"
    puts $cur_file " "
    puts $cur_file " "

    foreach acq $bins {

        if {[dict exists $dict_acquirer $acq]} {
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "ACQUIRER ID:,$acq"
            puts $cur_file "ACQUIRER NAME:,[dict get $dict_acquirer $acq name]"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "Description,Transaction Count,Transaction Volume,Discount Amt,Service Fee Amt,Net Amount,Other Fees,Total Net Settlement"
            
            set Tntamt 0
            set Tontamt 0
            set TSetamt 0

            if {[dict exists $dict_acquirer $acq ACTIVITY_TYPE]} {

                dict for {type columns} [dict get $dict_acquirer $acq ACTIVITY_TYPE] {

                    switch -glob $type {

                        [210-CARD]* {puts $cur_file "[lindex $columns 0], [lindex $columns 1], $[lindex $columns 2], $[lindex $columns 3], $[lindex $columns 4], $[lindex $columns 5] "}
                        "REJECTS"  {puts $cur_file "[lindex $columns 1], [lindex $columns 3], $[lindex $columns 5], $[lindex $columns 7], $[lindex $columns 9], $[lindex $columns 11] "}
                        "CHARGEBACKS" {puts $cur_file "[lindex $columns 1], [lindex $columns 3], $[lindex $columns 5], $[lindex $columns 7], $[lindex $columns 9], $[lindex $columns 11] "}
                        "ASSET BILLING" {puts $cur_file "[lindex $columns 1], [lindex $columns 3], $[lindex $columns 5], $[lindex $columns 7], $[lindex $columns 9], $[lindex $columns 11] "}
                        "TAKE ONE COMMISSION" {puts $cur_file "[lindex $columns 1], [lindex $columns 3], $[lindex $columns 5], $[lindex $columns 7], $[lindex $columns 9], $[lindex $columns 11] "}
                        [250-OTHER]* {puts $cur_file "[lindex $columns 0], [lindex $columns 1], $[lindex $columns 2], $[lindex $columns 3], $[lindex $columns 4], $[lindex $columns 6] "}

                    }

                     set Tntamt [expr $Tntamt + [lindex $columns 5]]

                }
            }
            
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "TOTAL NET SETTLEMENT, , , , ,$$Tntamt"
            puts $cur_file " "
            puts $cur_file " "
        }
    }
    
    close $cur_file
    
    if {$mode == "PROD"} {
###        exec echo "" | mutt -a $filename -s "$shortname" "reports-clearing@jetpay.com"
        exec echo "" | mutt -a $filename -s "$shortname" "devans@jetpay.com"

   }        
}

close $inFile
#exec mv $infile_name $apath
