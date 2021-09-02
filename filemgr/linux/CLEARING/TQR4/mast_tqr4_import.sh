#!/bin/bash
################################################################################
#
# File Name:  mast_tqr4_import.sh
#
# Description:  This script controls the entire MasterCard TQR4 import process.
#               The script downloads and processes TQR4 files from on the
#               MasterCard edit package workstation
#
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################
BASE_PATH=/clearing/filemgr/CLEARING/TQR4
TEMP_PATH=TEMP
# ARCHIVE_PATH=$BASE_PATH/ARCHIVE
# ensure directories exist
# mkdir $ARCHIVE_PATH 2> /dev/null

#
# Change CWD and perform downloads
#
cd $TEMP_PATH
$BASE_PATH/mast_tqr4_import.exp

#
# Process TQR
#
cd $BASE_PATH
for filename in $TEMP_PATH/TTQR4T0.*
    do
        ./mast_tqr4_import.py -f $filename -i
        err=$?
        if [ $err -eq 0 ]; then
            # echo "Archiving $filename"
            # ./mast_tqr4_rename.exp $(basename $filename)
            rm $filename
            #    mv $filename $ARCHIVE_PATH
            #    gzip $ARCHIVE_PATH/$filename
        fi
        # Move the TQR4 file to the archive directory in the windows box 
        # regardless of proceesing status.
        echo "Archiving $filename"
        ./mast_tqr4_rename.exp $(basename $filename)

    done
    
