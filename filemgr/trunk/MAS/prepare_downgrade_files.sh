#!/usr/bin/bash

################################################################################
# $Id: prepare_downgrade_files.sh 4098 2017-03-22 20:53:34Z bjones $
# $Rev: 4098 $
################################################################################
#
# File Name:  prepare_downgrade_files.sh
#
# Description:  This script initiates the generation of MAS interchange
#               downgrade by institution.
#
# Shell Arguments:  None.
#
# Script Arguments:
#                i = institution id (Required)(e.g., ALL, 101, 105, 107, 130).
#                d = date in YYYYMMDD format (optional)
#                v = debug level
#    Example - prepare_downgrade_files.sh -i ALL -d 20161026
#
# Output:  MAS interchange downgrade file by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth

usage(){
    print "Usage:prepare_downgrade_files.sh [-i institution_id] [-d date[YYYYMMDD]]"
    print "      Eg: 1) prepare_downgrade_files.sh -i 101"
    print "          2) prepare_downgrade_files.sh -i 101 -d 20160919"
}

flag=0
run_date=`date +%Y%m%d`
while getopts "hi:d:tv" arg
do
    case $arg in
        i)
            institution_id=$OPTARG
            ;;
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

if [[ $institution_id = "ALL" ]]; then
    inst_list="101 105 107 121 129 130 134"
else
    inst_list=$institution_id
fi


######## MAIN ####################################
echo `date +%Y/%m/%d\ %T` command $0 "$@"
for inst_id in $inst_list
    do
    print "Beginning downgrade MAS file for $inst_id for date $run_date" | tee -a $locpth/INST_$inst_id/LOG/MAS.downgrade_file.log
    code_nm="$locpth/vs_mc_mas_dwngrde_file.tcl -i $inst_id -d $run_date $VERBOSE $test"
    if $code_nm; then
        print "Ending downgrade MAS file for $inst_id for date $run_date" | tee -a $locpth/INST_$inst_id/LOG/MAS.downgrade_file.log
    else
        echo "`date +%Y%m%d%H%M%S` $0 $inst_id Evaluated \n$sysinfo\nEngineer, see $locpth/INST_$inst_id/LOG/MAS.downgrade_file.log" | mailx -r $MAIL_FROM -s "No MAS file downgrade for $inst_id on $run_date" $ALERT_NOTIFICATION
        print "`date +%Y%m%d%H%M%S` $0 $inst_id Evaluated \n$sysinfo\nEngineer, see $locpth/INST_$inst_id/LOG/MAS.downgrade_file.log"
    fi
done
