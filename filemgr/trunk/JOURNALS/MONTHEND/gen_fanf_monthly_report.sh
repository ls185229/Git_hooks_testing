#!/usr/bin/env ksh
# ###############################################################################
# $Id: gen_fanf_monthly_report.sh 3974 2016-11-29 21:55:50Z bjones $
# $Rev: 3974 $
# ###############################################################################
#
# File Name:  gen_fanf_monthly_report.sh
#
# Description:  This script determines if the MAS files are
#               processed or not.
#
# Running options:
#
# Shell Arguments:
#                    -c = Counting type (Optional)
#                    -t = TEST MODE (Optional)
#                    -v = verbose level
#
# Output:       The return code determines the next step.
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
    print "Usage:gen_fanf_monthly_report.sh -t -v"
    print "          Eg: gen_fanf_monthly_report.sh"
}

while getopts "hm:y:tv" arg
do
    case $arg in
        m)
            mnth="-m "$OPTARG
            ;;
        y)
            year="-y "$OPTARG
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

code_nm="$locpth/gen_fanf_monthly_report.tcl $mnth $year $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
   echo `date +%Y/%m/%d\ %T` "Success"
else
   echo `date +%Y/%m/%d\ %T` "Failure.see $locpth/LOG for more details"
   exit 1
fi
