#!/usr/bin/bash
. /clearing/filemgr/.profile

###################################################################################################
# $Id: compress_and_email_list_of_old_files.sh                                                    #
###################################################################################################
#                                                                                                 #
#    File Name    - compress_and_email_list_of_old_files.sh                                       #
#    Written By   - Avery Clariday                                                                #
#                                                                                                 #
#    Description  - This is a monthly run script that identifies all IsoBilling.csv files in the  #
#                   ISO_BILLING/ARCHIVE directory that are at least a year old, zips and logs     #
#                   them, and emails the LOG file to notify someone that there are old files in   #
#                   the ISO_BILLING/ARCHIVE directory.                                            #
#    Arguments   -u [OPTIONAL] Prints the script's usage and exits the script.                    #
#                -t [EMAIL_ADDR] [OPTIONAL] Runs the script in test mode. The user must provide   #
#                   an email address with -t.                                                     #
#                                                                                                 #
###################################################################################################

CRON_JOB=1
export CRON_JOB

#######################################
## Prnt_Usage                        ##
#######################################
Print_Usage()
{
    echo "Begin Print Usage"
    echo "Usage for compress_and_email_list_of_old_files.sh" >/dev/tty
    echo "bash compress_and_email_list_of_old_files.sh -u[OPTIONAL] -t[OPTIONAL]" >/dev/tty
    echo "  -u = Prints the usage." >/dev/tty
    echo "  -t = Runs the script in test mode." >/dev/tty
    echo "End Print Usage"
}

#######################################
## Send_Email                        ##
#######################################
# Sends an email to the Clearing group with the LOG file listing the old files attached to it.
Send_Email()
{
    echo "Begin Send Email"

    email_body=old_iso_billing_email_body.txt

    # If not run in test mode, set email_to.
    if [ -z $test_mode ];
    then
        email_to=$( echo "Clearing.JetPayTX@ncr.com" )
    fi

    echo "  Email To: $email_to"

    echo "The following files listed in the LOG file attached to this email" > $email_body
    echo "are at least one year old and may be ready for removal." >> $email_body
    echo "These files can be located in the ISO_BILLING ARCHIVE directory." >> $email_body
    echo "The CSV files can be found inside of the following zip file in " >> $email_body
    echo "the ISO_BILLING ARCHIVE directory: $zip_file" >> $email_body

    echo "  Email Body: $email_body"

    if [ ! -z $test_mode ];
    then
        echo "Test Email Called" >/dev/tty
        echo "" | mutt -s "[TESTING - IGNORE] Old ISO Billing CSV Files in ARCHIVE directory on $current_date" $email_to -i $email_body -a $email_log_file
    else
        echo "Production Email Called" >/dev/tty
        echo "" | mutt -s "Old ISO Billing CSV Files in ARCHIVE directory on $current_date" $email_to -i $email_body -a $email_log_file
    fi
    echo "End Send Email"
}

#######################################
## Generate_Log_And_Zip_For_Email   ##
#######################################
# Generates the LOG file that is sent out with the email as an attachment.
# The LOG file contains all IsoBilling.csv files in the ARCHIVE that are at least 1 year old.
Generate_Log_And_Zip_For_Email()
{
    echo "Begin Generate Log And Zip For Email"

    # The LOG file attached to the email sent out at the end of this script.
    email_log_file=$(echo "$local_path/LOG/old_iso_billing_files.log")

    # Echo for debugging.
    echo "  Email Log File: $email_log_file"

    # The ZIP file the old files are archived in, located in the ARCHIVE directory.
    zip_file=$(echo "old_iso_billing_csv_files_$current_year$current_month.zip")

    # Echo for debugging.
    echo "  Zip File: $zip_file"

    # The number of old files found in the ARCHIVE directory.
    old_file_count=0

    # Initializing the LOG file.
    echo "****************************************************" > $email_log_file
    echo "Old CSV files found on $current_date" >> $email_log_file
    echo "****************************************************" >> $email_log_file

    # Check if the file is at least one year old. If it is, add it to the LOG file.
    # Then, check if the file matches the Iso_Billing*.csv regex. If it does, add it
    # to the ZIP file.
    for file_name in $file_list; do

        # If the file is actually a directory, then move on.
        if [[ $file_name != *.* ]];
        then
            continue
        fi

        # The time the file's status was last changed.
        file_time=$(stat -c %z $archive_dir/$file_name)

        # The year and month the file's status was last changed.
        file_year=$(echo "$file_time" | cut -c1-4)
        file_month=$(echo "$file_time" | cut -c6-7)

        year_difference=$(( $current_year - $file_year ))
        month_difference=$(( $current_month - $file_month ))

        # Check if the difference between the file's year and the current year is at least 1.
        if (( $year_difference > 0 ));
        then

            # Check if the difference between the file's year and the current year is at least 1
            # or if the difference between the file's month and the current month is at least 0.
            if (( $year_difference > 1 )) || (( $month_difference > -1 ))
            then

                echo "$file_name $file_time" >> $email_log_file
                old_file_count=$(( $old_file_count + 1 ))

                if [[ $file_name =~ $regex ]];
                then

                    # Test mode doesn't remove files from the directory when added to the ZIP file.
                    if [ ! -z $test_mode ];
                    then
                        if (( $old_file_count == 0 ));
                        then
                            zip $zip_file $archive_dir/$file_name >/dev/tty
                        else
                            zip -u $zip_file $archive_dir/$file_name >/dev/tty
                        fi
                    else
                        if (( $old_file_count == 0 ));
                        then
                            zip -m $zip_file $archive_dir/$file_name >/dev/tty
                        else
                            zip -um $zip_file $archive_dir/$file_name >/dev/tty
                        fi
                    fi
                fi
            fi
        fi
    done
    echo "  Old File Count: $old_file_count"

    # If no old files were found, then we don't need to run the rest of the script.
    if (( $old_file_count == 0 ));
    then
        echo "No old files found. Email, log file, and zip file not needed."
        echo "End Generate Log And Zip For Email"
        echo "Compress And Email Old Files Finished running on $current_date"
        echo "-----------------------------------------------------------------------------------"
        exit 0
    fi
    mv $zip_file $archive_dir
    echo "End Generate Log And Zip For Email"
}

#######################################
## Init                              ##
#######################################
#Initializes variables based on the command line arguments passed.
Init()
{
    echo "Begin Init"
    # Get the command line arguments passed to the file.
    while getopts "t:u" arg; do
        case $arg in
            u)
                usage="1"
                ;;
            t)
                test_mode="1"
                email_to=$OPTARG
                ;;
        esac
    done

    # If the script is run in test mode, increment the current year by 1.
    if [ ! -z $test_mode ];
    then
        echo "  SCRIPT RUN IN TEST MODE, CURRENT YEAR INCREMENTED BY 1"
        current_year=$(( $current_year + 1 ))
    fi

    # If the usage is set, call Print_Usage and exit with 0.
    if [ ! -z $usage ];
    then
        Print_Usage
        echo "End Init"
        echo "Compress And Email Old Files Finished running on $current_date"
        echo "-----------------------------------------------------------------------------------"
        exit 0
    fi
    echo "End Init"
}

#######################################
## Main                              ##
#######################################
# Main script function.
Main()
{

    # Get the current day, month, and year.
    current_date=$(date "+%d-%m-%Y at %H:%M:%S")
    current_day=$(echo "$current_date" | cut -c1-2)
    current_month=$(echo "$current_date" | cut -c4-5)
    current_year=$(echo "$current_date" | cut -c7-10)

    echo "-----------------------------------------------------------------------------------"
    echo "Compress And Email Old Files Script started running on $current_date"

    # The Current Working Directory.
    local_path=$PWD

    # The path to the ARCHIVE directory.
    archive_dir=$local_path/ARCHIVE

    # Regular expression used to check the csv files in the ARCHIVE directory.
    regex='^(NEW_)?IsoBilling.[0-9][0-9][0-9][0-9][0-1][0-9].[a-zA-Z0-9]*.[a-zA-Z0-9]*.csv(-orig.csv)?$'

    # The list of files in the ARCHIVE directory.
    file_list=$(ls $archive_dir)

    # Address email is sent to.
    email_to=""
    
    # Initialize the script based on the command line arguments.
    Init $@
    echo "  Current Year: $current_year"

    # Generate the log file based on the contents of the ARCHIVE directory.
    Generate_Log_And_Zip_For_Email

    # Send an email with the list of old files in the ARCHIVE directory.
    Send_Email

    current_date=$(date "+%d-%m-%Y at %H:%M:%S")
    echo "Compress And Email Old Files Finished running on $current_date"
    echo "-----------------------------------------------------------------------------------"
}

Main $@
