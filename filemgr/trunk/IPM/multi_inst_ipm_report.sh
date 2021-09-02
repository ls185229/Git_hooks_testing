#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: multi_inst_ipm_report.sh 3724 2016-04-05 22:27:58Z millig $
# $Rev: 3724 $
################################################################################
#
# Arg1 = date (YYYYMMDD) optional 
# Arg1 is used to rerun a reports for all instittuions that are currently   
#      turned on CFG/ipm.t140.cfg file. 
# The original TT140 files exist on /clearing/filemgr/IPM/ARCHIVE.
################################################################################

CRON_JOB=1
export CRON_JOB

# export ORACLE_SID=clear1
# export TWO_TASK=clear1
export ORACLE_SID=$env(IST_DB)
export TWO_TASK=$env(IST_DB)
echo $ORACLE_HOME
echo $TWO_TASK

code_name="multi_inst_ipm_report.tcl"

EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"

notify_someone()
{
 echo $1 | mutt -s "$SYS_BOX: $code_name IPM Report Processing Error ***" $EMAIL_LIST
}


if multi_inst_ipm_report.tcl $1 >> ./LOG/multi_inst_ipm_report.log
  then
      print "$code_name $1 successful" 
  else 
      print "$code_name $1 failed"
      notify_someone "$code_name $1 run failed"
fi

#########
#########
