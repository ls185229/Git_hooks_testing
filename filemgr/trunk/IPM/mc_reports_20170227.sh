#!/usr/bin/bash

cd ~/IPM/ ;

export rpt_run_dt=`date +%Y%m%d`
export rpt_dash_dt=`date +%Y-%m-%d`

export workdir=ORIG.IPM.TT140.$rpt_run_dt
mkdir $workdir

recv_file_frm_mfe.exp >> LOG/ipm.t140.rpt.log 2>&1

mv TT140T0.$rpt_dash_dt* $workdir/

cd $workdir/

ln -s ../multi_ipm_split.py multi_ipm_split.py
ln -s ../test_luhn.py test_luhn.py
ln -s ../sre_list_plain.txt sre_list_plain.txt

echo multi_ipm_split.py \>\> ../LOG/test_split_$rpt_run_dt.log
multi_ipm_split.py >> ../LOG/test_split_$rpt_run_dt.log

for f in 000 101 107 117 121 122 127 129 130 134 ;
    do echo $f;
    echo zip -m $f-MCDailyReports-$rpt_run_dt.zip $f*001 ;
    zip -m $f-MCDailyReports-$rpt_run_dt.zip $f*001 ;
done

cd ~/IPM/ ;

for f in 101 107 117 121 122 127 129 130 134 ;
    do echo $f;
    echo ls -l $workdir/$f*MCD*zip;
    ls -l $workdir/$f*MCD*zip;

    echo Attached are the MasterCard daily reports. \
        \| mutt -s "$f MC Daily Reports $rpt_dash_dt" \
        -a $workdir/$f*$rpt_run_dt.zip \
        -- reports-clearing@jetpay.com;
    echo Attached are the MasterCard daily reports. \
        | mutt -s "$f MC Daily Reports $rpt_dash_dt" \
        -a $workdir/$f*$rpt_run_dt.zip \
        -- reports-clearing@jetpay.com;

done

# once 132 & 133 are turned on, add them here
for i in 130 ;
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
