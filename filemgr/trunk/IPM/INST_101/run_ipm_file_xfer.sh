#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth="/clearing/filemgr/IPM/INST_101"

cd $locpth

print "Beginning IPM FILE xfer from MFE at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfermfe.log

recv_file_frm_mfe.exp >> $locpth/LOG/xfermfe.log

print "Ending FILE xfer for MFE at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfermfe.log


