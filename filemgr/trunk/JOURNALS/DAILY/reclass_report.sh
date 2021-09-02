#!/usr/bin/bash
##############################################################################
# $Id: reclass_report.sh 4897 2019-09-24 21:01:06Z skumar $
##############################################################################
#
# File Name  :  reclass_report.sh
#
# Description:  This script will generates the reclass report for Visa and MC.
# Arguments  :   -d - Date in YYYYMMDD format(Optional)
#                -v - Verbosity level
#                -v    = logging.WARNING
#                -vv   = logging.INFO
#                -vvv  = logging.DEBUG                
#                -t -    Test option
#                        mail configuration is read from the test email
#                        file is read from /clearing/filemgr/MASCLRLIB
# Output     :  reclass report
#
# Return     :  0 = Success
#               !0 = Exit with errors
#
##############################################################################
#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth

source  /clearing/filemgr/.profile
source /clearing/filemgr/.local/lib/python3.7/bin/activate

export IST_HOST='clear2.jetpay.com'
export IST_SERVERNAME='clear2.jetpay.com'

usage(){
    print "Usage:reclass_report.sh [-d date in YYYYMMDD format] [-v] [-t test configuration mail ]"
    print "      Eg: 1) reclass_report.sh -d 20190828 -v -v -v "
    print "          2) reclass_report.sh -d 20190828 -v -v -v -t reclass_email.cfg"
    print "          2) reclass_report.sh"
}

flag=0
run_date=`date +%Y%m%d`
while getopts "hd:t:v" arg
do
    case $arg in
        d)
            run_date=$OPTARG
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

######## MAIN ####################################
print "Beginning reclass_report for date $run_date" >> $locpth/LOG/reclass_report.log

code_nm="$locpth/reclass_report.py -d $run_date $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
    print "Ending reclass_report for date $run_date" >> $locpth/LOG/reclass_report.log
else
    echo "`date +%Y%m%d%H%M%S` $0 Evaluated \n$sysinfo\nEngineer, see $locpth/LOG/reclass_report.log" | \
        mailx -r $MAIL_FROM -s "Not able to make reclass report on $run_date" $ALERT_NOTIFICATION
    print "`date +%Y%m%d%H%M%S` $0 Evaluated \n$sysinfo\nEngineer, see $locpth/LOG/reclass_report.log"
fi