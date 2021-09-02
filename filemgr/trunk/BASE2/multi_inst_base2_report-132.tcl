#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: multi_inst_base2_report-132.tcl 4910 2019-10-21 18:47:22Z smiller $
# $Rev: 4910 $
################################################################################
#
# File Name:  multi_inst_base2_report-132.tcl
#
# Description:  This program parses through the incoming Visa reports by
#               Settlement Reporting Entity (SRE).
#
# Script Arguments:  logdate = Report date.  Required.
#                    Default = Today's date
#
# Output:  Reports by SRE.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#import Mail functions
source $env(MASCLR_LIB)/masclr_tcl_lib

#Environment variables
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

#Email Subjects variables Priority wise
set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"

#Email Body Headers variables for assist
set mbody_c "ASSIST :: \n Contact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \n Contact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \n Inform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \n Inform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \n Assign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################

set logdate [clock format [clock seconds] -format "%Y%m%d"]
set err ""
set logfile "./LOG/base2.epd.rpt.log"

if {$argc == 1} {
    set logdatetmp [string trim [lindex $argv 0]]
    set logdate [clock format [clock scan $logdatetmp] -format %Y%m%d]
}

exec echo "Log Date: $logdate" >> $logfile

proc chk_err {errorv errmsg} {

  global box clrpath maspath mailtolist mailfromlist msubj_c msubj_u msubj_h
  global msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo err

  if {$errorv == ""} {
      #exec echo "\n Done -- $errmsg \n " >> $logfile
  } else {
          puts "Err: \n $errmsg \n $errorv"
          set mbody "Err: \n $errmsg \n $errorv \n"
		  MASCLR::mutt_send_mail  $mailtolist "$msubj_u" "$mbody_u $sysinfo $mbody" 
          exit 1
         }
}


set trknbr_list {}

proc get_cfg {cfg_pth} {
  global arr_cfg trknbr_list

  set cfg_file "base2.epd-132.cfg"
  set in_cfg [open $cfg_pth/$cfg_file r]
  set cur_line  [split [set orig_line [gets $in_cfg] ] ~]

  while {$cur_line != ""} {
    if {[string toupper [string trim  [lindex $cur_line 0]]] != "" && \
        [string toupper [string range [lindex $cur_line 0] 0 0]] != "#"} {
         lappend trknbr_list [lindex $cur_line 0]
         set arr_cfg(inst_id.[lindex $cur_line 0]) [lindex $cur_line 1]
         set arr_cfg(network.[lindex $cur_line 0]) [lindex $cur_line 2]
         }
         set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
         }
return arr_cfg
}

get_cfg ./CFG

        # First download the VISA SRE file from the window box
  catch {exec /clearing/filemgr/BASE2/recv_file_ftp-132.exp $logdate >> $logfile} err
  chk_err $err "./recv_file_ftp-132.exp >> $logfile"


        # Extract SRE reports from the VISA SRE file
foreach trknbr $trknbr_list {
  set l 1
  set infile "EP747.txt"
  set outfile "SRE$trknbr"
  set input [open $infile r]

  if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
    puts "Cannot create : $fileid"
    exit 1
  }
  exec echo "\n $outfile \n" >> $logfile
  puts "About to start reading $infile and dumping to $outfile. EOF Status: [eof $input]"
  while {! [eof $input]} {
    set cur_line0 [set orig_line [gets $input]]
    set line1 [string range [string trim $cur_line0] 0 8]
    #puts "line1: >$line1<"
    #puts "cur_line0: >$cur_line0<"
    if {$line1 == "REPORT ID"} {
      set cur_line2 [set orig_line [gets $input]]
      set line2 [string range [string trim $cur_line2] 20 29]

      if {$line2 == "$trknbr"} {

        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
            puts stderr "Cannot open /duplog : $fileid"
        } else {
            if {$l == 1} {
                puts $fileid "[string range $cur_line0 1 end]"
                incr l
            } else {
                puts $fileid "$cur_line0"
                incr l
                   }

            close $fileid
               }
        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
            puts stderr "Cannot open /duplog : $fileid"
        } else {
            puts $fileid $cur_line2
            close $fileid
               }

        set x 1
        while {$x == 1} {
               set cur_line2  [set orig_line [gets $input]]
               if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                   puts stderr "Cannot open /duplog : $fileid"
               } else {
                   puts $fileid $cur_line2
                   close $fileid
                      }
               if { ( [string match {*END OF VSS*} $cur_line2] == 1 || [string match {*NO DATA FOR THIS REPORT*} $cur_line2] == 1 ) } {
                    set x 5
               }
               if {[eof $input]} {
                   set x 5
               }
        }
      }
    }
  }

  if { [file size $outfile] == 0} {
    puts $fileid "*NO REPORTS EXIST FOR $trknbr*"
    close $fileid
  }

  close $input

  set inst_id "$arr_cfg(inst_id.$trknbr)"
  set network "$arr_cfg(network.$trknbr)"
  set pdffilename "VSReport-$outfile-$logdate.epd"

  exec cp -f $outfile $pdffilename

  puts "outfile: $outfile"
  puts "pdf filename: $pdffilename"

  set zipfolder "VSDailyReports-$inst_id-$network-$logdate"

  puts "zipfolder: $zipfolder"

  catch {exec mkdir $zipfolder >> $logfile} err
  chk_err $err "mkdir $zipfolder >> $logfile"

  catch {exec cp -f $pdffilename $zipfolder >> $logfile} err
  chk_err $err "cp -f $pdffilename $zipfolder >> $logfile"

  catch {exec zip -r $zipfolder $zipfolder >> $logfile} err
  chk_err $err "zip -r $zipfolder $zipfolder >> $logfile"

  catch {exec rm -r $zipfolder >> $logfile} err
  chk_err $err "rm -r $zipfolder >> $logfile"

  catch {exec mv -f $pdffilename ./INST_$inst_id/ARCHIVE/ >> $logfile} err
  chk_err $err "mv -f $pdffilename ./INST_$inst_id/ARCHIVE/ >> $logfile"

  catch {exec cp -f $zipfolder.zip ./INST_$inst_id/ >> $logfile} err
  chk_err $err "cp -f $zipfolder.zip ./INST_$inst_id/ >> $logfile"

  catch {exec rm -r $zipfolder.zip >> $logfile} err
  chk_err $err "rm -r $zipfolder.zip >> $logfile"

  file delete $outfile

}; #end of foreach


#################################################
# Setting up the email portion of this script
#################################################

set mdate "[clock format [clock scan $logdate] -format %Y-%m-%d]"
set email_lst "Reports-clearing@jetpay.com"

set email_body "
Dear Sir/Madam, \n
Attached are the VISA daily reports for today. If there is any question please contact us.  \n\n
Thank you, \n\n
Clearing Group
Jetpay LLC.
Email: clearing@jetpay.com
Toll Free: (800) 834-4405
Local: (972) 503-8900
Fax: (972) 503-9100 \n
*This message is intended only for the use of the Addressee and may contain information that is \
PRIVILEGED and CONFIDENTIAL. If you are not the intended recipient, you are hereby notified that \
any dissemination of this communication is strictly prohibited. If you have received this \
communication in error, please erase all copies of the message and its attachments and notify us \
immediately.
Thank You."

foreach inst_id {132} {
  set filelist ""
  set attachement_lst ""
  set locpth ""
  set email_subject " $inst_id Visa Daily Reports $mdate"
  set inst_dir "INST_$inst_id"
  set locpth "/clearing/filemgr/BASE2/$inst_dir"

  cd $locpth

        # Search for only files belonging to the given day
  set filelist [glob -nocomplain -directory "./" -types f "VSDailyReports-$inst_id-*-$logdate.zip"]

        # Creat a list of attachements adding "-a" to each file
  foreach fl $filelist {
    append attachement_lst " -a [file tail $fl]"
  }

        # Email out all the reports

  MASCLR::mutt_send_mail $email_lst "$email_subject" "$email_body" $attachement_lst


        # Clean up all the reports from this directory
   foreach fl $filelist {
     file delete $fl
   }
}


exec echo "------------------------------------------" >> .$logfile

##### THE END #####
