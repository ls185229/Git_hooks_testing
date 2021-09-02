#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to create the expedia auth count report.
    $Id: expedia_auth_count_report.py 4812 2019-02-25 15:04:02Z lmendis $
"""


# The following are pylint directives to suppress some pylint warnings that you
# do not care about.
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = no-self-use

import argparse
import csv
import inspect
from datetime import datetime, timedelta
import logging
import os

# import re
# import shutil
# import subprocess
import textwrap

import sys

# Add the library path. Note that the DbClass, LoggerClass, and EmailClass are
# libraries that reside in the /clearing/filemgr/MASCLRLIB directory. This line
# must be positioned prior to the import of the class libraries (MASCLRLIB).
# Refer to:
# https://www.blog.pythonlibrary.org/2016/03/01/python-101-all-about-imports/

sys.path.append('/clearing/filemgr/MASCLRLIB')
from database_class import DbClass
from email_class import EmailClass
from logger_class import LoggerClass


class LocalException(Exception):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A local exception class to post exceptions local to this module.

            The local exception class is derived from the Python base exception
            class. It is used to throw other types of exceptions that are not
            in the standard exception class.

        Author:
            Leonard Mendis

        Date Created:
            2019-01-21

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


class AuthCountClass(object):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for creating the Auth Count report.

        Author:
            Leonard Mendis

        Date Created:
            2019-01-21

        Modified By:

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes
    __loggerObj = None       # Need to initialize if you are using logger class
    __lineNum = 0            # Current line number in the program
    __emailConfigFile = None # Email config file
    __formatBuffer = None    # Generic buffer for formatting text messages
    __sqlText = None         # Global variable for formatting SQL text
    __dbObject = None        # Database object
    __logType = 'LOGFILE'    # Logging type - LOGFILE/CONSOLE/BOTH

    #-----------------------       __PrintUsage()       -----------------------

    def __PrintUsage(self):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __PrintUsage():
                Prints the usage parameters for calling the program.

            Parameters:
                None.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        print( \
            ('        Usage is:\n            %s [-u or -U or --usage]\n' \
            '            [-v or -V or --verbose <Verbosity Level>]\n' \
            '            [-b or -B or --begindate (Optional YYYYMMDD)]\n' \
            '            [-t or -T or --test (Optional)]\n' \
            '            [-l or -L or --logtype <LOGFILE/CONSOLE/BOTH> ' \
            '(Optional)]\n\n            %s\n                %s\n' \
            '                %s\n                %s\n                ' \
            '%s\n                %s\n') \
            % (__file__, 'Verbosity Levels:', '-v     - Debug', '-vv    ' \
                '- Info', '-vvv   - Warning', '-vvvv  - Error', \
                '-vvvvv - Critical'))


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
                          is 80 characters.
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
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Invalid keyword passed to the __FormatMessage() ' \
                        'method in {0} {1}{2}module{3}at Line #: {4}.\n')
                    print(self.__formatBuffer.format( \
                            __file__, '', '', '\n', self.__lineNum))

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


    # ----------------------      __LogEndMessage()      ----------------------

    def __LogEndMessage(self, endMessage=None):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __LogEndMessage(self):
                Logs the end message to the log file.

            Parameters:
                End message if any.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        if not self.__loggerObj.LogMessage( \
            'End Execution: %s %s\n           %s' \
            % (__file__, (datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                        endMessage), 'END'):
            self.__lineNum = self.__GetLineNo() - 4
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Print message generated in Module: {0} Method: ' \
                '__LogEndMessage() at Line #: {1}. Unable to ' \
                'log message.')

            if self.__logType != 'LOGFILE':
                self.__lineNum = self.__GetLineNo() - 1
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')


    # -----------------------        __init__()         -----------------------

    def __init__(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the Auth Count class object.

            Parameters:
                None.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__lineNum = 0
        self.__formatBuffer = None


    # ----------------------         __GetLineNo()        ---------------------

    def __GetLineNo(self):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GetLineNo():
                Returns the current line number of the executing code.

            Parameters:
                None.

            Returns:
                Current line number in the code.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Use the currentframe and get the line number of the executing code.
        # Note: This is how you get the line number at the location in the code
        # where the error occurred.
        return inspect.currentframe().f_back.f_lineno


    # ----------------------      __GenerateEmail()      ----------------------

    def __GenerateEmail(self, **keywordArgs):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GenerateEmail():
                Generates the email to send the attachment or the alert.

            Parameters:
                fileToAttach - Optional name of file to attach to the email.
                keywordArgs  - Email keyword arguments.
                    READ_EMAIL_TEXT_FROM_FILE
                        - Name of file to read the email text from.
                    READ_FROM_CONFIG_FILE
                        - Name of file to read the email configurations.
                    CONFIG_SECTION_NAME
                        - Config section name to read the value from.
                    EMAIL_BODY
                        - Email body if a file containing a message is not
                          provided.
                    TO_ADDRESS
                        - Email address of the recipient.
                    FROM_ADDRESS
                        - Email address of the sender.
                    COPY_ADDRESS
                        - Email address to copy to.
                    BCC_ADDRESS
                        - Email address to blind copy to.
                    EMAIL_SUBJECT
                        - The subject line of the email.
                    ATTACH_FILES_FOLDER
                        - Folder where the attachments reside.
                    ATTACH_FILES_LIST
                        - List of files to attach.

            Returns:
                True if email was sent False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Initialize email argument variables
        emailTextFile = None   # Name of file to read the email text from.
        emailConfig = None     # Name of file to read the email configurations.
        configSectionName = None
        emailBody = None
        emailTo = None
        emailFrom = None
        emailCopy = None
        emailBlindCopy = None
        emailSubject = None
        fileFolder = None
        fileListToAttach = []

        if keywordArgs:
            keywordDict = {}
            for keywordParam in keywordArgs:
                keywordToUpper = keywordParam.upper()

                # Add to the dictionary
                keywordDict.update( \
                                {keywordToUpper : keywordArgs[keywordParam]})

                if keywordToUpper == 'READ_EMAIL_TEXT_FROM_FILE':
                    emailTextFile = keywordDict[keywordToUpper]
                elif keywordToUpper == 'READ_FROM_CONFIG_FILE':
                    emailConfig = keywordDict[keywordToUpper]
                elif keywordToUpper == 'CONFIG_SECTION_NAME':
                    configSectionName = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EMAIL_BODY':
                    emailBody = keywordDict[keywordToUpper]
                elif keywordToUpper == 'TO_ADDRESS':
                    emailTo = keywordDict[keywordToUpper]
                elif keywordToUpper == 'FROM_ADDRESS':
                    emailFrom = keywordDict[keywordToUpper]
                elif keywordToUpper == 'COPY_ADDRESS':
                    emailCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'BCC_ADDRESS':
                    emailBlindCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EMAIL_SUBJECT':
                    emailSubject = keywordDict[keywordToUpper]
                elif keywordToUpper == 'ATTACH_FILES_FOLDER':
                    fileFolder = keywordDict[keywordToUpper]
                elif keywordToUpper == 'ATTACH_FILES_LIST':
                    fileListToAttach = keywordDict[keywordToUpper]
                else:
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Invalid keyword passed to the __GenerateEmail() ' \
                        'method in {0} module at Line #: {1}.{2}')
                    if self.__logType != 'LOGFILE':
                        print(self.__FormatMessage( \
                                self.__formatBuffer.format(__file__, \
                                                        self.__lineNum, ''), \
                                width=80, initial_indent='\n        ', \
                                subsequent_indent=' ' * 8, \
                                break_long_words=False, \
                                break_on_hyphens=False), '\n')

                    # Log to the log file only if the logger object was
                    # created.
                    self.__lineNum = self.__GetLineNo() + 1
                    if self.__loggerObj and not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                        return False
        else:   # Nothing to email
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Unable to generate the email. No arguments provided to ' \
                'set up the email object. Error occurred in the ' \
                '__GenerateEmail() method in module {0} at Line #: {1}.{2}')
            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Log to the log file only if the logger object was created.
            self.__lineNum = self.__GetLineNo() + 1
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, \
                                                self.__lineNum, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False
            return False

        # Create the email object and initialize email addresses from email
        # config file.
        emailObj = EmailClass(READ_EMAIL_TEXT_FROM_FILE=emailTextFile, \
                                READ_FROM_CONFIG_FILE=emailConfig, \
                                CONFIG_SECTION_NAME=configSectionName, \
                                EMAIL_BODY=emailBody, \
                                TO_ADDRESS=emailTo, \
                                FROM_ADDRESS=emailFrom, \
                                COPY_ADDRESS=emailCopy, \
                                BCC_ADDRESS=emailBlindCopy, \
                                EMAIL_SUBJECT=emailSubject)

        # Check if there is an issue creating the email object prior to
        # attaching any files and sending the email.
        if emailObj.errorCode:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Unable to create email class object. Error occurred ' \
                'in the __GenerateEmail() method in {0} module ' \
                'at Line #: {1}.{2}')

            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                                __file__, self.__lineNum, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False
            if not self.__loggerObj.LogMessage( \
                            self.__FormatMessage( \
                                emailObj.GetErrorDescription(), \
                                width=80, initial_indent='\n            ', \
                                subsequent_indent=' ' * 12, \
                                break_long_words=False, \
                                break_on_hyphens=False), 'ERROR'):
                return False
            return False

        if fileListToAttach:
            if not emailObj.AttachFiles(ATTACH_FILES_FOLDER=fileFolder, \
                         ATTACH_FILES_LIST=fileListToAttach):
                self.__lineNum = self.__GetLineNo() - 2
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Unable to attach files to the email. Error occurred ' \
                    'in the __GenerateEmail() method in {0} module ' \
                    'at Line #: {1}.{2}')
                if self.__logType != 'LOGFILE':
                    print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                # Log to the log file.
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format( \
                                    __file__, self.__lineNum, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'ERROR'):
                    return False

                # An error occurred in the email object module, so get the
                # the error message using the built-in class method and log
                # to the log file.
                if emailObj.errorCode:
                    if not self.__loggerObj.LogMessage( \
                            self.__FormatMessage( \
                                emailObj.GetErrorDescription(), \
                                width=80, initial_indent='\n            ', \
                                subsequent_indent=' ' * 12, \
                                break_long_words=False, \
                                break_on_hyphens=False), 'ERROR'):
                        return False

                return False

            # Use this method to print the email parameters
            # emailObj.PrintEmailParams()

            # Send the email.
        if not emailObj.SendEmail():
            return False

        return True


    # ----------------------     __GetQueryResults()     ----------------------

    def __GetQueryResults(self, queryToRun, bindVarDict=None, \
                                dataType='Tuple'):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GetQueryResults():
                Executes the query passed to the method and returns the result
                set.

            Parameters:
                queryToRun  - Query to execute.
                bindVarDict - A dictionary of Bind variables (if any) needed
                              to execute the query.
                dataType    - Standard is tuple, or list of dictionary values
                              (ListDictionary) if required.

            Returns:
                The result set from executing the SQL query, number of rows
                the query returned, and DB error if any.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            numRows = 0         # Initialize result set rows
            dbError = False     # Initialize database error flag

            # Open a cursor.
            cursorNumber = self.__dbObject.OpenCursor()

            # Check if there are database errors before proceeding
            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    self.__dbObject.GetErrorDescription( \
                                        self.__dbObject.errorCode))

            # Execute the query.
            self.__dbObject.ExecuteQuery(cursorNumber, bindVars=bindVarDict, \
                                sqlQuery=queryToRun, commitFlag=False)

            # Check if there are database errors before proceeding.
            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    self.__dbObject.GetErrorDescription( \
                                        self.__dbObject.errorCode))

            # Fetch the data rows.
            resultSet = self.__dbObject.FetchResults(cursorNumber)

            # Check if there are database errors before proceeding
            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    self.__dbObject.GetErrorDescription( \
                                        self.__dbObject.errorCode))

            numRows = self.__dbObject.dbCursor[cursorNumber].rowcount

            # Print the number of rows
            if self.__logType != 'LOGFILE':
                print('        No of rows returned from the query: ', numRows)
            self.__formatBuffer = None
            self.__formatBuffer = \
                    'Number of rows returned from query: {0}'.format(numRows)
            if not self.__loggerObj.LogMessage(self.__formatBuffer, 'BODY'):
                pass

            if dataType and (dataType.upper() == 'LISTDICTIONARY'):
                dbColumnList = \
                    [colName[0] for colName in \
                        self.__dbObject.dbCursor[cursorNumber].description]

                # print(dbColumnList)

                resultsList = []
                for rowValue in resultSet:
                    resultsList.append(dict(zip(dbColumnList, rowValue)))

                # print(resultsList)
                # listLen = len(resultsList)
                # indexCount = 0
                # while indexCount < listLen:
                    # print(indexCount, resultsList[indexCount]['MMID'])
                    # indexCount += 1

            # Close cursor after you are done.
            self.__dbObject.CloseCursor(cursorNumber)

            # Check if there are database errors before proceeding
            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    self.__dbObject.GetErrorDescription( \
                                        self.__dbObject.errorCode))

        except LocalException as exceptError:
            dbError = True
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Error in {0} module __GetQueryResults() method at '
                'Line #: {1}: {2}')

            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    exceptError.value), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Log to the log file
            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            __file__, self.__lineNum, \
                            exceptError.value), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False
            return False, numRows, dbError
        else:
            if dataType and (dataType.upper() == 'LISTDICTIONARY'):
                return resultsList, numRows, dbError

            return resultSet, numRows, dbError


    # ----------------------   __CreateAuthCountFile()   ----------------------

    def __CreateAuthCountFile(self, runMode, queryDateDict, reportTimeStamp, \
                                outFileName, outFilePath):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateAuthCountFile():
                Write your own code to handle your program requirements.

            Parameters:
                queryDateDict   - Query date (dictionary) YYYYMM form.
                reportTimeStamp - Time stamp when the report was run.
                outFileName     - The CSV file to write the output to.
                outFilePath     - Path to the output file.

            Returns:
                True if Auth Count File is created, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Open a database connection
            self.__dbObject.Connect()       # Single connection
            # self.__dbObject.Connect(TRUE) # If using Connection Pooling

            fileOpen = False

            # Check if there are database errors before proceeding
            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'connecting to the database'
                else:
                    emailSubject = ('IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error connecting to the database')

                raise LocalException( \
                    self.__dbObject.GetErrorDescription( \
                                            self.__dbObject.errorCode))

            self.__sqlText = \
                """
                SELECT /*+index(th TRANSACTION_AUTHDATETIME)*/
                    m.mmid,
                    (CASE WHEN
                            (th.request_type = '0100' AND th.amount IN (0, 1))
                                THEN '0111'
                                ELSE th.request_type
                      END) request_type,
                    count(*),
                    th.CARD_TYPE,
                    th.CURRENCY_CODE
                FROM transaction th
                JOIN merchant m
                    ON m.mid = th.mid
                JOIN master_merchant mm
                    ON mm.mmid = m.mmid
                WHERE th.authdatetime LIKE :queryDateVar
                    AND th.request_type NOT IN ('0250', '0440')
                    AND (mm.shortname IN ('SHARPINV', 'EXPEDIA')
                            OR mm.mmid
                                    IN ('ADVANTAGEDIRECT-', 'DFW-GROUND-TRAN',
                                        'DFW-DPS-GUN-RANG', 'DFW-DPS-FIRE-TRA',
                                        'DFW-ACCESS-CONTR', 'DFW_AIRPORT',
                                        'GIFT_TREE')
                         )
                    AND ((th.request_type IN ('0200', '0220', '0420')
                            OR (th.request_type = '0100' AND th.amount > 1))
                            OR (th.request_type <> '0100' OR th.amount > 0)
                            OR ((th.request_type = '0100')
                                    AND th.amount IN (0, 1))
                        )
                GROUP BY
                    m.mmid,
                    (CASE WHEN
                            (th.request_type = '0100' AND th.amount IN (0, 1))
                                THEN '0111'
                                ELSE th.request_type
                        END),
                    th.CARD_TYPE,
                    th.CURRENCY_CODE
                ORDER BY 1, 4, 2
                """

            if self.__logType != 'LOGFILE':
                print(self.__sqlText)
            # Print the sql text to the log file
            if not self.__loggerObj.LogMessage(self.__sqlText, 'BODY'):
                pass

            queryResult, numRows, dbError = \
                    self.__GetQueryResults(self.__sqlText, \
                                bindVarDict=queryDateDict, dataType=None)

            if dbError:
                self.__lineNum = self.__GetLineNo() - 1

                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'querying the database'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error querying the database'

                raise LocalException('A database error occurred while ' \
                                        'executing the query.')
            elif numRows == 0:
                self.__lineNum = self.__GetLineNo() - 1

                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Database ' \
                                    'query returned zero rows'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Database query returned zero rows'

                raise LocalException('Query returned zero rows. There are ' \
                                        'no data to process.')
            elif not queryResult:
                self.__lineNum = self.__GetLineNo() - 1

                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Database ' \
                                    'error occurred while executing the query'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: A database error occurred ' \
                                    'while executing the query'
                raise LocalException('A database error occurred while ' \
                                        'executing the query.')

            # for resultData in queryResult:
                # print(repr(resultData))

            # rowNum = 1
            # for resultData in queryResult:
                # print('Row Num: {0} Results: ' \
                          # '{1}\n'.format(rowNum, repr(resultData)))
                # rowNum += 1

            # If the output file path is given append it
            if outFilePath:
                outFileNameWithPath = ('%s/%s' % (outFilePath, outFileName))

            headerText = 'sdate = {0:.6}'.format(queryDateDict['queryDateVar'])
            headerRow = (headerText, '', '', '', '')
            timeStamp = 'Start report date = {0}'.format(reportTimeStamp)
            timeStampRow = (timeStamp, '', '', '', '')

            # Open the output csv file
            with open(outFileNameWithPath, mode='w+', newline='') as csvFile:
                fileOpen = True
                csvWriterObj = \
                        csv.writer(csvFile, dialect='excel', \
                                        delimiter=',', \
                                        quotechar=None, \
                                        skipinitialspace=True, \
                                        quoting=csv.QUOTE_NONE, \
                                        escapechar='')
                csvWriterObj.writerow(headerRow)
                csvWriterObj.writerow(timeStampRow)
                # Now write the extracted data to the csv file
                for rowData in queryResult:
                    csvWriterObj.writerow(rowData)

                endTimeStamp = datetime.now().strftime("%Y%m%d%H%M%S")
                trailerText = 'Finished @ {0}'.format(endTimeStamp)
                trailerRow = (trailerText, '', '', '', '')
                csvWriterObj.writerow(trailerRow)

            # Close the connection to database.
            self.__dbObject.Disconnect()

            if fileOpen:
                csvFile.close()

                if runMode == 'PROD':
                    emailSubject = \
                            ('Expedia Auth Count Report: %s' % outFileName)
                else:
                    emailSubject = \
                        ('IGNORE: Testing Expedia Auth Count Report: %s' \
                            % outFileName)

                # Email the file
                emailBody = 'Successfully created the %s file.' % outFileName
                outputFileList = [outFileName]
                filesFolder = '{0}/ARCHIVE'.format( \
                                    os.path.dirname(os.path.abspath(__file__)))

                if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_REPORT', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody, \
                            ATTACH_FILES_LIST=outputFileList, \
                            ATTACH_FILES_FOLDER=filesFolder):
                    self.__lineNum = self.__GetLineNo() - 1
                    if self.__logType != 'LOGFILE':
                        print('        Unable to ' \
                                'email Auth Count report %s' % outFileName)
                    raise LocalException('Unable to email the file.')

            return True

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Error in {0} module __CreateAuthCountFile() method at '
                'Line #: {1}: {2}')
            emailBody = \
                self.__formatBuffer.format(__file__, self.__lineNum, \
                                                exceptError.value)
            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    exceptError.value), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Log to the log file
            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            __file__, self.__lineNum, \
                            exceptError.value), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False

            # Generate the error email. Note that the email class object is
            # created within this function.
            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                if self.__logType != 'LOGFILE':
                    print('        Unable to generate Email Alert.\n')

                return False

            self.__LogEndMessage('Unable to create auth_count_report.')

            if fileOpen:
                csvFile.close()
            return False


    #--------------------         __CreateLogger()        ---------------------

    def __CreateLogger(self, verbosityLevel, runMode):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateLogger():
                Initialize the logging object for logging messages to the
                log file.

            Parameters:
                verbosityLevel - Level of logging to the file - DEBUG, INFO,
                                 WARNING, ERROR, or CRITiCAL.

                runMode        - Option to run as test/prod.

            Returns:
                True if logger object was created and initialized, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            loggingLevel = 'INFO'       # Initialize it to information logging
            handleType = 'LOGFILE'      # Initialize it to logging to a file

            # Create the logging object and set the logging level and the log
            # handle type based the verbosity and the log type passed to the
            # function.
            basePath = os.path.dirname(os.path.abspath(__file__))

            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateLogger() at Line #: {1}. Base file path: ' \
                    '{2}{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    basePath, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            logfilePath = os.path.join(basePath, 'LOG')

            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateLogger() at Line #: {1}. Log file path: ' \
                    '{2}{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    logfilePath, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            GetPath = lambda logfilePath, basePath: \
                            logfilePath if logfilePath else basePath

            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateLogger() at Line #: {1}. From Lambda ' \
                    'GetPath Value: {2}{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    GetPath(logfilePath, basePath), ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Create the logger class object.
            self.__loggerObj = LoggerClass( \
                                MODULE_NAME=__file__, \
                                LOG_FILE_PATH=GetPath(logfilePath, basePath), \
                                LOG_FILE_TYPE='TimedRotatingFileHandler')

            # An error occurred during logger object initialization.
            if self.__loggerObj.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'creating logger object'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error creating logger object'
                raise LocalException('Unable to create the logger object.')

            # Check the verbosity level and set the logging level accordingly.
            # The logging level is the number of -v options passed in the
            # program arguments. Initially the LOG_LEVEL is set to 'info' and
            # LOG_TYPE to 'logfile'. Note that the LOG_LEVEL can be changed by
            # passing the required verbosity level to the ResetLoggingLevel()
            # method in the logger class later.
            if  verbosityLevel == 1:            # called with -v
                loggingLevel = 'DEBUG'
            elif verbosityLevel == 2:           # called with -vv
                loggingLevel = 'INFO'
            elif verbosityLevel == 3:           # called with -vvv
                loggingLevel = 'WARNING'
            elif verbosityLevel == 4:           # called with -vvvv
                loggingLevel = 'ERROR'
            elif verbosityLevel == 5:           # called with -vvvvv
                loggingLevel = 'CRITICAL'

            handleType = self.__logType

            # Set up logging parameters. This is the second step in the logging
            # process.
            if not self.__loggerObj.SetupLogFileParams():
                self.__lineNum = self.__GetLineNo() - 1
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'setting log file parameters'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error setting log file parameters'
                raise LocalException( \
                                'Unable to set up the log file parameters.')

            # Now set the logging attributes. This is the third step in the
            # logging process. Note that the named parameters in the
            # SetupLoggingAttributes() method is not case sensitive. LOG_TYPE
            # can be 'logfile', 'console' or 'both' ('both' means logging to a
            # log file and the console).
            if not self.__loggerObj.SetupLoggingAttributes( \
                                LOG_LEVEL=loggingLevel, Log_Type=handleType):
                self.__lineNum = self.__GetLineNo() - 2
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'setting logger attributes'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error setting logger attributes'
                raise LocalException( \
                                'An error occurred setting logger attributes.')

            # Set up log handlers. This function must be called fourth.
            if not self.__loggerObj.SetupLogHandlers():
                self.__lineNum = self.__GetLineNo() - 1
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report:  Error ' \
                                    'setting log file handlers'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error setting log file handlers'
                raise LocalException('Unable to set the log file handlers.')

            if not self.__loggerObj.LogMessage( \
                    'Begin Execution: %s %s' % \
                    (__file__, datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                    'BEGIN'):
                if runMode == 'PROD':
                    emailSubject = 'Expedia Auth Count Report: Error ' \
                                    'writing to the log file'
                else:
                    emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                    'Report: Error writing to the log file'
                if self.__loggerObj.verbosityLevel == logging.DEBUG:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException( \
                            'Unable to write debug messages to the log file.')
                else:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException( \
                            'Unable to write messages to the log file.')

        except LocalException as exceptError:
            emailBody = \
                self.__formatBuffer.format(__file__, self.__lineNum, \
                                                exceptError.value)
            # If called with -v Debug flag or test mode print the email config
            # file path.
            if  verbosityLevel == 1 or runMode == 'TEST':
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        '__CreateLogger() at Line #: {1}. Email config ' \
                        'file path: {2}.{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                self.__lineNum, self.__emailConfigFile, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Generate the error email. Note that the email class object is
            # created within this function.
            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                if self.__logType != 'LOGFILE':
                    print('        Unable to generate Email Alert.\n')

                return False

            return False
        else:
            return True


    #-----------------------     __CreateDbObject()     -----------------------

    def __CreateDbObject(self, verbosityLevel, runMode):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateDbObject():
                This function creates the database object to connect to a
                database.

            Parameters:
                verbosityLevel - Verbosity level
                                    - DEBUG/INFO/WARNING/ERROR/CRITICAL
                runMode        - Option to run as test/prod.

            Returns:
                True if the database object was created, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateDbObject() at Line #: {1}. Mode: {2}{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    runMode, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                # Log to the log file.
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    runMode, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    return False

            # Use the database class object to initialize the login
            # credentials from the environment variables. Note: The
            # ENV_ prefix in the keyword argument list is the indicator
            # that prompts the class object to grab the credentials from
            # the environment. If you are not using the environment variables,
            # then you may want to look at the DbClass library to get yourself
            # familiarized with the different ways to initialize the database
            # object.

            # Example:
            # self.__dbObject = DbClass(HOSTNM='dfw-prd-db-09.jetpay.com', \
            #                     ENV_USERID='IST_DB_USERNAME', \
            #                     PORTNO='1521', \
            #                     ENV_PASSWD='IST_DB_PASSWORD', \
            #                     SERVNM='clear1.jetpay.com')

            self.__dbObject = DbClass(ENV_HOSTNM='ATH2_HOST', \
                                ENV_USERID='ATH_DB_USERNAME', \
                                PORTNO='1521', \
                                ENV_PASSWD='ATH_DB_PASSWORD', \
                                ENV_SERVNM='ATH2_SERVICE_NAME')

            if self.__dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException(self.__dbObject.GetErrorDescription( \
                                                    self.__dbObject.errorCode))

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Error in {0} module __CreateDbObject() method at '
                'Line #: {1}: {2}')
            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    exceptError.value), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            __file__, self.__lineNum, \
                            exceptError.value), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False

            # Now send an email alert.
            if runMode == 'PROD':
                emailSubject = 'Expedia Auth Count Report: Unable to create ' \
                                'database object'
            else:
                emailSubject = 'IGNORE: Testing - Expedia Auth Count ' \
                                'Report: Unable to create database object'

            emailBody = self.__formatBuffer.format('', '', exceptError.value)

            # If called with -v Debug flag or test mode print the email config
            # file path.
            if  verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        '__CreateDbObject() at Line #: {1}. Email config ' \
                        'file path: {2}.{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                self.__lineNum, self.__emailConfigFile, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Generate the error email. Note that the email class object is
            # created within this function.
            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                if self.__logType != 'LOGFILE':
                    print('        Unable to generate Email Alert.\n')

                return False
        else:
            return True


    #--------------------      __FormatReportDates()      ---------------------

    def __FormatReportDates(self, reportRunDate, runMode, verbosityLevel):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __FormatReportDates():
                If report run date is passed to the program, verifies the date
                is YYYYMMDD format, else defaults it to the system date. Then,
                takes the report run date and formats the report query compare
                date to YYYYMM and report time stamp to YYYYMMDDHHMMSS format.
            Parameters:
                reportRunDate  - Report run date
                runMode        - Report run mode PROD/TEST
                verbosityLevel - Verbosity Level
            Returns:
                Formatted (YYYYMM) query compare date, formatted report run
                date and report time stamp date (YYYYMMDDHHMMSS).
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            reportTimeStamp = None
            queryDate = None

            # Get the report execute time stamp
            reportTimeStamp = datetime.now().strftime("%Y%m%d%H%M%S")

            # Note: Report run date is not required, but if the run date is
            # not given, assume that you are running the report for the
            # previous month from the system date. Otherwise, if the date is
            # given, run the report for the the previous month from that date.
            if not reportRunDate:
                self.__lineNum = self.__GetLineNo() - 1
                reportRunDate = datetime.now().strftime("%Y%m%d")
            else:       # Validate the date is YYYYMMDD form
                self.__lineNum = self.__GetLineNo() - 1
                datetime.strptime(reportRunDate, '%Y%m%d')

            # Get the report query date based on report run date
            self.__lineNum = self.__GetLineNo() + 1
            currentMonthFirstDate = \
                    datetime(year=int(reportRunDate[0:4]), \
                                month=int(reportRunDate[4:6]), day=1)

            self.__lineNum = self.__GetLineNo() + 1
            previousMonthEndDate = \
                        currentMonthFirstDate - timedelta(days=1)

            self.__lineNum = self.__GetLineNo() + 1
            queryDate = previousMonthEndDate.strftime('%Y%m')   # YYYYMM

        except ValueError as valueException:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                    'Error in Module: {0} __FormatReportDates() method at '
                    'Line #: {1}: {2}{3}')
            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    str(valueException), ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            self.__PrintUsage()

            # Log to the log file
            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            __file__, self.__lineNum, \
                            str(valueException), '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Send an email alert
            if runMode == 'PROD':
                emailSubject = ( \
                    'An exception occurred generating the Auth Count ' \
                    'Report. Run date: %s.' % reportRunDate)
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating the ' \
                    'Auth Count Report. Run Date: %s' % reportRunDate)

            emailBody = self.__formatBuffer.format( \
                            __file__, self.__lineNum, '', \
                            str(valueException), '')

            if verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        '__FormatReportDates() at Line #: {1}. Email config ' \
                        'file path: {2}.{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                self.__lineNum, self.__emailConfigFile, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
            # Don't want to proceed, so exit the program.
            sys.exit()
        else:
            return queryDate, reportRunDate, reportTimeStamp


    #----------------------         __GetArgs()         -----------------------

    def __GetArgs(self):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GetArgs()
                This function parses and returns the command line arguments
                passed to the script.

                argparse() Documentation and Examples:
                    https://docs.python.org/3/library/argparse.html
                    https://www.blog.pythonlibrary.org/2015/10/08/a-intro-to-argparse/
                    https://docs.python.org/2/howto/argparse.html#id1

            Parameters:
                None.

            Returns:
                The arguments passed to the program.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Assign description to the help doc
            programDescription = ( \
                'This script parses and returns the command line arguments '
                'for the Auth Count Report.')

            argParser = argparse.ArgumentParser(description=programDescription)

            argParser.add_argument( \
                '-u', '-U', '--usage', help='Show how to invoke the script.', \
                required=False, default=False, action='store_true')

            # Add the verbose argument to argparse. Make it not required and
            # let the program handle the required arguments.
            argParser.add_argument( \
                    '-v', '-V', '--verbose', action='count', dest='verbose', \
                    help="verbose level... repeat up to five times.")

            # Add the logging level to argparse. Make it not required and let
            # the program handle the required arguments.
            argParser.add_argument( \
                    '-l', '-L', '--logtype', type=str,
                    help='One of optional logging flags: LOGFILE, CONSOLE, ' \
                            'or BOTH.', default='LOGFILE', required=False)

            # Add the begin date (optional) argument to argparse. Make it not
            # required and let the program handle the required arguments.
            argParser.add_argument( \
                    '-b', '-B', '--begindate', type=str, \
                    help='Optional report start date YYYYMMDD format.', \
                    required=False)

            # Add the test mode (optional) argument to argparse. Make it not
            # required and let the program handle the required arguments.
            argParser.add_argument( \
                    '-t', '-T', '--test', type=str, default='PROD', \
                    help='Run mode indicator (Optional).', required=False)

            # Extract all arguments passed to script into a list
            argsList = argParser.parse_args()

            # Assign args to variable(s)
            verbosityLevel = argsList.verbose
            showUsage = argsList.usage
            reportRunDate = argsList.begindate
            self.__logType = argsList.logtype
            runMode = argsList.test

            # Default program run mode
            if runMode != 'PROD':
                runMode = runMode.upper()
            if runMode == 'P':
                runMode = 'PROD'
            elif runMode != 'PROD':     # default set to 'PROD' in argparse
                runMode = 'TEST'

            if runMode == 'PROD':
                self.__emailConfigFile = \
                        '%s/email_config.ini' % os.environ.get('MASCLRLIB_PATH')
            else:
                print('Calling __GetArgs(): Using the test_email_config.ini file.\n')
                self.__emailConfigFile = '{0}/test_email_config.ini'.format(os.getcwd())

            if  verbosityLevel == 1:     # Verbosity level: Debug
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__GetArgs() at Line #: {1}. showUsage = {2}  ' \
                    'verbosityLevel = {3}  Run Mode = {4}')

                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                                showUsage, \
                                                str(verbosityLevel), \
                                                str(runMode)), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

        except argparse.ArgumentError as exceptError:
            if self.__logType != 'LOGFILE':
                self.__lineNum = self.__GetLineNo() - 2
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Exception error in Module: {0} __GetArgs() method at ' \
                    'Line #: {1}: {2}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    str(exceptError)), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
            sys.exit()
        else:
            # Return all variable values
            return showUsage, verbosityLevel, reportRunDate, runMode


    #--------------------     CreateAuthCountReport()     ---------------------

    def CreateAuthCountReport(self):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CreateAuthCountReport()
                Creates the auth count report.

            Parameters:
                None.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Get the arguments passed to the program. Note that the
            # verbosityLevel is the number of -v options that the program is
            # called with. For example -v is 1 and -vv is 2 and -vvv is 3 so
            # on and so forth. logType is either LOGFILE or CONSOLE depending
            # on where you want to log the messages.
            showUsage, verbosityLevel, reportRunDate, runMode \
                            = self.__GetArgs()

            # Check if you want to print the usage
            if showUsage:
                self.__PrintUsage()
                sys.exit()

            queryDate = None
            reportTimeStamp = None

            # Format report dates
            queryDate, reportRunDate, reportTimeStamp = \
                self.__FormatReportDates(reportRunDate, runMode, \
                                            verbosityLevel)

            # Call function to create the logging object and initialize the
            # parameters as necessary.
            if not self.__CreateLogger(verbosityLevel, runMode):
                return

            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'CreateAuthCountReport() at Line #: {1}. Report ' \
                    'Run Date: {2}{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, \
                                                    reportRunDate, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format( \
                                    __file__, self.__lineNum, \
                                    reportRunDate, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                    return

        except Exception as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                    'Error in Module: {0} CreateAuthCountReport() ' \
                    'method at Line #: {1}: {2}{3}')
            if self.__logType != 'LOGFILE':
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    str(exceptError), ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # Print the usage parameters
            self.__PrintUsage()

            # Log to the log file
            if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            __file__, self.__lineNum, \
                            str(exceptError), '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Send an email alert.
            if runMode == 'PROD':
                emailSubject = ( \
                    'An exception occurred generating Auth Count Report ' \
                    'for %s' % (reportRunDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating ' \
                    'Auth Count Report for %s' % (reportRunDate))

            emailBody = self.__formatBuffer.format( \
                            __file__, self.__lineNum, '', \
                            str(exceptError), '')

            # If called with -v Debug flag or test mode print the email config
            # file path.
            if  verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        'CreateAuthCountReport() at Line #: {1}. Email ' \
                        ' config file path: {2}.{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                self.__lineNum, self.__emailConfigFile, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # This is how you will initiate the error email. Note that the
            # email class object is created within this function.
            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='AUTH_COUNT_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
        else:
            # Call function to create the database class object.
            if not self.__CreateDbObject(verbosityLevel, runMode):
                self.__lineNum = self.__GetLineNo() - 1
                # Log a warning message
                if not self.__loggerObj.ResetLoggingLevel('warning'):
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        'CreateAuthCountReport() at Line #: {1}. Unable ' \
                        'to reset the logging level to WARNING.{2}')
                    if self.__logType != 'LOGFILE':
                        print(self.__FormatMessage( \
                                self.__formatBuffer.format(__file__, \
                                                        self.__lineNum, ''), \
                                width=80, initial_indent='\n        ', \
                                subsequent_indent=' ' * 8, \
                                break_long_words=False, \
                                break_on_hyphens=False), '\n')

                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: '
                    'CreateAuthCountReport() at Line #: {1}. Unable to ' \
                    ' create the csv file.{2}')
                if self.__logType != 'LOGFILE':
                    print(self.__FormatMessage( \
                            self.__formatBuffer.format(__file__, \
                                                        self.__lineNum, ''), \
                            width=80, initial_indent='\n        ', \
                            subsequent_indent=' ' * 8, \
                            break_long_words=False, \
                            break_on_hyphens=False), '\n')

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format( \
                                    __file__, self.__lineNum, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'ERROR'):
                    return
                return

            strFormat = '{0}%'
            queryDateDict = {'queryDateVar' : strFormat.format(queryDate)}
            if self.__logType != 'LOGFILE':
                print('        ', queryDateDict)
            # Log the dictionary value to the log file
            self.__formatBuffer = None
            self.__formatBuffer = \
                    'Query date dictionary value : {0}'.format(queryDateDict)
            if not self.__loggerObj.LogMessage(self.__formatBuffer, 'BODY'):
                pass

            outFileName = '{0}_{1}.csv'.format( \
                                    __file__.upper().strip('.PY'), queryDate)
            outFileName = outFileName.strip('./')

            outFilePath = './ARCHIVE/'
            if not self.__CreateAuthCountFile(runMode, queryDateDict, \
                                reportTimeStamp, outFileName, outFilePath):
                return

            outMessage = 'Successfully created %s file.' % (outFileName)

            self.__LogEndMessage(outMessage)


# If calling the script standalone add the following code.
if __name__ == '__main__':
    authCountClassObj = AuthCountClass()
    authCountClassObj.CreateAuthCountReport()
