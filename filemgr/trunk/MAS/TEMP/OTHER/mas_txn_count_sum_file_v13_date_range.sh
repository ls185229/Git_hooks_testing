#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr 
print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/maslog.txt

#/clearing/filemgr/MAS/mas_txn_count_sum_file_v13.tcl rkhan spawn123 masclr masclr 447474 jetpay `date +%Y%m%d` >> /clearing/filemgr/MAS/MAS_LOGS/mas_log.txt
print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/maslog.txt

print "-----------------------------------------------------------------------------------------------" | tee -a /clearing/filemgr/MAS/maslog.txt
