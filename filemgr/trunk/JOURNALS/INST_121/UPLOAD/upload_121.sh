#!/usr/bin/ksh
. /clearing/filemgr/.profile

#################################################################
# $Id: upload_121.sh 2789 2015-02-26 18:48:13Z mitra $
# $Rev: 2789 $
#################################################################

CRON_JOB=1
export CRON_JOB

err_mailto="clearing@jetpay.com"

## Directory locations ##
locpth=$PWD
logfile="$locpth/LOG/upload.log"
ARCHIVE_DIR="../ARCHIVE"

print "Beginning INST 121 Report UPLOAD at" `date "+%m/%d/%y %H:%M:%S"` " from $locpth" 

# Move files already present in the ARCHIVE directory to avoid errors in upload.exp
common_files=("$( comm -12 <(ls 121*.csv) <(cd $ARCHIVE_DIR && ls 121*.csv))")

if [ ! -z  "$common_files" ]; then
   for i in $common_files
   do
      mv $i $ARCHIVE_DIR
   done
fi

# Check if appropriate files in UPLOAD directory still exist and need to be uploaded
if [ ! -z "$(ls 121*.csv)" ]; then
   if upload.exp 121\*.csv >> $locpth/ftp.log; then
      echo "upload of inst 121 reports to Esquire Bank successful" 
   else
      print "Ending ... 121 UPLOAD to Esquire Bank FAILED at `date +%Y%m%d%H%M%S`" 
      tail -11 $logfile | mutt -s "inst 121 report upload to client failed. Location: $locpth" $err_mailto
      exit 1
   fi
else
   print "Ending... No files to be uploaded to Esquire Bank are present at `date +%Y%m%d%H%M%S`"
fi

print "Ending INST 121 Report UPLOAD at" `date "+%m/%d/%y %H:%M:%S"` 
print ""
print ""

################
################
