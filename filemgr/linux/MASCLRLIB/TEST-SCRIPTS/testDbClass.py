#!/usr/bin/env python

import os
from dbClassDefs import DbClass
import cx_Oracle

print('Calling testClass script')

# Print the OS environment variables
# for envs in os.environ:
#   print('[%s]: %s' % (envs, os.getenv(envs)))

# myObject = DbClass('dfw-qa-db-01@jetpay.com', 'lmendis', 'my@password', 
#                   'authqa.jetpay.com', 1521)
# myObject = DbClass('dfw-qa-db-01@jetpay.com', 'lmendis', 'my@password', 
#                   'authqa.jetpay.com')
# myObject = DbClass(HOSTNM = 'dfw-prd-db-09.jetpay.com', USERID = 'masclr', PORTNO = '1521',
#                   PASSWD = 'masclr', SERVNM = 'clear1.jetpay.com')
# myObject = DbClass(HOSTNM = 'dfw-qa-db-01.jetpay.com', PORTNO = '1521', USERID = 'lmendis', 
#                   PASSWD = 'CJcaQLQ1', SERVNM = 'authqa.jetpay.com')
# myObject = DbClass()
myObject = DbClass('dfw-qa-db-01@jetpay.com', env_userid = 'USER', 
                    PASSWD = 'CJcaQLQ1', SERVNM = 'service@jetpay.com')
# myObject = DbClass('dfw-qa-db-01@jetpay.com', USERID = 'USER', 
#                   SERVNM = 'service@jetpay.com')


getStringValue = lambda testStr: (testStr if testStr else None)
print('userName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['USERID'])))
print('passWord = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['PASSWD'])))
print('hostName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['HOSTNM'])))
print('portNum = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['PORTNO'])))
print('serviceName = {0}'.format(getStringValue(myObject._DbClass__dbCredentials['SERVNM'])))

print('testDbClass: Calling Connect()')
# testType = 'SINGLE'       # For testing single connection
testType = 'POOLED'     # For testing pooled connection

# Test for single connection
resultSet = None
if testType == 'SINGLE':
    myObject.Connect()
    print('testDbClass: %s' % myObject.dbConnection)

    print('testDbClass: Calling OpenCursor()')
    myObject.OpenCursor()
    print('testDbClass: %s' % myObject.dbCursor)

    # myDict = {'var1': 'varval1', 'var2': 'varval2', 'var3': 'varval3'}  
    # sqlString = 'SELECT * FROM mytable ' + 'WHERE x = :var1 AND ' + 'y = :var2 AND ' + 'z = :var3'
    # sqlString = "SELECT * FROM masclr.mas_file_log mfl WHERE mfl.INSTITUTION_ID in ('107')"
    # resultSet = myObject.ExecuteQuery(sqlString )
    # myObject.ExecuteQuery('SELECT * FROM mytable', ':var, varval')
    myDict = {'var1': '107'}
    sqlString = "SELECT * FROM masclr.mas_file_log mfl WHERE mfl.INSTITUTION_ID in (:var1)"
    print('testDbClass: %s' % sqlString)
    resultSet = myObject.ExecuteQuery(sqlString, myDict)

    # resultSet = myObject.FetchResults()
    resultSet = myObject.FetchResults(5)
    myObject.CloseCursor()
    myObject.Disconnect()

# myObject.CloseCursor()
# myObject.Disconnect()

# Test for Connection Pooling
if testType == 'POOLED':
    try:
        print('^^^^^^   TESTING FOR POOLED CONNECTIONS    ^^^^^^^')
        myObject.Connect(True)
        myPool = myObject.sessionPool
        myConnection = myPool.acquire()
        myCursor = myConnection.cursor()

        myDict = {'var1': '107'}
        sqlString = """
                        SELECT * 
                        FROM masclr.mas_file_log mfl 
                        WHERE mfl.INSTITUTION_ID in (:var1)"""
        print('testDbClass: %s' % sqlString)

        myCursor.execute(sqlString, myDict)

        resultSet = myCursor.fetchmany(3)

        if resultSet:
            for result in resultSet:
                print(result)
        else:
            print('1. No results returned from FetchResults()')

        myCursor.close()
        myPool.release(myConnection)
        print('1. Session released back to the pool...')

        myConnection = myPool.acquire()
        myCursor = myConnection.cursor()
        sqlString = """
                        select decode(rownum, 1, 111, 2, 3, 3, 56) as col1,
                            decode(rownum, 1, 322, 2, 14, 3, 676) as col2
                        from dual
                        connect by level <= 3 """
        myCursor.execute(sqlString)

        resultSet = myCursor.fetchall()

        if resultSet:
            for result in resultSet:
                print(result)
        else:
            print('2. No results returned from FetchResults()')


        myCursor.close()
        myPool.release(myConnection)
        print('2. Session released back to the pool...')

    except cx_Oracle.DatabaseError as exception:
        error, = exception
        # print('Database connection error: %s'.format(dbException))
        print('Database connection pool error\n\tError Code: ', error.code)
        print('\n\tError Message: ', error.message)
        print('\n\tError Context: ', error.context)

        # chekc if session was killed (ORA-00028)
        session_killed = 28
        if error.code == session_killed:
            #
            # drop session from the pool in case
            # your session has been killed!
            # Otherwise pool.busy and pool.opened
            # will report wrong counters.
            #
            myPool.drop(connection)
            print('Session droped from the pool...')
    # else:
        # if you're done with procession you can return session
        # back to the pool
        # myCursor.close()
        # myPool.release(myConnection)
        # print('Session released back to the pool...')


if resultSet:
    for result in resultSet:
        print(result)
else:
    print('No results returned from FetchResults()')

print('testDbClass: %s' %  myObject._DbClass__errorCode)

# Connection Pooling
# https://gist.github.com/Calzzetta/59e4bb50edd8ac30a6d9
# https://blogs.oracle.com/opal/python-cxoracle-and-oracle-11g-drcp-connection-pooling
# http://cx-oracle.readthedocs.io/en/latest/session_pool.html
# http://cx-oracle.readthedocs.io/en/latest/installation.html

# cx_Oracle.SessionPool(user, password, dsn, min, max, increment, 
#                       connectiontype=cx_Oracle.Connection, threaded=False, 
#                       getmode=cx_Oracle.SPOOL_ATTRVAL_NOWAIT, events=False, 
#                       homogeneous=True, externalauth=False, encoding=None, 
#                       nencoding=None, edition=None)


