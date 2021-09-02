#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: merrick_daily_upload.sh 2304 2013-05-16 19:06:44Z mitra $

export ALERT_EMAIL="clearing@jetpay.com, assist@jetpay.com"
export MAIL_TO=Reports-clearing@jetpay.com
export PROD_CLR_DB=trnclr4

if [[ $# > 0 ]]; then
  merrick_daily_trans_upload.tcl -c merrick_daily_trans_upload.cfg -d $1
else
  merrick_daily_trans_upload.tcl -c merrick_daily_trans_upload.cfg 
fi

if [[ $? == 0 ]]; then
  export file="merrick_daily_trans_upload_*.csv"
else
  mutt -s "Merrick daily trans upload TCL failure" -- $ALERT_EMAIL < upload_error.txt
  exit
fi

encrypt_merrick_files.sh $file

daily_trans_upload.exp $file.gpg

if [[ $? == 0 ]]; then
    mutt -s "Merrick daily trans upload Completed Successfully" -- $MAIL_TO < /dev/null
	gzip $file.gpg
	mv $file.gpg.gz ARCHIVE/.
	rm $file
else
    mutt -s "Merrick daily trans upload failure - file transfer" -- $ALERT_EMAIL < upload_error.txt
fi
