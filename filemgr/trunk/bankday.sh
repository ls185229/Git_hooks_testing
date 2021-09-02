#!/usr/bin/bash

##############################################################################
# $Id: bankday.sh 2973 2015-06-22 17:30:15Z bjones $
##############################################################################
#
# File Name:  bankday.sh
#
# Description:  This shell script allows a process to run on days that are not
#               bank holidays.  It first checks to see if the day is a weekday
#               then checks to see if it is a bank holiday.
#
# Running options:
#   1 as main cron job to prevent a process from running
#
# 30 13 * * 1-5 cd $HOME/ACH/INST_101/; $HOME/bankday.sh ach_auto.sh "52" >> LOG/ach.log 2>&1
#
#   2 as cron job conditional process
#
# 30 13 * * 1-5 cd $HOME/ACH/INST_101/; ($HOME/bankday.sh && ach_auto.sh "52") >> LOG/ach.log 2>&1
#
#   3 within another script as a part of an if clause
#
#             ...  sh, bash, ksh
#             if ~/bankday.sh ; then
#                 # something done only on bank work days
#             fi
#
#             ... tcl
#             if { [exec ~/bankday.sh] } {
#                 # something done only on bank work days
#             }
#
# Shell Arguments:  The full command to run
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (this is a weekday and not a holiday)
#           1 = Exit with errors (this is either a weekend or a holiday)
#
##############################################################################

CRON_JOB=1
export CRON_JOB
. ~/.profile > /dev/null

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if ~/ach_day.tcl ; then
   echo `date +%Y/%m/%d\ %T` "This is not a weekend or bank holiday (result 0)"
   # exit 0
   "$@"
else
   echo `date +%Y/%m/%d\ %T` "This is a weekend or bank holiday (result 1)"
   exit 1
fi
