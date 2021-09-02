#!/usr/bin/env tclsh

################################################################################
# $Id: ach_auto.tcl 4036 2017-01-25 21:40:52Z bjones $
# $Rev: 4036 $
################################################################################

################################################################################

####################### UPDATE BELOW FOR NEW INST ###############################

set inst_id [string trim [lindex $argv 0]]
set cycl [string trim [lindex $argv 1]]

####################### CHANGES STOPS HERE ######################################


set inst_dir "INST_$inst_id"
set subroot "ACH"
set locpth $env(PWD)

##################################################################################

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

#######################################################################################################################


set cd_path "cd out_ach"
set curdate [clock seconds]
set fdate [clock format [clock scan "-0 day"] -format %Y%m%d]
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set upld "1"
#####################################################################################################################
#set bank_ach_email "Clearing.JetPayTX@ncr.com"

set bank_ach_email ""
#####################################################################################################################

#Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists. If the the stop file do not exist
#create the stop file while running this script, so that other process do not start if this scripts completes successfully and removes the stop file at
#the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
    set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : ach_auto.tcl"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    exit 1
} else {
    catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

#grabbing ACH file for upload

#
# 129 - PTC Canadian
# DEFT-RPT859C-W_yyyymmddhhmm
# DEFT-RPT859D-W_yyyymmddhhmm
#
if {$inst_id == "129"} {
   switch $cycl {
    "52" {
           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPT859C-W*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "First File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
           }

           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPT859D-W*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "Second File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
          }
        }
        default {
           puts "File type >$cycl< did not match criteria";
           exit 1
        }
    }
}

#
# 130 - B2B Canadian
# DEFT-RPTCADCR-A_yyyymmddhhmm
# DEFT-RPTCADDR-A_yyyymmddhhmm
#
if {$inst_id == "130"} {
   switch $cycl {
    "52" {
           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPTCADCR-A*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "First File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
           }

           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPTCADDR-A*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "Second File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
          }
        }
        default {
           puts "File type >$cycl< did not match criteria";
           exit 1
        }
   }; #endof switch
}

#
# 134 - PTC Canadian
# DEFT-RPT637C-W_yyyymmddhhmm
# DEFT-RPT637D-W_yyyymmddhhmm
#
if {$inst_id == "134"} {
   switch $cycl {
    "52" {
           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPT637C-W*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "First File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
           }

           set x ""
           set fname ""
           catch {set x [ eval [list exec ls] [glob "DEFT-RPT637D-W*$fdate*"] ]} result;
           puts "x = $x"
           set fname [string range [lindex $x 0] 0 end]
           puts "fname = $fname"
           if { $x != "" } {
             puts "Second File to upload $fname"
             set dummy [catch {exec $locpth/upload.exp $fname >> $locpth/LOG/upload.log} result]
             exec sleep 2
             exec mv $fname ARCHIVE/$fname
             puts "dummy = $dummy"
             set upld 0
             set seq $cycl
          }
        }
        default {
           puts "File type >$cycl< did not match criteria";
           exit 1
        }
    }
}

puts "Found files:- $result"

if {$x == ""} {
    set mbody "ACH file not found in MAS ACH folder"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}

if {$upld == 0} {
   set dummy 0

   #If upload successfull emailing fax form to bank else stoping process.

    if {$dummy == 0} {
      set bank_ach_email ""
      switch $inst_id {
         "129" {set subj "129 $seq"}
         "130" {set subj "130 $seq"}
         "134" {set subj "134 $seq"}
         default {set subj ""}
    }

       #
       # Email the Faxes
       #
       exec cat $inst_id.achfax.CR.txt | mailx -r $mailfromlist -s "$box: ACH File Transmittal $subj CR" \
            reports-clearing.JetPayTX@ncr.com $bank_ach_email

       exec cat $inst_id.achfax.DB.txt | mailx -r $mailfromlist -s "$box: ACH File Transmittal $subj DB" \
            reports-clearing.JetPayTX@ncr.com $bank_ach_email

       #
       # Move Faxes to Archive
       #
       set fname $inst_id.achfax.CR.txt
       exec mv $fname ARCHIVE/sent-$fname

       set fname $inst_id.achfax.DB.txt
       exec mv $fname ARCHIVE/sent-$fname
   }

   file delete /clearing/filemgr/process.stop

} else {
    set mbody "Assist Please contact clearing group or On call Engr. immediately. Clearing ACH failed to upload to bank ftp site.\nFor more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}
