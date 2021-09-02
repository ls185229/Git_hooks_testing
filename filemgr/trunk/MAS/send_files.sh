#!/usr/bin/env bash
. /clearing/filemgr/.profile

while getopts "i:" opt; do
  case ${opt} in
	i )
	  institution=$OPSTARG
	  ;;

  esac
done
if [ -f "send_file.stop" ]; then
	echo `date "+%m/%d/%y %H:%M:%S"` "Lock file exists, exiting";
	exit 1;
else
	touch ~/MAS/send_file.stop;
fi

echo `date "+%m/%d/%y %H:%M:%S"` "Script Started"

if [ ! -z $institution ]; then
        echo `date "+%m/%d/%y %H:%M:%S"` "Institution is " $institution
        cd ~/MAS/MAS_FILES;
        for f in $institution*;
        do echo $f;
        if [ -f "$f" ]; then
                touch $f;
                cp $f $MAS_OSITE_ROOT/data/in/$f;
                if [[ "$?" -ne 0 ]]; then
                    echo `date "+%m/%d/%y %H:%M:%S"` "Error: Not able to copy the file $f to data/in directory. \n Check the log file for more details." | mailx -r $MAIL_FROM -s "$SYS_BOX Critical: send_files script failed" $ALERT_EMAIL;
					rm ~/MAS/send_file.stop
                    exit 1;
                fi
                mv $f ~/MAS/ARCHIVE/$f-`date +%Y%m%d-%H%M%S` ;
                if [[ "$?" -ne 0 ]]; then
                    echo `date "+%m/%d/%y %H:%M:%S"` "Error: Not able to move the file $f to ARCHIVE directory. \n Check the log file for more details." | mailx -r $MAIL_FROM -s "$SYS_BOX Error: send_files script failed" $ALERT_EMAIL;
					rm ~/MAS/send_file.stop
                    exit 1;
                fi
        fi
		done
else
        cd ~/MAS/MAS_FILES;
        for f in 1* 8*;
        do echo `date +%Y%m%d-%H%M%S` $f;
        if [ -f "$f" ]; then
                touch $f;
				sleep 1;
                cp $f $MAS_OSITE_ROOT/data/in/$f;
                if [[ "$?" -ne 0 ]]; then
                    echo `date "+%m/%d/%y %H:%M:%S"` "Error: Not able to copy the file $f to data/in directory.\n Check the log file for more details." | mailx -r $MAIL_FROM -s "$SYS_BOX Critical: send_files script failed" $ALERT_EMAIL;
					rm ~/MAS/send_file.stop
                    exit 1;
                fi
                mv $f ~/MAS/ARCHIVE/$f-`date +%Y%m%d-%H%M%S` ;
                if [[ "$?" -ne 0 ]]; then
                    echo `date "+%m/%d/%y %H:%M:%S"` "Error: Not able to move the file $f to ARCHIVE directory.\n Check the log file for more details." | mailx -r $MAIL_FROM -s "$SYS_BOX Error: send_files script failed" $ALERT_EMAIL;
					rm ~/MAS/send_file.stop
                    exit 1;
                fi
        fi
        done
fi
rm ~/MAS/send_file.stop
echo `date "+%m/%d/%y %H:%M:%S"` "Script Completed"