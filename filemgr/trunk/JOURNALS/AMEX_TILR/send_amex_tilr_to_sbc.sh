#!/usr/bin/ksh
# $Id: send_amex_tilr_to_sbc.sh 3284 2015-08-26 19:47:50Z fcaron $

. /clearing/filemgr/.profile

echo "`date +%F` `date +%T` Beginning American Express send TILR Files to SBC RUN" | tee -a $locpth/LOG/reports.log
locpth=/clearing/filemgr/JOURNALS/AMEX_TILR
cd $locpth
#email_to="reports-clearing@jetpay.com"
email_to="fcaron@jetpay.com"

today=`date +%Y%m%d`

out_file="`ls $locpth/ARCHIVE/105.AMEX.TILR.REPORT.$today.csv`"
if [[ -n "$out_file" ]]
then
     echo " Found $out_file American Express send TILR Files to SBC."

    # upload the TILR file to SBC
    if $locpth/put_tilr.sh sftp.jetpay.com filemgr /secure/sbancard/tilr $out_file
    then
        echo " Uploaded $out_file successfully"
        echo "$out_file send to SBC was successful" | mutt -s "$out_file send to SBC was successful " -- $email_to
    else
        echo " Failed to upload $out_file"
        echo "$out_file send to SBC Failed" | mutt -s "$out_file send to SBC Failed " -- $email_to 
     fi
fi     

out_file="`ls $locpth/ARCHIVE/117.AMEX.TILR.REPORT.$today.csv`"
if [[ -n "$out_file" ]]
then
    echo " Found $out_file American Express send TILR Files to SBC."

    # upload the TILR file to SBC
    if $locpth/put_tilr.sh sftp.jetpay.com filemgr /secure/sbancard/tilr $out_file
    then
        echo " Uploaded $out_file successfully"
        echo "$out_file send to SBC was successful" | mutt -s "$out_file send to SBC was successful " -- $email_to 
    else
        echo " Failed to upload $out_file"
        echo "$out_file send to SBC Failed" | mutt -s "$out_file send to SBC Failed " -- $email_to 
     fi
fi     

echo "`date +%F` `date +%T` Ending American Express send TILR Files to SBC RUN" | tee -a $locpth/LOG/reports.log
