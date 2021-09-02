#!/usr/bin/env python

import os
from builtins import print

import cx_Oracle
import sys
import datetime
import configparser
import shutil
import time
import traceback
from re import split
from datetime import timedelta


class Incoming_File:
    # in_file_nbr, institution_id, external_file_name, incoming_dt, end_dt, in_file_status
    def __init__(self, in_file_nbr, institution_id, external_file_name, in_file_status):
        self.in_file_nbr = in_file_nbr
        if institution_id == '05':
            self.institution_id = 'MC'
        elif institution_id == '04':
            self.institution_id = 'VS'
        else:
            self.institution_id = institution_id
        self.external_file_name = external_file_name
        self.in_file_status = in_file_status

    def toString(self):
        print(self.in_file_nbr, self.institution_id, self.external_file_name, self.in_file_status)


# region Init
Config = configparser.ConfigParser()
Config.read('monitor_incoming_files.cfg')

intervalSecs = Config['DEFAULT']['INTERVAL_SECS']
defaultFileList = Config['DEFAULT']['DEFAULT_FILE_LIST']
sundayFileList = Config['DEFAULT']['SUNDAY_FILE_LIST']
failStatus = Config['DEFAULT']['FAIL_STATUS']
scriptEndTime = Config['DEFAULT']['SCRIPT_END_TIME']
libraryPath = Config['DEFAULT']['LIB_PATH']

emailFrom = Config['EMAIL']['EMAIL_FROM']
emailToAlert = Config['EMAIL']['EMAIL_TO_ALERT']
emailToStatus = Config['EMAIL']['EMAIL_TO_STATUS']
emailSubjectAlert = Config['EMAIL']['EMAIL_SUBJECT_ALERT']
emailSubjectStatus = Config['EMAIL']['EMAIL_SUBJECT_STATUS']
emailSubjectFailure = Config['EMAIL']['EMAIL_SUBJECT_FAILURE']

expectedFileList = defaultFileList
intervalSecs = int(intervalSecs)

sys.path.append(libraryPath)

from database_class import DbClass
from email_class import EmailClass

now = datetime.datetime.today()
tomorrow = now + timedelta(days=1)
scriptEndTime = int(tomorrow.strftime("%y") + tomorrow.strftime("%j") + scriptEndTime)

runDate = now.strftime("%Y") + now.strftime("%m") + now.strftime("%d")
# runDate = str(20200623)
curTime = now.strftime("%Y") + now.strftime("%m") + now.strftime("%d") + now.strftime("%H:%M:%S")
dayOfWeek = now.weekday()  # 0-Mon, 1-Tue, ..., 6-Sun

jDateInFileName = now.strftime("%y") + now.strftime("%j")
jDateInFileName = jDateInFileName[1:]

# jDateInFileName = str("0175")

if dayOfWeek == 6:
    expectedFileList = sundayFileList

logFileName = "LOG/monitor_incoming_files.log_" + runDate + "_" + now.strftime("%H%M%S")

logFile = open(logFileName, "w+")
logFile.write("Starting to monitor Incoming Files: " + curTime + "\n")
logFile.write("CUR TIME:\t" + curTime + "\n")
logFile.write("Day of Week:\t" + str(dayOfWeek) + "\n")
logFile.write("Email to Alert:\t" + emailToAlert + "\n")

logFile.write("\nExpected Files:\n")
expectedFileList = expectedFileList.split(", ")
for i in range(0, len(expectedFileList)):
    expectedFileList[i] = expectedFileList[i].replace("$$$$", str(jDateInFileName))
    logFile.write(expectedFileList[i] + "\n")

failEmailBody = "\n\n\n######################################################\n"
failEmailBody = failEmailBody + "ASSIST :: \nContact On-Call Engineer. (15 minutes or Escalate) - Open Ticket\n"
failEmailBody = failEmailBody + "\n######################################################\n\n"


# endregion Init


def sendAlertEmail(msg, subject):
    emailObj = EmailClass(TO_ADDRESS=(emailToAlert),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=subject)
    emailObj.SendEmail()


def sendStatusEmail(msg):
    emailObj = EmailClass(TO_ADDRESS=(emailToStatus),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=emailSubjectStatus + " " + datetime.datetime.today().strftime(
                              "%Y-%m-%d %H:%M:%S"))
    emailObj.SendEmail()


def documentFailure(msg, e):
    excMsg = msg
    excType, excValue = e[:2]
    excMsg = excMsg + "\nError Type: \t" + str(excType)
    excMsg = excMsg + "\nError Value: \t" + str(excValue)
    logFile.write("\n\nERROR OCCURED:\n##### ########" + excMsg)
    logFile.write("\n\n" + traceback.format_exc() + "\n\n")
    excMsg = excMsg + "\n\nCheck log file for further information\n"
    excMsg = excMsg + failEmailBody
    sendAlertEmail(excMsg, emailSubjectFailure)


def cleanUp():
    logFile.write("\nEnding the monitoring script.\n")
    logFile.write(
        "#####################################################################################################")
    logFile.flush()
    dbObject.CloseCursor(selectCursor)
    dbObject.Disconnect()
    logFile.close()


# region Database Part
try:
    dbObject = DbClass(ENV_HOSTNM='IST_HOST', \
                        ENV_USERID='IST_DB_USERNAME', \
                        PORTNO='1521', \
                        ENV_PASSWD='IST_DB_PASSWORD', \
                        ENV_SERVNM='IST_SERVERNAME')

    dbObject.Connect()
    selectCursor = dbObject.OpenCursor()

    sqlString = """select in_file_nbr, institution_id, external_file_name, incoming_dt, end_dt, in_file_status from in_file_log 
                where file_type <> '01' and (external_file_name like 'INVS%' or external_file_name like 'INMC%') and 
                to_char(incoming_dt, 'YYYYMMDD') = :run_date"""
    logFile.write('\n' + sqlString + '\n' + "\n")
    dbObject.ExecuteQuery(selectCursor, sqlString, {'run_date': runDate})
    resultSet = dbObject.FetchResults(selectCursor)

    importsDict = {}

    for result in resultSet:
        logFile.write("Result Row:\t" + str(result) + "\n")
        inFileNbr = result[0]
        institutionId = result[1]
        externalFileName = result[2].rstrip()
        incomingDt = str(result[3]).rstrip()
        endDt = str(result[4]).rstrip()
        inFileStatus = result[5]
        if inFileStatus is not None:
            inFileStatus = inFileStatus.rstrip()

        importsDict[externalFileName] = Incoming_File(inFileNbr, institutionId, externalFileName, inFileStatus)

except:
    failMsg = "\nError occurred while performing database operation"
    exc = sys.exc_info()
    documentFailure(failMsg, exc)
    cleanUp()
    sys.exit(0)

# endregion Database Part

# region Parsing Results
try:
    stillProcessingFilesList = []
    successFilesList = []
    missingFilesList = []
    errorFilesList = []
    additionalFilesList = []

    stillProcessingMsg = "\n\nFiles still being processed:\n\n\t\tCARD_TYPE\t\tIN_FILE_NBR\t\tFILE_NAME\n"
    errorMsg = "\n\nThe following files have failed with import status = " + failStatus + "\n\n\t\tCARD_TYPE\t\tIN_FILE_NBR\t\tFILE_NAME\n"
    successMsg = "\n\nThe following files have been processed successfully with a status 'C' or 'P'\n\n\t\tCARD_TYPE\t\tIN_FILE_NBR\t\tFILE_NAME\n"
    missingMsg = "\n\nThe following files are still missing for the day\n\n\t\tFILE_NAME\n"
    additionalMsg = "\n\nThe following files have been processed today in addition to the above files\n\n\t\tCARD_TYPE\t\tIN_FILE_NBR\t\tFILE_NAME\n"

    for fileName in expectedFileList:
        if fileName in importsDict:
            logFile.write("Found file: " + fileName + "\n")
            file = importsDict[fileName]
            if file.in_file_status is None:
                stillProcessingFilesList.append(fileName)
                stillProcessingMsg += "\t\t" + str(file.institution_id) + "\t\t\t" + str(
                    file.in_file_nbr) + "\t\t" + file.external_file_name + "\n"
            elif file.in_file_status == failStatus:
                errorFilesList.append(fileName)
                errorMsg += "\t\t" + str(file.institution_id) + "\t\t\t" + str(
                    file.in_file_nbr) + "\t\t" + file.external_file_name + "\n"
            else:
                successFilesList.append(fileName)
                successMsg += "\t\t" + str(file.institution_id) + "\t\t\t" + str(
                    file.in_file_nbr) + "\t\t" + file.external_file_name + "\n"
        else:
            logFile.write("Did not find file: " + fileName + "\n")
            missingFilesList.append(fileName)
            # missingMsg += "\t\t" + str(file.institution_id) + "\t\t\t" + str(
            #     file.in_file_nbr) + "\t\t" + file.external_file_name + "\n"
            missingMsg += "\t\t" + fileName + "\n"

    for fileName in importsDict:
        if fileName not in expectedFileList:
            additionalFilesList.append(fileName)
            file = importsDict[fileName]
            additionalMsg += "\t\t" + str(file.institution_id) + "\t\t\t" + str(
                file.in_file_nbr) + "\t\t" + file.external_file_name + "\n"

    logFile.write("Missing File List: " + str(missingFilesList) + "\n")
    logFile.write("Error File List: " + str(errorFilesList) + "\n")
    logFile.write("Success File List: " + str(successFilesList) + "\n")
    logFile.write("Additional File List: " + str(additionalFilesList) + "\n")
    logFile.write("Still Processing File List: " + str(stillProcessingFilesList) + "\n")

    emailMsg = ""
    if len(errorFilesList) > 0 or len(missingFilesList) > 0:
        if len(errorFilesList) > 0:
            emailMsg = emailMsg + errorMsg
        if len(missingFilesList) > 0:
            emailMsg = emailMsg + missingMsg
        emailMsg = emailMsg + failEmailBody
        sendAlertEmail(emailMsg, emailSubjectAlert)

    logFile.write("Alert Email:\n" + emailMsg)

    emailMsg = ""
    if len(errorFilesList) > 0:
        emailMsg = emailMsg + errorMsg
    if len(missingFilesList) > 0:
        emailMsg = emailMsg + missingMsg
    emailMsg = emailMsg + successMsg
    if len(additionalFilesList) > 0:
        emailMsg = emailMsg + additionalMsg
    if len(stillProcessingFilesList) > 0:
        emailMsg = emailMsg + stillProcessingMsg
    sendStatusEmail(emailMsg)

    logFile.write("Notification Email:\n" + emailMsg)
    # print("\nEMAILS:\n")
    # print(errorMsg)
    # print(missingMsg)
    # print(stillProcessingMsg)
    # print(successMsg)
    # print(additionalMsg)
except Exception as exc:
    failMsg = "\nError occurred while parsing results"
    exc_info = sys.exc_info()
    documentFailure(failMsg, exc_info)
    cleanUp()
    sys.exit(0)
# endregion Parsing Results

cleanUp()
