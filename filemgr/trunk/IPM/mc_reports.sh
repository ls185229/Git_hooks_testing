#!/usr/bin/bash
. ~/.profile

# $Id: mc_reports.sh 4907 2019-10-15 14:15:38Z bjones $

cd ~/IPM/ ;

export rpt_run_dt=`date +%Y%m%d`
export rpt_dash_dt=`date +%Y-%m-%d`

export workdir=ORIG.IPM.TT140.$rpt_run_dt
mkdir $workdir

recv_file_frm_mfe.exp >> LOG/ipm.t140.rpt.log 2>&1

cnt=0
cnt=`find ./ -name "TT140T0.$rpt_dash_dt*" | wc -l`

if [ $cnt -ne "6" ]
then
    echo "Verify that MFE pulled 6 files from MasterCard for $rpt_dash_dt."
    echo "Verify that MFE pulled 6 files from MasterCard for $rpt_dash_dt." | \
        mutt -s "$0 failed -  Please investigate." \
        -- "assist@jetpay.com, clearing@jetpay.com"
    exit
fi

mv TT140T0.$rpt_dash_dt* $workdir/

cd $workdir/

ln -s ../multi_ipm_split.py multi_ipm_split.py
ln -s ../test_luhn.py test_luhn.py
ln -s ../sre_list_plain.txt sre_list_plain.txt

echo multi_ipm_split.py \>\> ../LOG/test_split_$rpt_run_dt.log
multi_ipm_split.py >> ../LOG/test_split_$rpt_run_dt.log

for f in 000 101 107 117 121 122 127 129 130 132 133 134 ;
    do echo $f;
    ### Extract File Creation Starts Here
    ### Grep the MC Files before they are zipped to create Extract
    echo ggrep -h -E -f ../mcmatch.txt $f*001 | uniq >> $f-MCDailyExtract.$rpt_run_dt.txt ;
    ggrep -h -E -f ../mcmatch.txt $f*001 | uniq >> $f-MCDailyExtract.$rpt_run_dt.txt ;
    ### Extract File Creation Stops Here
    echo zip -m $f-MCDailyReports-$rpt_run_dt.zip $f*001 ;
    zip -m $f-MCDailyReports-$rpt_run_dt.zip $f*001 ;
done

cd ~/IPM/ ;

for f in 101 107 117 121 122 127 129 130 132 133 134 ;
    do echo $f;
    echo ls -l $workdir/$f*MCD*zip;
    ls -l $workdir/$f*MCD*zip;

    echo Attached are the MasterCard daily reports. \
        \| mutt -s "$f MC Daily Reports $rpt_dash_dt" \
        -a $workdir/$f*$rpt_run_dt.zip \
        -a $workdir/$f-MCDailyExtract.$rpt_run_dt.txt \
        -- reports-clearing@jetpay.com;
    echo Attached are the MasterCard daily reports. \
        | mutt -s "$f MC Daily Reports $rpt_dash_dt" \
        -a $workdir/$f*$rpt_run_dt.zip \
        -a $workdir/$f-MCDailyExtract.$rpt_run_dt.txt \
        -- reports-clearing@jetpay.com;

done

#### No Archive logic for Extract File, yet
# once 132 & 133 are turned on, add them here
for i in 130 132 133;
    do echo send b2payments file to peoples
    cp $workdir/$i*.zip ./INST_129/UPLOAD/ ;
    cd ./INST_129/UPLOAD/
    upload.exp $i*$rpt_run_dt*zip
    cd ../..
done

for i in 122 ;
    do echo send das file to esquire
    cp $workdir/$i*.zip ./INST_121/UPLOAD/ ;
    cd ./INST_121/UPLOAD/
    upload.exp $i*$rpt_run_dt*zip
    cd ../..
done

for i in 101 107 127 129 130 134 ;
    do echo $workdir/$i*.zip ;
    echo mv $workdir/$i*.zip ./INST_$i/ARCHIVE/ ;
    mv $workdir/$i*.zip ./INST_$i/ARCHIVE/ ;
done

#### no Upload logic for Extract File, yet
for i in 117 121 122;
    do echo $workdir/$i*.zip ;
    echo mv $workdir/$i*.zip ./INST_$i/UPLOAD/ ;
    mv $workdir/$i*.zip ./INST_$i/UPLOAD/ ;
    echo cd ./INST_$i/UPLOAD/
    cd ./INST_$i/UPLOAD/
    echo upload.exp  $i*$rpt_run_dt*zip \>\> ftp.log
    upload.exp  $i*$rpt_run_dt*zip \>\> ftp.log
    echo cd ../..
    cd ../..
done

echo zip -m -r $workdir.zip $workdir
zip -m -r $workdir.zip $workdir

echo mv $workdir.zip ARCHIVE/
mv $workdir.zip ARCHIVE/
