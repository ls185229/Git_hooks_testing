#!/usr/bin/env tclsh
# ~/.profile

################################################################################
# $Id: clr_dump.tcl 4242 2017-07-25 14:08:04Z lmendis $
# $Rev: 4031 $
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

proc chkresult {result} {
    global programName
    if {$result != ""} {
        puts "$programName : chkresult -  $result "
        #exit 1
    }
}

proc create_fax_dump_file {inst_id file_type txn_type filePtr bank seq } {
   global curdate
   global locPath
   global programName
   global box

   set result ""
   set achfax  "$inst_id.achfax.$file_type.$seq.txt"
   set achdump "$inst_id.dump.$file_type.$seq.txt"
   puts "$programName Fax file $achfax"
   puts "$programName ACH dump file $achdump"

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
    | mutt -a $achfax -a $achdump -s "$box :: $inst_id $bank $seq Clearing Fax $curdate" \
        -- reports-clearing.JetPayTX@ncr.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }

   file delete $achdump
} ; #endof create_fax_dump_file

### MAIN FUNCTION ###
set file_name [lindex $argv 0]
set file_seq  [lindex $argv 1]

puts $file_name
set orig_line $file_name
set varlist [split $orig_line .]
puts $varlist

set inst_id     [lindex $varlist 0]
set file_cat    [lindex $varlist 1]
set file_type   [lindex $varlist 2]
set fbank       [lindex $varlist 3]
set fjdate      [lindex $varlist 4]
set fseq        [lindex $varlist 5]

if {$inst_id == "101" || $inst_id == "107"} {
   if {$file_type == "52"} {
      set fbank "WELLSFARGO"
   }
}

if {[string length $fbank] <= 3 && $file_type == "62"} {
    set fbank "FIRSTPREMIER"
}

puts "Log time $curdate"
exec cd $env(PWD)

set fname "$inst_id-ACH_2_$fbank-$file_type-$cdate.ach"
puts $fname

catch {exec $env(PWD)/net_zero_file.tcl $file_name $fname} result
puts $result
chkresult $result

create_fax_dump_file $inst_id $file_type "" $fname $fbank $file_seq

exec mv $file_name ARCHIVE
if {$inst_id == 105 && (($file_type == "52") || ($file_type == "92"))} {
    exec mv $fname ARCHIVE
}
