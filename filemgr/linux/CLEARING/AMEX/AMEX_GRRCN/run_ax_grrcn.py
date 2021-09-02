#!/usr/bin/env python3

"""
File Name:  run_ax_grrcn.py

Description: This script is used to parse the GRRCN file from Amex and send out summary reports for each institution.
             GRRCN file is the new format that is going to replace AX TILR file format starting Oct-2021.

Arguments:  -d DATE(optional)
            -i INST_ID(optional)

Output:     Creates .csv reports for each institution configured and sends out emails to the necessary recepients

Log:        Log file is created with various events logged

Return:   0 = Success
          !0 = Exit with errors
"""

import argparse
from random import choices

import cx_Oracle
import configparser
import csv
import datetime
import glob
import os
import pathlib
import shutil
import subprocess
import sys
import tarfile
import time
import traceback

from GRRCN_Record_Types import SubmissionRecord
from GRRCN_Record_Types import ChargebackRecord
from GRRCN_Record_Types import TransactionRecord
from GRRCN_Record_Types import FeesAndRevenueRecord

lib_path = os.getenv('MASCLRLIB_PATH')
sys.path.append(lib_path)
from database_class import DbClass
from enhanced_email_class import EnhancedEmailClass

now = datetime.datetime.today().strftime("%Y%m%d%H%M%S")

log_file_name = "LOG/run_ax_grrcn-" + now + ".log"
log_file = open(log_file_name, "a+")

log_file.write("\n\n#################################################################################\n")
log_file.write("\nPreparing to parse the GRRCN file from AMEX.")
log_file.write("\nScript Name:" + sys.argv[0])
log_file.write("\nDate: " + datetime.datetime.today().strftime("%b-%d-%Y"))
log_file.write("\nTime: " + datetime.datetime.today().strftime("%X"))
log_file.write("\n")

config = configparser.ConfigParser()
config.read('run_ax_grrcn.cfg')
email_config_file = lib_path + "/" + config['EMAIL']['EMAIL_CONFIG']

dbObject = None
inst_id = None
file_date = ""
report_date = ""
submissions_list = []
chargebacks_list = []
rejects_list = []
other_fees_list = []


def usage(script_name):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        usage():
            prints the usage format of the script.

        Parameter:
            script_name      - Name of the current script - argv[0]

        Returns:
            Returns nothing.
            Exits the program after printing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    print("Example Usage: " + script_name + " -d <DATE> -i <INST_ID>\n")
    print("\t\t -d\t Optional Date. Defaults to current date. Format is 'YYYYMMDD'")
    print("\t\t -i\t Optional Institution ID.")
    print("Exiting!!!\n\n")
    exit(1)


def sendAlertEmail(msg):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        sendAlertEmail():
            Sends email when there is a failure in the script.

        Parameter:
            msg - Text that goes out in the body of the email

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    email_config_section = config['EMAIL']['ALERT_SECTION']
    log_path = os.path.abspath(log_file_name)

    email_body_text = sys.argv[0] + " script failed. \n\n"
    email_body_text += msg + "\n\n"
    email_body_text += "Look at the log file for more information - " + log_path

    print("#############\n" + email_body_text + "\n#############")
    emailObj = EnhancedEmailClass(READ_FROM_CONFIG_FILE=email_config_file,
                                  CONFIG_SECTION_NAME=email_config_section,
                                  EMAIL_BODY=email_body_text)
    emailObj.SendEmail()


def sendSuccessEmail():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        sendSuccessEmail():
            Sends email after successful completion of the script.

        Parameter:
            msg - Text that goes out in the body of the email

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    email_config_section = config['EMAIL']['SUCCESS_SECTION']
    email_body_text = sys.argv[0] + " script completed successfully."

    print("#############\n" + email_body_text + "\n#############")

    emailObj = EnhancedEmailClass(READ_FROM_CONFIG_FILE=email_config_file,
                                  CONFIG_SECTION_NAME=email_config_section,
                                  EMAIL_BODY=email_body_text)
    emailObj.SendEmail()


def sendReportEmail(attachment_list, path):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        sendReportEmail():
            Sends email after successful completion of the script.

        Parameter:
            attachment_list - List of files that has to be attached.
                              In case of this script, there will always be
                              only a single file in this list
            path            - Path of the attachement files

        Returns:
            True if email is sent out successfully.
            False if sending email failed
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    email_config_section = config['EMAIL']['REPORT_SECTION']

    email_subject = attachment_list[0]
    email_body_text = ""

    emailObj = EnhancedEmailClass(READ_FROM_CONFIG_FILE=email_config_file,
                                  CONFIG_SECTION_NAME=email_config_section,
                                  EMAIL_SUBJECT=email_subject,
                                  EMAIL_BODY=email_body_text)

    emailObj.AttachFiles(ATTACH_FILES_LIST=attachment_list, ATTACH_FILES_FOLDER=path)
    email_status = emailObj.SendEmail()

    return email_status


def clearOldLogs():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        clearOldLogs():
            Purge old log files older the number of days specified in the config file

        Parameters:
            N/A

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    try:
        no_of_days = int(config['GENERIC']['NO_OF_DAYS_TO_PURGE'])
        log_path = os.getcwd() + "/LOG"
        fileset = [file for file in glob.glob(log_path + "**/*.log", recursive=True)]
        purge_cutoff = time.time() - (no_of_days * 24 * 60 * 60)

        log_file.write("\n\nPurged the following log files older than " + str(no_of_days) + " days")
        for file in fileset:
            file_m_time = os.stat(file).st_mtime

            if file_m_time < purge_cutoff:
                os.remove(file)
                log_file.write(file)
        log_file.write("")

    except OSError:
        failMsg = "Exception occured when purging old logs"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def initDB():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        initDB():
            Initialize database connection.
            As of now this function is not being used. It is defined here for
            future use if required.

        Parameter:
            <TBD> - Database params from config file/env vars

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    global dbObject
    try:
        # dbObject = DbClass(HOSTNM='authqa.jetpay.com', PORTNO='1521', USERID='masclr', PASSWD='masclr', SERVNM='authqa.jetpay.com')
        dbObject = DbClass(ENV_HOSTNM='IST_HOST', ENV_USERID='IST_DB_USERNAME', PORTNO='1521',
                           ENV_PASSWD='IST_DB_PASSWORD', ENV_SERVNM='IST_SERVERNAME')
        ''' Leaving the above hardcoded line to use when developing/testing the code from local machine'''

        dbObject.Connect()
        log_file.write("Connected to database successfully!!")

    except Exception:
        failMsg = "Exception occured when connecting to database"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def documentFailure(msg, e):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        documentFailure():
            Parses the Error message and writes it to the log file.

        Parameter:
            msg - String containing a short description of the error
            e   - Exception Info Object - sys.exc_info()

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    # global log_file
    exc_msg = msg
    exc_type, exc_value = e[:2]
    exc_msg = exc_msg + "\nError Type: \t" + str(exc_type)
    exc_msg = exc_msg + "\nError Value: \t" + str(exc_value)
    log_file.write("\n\nERROR OCCURED:\n##### ########" + exc_msg)
    log_file.write("\n\n" + traceback.format_exc() + "\n\n")


def cleanUpAndExit(exit_code, msg=""):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        cleanUpAndExit():
            Cleans up the resources like open file handles, database connections, etc.

        Parameter:
            exit_code           - used to identify success or error when exiting the program
                                    = 0 for successful completion
                                    = 1 if called by program logic
                                    = 2 if called after exception is caught

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    ''' Closing DB connections '''
    if isinstance(dbObject, DbClass):
        dbObject.Rollback()
        for i in range(len(dbObject.dbCursor)):
            dbObject.CloseCursor(i)
        dbObject.Disconnect()

    ''' Removing input file '''
    file_name = config['GENERIC']['INPUT_FILE_NAME'] + file_date
    fileset = [file for file in glob.glob(file_name, recursive=True)]
    for file in fileset:
        if os.path.exists(file):
            log_file.write("Removing input file '" + file + "' from the current directory.")
            os.remove(file)

    ''' Archiving the CSV files '''
    report_file = '*' + config['GENERIC']['REPORT_FILE_NAME'].replace("yyyymmdd", report_date)
    fileset = [file for file in glob.glob(report_file, recursive=True)]
    if len(fileset) > 0:
        archive_file_name = config['GENERIC']['ARCHIVE_FILE_NAME'].replace("yyyymmdd", report_date)
        log_file.write("\n\nArchiving the CSV report files")
        log_file.write("\nArchive File: " + os.path.abspath(archive_file_name))
        with tarfile.open(archive_file_name, "w:gz") as tar:
            for file in fileset:
                if os.path.exists(file):
                    log_file.write("\n\tAdding: " + file)
                    tar.add(file, arcname=os.path.basename(file))
                    os.remove(file)

    ''' Sending email based on exit code '''
    if exit_code == 0:
        sendSuccessEmail()
        log_file.write("\n\n\nSuccessfully completed.\nExiting the program " + sys.argv[0] + " with exit code '" + str(
            exit_code) + "'\n")
    elif exit_code == 1 or exit_code == 2:
        email_msg = "Error occurred when processing AMEX GRRCN file.\n\n"
        email_msg = email_msg + msg
        sendAlertEmail(email_msg)
        log_file.write("\n" + email_msg + "\n")
        log_file.write(
            "\n Terminating the program " + sys.argv[0] + " with exit code '" + str(exit_code) + "'\n")

    ''' Closing log file handles '''
    log_file.write(
        "#####################################################################################################")
    log_file.flush()
    log_file.close()

    exit(exit_code)


def parseArguments():
    """
    Name : parseArguments
    Arguments: none
    Description : Parses the command line arguments
    Returns: arg_parser args
    """
    cur_date = datetime.datetime.today().strftime("%Y%m%d")
    try:
        arg_parser = argparse.ArgumentParser(description='AX GRRCN File Processor')
        arg_parser.add_argument('-i', '-I', '--instid', type=str, dest='inst_id', help='Institution ID')
        arg_parser.add_argument('-d', '-D', '--date', type=str, dest='date', default=cur_date,
                                help='Date for which the GRRCN file has to be parsed. Defaults to current date when no value is given')
        args = arg_parser.parse_args()
    except argparse.ArgumentError as err:
        err_msg = 'Error: During parsing command line arguments {}'
        log_file.write(err_msg.format(err))
        usage(sys.argv[0])
    else:
        return args


def getFileFromMAS(date):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        getFileFromMAS():
            Connects to MAS server and downloads the files from the configured source directory
            and places them in the configured destination directory.

        Parameter:
            date - The date for which the GRRCN files have to be downloaded from MAS system

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    user_name = os.environ.get("FMGR_USERNAME")
    host_name = os.environ.get("MAS_HOST_NAME")
    src_path = config['FILE_TRANSFER']['SRC_PATH']
    destination = config['FILE_TRANSFER']['DEST_PATH']
    src_file_name = config['FILE_TRANSFER']['SRC_FILE_NAME'] + date

    scp_command = 'scp {0}@{1}:{2}{3} {4}'.format(user_name, host_name, src_path, src_file_name, destination)
    log_file.write('\n\nConnecting to {0}: \n{1}'.format(host_name, scp_command))

    transfer_result = subprocess.Popen(scp_command, shell=True, stdout=log_file, stderr=log_file).wait()
    log_file.write("\nTransfer Result: " + str(transfer_result))

    if transfer_result != 0:
        cleanUpAndExit(1, "\nError when downloading the file from " + host_name)


def copyFileToCurDir(date):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        copyFileToCurDir():
            Copies the input file for the specified date from the GRRCN download directory to the current directory.

        Parameter:
            date - The date for which the GRRCN file has to be copied -yyyymmdd

        Returns:
            Returns input file name.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    file_path = config['GENERIC']['INPUT_FILE_PATH']
    file_name = config['GENERIC']['INPUT_FILE_NAME'] + date
    fileset = [file for file in glob.glob(file_path + file_name, recursive=True)]

    '''
    Usually there will be one file per day. If more than one file is present for the given date, 
    the latest one is selected and used.    
    '''
    if len(fileset) > 0:
        latest_m_time = 0
        latest_file_size = 0
        for file in fileset:
            file_m_time = os.stat(file).st_mtime

            if file_m_time > latest_m_time:
                latest_m_time = file_m_time
                latest_file_size = os.stat(file).st_size
                file_name = os.path.basename(file)

        log_file.write("\n\nData_File_Size: - before copy:" + str(latest_file_size))

        try:
            shutil.copy(file_path + file_name, file_name)
        except OSError as err:
            failMsg = "Exception occured when copying input file"
            exc = sys.exc_info()
            documentFailure(failMsg, exc)
            cleanUpAndExit(2, msg=failMsg)

        time.sleep(5)
        copied_file_size = os.stat(file_name).st_size
        log_file.write("\nData_File_Size: - after copy:" + str(copied_file_size))
        if latest_file_size != copied_file_size:
            cleanUpAndExit(1, "Issue when copying file. Files sizes don't match after copying.")

    else:
        cleanUpAndExit(1, "File unavailable for '" + date + "' \n'" + file_path + file_name + "' not found.")

    return file_name


class Report_Record:
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Class Name: Report_Record
            This class is capture individual records in the GRRCN report

        Class Variables:
            -

        Instance Variables:
            rec_type, trancastion_count, transaction_volume, discount_amount,
            service_fee_amount, net_amount, other_fees, total_net_settlement

        Methods:
            toString() - Returns a String representation of the object
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    def __init__(self, rec_type):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: __init__
                Constructs the object and initializes instance variables to zero values .

            Parameters:
                rec_type

            Returns:
                An object of type Report_Record
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.rec_type = rec_type
        self.description = rec_type
        self.transaction_count = 0
        self.transaction_volume = 0.0
        self.discount_amount = 0.0
        self.service_fee_amount = 0.0
        self.net_amount = 0.0
        self.other_fees = 0.0
        self.total_net_settlement = 0.0

    def toString(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: toString
                Prints the object's instance variables in string format

            Parameters:
                -

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        print(self.rec_type, self.description, self.transaction_count, self.transaction_volume, self.discount_amount,
              self.service_fee_amount, self.net_amount, self.other_fees, self.total_net_settlement)

    @staticmethod
    def trim_parse_amount(amt):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: trim_parse_amount
                Takes in a signed, zero-prefixed amount 'string' trims the zeros
                and returns the actual signed amount value

            Parameters:
                amt - signed, zero prefixed amount string

            Returns:
                actual_amt - actual amount value of the amount string 'amt'
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        sign = amt[0]
        sign = '-' if sign == '-' else ''
        amt = amt[1:].lstrip('0')

        if amt != '':
            actual_amt = float(sign + amt)
            actual_amt /= 100
            return actual_amt
        else:
            return 0.0

    def round_amounts_to_two_digits(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: round_amounts_to_two_digits
                This function rounds the amount values to two digits.
                The following instance variables are rounded off.
                    - transaction_volume
                    - discount_amount
                    - service_fee_amount
                    - net_amount
                    - other_fees
                    - total_net_settlement


            Parameters:
                -

            Returns:
                nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.transaction_volume = round(self.transaction_volume, 2)
        self.discount_amount = round(self.discount_amount, 2)
        self.service_fee_amount = round(self.service_fee_amount, 2)
        self.net_amount = round(self.net_amount, 2)
        self.other_fees = round(self.other_fees, 2)
        self.total_net_settlement = round(self.total_net_settlement, 2)

    def make_writeable(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: make_writeable
                This function type casts all instance variables to string.
                This function helps to maintain clean code when writing to the output reports.
                The following instance variables are converted to string type.
                    - transaction_count
                    - transaction_volume
                    - discount_amount
                    - service_fee_amount
                    - net_amount
                    - other_fees
                    - total_net_settlement


            Parameters:
                -

            Returns:
                self
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.transaction_count = str(self.transaction_count)
        self.transaction_volume = str(self.transaction_volume)
        self.discount_amount = str(self.discount_amount)
        self.service_fee_amount = str(self.service_fee_amount)
        self.net_amount = str(self.net_amount)
        self.other_fees = str(self.other_fees)
        self.total_net_settlement = str(self.total_net_settlement)

        return self

    def addSubmissionRec(self, rec):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: addSubmissionRec
                Takes in a SubmissionRecord object and adds the counts and amounts to this object

            Parameters:
                rec - Record_Types.SubmissionRecord object

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.transaction_count += int(rec.transaction_count.lstrip('0'))
        self.transaction_volume += self.trim_parse_amount(rec.submission_gross_amount_in_submission_currency)
        self.discount_amount += self.trim_parse_amount(rec.submission_discount_amount)
        self.service_fee_amount += self.trim_parse_amount(rec.submission_service_fee_amount)
        self.net_amount += self.trim_parse_amount(rec.submission_net_amount)

        self.round_amounts_to_two_digits()
        # self.toString()

    def addChargebackRec(self, rec):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: addChargebackRec
                Takes in a ChargebackRecord object and adds the counts and amounts to this object

            Parameters:
                rec - Record_Types.ChargebackRecord object

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        self.transaction_count += 1
        self.transaction_volume += self.trim_parse_amount(rec.gross_amount)
        self.discount_amount += self.trim_parse_amount(rec.discount_amount)
        self.service_fee_amount += self.trim_parse_amount(rec.service_fee_amount)
        self.net_amount += self.trim_parse_amount(rec.net_amount)

        self.round_amounts_to_two_digits()
        # self.toString()

    def addRejectRec(self, rec):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: addRejectRec
                Takes in a TransactionRecord object and adds the counts and amounts to this object

            Parameters:
                rec - Record_Types.TransactionRecord object

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.transaction_count += 1
        self.transaction_volume += self.trim_parse_amount(rec.transaction_amount)
        self.net_amount += self.trim_parse_amount(rec.transaction_amount)

        self.round_amounts_to_two_digits()
        # self.toString()

    def addFeeRevenueRec(self, rec):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: addFeeRevenueRec
                Takes in a FeesAndRevenueRecord object and adds the counts and amounts to this object

            Parameters:
                rec - Record_Types.FeesAndRevenueRecord object

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.description = rec.fee_or_revenue_description
        self.transaction_count += 1
        self.transaction_volume += self.trim_parse_amount(rec.fee_or_revenue_amount)
        self.net_amount += self.trim_parse_amount(rec.fee_or_revenue_amount)

        self.round_amounts_to_two_digits()
        # self.toString()


def main():
    """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            main():
                This function holds all the program logic.
                Reads the raw GRRCN line by line parses the data to differnt record types based on the first field of the record.
                Generates csv files for different institutions configured
                Emails the reports to necessary recepients.

            Parameter:
                N/A

            Returns:
                Returns nothing.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
    global inst_id, file_date, report_date

    args = parseArguments()
    file_date = args.date
    inst_id = args.inst_id
    log_file.write("\nFile Date: " + str(file_date))
    log_file.write("\nInst ID: " + str(inst_id))

    try:
        check_date_validity = datetime.datetime.strptime(file_date, '%Y%m%d')
    except ValueError:
        print("'" + file_date + "' - Incorrect date format, should be YYYYMMDD")
        log_file.write("'" + file_date + "' - Incorrect date format, should be YYYYMMDD")
        usage(sys.argv[0])

    clearOldLogs()
    # initDB()

    bin_inst_map = {}
    card_sales_report_dict = {}
    chargebacks_report_dict = {}
    rejects_report_dict = {}
    other_fees_report_dict = {}

    for ax_bin, inst in config.items("BIN_INST_MAP"):
        bin_inst_map[ax_bin] = inst
        card_sales_report_dict[ax_bin] = Report_Record("CARD_SALES")
        chargebacks_report_dict[ax_bin] = Report_Record("CHARGEBACKS")
        rejects_report_dict[ax_bin] = Report_Record("REJECTS")
        other_fees_report_dict[ax_bin] = []

    getFileFromMAS(file_date)
    data_file_name = copyFileToCurDir(file_date)
    log_file.write("\nData_File_name: " + data_file_name)
    log_file.write("\n")

    # data_file_name = "NCRPAYPRD.GRRCN#P63LHD42505C0N.20210813"
    # data_file_name = "NCRPAYPRD.GRRCN#P80LH240642G59.20210802"

    '''
    Parsing the input files here and storing them as individual 
    lists based on the record types
    '''
    with open(data_file_name, 'r') as data:
        for line in csv.reader(data):
            # print(line[0] + ":\t" + line)
            rec_type = line[0]
            if rec_type == "HEADER":
                report_date = line[1]
            elif rec_type == "SUBMISSION":
                new_sub_rec = SubmissionRecord(bin_inst_map[line[1]], line)
                submissions_list.append(new_sub_rec)
            elif rec_type == "CHARGEBACK":
                new_cb_rec = ChargebackRecord(bin_inst_map[line[1]], line)
                chargebacks_list.append(new_cb_rec)
            elif rec_type == "TRANSACTN":
                if line[32] == "REJ":
                    new_rej_rec = TransactionRecord(bin_inst_map[line[1]], line)
                    rejects_list.append(new_rej_rec)
            elif rec_type == "FEEREVENUE":
                new_other_fees_rec = FeesAndRevenueRecord(bin_inst_map[line[1]], line)
                other_fees_list.append(new_other_fees_rec)

    log_file.write("\nSubmission Record Count:" + str(len(submissions_list)))
    log_file.write("\nChargeback Record Count:" + str(len(chargebacks_list)))
    log_file.write("\nReject Record Count:" + str(len(rejects_list)))
    log_file.write("\nOther Fees Record Count:" + str(len(other_fees_list)))
    log_file.write(
        "\n\n--------------------------------------------------------------------------------------------------------")
    # cleanUpAndExit(0)

    '''
    Looping through each record list created in the previous section and
    creating records to be written to GRRCN report file
    '''
    for sub_rec in submissions_list:
        card_sales_report_dict[sub_rec.payee_merchant_id].addSubmissionRec(sub_rec)

    for cb_rec in chargebacks_list:
        chargebacks_report_dict[cb_rec.payee_merchant_id].addChargebackRec(cb_rec)

    for rej_rec in rejects_list:
        rejects_report_dict[rej_rec.payee_merchant_id].addRejectRec(rej_rec)

    for other_fees_rec in other_fees_list:
        other_fees_rec_obj = Report_Record("OTHER_FEES")
        other_fees_rec_obj.addFeeRevenueRec(other_fees_rec)
        other_fees_report_dict[other_fees_rec.payee_merchant_id].append(other_fees_rec_obj)

    '''
    Parsing through the report records created for each ACQ_ID(INST_ID) and 
    create a csv file and email it to the necessary recepients. 
    '''
    for ax_bin, inst in config.items("BIN_INST_MAP"):
        inst = str(inst)
        report_file_name = inst + config['GENERIC']['REPORT_FILE_NAME'].replace("yyyymmdd", report_date)
        report_file = open(report_file_name, "w")
        total_net_settlement = 0.0

        log_file.write("\n\nGenerating report for INST ID: " + inst)
        log_file.write("\nReport Name: " + report_file_name + "")
        log_file.write("\nAcquirer ID:" + ax_bin + "\n")
        report_file.write("AMEX NETWORK\n")
        report_file.write("ACQUIRER DAILY SUMMARY REPORT\n")
        report_file.write("\n")
        report_file.write("PROGRAM NAME:,AMEX_GRRCN\n")
        report_file.write("SYSTEM_DATE:," + now[:8] + "\n")
        report_file.write("PROCESSING_DATE:," + report_date + "\n")
        report_file.write("\n\n\n")
        report_file.write("ACQUIRER ID:," + ax_bin + "\n")
        report_file.write("ACQUIRER NAME:,INSTITUTION " + inst + "\n")
        report_file.write("\n\n")
        report_file.write(
            "DESCRIPTION,TRANSACTION COUNT,TRANSACTION VOLUME,DISCOUNT AMOUNT,SERVICE FEE AMOUNT,NET AMOUNT\n")

        report_rec = card_sales_report_dict[ax_bin]
        total_net_settlement += report_rec.net_amount
        report_rec = report_rec.make_writeable()
        report_file.write(
            report_rec.description + "," + report_rec.transaction_count + ",$" + report_rec.transaction_volume + ",$" + report_rec.discount_amount + ",$" + report_rec.service_fee_amount + ",$" + report_rec.net_amount + "\n")

        report_rec = chargebacks_report_dict[ax_bin]
        if report_rec.transaction_count > 0:
            total_net_settlement += report_rec.net_amount
            report_rec = report_rec.make_writeable()
            report_file.write(
                report_rec.description + "," + report_rec.transaction_count + ",$" + report_rec.transaction_volume + ",$" + report_rec.discount_amount + ",$" + report_rec.service_fee_amount + ",$" + report_rec.net_amount + "\n")

        report_rec = rejects_report_dict[ax_bin]
        if report_rec.transaction_count > 0:
            total_net_settlement += report_rec.net_amount
            report_rec = report_rec.make_writeable()
            report_file.write(
                report_rec.description + "," + report_rec.transaction_count + ",$" + report_rec.transaction_volume + ",$" + report_rec.discount_amount + ",$" + report_rec.service_fee_amount + ",$" + report_rec.net_amount + "\n")

        report_list = other_fees_report_dict[ax_bin]
        for report_rec in report_list:
            if report_rec.transaction_count > 0:
                total_net_settlement += report_rec.net_amount
                report_rec = report_rec.make_writeable()
                report_file.write(
                    report_rec.description + "," + report_rec.transaction_count + ",$" + report_rec.transaction_volume + ",$" + report_rec.discount_amount + ",$" + report_rec.service_fee_amount + ",$" + report_rec.net_amount + "\n")

        report_file.write("\n\n")
        report_file.write("TOTAL NET SETTLEMENT,,,,," + str(round(total_net_settlement, 2)))
        report_file.flush()
        report_file.close()

        log_file.write("\nReport successfully created\n")

        file_path = os.path.dirname(os.path.abspath(report_file_name))

        email_status = sendReportEmail([report_file_name], file_path)
        if email_status:
            log_file.write("\n" + report_file_name + " successfully emailed\n")
        else:
            log_file.write("\n\nSending email failed - " + report_file_name)
            cleanUpAndExit(1, "Failed to send email - " + report_file_name)
        log_file.write(
            "--------------------------------------------------------------------------------------------------------")

    cleanUpAndExit(0)


if __name__ == "__main__":
    main()
