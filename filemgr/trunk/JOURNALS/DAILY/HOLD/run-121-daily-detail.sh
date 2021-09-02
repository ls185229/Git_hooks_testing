#!/usr/bin/bash
. /clearing/filemgr/.profile

# $Id: run-121-daily-detail.sh 4054 2017-02-06 23:16:14Z millig $

mailto="Reports-clearing@jetpay.com"
err_mailto="clearing@jetpay.com"

if [ $# == 0 ]
then
    tclsh all-daily-detail.tcl -i 121
else
    tclsh all-daily-detail.tcl -i 121 -d $1
fi

#Check if the file was generated
cnt=0
cnt=`find ./ -name "ROLLUP.REPORT.DETAIL.*.121.csv" | wc -l`

if [ $cnt -lt "1" ]
then
    echo "ROLLUP.REPORT.DETAIL file for 121 not found!"
    echo "The 121 daily detail file was not generated." | mutt -s "$0 - The 121 daily detail file was not generated." "$err_mailto"
    exit
fi

for f in `ls ROLLUP.REPORT.DETAIL.*.121.csv`; do

    echo "file: $f"

    echo "Please see attached.." | mutt -s "$f" -a "$f" "$mailto"
#   cp $f ../INST_121/UPLOAD/
    mv $f ./FINALS/

    #Only do this for the first file. (Should only be one)
    #Remove this break if you would like all files to be emailed and moved
    break
done

