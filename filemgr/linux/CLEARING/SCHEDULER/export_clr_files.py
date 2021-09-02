#!/usr/bin/env python3

"""
File Name:  export_clr_files.py

Description: This script is used to schedule the clearing tasks for generating export files.
             TASKS table is updated for the given institution_id and file_type.

Arguments:  -i INST_ID
            -f FILE_TYPE

Output:     Does not create an output file. The database update is the final goal of the script.

Log:        Log file is created with various events logged along with the SQL qurey for the DB update.

Return:   0 = Success
          !0 = Exit with errors
"""

import argparse
from random import choices

import cx_Oracle
import configparser
import datetime
import glob
import os
import pathlib
import sys
import time
import traceback

lib_path = os.getenv('MASCLRLIB_PATH')
sys.path.append(lib_path)
from database_class import DbClass
from email_class import EmailClass

now = datetime.datetime.today().strftime("%Y%m%d%H%M%S")
clr_date_j = datetime.datetime.today().strftime("%y%j")

log_file_name = "LOG/export_clr_files-" + now + ".log"
log_file = open(log_file_name, "a+")

config = configparser.ConfigParser()
config.read('export_clr_files.cfg')

dbObject = None
inst_id = None
file_type_list = []
success_list = []


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
    print("Example Usage: " + script_name + " -i <INST_ID> -f <FILE_TYPE>\n")
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
    email_to = config['EMAIL_ALERT']['TO']
    email_from = config['EMAIL_ALERT']['FROM']
    email_subject = config['EMAIL_ALERT']['SUBJECT'] + " " + str(inst_id) + " " + datetime.datetime.today().strftime(
        "%Y-%m-%d %H:%M:%S")
    emailObj = EmailClass(TO_ADDRESS=(email_to),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=email_from,
                          EMAIL_SUBJECT=email_subject)
    emailObj.SendEmail()


def sendStatusEmail(msg):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        sendStatusEmail():
            Sends email after successful completion of the script.

        Parameter:
            msg - Text that goes out in the body of the email

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    email_to = config['EMAIL_STATUS']['TO']
    email_from = config['EMAIL_STATUS']['FROM']
    email_subject = config['EMAIL_STATUS']['SUBJECT'] + " " + str(inst_id) + " " + str(
        inst_id) + " " + datetime.datetime.today().strftime("%Y-%m-%d %H:%M:%S")
    emailObj = EmailClass(TO_ADDRESS=(email_to),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=email_from,
                          EMAIL_SUBJECT=email_subject)

    emailObj.SendEmail()


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
        no_of_days = int(config['DEFAULT']['NO_OF_DAYS_TO_PURGE'])
        log_path = os.getcwd() + "/LOG"
        fileset = [file for file in glob.glob(log_path + "**/*.log", recursive=True)]
        purge_cutoff = time.time() - (no_of_days * 24 * 60 * 60)

        log_file.write("Purged the following log files older than " + str(no_of_days) + " days")
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
            Initialize database connection

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


def cleanUpAndExit(exit_code, remove_stop_file=1, msg=""):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        cleanUpAndExit():
            Cleans up the resources like open file handles, database connections, etc.

        Parameter:
            exit_code           - used to identify success or error when exiting the program
                                    = 0 for successful completion
                                    = 1 if called by program logic
                                    = 2 if called after exception is caught
            remove_stop_file    - used to check if stop file has to be removed.
                                  If exiting because of existing stop file, we should not remove the stop file.

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """
    stop_file_name = str(inst_id) + "_" + config['DEFAULT']['STOP_FILE_NAME']
    stop_file = pathlib.Path(stop_file_name)

    if remove_stop_file:
        if stop_file.exists():
            stop_file.unlink()

    if isinstance(dbObject, DbClass):
        dbObject.Rollback()
        for i in range(len(dbObject.dbCursor)):
            dbObject.CloseCursor(i)
        dbObject.Disconnect()

    inst_msg = "INSTITUTION ID: " + str(inst_id) + "\n\n"
    if exit_code == 0:
        email_msg = " "
        if len(success_list) == 0:
            email_msg = email_msg + "No export tasks is currently available to schedule.\n\n"
        else:
            email_msg = email_msg + "Export tasks for have been successfully scheduled for the following file types.\n\n"
        email_msg = email_msg + inst_msg
        for file_type in success_list:
            email_msg = email_msg + "\t" + str(file_type) + " - " + config['FILE_TYPE'][file_type] + "\n"

        sendStatusEmail(email_msg)
        log_file.write("\n Successfully completed. Exiting the program " + sys.argv[0] + " with exit code '" + str(
            exit_code) + "'\n")
    elif exit_code == 1:
        email_msg = "Can't schedule the export task now.\n\n"
        email_msg = email_msg + inst_msg + msg
        sendAlertEmail(email_msg)
        log_file.write(
            "\n Can't schedule the export task now. Exiting the program " + sys.argv[0] + " with exit code '" + str(
                exit_code) + "'\n")
    elif exit_code == 2:
        email_msg = "Error occurred when scheduling export task.\n\n"
        email_msg = email_msg + inst_msg + msg
        sendAlertEmail(email_msg)
        log_file.write(
            "\n Error Occurred. Terminating the program " + sys.argv[0] + " with exit code '" + str(exit_code) + "'\n")

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
    try:
        arg_parser = argparse.ArgumentParser(description='Export Task Scheduler')
        arg_parser.add_argument('-i', '-I', '--instid', type=str, dest='inst_id', required=True,
                                help='Institution ID')
        """
        File Types: 
            00 - Default, used to schedule all tasks
            21 - MAS File
            41 - Visa File
            55 - Mastercard File
            83 - Discover File
        """
        arg_parser.add_argument('-f', '-F', '--filetype', type=str, dest='file_type', default='00',
                                choices=['55', '41', '21', '83'],
                                help='File Type for which export task should be scheduled. Defaults to "00" when no value is given')
        args = arg_parser.parse_args()
    except argparse.ArgumentError as err:
        err_msg = 'Error: During parsing command line arguments {}'
        log_file.write(err_msg.format(err))
        usage(sys.argv[0])
    else:
        return args


def checkForStopFile(inst):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        checkForStopFile():
            Checks for stop file at the beginning of the program. If found, the script does nothing and exits cleanly.
            If not found, it proceeds with the execution. Next steps are checking the CUTOFF_BATCH, IN_FILE_LOG and TASK_LOG
            tables in the given order and then schedule the task in TASKS table.
            Stop file will be in place during the execution of the program. It will be deleted 180 seconds after the task has been scheduled.
            This is to prevent another instance of the script from running during the delay between scheduling the task and the task starting.

            Logic for stop file mechanism is as follows.
                * Check for presence of stop file at the beginning of the program.
                * If found, do a clean exit.(It means another instance of the script is running and has not scheduled the jobs yet)
                * If not found, create one and proceed to other checks.
                                - checkCutOffBatch
                                - checkInFileLog
                                - checkTaskLog
                * If all the above checks are passed, proceed to schedule the task
                                - scheduleTask
                * Wait for 180 seconds and delete the stop file. This will give enough time for the scheduled task to actually start.
                                - removeStopFile

        Parameter:
            inst - Institution ID(This is a dummy argument as of now. Placeholder for future scalability)

        Returns:
             Retunrs 1 - If no stop file is found. Creates a new stop file before returning.
             "Exits" 0 - If a stop file is found
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    stop_file_name = str(inst) + "_" + config['DEFAULT']['STOP_FILE_NAME']
    stop_file = pathlib.Path(stop_file_name)
    log_file.write("StopFileName: " + stop_file_name)

    if stop_file.exists():
        log_file.write("Stop file found!! Another instance of the program is running.\nExiting.\n\n")
        cleanUpAndExit(1, remove_stop_file=0, msg="Stop file found!! Another instance of the program is running.")
    else:
        log_file.write("No stop file was found.\nCreating one and proceeding to other checks.\n")
        try:
            stop_file.touch()
        except Exception:
            failMsg = "Exception occured when creating stop file  - checkForStopFile"
            exc = sys.exc_info()
            documentFailure(failMsg, exc)
            cleanUpAndExit(2, msg=failMsg)
        return 1


def checkCutOffBatch(inst, file_type):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        checkCutOffBatch():
            Checks in CUTOFF_BATCH table for the given institution ID and file type if there are any records ready to be processed

        Parameter:
            inst   - Institution ID
            file_type - File Type used to schedule the appropriate task in the TASKS table.
                        file_type should be one of the following
                            21 - MAS File
                            41 - Visa File
                            55 - Mastercard File
                            83 - Discover File

        Returns:
             1 - If records that are ready to be processed are found
             0 - If records that are ready to be processed are not found
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    log_file.write("\n\n--Checking CUTOFF_BATCH--")
    try:
        cutoff_batch_cursor = dbObject.OpenCursor()
        cutoff_batch_sql = "SELECT SRC_INST_ID, DEST_FILE_TYPE, COUNT(*), SUM(CUTOFF_CNT), SUM(CUTOFF_AMT) FROM CUTOFF_BATCH " \
                           "WHERE SRC_INST_ID = '" + inst + "' AND DEST_FILE_TYPE = '" + file_type + "' " \
                           "AND CLR_DATE_J = " + clr_date_j + " AND CUTOFF_STATUS = 'R' " \
                                                                                                                                           "GROUP BY SRC_INST_ID, DEST_FILE_TYPE"
        # cutoff_batch_sql = "SELECT SRC_INST_ID, DEST_FILE_TYPE, COUNT(*), SUM(CUTOFF_CNT), SUM(CUTOFF_AMT) FROM CUTOFF_BATCH " \
        #                    "WHERE SRC_INST_ID = '" + inst + "' AND DEST_FILE_TYPE = '" + file_type + "' " \
        #                    "AND CUTOFF_STATUS = 'R' " \
        #                    "GROUP BY SRC_INST_ID, DEST_FILE_TYPE"
        log_file.write("\nCUTOFF_BATCH Query:" + cutoff_batch_sql + "\n")
        dbObject.ExecuteQuery(cutoff_batch_cursor, cutoff_batch_sql)
        resultset = dbObject.FetchResults(cutoff_batch_cursor)

        if len(resultset) == 0:
            log_file.write("No entries in CUTOFF_BATCH.")
            return 0
        else:
            for row in resultset:
                log_file.write("Result Row:\t" + str(row))
            return 1

    except Exception:
        failMsg = "Exception occured when performing database operation - checkCutOffBatch"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def checkInFileLog(inst):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        checkInFileLog():
            Checks in IN_FILE_LOG table if a TC57 file for the given institution is
            currently being imported.

        Parameter:
            inst - Institution ID

        Returns:
             0 - if a TC57 file is currently being imported
             1 - if no TC57 file is currently being imported
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    log_file.write("\n\n--Checking IN_FILE_LOG--")
    try:
        in_file_log_cursor = dbObject.OpenCursor()
        offsetHrs = int(config['DEFAULT']['DB_CHECK_OFFSET_HRS'])
        check_time = (datetime.datetime.today() - datetime.timedelta(hours=offsetHrs)).strftime("%Y%m%d%H%M%S")

        in_file_log_sql = "SELECT IN_FILE_NBR, EXTERNAL_FILE_NAME, INCOMING_DT, IN_FILE_STATUS FROM IN_FILE_LOG " \
                          "WHERE FILE_TYPE = '01' AND INSTITUTION_ID = '" + inst + "' AND IN_FILE_STATUS IS null " \
                          "AND INCOMING_DT > TO_DATE('" + check_time + "', 'YYYYMMDDHH24MISS')"

        log_file.write("\nIN_FILE_LOG Query:" + in_file_log_sql + "\n")
        dbObject.ExecuteQuery(in_file_log_cursor, in_file_log_sql)
        resultset = dbObject.FetchResults(in_file_log_cursor)

        if len(resultset) == 0:
            return 1
        else:
            log_file.write("Cant schedule the export tasks now.\nThe following TC57 imports are still running.")
            for row in resultset:
                log_file.write("Result Row:\t" + str(row))
            cleanUpAndExit(1,
                           msg="Cant schedule the export tasks now.\nTC57 import for INST " + inst + " still running.")

    except Exception:
        failMsg = "Exception occured when performing database operation - checkInFileLog"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def checkTaskLog(inst, file_type):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        checkTaskLog():
            Checks in TASK_LOG table if any export process is running for the institution.
            If any export task for the given institution is currently running, the script rollsback all DB updates and exits.

        Parameter:
            inst - Institution ID
            file_type - File Type used to schedule the appropriate task in the TASKS table.
                        file_type should be one of the following
                            21 - MAS File
                            41 - Visa File
                            55 - Mastercard File
                            83 - Discover File

        Returns:
            Retunrs 1 - if no export task for the given institution is currently running
            Returns 0 - if any export task for the given institution is currently running
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    log_file.write("\n\n--Checking TASK_LOG--")
    try:
        task_log_cursor = dbObject.OpenCursor()
        task_usage = config['DEFAULT']['EXPORT_TASK_USAGE']
        task_nbr = config['DEFAULT']['EXPORT_TASK_PREFIX'] + file_type
        offsetHrs = int(config['DEFAULT']['DB_CHECK_OFFSET_HRS'])
        check_time = (datetime.datetime.today() - datetime.timedelta(hours=offsetHrs)).strftime("%Y%m%d%H%M%S")

        task_log_sql = "SELECT TASK_LOG_SEQ, INSTITUTION_ID, TASK_NBR, SCHEDULE_START_DT, RESULT FROM TASK_LOG " \
                       "WHERE USAGE = '" + task_usage + "' AND INSTITUTION_ID = '" + inst + "' " \
                       "AND TASK_NBR = '" + task_nbr + "' AND RESULT = 'EXECUTED' " \
                       "AND SCHEDULE_START_DT > TO_DATE('" + check_time + "', 'YYYYMMDDHH24MISS')"

        # task_log_sql = "SELECT TASK_LOG_SEQ, INSTITUTION_ID, TASK_NBR, SCHEDULE_START_DT, RESULT FROM TASK_LOG " \
        #                "WHERE USAGE = '" + task_usage + "' AND INSTITUTION_ID = '" + inst + "' " \
        #                "AND TASK_NBR = '" + task_nbr + "' AND SCHEDULE_START_DT > TO_DATE('" + check_time + "', 'YYYYMMDDHH24MISS')"

        log_file.write("\nTASK_LOG Query:" + task_log_sql + "\n")
        dbObject.ExecuteQuery(task_log_cursor, task_log_sql)
        resultset = dbObject.FetchResults(task_log_cursor)

        if len(resultset) == 0:
            return 1
        else:
            log_file.write(
                "Cant schedule the export task for file type " + file_type + ".\nThe following export tasks are still running.")
            for row in resultset:
                log_file.write("Result Row:\t" + str(row))
            return 0

    except Exception:
        failMsg = "Exception occured when performing database operation - checkTaskLog"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def scheduleTask(inst, file_type):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        scheduleTask():
            Updates the TASKS table for the given institution ID and file type

        Parameter:
            inst   - Institution ID
            file_type - File Type used to schedule the appropriate task in the TASKS table.
                        file_type should be one of the following
                            21 - MAS File
                            41 - Visa File
                            55 - Mastercard File
                            83 - Discover File

        Returns:
             1 -
             0 -
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    log_file.write("\n--Scheduling the task--")
    try:
        tasks_cursor = dbObject.OpenCursor()
        delay = int(config['DEFAULT']['EXPORT_TASK_DELAY_MINS'])
        sh_time = datetime.datetime.today() + datetime.timedelta(minutes=delay)
        sh_hr = sh_time.strftime("%H")
        sh_mi = sh_time.strftime("%M")

        task_nbr = config['DEFAULT']['EXPORT_TASK_PREFIX'] + file_type
        task_usage = config['DEFAULT']['EXPORT_TASK_USAGE']
        tasks_sql = "UPDATE TASKS SET RUN_HOUR = '" + sh_hr + "', RUN_MIN  = '" + sh_mi + "' " \
                                                                                          "WHERE INSTITUTION_ID = '" + inst + "' AND TASK_NBR = '" + task_nbr + "' AND USAGE = '" + task_usage + "'"

        log_file.write("\nTASKS Query:" + tasks_sql + "\n")
        dbObject.ExecuteQuery(tasks_cursor, tasks_sql)
        success_list.append(file_type)

    except Exception:
        failMsg = "Exception occured when performing database operation - scheduleTask"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def removeStopFile(inst):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        removeStopFile():
            Sleeps for the delay time configured and deletes the stop file created at the beginning of the program

        Parameter:
            inst - Institution ID(This is a dummy argument as of now. Placeholder for future scalability)

        Returns:
             0 - If failed to remove the stop file
             1 - If successfully removed the stopfile after delay
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    stop_file_name = str(inst) + "_" + config['DEFAULT']['STOP_FILE_NAME']
    stop_file = pathlib.Path(stop_file_name)
    delay = int(config['DEFAULT']['EXPORT_TASK_DELAY_MINS']) * 60

    try:
        if stop_file.exists():
            log_file.write("\nSleeping for " + str(delay) + " seconds.")
            time.sleep(delay)
            # time.sleep(10)
            stop_file.unlink()
            log_file.write("\nStop File deleted.\n")

    except IOError:
        failMsg = "Error occured when removing stop file  - removeStopFile"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)


def main():
    """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            main():
                This function holds all the program logic.
                Reads the raw Discover IIN line by line generates insert statements for BIN_SPECIFIC_LINK and BIN tables
                Writes the insert queries to the output file(.sql).
                Writes the parsed, tab delimited IIN records to a raw text file.

            Parameter:
                N/A

            Returns:
                Returns nothing.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
    global inst_id, file_type_list

    log_file.write("\n\n#################################################################################\n")
    log_file.write("\nPreparing to schedule the export tasks.")
    log_file.write("\nScript Name:" + sys.argv[0])
    log_file.write("\nDate: " + datetime.datetime.today().strftime("%b-%d-%Y"))
    log_file.write("\nTime: " + datetime.datetime.today().strftime("%X"))
    log_file.write("\n")

    args = parseArguments()
    clearOldLogs()
    initDB()

    log_file.write("Args: " + str(args))
    log_file.write("clr_date_j:" + clr_date_j)

    inst_id = args.inst_id
    file_type = args.file_type
    if args.file_type == '00':
        file_type_list = ['55', '41', '21', '83']
    else:
        file_type_list.append(file_type)

    log_file.write("File Type List: " + str(file_type_list))

    checkForStopFile(inst_id)
    for file_type in file_type_list:
        log_file.write("\n#########################################################################")
        log_file.write("Processing file type - " + file_type + "\n")
        cutoff_check = checkCutOffBatch(inst_id, file_type)
        in_file_check = checkInFileLog(inst_id)
        task_log_check = checkTaskLog(inst_id, file_type)
        if cutoff_check and in_file_check and task_log_check:
            scheduleTask(inst_id, file_type)

    try:
        dbObject.Commit()
        log_file.write("\n\nDatabase commit complete.")

    except Exception:
        failMsg = "Exception occured when performing database commit operation - main"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUpAndExit(2, msg=failMsg)

    removeStopFile(inst_id)
    cleanUpAndExit(0)


if __name__ == "__main__":
    main()
