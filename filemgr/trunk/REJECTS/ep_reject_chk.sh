#!/usr/bin/ksh

# #############################################################################
# $Id: ep_reject_chk.sh 3951 2016-11-09 18:07:38Z bjones $
# #############################################################################
#
# File Name:  ep_reject_chk.sh
#
# Description:  This script currently runs just the chg_ems.tcl script to generate the EMS ROLLUP csv
#
# Running options:
#
# Shell Arguments:
#                    -d = Report date (YYYYMMDD) (Optional)
#                    -t = TEST MODE (Optional)
#
# Output:       Prints 'Script chg_ems.tcl successful.' on chg_ems.tcl running.
#                    Prints 'Script chg_ems.tcl Failed.' on chg_ems.tcl failing to run.
#                    Prints 'End of reject Check started at %Y%m%d%H%M%S'
#
# Return:   0 = Success (chg_ems.tcl script successful)
#           !0 = Exit with errors during the following conditions
#               1) Invalid date provided with -d flag
# #############################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=$(cd $(dirname $0);echo $PWD)
cd "$locpth"

usage(){
    print "Usage:testargparse.sh -d report_date -t"
    print "      where -d is the date to run the ems report for (YYYYMMDD)" 
}

test=""

while getopts "d:t" arg
do
    case $arg in
        d)
            eval "printf '%(%Y%m%d)T' $OPTARG >/dev/null 2>&1"
            if [[ $? -eq 0 ]]; then
                if [[ "$OPTARG" == "$(printf '%(%Y%m%d)T' $OPTARG)" ]]; then
                        format_date="-d $OPTARG"
                    else
                        usage
                        exit 1
                fi
            else
                usage
                exit 1
            fi
            ;;
        t)
            test="-t "
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

#
# 2016/11/07 bjones
# commented out all but chg_ems.tcl to remove card numbers in emails
#
# print "Beginning reject Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# if /clearing/filemgr/REJECTS/update_ems_trans.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then
#
#     print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# else
#     print "Script /clearing/filemgr/REJECTS/update_ems_trans.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#     echo "Script /clearing/filemgr/REJECTS/update_ems_trans.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# fi
#
# sleep 120
#
# if /clearing/filemgr/REJECTS/ep_reject_chk.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then
#
#     print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# else
#     print "Script ep_reject_chk.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#     echo "Script ep_reject_chk.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# fi

if eval "'$locpth/chg_ems.tcl' $test$format_date >> '$locpth/LOG/rejchk.log'"; then

    print "Script chg_ems.tcl successful." | tee -a "$locpth/LOG/rejchk.log"

else
    print "Script chg_ems.tcl Failed." | tee -a "$locpth/LOG/rejchk.log"
    if [[ -z "$test" ]]; then
        echo "Script chg_ems.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
    fi
fi

# if /clearing/filemgr/REJECTS/ipm_err_check.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then
#
#     print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# else
#     print "Script ipm_err_check.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#     echo "Script ipm_err_check.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# fi
#
#
# if /clearing/filemgr/REJECTS/return_record_chk.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then
#
#     print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# else
#     print "Script return_record_chk.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#     echo "Script return_record_chk.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# fi
#
# #if /clearing/filemgr/REJECTS/return_file_status_chk.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then
#
#  #   print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#
# #else
#   #  print "Script return_file_status_chk.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
#  #   echo "Script return_file_status_chk.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# #fi
#
#
# if /clearing/filemgr/REJECTS/datagurad_chk.tcl >> /clearing/filemgr/REJECTS/LOG/dgchk.log; then
#
#     print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/dgchk.log
#
# else
#     print "Script datagurad_chk.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/dgchk.log
#     echo "Script datagurad_chk.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
# fi


print "End of reject Check started at `date +%Y%m%d%H%M%S`" | tee -a "$locpth/LOG/rejchk.log"
