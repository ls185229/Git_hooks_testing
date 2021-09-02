#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: check_log_for_error.tcl 3420 2015-09-11 20:05:17Z bjones $

package require Oratcl
#package require Oratcl
package provide random 1.0


#TCL CODE HEADER-------------------------------------------------------------------------

#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)


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

set sysinfo "System: $box\n Location: $env(PWD)\n\n"

#######################################################################################################################


set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set curday [clock format $logdate -format "%d"]
set chkdate [string range $curdate 2 7]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts "                                                            "
puts "----- NEW LOG -------------- $logdate ----------------------"
set pth "/home/rkhan/IPMFILES"
set x ""
set y ""
set xfile ""
set yfile ""
set xfsize ""
set yfsize ""
set zerobyte 0
set flder ""
set bse2 ""

set inst_id [lindex $argv 0]

set err_msg20 "CONTACT ONCALL NOW!!! \n RC 20 UNSUCCESSFUL COMPLETION OF OUTGOING RUN
    Description: The outgoing Edit Package run completed unsuccessfully. The outgoing ITF
    was not created.
    Action: Review the EP.100A and EP.199 reports for error messages that indicate the
    problem. Take the appropriate action according to the description and action associated with
    the message."

set err_msg16 "CONTACT ONCALL NOW!!! \n RC 16 UNSUCCESSFUL COMPLETION OF OUTGOING RUN
    Description: The outgoing Edit Package run completed unsuccessfully. The outgoing ITF
    was not created.
    Action: Review the EP.100A and EP.199 reports for error messages that indicate the
    problem. Take the appropriate action according to the description and action associated with
    the message."

set err_msg4 "CONTACT ONCALL NOW!!! \n RC 04 SUCCESSFUL COMPLETION OF OUTGOING RUN WITH REJECTS
    Description: The outgoing Edit Package run completed with errors; some transactions were
    rejected from the CTF. The outgoing ITF was created.
    Action: Review the EP.100A Report for transaction warning and error messages. Rejected
    transactions must be corrected and submitted in another run of the outgoing Edit Package."

set err_msg8 "CONTACT ONCALL NOW!!! \n RC 08 UNSUCCESSFUL COMPLETION OF OUTGOING RUN
    Description: The outgoing Edit Package run completed unsuccessfully. The outgoing ITF
    was not created.
    Action: Review the EP.100A and EP.199 reports for error messages that indicate the
    problem. Take the appropriate action according to the description and action associated with
    the message."

set err_msg6 "CONTACT ONCALL NOW!!! \n RC 06 UNSUCCESSFUL COMPLETION OF OUTGOING RUN
    Description: The outgoing Edit Package run completed unsuccessfully. The outgoing ITF
    was not created.
    Action: Review the EP.100A and EP.199 reports for error messages that indicate the
    problem. Take the appropriate action according to the description and action associated with
    the message."

set err_msg "CONTACT ONCALL NOW!!! \n COULD NOT DETERMINE THE TRANSFER STATUS
    Description: Could not find status keyword RC. Make sure the file was transmitted
    Action: Review the EP.100A and EP.199 reports for error messages that indicate the
    problem. Take the appropriate action according to the description and action associated with
    the message."



catch {set y [exec find . -name BF$chkdate*.log]} result

if {$y == ""} {
    set mbody "No Visa Log files found in C:/EP40/BatchFacility/OutgoingRunProd/ \n $result\nEmail sent from the code check_log_for_error.tcl"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}

if {[file exist /clearing/filemgr/TC57/$inst_id/STOP/process.skip]} {
    puts "Skip process"
    foreach fyle $y {
        puts "deleting $fyle because skip found for $inst_id"
        file delete $fyle
    }
    exit 0
}

if {[file exist /clearing/filemgr/TC57/$inst_id/STOP/vsprocess.skip]} {
    puts "Skip process"
    foreach fyle $y {
        puts "deleting $fyle because skip found for $inst_id"
        file delete $fyle
    }
    exit 0
}

foreach fyle $y {

    set fyle [string range [lindex $fyle 0] 2 end]
    set rcFlg "0"

    catch {set x [exec grep RC=16 $fyle]} result
    if {$result != "child process exited abnormally"} {
        puts "file transfer/process failed at Visa Edit package\n$result"
        set mbody "file transfer/process failed at Visa Edit package \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg16"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg16" >> /clearing/alerts/$inst_id.alert
        set rcFlg "1"
    } else {
        puts "No RC=16 Found"
    }

    catch {set x [exec grep RC=20 $fyle]} result
    if {$result != "child process exited abnormally"} {
        puts "file transfer/process failed at Visa Edit package\n$result"
        set mbody "file transfer/process failed at Visa Edit package \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg20"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg20" >> /clearing/alerts/$inst_id.alert
        set rcFlg "1"
    } else {
        puts "No RC=20 Found"
    }

    catch {set x [exec grep RC=8 $fyle]} result
    if {$result != "child process exited abnormally"} {
        puts "file transfer/process failed at Visa Edit package\n$result"
        set mbody "file transfer/process failed at Visa Edit package \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg8"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg8" >> /clearing/alerts/$inst_id.alert
        set rcFlg "1"
    } else {
        puts "No RC=8 Found"
    }
    catch {set x [exec grep RC=4 $fyle]} result
    if {$result != "child process exited abnormally"} {
        puts "file transfer/process failed at Visa Edit package\n$result"
        set mbody "file transfer/process failed at Visa Edit package \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg4"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg4" >> /clearing/alerts/$inst_id.alert
        set rcFlg "1"
        if {[string range $inst_id 5 7] == "108"} {
            exec echo "$sysinfo$inst_id\n\n
                $result" | mailx -r $mailfromlist -s "\[~VEP~\] \[WARNING\] File transfer partially completed with RC=4" clearing@jetpay.com Settlement_MIS@integritypaymentsystems.com
        }
    } else {
        puts "No RC=4 Found"
    }

    catch {set x [exec grep RC=6 $fyle]} result
    if {$result != "child process exited abnormally"} {
        puts "file transfer/process failed at Visa Edit package\n$result"
        set mbody "file transfer/process failed at Visa Edit package \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg6"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg6" >> /clearing/alerts/$inst_id.alert
        set rcFlg "1"
        if {[string range $inst_id 5 7] == "108"} {
            exec echo "$sysinfo$inst_id\n\n
                $result" | mailx -r $mailfromlist -s "\[~VEP~\] \[ALERT\] File transfer failed with RC=6" clearing@jetpay.com Settlement_MIS@integritypaymentsystems.com
        }
    } else {
        puts "No RC=6 Found"
    }
        catch {set x [exec grep "errors. RC=0" $fyle]} result
        if {$result != "child process exited abnormally"} {
            puts "Found RC=0"
            set rcFlg "1"
            puts "$inst_id\nFile id:\n[exec grep STOR $fyle]\n$x\n[exec grep RC=0 $fyle]"
            catch {exec /usr/xpg4/bin/grep -e "errors. RC=0" -e RC=2 $fyle} rslt

            if {[string range $inst_id 5 7] == "108"} {
            exec echo "$sysinfo$inst_id\n\nFile id:
                [exec grep STOR $fyle]
                \n$x
                $rslt" | mailx -r $mailfromlist -s "\[~VEP~\] IPS VS File transfer Successfull with RC=0/2" clearing@jetpay.com Settlement_MIS@integritypaymentsystems.com

            } else {
                exec echo "$sysinfo$inst_id\n\nFile id:
                [exec grep STOR $fyle]
                \n$x
                $rslt" 
            }
        }

    if {$rcFlg == 0} {
        puts "Could not find keyword RC in the log file"
        puts "file transfer status Undetermined"
        set mbody "file transfer/process possibly failed at VEP \n\n$result\nFilename: C:/EP40/BatchFacility/OutgoingRunProd/$fyle \n $err_msg"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exec echo "$err_msg" >> /clearing/alerts/$inst_id.alert
    }

    file delete $fyle
}

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts "------END OF IPM REPORT FILES-------$logdate-------------"
puts "                                                          "
