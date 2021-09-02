#!/usr/bin/env ksh

################################################################################
# $Id: get_ach_file.sh 4677 2018-08-31 20:09:03Z skumar $
# $Rev: 4677 $
################################################################################
#
# File Name:  get_ach_file.sh
#
# Description:  This script initiates movement of the ACH file from the MAS
#               system to the ACH upload folder.
#
# Shell Arguments:  None.
#
# Script Arguments:  inst_id = Institution ID.  Required.
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB
echo ORACLE_HOME = $ORACLE_HOME
echo IST_DB = $TWO_TASK

cd $PWD

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
clrdb=$IST_DB
authdb=$ATH_DB
box=$SYS_BOX
today=`date +%Y%m%d`

#Email Subjects variables Priority wise

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

#Email Subjects variables Priority wise

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

##################################################################################

locpth=$PWD
cd $locpth

######## MAIN ####################################
usage(){
    print "Usage:get_ach_file.sh [-i INST] [-d date[YYYYMMDD]] [-e email_address] [-hv]"
    print "  -i  Institution ID(Mandatory arguement)"
    print "  -d  date in YYYYMMDD format"
    print "  -e  a@b.com  email address to send error messages"
    print "  -t  turn on test mode"
    print "  -v  increase verbose level (possibly debug) for output"
    print "  -h or -?    help, this output"
    print "      Eg: 1) get_ach_file.sh -i 101" 
    print "          2) get_ach_file.sh -i 101 -d 20160919"
    print "          3) get_ach_file.sh -i 101 -d 20160919 -e a@b.com -t -v -v"
}

flag=0
run_date=`date +%Y%m%d`
while getopts "hi:d:e:tv" arg
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
        e)
            mailtolist=$OPTARG
            export MAIL_TO=$OPTARG
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

if [[ $test = "P" ]] ; then
    sht_name=$prdsn
    print "Production run for $sht_name"
else
    sht_name=$tstsn
    print "TEST run for $sht_name"
fi

code_nm="get_ach_file.tcl -i $inst_id -d $run_date $test $VERBOSE"
bank="BMOHARRIS"
print code to run: $code_nm

print "ACH BEGIN `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/ach.log

if $locpth/$code_nm | tee -a $locpth/LOG/ach.log; then
    print "$locpth/$code_nm successful" | tee -a $locpth/LOG/ach.log
    fname="$inst_id*ACH*$bank*52*$today*.ach"
else
    echo "$locpth/$code_nm failed" | mailx -r $MAIL_FROM -s "$SYS_BOX Script $code_nm Failed" $MAIL_TO
fi

print "<> END <> `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/ach.log
