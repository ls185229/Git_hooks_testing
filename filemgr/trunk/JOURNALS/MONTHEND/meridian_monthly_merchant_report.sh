#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: 

export MAIL_TO=clearing@jetpay.com
export PROD_CLR_DB=trnclr4

if [[ $# > 0 ]]; then
  export script_to_execute=meridian_monthly_merchant_list.tcl -d $1
else
  export script_to_execute=meridian_monthly_merchant_list.tcl
fi

if $script_to_execute; then
  mutt -s "Meridian monthly merchant report Completed Successfully" -- $MAIL_TO < /dev/null
  export file=`ls meridian_merchant_list_*.csv | grep -v gz`
else
  mutt -s "Meridian monthly merchant report failure" -- $MAIL_TO < "The Meridian monthly merchant process failed. Check the latest log file located at $pwd/LOG"
fi
