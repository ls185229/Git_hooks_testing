#!/usr/bin/bash

# $Id: fix_gl_date.sh 3016 2015-06-25 19:27:17Z jkruse $

cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 101 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 105 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 106 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 107 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 112 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 113 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
sleep 300
cd /clearing/filemgr/MAS/; run_mas_cmd.sh 106 811 "all" >> /clearing/filemgr/MAS/MULTI/LOG/MAS.MULTI.CRON.log 2>&1
