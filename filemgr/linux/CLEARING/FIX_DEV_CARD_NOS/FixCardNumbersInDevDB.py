#!/usr/local/bin python

'''
File Name:  FixCardNumbersInDevDB.py

Description:  This script is to update the dummy card numbers for the transactions in SETTLEMENT table from the dev database.
                As we have restrictions on using live card numbers in non-production databases, the tables are loaded using dummy card numbers.
                This script updates the cardnum field in the settlement to valid ones that pass the Luhn's check.

Arguments:  Database name.
            Example: authqa, authdev, cleardev, etc

Output:       N/A
            The database records in the SETTLEMENT table are updated with valid card numbers

Return:   0 = Success
          !0 = Exit with errors
'''

import os
from luhn import generate
import cx_Oracle
import configparser
import datetime
import sys
import traceback
from datetime import datetime

logFile = None


def usage(scriptname):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        usage():
            prints the usage format of the script.

        Parameter:
            scriptname      - Name of the current script - argv[0]

        Returns:
            Returns nothing.
            Exits the program after printing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    print("Example Usage: " + scriptname + " authdev\n")
    print("Exiting!!!\n\n")
    exit(1)


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
    excMsg = msg
    excType, excValue = e[:2]
    excMsg = excMsg + "\nError Type: \t" + str(excType)
    excMsg = excMsg + "\nError Value: \t" + str(excValue)
    print(excMsg)
    logFile.write("\n\nERROR OCCURED:\n##### ########" + excMsg)
    logFile.write("\n\n" + traceback.format_exc() + "\n\n")


def cleanUp():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        cleanUp():
            Cleans up the resources like open file handles, database connections, etc.

        Parameter:
            N/A

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """
    logFile.write("\n Error Occurred. Exiting the program " + sys.argv[0] + "\n")
    logFile.write(
        "#####################################################################################################")
    logFile.flush()
    # dbObject.CloseCursor(selectCursor)
    # dbObject.CloseCursor(updateCursor)
    # dbObject.Disconnect()
    logFile.close()


def main():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        main():
            This function holds all the program logic.
            Reads the records from the settlement table and updates the last digit in order to pass the Luhn's check

        Parameter:
            N/A

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """
    global logFile
    Config = configparser.ConfigParser()
    Config.read('FixCardNumbersInDevDB.cfg')

    if len(sys.argv) != 2:
        print(sys.argv[0] + " expects one argument for database name")
        usage(sys.argv[0])
    dbName = sys.argv[1].upper()

    print("Database Name:\t" + dbName)

    if dbName not in Config.sections():
        print("Connection parameters for '" + dbName + "' not found in config file.")
        exit(1)

    dbHostName = Config[dbName]['DB_HOST_NAME']
    dbPortNo = Config[dbName]['DB_PORT_NO']
    dbUserID = Config[dbName]['DB_USER_ID']
    dbPassword = Config[dbName]['DB_PASSWORD']
    dbServiceName = Config[dbName]['DB_SERVICE_NAME']
    print("Database Params:\n\t" + dbHostName + "\n\t" + dbPortNo + "\n\t" + dbUserID + "\n\t" + dbPassword + "\n\t" + dbServiceName + "\n\t")

    libraryPath = Config['DEFAULT']['LIB_PATH']
    sys.path.append(libraryPath)

    today = datetime.now()
    logFileName = "LOG/FixCardNumbersInDevDB.log_" + str(today.strftime("%Y%m%d%H%M%S"))
    logFile = open(logFileName, "w+")

    from database_class import DbClass
    from email_class import EmailClass

    try:
        dbObject = DbClass(HOSTNM=dbHostName, PORTNO=dbPortNo, USERID=dbUserID, PASSWD=dbPassword, SERVNM=dbServiceName)
        dbObject.Connect()

        print("Connected To \t" + dbHostName + " database.\n")

        selectCursor = dbObject.OpenCursor()
        updateCursor = dbObject.OpenCursor()

        selectQuery = """select other_data4, cardnum from settlement"""

        logFile.write(selectQuery + '\n')
        dbObject.ExecuteQuery(selectCursor, selectQuery)
        resultSet = dbObject.FetchResults(selectCursor)

        counter = 0
        for result in resultSet:
            logFile.write("Result Row:\t" + str(result))
            counter += 1
            updateQuery = ''
            od4 = result[0]
            cardNo = result[1]
            print("\nOther_Data4:\t" + od4)
            print("Orig_CardNo:\t" + cardNo)
            cardNo = cardNo[0:-1]
            print("CardNo(1-15):\t" + cardNo)
            checkDigit = generate(cardNo)
            print("Check Digit:\t" + str(checkDigit))
            cardNo = cardNo + str(checkDigit)
            print("New_CardNo:\t" + cardNo)

            updateQuery += 'UPDATE SETTLEMENT SET CARDNUM = ' + '\'' + cardNo + '\' WHERE OTHER_DATA4 = ' + '\'' + od4 + '\''

            dbObject.ExecuteQuery(updateCursor, updateQuery)
            dbObject.Commit()
            print(str(counter) + ': Updated - ' + str(od4) + '\t' + str(cardNo) + '\n')

            updateQuery += ';\n'
            logFile.write(updateQuery + '\n')

    except Exception:
        failMsg = ""
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUp()
        sys.exit(0)

    cleanUp()


if __name__ == "__main__":
    main()
