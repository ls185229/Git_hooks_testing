#!/usr/bin/env python

"""
A general purpose Python class for database access and data manipulation.
    $Id: dbClassDefs.py 4442 2017-12-05 18:35:25Z lmendis $
"""
import cx_Oracle
import csv
import os

"""
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        An Oracle database class for accessing basic database functionality.
        Source: Class design adapted from the following: 
            https://stackoverflow.com/questions/7465889/cx-oracle-and-exception-handling-good-practices
        Other Reference:
            https://dbaportal.eu/sidekicks/sidekick-cx_oracle-code-paterns/
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"""

class LocalException(Exception):
    # The local exception class is derived from the Python base exception class. It is
    # used to throw other types of exceptions that are not in the standard exception 
    # class.
 
    # Constructor or Initializer
    def __init__(self, errorValue):
        self.value = errorValue
 
    # __str__ is to print() the value
    def __str__(self):
        return(repr(self.value))


class DbClass(object):
    # Private class attributes (Note: A single prefixed '_' indicates Protected and a 
    # double '__' denotes a Private attribute).
    __dbOpened = False          # An object can only open one database
    __cursorOpened = []         # An object can open multiple cursors
    __dbCredentials = {}        # Define a dictionary variable to store database 
                                # login credentials
    __errorCode = 0
    __errorMessage = None

    # Public attributes
    dbConnection = None         # An object can only be associated with one database. So if 
                                # you need to access multiple databases, you need to create
                                # multiple database class objects with the appropriate 
                                # credentials.
    dbCursor = []               # An object can have multiple cursors
    resultSet = None
    sessionPool = None
    sessionsList = []           # A list of sessions acquired for DRCP


    # -----------------------  __CheckMissingCredentials__()  -----------------------
    def __CheckMissingCredentials__(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CheckMissingCredentials__()   
                Checks for missing credentials and returns an error message based 
                on what credentials are missing.
    
            Parameters: 
                None.   
    
            Returns:
                Returns an error message if there is missing credentials.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # HOSTNM is not in the dictionary or has no value
        if 'HOSTNM' not in self.__dbCredentials.keys():
            return ('Missing credentials for database %s%s' %
                            ('connectivity. Please ensure the HOSTNM, ', 
                            'is passed when instantiating the class object.'))
        elif not self.__dbCredentials.get('HOSTNM'):
            return ('HOSTNM field has no value. Please ensure all credentials %s' 
                        % 'are passed when instantiating the class object.')

        # USERID is not in the dictionary or has no value
        if 'USERID' not in self.__dbCredentials.keys():
            return ('Missing credentials for database %s%s' %
                            ('connectivity. Please ensure the USERID, ', 
                            'is passed when instantiating the class object.'))
        elif not self.__dbCredentials.get('USERID'):
            return ('USERID field has no value. Please ensure all credentials %s' 
                        % 'are passed when instantiating the class object.')

        # PASSWD is not in the dictionary or has no value
        if 'PASSWD' not in self.__dbCredentials.keys():
            return ('Missing credentials for database %s%s' %
                            ('connectivity. Please ensure the PASSWD, ', 
                            'is passed when instantiating the class object.'))
        elif not self.__dbCredentials.get('PASSWD'):
            return ('PASSWD field has no value. Please ensure all credentials %s' 
                        % 'are passed when instantiating the class object.')

        # SERVNM is not in the dictionary or has no value
        if 'SERVNM' not in self.__dbCredentials.keys():
            return ('Missing credentials for database %s%s' %
                            ('connectivity. Please ensure the SERVNM, ', 
                            'is passed when instantiating the class object.'))
        elif not self.__dbCredentials.get('SERVNM'):
            return ('SERVNM field has no value. Please ensure all credentials %s' 
                        % 'are passed when instantiating the class object.')

        return None


    # -------------------------         __init__()         -------------------------
    def __init__(self, *positionalArgs, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__():
                Initializes the database object attributes.
    
                NOTE: There are several ways to pass arguments to initialize the 
                database object. One way is to pass them in positional order meaning
                that positional value order (Host Name, User ID, Password, Service 
                Name and optional Port Number). Another way is to pass using key word
                arguments in any order (HOSTNM = 'Something', USERID = 'Something',
                PASSWD = 'SomeThing', SERVNM = 'Something'). The keywords must match 
                as indicated here. You could also use a combination of positional and 
                keyword parameters but the positional parameters must be passed prior 
                to the keyword parameters but the positional parameters must be ordered 
                and cannot have missing value between two ajacent parameters.
        
                Keyword arguments can also be obtained from the environment variables. 
                in order to indicate that they are to be obtained from the enviroment
                variable settings, the keyword must be prefixed with ENV_ like ENV_HOSTNM
                or ENV_USERID so on and so forth.
                
            Parameters: 
                positionalArgs - Positional argument values
                keywordArgs    - Keyword argument values
        
                Ex:
                    HOSTNM - Database host name (dfw-prd-db-09.jetpay.com)
                    USERID - Database login ID  (johndoe)
                    PASSWD - Database password
                    SERVNM - Service name (clear1.jetpay.com)
                    PORTNO - Port number the database is listening to (usually 1521)
    
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # Check if a value passed to the lambda is a string and return the 
            # appropriate values
            getStringValue = lambda testStr: (testStr if testStr else None)

            argNum = 1

            # Check if it is positional arguments then, initialize the class object 
            # attributes. 
            # THE ORDER FOR POSITIONAL ARGUMENTS MATTER: Host Name, User ID, Passsword, 
            # Service Name, and Port Number. 
            # NOTE: __dbCredentials is a dictionary 
            if positionalArgs:
                for arguments in positionalArgs:
                    # Initialize the class object attributes. The order for positional
                    # arguments is: Host Name, User ID, Passsword, Service Name, and
                    # Port Number. 
                    if argNum == 1:
                        self.__dbCredentials.update({'HOSTNM': getStringValue(arguments)})
                    elif argNum == 2:
                        self.__dbCredentials.update({'USERID': getStringValue(arguments)})
                    elif argNum == 3:
                        self.__dbCredentials.update({'PASSWD': getStringValue(arguments)})
                    elif argNum == 4:
                        self.__dbCredentials.update({'SERVNM': getStringValue(arguments)})
                    elif argNum == 5:
                        self.__dbCredentials.update({'PORTNO': getStringValue(arguments)})

                    argNum += 1

            # Check if there are any keyword arguments
            if keywordArgs:
                # Read the keyword arguments into a temporary dictionary
                keywordDict = {}
                for keyWord in keywordArgs:
                    # Check to see if a keyword parameter has an ENV_ prefix. If so, get
                    # the the value from the environment variable. If some of the variables
                    # are obtained from the environment, then the expectation is that the
                    # keyword is prfixed with ENV_ (case does not matter). Ex. env_HOSTNM
                    if 'ENV_' in keyWord.upper():
                        tempKeyWord = keyWord[4:].upper()   # Remove the ENV_ from keyword  
                        keywordDict.update({tempKeyWord: keywordArgs[keyWord]})

                        self.__dbCredentials.update({tempKeyWord: 
                                        os.environ.get(keywordDict[tempKeyWord])})
                    else:
                        keywordDict.update({keyWord: keywordArgs[keyWord]})
                        self.__dbCredentials.update({keyWord: keywordDict[keyWord]})
                        
                    argNum += 1         

            # There has to be a total of five positional and keyword arguments
            if argNum == 1:
                # No arguments passed at the time of object initialization, so raise
                # an exception
                self.__errorMessage = ('No credentials provided for database %s%s%s' %
                                        ('connectivity. Please ensure the HOSTNM, ', 
                                        'USERID, PASSWD, SERVNM and PORTNO are passed ',  
                                        'when instantiating the class object.'))
                raise(LocalException(self.__errorMessage))

            # If the port number is still not assigned, then default it to 1521 
            if 'PORTNO' not in self.__dbCredentials:
                self.__dbCredentials.update({'PORTNO': str(1521)})
                argNum += 1

            # Now check for missing values 
            self.__errorMessage = self.__CheckMissingCredentials__()
            if self.__errorMessage is not None:
                raise(LocalException(self.__errorMessage))

        except LocalException as error:
            self.__errorCode = 1
            print('Error occurred in DbClass __init__():\n   ', error.value)


    # -------------------------          Connect()          -------------------------
    def Connect(self, isDRCP = False, minSessions = 1, maxSessions = 10, poolIncrement = 1,
                    isThreaded = False, getMode = None, isHomogeneous = True):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Connect(self):
                Connect to the database using the credentials passed to the class 
                method.
            
            Parameters:
                isDRCP        - Is the connection using DRCP pooling.
                minSessions   - Minimum number of connections in the session pool.
                maxSessions   - Maximum number of connections in the session pool.
                poolIncrement - Number of sessions by which to increment the pool.
                isThreaded    - Flag to indicate threading. False by default.
                getMode       - SPOOL_ATTRVAL_NOWAIT, SPOOL_ATTRVAL_WAIT, 
                                SPOOL_ATTRVAL_FORCEGET.
                isHomogeneous - Defaulted to True. If pool is not homogeneous, then 
                                different authentication can be used for each 
                                commection in the pool.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            if not isDRCP: 
                self.dbConnection = cx_Oracle.connect( self.__dbCredentials['USERID'], 
                                        self.__dbCredentials['PASSWD'], 
                                        ('%s:%s/%s' % (self.__dbCredentials['HOSTNM'],
                                            str(self.__dbCredentials['PORTNO']),
                                                self.__dbCredentials['SERVNM'])))
            else:   # Use session pooling for multiple connections to database
                dsnName = cx_Oracle.makedsn(self.__dbCredentials['HOSTNM'], 
                            str(self.__dbCredentials['PORTNO']), sid = None, 
                            service_name = self.__dbCredentials['SERVNM'], region = None, 
                            sharding_key = None)
                            # sharding_key = None, super_sharding_key = None)

                if getMode == 'WAIT':
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_WAIT
                elif getMode == 'FORCEGET':
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_FORCEGET
                else:
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_NOWAIT

                # Use Oracle DRCP (Database Resident Connection Pooling)
                self.sessionPool = cx_Oracle.SessionPool(
                                    user = self.__dbCredentials['USERID'], 
                                    password = self.__dbCredentials['PASSWD'], 
                                    dsn = dsnName, 
                                    min = minSessions, 
                                    max = maxSessions,
                                    increment = poolIncrement,
                                    connectiontype = cx_Oracle.Connection,
                                    threaded = isThreaded,
                                    getmode = poolGetMode,
                                    homogeneous = isHomogeneous)

                # Set session pool time out for idle connections.
                self.sessionPool.timeout = 50       # 50 seconds

                # Set a flag to indicate database connection  pooling is in use
                self.__isConnectionPooling = True
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            if error.code == 1017:
                print('Please check your credentials.')
                self.__errorCode = 2
            else:
                # print('Database connection error: %s'.format(dbException))
                print('Database connection error.\n    Error Code:', error.code)
                print('\n    Error Message: ', error.message)
                print('\n    Error Context: ', error.context)
                self.__errorCode = 3

            # Very important part!
            raise
        else:
            self.__dbOpened = True


    # -------------------------        OpenCursor()        -------------------------
    def OpenCursor(self, poolIndex = -1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            OpenCursor(self):
                Create a cursor if the connection was successful.
            
            Parameters:
                poolIndex - Index to the pooled connections list
            Returns:
                The index number assigned for the cursor that was opened.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if self.sessionPool:
                self.dbCursor.append(self.sessionsList[poolIndex].cursor())
            elif self.__dbOpened:
                self.dbCursor.append(self.dbConnection.cursor())
            else:
                self.__errorMessage = (
                                'A connection to the database has not been established.')
                raise(LocalException(self.__errorMessage))
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to open cursor.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 4

            # Very important part!
            raise
        except LocalException as error:
            self.__errorCode = 5
            print('Error occurred in DbClass OpenCursor():\n   ', error.value)
        else:
            self.__cursorOpened.append(True)
            return len(self.dbCursor) - 1   


    # -------------------------        CloseCursor()        -------------------------
    def CloseCursor(self, cursorNumber):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CloseCursor():
                Closes the cursor.
            
            Parameters:
                cursorNumber - Index assigned to the cursor when it was originally
                               opened in the OpenCursor() method.
    
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # Close cursor if it is in the list of cursors that were opened.
            if self.__cursorOpened[cursorNumber]:
                self.dbCursor[cursorNumber].close()
                self.__cursorOpened[cursorNumber] = False
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to close cursor.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            pass


    # -------------------------        Disconnect()        -------------------------
    def Disconnect(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Disconnect():
                Disconnects from the database. If this fails, for instance if the 
                connection instance doesn't exist we don't really care.
            
            Parameters:
                None.   
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # Close database connection
            if self.__dbOpened:
                if not self.sessionPool:
                    self.dbConnection.close()
                    self.__dbOpened = False
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to disconnect from the database.\n    Error Code:', 
                    error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            pass


    # -------------------------       ExecuteQuery()       -------------------------
    def ExecuteQuery(self, cursorNumber, sqlQuery, bindVars = None, commitFlag = False):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ExecuteQuery():
                Execute an SQL statement to query a database and get the results.
                Commit if specified.  Note that the same resultSet is used for
                ExecuteQuery() and FetchResults(), so it is recommended that the 
                calling program assign the resultSet to a local variable and then
                manupulate the results locally.
            
            Do not specify fetchall() here as the SQL statement may not be a select.
            
            Parameters: 
                cursorNumber - Cursor number for which the query is executed.   
                sqlQuery     - SQL query to execute.
                Bindvars     - A dictionary of bind variables required to execute the
                               query.
                commitFlag   - Flag indicating whether to commit or not.
            Returns:
                The result set from executing the query.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # An example of calling a query with bind variables:
            #    named_params = {'dept_id':50, 'sal':1000}
            #    query1 = cursor.execute('SELECT * FROM employees WHERE 
            #                       department_id=:dept_id AND salary>:sal', named_params)

            if bindVars:
                self.resultSet = self.dbCursor[cursorNumber].execute(sqlQuery, bindVars)
            else:
                self.resultSet = self.dbCursor[cursorNumber].execute(sqlQuery)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to execute query.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 6

            # Raise the exception.
            raise
        else:
            # Only commit if it is necessary.
            if commitFlag:
                self.dbConnection.commit()

            return self.resultSet


    # -------------------------       FetchResults()       -------------------------
    def FetchResults(self, cursorNumber, numRows = 0):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            FetchResults():
                Based on the arguments passed, calls the cx_Oracle fetchall() or 
                fetchmany() methods to fetch the results from executing the SQL 
                query.  Note that the same resultSet is used for FetchResults() and 
                ExecuteQuery(), so it is recommended that the calling program assign 
                the resultSet to a local variable and then manupulate the results 
                locally.
    
            Parameters:
                cursorNumber - Cursor number for which the results are fetched.
                numRows      - The number of rows to fetch if specified. Default is all 
                               rows.
    
            Returns:
                The result set from fetching the cursor.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            if numRows:
                self.resultSet = self.dbCursor[cursorNumber].fetchmany(numRows)
            else:
                self.resultSet = self.dbCursor[cursorNumber].fetchall()
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database execution error.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 7
            raise
        else:
            return self.resultSet


    # -------------------------          Commit()          -------------------------
    def Commit(self, poolIndex = -1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Commit():
                Commits the query results.
        
            Parameters: 
                poolIndex - Index to the pooled connections list
    
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            if self.sessionPool:
                self.sessionsList[poolIndex].commit()
            else:
                self.dbConnection.commit()
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to commit updates.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 8
            raise


    # -------------------------         Rollback()         -------------------------
    def Rollback(self, poolIndex = -1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Rollback():
                Rollback the transaction.
        
            Parameters: 
                poolIndex - Index to the pooled connections list
    
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            if self.sessionPool:
                self.sessionsList[poolIndex].rollback()
            else:
                self.dbConnection.rollback()
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to rollback updates.\n    Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 9
            raise


    # -------------------------     AcquireConnection()     -------------------------
    def  AcquireConnection(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            AcquireConnection():
                Acquires a connection for a single session in the DRCP pool. Applies
                only if you are using connection pooling.
        
            Parameters: 
                None.
    
            Returns:
                The index to the sessionsList list.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # Acquire a connection only if the class object created is for a database
            # connection pool
            if self.sessionPool:
                # Check and make sure there are enough sessions available in the session
                # pool to acquire one.
                activeCount = 0
                for numSessions in self.sessionsList:
                    if numSessions:
                        activeCount += 1

                if activeCount > self.sessionPool.max - 1:
                    self.__errorMessage = ('Maximum number of database connection %s %s'
                                            % ('pools reached. There are no more sesseion', 
                                            'pools available.'))
                    raise(LocalException(self.__errorMessage))
            else:
                self.__errorMessage = ('There is no database connection pool open to %s' 
                                        % 'aquire a connection.') 
                raise(LocalException(self.__errorMessage))
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to acquire a database connection.\n    Error Code:', 
                    error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 10
            raise
        except LocalException as error:
            self.__errorCode = 11
            print('Error occurred in DbClass AcquireConnection():\n   ', error.value)
        else:
            self.sessionsList.append(self.sessionPool.acquire())
            # Return the current index of the sessionsList list
            return len(self.sessionsList) - 1


    # -------------------------     ReleaseConnection()     -------------------------
    def  ReleaseConnection(self, poolIndex):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ReleaseConnection():
                Releases the connection back to the DRCP connection pool. Applies
                only if you are using connection pooling.
        
            Parameters: 
                poolIndex - Index to the pooled connections list
    
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            if self.sessionPool:
                self.sessionPool.release(self.sessionsList[poolIndex])
            else:
                self.__errorMessage = ('Connection was not created using the Database %s %s'
                                        % ('Resident Connections pooling. Unable to', 
                                            'release the connection.'))
                raise(LocalException(self.__errorMessage))
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to release the database connection.\n    ',
                    'Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 12
            raise
        except LocalException as error:
            self.__errorCode = 13
            print('Error occurred in DbClass ReleaseConnection():\n   ', error.value)


    # -------------------------   InsertDataFromCsvFile()   -------------------------
    def InsertDataFromCsvFile(self, cursorNumber, insertSql, fileName, commitFlag,
                                **csvKeywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            InsertDataFromCsvFile():    
                This method is used to insert bulk data from a csv file to the 
                database.
            
            Parameters: 
                cursorNumber     - Cursor number used to insert data.
                sqlQuery         - Insert SQL statement to execute.
                fileName         - The nput csv file name with path.
                commitFlag       - Flag indicating whether to commit or not.
                **csvKeywordArgs - csv.reader() function takes the following keyword
                                   arguments. NOTE: This is the keyword argument list
                                   for the python csv reader object. It cannot contain
                                   any keywords other than the ones specified in the 
                                   function header.
    
                    quotechar        - Specifies a one-character string to use as the 
                                       quoting character. It defaults to '"'. Setting 
                                       this to None has the same effect as setting 
                                       quoting to csv.QUOTE_NONE.
                    delimiter        - Specifies a one-character string to use as the 
                                       field separator. It defaults to ','.
                    escapechar       - Specifies a one-character string used to escape 
                                       the delimiter when quotechar is set to None.
                    skipinitialspace - Specifies how to interpret whitespace which 
                                       immediately follows a delimiter. It defaults to 
                                       False, which means that whitespace immediately 
                                       following a delimiter is part of the following 
                                       field.
                    lineterminator   - Specifies the character sequence which should 
                                       terminate rows.
                    quoting          - Controls when quotes should be generated by the 
                                       writer. It can take on any of the following module 
                                       constants:
                                            csv.QUOTE_MINIMAL - Means only when required, 
                                                for example, when a field contains either 
                                                the quotechar or the delimiter
                                            csv.QUOTE_ALL - Means that quotes are always 
                                                placed around fields.
                                            csv.QUOTE_NONNUMERIC - Means that quotes are 
                                                always placed around nonnumeric fields.
                                            csv.QUOTE_NONE - Means that quotes are never 
                                                placed around fields.
                    doublequote      - Controls the handling of quotes inside fields. When 
                                       True two consecutive quotes are interpreted as one 
                                       during read, and when writing, each quote is written 
                                       as two quotes.
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            with open(fileName, mode = 'r', newline = '') as csvFile:
                # Initialize list that will serve as a container for bind values
                csvDataList = []

                # Read the csv file using the python csv reader object
                csvReaderObj = csv.reader(csvFile, **csvKeywordArgs)
 
                # Create a list for each row of data found in the csv file
                for csvRow in csvReaderObj:
                    # Remove the leading and trailing white spaces if any from the input.
                    # You can remove the white space immediately following a delimiter by
                    # setting the skipinitialspace keyword in the keywardArg list to True.
                    for itemIndex in range(len(csvRow)):
                        csvRow[itemIndex] = csvRow[itemIndex].strip()

                    # Append the row to the list
                    csvDataList.append(tuple(csvRow)) 

                # Sample SQL statement for bulk inserts. Note that the input lines in the csv
                # file must match the columns specified in the SQL statement.
                #
                # insertSql = 
                #       "INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
                #       VALUES (:1, :2, :3, :4, to_date(:5,'DD.MM.YYYY'), :6, :7, :8)"

                # Prepare insert statement
                self.dbCursor[cursorNumber].prepare(insertSql)
 
                # Execute insert with executemany
                self.dbCursor[cursorNumber].executemany(None, csvDataList)
 
        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to insert data from csv file.\n    Error Code:', 
                    error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 14

            # Raise the exception.
            raise
        else:
            # Report number of inserted rows
            # print('Inserted: ' + str(self.dbCursor[cursorNumber].rowcount) + ' rows.')
 
            if commitFlag:
                self.dbConnection.commit()


    # -------------------------    ExportDataFromTable()    -------------------------
    def  ExportDataFromTable(self, cursorIndex, outputFile, outputFilePath, includeHeaders, 
                                sqlText, tableName, **csvKeywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ExportDataFromTable():
                Exports data from an Oracle database table into a csv file.
        
            Parameters: 
                cursorIndex       - Index to the cursor object.
                outputFile        - Optional Output csvFile name. 
                outputFilePath    - Optional path to the outFile.
                includeHeaders    - Optional flag if column headers are needed.
                sqlText           - Optional SQL text if you do not want to export all 
                                    table columns.
                tableName         - Table name in case the output file name is not given.
                **csvKeywordArgs  - csv.reader() function takes the following keyword
                                    arguments. NOTE: This is the keyword argument list
                                    for the python csv reader object. It cannot contain
                                    any keywords other than the ones specified in the 
                                    function header.
    
                    quotechar        - Specifies a one-character string to use as the 
                                       quoting character. It defaults to '"'. Setting 
                                       this to None has the same effect as setting 
                                       quoting to csv.QUOTE_NONE.
                    delimiter        - Specifies a one-character string to use as the 
                                       field separator. It defaults to ','.
                    escapechar       - Specifies a one-character string used to escape 
                                       the delimiter when quotechar is set to None.
                    skipinitialspace - Specifies how to interpret whitespace which 
                                       immediately follows a delimiter. It defaults to 
                                       False, which means that whitespace immediately 
                                       following a delimiter is part of the following 
                                       field.
                    lineterminator   - Specifies the character sequence which should 
                                       terminate rows.
                    quoting          - Controls when quotes should be generated by the 
                                       writer. It can take on any of the following module 
                                       constants:
                                            csv.QUOTE_MINIMAL - Means only when required, 
                                                for example, when a field contains either 
                                                the quotechar or the delimiter
                                            csv.QUOTE_ALL - Means that quotes are always 
                                                placed around fields.
                                            csv.QUOTE_NONNUMERIC - Means that quotes are 
                                                always placed around nonnumeric fields.
                                            csv.QUOTE_NONE - Means that quotes are never 
                                                placed around fields.
                    doublequote      - Controls the handling of quotes inside fields. When 
                                       True two consecutive quotes are interpreted as one 
                                       during read, and when writing, each quote is written 
                                       as two quotes.
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try: 
            # Ensure the SQL text is provided
            if not sqlText:
                self.__errorMessage = ('Must provide the SQL statements to extract %s%s'
                                            % ('data from the table. Please invoke the ',
                                                'function with the correct argument list.'))
                raise(LocalException(self.__errorMessage))
            else:
                queryResult = self.ExecuteQuery(cursorIndex, sqlText) 

            # If the output file path is given append it 
            if outputFilePath:
                # If output file name is not provided, prefix the table name to the csv file
                if not outputFile:
                    outputFile = ('%s/%s.csv' % (outputFilePath, tableName))
                else:
                    outputFile = ('%s/%s' % (outputFilePath, outputFile)) 
            else:
                if not outputFile:
                    outputFile = ('%s.csv' % tableName)

            # Open the output csv file
            with open(outputFile, mode = 'w+', newline = '') as csvFile:
                fileOpen = True
                csvWriterObj = csv.writer(csvFile, dialect = 'excel', **csvKeywordArgs)

                # Get the column headers from the results
                if includeHeaders:
                    tableColumns = []
                    for eachColumn in self.dbCursor[cursorIndex].description:
                        # print('Columns:\n', eachColumn[0])
                        tableColumns.append(eachColumn[0]) 
                    # Write the column headers to the csv file
                    csvWriterObj.writerow(tableColumns)

                # Now write the extracted data to the csv file
                for rowData in queryResult:
                    csvWriterObj.writerow(rowData)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            print('Database error - Unable to extract data for exporting to Excel. .\n    ',
                    'Error Code:', error.code)
            print('\n    Error Message: ', error.message)
            print('\n    Error Context: ', error.context)
            self.__errorCode = 15
            raise
        except LocalException as error:
            self.__errorCode = 16
            print('Unable to execute SQL statement to extract data in %s' 
                    % 'ExportDataFromTable():\n ', error.value)
        finally:
            if fileOpen:
                csvFile.close()

