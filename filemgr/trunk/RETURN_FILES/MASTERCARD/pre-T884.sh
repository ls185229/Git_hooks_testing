#!/usr/bin/bash
timestamp=`date +%Y-%m-%d`
success=0
ls TT884T0* || success=1
if [ $success -eq 0 ] 
then
	for MCRCFILE in TT884T0*
	do
	success=0
	cp $MCRCFILE EDPT0079893/ARCHIVE/PD-$MCRCFILE-$timestamp-original
 	./pre-T884.pl $MCRCFILE || success=1
	if [ $success -eq 0 ]
	then
		echo "Pre-processing of file $MCRCFILE was successful"
	else
		echo "Pre-processing of file $MCRCFILE FAILED"
		exit 1
	fi
	# if file size is now less than a valid file
	# move it to ARCHIVE without giving it a chance to go into clearing	
	filesize=$(stat -c%s "$MCRCFILE")
	echo $filesize
	if [ $filesize -lt 333 ]
	then
		echo "Moving empty file $MCRCFILE to archive"
		mv $MCRCFILE EDPT0079893/ARCHIVE/PD-$MCRCFILE-$timestamp-modified
	fi
	done
fi
