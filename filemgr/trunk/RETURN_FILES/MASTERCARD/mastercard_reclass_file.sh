#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: mastercard_reclass_file.sh 2410 2013-08-28 18:07:47Z devans $
# $Rev: 2410 $
################################################################################
#

##################################################################################
#
# mastercard_reclass_file.sh 
#    This shell script initiates Mastercard reclass activity analysis.
#
##################################################################################
CRON_JOB=1
export CRON_JOB

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#Directory locations
locpth=/clearing/filemgr/RETURN_FILES/MASTERCARD
srcpth=/clearing/filemgr/RETURN_FILES/MASTERCARD/EDPT0079893/ARCHIVE

#Email recipients
PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="clearing@jetpay.com"
msubj_c="$SYS_BOX :: Priority : Critical - Clearing and Settlement"
msubj_u="$SYS_BOX :: Priority : Urgent - Clearing and Settlement"
msubj_h="$SYS_BOX :: Priority : High - Clearing and Settlement"
msubj_m="$SYS_BOX :: Priority : Medium - Clearing and Settlement"
msubj_l="$SYS_BOX :: Priority : Low - Clearing and Settlement"

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#File variables
file_date=`date +%Y%m%d`
file_time=`date +%H%M%S`
log_file=$locpth/LOG/mastercard_reclass_file.log
cfg_file=$locpth/mastercard_reclass_file.cfg

#Script arguments
script_name=$0
run_mode=$1
run_date=$2
num_args=$#
max_num_args=2

##################################################
# Calculate the Julian date 
##################################################
calcod()               # function to calculate ordinal date
{
oIFS="$IFS"            # save Internal field separators
IFS='-'                # set Internal field separator to -
set -- $1              # split date into args
y=$1 m=$2 d=$3
IFS="$oIFS"            # restore Internal field separators
set -A odm 0 0 31 59 90 120 151 181 212 243 273 304 334
printf "%02d%03d\n" ${y#??} $(( (m+9)/12*(y/4*4/y-y/100*100/y+y/400*400/y)+odm[m]+d)) # 2 digit year
}


##################################################
# Send an alert message
##################################################
alert_someone()
{
   exec echo $1 | mutt -s "$msubj_h" -- "$PRIORITY_EMAIL_LIST"
   print $1 | tee -a $log_file
}


##################################################
# Send a notification of processing status
##################################################
notify_someone()
{
   exec echo $1 | mutt -s "$msubj_l" -- "$NON_PRIORITY_EMAIL_LIST"
   print $1 | tee -a $log_file
}


##################################################
# Send transaction information
##################################################
mail_someone()
{
   exec echo $1 | mutt -s "$msubj_l - Mastercard Reclass Activity Analyzed for $run_file_date" -- "$NON_PRIORITY_EMAIL_LIST" < $mail_file
   print $1 | tee -a $log_file
}


##################################################
# Print run command help message
##################################################
print_help()
{
    print "Arg1 = run mode is required (T = test mode, P = production mode)"
    print "Arg2 = date (YYYYMMDD) is optional"
    exit 1 
}


##################################################
# Inspect the provided run command arguments
##################################################
if [ $num_args -le $max_num_args ]
then
    if [ "$run_mode" ]
    then
        if [ "$run_date" ] 
        then
            run_file_date=$run_date
            long_date=`echo $run_date | awk '{ print substr($0,1,4)"-"substr($0,5,2)"-"substr($0,7,2) }'`  #date as ccyy-mm-dd
            #~ runj_date=$(calcod $long_date)  # calc julian date
            runj_date=`gdate +%y%j -d $long_date`
            runj_date=`echo $runj_date | cut -c 2-5`  #just keep last digit of year
            input_acquirer_file=$srcpth/MCRC.TT884T0.$runj_date*
            mail_file=$srcpth/mastercard_reclass_listing_$run_date
        else 
            run_file_date=$file_date
            long_date=`echo $file_date | awk '{ print substr($0,1,4)"-"substr($0,5,2)"-"substr($0,7,2) }'`  #date as ccyy-mm-dd
            #~ runj_date=$(calcod $long_date)  # calc julian date
            runj_date=`gdate +%y%j -d $long_date`
            runj_date=`echo $runj_date | cut -c 2-5`  #just keep last digit of year
            input_acquirer_file=$srcpth/MCRC.TT884T0.$runj_date* #MCRC.TT884T0.9006*.201
            mail_file=$srcpth/mastercard_reclass_listing_$file_date
        fi
    else
        print "Provide missing argument(s) for mastercard_reclass_file.sh"
        print_help
    fi
else
    print "Too many arguments provided for mastercard_reclass_file.sh"
    print_help
fi


##################################################
# Check for the presence of a file for this 
# processing day; if present, proceed with
# Mastercard reclass activity analysis.
##################################################
cd $locpth

print "Processing Day:  `date +%m/%d/%Y`" | tee -a $log_file
print "Beginning Mastercard reclass activity analysis `date +%H:%M:%S`" | tee -a $log_file

print "run_file_date: $run_file_date"
print "long_date: $long_date"
print "runj_date: $runj_date"
print "input_acquirer_file: $input_acquirer_file"

if [ -e $mail_file ]
then
    rm $mail_file
fi

if [ -e $input_acquirer_file ]
then
    input_acquirer_filename=`ls $input_acquirer_file`
    if $locpth/mastercard_reclass_file.tcl $log_file $input_acquirer_filename $mail_file $cfg_file $run_file_date $run_mode >> $log_file 
    then
        mail_someone "Mastercard reclass activity for today"
        gpg --yes --output $input_acquirer_filename.gpg --encrypt --recipient clearing@jetpay.com $input_acquirer_filename && rm -f $input_acquirer_filename
        mv $input_acquirer_filename.gpg $locpth/ARCHIVE
        mv $mail_file $locpth/ARCHIVE
    else
        alert_someone "Mastercard reclass activity $0 analysis failed."
    fi
else
    notify_someone "No Mastercard activity file was received today for reclass analysis."
fi

print "Ending Mastercard reclass activity analysis `date +%H:%M:%S`" | tee -a $log_file
print "___________________________________________________________________________\n" | tee -a $log_file
