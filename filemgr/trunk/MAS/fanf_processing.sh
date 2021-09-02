#!/usr/bin/env bash

################################################################################
# $Id: fanf_processing.sh 4651 2018-07-27 21:42:47Z bjones $
# $Rev: 4651 $
################################################################################
#
# File Name:  fanf_processing.sh
#
# Description:  This script initiates the generation of MAS FANF files by
#               institution.
#
# Shell Arguments:  -a = Auth database to use (e.g., auth1, auth4).
#                   -c = Clearing database to use (e.g., trnclr1, trnclr4).
#                   -e = Email address to send error messages.
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
#                    -m = Month option.
#                    -t = Test run option.
#                    -v = Verbose logging.  Optional.  Defaults to OFF.
#                    -y = Year option.
#
# Output:  MAS FANF files by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

##################################################################################

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

usage(){
    echo all_mas_count_sum_file.sh - building counting files
    echo "Usage:all_mas_count_sum_file.sh [-hv] [-a auth_database] "
    echo "              [-c clearing_database] [-e email_address]  "
    echo "              [-i inst] [-l location_for_output]"
    echo "  -i INST     Institution to be counted (ALL is default)"
    echo "  -e a@b.com  email address to send error messages"
    echo "  -a transp4  Auth database to use, transp1, transp4"
    echo "  -c masclr4  Clearing database to use, masclr1, masclr4"
    echo "  -h          help, this output"
    echo "  -l ON_HOLD  location of output files"
    echo "  -v          verbose (possibly debug) output"
}


AUTH_DATABASE=$ATH_DB
CLEAR_DATABASE=$CLR4_DB
INSTITUTION_ID="ALL"
LOCATION=ON_HOLD_FILES
VERBOSE=0
TEST=""
while getopts "a:c:e:hi:l:m:Tvy:" arg
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
            let VERBOSE=$VERBOSE+1
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

if [ $VERBOSE -gt 0 ]
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

echo "envoked at `date +%Y%m%d%H%M%S`"
codename="fanf_processing.tcl"

if [[ $INSTITUTION_ID == "ALL" ]]; then
    inst_list="101 105 107 121"
else
    inst_list=$INSTITUTION_ID
fi

for inst_id in $inst_list
    do
    #codename="all_mas_txn_count_sum_file_v13.tcl"

    #if /clearing/filemgr/lastday.sh; then
    cnt_list="FANF"
    case $inst_id in
        105  ) cnt_list="$cnt_list FPREPORT FPRPT02";;
        # 130  ) cnt_list="FUNDXFER";;
    esac

    for cnt_type in $cnt_list
        do
        logname="$inst_id.$cnt_type.log"
        echo "Script $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT started."
        if $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT >> $locpth/LOG/$logname; then
            echo "Script $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT completed." >> $locpth/LOG/$logname
            echo "$cnt_type Count File Completed Successfully"
        else
            mbody="Script failed:\n $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT "
            #echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            if [[ "$TEST" -eq "" ]]; then
                echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c all_mas_count_sum_file_v13.sh" -- $mailtolist
            else
                echo "$mbody_l $sysinfo $mbody" | mutt -s "$msubj_l all_mas_count_sum_file_v13.sh" -- $mailtolist
            fi
        fi
    done

done
