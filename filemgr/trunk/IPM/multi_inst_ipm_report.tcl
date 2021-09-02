#!/usr/bin/env tclsh

################################################################################
# $Id: multi_inst_ipm_report.tcl 4910 2019-10-21 18:47:22Z smiller $
# $Rev: 4910 $
################################################################################
#
# File Name:  multi_inst_ipm_report.tcl
#
# Description:  This program parses through the incoming MasterCard reports by 
#               instititution.
#              
# Script Arguments:  Report date = sysdate.  Required.
#                    Default = sysdate
#
# Output:  Reports by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib

puts "Start..."

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

set mbody_c "ASSIST :: \n Contact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \n Contact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \n Inform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \n Inform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \n Assign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: /clearing/filemgr/IPM/ \n\n"

set logdate [clock format [clock seconds] -format "%Y%m%d"]
set logfile "./LOG/ipm.t140.rpt.log"
set err ""
set curdate [clock format [clock seconds] -format "%Y%m%d"]
set timestamp [clock format [clock seconds] -format "%Y%m%d%M%H%S"]

set ind_on_101 1
set ind_on_105 1
set ind_on_107 1
set ind_on_117 1
set ind_on_121 1
set ind_on_127 1
set ind_on_129 1
set ind_on_130 1
set ind_on_134 1

puts "Log Date: $logdate"

exec echo "Log Date: $logdate" >> $logfile

proc chk_err {errorv errmsg} {
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h 
    global msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo err

    if {$errorv == ""} {
        #exec echo "\n Done -- $errmsg \n " >> $logfile
    } else {
        puts "Err: \n $errmsg \n $errorv"
        set mbody "Err: \n $errmsg \n $errorv \n"
		MASCLR::mutt_send_mail $mailtolist  "$msubj_u" "$mbody_u $sysinfo $mbody" 
        exit 1
    }
}

proc skp_err {errorv errmsg} {
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h 
    global msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo err

    if {$errorv == ""} {
        #exec echo "\n Done -- $errmsg \n " >> $logfile
    } else {
        puts "Err: \n $errmsg \n $errorv"
        set mbody "Err: \n $errmsg \n $errorv \n"
		MASCLR::mutt_send_mail $mailtolist  "$msubj_u" "$mbody_u $sysinfo $mbody" 
    }
}

if {$argc == 1} {
    set logdate [string trim [lindex $argv 0]]
    puts "logdate: >$logdate<"
    catch {exec ./recv_file_frm_mfe.exp >> $logfile} err
    #catch {set y [exec find ./ARCHIVE -name ORIG.IPM.TT140.$logdate.zip]} result

    #if {[file exists ORIG.IPM.TT140.$logdate]} {
    #    file rename ./ORIG.IPM.TT140.$logdate $timestamp-ORIG.IPM.TT140.$logdate
    #}

    #exec unzip $y
    #set ttf [glob $env(PWD)/ORIG.IPM.TT140.$logdate/TT*]

    #foreach attf $ttf {
    #    exec cp $attf $env(PWD)
    #    file delete $attf
    #}

    set olddir "ORIG.IPM.TT140.$logdate"
    catch {exec mkdir ORIG.IPM.TT140.$logdate >> $logfile} err
    #if {[file isdirectory ./$olddir]} {
    #    file delete ./$olddir
    #}

} else {
    set logdate [clock format [clock seconds] -format "%Y%m%d"]
    catch {exec ./recv_file_frm_mfe.exp >> $logfile} err
    puts "Argc <> 1 revc err result: $err"
#    chk_err $err "./recv_file_ftp.exp >> $logfile"

    if {[file exists ORIG.IPM.TT140.$logdate]} {
        file rename ./ORIG.IPM.TT140.$logdate $timestamp-ORIG.IPM.TT140.$logdate
    }

    set origdir "ORIG.IPM.TT140.$logdate"
    catch {exec mkdir ORIG.IPM.TT140.$logdate >> $logfile} err
#   chk_err $err "./recv_file_ftp.exp >> $logfile"
}

catch {set tt140 [exec find . -name TT* -mtime 0 | grep -v ORIG.IPM.TT140 ]} result
puts "result: $result"
puts "tt140: $tt140"

set arr_cfg(0) 0

if {$tt140 == ""} {
    set mbody "REPORTS NOT FOUND.\n"
	MASCLR::mutt_send_mail  $mailtolist $msubj_l "$mbody_l $sysinfo $mbody" 
}

if {[llength $tt140] != "6" } {
    set mbody "T140 FILE COUNT IS NOT 6. PLEASE VERIFY ALL FILES ARE DOWNLOADED THEN RUN REPORTS AGAIN.\n" 
	MASCLR::mutt_send_mail  $mailtolist $msubj_l "$mbody_l $sysinfo $mbody" 
	
    foreach infile $tt140 {
        file delete $infile
    }
    if {[file exists ORIG.IPM.TT140.$logdate]} {
        catch {exec rmdir ORIG.IPM.TT140.$logdate >> $logfile} err
    }
    chk_err $err "rmdir ORIG.IPM.TT140.$logdate >> $logfile"
    exit 1
}

proc get_cfg {cfg_pth} {
    global arr_cfg trknbr_list
    set cfg_file "ipm.t140.cfg"
    set in_cfg [open $cfg_pth/$cfg_file r]
    set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
    while {$cur_line != ""} {
        if {[string toupper [string trim [lindex $cur_line 0]]] != "" && \
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

set i 1

foreach trknbr $trknbr_list {
    set ind_on_101 1
    set ind_on_105 1
    set ind_on_107 1
    set ind_on_117 1
    set ind_on_121 1
    set ind_on_127 1
    set ind_on_130 1

    puts "PWD: [pwd]"
    set inst_id "$arr_cfg(inst_id.$trknbr)"
    set network "$arr_cfg(network.$trknbr)"
    set zipfilename "$inst_id-MCDailyReports-[string range $trknbr 16 end]-$logdate"
    if {[file exists $zipfilename]} {
        file rename $zipfilename $timestamp-$zipfilename 
    } else {
        exec mkdir $zipfilename
    }

    foreach infile $tt140 {
        set input [open $infile r]
        set i 1
        set chk2 0
        set brk 1
        set chk4 6
        set prnt 1
        set oprt 1
        set skp 1
        set replacepan "N"

        set outfile "DT$curdate.[string range $trknbr 16 end].[string range $infile 2 end]"

        while {! [eof $input]} {
            set cur_line(0) [set orig_line [gets $input]]
            set cr_line  [split $orig_line \ ]
            set chk1 "[lindex $cr_line 43] [lindex $cr_line 44]"

            set chkfpan "[string trim [lindex $cr_line 0]]"
            set chkpan "[string range $cur_line(0) 17 21]"

            if {$chkpan == "D0002"} {
                set cur_line(0) "[string range $cur_line(0) 0 34]XXXXXXXX[string range $cur_line(0) 43 end]" 
                set chkpan ""
            }

            if {$chkfpan == "1IP142110-AA"} {
                set replacepan "Y"
            } elseif {[string trim $cur_line(0)] == "NO DATA TO REPORT"} {
                set replacepan "N"
            } else {
                set replacepan $replacepan
            }

            if {$replacepan == "Y"} {
                set fpan "[string trim [string range $cur_line(0) 111 end]]"
                if {$fpan > "300000000" && [string is digit $fpan]} {
                    set cur_line(0) "[string range $cur_line(0) 0 114]XXXXXXXX[string range $cur_line(0) 123 end]"
                } else {
                    set cur_line(0) $cur_line(0)
                }
            }

            if {$oprt == 0 && $chk1 != "MASTERCARD WORLDWIDE"} {
                exec echo $cur_line(0) >> $outfile
            }

            if {$chk1 == "MASTERCARD WORLDWIDE"} {
                set i 1 
                while {$chk4 >= $i} {
                    set cur_line($i) [set orig_line [gets $input]]
                    set chk [string range [string trim $cur_line($i)] 0 21]
                    set errdt [string range [string trim $cur_line($i)] 0 11]

                    if {$errdt == "ERROR DETAIL" && $skp == 0} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                        set oprt 0
                        set prnt 1
                        break
                    }

                    if {$chk == $trknbr} { 
                        set ind_on_$arr_cfg(inst_id.$trknbr) 0
                    } else {
                        set ind_on_$arr_cfg(inst_id.$trknbr) 1
                    }

                    switch $chk {
                           "MEMBER ID: 00000004013"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_101; 
                                        set oprt $ind_on_101; 
                                        set skp $ind_on_101; 
                                        break}
                           "MEMBER ID: 00000005165"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_105; 
                                        set oprt $ind_on_105; 
                                        set skp $ind_on_105; 
                                        break}
                           "MEMBER ID: 00000010279"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_107; 
                                        set oprt $ind_on_107; 
                                        set skp $ind_on_107; 
                                        break}
                           "MEMBER ID: 00000012539"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_117; 
                                        set oprt $ind_on_117; 
                                        set skp $ind_on_117; 
                                        break}
                           "MEMBER ID: 00000014755"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_121; 
                                        set oprt $ind_on_121; 
                                        set skp $ind_on_121; 
                                        break}
                           "MEMBER ID: 00000015547"  
                                       {set i [expr $i + 1]; 
                                        set prnt $ind_on_127; 
                                        set oprt $ind_on_127; 
                                        set skp $ind_on_127; 
                                        break}
                           "MEMBER ID: 00000017117"
                                       {set i [expr $i + 1];
                                        set prnt $ind_on_129;
                                        set oprt $ind_on_129;
                                        set skp $ind_on_129;
                                        break}
                           "MEMBER ID: 00000017165"
                                       {set i [expr $i + 1];
                                        set prnt $ind_on_130;
                                        set oprt $ind_on_130;
                                        set skp $ind_on_130;
                                        break}
                           "MEMBER ID: 00000017105"
                                       {set i [expr $i + 1];
                                        set prnt $ind_on_134;
                                        set oprt $ind_on_134;
                                        set skp $ind_on_134;
                                        break}
                           "MEMBER ID: 00000008183"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; break}                                
                           "MEMBER ID: 00000004485"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; 
                                        break}
                           "MEMBER ID: 00000006919"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; 
                                        break} 
                           "MEMBER ID: 00000008164"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; break}
                           "MEMBER ID: 00000008272"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; 
                                        break}
                           "MEMBER ID: 00000004358"  
                                       {set i [expr $i + 1]; 
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1; 
                                        break}
                           default     {
                                        set prnt 1; 
                                        set oprt 1; 
                                        set skp 1}
                    }
                    set i [expr $i + 1]
                }

                if {$prnt == 0} {
                    if {$i == 1} {
                        exec echo $cur_line(0) >> $outfile
                    } elseif {$i == 2} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                    } elseif {$i == 3} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                        exec echo $cur_line(2) >> $outfile
                    } elseif {$i == 4} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                        exec echo $cur_line(2) >> $outfile
                        exec echo $cur_line(3) >> $outfile
                    } elseif {$i == 5} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                        exec echo $cur_line(2) >> $outfile
                        exec echo $cur_line(3) >> $outfile
                        exec echo $cur_line(4) >> $outfile
                    } elseif {$i == 6} {
                        exec echo $cur_line(0) >> $outfile
                        exec echo $cur_line(1) >> $outfile
                        exec echo $cur_line(2) >> $outfile
                        exec echo $cur_line(3) >> $outfile
                        exec echo $cur_line(4) >> $outfile
                        exec echo $cur_line(5) >> $outfile
                    }
                    set prnt 1
                }
            }
        }
        exec mv $outfile ./$zipfilename
    }
    puts "outfile: >$outfile<"
    puts "zipfilename: >$zipfilename<"
 
    set zipfolder $zipfilename
    puts "zipfolder: >$zipfolder<"

    catch {exec zip -r $zipfolder $zipfolder >> $logfile} err
    chk_err $err "zip -r $zipfolder $zipfolder >> $logfile"

    catch {exec rm -r $zipfolder >> $logfile} err
    chk_err $err "rm -r $zipfolder >> $logfile"

    catch {exec cp $zipfolder.zip ./INST_$inst_id/ >> $logfile} err
    chk_err $err "cp $zipfolder.zip ./INST_$inst_id/ >> $logfile"

    catch {exec mv $zipfolder.zip ./INST_$inst_id/ARCHIVE/ >> $logfile} err
    chk_err $err "mv $zipfolder.zip ./INST_$inst_id/ARCHIVE/ >> $logfile"

    if { $inst_id != "101" && $inst_id != "107" && $inst_id != "127" && $inst_id != "129" && $inst_id != "130" && $inst_id != "134" } { 
        catch {exec mv ./INST_$inst_id/ARCHIVE/$zipfolder.zip ./INST_$inst_id/UPLOAD/ >> $logfile} err
        chk_err $err "mv ./INST_$inst_id/ARCHIVE/$zipfolder.zip ./INST_$inst_id/UPLOAD/ >> $logfile"

        cd ./INST_$inst_id/UPLOAD
        catch {exec upload.exp $zipfolder.zip >> ftp.log} err
        chk_err $err "upload.exp $zipfolder.zip >> ftp.log"

        if {$err == ""} {
            chk_err $err "upload.exp $zipfolder.zip >> $logfile"
        } else {
            skp_err $err "upload.exp $zipfolder.zip >> $logfile"
        }

        cd ../..
    }
}


if {$argc == 0} {
    foreach infile $tt140 {
        catch {exec mv $infile ./$origdir/ >> $logfile} err
        chk_err $err "mv $infile ./$origdir/ >> $logfile" 
    }

    catch {exec zip -r $origdir.zip $origdir >> $logfile} err
    chk_err $err "zip -r $origdir.zip $origdir >> $logfile"

    catch {exec rm -r $origdir >> $logfile} err
    chk_err $err "rm -r $origdir >> $logfile"

    catch {exec mv $origdir.zip ./ARCHIVE >> $logfile} err
    chk_err $err "mv $origdir.zip ./ARCHIVE >> $logfile"

    if {$err == ""} {
        catch {exec delete_files_frm_mfe.exp >> $logfile} err
        chk_err $err "delete_files_frm_mfe.exp >> $logfile"
    }

} else {
    foreach infile $tt140 {
        file delete $infile
    }
}


#################################################
# Setting up the email portion of this script
#################################################

#set mdate   [clock format [clock seconds] -format "%Y-%m-%d"]
set mdate [clock format [clock scan $logdate] -format "%Y-%m-%d"]
puts "Email subject date: >$mdate<"
set email_lst "Reports-clearing@jetpay.com"

set email_body "
Dear Sir/Madam, \n
Attached are the MasterCard daily reports for today. If there is any question please contact us.  \n\n
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

foreach inst_id {101 107 117 121 127 129 130 134} {

    set filelist ""
    set attachement_lst ""
    set locpth ""
    set email_subject " $inst_id MC Daily Reports $mdate"
    set inst_dir "INST_$inst_id"
    set locpth "/clearing/filemgr/IPM/$inst_dir"

    cd $locpth
    puts "Changing directory to $locpth..."
    # Search for only files belonging to the given day
    set filelist [glob -nocomplain -directory "./" -types f "$inst_id-MCDailyReports-*-$logdate.zip"]
    puts "File list: $filelist"
    # Creat a list of attachements adding "-a" to each file
    foreach fl $filelist {
        puts "Attaching: >[file tail $fl]<"
        append attachement_lst " [file tail $fl]"
    }

    # Email out all the reports
    puts "PWD: [pwd]"

	MASCLR::mutt_send_mail  $$email_lst $email_subject "$email_body" $attachement_lst


    # Clean up all the reports from this directory
    foreach fl $filelist {
        file delete $fl
    }
}


exec echo "------------------------------------------" >> .$logfile

##### THE END #####

