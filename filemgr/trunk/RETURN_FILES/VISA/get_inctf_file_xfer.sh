#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

####################### UPDATE BELOW FOR NEW CIB ###############################

cib="457003"
box=$SYS_BOX
locpth="/clearing/filemgr/RETURN_FILES/VISA"

cd $locpth

##################################################################################


 clrpath=$CLR_OSITE_ROOT
 maspath=$MAS_OSITE_ROOT
 mailtolist=$MAIL_TO
 mailfromlist=$MAIL_FROM
 clrdb=$IST_DB
 authdb=$ATH_DB
 # $CLEARING_BOX
 file_exchanger=$FILE_XCHNGR_VS


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




if $locpth/recv_file_ftp.exp >> $locpth/xfermfe.log; then
    print "File transfer to $locpth is successful." | tee -a $locpth/xfermfe.log
    if $locpth/rename_send_visa_report.tcl >> $locpth/xfermfe.log; then
        print "File transfer to $locpth is successful." | tee -a $locpth/xfermfe.log
        if $locpth/send_file_file_2_QA.exp >> $locpth/xfermfe.log; then
           print "File transfer to QA is successful." | tee -a $locpth/xfermfe.log
           rm INVS*
        else
            # mbody="File transfer to filemgr failed from dfw-prd-clr-02"
            mbody="File transfer to filemgr failed from $file_exchanger"

            print "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
        fi
    else
        # mbody="File transfer to filemgr failed from dfw-prd-clr-02. Rename_send_visa_report.tcl script failed. production $locpth "
        mbody="File transfer to filemgr failed from $file_exchanger. Rename_send_visa_report.tcl script failed. production $locpth "
        print "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
    fi

else
    # mbody="File transfer to filemgr failed from dfw-prd-clr-02. The recv_file_ftp.exp script failed. production $locpth."
    mbody="File transfer to filemgr failed from $file_exchanger. The recv_file_ftp.exp script failed. production $locpth."
    print "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
fi

