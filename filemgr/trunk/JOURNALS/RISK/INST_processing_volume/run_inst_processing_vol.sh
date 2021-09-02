#!/usr/bin/ksh
. /clearing/filemgr/.profile

#$Id: run_inst_processing_vol.sh 2520 2014-01-22 21:45:11Z mitra $

###########################################################################
# Institution Processing Volume Risk Report 
# This script is scheduled to run on the last day of each month  
#
# How to run manually: 
#     tclsh inst_processing_vol.tcl -i $inst -d date -sort AUTH_DECLINES
#
# Without -d, script will pick up the system date and run the report 
#     month to date for the current month
# -sort could be one of the following: AUTH_DECLINES, CUR_SALES_AMT, 
#     AVG_TICKET, PERC_CHNGE, CHARGBK_CNT
#
# There can be multiple -sort options on the same command line.  Each one
# will make a separate report.
###########################################################################

CRON_JOB=1
export CRON_JOB

error_recipient="clearing@jetpay.com"

errstr="An error occurred while executing the Institution Processing Volume Risk Report"

today=$(date +%d)
echo Today is: $today

month_last_day=$(cal | tr ' ' '\n'|grep -v '^$' |tail -1)
echo Last day of Month is: $month_last_day

if [ $today -eq $month_last_day ]; then

    for inst in 101 105 107 117 121; do

        #This creates 5 outputs for each inst. One output per sort order
        tclsh inst_processing_vol.tcl -i $inst -sort AUTH_DECLINES \
                                               -sort CUR_SALES_AMT \
                                               -sort AVG_TICKET    \
                                               -sort PERC_CHNGE    \
                                               -sort CHARGBK_CNT
        if [ $? -ne 0 ]; then
            echo "$errstr while processing inst: $inst" | \
                mutt -s "inst_processing_vol.tcl Report Failure" $error_recipient
        fi
    done

    tclsh mcc_processing_vol.tcl -mcc 4814 -mcc 5962 -mcc 5966 -mcc 5968
    if [ $? -ne 0 ]; then
        echo "$errstr while processing mcc_processing_vol.tcl" | \
            mutt -s "mcc_processing_vol.tcl Report Failure" $error_recipient
    fi
    mv *.csv ./ARCHIVE
fi

