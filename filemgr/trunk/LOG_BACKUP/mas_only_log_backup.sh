#!/usr/bin/ksh

################################################################################
# $Id: $
# $Rev: $
################################################################################
CRON_JOB=1
export CRON_JOB

. /clearing/filemgr/.profile

locpth=$PWD
maspth=$MAS_OLOGDIR

newmasdir="MAS-`date +%Y%m%d%H%M%S`"

log_file=$locpth/LOG/clr_only_log_backup.log
run_date=`date +%Y%m%d`
run_time=`date +%H%M%S`



##########
## MAIN ##
##########
echo "Beginning LOG Backup of IST/MAS for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $log_file

mkdir $currdir/$newmasdir                     2>> $log_file

cp -p $maspth/debug/* $currdir/$newmasdir/.   2>> $log_file
mv $currdir/$newmasdir $currdir/ARCHIVE/      2>> $log_file
gzip $currdir/ARCHIVE/$newmasdir/*            2>> $log_file
rm -f $maspth/debug/*                         2>> $log_file

sleep 2

echo "LOG Backup of IST/MAS complete for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $log_file
