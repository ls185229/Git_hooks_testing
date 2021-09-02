#!/usr/bin/ksh

################################################################################
# $Id: lastday.sh 4569 2018-05-17 15:28:32Z bjones $
# $Rev: 4569 $
################################################################################
#
# File Name:  lastday.sh
#
# Description:  This script determines whether or not an ACH should be
#               automatically generated for the day.  ACH files are manually
#               generated for month-end processing.
#              
# Shell Arguments:  None.
#
# Script Arguments:  None.
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

# while this is no longer providing a useful function, some scripts still invoke it and can't run if this is removed.
exit 0
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

month=`date +%m`
today=`date +%e`
year=`date +%Y`
lastday=`cal $month $year | grep -v "^$" | tail -1 | awk '{print $NF}'`
if [ $today == $lastday ]; then
   print "Last day of the month check result 0"
   exit 0
else
   print "Last day of the month check result 1"
   exit 0
fi

