#!/usr/bin/env bash

################################################################################
# $Id: extra_processing_fees.sh 4383 2017-10-06 20:22:04Z skumar $
# $Rev: 4383 $
################################################################################
#
# File Name:  extra_processing_fees.sh
#
# Description:  This script initiates the generation of MAS extra processing
#               fee files by institution.
#
# Shell Arguments:  -a = Auth database to use (e.g., auth1, auth4).
#                   -c = Clearing database to use (e.g., trnclr1, trnclr4).
#                   -e = Email address to send error messages.
#                   -f = Fee type to calculate (e.g., ALL, VS_ISA_FEE, MC_BORDER,
#                        DS_INTERNATIONAL, MC_GE_1K, CANADA_TAX).
#                   -h = Help with script usage flag.
#                   -i = Institution ID (e.g., ALL, 101, 105, 107, 802).
#                        Required.  No default.
#                   -l = Location of output files.
#                   -m = Month option.
#                   -t = Test run option.
#                   -v = Verbose logging flag.  Optional.  Defaults to OFF.
#                   -y = Year option.
#
# Script Arguments:  -c = Clearing database to use (e.g., trnclr1, trnclr4).
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 802).
#                         Required.
#                    -t = Test run option.
#                    -v = Verbose logging.  Optional.  Defaults to OFF.
#
# Output:  MAS extra processing fee files by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile
source $MASCLR_LIB/mas_env.sh


export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailtolist="$SCRIPT_USER@jetpay.com"
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
INSTITUTION_ID="ALL"
fee_type="ALL"
VERBOSE=""
TEST=""
while getopts "a:c:e:f:hi:l:m:Tvy:" arg
do
    case $arg in
        a)
            AUTH_DATABASE=$OPTARG
            export ATH_DB=$OPTARG
            ;;
        c)
            CLEAR_DATABASE=$OPTARG
            export CLR4_DB=$OPTARG
            ;;
        e)
            mailtolist=$OPTARG
            export MAIL_TO=$OPTARG
            ;;
        f)
            fee_type=$OPTARG
            ;;
        i)
            INSTITUTION_ID=$OPTARG
            ;;
        l)
            if [ -d $OPTARG ]
            then
                LOCATION=$OPTARG
            else
                usage
                exit 1
            fi
            ;;
        m)
            MONTH_OPT="-m$OPTARG"
            ;;
        v)
            VERBOSE="$VERBOSE -v"
            echo "Verbose level $VERBOSE " >&2
            ;;
        T)
            TEST="-T"
            ;;
        y)
            YEAR_OPT="-y$OPTARG"
            ;;
        h|*)
            usage
            exit 1
            ;;
    esac
done

if [ "$VERBOSE" != "" ]
then
    echo AUTH_DATABASE  $AUTH_DATABASE
    echo CLEAR_DATABASE $CLEAR_DATABASE
    echo INSTITUTION_ID $INSTITUTION_ID
    echo LOCATION       $LOCATION
    echo VERBOSE        $VERBOSE
    echo mailtolist     $mailtolist
    echo MAIL_TO        $MAIL_TO
    echo CLR4_DB        $CLR4_DB
    echo ATH_DB         $ATH_DB
fi
######## MAIN ####################################

echo "invoked at `date +%Y%m%d%H%M%S`"
inst_fee_list=""

if [[ $INSTITUTION_ID = "ALL" ]]; then
    inst_list="101 105 107 121"
    inst_fee_list=" MC_GE_1K PIN_DB_SPNSR MC_ANF "
elif [[ $INSTITUTION_ID = "US" ]]; then
    inst_list="101 107 121"
    inst_fee_list=" MNTHLY_SETL "
elif [[ $INSTITUTION_ID = "CANADA" ]]; then
    inst_list="130 132 133"
    inst_fee_list=" CANADA_TAX "
else
    inst_list=$INSTITUTION_ID
fi

# clearing_fee_list="VS_ISA_FEE MC_BORDER DS_INTERNATIONAL ZZACQSUPPORTFEE"
if [[ $fee_type = "ALL" ]]; then
    clearing_fee_list="VS_ISA_FEE MC_BORDER DS_INTERNATIONAL $inst_fee_list"
else
    clearing_fee_list=$fee_type
fi

codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

for inst_id in $inst_list
    do

    for clearing_fee in $clearing_fee_list
        do
        logname="$inst_id.$clearing_fee.log"
        echo "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST $MONTH_OPT $YEAR_OPT started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST $MONTH_OPT $YEAR_OPT >> $locpth/LOG/$logname; then
            echo "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
            echo "$clearing_fee Count File Completed Successfully"
        else
            mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST $MONTH_OPT $YEAR_OPT"
            if [[ "$TEST" == "" ]]; then
                echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c extra_processing_fees.sh" -- $mailtolist
            else
                echo "$mbody_l $sysinfo $mbody" | mutt -s "$msubj_l extra_processing_fees.sh" -- $mailtolist
            fi
        fi
    done

done
