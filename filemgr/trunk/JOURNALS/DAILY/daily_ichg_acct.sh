#!/usr/bin/bash
. /clearing/filemgr/.profile

echo ml2_reports: $ml2_reports ,my_ml2_reports: $my_ml2_reports
if [[ "$my_ml2_reports" ]] ; then
    ml2_reports=$my_ml2_reports
fi
echo ml2_reports: $ml2_reports ,my_ml2_reports: $my_ml2_reports

### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#
today=$(date +"%Y%m%d")

locpth=$PWD
logFile=$locpth/LOG/$programName.log

init() {
    run_date=`date +%Y%m%d`
    while getopts d:f: option
    do
        case $option in
            d) run_date="$OPTARG" ;;
            f) cfgFile="$OPTARG" ;;
            ?) usage
                tail -40 $logFile | mutt -s "$programName Report failed" "$mail_err"
                exit 1;;
        esac
    done
}


main() {
    init
    
    outfile="$programName"_"$run_date.csv"
    
    sqlplus -S $IST_DB_USERNAME/$IST_DB_PASSWORD@$IST_DB  @daily_ichg_acct.sql | grep -v "\-\-\-\-\-" | gsed 's/[\t\ ]*,[\t\ ]*/,/g' > $outfile
    
    echo See attached | mutt -s "$outfile" -a $outfile -- $ml2_reports   
}

main