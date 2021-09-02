#!/usr/bin/env python

import os
import cx_Oracle
import sys
import datetime
import configparser
import shutil
from re import split
from datetime import timedelta


Config = configparser.ConfigParser()
Config.read('GeneratePOSDataUpdates.cfg')

suspendErrCodes = Config['DEFAULT']['ERR_CODES']
libraryPath = Config['DEFAULT']['LIB_PATH']

sys.path.append(libraryPath)

from database_class import DbClass

today = datetime.date.today()
yesterday = today - timedelta(days=1)
today = today.strftime("%Y") + today.strftime("%m") + today.strftime("%d")
yesterday = yesterday.strftime("%Y") + yesterday.strftime("%m") + yesterday.strftime("%d")
startTime = yesterday + '100000'
endTime = today + '095959'
# startTime = '20181018120000'

_00posCrdDatInCapDict = {'0': '0', '1': '1', '2': '2', '4': '4', '5': '5', '6': '6', 'A': '7', 'B': '8', 'C': '9',
                         'D': '10', 'E': '11', 'M': '97', 'V': '99'}
_01posChAuthCapDict = {'0': '1', '1': '2', '2': '3', '3': '5', '5': '4', '6': '9', '9': '0'}
_02posCrdCaptCapDict = {'0': '0', '1': '1', '9': '9'}
_03posOperatingEnvDict = {'0': '1', '1': '2', '2': '3', '3': '4', '4': '5', '5': '6', '6': '7', '7': '14', '9': '0'}
_04posChPresentDict = {'0': '1', '1': '0', '2': '2', '3': '3', '4': '4', '5': '5', '9': '9'}
_05posCrdPresentDict = {'0': '0', '1': '1', '9': '9'}
_06posCrdDatInModeDict = {'0': '0', '1': '1', '2': '2', '6': '6', '7': '10', 'A': '7', 'B': '90', 'C': '5', 'F': '96',
                          'M': '97', 'R': '98', 'S': '109', 'T': '121'}
_07posChAuthMethodDict = {'0': '1', '1': '2', '2': '6', '5': '3', '6': '7', '9': '0', 'S': '8'}
_08posChAuthEntityDict = {'0': '1', '1': '2', '2': '3', '3': '4', '4': '5', '5': '9', '9': '0'}
_09posCrdDatOutCapDict = {'0': '0', '1': '1', '2': '2', '3': '3', 'S': '9'}
_10posTermOutCapDict = {'0': '0', '1': '1', '2': '2', '3': '3', '4': '4'}
_11posPinCaptCapDict = {'0': '1', '1': '0', '2': '2', '3': '3', '4': '4', '5': '5', '6': '6', '7': '7', '8': '8',
                        '9': '9', 'A': '10', 'B': '11', 'C': '12'}
inputFileName = "ARCHIVE/suspendedTrans.txt_"+today
outputFileName = "ARCHIVE/updateQueries.sql_"+today
logFileName = "LOG/GeneratePOSDataUpdates.log_"+today
inputFile = open(inputFileName, "w+")
outputFile = open(outputFileName, "w+")
logFile = open(logFileName, "w+")
# print("FILE NAME: ", outputFile.name)
# print("FILE MODE: ", outputFile.mode)
logFile.write("Starting first step in MC Edit-16 suspends processing\n")

dbObject = DbClass(ENV_HOSTNM='IST_HOST', \
                    ENV_USERID='IST_DB_USERNAME', \
                    PORTNO='1521', \
                    ENV_PASSWD='IST_DB_PASSWORD', \
                    ENV_SERVNM='IST_SERVERNAME')

dbObject.Connect()
selectCursor = dbObject.OpenCursor()
updateCursor = dbObject.OpenCursor()

sqlString = "select trans_seq_nbr ||'-'|| msg_text_block as SUSPENDS from IN_DRAFT_MAIN " \
            "where msg_text_block is not null and trans_seq_nbr in(select trans_seq_nbr from TRANS_ERR_LOG " \
            "where trans_seq_nbr in(select trans_seq_nbr from SUSPEND_LOG " \
            "where suspend_status = 'S' and in_file_nbr in(select in_file_nbr from IN_FILE_LOG " \
            "where external_file_name like '%tc57%'and (incoming_dt between to_date('"+startTime+"', 'YYYYMMDDHH24MISS')" + "and to_date('"+endTime+"', 'YYYYMMDDHH24MISS'))))" \
            "and trans_err_cd in (" + suspendErrCodes + "))"
# print(sqlString + '\n')
logFile.write("\nRun Date:" + today)
logFile.write("\nStart Time:" + startTime)
logFile.write("\nEnd Time:" + endTime)
logFile.write('\nSQL STRING:\n' + sqlString + '\n\n')

resultSet = dbObject.ExecuteQuery(selectCursor, sqlString)

# resultSet = myObject.FetchResults()
resultSet = dbObject.FetchResults(selectCursor)

counter = 0
logFile.write("Updating the POS columns in IN_DRAFT_MAIN using the result set\n")
for result in resultSet:
    inputFile.write(str(result[0]) + "\n")
    suspend = result[0]
    counter += 1
    suspend = suspend.rstrip()
    transSeqNbr, posData = suspend.split('-')
    pd = posData
    # pd01, pd02, pd03, pd04, pd05, pd06, pd07, pd08, pd09, pd10, pd11, pd12 = posData.split("")

    suspendStatusUpdateQuery = ''
    idmUpdateQuery = ''

    idmUpdateQuery += 'UPDATE IN_DRAFT_MAIN SET '
    # outputFile.write(arn + '\n')
    posCrdDatInCap = _00posCrdDatInCapDict.get(pd[0])
    posChAuthCap = _01posChAuthCapDict.get(pd[1])
    posCrdCaptCap = _02posCrdCaptCapDict.get(pd[2])
    posOperatingEnv = _03posOperatingEnvDict.get(pd[3])
    posChPresent = _04posChPresentDict.get(pd[4])
    posCrdPresent = _05posCrdPresentDict.get(pd[5])
    posCrdDatInMode = _06posCrdDatInModeDict.get(pd[6])
    posChAuthMethod = _07posChAuthMethodDict.get(pd[7])
    posChAuthEntity = _08posChAuthEntityDict.get(pd[8])
    posCrdDatOutCap = _09posCrdDatOutCapDict.get(pd[9])
    posTermOutCap = _10posTermOutCapDict.get(pd[10])
    posPinCaptCap = _11posPinCaptCapDict.get(pd[11])

    idmUpdateQuery += 'POS_CRDDAT_IN_CAP = ' + '\'' + posCrdDatInCap + '\','
    idmUpdateQuery += 'POS_CH_AUTH_CAP = ' + '\'' + posChAuthCap + '\','
    idmUpdateQuery += 'POS_CRD_CAPT_CAP = ' + '\'' + posCrdCaptCap + '\','
    idmUpdateQuery += 'POS_OPERATING_ENV = ' + '\'' + posOperatingEnv + '\','
    idmUpdateQuery += 'POS_CH_PRESENT = ' + '\'' + posChPresent + '\','
    idmUpdateQuery += 'POS_CRD_PRESENT = ' + '\'' + posCrdPresent + '\','
    idmUpdateQuery += 'POS_CRDDAT_IN_MODE = ' + '\'' + posCrdDatInMode + '\','
    idmUpdateQuery += 'POS_CH_AUTH_METHOD = ' + '\'' + posChAuthMethod + '\','
    idmUpdateQuery += 'POS_CH_AUTH_ENTITY = ' + '\'' + posChAuthEntity + '\','
    idmUpdateQuery += 'POS_CRDDAT_OUT_CAP = ' + '\'' + posCrdDatOutCap + '\','
    idmUpdateQuery += 'POS_TERM_OUT_CAP = ' + '\'' + posTermOutCap + '\','
    idmUpdateQuery += 'POS_PIN_CAPT_MODE = ' + '\'' + posPinCaptCap + '\''
    idmUpdateQuery += 'WHERE TRANS_SEQ_NBR = ' + '\'' + transSeqNbr + '\''

    suspendStatusUpdateQuery += 'UPDATE SUSPEND_LOG SET SUSPEND_STATUS = \'R\' ' \
                                'WHERE TRANS_SEQ_NBR = ' + '\'' + transSeqNbr + '\''

    # logFile.write(str(counter) + ': Updating - ' + str(transSeqNbr) + '\t' + str(posData) + '\n')
    dbObject.ExecuteQuery(updateCursor, idmUpdateQuery)
    dbObject.ExecuteQuery(updateCursor, suspendStatusUpdateQuery)
    dbObject.Commit()
    logFile.write(str(counter) + ': Updated - ' + str(transSeqNbr) + '\t' + str(posData) + '\n')

    idmUpdateQuery += ';\n'
    suspendStatusUpdateQuery += ';\n'
    outputFile.write(idmUpdateQuery)
    outputFile.write(suspendStatusUpdateQuery)

logFile.write('Total No of suspends processed: ' + str(counter) + '\n')
outputFile.write('\n\n')
logFile.write("Closing the File Handles\n")
logFile.write("End of step 1\n")
logFile.write("Login to PRD-CLR-01 as clradmin to process the suspends\n")
logFile.write("\n\n##################################################################")

inputFile.flush()
outputFile.flush()
logFile.flush()


dbObject.CloseCursor(selectCursor)
dbObject.CloseCursor(updateCursor)
dbObject.Disconnect()

inputFile.close()
outputFile.close()
logFile.close()

