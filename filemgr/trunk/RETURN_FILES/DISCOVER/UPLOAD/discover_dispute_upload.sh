#!/usr/bin/ksh

# $Id: discover_dispute_upload.sh 1961 2013-01-17 20:52:35Z mitra $

# Main script for processing the Discover settlement file

# Invocation is: discover_settlement.sh 

# Following notifies .profile that this is a cron script so do not invoke
# STTY command, otherwise script generates a "stty: : No such device or address"
# email every day.

CRON_JOB=1
export CRON_JOB

. /clearing/filemgr/.profile

##################################################################################

 clrpath=$CLR_OSITE_ROOT
 maspath=$MAS_OSITE_ROOT
 mailtolist=$MAIL_TO
 mailfromlist=$MAIL_FROM
 clrdb=$IST_DB
 authdb=$ATH_DB
 box=$SYS_BOX



#Email Subjects variables Priority wise

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

#Email Subjects variables Priority wise

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#####################################################################################################

locpth=$PWD
cd $locpth


print "\nDiscover settlement started on" `date +'%m/%d/%y @ %H:%M:%S'`
run_num=`expr $1 + 1`
cnt=1
TIME_STAMP=`date +%Y%m%d%H%M%S`
HOST_NAME=`hostname`
DISCOVER_DIR="discover_files"
EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"

if [[ $1 -eq "" ]]
then
echo "No argument provided for get_anr.sh" | mailx -r clearing@jetpay.com -s "*** Discover anr File Processing Error ***" $EMAIL_LIST
exit 0
fi


confirmation_file=INDS.OUT.DISPIMGE.*

 for file in `find . -type f -name "$confirmation_file"`
  do
   if [ -s $file ] 
   then
	print $cnt
	if [[ $cnt -eq $run_num ]]
		then
			echo "Found More than expected $run_num files. Please, look at LOG for file list." | mailx -r clearing@jetpay.com -s "*** Discover File Upload ISSUE ***" $EMAIL_LIST
			exit 0
	fi
      if discover_DISPIMGE_file_upload.exp $file
      then
         print "Discover File $file transfer complete"
         echo "Discover file $file Uploaded" 
         mv $file ../ARCHIVE
	 cnt=`expr $cnt + 1`
      else
         print "Discover File transfer failed"
         echo "Discover file:$file Failed to Upload to Discover.  Log into to filemgr and cd DISCOVER/UPLOAD/" | mailx -s "$msubj_c" $EMAIL_LIST
      fi
   else
     echo "Discover file is zero bites.  Contact On call clearing engineer." | mailx -s "$msubj_c" $EMAIL_LIST
   fi
sleep 35
  done

confirmation_file=INDS.OUT.DISPNTCE.*

 for file in `find . -type f -name "$confirmation_file"`
  do
   if [ -s $file ]
   then
        print $cnt
        if [[ $cnt -eq $run_num ]]
                then
                        echo "Found More than expected $run_num files. Please, look at LOG for file list." | mailx -r clearing@jetpa
y.com -s "*** Discover File Upload ISSUE ***" $EMAIL_LIST
                        exit 0
        fi
      if discover_DISPNTCE_file_upload.exp $file
      then
         print "Discover File $file transfer complete"
         echo "Discover file $file Uploaded" 
         mv $file ../ARCHIVE
         cnt=`expr $cnt + 1`
      else
         print "Discover File transfer failed"
         echo "Discover file:$file Failed to Upload to Discover.  Log into to filemgr and cd DISCOVER/UPLOAD/" | mailx -s "$msubj_c"
 $EMAIL_LIST
      fi
   else
     echo "Discover file is zero bites.  Contact On call clearing engineer." | mailx -s "$msubj_c" $EMAIL_LIST
   fi
sleep 35
  done

print "Discover settlement complete on" `date +'%m/%d/%y @ %H:%M:%S'`

