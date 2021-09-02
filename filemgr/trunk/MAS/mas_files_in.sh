#!/usr/bin/env ksh
# ###############################################################################
# $Id: mas_files_in.sh 4341 2017-09-13 18:19:01Z lmendis $
# $Rev: 4341 $
# ###############################################################################
#
# File Name:  mas_files_in.sh
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
# Return:   0 = Success (All the Clearing MAS files are processed)
#           !0 = Exit with errors during the following conditions
#               1) Clearing file count doesnt match
#               2) Database error
#               3) Clearing file is still under process
# #############################################################################
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth

usage(){
    print "Usage:mas_files_in.sh -c cnt_type -i inst_id -t -v"
    print "      where -c is a count type (Eg: FANF, OKDMV)" 
	print "      where -i is an institution ID (Eg: 107)"
    print "          Eg: mas_files_in.sh -c FANF -i 107"
	print "          Eg: mas_files_in.sh -i 107 -c OKDMV"
}

while getopts "hc:i:tv" arg
do
    case $arg in
        c)
            cnt_type="-c "$OPTARG
            ;;
        i)
            inst_id="-i "$OPTARG
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

code_nm="$locpth/mas_files_in.tcl $inst_id $cnt_type "

code_nm="$code_nm $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
   echo `date +%Y/%m/%d\ %T` "Success"
else
   echo `date +%Y/%m/%d\ %T` "Failure.see $locpth/LOG for more details"
   exit 1
fi
