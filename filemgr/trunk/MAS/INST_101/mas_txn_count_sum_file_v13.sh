#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth

print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/maslog.txt



if mas_txn_count_sum_file_v13.tcl JETPAY 101 `date +%Y%m%d` >> $locpth/LOG/maslog.txt; then
	print "Script mas_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/maslog.txt
else
	echo "Script mas_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: Script mas_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi

if mas_recyl_txn_count_sum_file_v13.tcl JETPAY 101 `date +%Y%m%d` >> $locpth/LOG/rcyllog.txt; then
        print "Script mas_recyl_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/rcyllog.txt
else
        echo "mas_recyl_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: mas_recyl_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi

if mas_avcvbb_txn_count_sum_file_v13.tcl JETPAY 101 `date +%Y%m%d` >> $locpth/LOG/avscvvbb.log; then
        print "mas_avcvbb_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/avscvvbb.log
else
        echo "mas_avcvbb_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: mas_avcvbb_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi

if mas_vau_count_sum_file.tcl JETPAY 101 `date +%Y%m%d` >> $locpth/LOG/vau.log; then
        print "mas_vau_count_sum_file.tcl completed" | tee -a $locpth/LOG/vau.log
else
        echo "mas_vau_count_sum_file.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: mas_vau_count_sum_file.tcl Failed" $MAIL_TO
fi

print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/maslog.txt

