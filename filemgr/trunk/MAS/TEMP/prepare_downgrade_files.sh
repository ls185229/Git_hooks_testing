#!/usr/bin/bash

# $Id: prepare_downgrade_files.sh 3016 2015-06-25 19:27:17Z jkruse $

FULL_DATE="`date +%Y%m%d`"
SHORT_DATE="`date +%Y%m`"

echo FULL_DATE=$FULL_DATE
echo SHORT_DATE=$SHORT_DATE

 vs_mc_mas_dwngrde_file.tcl JETPAYSQ 105 $FULL_DATE
 vs_mc_mas_dwngrde_file.tcl JETPAYMD 106 $FULL_DATE
 vs_mc_mas_dwngrde_file.tcl JETPAYIS 107 $FULL_DATE
 vs_mc_mas_dwngrde_file.tcl JETPAY 101 $FULL_DATE
 vs_mc_mas_dwngrde_file.tcl BANKCCTL 112 $FULL_DATE
 vs_mc_mas_dwngrde_file.tcl PINNACLE 113 $FULL_DATE
 reject_downgrade_file.tcl 105 $SHORT_DATE
 reject_downgrade_file.tcl 101 $SHORT_DATE
 reject_downgrade_file.tcl 106 $SHORT_DATE
 reject_downgrade_file.tcl 107 $SHORT_DATE
 reject_downgrade_file.tcl 112 $SHORT_DATE
 reject_downgrade_file.tcl 113 $SHORT_DATE
