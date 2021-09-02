#!/usr/bin/env tclsh
# ###############################################################################
# $Id: mas_files_in.tcl 3911 2016-10-03 20:54:29Z skumar $
# $Rev: 3911 $
# ###############################################################################
#
# File Name:  mas_files_in.tcl
#
# Description:  This script determines if the MAS files are 
#               processed or not.
#
# Running options:
#
# Shell Arguments:
#                    -c = Counting type (Optional)
#                    -t = TEST MODE (Optional)
#                    -v = verbose level
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (All the Clearing MAS files are processed)
#           !0 = Exit with errors during the following conditions
#               1) Clearing file count doesnt match 
#               2) Database error 
#               3) Clearing file is still under process
# #############################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

global MODE
set MODE "TEST"
proc connect_to_dbs {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath 
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        puts $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }

}

proc open_cursor_masclr {cursr} {
    global db_login_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo    
    global $cursr

    if {[catch {set $cursr [oraopen $db_login_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        puts $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1    
    }
}

proc get_file_type_count {} {
    global mftc_count inst_list opt_type
    global arr_cfg inst_id s_name fname clr_get clr_get1
    global cday
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    if { [catch {
        ## based on the day, ALL inst has DAILY FREQUENCY SEQ is 0
        ##for 107 OKDMV doesnt have files on SUNDAY (cday 0), WEEKDAY (SEQ 1 - cday 1-5) & SATURDAY(SEQ 2 - cday 6) FREQUENCY to be updated based on the day script executed
        set mfc_query_sql "
            select 
                institution_id inst_id, 
                sum(file_count) cnt
            from MASCLR.MAS_FILE_TYPE_COUNT mfc
            where 
                mfc.category is null
                and mfc.INSTITUTION_ID in ($inst_list)
                and (mfc.frequency = 'DAILY' 
                or (mfc.frequency = 'WEEKDAY' 
                    and TO_CHAR(sysdate,'DY','nls_date_language=english') != 'SAT'
                    and TO_CHAR(sysdate,'DY','nls_date_language=english') != 'SUN')          
                or (mfc.frequency = TO_CHAR(sysdate,'DY','nls_date_language=english'))
                or (mfc.frequency = TO_CHAR(sysdate,'DY','nls_date_language=english'))) "
        if { $opt_type  == "FANF" } {
            append mfc_query_sql "
                and mfc.file_type = 'CLEARING' "
        }

        append mfc_query_sql " 
               group by institution_id  order by institution_id "
        #puts "\n mfc_query_sql: \n$mfc_query_sql\n\n"
        MASCLR::log_message " Inside get_file_type_count query_string: \n$mfc_query_sql\n\n" 3
        orasql $clr_get1 $mfc_query_sql
    
        while {[orafetch $clr_get1 -dataarray fcnt -indexbyname] == 0} {
                dict set mftc_count $fcnt(INST_ID) $fcnt(CNT)
        }
    } failure] } {
        set mbody "Error parsing, binding or executing mfc_query_sql sql: $failure \n $mfc_query_sql"
        error $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
    return 0
}

proc get_mas_file_log_count {} {
    global mfl_count inst_list opt_type
    global arr_cfg inst_id s_name fname clr_get clr_get1
    global cday
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo    

    if { [catch {
        set mfl_query_sql "
            select 
                 mfl.INSTITUTION_ID inst_id, 
                 count(mfl.file_name) cnt 
            from masclr.mas_file_log mfl 
            WHERE 
                 mfl.receive_date_time > TRUNC(sysdate)-.5 
                 and mfl.INSTITUTION_ID in ($inst_list) "		

        if { $opt_type  == "FANF" } {
            append mfl_query_sql "
                 and mfl.file_name like '%CLEARING%' "
        }

        append mfl_query_sql " 
            group by institution_id  order by institution_id "
        
        MASCLR::log_message " inside get_mas_file_log_count query_string: \n$mfl_query_sql\n\n" 3
        orasql $clr_get1 $mfl_query_sql
        
        while {[orafetch $clr_get1 -dataarray mflcnt -indexbyname] == 0} {
                dict set mfl_count $mflcnt(INST_ID) $mflcnt(CNT)
        }
    } failure] } {
        set mbody "Error parsing, binding or executing mfl_query_sql sql: $failure \n $mfl_query_sql"
        error $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
    return 0
}

proc compare_file_count {} {
    global mfl_count mftc_count programName mbody
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo     
    MASCLR::log_message " Inside compare_file_count mfl_count:[dict size $mfl_count] mftc_count: [dict size $mftc_count]" 3
	foreach inst [dict keys $mftc_count] {
		   MASCLR::log_message " Inst id : $inst" 3
	     if {[dict get $mfl_count $inst] < [dict get $mftc_count $inst] } {
		      MASCLR::log_message " Error Inst id : $inst MAS_FILE_TYPE_COUNT.FILE_COUNT doesnt match with MAS_FILE_LOG count"
              set mbody "Error: $programName.tcl is exiting - Not enough MAS files in MAS_FILE_LOG: $failure"
              exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
              MASCLR::close_all_and_exit_with_code 1
		  } else {
		       MASCLR::log_message " Inst id : $inst MAS_FILE_LOG count: [dict get $mfl_count $inst] \
                        greater than or equal to MAS_FILE_TYPE_COUNT  count: [dict get $mftc_count $inst]" 3
		  }
	}
    return 0
}

proc get_mas_file_status {} {
    global arr_cfg inst_id s_name fname clr_get mfl_dictionary
    global inst_list mfl_file_status bs_tot_cnt inst_list opt_type
    if { [catch {
        set mfl_query_string "
        select
              SUBSTR(mfl.institution_id,1,4)                                Inst,
              SUBSTR(mfl.file_id,1,10)                                      File_Id,
              SUBSTR(mfl.file_name,1,31)                                    File_Name,
              mfl.file_amt                                                  File_Amt,
              sum(bs.batch_amt)                                             BS_Total_amt,
              mfl.file_cnt                                                  File_Cnt,
              sum(bs.BATCH_CNT)                                             BS_file_cnt,
              mfl.nbr_of_batches                                            batch_cnt,
              sum( (case when bs.batch_processed = 'Y' then 1 else 0 end))  bs_batch_cnt,
              sum( (case when bs.suspend_flag = 'Y' then 1 else 0 end))     bs_suspend_cnt            
        from
             masclr.mas_file_log mfl LEFT JOIN MASCLR.BATCH_SUMMARY bs
                ON bs.institution_id = mfl.institution_id
                AND bs.file_id      = mfl.file_id
        WHERE 
             mfl.receive_date_time > TRUNC(sysdate)-.5
             and mfl.INSTITUTION_ID in ($inst_list) "

        if { $opt_type  == "FANF" } {
            append mfl_query_string " 
            and mfl.file_name like '%CLEARING%' "
        }

        append mfl_query_string " 
        group by mfl.institution_id, mfl.file_id, mfl.file_name, mfl.file_amt, mfl.file_cnt,mfl.nbr_of_batches "
        append mfl_query_string " 
        order by mfl.institution_id, mfl.file_id "
        
        MASCLR::log_message " inside get_mas_file_status query_string: \n$mfl_query_string\n\n" 3
        orasql $clr_get $mfl_query_string
        set inst_list [oracols $clr_get]
        
        MASCLR::log_message " No of rows from mfl_query_string: $inst_list" 3
        while {[orafetch $clr_get -dataarray mflog -indexbyname] != 1403} {
            set bs_tot_cnt [expr $mflog(BS_BATCH_CNT) + $mflog(BS_SUSPEND_CNT)]
            if { $mflog(BATCH_CNT) == $bs_tot_cnt } {
                MASCLR::log_message " INST: $mflog(INST)  FILE_NAME: $mflog(FILE_NAME)  processed" 3
                continue
            } else {
                MASCLR::log_message " INST: $mflog(INST)  FILE_NAME: $mflog(FILE_NAME) is under process"
                set mfl_file_status 'P'
                return $mfl_file_status
            }
        }
    } failure] } {
        set mbody "Error parsing, binding or executing mfl_query_string sql: $failure \n $mfl_query_string"
        error $mbody
        return 1
    }
    set mfl_file_status 'C'
    return $mfl_file_status
}

proc free_db_dandle {} {
    global clr_get clr_get1
    global db_login_handle
    # close all the DB connections
    oraclose $clr_get
    oraclose $clr_get1
    
    if { [catch {oralogoff $db_login_handle } result ] } {
       error "Encountered error $result while trying to close DB handles"
    }
}

proc set_var {} {
    global rightnow cmonth cdate cyear cday
    set rightnow [clock seconds]
    set cmonth [clock format $rightnow -format "%b"]
    set cyear [clock format $rightnow -format "%Y"]
    set cday  [clock format $rightnow -format "%w"]
    global argv inst_list
    ### specify a log file to log within the tcl script
    ### or (the normal) just leave this call to an empty
    ### string and logging will go to stdout and redirect
    ### to the log file specified in the calling script
    MASCLR::open_log_file ""

    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "LOW"
    MASCLR::live_updates
}

proc readCfgFile {} {
    global inst_list file_type cfg_name programName
    set cfg_name "mas_files_in.cfg"
    if {[catch {open $cfg_name} filePtr]} {
        puts "File Open Err in : $programName Cannot open the config file $cfg_name"
        exit 2
    }

    while { [set line [gets $filePtr]] != {}} {
      set lineParms [split $line =]
      switch -exact -- [lindex  $lineParms 0] {
            "INST_LIST" {
                set inst_list [lindex $lineParms 1]
            }
            "FILE_TYPE" {
                set file_type [lindex $lineParms 1]
            }
         default {
            puts "Unknown config parameter [lindex $lineParms 0]"
          }
       }
    }

    close $filePtr
}


proc usage {} {
    global programName
    puts stderr "Usage: $programName -c count_type -t "
    puts stderr "       where -c is a count type (Eg: FANF)"
    puts stderr "Example:  $programName -c FANF"
    exit 1
}

proc arg_parse {} {
    global argv argv0
    global opt_type mailtolist
    set opt_type ""
    while { [ set err [ getopt $argv "hc:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               c {set opt_type $optarg}
               t {set mailtolist "clearing@jetpay.com"}
               v {incr MASCLR::DEBUG_LEVEL}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
}

###########################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)

global programName

set programName [file tail $argv0]
#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement from $programName script"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement  from $programName script"
set msubj_h "$box :: Priority : High - Clearing and Settlement  from $programName script"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement  from $programName script"
set msubj_l "$box :: Priority : Low - Clearing and Settlement  from $programName script"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"



###########################################################################################################
### MAIN ##################################################################################################
###########################################################################################################
proc main {} {
    #GLOBALS
    
    global arr_cfg s_name fname dot cnt_type run_mnth run_year db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb
    global msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global mfl_count mftc_count mfl_file_status
    global rightnow cday
    global rightnow cmonth cdate cyear
    global opt_type programName
   
    readCfgFile
    arg_parse

    #sql logon handles #################################################
   
    connect_to_dbs
    open_cursor_masclr clr_get
    open_cursor_masclr clr_get1
   
    #Initialisation############################
    set_var
    global mfl_count mftc_count mfl_file_status fn_cnt
   
    get_file_type_count
    get_mas_file_log_count
    compare_file_count

    get_mas_file_status
    set fn_cnt 0
    while { ($mfl_file_status == "P") && ($fn_cnt <= 5) } {
        exec sleep 10m
        get_mas_file_status
        if {($mfl_file_status == "P") && ($fn_cnt == 5)} {
            set mbody "MAS files takes more time to process, so $programName process is exiting"
            puts $mbody
            exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist      
            MASCLR::close_all_and_exit_with_code 1
        }
        incr fn_cnt
    }
    MASCLR::log_message " All the expected MAS files are processed"
    free_db_dandle
    MASCLR::close_all_and_exit_with_code 0
}

main

