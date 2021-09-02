#!/usr/bin/ksh
. /clearing/filemgr/.profile
 
################################################################################
# $Id: woot_chargeback_report.sh 2612 2014-05-12 21:24:35Z mitra $
# $Rev: 2612 $
################################################################################
#
#    File Name   - woot_chargeback_report.sh
#
#    Description - This s a custom report for woot to help them match
#                  chargebacks to their transactions.
#
#    Arguments   - $1 Date to run the report.  If no argument, then defaults to
#                  today's date.  EX. 20140204
#
################################################################################

mailto_err="assist@jetpay.com clearing@jetpay.com"

locpth=$PWD

cd $locpth

logfile="$locpth/LOG/woot_chargeback_report.log"   

############################## MAIN #################################

print "\nBeginning WOOT Report at `date +%Y%m%d-%H:%M:%S`" >> $logfile


if [ $# == 0 ]
then
      woot_chargeback_report.tcl 
else
      woot_chargeback_report.tcl -d $1 
fi


if [ $? ]; then

    print "Script woot_chargeback_report.tcl completed successfully" | tee -a $logfile

        # upload the encypted chargeback file to WOOT

    if $locpth/put_response.sh sftp.jetpay.com filemgr /secure/woot/reports/ Woot-Chargeback-*.xls
    then
       echo "  Uploaded $out_file successfully"
       mv Woot-Chargeback-*.xls $locpth/ARCHIVE
    else
       print "  Failed to upload $out_file to WOOT"
       echo "woot_chargeback_report.tcl failed" | mutt -s "WOOT Report upload to WOOT Failed" $mailto_err
    fi

else

    print "Script woot_chargeback_report.tcl failed" | mutt -s "Script woot_chargeback_report.tcl Failed" $mailto_err
    print "woot_chargeback_report.tcl failed " | tee -a $logfile

fi


print "Ending WOOT Report at `date +%Y%m%d-%H:%M:%S`" >> $logfile

exit 0

