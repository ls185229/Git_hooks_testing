#!/usr/bin/bash
#
# ###############################################################################
# $Id: recv_ach_return.sh 4757 2018-10-20 12:36:10Z bjones $
# $Rev: 4757 $
# ###############################################################################
#
#  File Name:  recv_ach_return.sh YYYYMMDD
#
#  Description:  This script retrieves the ach acknowlegement files (ACK), the
#                ach reports (RPT) and ach return files (RTN). Then the return
#                files are transformed into csv format.
#
#  Script Arguments: date is optional defaults to today
#
#                    planned arguments (not yet implemented)
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages. (optional)
#                    -v = debug level. (optional)
#                    -t = test run option. (optional)
#
#  Output:  Files are emailed to configured parties.
#
#  Return:   0 = Success
#           !0 = Exit with errors
#
# ###############################################################################

echo
echo `date +"%Y/%m/%d %H:%M:%S"`
. $HOME/.profile

libpathadd /clearing/filemgr/scripts/lib

recv_ach_return.exp $1

datetime=`date +%Y%m%d_%H%M%S`

for f in JTPYTXACK.*; do
    if [ -f $f ] ; then
        echo $f;
        cat $f | \
            mutt -a $f -s "BMO ach acknowledgement - $f" \
            -- reports-clearing@jetpay.com ;
        mv $f ARCHIVE/$f;
    fi
done

for f in JTPYTXRPT.*; do
    if [ -f $f ] ; then
        echo $f;
        cat $f | uniq | \
            mutt -a $f -s "BMO ach return report - $f" \
            -- reports-clearing@jetpay.com ;
        mv $f ARCHIVE/$f;
    fi
done

for f in JTPYTXRTN.*; do
    if [ -f $f ] ; then
        echo
        if [[ $(./nacha_parser_quick.py $f) ]]; then
            mv $f ARCHIVE
        fi
    fi
done

for f in JTPYTXRTN*csv; do
    if [ -f $f ] ; then
        echo $f;
        echo Please see attached file. | \
            mutt -a $f -s "BMO ach returns - $f" \
            -- collections@jetpay.com reports-clearing@jetpay.com Thomas.marsan@ncr.com;
        mv $f ARCHIVE/$f;
    fi
done
