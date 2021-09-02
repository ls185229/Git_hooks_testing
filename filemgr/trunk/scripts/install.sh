#!/usr/bin/env bash

#
#   mas_install.sh -f file_list -d diff_log -p local_path
#
#       file_list is a file with the desired location of files to be installed
#       diff_log is the output of the diff from each file to installed and
#           the current production file to be changed
#       the local_path is where to look for the new files
#
#   This script assumes that a tar file has been extracted to a local directory
#   The file list allows the script to only install some files from that extract.
#
#   a sample:
#       mas_install.sh                                  \
#           -f /clearing/filemgr/file1                  \
#           -l /clearing/filemgr/diff_mas_install.log   \
#           -p /export/home/skumar/install/filemgr/trunk
#

. /clearing/filemgr/.profile > /dev/null
echo

function log_message {
    echo `date '+%Y/%m/%d %H:%M:%S'` $@
}

function usage {
    echo "Usage: $0 -f filelist -p install_from_path -l diff_logfile"

    echo "  -f filelist     list of files to install                "
    echo "  -l diff_logfile file to contain diffs of files installed"
    echo "  -p install_from path of files to install                "
    echo "  -r rollbackfile file to contain backup files            "
    echo "  -t              test mode on                            "
    echo "  -v              verbosity more increases level          "
    echo "  -h              display help                            "

    exit 1
}

locpth=`pwd`
cd $locpth

test_mode="false"
verbosity=$((0))

while getopts "f:l:p:r:tvh" arg; do
    case ${arg} in
        f)
            file_list=$OPTARG
            ;;
        l)
            diff_log=$OPTARG
            ;;
        p)
            local_path=$OPTARG
            ;;
        r)
            roll_back=$OPTARG
            ;;
        t)
            test_mode="true"
            ;;
        v)
            verbosity=$(($verbosity+1))
            ;;
        h | *)
            usage
            ;;
    esac
done

if [[ "$diff_log" == "" ]]; then
    diff_log=LOG/$0_diff.log
fi

log_message "Installation started"
log_message "$0 $@"

if [[ -f $file_list && -s $file_list ]]; then
    log_message "$file_list exists and is not empty "
else
    log_message "$file_list does not exist, or is empty "
    exit 1;
fi


for f in $(cat ${file_list}); do
    install_file_name="$local_path/$f"
    log_message "install_file_name: $install_file_name"
    prod_file_name="$HOME/$f"
    log_message "prod_file_name: $prod_file_name"
    dir_name="$(dirname "$prod_file_name")"
    dir_name="$dir_name"
    bkup_dir_name="$dir_name/OLD_VERSIONS"

    if [[ ! -d $dir_name ]]; then
        log_message "Prodution directory does not exist, creating"
        log_message "mkdir $dir_name"
    fi
    if [[ -f "$prod_file_name" ]]; then
        log_message
        log_message "diff $install_file_name $prod_file_name >> $diff_log"
        file_time=`gdate +-%Y%m%d_%H%M%S -d "$(stat -c %x $prod_file_name)"`
        file_time=`ls -l --time-style=+%Y%m%d_%H%M%S $prod_file_name | awk '{print $6}'`
        log_message "file_time: $file_time"
        if [[ ! -d $bkup_dir_name ]]; then
            log_message "Backup directory does not exist, creating"
            log_message "mkdir $bkup_dir_name"
        fi
        file_name="$(basename "$prod_file_name")"
        ft=`ls -tog --time-style=+%Y%m%d_%H%M%S $prod_file_name `
        log_message "file time tog: $ft"
        mv_filename="$dir_name/OLD_VERSIONS/$file_name-$file_time"
        log_message "mv_filename: $mv_filename"
    fi
    log_message cp -f $prod_file_name $mv_filename
    log_message cp $install_file_name $prod_file_name
    if [ "$test_mode" != "true" ] ;then
        if [[ -f "$prod_file_name" ]]; then
            log_message diff $install_file_name $prod_file_name >> $diff_log
            diff $install_file_name $prod_file_name >> $diff_log
            ret=$?
            if [ $ret -gt 1 ]; then
                log_message "diff between $install_file_name and $prod_file_name failed"
                exit 1;
            fi
            cp -f $prod_file_name $mv_filename
            ret=$?
            if [ $ret -ne 0 ]; then
                log_message "Copy of $prod_file_name to OLD_VERSIONS directory failed"
                exit 1;
            fi
        fi

        if [[ ! -d $dir_name ]]; then
            mkdir $dir_name
        fi
        if [[ ! -d $bkup_dir_name ]]; then
            mkdir $bkup_dir_name
        fi

        cp $install_file_name $prod_file_name
        ret=$?
        if [ $ret -ne 0 ]; then
            log_message "Copy of the $install_filename to $prod_file_name failed"
            exit 1;
        fi
    fi
    prod_file_name=""
    install_file_name=""
done

log_message "Installation completed"
echo
