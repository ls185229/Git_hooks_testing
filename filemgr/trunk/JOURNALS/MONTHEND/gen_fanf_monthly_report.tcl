#!/usr/bin/env tclsh

# ###############################################################################
# $Id: gen_fanf_monthly_report.tcl 4008 2017-01-04 21:23:35Z skumar $
# $Rev: 4008 $
# ###############################################################################
#
# File Name:  gen_fanf_monthly_report.tcl
#
# Description:  This script generates the fanf monthly report  
#               from fanf_staging table.
#              
#
# Script Arguments:  
#                    -m = month (Optional)
#                    -y = year (Optional)
#                    -t = TEST MODE (Optional)
#                    -v = verbose level
#
#
# Output:  
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# ###############################################################################
package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib
proc connect_to_dbs {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global programName

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle in $programName"
        puts $mbody
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
        exit 1
    }

}

proc open_cursor_masclr {cursr} {
    global db_login_handle
    global programName
    global $cursr
    if {[catch {set $cursr [oraopen $db_login_handle]} result]} {
        set mbody "$cursr failed to open statement handle in $programName"
        puts $mbody
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
        exit 1    
    }
}


proc free_db_dandle {} {
    global clr_get
    global db_login_handle
    # close all the DB connections
    oraclose $clr_get
    
    if { [catch {oralogoff $db_login_handle } result ] } {
       error "Encountered error $result while trying to close DB handles"
    }
}

proc openOutputFile {} {
    global filePtr programName reportmonth fileName mnth 
    set rightnow [clock seconds]
    set filedate [clock format $rightnow -format %Y%m%d]
    #### open output file
    
    set fileName [format "fanf_check_$filedate.csv"]
    
    if {[catch {open $fileName w} filePtr]} {
       puts "File Open Err:$programName.tcl Cannot open output file $fileName"
       exit 1
    }
}

proc gen_report {} {
    global clr_get cday
    global db_login_handle mas_code_repair_sql filePtr inst_list sql_string
    global mailtolist mailfromlist msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody

    if { [catch {    
        set sql_string "
            SELECT  
              fs.INST_NAME, fs.TAX_ID,
              fs.institution_id inst,  
              fs.entity_id,  
              ae.entity_dba_name,  
              to_char(fs.month_requested, 'YYYY-MM') mnth,  
              fs.num_of_locations locs,  
              fs.cp_percentage cp_pct,  
              fs.cp_amt,  
              fs.cnp_amt,  
              fs.cp_fee,  
              fs.cnp_fee  
            FROM  
              masclr.fanf_staging fs, masclr.acq_entity ae  
            WHERE  
                fs.MONTH_REQUESTED = to_date('$cday','DD-MM-YYYY')  
            and ae.institution_id = fs.institution_id  
            and ae.entity_id = fs.entity_id
            and fs.institution_id in ($inst_list)            
            order by 1, 2, 3, 4"
        MASCLR::log_message "\n inside gen_report query_string: \n$sql_string\n\n" 3
        orasql $clr_get $sql_string
        set col_list [oracols $clr_get]
        puts $filePtr "INST_NAME,TAX_ID,INST,ENTITY_ID,ENTITY_DBA_NAME,MNTH,LOCS,CP_PCT,CP_AMT,CNP_AMT,CP_FEE,CNP_FEE"
        MASCLR::log_message "\n No of rows from sql_string: $col_list" 3
        while {[orafetch $clr_get -dataarray s -indexbyname] != 1403} {
            puts $filePtr  "$s(INST_NAME),$s(TAX_ID),$s(INST),$s(ENTITY_ID),$s(ENTITY_DBA_NAME),$s(MNTH),$s(LOCS),$s(CP_PCT),$s(CP_AMT),$s(CNP_AMT),$s(CP_FEE),$s(CNP_FEE)"
        }            
    } failure] } {
        set mbody "Error parsing, binding or executing gen_report sql query : $failure \n $sql_string"
        error $mbody
        return 1
    }
    close $filePtr 
    return 0        
        
}

proc send_report {} {
    global reportmonth fileName programName mbody_h sysinfo 
    global mbody mailfromlist  mailtolist msubj_h
    if {[catch {exec echo "See attached FANF report for - $reportmonth" | mutt -a $fileName -s "FANF - $reportmonth" -- reports-clearing@jetpay.com } ] != 0 } {
        set mbody "Unable to send the FANF report file: $result in $programName"
        puts $mbody
        exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
        exit 1   
    } else {
        exec mv $fileName ARCHIVE/sent-$fileName
    }
}

proc readCfgFile {} {
    global inst_list file_type cfg_name programName
    set cfg_name "fanf.cfg"
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
         default {
            puts "Unknown config parameter [lindex $lineParms 0]"
          }
       }
    }

    close $filePtr
}


proc usage {} {
    global programName
    puts stderr "Usage: $programName -m month -y year -t "
    puts stderr "       where -m month fanf report to be generated(Optional - Default current month)"
    puts stderr "       where -y year fanf report to be generated(Optional -Default current year)"    
    puts stderr "Example:  $programName -c FANF"
    exit 1
}

proc arg_parse {} {
    global argv argv0
    global opt_type mailtolist mnth year
    set opt_type ""
    global rightnow cmonth cdate cyear cday reportmonth
    set rightnow [clock seconds]
    set cmonth [clock format $rightnow -format "%m"]
    set cyear [clock format $rightnow -format "%Y"]
    set mnth ""
    set year ""
    set cday ""
    
    while { [ set err [ getopt $argv "hm:y:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               m {set mnth $optarg}
               y {set year $optarg}
               t {set mailtolist "clearing@jetpay.com"}
               v {incr MASCLR::DEBUG_LEVEL}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
    set rightnow [clock seconds]
    set reportmonth [clock format $rightnow -format "%B %Y"]
    if { [string length $mnth] != 0 && [string length $year] != 0 } {
        set cday [format "01-%02d-%d" $mnth $year]
    } elseif { [string length $mnth] != 0 } {
        set cday [format "01-%02d-%d" $mnth $cyear]
    } else {
        set cday [clock format [clock scan "-1 month" -base [clock seconds]] -format 01-%m-%Y]
        set reportmonth [clock format [clock scan "-1 month" -base [clock seconds]] -format "%B %Y"]
    }
}
# ##########################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)

global programName

set programName [file tail $argv0]
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



###########################################################################################################
### MAIN ##################################################################################################
###########################################################################################################
proc main {} {
    #GLOBALS
    
    global arr_cfg s_name fname dot cnt_type run_mnth run_year db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb
    global msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    #set_var
    arg_parse
    readCfgFile
    
    openOutputFile
    #sql logon handles #################################################
    
    connect_to_dbs
    open_cursor_masclr clr_get
    gen_report
    send_report
    free_db_dandle
    MASCLR::close_all_and_exit_with_code 0
}

main
