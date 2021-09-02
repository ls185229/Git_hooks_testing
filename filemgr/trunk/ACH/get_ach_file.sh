#!/usr/bin/ksh

################################################################################
# $Id: get_ach_file.sh 4234 2017-07-05 21:13:28Z skumar $
# $Rev: 4234 $
################################################################################
#
# File Name:  get_ach_file.sh
#
# Description:  This script initiates movement of the ACH file from the MAS
#               system to the ACH upload folder.
#
# Shell Arguments:  -i = Institution ID.  Required.
#                   -d = date in YYYYMMDD format (optional)
#                   -e = Email address to send error messages.(optional)
#                   -v = debug level(optional)
#                   -t = test run option.(optional)
#
# Script Arguments:  -i = Institution ID.  Required.
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages.(optional)
#                    -v = debug level.(optional)
#                    -t = test run option.(optional)
#
# Output:  1) EFT Files 
#          2) Confirmation emails to configured parties.
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

 cd $PWD

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

##################################################################################

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
clrdb=$IST_DB
authdb=$ATH_DB
box=$SYS_BOX

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

##################################################################################


locpth=$PWD
cd $locpth

######## MAIN ####################################

code_nm="get_ach_file.tcl -i $inst_id -d $run_date $test $VERBOSE"
log_file_name="INST_$inst_id/LOG/ach.log"

print "$code_nm is going to be invoked" >> $locpth/$log_file_name
print "log_file_name: $log_file_name" >> $locpth/$log_file_name

print "ACH BEGIN `date +%Y%m%d%H%M%S`" >> $locpth/$log_file_name

if $locpth/$code_nm >> $locpth/$log_file_name; then
    print "$locpth/$code_nm successful" >> $locpth/$log_file_name

else
    echo "$locpth/$code_nm failed" | mailx -r $MAIL_FROM -s "$SYS_BOX Script $code_nm Failed" $MAIL_TO
fi

print "ACH END `date +%Y%m%d%H%M%S`"  >> $locpth/$log_file_name