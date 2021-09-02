#!/usr/bin/env python

import os
import cx_Oracle
import sys
import datetime
import configparser
import shutil
import time
from re import split
from datetime import timedelta


class TC57_Import:
    # in_file_nbr, institution_id, external_file_name, incoming_dt, end_dt, in_file_status
    def __init__(self, in_file_nbr, institution_id, external_file_name, in_file_status):
        self.in_file_nbr = in_file_nbr
        self.institution_id = institution_id
        self.external_file_name = external_file_name
        self.in_file_status = in_file_status


Config = configparser.ConfigParser()
Config.read('monitor_tc57_imports.cfg')

intervalSecs = Config['DEFAULT']['INTERVAL_SECS']
defaultFileCount = Config['DEFAULT']['DEFAULT_FILE_COUNT']
sundayFileCount = Config['DEFAULT']['SUNDAY_FILE_COUNT']
failStatus = Config['DEFAULT']['FAIL_STATUS']
scriptEndTime = Config['DEFAULT']['SCRIPT_END_TIME']
libraryPath = Config['DEFAULT']['LIB_PATH']

emailFrom = Config['EMAIL']['EMAIL_FROM']
emailToAlert = Config['EMAIL']['EMAIL_TO_ALERT']
emailToStatus = Config['EMAIL']['EMAIL_TO_STATUS']
emailSubjectAlert = Config['EMAIL']['EMAIL_SUBJECT_ALERT']
emailSubjectStatus = Config['EMAIL']['EMAIL_SUBJECT_STATUS']

expectedFileCount = int(defaultFileCount)
intervalSecs = int(intervalSecs)

sys.path.append(libraryPath)

from database_class import DbClass
from email_class import EmailClass

now = datetime.datetime.today()
tomorrow = now + timedelta(days=1)
scriptEndTime = int(tomorrow.strftime("%y") + tomorrow.strftime("%j") + scriptEndTime)

today = now.strftime("%Y") + now.strftime("%m") + now.strftime("%d")
tomorrow = tomorrow.strftime("%Y") + tomorrow.strftime("%m") + tomorrow.strftime("%d")
curTime = now.strftime("%Y") + now.strftime("%m") + now.strftime("%d") + now.strftime("%H:%M:%S")
dayOfWeek = now.weekday()  # 0-Mon, 1-Tue, ..., 6-Sun

print("CUR TIME:\t" + curTime)
print("Day of Week:\t" + str(dayOfWeek))
print("Monitor End Time:\t" + str(scriptEndTime))
print("Email to Alert:\t" + emailToAlert)

startTime = today + '170000'
endTime = tomorrow + '015959'

# startTime = '20191105170000'
# endTime = '20191106015959'

if dayOfWeek == 6:
    expectedFileCount = int(sundayFileCount)

print("Expected File Count:\t" + str(expectedFileCount))

logFileName = "LOG/monitor_tc57_imports.log_" + today
logFile = open(logFileName, "w+")
logFile.write("Starting to monitor TC57 runs: " + curTime)

failEmailBody = "ASSIST :: \nContact On-Call Engineer. (15 minutes or Escalate) - Open Ticket " \
                "\n\nENGINEER:: \nAfter cleaning the partial import from Clearing database, rerun the import by updating the TASKS table"

dbObject = DbClass(ENV_HOSTNM='IST_HOST', \
                    ENV_USERID='IST_DB_USERNAME', \
                    PORTNO='1521', \
                    ENV_PASSWD='IST_DB_PASSWORD', \
                    ENV_SERVNM='IST_SERVERNAME')
dbObject.Connect()
selectCursor = dbObject.OpenCursor()
updateCursor = dbObject.OpenCursor()

sqlString = "select in_file_nbr, institution_id, external_file_name, incoming_dt, end_dt, in_file_status from in_file_log " \
            "where file_type = 01 and external_file_name like '%tc57%'and " \
            "(incoming_dt between to_date('" + startTime + "', 'YYYYMMDDHH24MISS')" + "and to_date('" + endTime + "', 'YYYYMMDDHH24MISS'))"
print(sqlString + '\n')

suspendList = []
successList = []


def sendAlertEmail(inst, msg):
    emailObj = EmailClass(TO_ADDRESS=(emailToAlert),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=emailSubjectAlert + " " + inst)
    emailObj.SendEmail()


def sendStatusEmail(msg):
    emailObj = EmailClass(TO_ADDRESS=(emailToStatus),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=emailSubjectStatus + " " + datetime.datetime.today().strftime("%Y-%m-%d %H:%M:%S"))
    emailObj.SendEmail()


counter = 0
importsDict = {}


def checkForSuspends():
    global counter
    global importsDict
    importsDict = {}
    print("Checking for TC57 suspends in IN_FILE_LOG")
    dbObject.ExecuteQuery(selectCursor, sqlString)
    resultSet = dbObject.FetchResults(selectCursor)

    for result in resultSet:
        print("Result Row:\t" + str(result))
        in_file_nbr = result[0]
        institution_id = result[1]
        external_file_name = result[2].rstrip()
        incoming_dt = str(result[3]).rstrip()
        end_dt = str(result[4]).rstrip()
        in_file_status = result[5]
        if in_file_status is not None:
            in_file_status = in_file_status.rstrip()

        importsDict[in_file_nbr] = TC57_Import(in_file_nbr, institution_id, external_file_name, in_file_status)

        if in_file_status in ['C', 'P'] and in_file_nbr not in successList:
            successList.append(in_file_nbr)
            counter += 1

        if in_file_nbr not in suspendList:
            if in_file_status is not None and in_file_status == failStatus:
                print("Send Email")
                msg = "TC57 Import for institution " + institution_id + " failed with status '" + failStatus + "'"
                msg += "\nDetails:"
                msg += "\n\tIN_FILE_NBR = " + str(in_file_nbr)
                msg += "\n\tINST_ID = " + str(institution_id)
                msg += "\n\tFILE_NAME = " + external_file_name
                msg = msg + "\n\n" + failEmailBody
                sendAlertEmail(inst=institution_id, msg=msg)
                suspendList.append(in_file_nbr)

    return counter


ctr = 0
statusEmailMsg = ""

while True:
    ctr += 1
    count = checkForSuspends()
    now = datetime.date.today()
    h24miss = int(datetime.datetime.today().strftime("%y%j%H%M%S"))
    print("IN_FILE_LOG COUNT:" + str(count))
    print("DICT COUNT:" + str(len(importsDict)))
    print("TimeNow:" + str(h24miss))
    print("Success List:" + str(successList))
    print("Suspend List:" + str(suspendList))
    if count >= expectedFileCount or h24miss > scriptEndTime:
        statusEmailMsg += "\n\nTotal number of TC57 files processed: " + str(count) + "\n"
        break
    print(str(ctr) + ". Sleeping for " + str(intervalSecs) + "seconds")
    time.sleep(intervalSecs)

# Get Counts
c_count = 0
p_count = 0
s_count = 0
incomplete_count = 0
c_statusMsg = "INST_ID\t\tIN_FILE_NBR\t\tFILE_NAME\n"
p_statusMsg = "INST_ID\t\tIN_FILE_NBR\t\tFILE_NAME\n"
s_statusMsg = "INST_ID\t\tIN_FILE_NBR\t\tFILE_NAME\n"
incomplete_statusMsg = "INST_ID\t\tIN_FILE_NBR\t\tFILE_NAME\n"
for x in importsDict:
    item = importsDict[x]
    if item.in_file_status is 'C':
        c_count += 1
        c_statusMsg += str(item.institution_id) + "\t" + str(item.in_file_nbr) + "\t" + item.external_file_name + "\n"
    elif item.in_file_status is 'P':
        p_count += 1
        p_statusMsg += str(item.institution_id) + "\t" + str(item.in_file_nbr) + "\t" + item.external_file_name + "\n"
    elif item.in_file_status is 'S':
        s_count += 1
        s_statusMsg += str(item.institution_id) + "\t" + str(item.in_file_nbr) + "\t" + item.external_file_name + "\n"
    elif item.in_file_status is None:
        incomplete_count += 1
        incomplete_statusMsg += str(item.institution_id) + "\t" + str(item.in_file_nbr) + "\t" + item.external_file_name + "\n"

# Imports finished with status 'C'
c_statusMsg = "\n\n'" + str(c_count) + "' imports finished with status 'C'\n" + c_statusMsg
# Imports finished with status 'P'
p_statusMsg = "\n\n'" + str(p_count) + "' imports finished with status 'P'\n" + p_statusMsg
# Imports failed with status 'S'
s_statusMsg = "\n\n'" + str(s_count) + "' imports failed with status 'S'\n" + s_statusMsg
# Imports still running
incomplete_statusMsg = "\n\n'" + str(incomplete_count) + "' imports are still running\n" + incomplete_statusMsg

statusEmailMsg = statusEmailMsg + c_statusMsg + p_statusMsg + s_statusMsg + incomplete_statusMsg

print(statusEmailMsg)

sendStatusEmail(statusEmailMsg)

logFile.flush()
dbObject.CloseCursor(selectCursor)
dbObject.Disconnect()
logFile.close()