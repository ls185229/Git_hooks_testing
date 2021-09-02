#!/usr/bin/ksh

##############################################################################
# $Id: notlastday.sh 2967 2015-06-19 20:00:15Z bjones $
##############################################################################
#
# File Name:  notlastday.sh
#
# Description:  This shell script allows a process to run on the last day of
#               the month.
#
# Running options:
#   1 as main cron job to prevent a process from running
#
# 20 01 * * * cd $HOME/MAS/; $HOME/notlastday.sh send_mas_files_to_mas.sh 105 >> $HOME/LOG/MAS.MULTI.CRON.log 2>&1
#
#   2 as cron job conditional process
#
# 20 01 * * * cd $HOME/MAS/; ($HOME/notlastday.sh && send_mas_files_to_mas.sh 105) >> $HOME/LOG/MAS.MULTI.CRON.log 2>&1
#
#   3 within another script as a part of an if clause
#
#             ...  sh, bash, ksh
#             if ~/notlastday.sh ; then
#                 # something done any day but the last day in the month
#             fi
#
#             ... tcl
#             if { [exec ~/notlastday.sh] } {
#                 # something done any day but the last day in the month
#             }
#
# Shell Arguments:  The full command to run
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (this is not the last day in the month)
#           1 = Exit (this is the last day in the month)
#
##############################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile > /dev/null

echo `date +%Y/%m/%d\ %T` command $0 "$@"

month=`date +%m`
today=`date +%e`
year=`date +%Y`
lastday=`cal $month $year | grep -v "^$" | tail -1 | awk '{print $NF}'`

if [ $today == $lastday ]; then
   echo "Last day of the month ($today/$month/$year == $lastday/$month/$year) (result 1)"
   exit 1
else
   echo "Not last day of the month ($today/$month/$year != $lastday/$month/$year) (result 0)"
   # exit 0
   "$@"
fi
