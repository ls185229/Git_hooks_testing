#!/usr/bin/env ksh
# ###############################################################################
# $Id: gen_on_call_summary.sh 4771 2018-11-16 15:37:46Z skumar $
# $Rev: 4771 $
# ###############################################################################
#
# File Name:  gen_on_call_summary.sh
#
# Description:  This script creates the summary of rejects and suspends
#               occurred in the CLEARING and MAS system and emails the same.
#
# Running options:
#
# Shell Arguments:
#                    -d = date in YYYYMMDD format (optional)
#                    -t = TEST MODE (Optional)
#                    -v = verbose level
#
# Output:       on_call_summary report for the date.
#
# Return:   0 = Success 
#           !0 = Exit with errors
# #############################################################################
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth

usage(){
    print "Usage:gen_on_call_summary.sh -t -v"
    print "          Eg: gen_on_call_summary.sh"
}

while getopts "h:d:tv" arg
do
    case $arg in
        d)
            date="-d "$OPTARG
            ;;
        v)
            VERBOSE=$VERBOSE" -v"
            echo "Verbose level $VERBOSE " >&2
            ;;
        t)
            test="-t"
            ;;
        h|*)
            usage
            exit 1
            ;;
    esac
done

code_nm="$locpth/gen_on_call_summary.tcl $date $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
   echo `date +%Y/%m/%d\ %T` "Success"
else
   echo `date +%Y/%m/%d\ %T` "Failure.see $locpth/LOG for more details"
   exit 1
fi
