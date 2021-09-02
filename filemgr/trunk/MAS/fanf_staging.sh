#!/usr/bin/env ksh
# ###############################################################################
# $Id: fanf_staging.sh 4822 2019-03-11 16:47:43Z bjones $
# $Rev: 4822 $
# ###############################################################################
#
# File Name:  fanf_staging.sh
#
# Description:  This script determines if the fanf_processing script to be
#               executed or not.
#
# Running options:
#
# Shell Arguments: none
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
    print "Usage:fanf_staging.sh -t -v -d yyyymmdd"
    print "          Eg: fanf_staging.sh"
}

DATEVAR=""

while getopts "d:htv" arg
do
    case $arg in
        d)
            DATEVAR=" -d "$OPTARG
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

code_nm="$locpth/fanf_staging.tcl $DATEVAR $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
   echo `date +%Y/%m/%d\ %T` "Success"
else
   echo `date +%Y/%m/%d\ %T` "Failure.see $locpth/LOG for more details"
   exit 1
fi
