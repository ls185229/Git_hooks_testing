#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

endpoint="EDPT0079893"
ALERT_EMAIL=$MAIL_TO
NOTIFY_EMAIL="clearing-np@jetpay.com"

box=$SYS_BOX
msubj_h="$box :: Priority : High - Clearing and Settlement"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
sysinfo="System: $box\n Location: $env(PWD) \n\n"

# not used
#pth="RETURN_FILES/MASTERCARD/$endpoint"

# moving this to the cron line
#cd /clearing/filemgr/RETURN_FILES/MASTERCARD

print "Beginning T884 file import at `date +%Y%m%d%H%M%S`" | tee -a LOG/CLR.IMPORT.T884.log

# get file from windows box 
if ./recv_file_frm_mfe_t884_incoming.exp >> LOG/CLR.IMPORT.T884.log; then
    # if no files were received, skip to a clean exit
    success=0
    ls TT884T0* || success=1
    if [ $success -eq 0 ]
    then
        # with addition of IPSys, we get "NO ACTIVITY" in nearly every file at the very end.
        # this causes each file to be skipped
        # use a perl script to strip out the NO ACTIVITY line(s)
        # then move directly to archive if the file is less than 333 bytes after stripping the NO ACTIVITY line
        if ./pre-T884.sh >> LOG/CLR.IMPORT.T884.log; then
            #find each T884T0 file, grep for NO ACTIVITY and move it to archive if this line is in the file, rename and cp to clearing's in/ipm
            # then move to ARCHIVE in EDPT0079893.  schedule 256 command to import
            # if there are no T884 files left after stripping out the NO ACTIVITY lines, rename_T884_in.tcl should not run, but the delete script *should* run
            success=0
            ls TT884T0* || success=1
            if [ $success -eq 0 ]
            then
                if ./rename_T884_in.tcl $endpoint >> LOG/CLR.IMPORT.T884.log; then
                    # remove the file from the Windows box
                    if ./delete_files_frm_mfe_incoming_t884.exp >> LOG/CLR.IMPORT.T884.log; then
                        print "All scripts completed successfully" | tee -a LOG/CLR.IMPORT.T884.log
                    else # delete_files_frm_mfe_incoming_t884.exp 
                        print "delete_files_frm_mfe_incoming.exp failed" | tee -a LOG/CLR.IMPORT.T884.log
                        echo "delete_files_frm_mfe_incoming.exp script failed.\n\n ASSIST:\n\n See log file for detail." | mailx -r $NOTIFY_EMAIL -s "$msubj_h Mastercard Reclass issue" $ALERT_EMAIL
                    fi # delete_files_frm_mfe_incoming_t884.exp 
                else # rename_T884_in.tcl
                    print "rename_ipm_import_files_incoming.tcl failed" | tee -a LOG/CLR.IMPORT.T884.log
                    echo "rename_T884_in.tcl script failed.\n\n ASSIST:\n\n See log file for detail." | mailx -r $NOTIFY_EMAIL -s "$msubj_h Mastercard Reclass issue" $ALERT_EMAIL
                fi # rename_T884_in.tcl
            else
                # no files left after removing empty files
                # still need to run the delete from Windows box as long as the files retrieved were determined to be empty of reclass records
                print "T884 files received, but no reclass records were in the files" | tee -a LOG/CLR.IMPORT.T884.log
                echo "T884 files received, but no reclass records were in the files" | mailx -r $NOTIFY_EMAIL -s "No Mastercard Reclasses" $NOTIFY_EMAIL
                if ./delete_files_frm_mfe_incoming_t884.exp >> LOG/CLR.IMPORT.T884.log; then
                    print "All scripts completed successfully" | tee -a LOG/CLR.IMPORT.T884.log
                else # delete_files_frm_mfe_incoming_t884.exp 
                    print "delete_files_frm_mfe_incoming.exp failed" | tee -a LOG/CLR.IMPORT.T884.log
                    echo "delete_files_frm_mfe_incoming.exp script failed.\n\n ASSIST:\n\n See log file for detail." | mailx -r $NOTIFY_EMAIL -s "$msubj_h Mastercard Reclass issue" $ALERT_EMAIL
                fi # delete_files_frm_mfe_incoming_t884.exp 
            fi # end test for T884 files after removing empty files
        else # pre-T884.sh
            print "pre-T884.sh failed" | tee -a LOG/CLR.IMPORT.T884.log
            echo "pre-T884.sh failed script failed.\n\n ASSIST:\n\n See log file for detail." | mailx -r $NOTIFY_EMAIL -s "$msubj_h Mastercard Reclass issue" $ALERT_EMAIL
        fi # pre-T884.sh
    fi # end first check for T884 files 
else # recv_file_frm_mfe_t884_incoming.exp
    print "recv_file_frm_mfe_t884_incoming.exp failed" | tee -a LOG/CLR.IMPORT.T884.log
    echo "recv_file_frm_mfe_t884_incoming.exp script failed.\n\n ASSIST:\n\n See log file for detail." | mailx -r $NOTIFY_EMAIL -s "$msubj_h Mastercard Reclass issue" $ALERT_EMAIL
fi # recv_file_frm_mfe_t884_incoming.exp





print "Ending T884 file import at `date +%Y%m%d%H%M%S`" | tee -a LOG/CLR.IMPORT.T884.log


