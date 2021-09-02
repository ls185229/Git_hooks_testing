#!/usr/bin/ksh

# Replaciing the month_min_waive_list.txt file

sqlplus -S masclr/masclr@$IST_DB @build_waive_list.sql
