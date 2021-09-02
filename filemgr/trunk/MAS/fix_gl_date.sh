#!/usr/bin/bash

################################################################################
# $Id: fix_gl_date.sh 3186 2015-07-17 15:45:20Z fcaron $
# $Rev: 3186 $
################################################################################
#
# File Name:  fix_gl_date.sh
#
# Description:  This script initiates GL date advancement for MAS processing by
#               institution.
#              
# Shell Arguments:  None.
#
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 101 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 105 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 107 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 121 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 811 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
