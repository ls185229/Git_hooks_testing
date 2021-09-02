#!/usr/bin/bash


cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 101 -e bjones@jetpay.com >> ./LOG/all_mas_count_101.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 105 -e bjones@jetpay.com >> ./LOG/all_mas_count_105.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 107 -e bjones@jetpay.com >> ./LOG/all_mas_count_107.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 121 -e bjones@jetpay.com >> ./LOG/all_mas_count_121.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 129 -e bjones@jetpay.com >> ./LOG/all_mas_count_129.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 130 -e bjones@jetpay.com >> ./LOG/all_mas_count_130.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 134 -e bjones@jetpay.com >> ./LOG/all_mas_count_134.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 811 -e bjones@jetpay.com >> ./LOG/all_mas_count_811.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; extra_processing_fees.sh -v -v -v -T >> LOG/extra_processing.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; fanf_processing.sh -v -v -v -T -i ALL  -e bjones@jetpay.com >> LOG/fanf_processing.log  2>&1 &
