#!/usr/bin/bash

# $Id: incoming_transaction_fixes.sh 2568 2014-03-05 19:53:49Z msanders $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/RETURN_FILES

cd $locpth

echo "Beginning return transaction fix at `date +%Y%m%d-%H:%M:%S`"

script_output=`incoming_transaction_inst_fix.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "incoming_transaction_inst_fix.tcl successful" | tee -a $locpth/LOG/incoming_transaction_inst_fix.log
else
   echo $script_output | tee -a $locpth/LOG/incoming_transaction_inst_fix.log
   mutt -s "Priority : High - Clearing and Settlement - $SYS_BOX Script incoming_transaction_inst_fix.tcl Failed" clearing@jetpay.com < echo "incoming_transaction_inst_fix.tcl failed contact oncall engineer"
   echo "incoming_transaction_inst_fix.tcl failed " | tee -a $locpth/LOG/incoming_transaction_inst_fix.log
fi

script_output=`reclass_mascode_fix.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "reclass_mascode_fix.tcl successful" | tee -a $locpth/LOG/reclass_mascode_fix.log
else
   echo $script_output | tee -a $locpth/LOG/reclass_mascode_fix.log
   mutt -s "Priority : High - Clearing and Settlement - $SYS_BOX Script reclass_mascode_fix.tcl Failed" clearing@jetpay.com < echo "reclass_mascode_fix.tcl failed contact oncall engineer"
   echo "reclass_mascode_fix.tcl failed " | tee -a $locpth/LOG/reclass_mascode_fix.log
fi

script_output=`pre_abr_fix.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "reclass_mascode_fix.tcl successful" | tee -a $locpth/LOG/reclass_mascode_fix.log
else
   echo $script_output | tee -a $locpth/LOG/reclass_mascode_fix.log
   mutt -s "Priority : High - Clearing and Settlement - $SYS_BOX Script reclass_mascode_fix.tcl Failed" clearing@jetpay.com < echo "
reclass_mascode_fix.tcl failed contact oncall engineer"
   echo "reclass_mascode_fix.tcl failed " | tee -a $locpth/LOG/reclass_mascode_fix.log
fi

