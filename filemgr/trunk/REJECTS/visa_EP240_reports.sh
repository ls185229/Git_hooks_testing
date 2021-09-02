#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: visa_EP240_reports.sh 3597 2015-12-01 21:27:00Z bjones $
# $Rev: 3597 $
################################################################################

CRON_JOB=1
export CRON_JOB

locpth=$PWD
cd $locpth

transfer_file_path="EP40/C457003/REPORTS/INCOMING"
transfer_file="EP240N.TXT"

subject="Visa Charges Report"     
err_email="clearing@jetpay.com"
email_list="Reports-clearing@jetpay.com"
logfile="$locpth/LOG/download.log"

print "\n*************************************************************************" >> $logfile
print "Beginning $transfer_file FILE Transfer at `date +%Y/%m/%d-%H:%M:%S`" >> $logfile

if  recv_vs_incomming_file.exp $transfer_file_path $transfer_file >> $logfile; then
    print "ftp file transfer successful." >> $logfile
    cat $transfer_file | mutt -s "$subject `date +%Y/%m/%d`" $email_list
    mv $transfer_file ./ARCHIVE/DN.$transfer_file.`date +%Y%m%d%H%M%S`
else
    print "\nScript $locpth/recv_vs_incomming_file.exp Failed." >> $logfile
    tail -40 $logfile | mutt -s "$transfer_file file transfer failed." $err_email
fi

print "\nEnd of EP240N FILE Transfer at `date +%Y/%m/%d-%H:%M:%S`" >> $logfile
print "\n*************************************************************************" >> $logfile

###############
###############
