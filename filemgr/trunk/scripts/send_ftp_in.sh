#!/usr/bin/bash

# $Id: send_ftp_in.sh 3011 2015-06-24 19:46:55Z bjones $

if [ "$#" -ne 1 ]
then
    echo "Usage: send_ftp_in.sh <filename>" >&2
    exit 1
elif ! [ -f "$1" ]
then
    echo "Invalid file: $1" >&2
    exit 1
fi

filename=$1

lftp <<!
debug 10
set ssl:cert-file /clearing/filemgr/.certdata/in_cert.pem
set ssl:key-file /clearing/filemgr/.certdata/in_privkey.pem
set ssl:ca-file /clearing/filemgr/.certdata/in_trust.pem
set ssl:verify-certificate false
open -ua,b ftp://172.20.30.55:17532
put $filename
!
