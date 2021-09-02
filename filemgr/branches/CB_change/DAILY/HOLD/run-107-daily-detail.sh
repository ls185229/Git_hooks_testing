#!/usr/bin/bash
. /clearing/filemgr/.profile

# $Id: run-107-daily-detail.sh 4054 2017-02-06 23:16:14Z millig $

mailto="Reports-clearing@jetpay.com"
err_mailto="clearing@jetpay.com"

if [ $# == 0 ]
then
    tclsh nxdy_funding_dd_cycle_5.tcl -i 107
else
    tclsh nxdy_funding_dd_cycle_5.tcl -i 107 -d $1
fi

#Check if the file was generated
cnt=0
cnt=`find ./ -name "ROLLUP.REPORT.DETAIL.*.107.csv" | wc -l`

if [ $cnt -lt "1" ]
then
    echo "ROLLUP.REPORT.DETAIL file for 107 not found!"
    echo "The 107 daily detail file was not generated." | mutt -s "$0 - The 107 daily detail file was not generated." "$err_mailto"
    exit
fi

for f in `ls ROLLUP.REPORT.DETAIL.*.107.csv`; do

    mv  $f nxdy_funding_$f
    echo "file: nxdy_funding_$f"

    echo "Please see attached.." | mutt -s "nxdy_funding_$f" -a "nxdy_funding_$f" "$mailto"
#    cp nxdy_funding_$f ../INST_107/UPLOAD/
    mv nxdy_funding_$f ./FINALS/

    #Only do this for the first file. (Should only be one)
    #Remove this break if you would like all files to be emailed and moved
    break
done

