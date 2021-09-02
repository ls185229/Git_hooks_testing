#!/usr/bin/bash

##############################################################################
# $Id: lastday.sh 2973 2015-06-22 17:30:15Z bjones $
##############################################################################
#
# File Name:  lastday.sh
#
# Description:  This shell script allows a process to run on the last day of
#               the month.
#
# Running options:
#   1 as main cron job to prevent a process from running
#
# 30 00 * * 1-5 cd $HOME/MAS/; $HOME/lastday.sh run_all_send_mas_files_to_mas_eom.sh >> LOG/send_mas_file.log 2>&1
#
#   2 as cron job conditional process
#
# 30 00 * * 1-5 cd $HOME/MAS/; ($HOME/lastday.sh && run_all_send_mas_files_to_mas_eom.sh) >> LOG/send_mas_file.log 2>&1
#
#   3 within another script as a part of an if clause
#
#             ...  sh, bash, ksh
#             if ~/lastday.sh ; then
#                 # something done only on the last day in the month
#             fi
#
#             ... tcl
#             if { [exec ~/lastday.sh] } {
#                 # something done only on the last day in the month
#             }
#
# Shell Arguments:  The full command to run
#
# Options:  -o offset
#           This is the offset from the end of the month in days (0 - 28),
#           allowing something to be run on the next to the last day (1) or one
#           week before the end of the month (7).
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (this is the last day in the month)
#           1 = Exit (this is not the last day in the month)
#
##############################################################################

CRON_JOB=1
export CRON_JOB
. ~/.profile > /dev/null

echo `date +%Y/%m/%d\ %T` command $0 "$@"

month=`date +%m`
today=`date +%e`
year=`date +%Y`
lastday=`cal $month $year | grep -v "^ *$" | tail -1 | awk '{print $NF}'`
offset=""

usage() {
    echo "Usage: $0 [-o <0 - 28>] [-h] [command to run]"    1>&2
    echo ""                                                 1>&2
    echo "  -o offset (in days)"                            1>&2
    exit 1
}

while getopts "o:h" flag; do
  case $flag in
    o)
      echo "-o used: $OPTARG"
      offset="$OPTARG"
      (($OPTARG >= 0 && $OPTARG <= 28)) || usage;
      ;;
    h)
      usage;
      ;;
    ?)
      echo "Invalid option $1"
      usage;
      ;;
  esac
done

shift $(( OPTIND - 1 ));

if [ "$offset " != " " ]; then
    # uncomment the following for testing
    # echo offset $offset with arguments $@
    # echo day to run `expr $lastday - $offset`
    daytorun=`expr $lastday - $offset`
else
    daytorun=$lastday
fi

#echo today - $today : lastday - $lastday : daytorun - $daytorun

if [ $today == $daytorun ]; then
   echo "Day to run ($today/$month/$year == $lastday/$month/$year w/ offset $offset) (result 0)"
   # exit 0
   "$@"
else
   echo "Not day to run ($today/$month/$year != $lastday/$month/$year w/ offset $offset:)  (result 1)"
   exit 1
fi
