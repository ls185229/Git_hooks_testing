#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A general purpose Python class for database access and data manipulation.
    $Id: database_class.py 4548 2018-04-27 16:00:44Z lmendis $
"""

import csv
import os
import inspect
import textwrap
import cx_Oracle

# Add pylint directives to suppress warnings you don't want it to report
# as warnings. Note they need to have the hash sign as shown below.
# pylint: disable = invalid-name

class LocalException(Exception):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A local exception class to post exceptions local to this module.

            The local exception class is derived from the Python base
            exception class. It is used to throw other types of exceptions
            that are not in the standard exception class.

        Author:
            Leonard Mendis

        Date Created:
            December 11, 2017

        Modified By:

        References:
            https://www.geeksforgeeks.org/user-defined-exceptions-python-examples/

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)


class DbClass(object):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            An Oracle database class for accessing and manipulating data from
            a Oracle database.

        Author:
            Leonard Mendis

        Date Created:
            December 11, 2017

        Modified By:

        Source: Class design adapted from the following:
            https://stackoverflow.com/questions/7465889/cx-oracle-and-exception-handling-good-practices

        Other References:
            https://dbaportal.eu/sidekicks/sidekick-cx_oracle-code-paterns/

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes (Note: A single prefixed '_' indicates Protected
    # and a double '__' denotes a Private attribute).
    __dbOpened = False      # An object can only open one database
    __cursorOpened = []     # An object can open multiple cursors
    __dbCredentials = {}    # Define a dictionary variable to store database
                            # login credentials
    __errorMessage = None
    __moduleName = 'database_class.py'
    __isConnectionPooling = False  # Flag to indicate connection pooling
    __formatBuffer = None   # Buffer for formatting output

    # List to hold error descriptions (Based on the max error number)
    __errorDesc = [None, None, None, None, None, None, None, None, None, \
                    None, None, None, None, None, None, None, None, None, \
                    None, None, None, None, None, None, None, None, None]

    # Public attributes
    errorCode = 0
    dbConnection = None     # An object can only be associated with one
                            # database. So if you need to access multiple
                            # databases, you need to create multiple database
                            # class objects with the appropriate credentials.
    dbCursor = []           # An object can have multiple cursors
    resultSet = None
    sessionPool = None
    sessionsList = []       # A list of sessions acquired for DRCP
    lineNum = 0             # Source code line number where the error occurred


    # ----------------------     GetErrorDescription()    ---------------------
    def GetErrorDescription(self, errorIndex):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            GetErrorDescription():
                Returns the error description for a given error code in case
                the calling program needs to know what the error is. You can
                also get the error code via the class object and trace back
                the error to that location in the code.

            Parameters:
                errorIndex - The database object errorCode passed from the
                             calling program.

            Returns: Email object error description.

        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Make sure there is an error and the error code is within the list
        # boundary
        if self.errorCode and (self.errorCode <= len(self.__errorDesc)):
            # print('GetErrorDescription(): %d - %s' % \
            #         (self.errorCode, self.__errorDesc[self.errorCode - 1]))
            return self.__errorDesc[errorIndex - 1]

        return None


    # ----------------------          GetLineNo()         ---------------------

    def GetLineNo(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            GetLineNo():
                Returns the current line number of the executing code.

            Parameters:
                None.

            Returns: Current line number in the code.

        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Use the currentframe and get the line number of the executing code.
        return inspect.currentframe().f_back.f_lineno


    # --------------------       __FormatMessage()         --------------------
    def __FormatMessage(self, unwrappedText, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __FormatMessage():
                Formats a message string using Python's TextWrapper() built-in
                function.

            Parameters:
                unwrappedText - Unwrapped text needing formatting.
                keywordArgs   - Text wrapper arguments.
                    width
                        - The line width to wrap the text message at. Default
                          is 70 characters.
                    expand_tabs
                        - Do tabs need to be expanded to spaces. Default is
                          True.
                    replace_whitespace
                        - Do each whitespace character after the tab need to
                          be replaced by a single whitespace. Default is
                          True.
                    drop_whitespace
                        - Do white spaces after wrapping at the beginning and
                          end of a line need to be dropped. Default is True.
                    initial_indent
                        - String that will be prepended to the first line of
                          wrapped output.  Default is ''.
                    subsequent_indent
                        - String that will be prepended to all lines of
                          wrapped output except the first. Default is ''.
                    fix_sentence_endings
                        - Attempts to detect sentence endings and ensure that
                          sentences are always separated by exactly two spaces.
                          This is generally desired for text in a mono spaced
                          font. However, the sentence detection algorithm is
                          imperfect. Default is False.
                    break_long_words
                        - Do words longer than width need be broken in order
                          to ensure that no lines are longer than width.
                          Default is True.
                    break_on_hyphens
                        - Does wrapping need to occur on white spaces and
                          right after hyphens in compound words. Default is
                          True.
            Returns:
                The wrapped text.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # The following are all the default local variables corresponding to
        # the named arguments in the TextWrapper() function.
        lineWidth = 80
        expandTabs = True
        replaceWhitespace = True
        dropWhitespace = True
        initialIndent = ''
        subsequentIndent = ''
        fixSentenceEndings = False
        breakLongWords = True
        breakOnHyphens = True

        if keywordArgs:
            keywordDict = {}
            for keywordParam in keywordArgs:
                keywordToUpper = keywordParam.upper()
                # Add to the dictionary
                keywordDict.update( \
                                {keywordToUpper : keywordArgs[keywordParam]})

                if keywordToUpper == 'WIDTH':
                    lineWidth = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EXPAND_TABS':
                    expandTabs = keywordDict[keywordToUpper]
                elif keywordToUpper == 'REPLACE_WHITESPACE':
                    replaceWhitespace = keywordDict[keywordToUpper]
                elif keywordToUpper == 'DROP_WHITESPACE':
                    dropWhitespace = keywordDict[keywordToUpper]
                elif keywordToUpper == 'INITIAL_INDENT':
                    initialIndent = keywordDict[keywordToUpper]
                elif keywordToUpper == 'SUBSEQUENT_INDENT':
                    subsequentIndent = keywordDict[keywordToUpper]
                elif keywordToUpper == 'FIX_SENTENCE_ENDINGS':
                    fixSentenceEndings = keywordDict[keywordToUpper]
                elif keywordToUpper == 'BREAK_LONG_WORDS':
                    breakLongWords = keywordDict[keywordToUpper]
                elif keywordToUpper == 'BREAK_ON_HYPHENS':
                    breakOnHyphens = keywordDict[keywordToUpper]
                else:
                    self.lineNum = self.GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Invalid keyword passed to the __FormatMessage() ' \
                        'method in {0} module\nat Line #: {1}.\n')
                    print(self.__formatBuffer.format(__file__, self.lineNum))

        wrapperFormat = textwrap.TextWrapper(width=lineWidth, \
                                expand_tabs=expandTabs, \
                                replace_whitespace=replaceWhitespace, \
                                drop_whitespace=dropWhitespace, \
                                initial_indent=initialIndent, \
                                subsequent_indent=subsequentIndent, \
                                fix_sentence_endings=fixSentenceEndings, \
                                break_long_words=breakLongWords, \
                                break_on_hyphens=breakOnHyphens)

        return wrapperFormat.fill(unwrappedText)


    # ----------------------        Disconnect()        -----------------------

    def Disconnect(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Disconnect():
                Disconnects from the database. If this fails, for instance if
                the connection instance doesn't exist we don't really care.

            Parameters:
                None.
            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Close database connection
            if self.__dbOpened:
                if not self.sessionPool:
                    self.dbConnection.close()
                    self.__dbOpened = False

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = None
            self.__formatBuffer = \
                ('Database error - Unable to disconnect from the database. ' \
                'Error occurred in {0} module Disconnect() method at Line #' \
                ': {1}. Error Code: {2}. Error Message: {3}. Error ' \
                'Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                    error.code, error.message, error.context)
            self.errorCode = 27
            # print(self.__errorMessage)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')


    # ----------------------          Commit()          -----------------------

    def Commit(self, poolIndex=-1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Commit():
                Commits the query results.

            Parameters:
                poolIndex - Index to the pooled connections list

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if self.sessionPool:
                self.sessionsList[poolIndex].commit()
            else:
                self.dbConnection.commit()

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error - Unable to commit updates. Error occurred ' \
                '{0} module Commit() method at Line #: {1}. Error code: ' \
                'Code: {2}. Error Message: {3}. Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 26
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')


    # ----------------------         Rollback()         -----------------------

    def Rollback(self, poolIndex=-1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Rollback():
                Rollback the transaction.

            Parameters:
                poolIndex - Index to the pooled connections list

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if self.sessionPool:
                self.sessionsList[poolIndex].rollback()
            else:
                self.dbConnection.rollback()

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error - Unable to rollback updates. Error ' \
                'occurred in {0} module Rollback() method at Line #: {1}. ' \
                'Error Code: {2}. Error Message: {3}. ' \
                'Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
            self.errorCode = 25
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage


    # ----------------------        CloseCursor()        ----------------------

    def CloseCursor(self, cursorNumber):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CloseCursor():
                Closes the cursor.

            Parameters:
                cursorNumber - Index assigned to the cursor when it was
                               originally opened in the OpenCursor() method.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Close cursor if it is in the list of cursors that were opened.
            if self.__cursorOpened[cursorNumber]:
                self.dbCursor[cursorNumber].close()
                self.__cursorOpened[cursorNumber] = False

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error - Unable to close cursor. Error occurred ' \
                'in {0} module CloseCursor() method at Line #: {1}. ' \
                'Error Code: {2}. Error Message: {3}. Error ' \
                'Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 24
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')


    # ----------------------   InsertDataFromCsvFile()   ----------------------

    def InsertDataFromCsvFile(self, cursorNumber, insertSql, fileName, \
                                commitFlag, **csvKeywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            InsertDataFromCsvFile():
                This method is used to insert bulk data from a csv file to the
                database.

            Parameters:
                cursorNumber     - Cursor number used to insert data.
                sqlQuery         - Insert SQL statement to execute.
                fileName         - The nput csv file name with path.
                commitFlag       - Flag indicating whether to commit or not.
                **csvKeywordArgs - csv.reader() function takes the following
                                   keyword arguments. NOTE: This is the keyword
                                   argument list for the python csv reader
                                   object. It cannot contain any keywords
                                   other than the ones specified in the
                                   function header.

                    quotechar        - Specifies a one-character string to use
                                       as the quoting character. It defaults to
                                       '"'. Setting this to None has the same
                                       effect as setting quoting to
                                       csv.QUOTE_NONE.
                    delimiter        - Specifies a one-character string to use
                                       as the field separator. It defaults
                                       to ','.
                    escapechar       - Specifies a one-character string used
                                       to escape the delimiter when quotechar
                                       is set to None.
                    skipinitialspace - Specifies how to interpret whitespace
                                       which immediately follows a delimiter.
                                       It defaults to False, which means that
                                       whitespace immediately following a
                                       delimiter is part of the following
                                       field.
                    lineterminator   - Specifies the character sequence which
                                       should terminate rows.
                    quoting          - Controls when quotes should be generated
                                       by the writer. It can take on any of the
                                       following module
                                       constants:
                                            csv.QUOTE_MINIMAL - Means only when
                                                required, for example, when a
                                                field contains either the
                                                quotechar or the delimiter
                                            csv.QUOTE_ALL - Means that quotes
                                                are always placed around fields.
                                            csv.QUOTE_NONNUMERIC - Means that
                                                quotes are always placed around
                                                nonnumeric fields.
                                            csv.QUOTE_NONE - Means that quotes
                                                are never placed around fields.
                    doublequote      - Controls the handling of quotes inside
                                       fields. When True two consecutive quotes
                                       are interpreted as one during read, and
                                       when writing, each quote is written as
                                       two quotes.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            with open(fileName, mode='r', newline='') as csvFile:
                # Initialize list that will serve as a container for
                # bind values
                csvDataList = []

                # Read the csv file using the python csv reader object
                csvReaderObj = csv.reader(csvFile, **csvKeywordArgs)

                # Create a list for each row of data found in the csv file
                for csvRow in csvReaderObj:
                    # Remove the leading and trailing white spaces if any from
                    # the input. You can remove the white space immediately
                    # following a delimiter by setting the skipinitialspace
                    # keyword in the keywardArg list to True.
                    # for itemIndex in range(len(csvRow)):
                    #     csvRow[itemIndex] = csvRow[itemIndex].strip()
                    for itemIndex, csvRowItem in enumerate(csvRow):
                        csvRow[itemIndex] = csvRowItem.strip()

                    # Append the row to the list
                    csvDataList.append(tuple(csvRow))

                # Sample SQL statement for bulk inserts. Note that the input
                # lines in the csv file must match the columns specified in
                # the SQL statement.
                #
                # insertSql = (
                #       "INSERT INTO emp (empno, ename, job, mgr, hiredate, " \
                #       "sal, comm, deptno)" \
                #       "VALUES (:1, :2, :3, :4, to_date(:5,'DD.MM.YYYY'), " \
                #       ":6, :7, :8)")

                # Prepare insert statement
                self.dbCursor[cursorNumber].prepare(insertSql)

                # Execute insert with executemany()
                self.dbCursor[cursorNumber].executemany(None, csvDataList)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error - Unable to insert data from csv file. ' \
                'Error occurred in {0} module InsertDataFromCsvFile() ' \
                'method at Line #: {1}. Error Code: {2}. Error ' \
                'Message: {3}. Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 23
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        else:
            # Report number of inserted rows
            # print('Inserted: ' + str(self.dbCursor[cursorNumber].rowcount) \
            #       + ' rows.')

            if commitFlag:
                self.dbConnection.commit()


    # ----------------------    ExportDataFromTable()    ----------------------

    def  ExportDataFromTable(self, cursorIndex, outputFile, outputFilePath, \
                                includeHeaders, sqlText, tableName, \
                                **csvKeywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ExportDataFromTable():
                Exports data from an Oracle database table into a csv file.

            Parameters:
                cursorIndex       - Index to the cursor object.
                outputFile        - Optional Output csvFile name.
                outputFilePath    - Optional path to the outFile.
                includeHeaders    - Optional flag if column headers are needed.
                sqlText           - Optional SQL text if you do not want to
                                    export all table columns.
                tableName         - Table name in case the output file name is
                                    not given.
                **csvKeywordArgs  - csv.reader() function takes the following
                                    keyword arguments. NOTE: This is the
                                    keyword argument list for the python csv
                                    reader object. It cannot contain any
                                    keywords other than the ones specified in
                                    the function header.

                    quotechar        - Specifies a one-character string to use
                                       as the quoting character. It defaults to
                                       '"'. Setting this to None has the same
                                       effect as setting quoting to
                                       csv.QUOTE_NONE.
                    delimiter        - Specifies a one-character string to use
                                       as the field separator. It defaults
                                       to ','.
                    escapechar       - Specifies a one-character string used to
                                       escape the delimiter when quotechar is
                                       set to None.
                    skipinitialspace - Specifies how to interpret whitespace
                                       which immediately follows a delimiter.
                                       It defaults to False, which means that
                                       whitespace immediately following a
                                       delimiter is part of the following
                                       field.
                    lineterminator   - Specifies the character sequence which
                                       should terminate rows.
                    quoting          - Controls when quotes should be generated
                                       by the writer. It can take on any of the
                                       following module
                                       constants:
                                            csv.QUOTE_MINIMAL - Means only when
                                                required, for example, when a
                                                field contains either the
                                                quotechar or the delimiter
                                            csv.QUOTE_ALL - Means that quotes
                                                are always placed around
                                                fields.
                                            csv.QUOTE_NONNUMERIC - Means that
                                                quotes are always placed around
                                                nonnumeric fields.
                                            csv.QUOTE_NONE - Means that quotes
                                                are never placed around fields.
                    doublequote      - Controls the handling of quotes inside
                                       fields. When True two consecutive quotes
                                       are interpreted as one during read, and
                                       when writing, each quote is written as
                                       two quotes.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            fileOpen = False
            # Ensure the SQL text is provided
            if not sqlText:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('Must provide the SQL statements to extract data from ' \
                    'the table. Please invoke the function with the ' \
                    'correct argument list. Error occurred in {0} module ' \
                    'ExportDataFromTable() method at Line #: {1}.')
                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)

                self.errorCode = 22
                self.__errorDesc[self.errorCode - 1] = self.__errorMessage

                raise LocalException(self.__errorMessage)
            else:
                queryResult = self.ExecuteQuery(cursorIndex, sqlText)

            # If the output file path is given append it
            if outputFilePath:
                # If output file name is not provided, prefix the csv file
                # with the table name.
                if not outputFile:
                    outputFile = ('%s/%s.csv' % (outputFilePath, tableName))
                else:
                    outputFile = ('%s/%s' % (outputFilePath, outputFile))
            else:
                if not outputFile:
                    outputFile = ('%s.csv' % tableName)

            # Open the output csv file
            with open(outputFile, mode='w+', newline='') as csvFile:
                fileOpen = True
                csvWriterObj = \
                        csv.writer(csvFile, dialect='excel', **csvKeywordArgs)

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
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error - Unable to extract data for exporting to ' \
                'Excel. Error occurred in {0} module ExportDataFromTable() ' \
                'method at Line #: {1}. Error Code: {2}. Error Message {3}. ' \
                'Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 21
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        except LocalException as error:
            # print(self.__errorMessage)
            print(self.__FormatMessage( \
                error.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
        finally:
            if fileOpen:
                csvFile.close()


    # ----------------------       FetchResults()       -----------------------

    def FetchResults(self, cursorNumber, numRows=0):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            FetchResults():
                Based on the arguments passed, calls the cx_Oracle fetchall()
                or fetchmany() methods to fetch the results from executing
                the SQL query.  Note that the same resultSet is used for
                FetchResults() and ExecuteQuery(), so it is recommended that
                the calling program assign the resultSet to a local variable
                and then manipulate the results locally.

            Parameters:
                cursorNumber - Cursor number for which the results are
                               fetched.
                numRows      - The number of rows to fetch if specified.
                               Default is all rows.

            Returns:
                The result set from fetching the cursor.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if numRows:
                self.resultSet = self.dbCursor[cursorNumber].fetchmany(numRows)
            else:
                self.resultSet = self.dbCursor[cursorNumber].fetchall()

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database execution error. Error occurred in {0} module ' \
                'FetchResults() method at Line #: {1}. Error Code: {2}. ' \
                'Error Message: {3}. Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 20
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        else:
            return self.resultSet


    # ----------------------       ExecuteQuery()       -----------------------

    def ExecuteQuery(self, cursorNumber, sqlQuery, bindVars=None, \
                        commitFlag=False):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ExecuteQuery():
                Execute an SQL statement to query a database and get the
                results. Commit if specified.  Note that the same resultSet
                is used for ExecuteQuery() and FetchResults(), so it is
                recommended that the calling program assign the resultSet
                to a local variable and then manipulate the results locally.

            Do not specify fetchall() here as the SQL statement may not be
            a select.

            Parameters:
                cursorNumber - Cursor number for which the query is executed.
                sqlQuery     - SQL query to execute.
                Bindvars     - A dictionary of bind variables required to
                               execute the query.
                commitFlag   - Flag indicating whether to commit or not.
            Returns:
                The result set from executing the query.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # An example of calling a query with bind variables:
            #    named_params = {'dept_id':50, 'sal':1000}
            #    query1 = cursor.execute('SELECT * FROM employees WHERE
            #           department_id=:dept_id AND salary>:sal', named_params)

            if bindVars:
                self.resultSet = \
                        self.dbCursor[cursorNumber].execute(sqlQuery, bindVars)
            else:
                self.resultSet = \
                        self.dbCursor[cursorNumber].execute(sqlQuery)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = (
                'Database error. Unable to execute query. Error occurred ' \
                'in {0} module ExecuteQuery() method at Line #: {1}. Error ' \
                'Code: {2}. Error Message: {3}. Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 19
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        else:
            # Only commit if it is necessary.
            if commitFlag:
                self.dbConnection.commit()

            return self.resultSet


    # ----------------------        OpenCursor()        -----------------------

    def OpenCursor(self, poolIndex=-1):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            OpenCursor(self):
                Create a cursor if the connection was successful.

            Parameters:
                poolIndex - Index to the pooled connections list
            Returns:
                The index number assigned for the cursor that was opened.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if self.sessionPool:
                self.dbCursor.append(self.sessionsList[poolIndex].cursor())
            elif self.__dbOpened:
                self.dbCursor.append(self.dbConnection.cursor())
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('A connection to the database has not been ' \
                    'established. Error occurred in {0} module ' \
                    'OpenCursor() method at Line #: {1}.')

                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
                self.errorCode = 18
                self.__errorDesc[self.errorCode - 1] = self.__errorMessage

                raise LocalException(self.__errorMessage)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error. Unable to open cursor. Error occurred in ' \
                '{0} module OpenCursor() method at Line #: {1}. Error ' \
                'Code: {2}. Error Message: {3}. Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 17
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        except LocalException as error:
            # print(self.__errorMessage)
            print(self.__FormatMessage( \
                error.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
        else:
            self.__cursorOpened.append(True)
            return len(self.dbCursor) - 1


    # ----------------------     ReleaseConnection()     ----------------------

    def  ReleaseConnection(self, poolIndex):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ReleaseConnection():
                Releases the connection back to the DRCP connection pool.
                Applies only if you are using connection pooling.

            Parameters:
                poolIndex - Index to the pooled connections list

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if self.sessionPool:
                self.sessionPool.release(self.sessionsList[poolIndex])
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('Connection was not created using the Database ' \
                    'Resident Connections Pooling. Unable to release the ' \
                    'connection. Error occurred in {0} module ' \
                    'ReleaseConnection() method at Line #: {1}.')

                self.errorCode = 16
                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
                self.__errorDesc[self.errorCode - 1] = self.__errorMessage
                raise LocalException(self.__errorMessage)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error. Unable to release database connection. ' \
                'Error occurred in {0} module ReleaseConnection() method ' \
                'at Line #: {1}. Error Code: {2}. Error Message: {3}. ' \
                'Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 15
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        except LocalException as error:
            # print(self.__errorMessage)
            print(error.value)
            print(self.__FormatMessage( \
                error.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')


    # ----------------------     AcquireConnection()     ----------------------

    def  AcquireConnection(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            AcquireConnection():
                Acquires a connection for a single session in the DRCP pool.
                Applies only if you are using connection pooling.

            Parameters:
                None.

            Returns:
                The index to the sessionsList list.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Acquire a connection only if the class object created is for a
            # database connection pool
            if self.sessionPool:
                # Check and make sure there are enough sessions available in
                # the session pool to acquire one.
                activeCount = 0
                for numSessions in self.sessionsList:
                    if numSessions:
                        activeCount += 1

                if activeCount > self.sessionPool.max - 1:
                    self.lineNum = self.GetLineNo() - 1
                    self.__formatBuffer = \
                        ('Maximum number of databse connection pools ' \
                        'reached. There are no more session pools ' \
                        'available. Error occurred in {0} module ' \
                        'AcquireConnection() method at Line #: {1}.')

                    self.errorCode = 14
                    self.__errorMessage = \
                        self.__formatBuffer.format(self.__moduleName, \
                                                    self.lineNum)
                    self.__errorDesc[self.errorCode - 1] = self.__errorMessage
                    raise LocalException(self.__errorMessage)
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('There is no database connection pool open to acquire ' \
                    'a connection. Error occurred in {0} module ' \
                    'AcquireConnection() method at Line #: {1}.')

                self.errorCode = 13
                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
                self.__errorDesc[self.errorCode - 1] = self.__errorMessage
                raise LocalException(self.__errorMessage)

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                ('Database error. Unable to acquire a database connection. ' \
                'Error occurred in {0} module AcquireConnection() method ' \
                'at Line #: {1}. Error Code: {2}. Error Message: {3}. ' \
                'Error Context: {4}')

            self.__errorMessage = \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context)
            self.errorCode = 12
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

        except LocalException as error:
            # print(self.__errorMessage)
            print(self.__FormatMessage( \
                error.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
        else:
            self.sessionsList.append(self.sessionPool.acquire())
            # Return the current index of the sessionsList list
            return len(self.sessionsList) - 1


    # ----------------------          Connect()          ----------------------

    def Connect(self, isDRCP=False, minSessions=1, maxSessions=10, \
                poolIncrement=1, isThreaded=False, getMode=None, \
                isHomogeneous=True):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Connect(self):
                Connect to the database using the credentials passed to the
                class method.

            Parameters:
                isDRCP        - Is the connection using DRCP pooling.
                minSessions   - Minimum number of connections in the
                                session pool.
                maxSessions   - Maximum number of connections in the
                                session pool.
                poolIncrement - Number of sessions by which to increment
                                the pool.
                isThreaded    - Flag to indicate threading. False by
                                default.
                getMode       - SPOOL_ATTRVAL_NOWAIT, SPOOL_ATTRVAL_WAIT,
                                SPOOL_ATTRVAL_FORCEGET.
                isHomogeneous - Defaulted to True. If pool is not homogeneous,
                                then different authentication can be used for
                                each connection in the pool.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if not isDRCP:
                self.dbConnection = \
                        cx_Oracle.connect(self.__dbCredentials['USERID'], \
                            self.__dbCredentials['PASSWD'], \
                            ('%s:%s/%s' % (self.__dbCredentials['HOSTNM'], \
                            str(self.__dbCredentials['PORTNO']), \
                            self.__dbCredentials['SERVNM'])))
            else:   # Use session pooling for multiple connections to database
                dsnName = cx_Oracle.makedsn(self.__dbCredentials['HOSTNM'], \
                            str(self.__dbCredentials['PORTNO']), sid=None, \
                            service_name=self.__dbCredentials['SERVNM'], \
                            region=None, sharding_key=None)
                            # sharding_key=None, super_sharding_key=None)

                if getMode == 'WAIT':
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_WAIT
                elif getMode == 'FORCEGET':
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_FORCEGET
                else:
                    poolGetMode = cx_Oracle.SPOOL_ATTRVAL_NOWAIT

                # Use Oracle DRCP (Database Resident Connection Pooling)
                self.sessionPool = (
                    cx_Oracle.SessionPool(
                        user=self.__dbCredentials['USERID'],
                        password=self.__dbCredentials['PASSWD'],
                        dsn=dsnName,
                        min=minSessions,
                        max=maxSessions,
                        increment=poolIncrement,
                        connectiontype=cx_Oracle.Connection,
                        threaded=isThreaded,
                        getmode=poolGetMode,
                        homogeneous=isHomogeneous))

                # Set session pool time out for idle connections.
                self.sessionPool.timeout = 50       # 50 seconds

                # Set a flag to indicate database connection  pooling is in use
                self.__isConnectionPooling = True

        except cx_Oracle.DatabaseError as dbException:
            error, = dbException.args
            if error.code == 1017:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('Database connection error. Please check your ' \
                    'credentials. Error occurred in {0} module Connect() ' \
                    'method at Line #: {1}. Error Code: {2}. Error ' \
                    'Message: {3}. Error Context: {4}')
                self.errorCode = 11
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('Database connection error. Error occurred in {0} ' \
                    'module Connect() method at Line #: {1}. Error ' \
                    'Code: {2}. Error Message: {3}. Error Context: {4}')
                self.errorCode = 10

            self.__errorMessage = \
                (self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                error.code, error.message, error.context))
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
        else:
            self.__dbOpened = True


    # --------------------  __CheckMissingCredentials__()  --------------------

    def __CheckMissingCredentials__(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CheckMissingCredentials__()
                Checks for missing credentials and returns an error message
                based on what credentials are missing.

            Parameters:
                None.

            Returns:
                Returns an error message if there is missing credentials.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        returnVal = True

        # HOSTNM is not in the dictionary or has no value
        if 'HOSTNM' not in self.__dbCredentials.keys():
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Missing credentials for database connectivity. Please ' \
                'ensure the HOSTNM is passed as a parameter when ' \
                'instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: ' \
                '{1}.')

            self.errorCode = 9
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False
        elif not self.__dbCredentials.get('HOSTNM'):
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Invalid HOSTNM. Please ensure all credentials are passed ' \
                'when instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 8
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False

        # USERID is not in the dictionary or has no value
        if 'USERID' not in self.__dbCredentials.keys():
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Missing credentials for database connectivity. Please ' \
                'ensure the USERID is passed as a parameter when ' \
                'instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 7
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False
        elif not self.__dbCredentials.get('USERID'):
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Invalid USERID. Please ensure all credentials are passed ' \
                'when instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 6
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False

        # PASSWD is not in the dictionary or has no value
        if 'PASSWD' not in self.__dbCredentials.keys():
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Missing credentials for database connectivity. Please ' \
                'ensure the PASSWD is passed as a parameter when ' \
                'instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 5
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False
        elif not self.__dbCredentials.get('PASSWD'):
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Invalid PASSWD. Please ensure all credentials are passed ' \
                'when instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 4
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False

        # SERVNM is not in the dictionary or has no value
        if 'SERVNM' not in self.__dbCredentials.keys():
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Missing credentials for database connectivity. Please ' \
                'ensure the SERVNM is passed as a parameter when ' \
                'instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 3
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False
        elif not self.__dbCredentials.get('SERVNM'):
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                ('Invalid SERVNM. Please ensure all credentials are passed ' \
                'when instantiating the class object. Error occurred in {0} ' \
                'module __CheckMissingCredentials__() method at Line #: {1}.')

            self.errorCode = 2
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.__errorDesc[self.errorCode - 1] = self.__errorMessage
            returnVal = False

        return returnVal


    # ----------------------         __init__()         -----------------------

    def __init__(self, *positionalArgs, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__():
                Initializes the database object attributes.

                NOTE: There are several ways to pass arguments to initialize
                the database class object. One way is to pass them the
                arguments in a positional order meaning passing them in the
                sequence that the class object expects to receive. The order
                is Host Name, User ID, Password, Service Name and optional
                Port Number. Another way is to pass the arguments using
                keywords. i.e. HOSTNM = 'Something', USERID = 'Something',
                PASSWD = 'SomeThing', SERVNM = 'Something'. The order in
                which you pass the keyword arguments does not matter. The
                keyword names must match as indicated here. You could also
                use a combination of positional and keyword arguments but
                the positional arguments must be passed prior to the keyword
                arguments. Again, the positional parameters must be ordered
                and therefore, cannot skip an argument in between two
                argument values.

                Keyword arguments can also be obtained from the environment
                variables by prefixing the keyword with ENV_. i.e. like
                ENV_HOSTNM or ENV_USERID so on and so forth. However, the
                value assigned to the keyword must match the environment
                variable name, otherwise the connection object will fail to
                connect to the database.

            Parameters:
                positionalArgs - Positional argument values
                keywordArgs    - Keyword argument values

                Ex:
                    HOSTNM - Database host name (dfw-prd-db-09.jetpay.com)
                    USERID - Database login ID  (johndoe)
                    PASSWD - Database password
                    SERVNM - Service name (clear1.jetpay.com)
                    PORTNO - Port number the database is listening to
                             (usually 1521)

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Check if a value passed to the lambda is a string and return
            # the appropriate values
            getStringValue = lambda testStr: (testStr if testStr else None)

            argNum = 1

            # Check if it is positional arguments then, initialize the class
            # object attributes.
            # THE ORDER FOR POSITIONAL ARGUMENTS MATTER: Host Name, User ID,
            # Passsword, Service Name, and Port Number.
            # NOTE: __dbCredentials is a dictionary
            if positionalArgs:
                for arguments in positionalArgs:
                    # Initialize the class object attributes. The order for
                    # positional arguments is: Host Name, User ID, Passsword,
                    # Service Name, and Port Number.
                    if argNum == 1:
                        self.__dbCredentials.update( \
                                        {'HOSTNM': getStringValue(arguments)})
                    elif argNum == 2:
                        self.__dbCredentials.update( \
                                        {'USERID': getStringValue(arguments)})
                    elif argNum == 3:
                        self.__dbCredentials.update( \
                                        {'PASSWD': getStringValue(arguments)})
                    elif argNum == 4:
                        self.__dbCredentials.update( \
                                        {'SERVNM': getStringValue(arguments)})
                    elif argNum == 5:
                        self.__dbCredentials.update( \
                                        {'PORTNO': getStringValue(arguments)})

                    argNum += 1

            # Check if there are any keyword arguments
            if keywordArgs:
                # Read the keyword arguments into a temporary dictionary
                keywordDict = {}
                for keyWord in keywordArgs:
                    # Check to see if a keyword parameter has an ENV_ prefix.
                    # If so, get the the value from the environment variable.
                    # If some of the variables are obtained from the
                    # environment, then the expectation is that the keyword
                    # is prefixed with ENV_ (case does not matter).
                    # Ex. env_HOSTNM
                    # Remove the ENV_ from keyword
                    if 'ENV_' in keyWord.upper():
                        tempKeyWord = keyWord[4:].upper()
                        keywordDict.update({tempKeyWord: keywordArgs[keyWord]})

                        self.__dbCredentials.update({tempKeyWord: \
                                    os.environ.get(keywordDict[tempKeyWord])})
                    else:
                        tempKeyWord = keyWord.upper()
                        keywordDict.update({tempKeyWord: keywordArgs[keyWord]})
                        self.__dbCredentials.update({tempKeyWord: \
                                                    keywordDict[tempKeyWord]})

                    argNum += 1

            # There has to be a total of five positional and keyword arguments
            if argNum == 1:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                    ('No credentials provided for database connectivity. ' \
                    'Please ensure the the HOSTNM, USERID, PASSWD, SERVNM ' \
                    'and PORTNO are passed when instantiating the class ' \
                    'object. Error occurred in {0} module __init__() ' \
                    'method at Line #: {1}.')

                self.errorCode = 1
                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
                self.__errorDesc[self.errorCode - 1] = self.__errorMessage
                raise LocalException(self.__errorMessage)

            # If the port number is still not assigned, then default it to 1521
            if 'PORTNO' not in self.__dbCredentials:
                self.__dbCredentials.update({'PORTNO': str(1521)})
                argNum += 1

            # Now check for missing values
            if not self.__CheckMissingCredentials__():
                raise LocalException(self.__errorMessage)

        except LocalException as error:
            # print(self.__errorMessage)
            print(self.__FormatMessage( \
                error.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
