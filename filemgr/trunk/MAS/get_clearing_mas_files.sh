#!/bin/bash

# $Id: get_clearing_mas_files.sh 4576 2018-05-24 19:40:08Z bjones $

. /clearing/filemgr/.profile

source $MASCLR_LIB/mas_env.sh

echo `date +%Y/%m/%d-%H:%M:%S` "get_clearing_mas_files.sh $1 $2 $3"

# ssh -q filemgr@dfw-prd-clr-01 ls -l $CLR_OSITE_DATA/ftp/out
ssh -q filemgr@$CLEARING_BOX ls -l $CLR_OSITE_DATA/ftp/out

# scp filemgr@dfw-prd-clr-01:$CLR_OSITE_DATA/ftp/out/*CLEARING* ~/MAS/ON_HOLD_FILES/
scp filemgr@$CLEARING_BOX:$CLR_OSITE_DATA/ftp/out/*CLEARING* ~/MAS/ON_HOLD_FILES/

ls -l ~/MAS/ON_HOLD_FILES/

cd  ~/MAS/ON_HOLD_FILES/

for f in *CLEARING.01.* ;
do
    date_time_stamp=`date +%Y%m%d-%H%M%S`
    # ssh -q filemgr@dfw-prd-clr-01 mv $CLR_OSITE_DATA/ftp/out/$f $CLR_OSITE_DATA/ftp/out/mas_file_archive/$f-$date_time_stamp ;
    ssh -q filemgr@$CLEARING_BOX mv $CLR_OSITE_DATA/ftp/out/$f $CLR_OSITE_DATA/ftp/out/mas_file_archive/$f-$date_time_stamp ;
    # ssh -q filemgr@dfw-prd-clr-01 gzip $CLR_OSITE_DATA/ftp/out/mas_file_archive/$f-$date_time_stamp ;
    ssh -q filemgr@$CLEARING_BOX gzip $CLR_OSITE_DATA/ftp/out/mas_file_archive/$f-$date_time_stamp ;
done

# The 122 Institution clearing files are not processed, so move them to the INST_122 folder
# mv ~/MAS/ON_HOLD_FILES/122.CLEARING.01.* ~/MAS/INST_122/
# 2018/05/24 122 files are now going into MAS

mv ~/MAS/ON_HOLD_FILES/*CLEARING.01.* ~/MAS/MAS_FILES/

echo `date +%Y/%m/%d-%H:%M:%S` "get_clearing_mas_files.sh end"
