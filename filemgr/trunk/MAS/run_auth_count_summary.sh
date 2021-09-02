#!/usr/bin/bash


for ((day = 630 ; day <= 630; day = day + 1))
do
    cd ~/MAS; ~/MAS/auth_count_summary.sh 20120$day >> ~/MAS/LOG/MAS.auth_count_06.log 2>&1
done

for ((day = 701 ; day <= 723; day = day + 1))
do
    cd ~/MAS; ~/MAS/auth_count_summary.sh 20120$day >> ~/MAS/LOG/MAS.auth_count_07.log 2>&1
done
