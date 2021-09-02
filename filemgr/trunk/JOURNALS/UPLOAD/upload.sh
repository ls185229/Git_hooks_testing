#!/usr/bin/ksh
. /clearing/filemgr/.profile

#################################################################
#   File Name:      upload.sh
#
#   Description:    This script will upload reports found in an
#                   institution's UPLOAD directory to the sftp server
#
#   Arguments:     -i institution id
#################################################################

CRON_JOB=1
export CRON_JOB

err_mailto="clearing@jetpay.com"

#################################################################
# Function:      usage()
# Description:   Print the syntax for this script
#################################################################
usage()
{
    echo "Usage: upload.sh [-i institution]"
    echo "      -i = institution ID (required)"

    echo "Example - "
    echo "      upload.sh -i 121"
}

#################################################################
# Function:     init()
# Description:  Initialize the startup parameters
#################################################################
init(){
    while getopts "i:u" option
    do
        case $option in
            i)  instId=$OPTARG ;;
            ?|u) 
                usage
                exit 1;;
        esac
    done

    if [ ! $instId ]
    then
        print "ERROR: Missing Argument : Need institution ID"
        usage
        exit 1
    fi

    progArgs="-i $instId"

    ## Directory Locations ##
    ARCHIVE_DIR="../INST_$instId/ARCHIVE"
    UPLOAD_DIR="../INST_$instId/UPLOAD"

    ## initialize log file ##
    echo "************************************"
    echo "Executing upload.sh on `date +%m/%d/%Y@%H:%M:%S`"
    echo "Arguments passed $progArgs"
    echo "************************************"
}

##########
## MAIN ##
##########

init $*

# Institute info goes here
case $instId in
    117) 
        regex='117.MERIDIAN.DISC.ARI.REPORT.*.csv'
        upl_script="upload_SBC.exp"
        destination="Discover ARI to SBC";;
    121|122)
        regex="$instId*.csv"
        upl_script="upload.exp"
        destination="Esquire Bank";;
    *)
        echo "INST $instId not supported in this script"
        echo ""
        echo ""
        exit 1;;
esac

echo "Beginning INST $instId Report UPLOAD at" `date "+%m/%d/%y %H:%M:%S"`

# Move files already in the ARCHIVE directory to avoid errors in upload.exp
common_files=("$( comm -12 <(cd $UPLOAD_DIR && ls $regex) <(cd $ARCHIVE_DIR && ls $regex))")

if [ -n  "$common_files" ]; then
    for i in $common_files
    do
        (cd $UPLOAD_DIR && mv $i ../ARCHIVE)
    done
fi

# Check if files to be uploaded in UPLOAD directory still exist
if [ -n "$(cd $UPLOAD_DIR && ls $regex)" ]; then
    if $UPLOAD_DIR/$upl_script "$(cd $UPLOAD_DIR && ls $regex)" >> $UPLOAD_DIR/ftp.log; then
        echo "$destination upload for INST $instId successful" 
    else
        echo "Ending ... $destination upload for INST $instId FAILED at `date +%Y%m%d%H%M%S`" 
        tail -11 $logfile | mutt -s "INST $instId report upload to client failed. Location: $locpth" $err_mailto
        exit 1
    fi
else
    echo "Ending... No files for INST $instId to be uploaded are present at `date +%Y%m%d%H%M%S`"
fi

echo "Ending INST $instId Report UPLOAD at" `date "+%m/%d/%y %H:%M:%S"` 
echo ""
echo ""
