#!/usr/bin/env python

import os
import sys
import cx_Oracle
import csv
import os

# Add the library path. Note that the DbClass library reside in the
# /clearing/filemgr/MASCLRLIB directory. This line # must be positioned
# prior to the import of the class libraries. Refer to
# https://www.blog.pythonlibrary.org/2016/03/01/python-101-all-about-imports/
sys.path.append('/clearing/filemgr/MASCLRLIB')
from database_class import DbClass
print('Calling testDbPooling.py script')

# Print the OS environment variables.
# for envs in os.environ:
#   print('[%s]: %s' % (envs, os.getenv(envs)))

# Creating the class object using the positional argument method
# myObject = DbClass('dfw-qa-db-01.jetpay.com', 'lmendis', 'CJcaQLQ1',
#                   'authqa.jetpay.com', 1521)
# Incorrect password. The connection should fail in this instance
# myObject = DbClass('dfw-qa-db-01.jetpay.com', 'lmendis', 'my@password',
#                   'authqa.jetpay.com')


# PRODUCTION DATABASE:
# Creating the class object using the keyword argument method
# myObject = DbClass(HOSTNM = 'dfw-prd-db-09.jetpay.com', USERID = 'masclr', PORTNO = '1521',
#                   PASSWD = 'masclr', SERVNM = 'clear1.jetpay.com')


# Creating the class object using the keyword argument method
# myObject = DbClass(HOSTNM = 'dfw-qa-db-01.jetpay.com', PORTNO = '1521', USERID = 'lmendis',
#                     PASSWD = 'CJcaQLQ1', SERVNM = 'AUTHQA.jetpay.com')
#                   PASSWD = 'CJcaQLQ1', SERVNM = 'authqa.jetpay.com')

# This should throw an error
# myObject = DbClass()


# Creating a class object using a combination of positional and keyword arguments method.
myObject = DbClass('dfw-qa-db-01.jetpay.com', userid = 'lmendis',
                  PASSWD = 'CJcaQLQ1', servnm = 'authqa.jetpay.com')
# myObject = DbClass('dfw-qa-db-01.jetpay.com', USERID = 'USER',
#                   passwd = 'CJcaQLQ1', SERVNM = 'AUTHQA.jetpay.com')
# myObject = DbClass('dfw-qa-db-01.jetpay.com', USERID = 'USER',
#                   SERVNM = 'AUTHQA.jetpay.com')


# Use the database class object to initialize the login credentials from the
# environment variables. Note: The # ENV_ prefix in the keyword argument list
# is the indicator that prompts the class object to grab the credentials from
# the environment.

# dbObject = DbClass(HOSTNM='dfw-prd-db-09.jetpay.com', \
#                     ENV_USERID='IST_DB_USERNAME', \
#                     PORTNO='1521', \
#                     ENV_PASSWD='IST_DB_PASSWORD', \
#                     SERVNM='clear1.jetpay.com')
# dbObject = DbClass(ENV_HOSTNM='IST_HOST', \
#                     ENV_USERID='IST_DB_USERNAME', \
#                     PORTNO='1521', \
#                     ENV_PASSWD='IST_DB_PASSWORD', \
#                     ENV_SERVNM='IST_SERVERNAME')


getStringValue = lambda testStr: (testStr if testStr else None)
# Print credentials.
print('userName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['USERID'])))
print('passWord = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['PASSWD'])))
print('hostName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['HOSTNM'])))
print('portNum = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['PORTNO'])))
print('serviceName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['SERVNM'])))

# sys.exit()        # In case you want to break out of the program

# print('testDbPooling: Calling Connect()')
testType = 'SINGLE'       # For testing single connection
# testType = 'POOLED'       # For testing pooled connection

# Test cases for single connection.
resultSet = None
if testType == 'SINGLE':
    myObject.Connect()
    print('\nTesting Single Connection: %s' % myObject.dbConnection)

    print('Testing Single Connection: Calling OpenCursor()\n')
    # Open a cursor. Need to keep track of the cursor being opened.
    cursorNumber = myObject.OpenCursor()
    print('1.  Test Single Connection: %s\nCursor count = %d\n' %
                (myObject.dbCursor[cursorNumber], cursorNumber))

    # Examples of queries with bind variables.
    # myDict = {'var1': 'varval1', 'var2': 'varval2', 'var3': 'varval3'}
    # sqlString = ('SELECT * FROM mytable ' + 'WHERE x = :var1 AND ' + 'y = :var2 AND '
    #                   + 'z = :var3')

    # myDict = {'var1': '107'}
    # sqlString = "SELECT * FROM masclr.mas_file_log mfl WHERE mfl.INSTITUTION_ID in (:var1)"
    # Testing using positional parameters.
    # myObject.ExecuteQuery(cursorNumber, sqlString, myDict)

    # myDict = {'var1': '107', 'var2': 'OKDMV'}
    # sqlString = ('Select * from MASCLR.MAS_FILE_TYPE_COUNT %s %s' %
    #             ('where INSTITUTION_ID = :var1 and',
    #                 'CATEGORY = :var2'))
    # Testing using positional parameters.
    # myObject.ExecuteQuery(cursorNumber, sqlString, myDict)

    # Using a simple query without host variables.
    # sqlString = "SELECT * FROM masclr.mas_file_log mfl WHERE mfl.INSTITUTION_ID in ('107')"
    # myObject.ExecuteQuery(cursorNumber, sqlString)

    myDict = {'var1': '107'}
    sqlString = "SELECT * FROM masclr.mas_file_log mfl WHERE mfl.INSTITUTION_ID in (:var1)"
    # Testing using combination of positional and named parameters. Note that
    # the order in which the named parameters are called does not matter.
    myObject.ExecuteQuery(cursorNumber, bindVars = myDict, sqlQuery = sqlString)

    print('2.  Test Single Connection: %s\n' % sqlString)

    # Fetch a few rows.
    resultSet = myObject.FetchResults(cursorNumber, 3)

    # Print fetched rows.
    if resultSet:
        for result in resultSet:
            print(result)
    else:
        print('No results returned from FetchResults()')

    sqlString = """
                    select decode(rownum, 1, 111, 2, 3, 3, 56) as col1,
                        decode(rownum, 1, 322, 2, 14, 3, 676) as col2
                    from dual
                    connect by level <= 3 """
    # Open another cursor. Need to keep track of the cursor being opened.
    cursorNumber2 = myObject.OpenCursor()
    print('3.  Test Single Connection with multiple cursors: %s\nCursor count = %d\n' %
                (myObject.dbCursor[cursorNumber2], cursorNumber2))
    # Excute query.
    myObject.ExecuteQuery(cursorNumber2, sqlString)

    resultSet = myObject.FetchResults(cursorNumber2)

    # Test insert from a csv file. Note this will result in an error since the mas.mytable
    # does not exist.
    insertSqlText = 'Insert into mas.mytable (col_1, col_2, col_3) VALUES(:1, :2, :3)'

    # myObject.InsertDataFromCsvFile(cursorNumber, insertSqlText, 'myCSVfile.csv', False,
    #                             delimiter = ',', quotechar = "'", skipinitialspace = True,
    #                             quoting = csv.QUOTE_MINIMAL)


    # sqlText = ("select TO_CHAR(sysdate, 'YYYY/MM/DD') AS DAY, %s %s" %
    #                 ("systimestamp AS TIMESTAMP, ", "'This is a test' AS TEST from dual"))

    sqlText = ('Select * from MASCLR.MAS_FILE_TYPE_COUNT %s %s' %
                ("where INSTITUTION_ID = '107' and",
                    "CATEGORY = 'OKDMV'"))

    print(sqlText, '\n')

    # Note that the positional parameters 1 - 6 must have values. The rest are keyword
    # arguments. It is recommended to make the positional arguments as named for clarity
    # but it is not necessary as long as they hold values.
    myObject.ExportDataFromTable(cursorNumber, outputFile = None, outputFilePath = None,
                                    includeHeaders = True, sqlText = sqlText,
                                    tableName = 'MAS_FILE_TYPE_COUNT',
                                    delimiter = ',', quotechar = "'", skipinitialspace = False,
                                    quoting = csv.QUOTE_MINIMAL)

    # Need to give cursor number to close the right cursor.
    myObject.CloseCursor(cursorNumber)
    myObject.CloseCursor(cursorNumber2)

    # Close the connection to database.
    myObject.Disconnect()

    if resultSet:
        for result in resultSet:
            print(result)
    else:
        print('No results returned from FetchResults()\n')


# Test cases for Connection Pooling.
if testType == 'POOLED':
    try:
        print('^^^^^^   TESTING FOR POOLED CONNECTIONS    ^^^^^^^\n')
        # The optional isDRCP flag must be set to True for connection pooling. Assume
        # default values for the rest of the named argument list.
        myObject.Connect(True)

        # Test to see what happens if you don't pass the isDRCP flag to Connect() method.
        # The connection is a regular connection but all methods using the connection pool
        # will fail.
        # myObject.Connect()

        # Get the number assigned by the object for the acquired connection.
        poolIndex_1 = myObject.AcquireConnection()
        print('poolIndex_1 = %d\n' % poolIndex_1)

        # Get the number assigned by the object for another aquired connection.
        poolIndex_2 = myObject.AcquireConnection()
        print('poolIndex_2 = %d\n' % poolIndex_2)

        # Test for maximum number of pools. Note the default is minimum of 3, maximum of 10
        # set by the class object. In this instance we did not specify the min max when the
        # connection object was created.
        # poolIndex_3 = myObject.AcquireConnection()
        # print('poolIndex_3 = %d' % poolIndex_3)
        # poolIndex_4 = myObject.AcquireConnection()
        # print('poolIndex_4 = %d' % poolIndex_4)
        # poolIndex_5 = myObject.AcquireConnection()
        # print('poolIndex_5 = %d' % poolIndex_5)
        # poolIndex_6 = myObject.AcquireConnection()
        # print('poolIndex_6 = %d' % poolIndex_6)
        # poolIndex_7 = myObject.AcquireConnection()
        # print('poolIndex_7 = %d' % poolIndex_7)
        # poolIndex_8 = myObject.AcquireConnection()
        # print('poolIndex_8 = %d' % poolIndex_8)
        # poolIndex_9 = myObject.AcquireConnection()
        # print('poolIndex_9 = %d' % poolIndex_9)
        # poolIndex_10 = myObject.AcquireConnection()
        # print('poolIndex_10 = %d' % poolIndex_10)
        # poolIndex_11 = myObject.AcquireConnection()
        # print('poolIndex_11 = %d' % poolIndex_11)

        # Get connection object from the connection pool.
        myConnection_1 = myObject.sessionsList[poolIndex_1]
        # print(myConnection_1)

        # Get the index to the Cursor object created for the above connection.
        cursorNumber_1 = myObject.OpenCursor(poolIndex_1)

        myDict = {'var1': '107'}
        sqlString = """
                        SELECT *
                        FROM masclr.mas_file_log mfl
                        WHERE mfl.INSTITUTION_ID in (:var1)"""
        print('testDbClass: %s \n' % sqlString)

        # Use the cursor index to execute the above SQL query.
        resultSet = myObject.ExecuteQuery(cursorNumber_1, sqlQuery = sqlString,
                                            bindVars = myDict)

        # Fetch the first 3 rows from the fetched rows. Omit the number of rows to fetch all.
        resultSet = myObject.FetchResults(cursorNumber_1, 3)

        if resultSet:
            for result in resultSet:
                print(result)
        else:
            print('1. No results returned from FetchResults()\n')

        # Close the cursor that was opened for the pooled connection.
        myObject.CloseCursor(cursorNumber_1)

        # Release connection back to the pool if you are done. You can also use:
        # myObject.sessionPool.release(myConnection_1).
        myObject.ReleaseConnection(poolIndex_1)
        print('1. Session released back to the pool...\n')

        sqlString = """
                        select decode(rownum, 1, 111, 2, 3, 3, 56) as col1,
                            decode(rownum, 1, 322, 2, 14, 3, 676) as col2
                        from dual
                        connect by level <= 3 """

        # Get a second connection object from the connection pool.
        myConnection_2 = myObject.sessionsList[poolIndex_2]
        print(myConnection_2, '\n')

        # Get the index to the Cursor object created for the above connection.
        cursorNumber_2 = myObject.OpenCursor(poolIndex_2)

        # Use the cursor index to execute the second SQL query.
        resultSet = myObject.ExecuteQuery(cursorNumber_2, sqlString)

        # Fetch all the rows in the result set. Note: the number of rows is not an argument
        # to the ExecuteQuery().
        resultSet = myObject.FetchResults(cursorNumber_2)

        if resultSet:
            for result in resultSet:
                print(result)
        else:
            print('2. No results returned from FetchResults()')


        # Close the second cursor that was opened for the pooled connection.
        myObject.CloseCursor(cursorNumber_2)

        # Test for Rollback and Commit.
        myObject.Rollback(poolIndex_2)
        myObject.Commit(poolIndex_2)

        # Release connection back to the pool if you are done. You can also use:
        # myObject.sessionPool.release(myConnection_2)
        myObject.ReleaseConnection(poolIndex_2)

        # Get the number assigned by the object for another acquired connection.
        poolIndex_3 = myObject.AcquireConnection()
        # Get connection object from the connection pool.
        myConnection_3 = myObject.sessionsList[poolIndex_3]
        # Get the index to the Cursor object created for the above connection.
        cursorNumber_3 = myObject.OpenCursor(poolIndex_3)
        # print(myConnection_1)
        # Test insert from a csv file. Note this will result in an error since the mas.mytable
        # does not exist.
        insertSqlText = 'Insert into mas.mytable (col_1, col_2, col_3) VALUES(:1, :2, :3)'

        # myObject.InsertDataFromCsvFile(cursorNumber_3, insertSqlText, 'myCSVfile.csv', False,
        #                                 delimiter = ',', quotechar = "'",
        #                                 skipinitialspace = True, quoting = csv.QUOTE_MINIMAL)


        # sqlText = ("select TO_CHAR(sysdate, 'YYYY/MM/DD') AS DAY, %s %s" %
        #                 ("systimestamp AS TIMESTAMP, ", "'This is a test' AS TEST from dual"))

        sqlText = ('Select * from MASCLR.MAS_FILE_TYPE_COUNT %s %s' %
                    ("where INSTITUTION_ID = '107' and",
                        "CATEGORY = 'OKDMV'"))

        # print(sqlText, '\n')

        # Note that the positional parameters 1 - 6 must have values. The rest are keyword
        # arguments. It is recommended to make the positiona arguments as named for clarity
        # but it is not necessary as long as they hold values.
        myObject.ExportDataFromTable(cursorNumber_3, outputFile = None, outputFilePath = None,
                                        includeHeaders = True, sqlText = sqlText,
                                        tableName = 'MAS_FILE_TYPE_COUNT',
                                        delimiter = ',', quotechar = "'",
                                        skipinitialspace = False, quoting = csv.QUOTE_MINIMAL)

        # Close the second cursor that was opened for the pooled connection.
        myObject.CloseCursor(cursorNumber_3)

        # Release connection back to the pool if you are done. You can also use:
        # myObject.sessionPool.release(myConnection_3)
        myObject.ReleaseConnection(poolIndex_3)

        print('2. Session released back to the pool...')
        myObject.Disconnect()

    except cx_Oracle.DatabaseError as exception:
        error, = exception
        # print('Database connection error: %s'.format(dbException))
        print('Database connection pool error\n\tError Code: ', error.code)
        print('\n\tError Message: ', error.message)
        print('\n\tError Context: ', error.context)

        # chekc if session was killed (ORA-00028).
        session_killed = 28
        if error.code == session_killed:
            #
            # drop session from the pool in case
            # your session has been killed!
            # Otherwise pool.busy and pool.opened
            # will report wrong counters.
            #
            # myPool.drop(connection)
            print('Session droped from the pool...')
    # else:
        # if you're done with procession you can return session
        # back to the pool
        # myCursor.close()
        # myPool.release(myConnection)
        # print('Session released back to the pool...')


print('testDbPooling: myObject.errorCode = %s' %  myObject.errorCode)

# Connection Pooling
# https://gist.github.com/Calzzetta/59e4bb50edd8ac30a6d9
# https://blogs.oracle.com/opal/python-cxoracle-and-oracle-11g-drcp-connection-pooling
# http://cx-oracle.readthedocs.io/en/latest/session_pool.html
# http://cx-oracle.readthedocs.io/en/latest/installation.html
# https://vladmihalcea.com/2014/04/17/the-anatomy-of-connection-pooling/

# cx_Oracle.SessionPool(user, password, dsn, min, max, increment,
#                       connectiontype=cx_Oracle.Connection, threaded=False,
#                       getmode=cx_Oracle.SPOOL_ATTRVAL_NOWAIT, events=False,
#                       homogeneous=True, externalauth=False, encoding=None,
#                       nencoding=None, edition=None)

