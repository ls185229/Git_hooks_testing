#!/usr/bin/env ksh
##############################################################################
# $Id: mas_chgbck_file.sh 4748 2018-10-15 16:38:52Z bjones $
##############################################################################
#
# File Name:  mas_chgbck_file.sh
#
# Description:  This script creates the chargeback file
#
# Running options:
#
# Shell Arguments:  The full command to run
#                i = institution id (Required)
#                d = date in YYYYMMDD format (optional)
#                f = Missed trans_seq_nbr list file name (optional)
#                v = debug level
#
# Output:       Creates a chargeback file.
#
# Return:   0 = Success
#           1 = Exit with errors
#
##############################################################################
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth

usage(){
    print "Usage:mas_chgbck_file.sh [-i institution_id] [-d date[YYYYMMDD]]"
    print "      Eg: 1) mas_chgbck_file.sh -i 101"
    print "          2) mas_chgbck_file.sh -i 101 -d 20160919"
}

flag=0
run_date=`date +%Y%m%d`
while getopts "hi:d:f:tv" arg
do
    case $arg in
        i)
            inst_id=$OPTARG
            flag=1
            ;;
        d)
            run_date=$OPTARG
            flag=1
            ;;
        f)
            file_name=" -f "$OPTARG
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

if ((!flag)); then
    echo "Invalid option $0"
    usage
    exit 1
fi

######## MAIN ####################################
print "Beginning Chargeback MAS file for $inst_id for date $run_date" >> $locpth/INST_$inst_id/LOG/MAS.chgbck_file.log

code_nm="$locpth/mas_chgbck_file.tcl -i $inst_id -d $run_date $file_name $VERBOSE $test"

echo `date +%Y/%m/%d\ %T` command $0 "$@"

if $code_nm; then
    print "Ending Chargeback MAS file for $inst_id for date $run_date" >> $locpth/INST_$inst_id/LOG/MAS.chgbck_file.log
else
    echo "`date +%Y%m%d%H%M%S` $0 $inst_id Evaluated \n$sysinfo\nEngineer, see $locpth/INST_$inst_id/LOG/MAS.chgbck_file.log" | \
        mailx -r $MAIL_FROM -s "Not able to make MAS file chargebacks for $inst_id on $run_date" $ALERT_NOTIFICATION
    print "`date +%Y%m%d%H%M%S` $0 $inst_id Evaluated \n$sysinfo\nEngineer, see $locpth/INST_$inst_id/LOG/MAS.chgbck_file.log"
fi
