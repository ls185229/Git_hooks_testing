#!/usr/bin/ksh

# $Id: fanf_processing.sh 3016 2015-06-25 19:27:17Z jkruse $

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
    print all_mas_count_sum_file.sh - building counting files
    print "Usage:all_mas_count_sum_file.sh [-hv] [-a auth_database] "
    print "              [-c clearing_database] [-e email_address]  "
    print "              [-i inst] [-l location_for_output]"
    print "  -i INST     Institution to be counted (ALL is default)"
    print "  -e a@b.com  email address to send error messages"
    print "  -a transp4  Auth database to use, transp1, transp4"
    print "  -c masclr4  Clearing database to use, masclr1, masclr4"
    print "  -h          help, this output"
    print "  -l ON_HOLD  location of output files"
    print "  -v          verbose (possibly debug) output"
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

print "envoked at `date +%Y%m%d%H%M%S`"
codename="fanf_processing.tcl"

if [[ $INSTITUTION_ID == "ALL" ]]; then
    inst_list="101 105 106 107 112 113"
else
    inst_list=$INSTITUTION_ID
fi

for inst_id in $inst_list
    do
    #codename="all_mas_txn_count_sum_file_v13.tcl"

    #if /clearing/filemgr/lastday.sh; then
    cnt_list="FANF"
    case $inst_id in
        105 ) cnt_list="$cnt_list FPREPORT FPRPT02";;
    esac

    for cnt_type in $cnt_list
        do
        logname="$inst_id.$cnt_type.log"
        print "Script $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT started."
        if $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT >> $locpth/LOG/$logname; then
            print "Script $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT completed." >> $locpth/LOG/$logname
            print "$cnt_type Count File Completed Successfully"
        else
            mbody="Script failed:\n $locpth/$codename -i$inst_id -c$cnt_type $TEST $YEAR_OPT $MONTH_OPT "
            #echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
            if [[ "$TEST" -eq "" ]]; then
                echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c all_mas_count_sum_file_v13.sh" $mailtolist
            else
                echo "$mbody_l $sysinfo $mbody" | mutt -s "$msubj_l all_mas_count_sum_file_v13.sh" $mailtolist
            fi
        fi
    done

done
