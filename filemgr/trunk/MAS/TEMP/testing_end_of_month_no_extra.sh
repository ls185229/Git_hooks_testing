#!/usr/bin/ksh


cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 101 -e bjones@jetpay.com >> ./LOG/all_mas_count_101.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 107 -e bjones@jetpay.com >> ./LOG/all_mas_count_107.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 105 -e bjones@jetpay.com >> ./LOG/all_mas_count_105.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 106 -e bjones@jetpay.com >> ./LOG/all_mas_count_106.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 811 -e bjones@jetpay.com >> ./LOG/all_mas_count_811.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 112 -e bjones@jetpay.com >> ./LOG/all_mas_count_112.log 2>&1 &
cd /clearing/filemgr/MAS/TEMP; ./all_mas_count_sum_file_v13.sh -v -v -v -T -i 113 -e bjones@jetpay.com >> ./LOG/all_mas_count_113.log 2>&1 &
# cd /clearing/filemgr/MAS/TEMP; extra_processing_fees.sh  >> LOG/extra_processing.log 2>&1 &

cd /clearing/filemgr/MAS/TEMP; fanf_processing.sh -v -v -v -T -i105  -e bjones@jetpay.com >> LOG/fanf_processing_FR_01.log  2>&1 &
cd /clearing/filemgr/MAS/TEMP; fanf_processing.sh -v -v -v -T -i105  -e bjones@jetpay.com >> LOG/fanf_processing_FR_02.log  2>&1 &

cd /clearing/filemgr/MAS/TEMP; fanf_processing.sh -v -v -v -T -i ALL  -e bjones@jetpay.com >> LOG/fanf_processing_FR_03.log  2>&1 & 
