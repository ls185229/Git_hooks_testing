#!/usr/bin/bash
# $Id: put_response.sh 1748 2012-05-21 21:40:30Z daustin $

# Invocation is: put_response.sh <server> <username> <directory> <filename>

DESTINATION_MACHINE=$1
USERNAME=$2
UPLOAD_DIR=$3
FILE_TO_UPLOAD=$4

printf "Uploading response file @ `date +'%m/%d/%y @ %H:%M:%S'`\n"

if echo -e "cd $UPLOAD_DIR\nput $4" | sftp $USERNAME@$DESTINATION_MACHINE ; then
  printf "SFTP transfer of $4 successful\n"
else
  printf "SFTP transfer of $4 failed\n"
  exit 1
fi

printf "Done uploading response file @ `date +'%m/%d/%y @ %H:%M:%S'`\n"

exit 0

