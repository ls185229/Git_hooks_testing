#!/usr/bin/ksh

# $Id: extra_processing_fees.sh 3016 2015-06-25 19:27:17Z jkruse $

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
 mailtolist="bjones@jetpay.com"
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
VERBOSE=""
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

print "invoked at `date +%Y%m%d%H%M%S`"
# clearing_fee_list="VS_ISA_FEE MC_BORDER DS_INTERNATIONAL ZZACQSUPPORTFEE"
clearing_fee_list="VS_ISA_FEE MC_BORDER DS_INTERNATIONAL"
inst_id="105"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
    logname="$inst_id.$clearing_fee.log"
    print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
    if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
        print "$clearing_fee Count File Completed Successfully"
    else
        mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
        echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    fi
    done

#else
#	print "Not yet end of the month. This code should be run only at end of month."
#fi


inst_id="107"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
        logname="$inst_id.$clearing_fee.log"
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
                print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
                print "$clearing_fee Count File Completed Successfully"
        else
                mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
                echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        fi
    done

#else
#        print "Not yet end of the month. This code should be run only at end of month."
#fi


inst_id="101"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
        logname="$inst_id.$clearing_fee.log"
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
                print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
                print "$clearing_fee Count File Completed Successfully"
        else
                mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
                echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        fi
    done

#else
#        print "Not yet end of the month. This code should be run only at end of month."
#fi

inst_id="106"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
        logname="$inst_id.$clearing_fee.log"
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
                print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
                print "$clearing_fee Count File Completed Successfully"
        else
                mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
                echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        fi
    done

#else
#        print "Not yet end of the month. This code should be run only at end of month."
#fi

inst_id="112"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
        logname="$inst_id.$clearing_fee.log"
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
                print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
                print "$clearing_fee Count File Completed Successfully"
        else
                mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
                echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        fi
    done

#else
#        print "Not yet end of the month. This code should be run only at end of month."
#fi

inst_id="113"
codename="extra_processing_fees.tcl"

#if /clearing/filemgr/lastday.sh; then

  for clearing_fee in $clearing_fee_list
    do
        logname="$inst_id.$clearing_fee.log"
        print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST >> $locpth/LOG/$logname; then
                print "Script $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
                print "$clearing_fee Count File Completed Successfully"
        else
                mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee $VERBOSE $TEST "
                echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        fi
    done

#else
#        print "Not yet end of the month. This code should be run only at end of month."
#fi


