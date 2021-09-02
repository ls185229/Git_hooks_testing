#!/usr/bin/bash

# ###############################################################################
#  $Id: ach_auto.sh 4234 2017-07-05 21:13:28Z skumar $
#  $Rev: 4234 $
# ###############################################################################
# 
#  File Name:  ach_auto.sh
# 
#  Description:  This script initiates the upload of ACH files to the appropriate
#                bank.
# 
#  Shell Arguments:  -i = Institution ID.  Required.
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages.(optional)
#                    -v = debug level.(optional)
#                    -t = test run option.(optional)
# 
#  Script Arguments: -i = Institution ID.  Required.
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages.(optional)
#                    -v = debug level.(optional)
#                    -t = test run option.(optional)
# 
#  Output:  Confirmation emails to configured parties.
# 
#  Return:   0 = Success
#           !0 = Exit with errors
# 
# ###############################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD
usage(){
    print "Usage:ach_auto.sh [-i INST] [-d date[YYYYMMDD]] [-e email_address] [-hv]"
    print "  -i  Institution ID(Mandatory arguement)"
    print "  -d  date in YYYYMMDD format"
    print "  -e  a@b.com  email address to send error messages"
    print "  -t  turn on test mode"
    print "  -v  increase verbose level (possibly debug) for output"
    print "  -h or -?    help, this output"
    print "      Eg: 1) ach_auto.sh -i 101" 
    print "          2) ach_auto.sh -i 101 -d 20160919"
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

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
clrdb=$IST_DB
authdb=$ATH_DB
box=$SYS_BOX

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

#####################################################################################################

locpth=$PWD
cd $locpth

######## MAIN ####################################

code_nm="ach_auto.tcl -i $inst_id -d $run_date $test $VERBOSE"
log_file_name="INST_$inst_id/LOG/ach.log"

print "$code_nm BEGIN" >> $locpth/$log_file_name

if $locpth/$code_nm >> $locpth/$log_file_name; then
    print "$locpth/$code_nm upload successful" >> $locpth/$log_file_name
else
    print "$locpth/$code_nm failed" | mutt -s "$SYS_BOX Script $code_nm Failed" -- $MAIL_TO
fi

print "$code_nm END" >> $locpth/$log_file_name