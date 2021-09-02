#!/usr/bin/ksh

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

