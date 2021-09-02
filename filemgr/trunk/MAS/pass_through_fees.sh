#!/usr/bin/env ksh
# ###############################################################################
# $Id: pass_through_fees.sh 4876 2019-07-25 21:05:16Z skumar $
# $Rev: 4876 $
# ###############################################################################
#
# File Name:  pass_through_fees.sh
#
# Description:  This script creates the fee mas file
#
# Running options:
#
#    Arguments - i = institution id (Required)
#                c = count type (Required)
#                m = month in MM format (optional)
#                y = year in YYYY format (optional)
#                v = debug level (optional)
#    Example - pass_through_fees.sh -i 107 -c VOUCHER
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - syntax error/Invalid argument
#           2 - Code logic
#           3 - DB error
#
# ###############################################################################
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

locpth=`pwd`
cd $locpth
usage(){
    print "Usage:pass_through_fees.sh [-i institution_id] [-c cnt_type] [-m month in MM format] [-y year in YYYY format]"
    print "      Eg: 1) pass_through_fees.sh -i 107 -c VOUCHER"
    print "          2) pass_through_fees.sh -i 107 -c VOUCHER -m 12 -y 2016"
    print "          2) pass_through_fees.sh -i ALL -c ALL"
}

flag=0
run_year=`date +%Y`
run_month=`date +%m`
while getopts "hi:e:c:m:y:tv" arg
do
    case $arg in
        i)
            inst_id=$OPTARG
            flag=1
            ;;
        c)
            cnt_type=$OPTARG
            flag=1
            ;;
        e)
            mailtolist=$OPTARG
            export MAIL_TO=$OPTARG
            ;;
        m)
            run_month=$OPTARG
            ;;
        y)
            run_year=$OPTARG
            ;;
        v)
            VERBOSE=$VERBOSE" -v"
            echo "Verbose level $VERBOSE " >&2
            ;;
        t)
            TEST="-t"
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

echo "invoked at `date +%Y%m%d%H%M%S`"

if [[ $inst_id = "ALL" ]]; then
    inst_list="101 105 107 121"
else
    inst_list=$inst_id
fi


if [[ $cnt_type = "ALL" ]]; then
    clearing_fee_list="VOUCHER TXNINTGR MCDWNGRD TRANSMIS AXBORDER AXCNPRES DSNOQUAL ZEROVERI NWACQPRO AVSASSOC CVVASSOC MISAUTH MISCAPT DCLNAUTH SMS_ITEM 3DS_AUTH"
elif [[ $cnt_type = "CLR" ]]; then
    clearing_fee_list="VOUCHER TXNINTGR MCDWNGRD TRANSMIS AXBORDER AXCNPRES DSNOQUAL"    
elif [[ $cnt_type = "PORT" ]]; then
    clearing_fee_list="ZEROVERI NWACQPRO DCLNAUTH"
elif [[ $cnt_type = "AUTH" ]]; then
    clearing_fee_list="AVSASSOC CVVASSOC MISAUTH MISCAPT SMS_ITEM 3DS_AUTH"   
else
    clearing_fee_list=$cnt_type
fi

codename="pass_through_fees.tcl"

for inst_id in $inst_list
    do

    for clearing_fee in $clearing_fee_list
        do
        logname="$inst_id.$clearing_fee.log"
        echo "Script $locpth/$codename -i $inst_id -c $clearing_fee $VERBOSE $TEST started."
        if $locpth/$codename -i $inst_id -c $clearing_fee $VERBOSE $TEST -m $run_month -y $run_year >> $locpth/LOG/$logname; then
            echo "Script $locpth/$codename -i $inst_id -c $clearing_fee $VERBOSE $TEST completed." >> $locpth/LOG/$logname
            echo "$clearing_fee Count File Completed Successfully"
        else
            mbody="Script failed:\n $locpth/$codename -i $inst_id -c $clearing_fee $VERBOSE $TEST "
            if [[ "$TEST" == "" ]]; then
                echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c pass_through_fees.sh" -- $mailtolist
            else
                echo "$mbody_l $sysinfo $mbody" | mutt -s "$msubj_l pass_through_fees.sh" -- $mailtolist
            fi
        fi
    done

done
