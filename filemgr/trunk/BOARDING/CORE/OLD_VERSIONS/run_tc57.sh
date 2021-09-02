#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


print "Beginning  TC57 FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/TC57/LOG/txn_move.log

export ORACLE_SID=transbpk
export TWO_TASK=transbpk

./move_txntest.tcl JTPYTEST | tee -a /clearing/filemgr/CORE/txn_move.log


print "Ending TC57 FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/TC57/LOG/txn_move.log
