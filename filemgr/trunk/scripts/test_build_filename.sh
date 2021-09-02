#!/usr/bin/env bash

################################################################################
# $Id: test_build_filename.sh 3649 2016-01-22 21:01:04Z bjones $
# $Rev: 3649 $
################################################################################

# test shell script for build_filename.py

#echo arg 0 = $0
#echo arg 1 = $1

if [ "$1" != "" ]
then jday=$1
else jday=5299
fi

dbt_filename=`build_filename.py -i 107 -f DEBITRAN -j $jday`
clr_filename=`build_filename.py -i 107 -f CLEARING -j $jday`
cnv_filename=`build_filename.py -i 107 -f CONVCHRG -j $jday`

echo dbt_filename = $dbt_filename
echo clr_filename = $clr_filename
echo cnv_filename = $cnv_filename
