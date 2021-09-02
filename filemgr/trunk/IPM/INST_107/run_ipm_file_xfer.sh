#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth="/clearing/filemgr/IPM/INST_107"

cd $locpth

print "Beginning IPM FILE xfer from MFE at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfermfe.log



if recv_file_frm_mfe.exp >> $locpth/LOG/xfermfe.log; then
    if parse_mc_report.tcl >> $locpth/LOG/xfermfe.log; then
	if rename_ipm_import_files.tcl >> $locpth/LOG/xfermfe.log; then
		print "Done"
		mv DT* ./ARCHIVE/
	else 
		print "rename_ipm_import_files.tcl failed" | tee -a $locpth/LOG/xfermfe.log
		echo "rename_ipm_import_files.tcl failed.\n\n ASSIST:\n\n 1) Contact clearing group.\n Mastercard Reports are not sent. If there is any additional email recieved reguarding mastercard files please forward them to clearing@jetpay.com/oncall engr. immidiately.\n\n CLEARING/ONCALL:\n\n 2) Before you procced, Please, look in the log file at $locpth/LOG/xfermfe.log and the emails recieved from Assist to determine the issue and correct them.\n If there is an email stating file count is not 6. Check that mail to see how many files we have. If we have less than 6 means we did not receive all the files from Mastercard. (Look in box dfw-prd-set-03 path: production/MASTERCARDARCHIVE/incomming/T140). If file count is more means file delete did not completed yesterday.(EXCEPTION: SUNDAY there will be no files in folder production/MASTERCARDARCHIVE/incomming/T140). \n\n Now, If it is LESS FILES THAN 6, Wait till we recieve all the files. You might have to do manual download from mastercard. Once you have all the files e.g. TT140T.001, TT140T.002, TT140T.003.... TT140T.006 and TT461T.001. Then run the following commands below \n\n recv_file_frm_mfe.exp >> $locpth/LOG/xfermfe.log then \n" | mailx -r clearing@jetpay.com -s "Mastercard Reports issue" clearing@jetpay.com assist@jetpay.com
	fi
   else
        print "parse_mc_report.tcl failed" | tee -a $locpth/LOG/xfermfe.log
	echo "parse_mc_report.tcl failed" | mailx -r clearing@jetpay.com -s "Mastercard Reports issue" clearing@jetpay.com assist@jetpay.com
   fi
else
	print "recv_file_frm_mfe.exp failed" | tee -a $locpth/LOG/xfermfe.log
	echo "Prod: recv_file_frm_mfe.exp failed.\n\n ASSIST:\n\n Mastercard Reports are not sent. If there is any additional email recieved reguarding mastercard files please forward them to clearing@jetpay.com/oncall engr. immidiately.\n\n CLEARING/ONCALL:\n\n 2) Before you procced, Please look in the log file at EXP.log and the emails emails recieved from Assist to determine the issue and correct them.\n. In this case please copy the command from crontab and run again that should take care of the issue. verify the reports are sent in the email attachment." | mailx -r clearing@jetpay.com -s "Mastercard Reports issue" clearing@jetpay.com assist@jetpay.com
fi 

print "Ending FILE xfer for MFE at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfermfe.log


