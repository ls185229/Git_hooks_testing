#!/usr/bin/ksh
# $Id: 
. /clearing/filemgr/.profile
export ALERT_EMAIL="clearing@jetpay.com, assist@jetpay.com"
export MAIL_TO=reports-clearing@jetpay.com
export PROD_CLR_DB=trnclr4
export alert_msg="The Merrick merhant list upload process failed. Check the latest log file located in /clearing/filemgr/JOURNALS/Merrick_daily_merchant_list/LOG"
if [[ $# > 0 ]]; then
  ./merrick_daily_merchant_list.tcl -c merrick_daily_merchant_list.cfg -d $1
else
  ./merrick_daily_merchant_list.tcl -c merrick_daily_merchant_list.cfg 
fi
if [[ $? == 0 ]]; then
  export file="merrick_daily_merchant_list_*.csv"
else
  mutt -s "Merrick daily merhcant list upload TCL failure" -- $ALERT_EMAIL < $alert_msg
  exit
fi
./encrypt_merrick_files.sh $file
./merrick_daily_merchant_list_upload.exp $file.gpg
if [[ $? == 0 ]]; then
	gzip $file
	mv $file.gz ARCHIVE/.
	rm $file.gpg
else
    mutt -s "Merrick daily merhcant list upload failed" -- $ALERT_EMAIL < alert_msg
fi