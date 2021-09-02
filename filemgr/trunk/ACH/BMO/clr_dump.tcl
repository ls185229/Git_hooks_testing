#!/usr/bin/env tclsh
# ~/.profile

################################################################################
# $Id: clr_dump.tcl 4720 2018-09-27 20:58:06Z skumar $
# $Rev: 4720 $
################################################################################
#
# File Name:  clr_dump.tcl
#
# Description:  This program displays the contents of a specified ACH file.
#               It invokes net_zero_file.tcl, as well.
#
# Script Arguments:  file_name = Name of file to display.
#                    seq       (optional sequence number for muliple files)
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################
lappend auto_path $env(MASCLR_LIB)
source $env(MASCLR_LIB)/masclr_tcl_lib

set debug true
set debug_level 4
set MASCLR::DEBUG_LEVEL 4
#Environment variables.......

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
set locPath $env(PWD)

#################################################################################

### Set Global Variables
set programName "[lindex [split [file tail $argv0] .] 0]"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y/%m/%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
exec sleep 1

proc chkresult {alert_msg} {
    global programName
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id
    if {$alert_msg != ""} {
        puts "$programName : chkresult -  $alert_msg "
        if { [catch { exec echo "$mbody_c $sysinfo $alert_msg" | mutt -s "$msubj_c" -- $mailtolist } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
        }
        exit 1
    }
}; #end of chkresult

proc create_fax_dump_file {inst_id file_type filePtr bank fdate} {
   global curdate
   global locPath
   global programName
   global box

   set result ""
   if { ($inst_id == "101" || $inst_id == "107") && ($file_type == "52") } {
        set achfax "$inst_id\_ACH\_$bank\_$file_type\_$fdate.achfax.txt"
        set achdump "$inst_id\_ACH\_$bank\_$file_type\_$fdate.dump.txt"
   } else {
        set achfax  "$inst_id.$file_type.achfax.txt"
        set achdump "$inst_id.$file_type.dump.txt"
   }

   MASCLR::log_message "$programName Fax file $achfax"
   MASCLR::log_message "$programName ACH dump file $achdump"

   ### Create fax
   if {[file exists $achfax]} {
      catch {file delete $achfax} result
   }
   catch {exec $locPath/fax_form.tcl $filePtr $inst_id $file_type >> $achfax} result
   chkresult $result

   ### Create ACH view
   if {[file exists $achdump]} {
      catch {file delete $achdump} result
   }
   catch {exec $locPath/dump_ach.tcl $filePtr >> $achdump} result
   chkresult $result

   ### Email the fax and view
   if { [catch { exec cat $achfax \
    | mutt -a $achfax -a $achdump -s "$box :: $inst_id $bank NCR PS Texas Fax $curdate" \
        -- reports-clearing.JetPayTX@ncr.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }

   file delete $achdump
} ; #endof create_fax_dump_file

proc create_dest_ach_file {in_file out_file } {
    global line_count tax_id
    global programName blocking_flag

    if {[catch {open $in_file r} in_file_ptr]} {
        MASCLR::log_message "ERROR: $programName Cannot open input file $in_file"
        exit 1
    }

    if {[catch {open $out_file w } out_file_ptr]} {
        MASCLR::log_message stderr "Cannot open $out_file : $out_file_ptr"
        exit 1
    }

    while {[set line [gets $in_file_ptr]] != {}} {
        switch [string range $line 0 0] {
            "8" {
                set bt_rec ""
                append bt_rec [string range $line 0 43]
                append bt_rec $tax_id
                append bt_rec [string range $line 54 94]
                puts $out_file_ptr $bt_rec
                incr line_count
            }
            "1" {
                puts $out_file_ptr $line
                incr line_count
            }
            "5" {
                puts $out_file_ptr $line
                incr line_count
            }
            "6" {
                puts $out_file_ptr $line
                incr line_count
            }
            "9" {
                puts $out_file_ptr $line
                incr line_count
            }
            default {
                puts $line
                #incr line_count
            }
        }
    } ; # end while. . .

    if {$blocking_flag == "YES"} {
        #puts "cnt is $line_count"
        set blocking_line "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\r"
        set line_count [expr $line_count % 10]
        if {$line_count > 0} {
        set line_count [expr 10 - $line_count]
        }
        
        for {set cntr 0} {$cntr < $line_count} {incr cntr 1} {
        puts $out_file_ptr $blocking_line
        }
    }
    close $in_file_ptr
    close $out_file_ptr
}; #end of create_dest_ach_file

#Procedure to Parse the config file
proc read_cfg_file {} {
    global cfg_file_name cur_line 
    global inst_id fbank tax_id blocking_flag
    global encrypt_flag mode
    global key1 key2
    
    set cfg_file_name "bmo_harris.cfg" 
    MASCLR::log_message "Inside read_cfg_file function"
    if {[catch {open $cfg_file_name r} file_ptr]} {
        MASCLR::log_message " ERROR :: File Open Error: Cannot open config file $cfg_file_name"
        exit 1
    }

    set fbank ""
    set blocking_flag ""
    set encrypt_flag ""
    set key1 ""
    set key2 ""
    set tax_id ""
    set cur_line ""
    set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    while {$cur_line != ""} {
      if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_id } {
         set tax_id [lindex $cur_line 1]
         set fbank [lindex $cur_line 2]
         set blocking_flag [lindex $cur_line 5]
         set encrypt_flag [lindex $cur_line 6]
         set key1 [lindex $cur_line 7]
         set key2 [lindex $cur_line 8]
      }
      set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    }
    MASCLR::log_message "bank $fbank, tax_id : $tax_id , blocking_flag : $blocking_flag" 3
    MASCLR::log_message "encrypt_flag $encrypt_flag, key1 $key1, key2 $key2" 3
}; #end of read_cfg_file

### MAIN FUNCTION ###
global tax_id blocking_flag fbank
global encrypt_flag key1 key2 mode

set file_name [lindex $argv 0]
set file_seq  [lindex $argv 1]
set mode [lindex $argv 2]
set MASCLR::DEBUG_LEVEL [lindex $argv 3]

MASCLR::log_message "Inside clr_dump , Processing file : $file_name" 3
set orig_line $file_name
set varlist [split $orig_line .]
MASCLR::log_message "Inside clr_dump, variable list from filename : $varlist" 4

set inst_id     [lindex $varlist 0]
set file_cat    [lindex $varlist 1]
set file_type   [lindex $varlist 2]
set fbank       [lindex $varlist 3]
set fjdate      [lindex $varlist 4]
set fseq        [lindex $varlist 5]


read_cfg_file

if { $file_type == "62" } {
    set fbank "FIRSTPREMIER"
}

MASCLR::log_message "Log time $curdate" 3
exec cd $env(PWD)
global fname
set result ""
set return_status ""

if { ($inst_id == "101" || $inst_id == "107") && ($file_type == "52") } {
    set fname "$inst_id\_ACH\_$fbank\_$file_type\_$cdate.ach"
    MASCLR::log_message "$programName ACH file name - $fname"
    create_dest_ach_file $file_name $fname
    create_fax_dump_file $inst_id $file_type $fname $fbank $cdate

} else {
    set fname "$inst_id\_ACH_2\_$fbank\_$file_type\_$cdate.ach"
    MASCLR::log_message "ACH file name $fname"
    set return_status [catch {exec $env(PWD)/net_zero_file.tcl -i $file_name -o $fname -v $MASCLR::DEBUG_LEVEL } result]
    MASCLR::log_message "After net_zero_file call status - <$return_status>" 3
    if { $return_status != 0 } {
        chkresult $result
    }
    create_fax_dump_file $inst_id $file_type $fname $fbank $cdate
    MASCLR::log_message "After the first premier fax file creation" 3
}
set result ""
if { ($encrypt_flag == "YES") && ($file_type == "52") } {
    if { [string length $key2] > 0 && [string length $key1] > 0 } {
        MASCLR::log_message "File Encryption using 2 keys" 3
        catch {exec gpg --batch --armor --no-tty \
          --output $fname.gpg --encrypt --no-secmem-warning \
          --recipient $key1 --recipient $key2 $fname} result
    } elseif { [string length $key1] > 0 } {
        MASCLR::log_message "File Encryption using 1 keys" 3
        catch {exec gpg --batch --armor --no-tty \
          --output $fname.gpg --encrypt --no-secmem-warning \
          --recipient $key1 $fname} result
    } else {
        set errmsg "Encryption keys are not present in the configuration file"
        chkresult $errmsg
    }
    chkresult $result
    if {$result == ""} {
        MASCLR::log_message "File Encryption success: $fname"
        exec mv $file_name ARCHIVE
        exec mv $fname ARCHIVE
    }
} else {
    MASCLR::log_message "File Encryption is DISABLED"
    exec mv $file_name ARCHIVE
}

