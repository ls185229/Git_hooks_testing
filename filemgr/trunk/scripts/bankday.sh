#!/usr/bin/bash

##############################################################################
#
# File Name:  bankday.sh
#
# Description:  This shell script allows a process to run on days that are not
#               bank holidays.  It first checks to see if the day is a weekday
#               then checks to see if it is a bank holiday.
#
# Running options:
#
#   1 as cron job conditional process
#
# 30 13 * * 1-5 cd $HOME/ACH/INST_101/; ($HOME/bankday.sh -i 101 && ach_auto.sh "52") >> LOG/ach.log 2>&1
#
#   2 within another script as a part of an if clause
#
#             ...  sh, bash, ksh
#             if ~/bankday.sh -i 101; then
#                 # something done only on bank work days
#             fi
#
#             ... tcl
#             if { [exec ~/bankday.sh -i 101] } {
#                 # something done only on bank work days
#             }
#   3 Date is optional argument
#
#             ...  sh, bash, ksh
#             if ~/bankday.sh -i 101 -d 20160919; then
#                 # something done only on bank work days
#             fi
#
#             ... tcl
#             if { [exec ~/bankday.sh -i 101 -d 20160919] } {
#                 # something done only on bank work days
#             }
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

usage(){
    print "Usage:bankday.sh [-i institution_id] [-d date[YYYYMMDD format optional argument]]"
    print "      Eg: 1) bankday.sh -i 101"
    print "          2) bankday.sh -i 101 -d 20160919"
}

flag=0
t_date=`date +%Y%m%d`
while getopts "d:hi:" arg
do
    case $arg in
        i)
            inst_id=$OPTARG
            flag=1
            ;;
        d)
            t_date=$OPTARG
            flag=1
            ;;
        h|*)
            usage
            exit 1
            ;;
    esac
done

if ((!flag)); then
    echo "Invalid option $0"
    usage
    exit 1
fi

code_nm="ach_day.tcl -i $inst_id -d $t_date"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if ~/$code_nm; then
   echo `date +%Y/%m/%d\ %T` "This is not a weekend or bank holiday (result 0)"
#   exit 0
#   "$@"
else
   echo `date +%Y/%m/%d\ %T` "This is a weekend or bank holiday (result 1)"
   exit 1
fi
