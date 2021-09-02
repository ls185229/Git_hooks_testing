#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to create and email the OKDMV accounting report.
    $Id: okdmv_reports_class.py 4536 2018-04-25 19:56:13Z lmendis $
"""

import os
import logging
import inspect
import argparse
import csv
import sys
import shutil
import textwrap
from datetime import datetime, timedelta

import cx_Oracle
from database_class import DbClass
from logger_class import LoggerClass
from email_class import EmailClass

# pylint: disable = invalid-name
# pylint: disable = protected-access


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
            March 02, 2018

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


class OkdmvReportClass(object):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for creating and mailing the OKDMV report.

        Author:
            Leonard Mendis

        Date Created:
            March 02, 2018

        Modified By:

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes
    __loggerObj = None
    __lineNum = 0
    __emailConfigFile = None
    __formatBuffer = None


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


    # -----------------------        __init__()         -----------------------

    def __init__(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the OKDMV class object.

            Parameters:
                None.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__lineNum = 0
        self.__emailConfigFile = 'email_config.ini'
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

            Returns:
                True if email was sent False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Initialize email argument variables
        emailTextFile = None   # Name of file to read the email text from.
        emailConfig = None     # Name of file to read the email configurations.
        emailBody = None
        emailTo = None
        emailFrom = None
        emailCopy = None
        emailBlindCopy = None
        emailSubject = None
        fileListToAttach = []
        fileFolder = None

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
            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, ''), \
                    width=80, initial_indent='\n        ', \
                                subsequent_indent=' ' * 8, \
                                break_long_words=False, \
                                break_on_hyphens=False), '\n')

            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage( \
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
                                EMAIL_BODY=emailBody, \
                                CONFIG_SECTION_NAME=configSectionName, \
                                TO_ADDRESS=emailTo, FROM_ADDRESS=emailFrom, \
                                COPY_ADDRESS=emailCopy, \
                                BCC_ADDRESS=emailBlindCopy, \
                                EMAIL_SUBJECT=emailSubject)

        # Check if there is an issue creating the email object prior to
        # attaching any files and sending the email.
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

        if fileListToAttach:
            if not emailObj.AttachFiles(ATTACH_FILES_FOLDER=fileFolder, \
                         ATTACH_FILES_LIST=fileListToAttach):
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Unable to attach files to the email. Error occurred ' \
                    'in the __GenerateEmail() method in {0} module ' \
                    'at Line #: {1}.{2}')
                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, ''), \
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

        # Send the email
        if not emailObj.SendEmail():
            return False

        return True


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
            ('Usage is:\n   %s --date <YYYYMMDD> --verbose <verbose level> ' \
            '%s %s\n   %s\n      %s\n      %s\n      %s\n      %s\n      ' \
            '%s\n      %s\n') \
            % (__file__, '--logtype', \
            '<LOGFILE/CONSOLE/BOTH>', '--usage', 'Verbose Levels:', \
            '-v     - Debug', '-vv    - Info', '-vvv   - Warning', \
            '-vvvv  - Error', '-vvvvv - Critical'))


    #----------------------      __CreateCsvFile()      -----------------------

    def __CreateCsvFile(self, repStartDateTime, repEndDateTime, verbosityLevel):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateCsvFile():
                This function takes the start and end dates for the report
                and uses them to run an SQL statement to fetch the results.
                Then it creates a CSV file for distribution.

            Parameters:
                repStartDateTime - Report Start Date YYYYMMDDHHMMSS format.
                repEndDateTime   - Report End Date YYYYMMDDHHMMSS format.
                verbosityLevel   - Verbosity level
                                        - DEBUG/INFO/WARNING/ERROR/CRITICAL

            Returns:
                True if the csv file was created, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            if verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateCsvFile() at Line #: {1}. Report Start ' \
                    'Date and Time: {2} Report End Date and Time: {3}{4}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    repStartDateTime, repEndDateTime, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    repStartDateTime, repEndDateTime, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    return False

            # Use the database class object to initialize the login
            # credentials from the environment variables. Note: The
            # ENV_ prefix in the keyword argument list is the indicator
            # that prompts the class object to grab the credentials from
            # the environment.
            dbObject = DbClass(ENV_HOSTNM='ATH_HOST', \
                                ENV_USERID='ATH_DB_USERNAME', \
                                PORTNO='1521', \
                                ENV_PASSWD='ATH_DB_PASSWORD', \
                                ENV_SERVNM='ATH_DB')
            dbObject.Connect(True)

            # Get the pool number assigned by the object for the acquired
            # connection.
            poolIndex = dbObject.AcquireConnection()
            if verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__CreateCsvFile() at Line #: {1}. poolIndex = {2}{3}')
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    poolIndex, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    poolIndex, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    return False

            # Get the index to the Cursor object created for the above
            # connection.
            cursorNumber = dbObject.OpenCursor(poolIndex)

            sqlText = ("""
                SELECT
                    tran.mid,''''||visa_id "VISA ID",
                    COUNT(1),
                    SUM(
                        CASE
                            WHEN request_type IN ('0200','0260') THEN (amount-fee_amount)
                            WHEN request_type IN ('0400') THEN (amount-fee_amount) * -1
                            WHEN request_type IN ('0420') THEN (amount * -1)
                            ELSE 0
                        END
                    ) AS "Total Amount",
                    SUM(
                        CASE
                            WHEN request_type IN ('0200','0260') THEN (fee_amount)
                            WHEN request_type IN ('0400') THEN (fee_amount * -1)
                            ELSE 0
                        END
                    ) AS "Total Fees",
                    ROUND((SUM(fee_amount) /
                            DECODE(SUM(amount-fee_amount), 0, 1, SUM(amount-fee_amount))*100), 3)
                            AS "fee %"
                FROM    teihost.transaction tran, teihost.merchant merch
                WHERE
                    tran.mid = merch.mid AND
                    tran.mid IN (
                        SELECT mid FROM teihost.merchant
                        WHERE mmid IN (
                            SELECT mmid FROM teihost.master_merchant
                            WHERE shortname = 'OKDMV'
                        )
                    ) AND
                    (shipdatetime >= '{0}' AND shipdatetime < '{1}') AND
                    action_code = '000' AND
                    request_type not IN ('0194','0440', '0730', '0732') AND
                    amount > 0
                GROUP BY visa_id, tran.mid
                ORDER BY visa_id, tran.mid
                """).format(repStartDateTime, repEndDateTime)

            # Print the sql text to the log file
            if not self.__loggerObj.LogMessage(sqlText, 'BODY'):
                pass

            # Note that the positional parameters 1 - 6 must have values.
            # The rest rest are keyword arguments. It is recommended to make
            # the positional arguments as named for clarity but it is not
            # necessary as long as they hold values.
            csvFileName = ('%s-OKDMV_report.csv' % repStartDateTime)
            dbObject.ExportDataFromTable(cursorNumber, \
                                        outputFile=csvFileName, \
                                        outputFilePath=None, \
                                        includeHeaders=True, \
                                        sqlText=sqlText, \
                                        tableName=None, \
                                        delimiter=',', quotechar=None, \
                                        skipinitialspace=False, \
                                        quoting=csv.QUOTE_NONE)

            # Close the second cursor that was opened for the pooled
            # connection.
            dbObject.CloseCursor(cursorNumber)

        except RuntimeError as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'An exception occurred while creating the CSV file in ' \
                'Module: {0} Method: __CreateCsvFile() at Line #: {1}.' \
                '{2}{3}{4}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(__file__, self.__lineNum, \
                                            str(exceptError), ''), \
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
                            str(exceptError), '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False

            # Now send an email alert
            emailSubject = ( \
                'An Error occurred generating OKDMV report for %s to %s' % \
                (repStartDateTime, repEndDateTime))

            emailBody = self.__formatBuffer.format('', '', str(exceptError))

            if not self.__GenerateEmail( \
                                READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                CONFIG_SECTION_NAME='OKDMV_ALERTS', \
                                EMAIL_SUBJECT=emailSubject, \
                                EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')

            return False
        else:
            if not dbObject.errorCode:
                # Release connection back to the pool if you are done.
                dbObject.ReleaseConnection(poolIndex)

                # Disconnect from the database
                dbObject.Disconnect()

                # Send email attachment
                outputFileList = [csvFileName]
                emailSubject = ('OKDMV report for %s to %s' % \
                                    (repStartDateTime, repEndDateTime))

                if not self.__GenerateEmail( \
                                READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                CONFIG_SECTION_NAME='OKDMV_REPORTS', \
                                EMAIL_SUBJECT=emailSubject, \
                                ATTACH_FILES_LIST=outputFileList, \
                                ATTACH_FILES_FOLDER=None):
                    print('            ' \
                            'Unable to generate the OKDMV report Email.\n')
                    return False

                # Archive the file
                basePath = os.path.dirname(os.path.abspath(__file__))
                archivePath = os.path.join(basePath, 'ARCHIVE')

                if not os.path.exists(archivePath):
                    os.makedirs(archivePath)

                sourceFilePath = os.path.join(basePath, csvFileName)
                destFilePath = os.path.join(archivePath, csvFileName)
                shutil.move(sourceFilePath, destFilePath)
                return True


    #--------------------         __CreateLogger()        ---------------------

    def __CreateLogger(self, verbosityLevel, logType):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateLogger():
                Initialize the logging object for logging messages to the
                log file.

            Parameters:
                verbosityLevel - Level of logging to the file - DEBUG, INFO,
                                 WARNING, ERROR, or CRITiCAL.
                logType        - Logging handler type - LOGFILE, CONSOLE, or
                                 BOTH.

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
            if verbosityLevel == 1:             # Called with -v Debug flag
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
            if verbosityLevel == 1:             # Called with -v Debug flag
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

            if verbosityLevel == 1:             # Called with -v Debug flag
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
            self.__loggerObj = LoggerClass( \
                                MODULE_NAME=__file__, \
                                LOG_FILE_PATH=GetPath(logfilePath, basePath), \
                                LOG_FILE_TYPE='TimedRotatingFileHandler')

            # An error occurred during logger object initialization
            if self.__loggerObj.errorCode:
                raise LocalException('Unable to create the logger object.')

            # Check the verbosity level and set the logging level accordingly.
            # The logging level is the number of -v options passed in the
            # program arguments. Initially the LOG_LEVEL is set to 'info' and
            # LOG_TYPE to 'logfile'. Note that the LOG_LEVEL can be changed by
            # passing the reuired verbosity level to the ResetLoggingLevel()
            # method in the logger class later.
            if verbosityLevel == 1:             # called with -v
                loggingLevel = 'DEBUG'
            elif verbosityLevel == 2:           # called with -vv
                loggingLevel = 'INFO'
            elif verbosityLevel == 3:           # called with -vvv
                loggingLevel = 'WARNING'
            elif verbosityLevel == 4:           # called with -vvvv
                loggingLevel = 'ERROR'
            elif verbosityLevel == 5:           # called with -vvvvv
                loggingLevel = 'CRITICAL'

            if logType:
                handleType = logType

            # Set up logging parameters. This is the second step in the logging
            # process.
            if not self.__loggerObj.SetupLogFileParams():
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                                'Unable to set up the log file parameters.')

            # Now set the logging attributes. This is the third step in the
            # logging process. Note that the named parameters in the
            # SetupLoggingAttributes() method is not case sensitive. LOG_TYPE
            # can be 'logfile', 'console' or 'both' ('both' means logging to a
            # log file and the console).
            if not self.__loggerObj.SetupLoggingAttributes( \
                                LOG_LEVEL=loggingLevel, Log_Type=handleType):
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                                'Error occurred setting logger attributes.')

            # Set up log handlers. This function must be called third.
            if not self.__loggerObj.SetupLogHandlers():
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException('Unable to set the log file handlers.')

            if not self.__loggerObj.LogMessage( \
                    'Begin Execution: %s %s' % \
                    (__file__, datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                    'BEGIN'):
                if self.__loggerObj.verbosityLevel == logging.DEBUG:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException( \
                            'Unable to write debug messages to the log file.')
                else:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException( \
                            'Unable to write messages to the log file.')

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Error in {0} module __CreateLogger() method at '
                'Line #: {1}. {2}')
            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                exceptError.value), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, \
                    break_long_words=False, \
                    break_on_hyphens=False), '\n')
            return False
        else:
            return True


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
                The report date passed to the script in YYYYMMDD format, the
                verbosity level, logging type, and usage True/False flag.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Assign description to the help doc
            reportDescription = ( \
                'This script creates a CSV file containing the data for the ' \
                '%s' % 'OKDMV Accounting Report and emails the report to an ' \
                        'email group.')
            argParser = argparse.ArgumentParser(description=reportDescription)
            # Add arguments
            argParser.add_argument( \
                '-u', '-U', '--usage', help='Show how to invoke the script.', \
                required=False, default=False, action='store_true')

            # argParser.add_argument('-v', '--verbose', metavar=int, nargs='+',
            #                         help='Increase output verbosity.',
            #                         required=False)

            # argParser.add_argument('-v', '--verbose', type=int,
            #               help = 'Increase output verbosity.',
            #               required=False, action='count', default=0)

            # argParser.add_argument('-v', '--verbose', action="count",
            #               help="verbose level... repeat up to five times.")

            # Add the verbose argument to argparse.
            argParser.add_argument( \
                    '-v', '-V', '--verbose', action='count', dest='verbose', \
                    help="verbose level... repeat up to five times.")

            # Add the logging level to argparse.
            argParser.add_argument( \
                    '-l', '-L', '--logtype', type=str, help='One of LOGFILE, \
                    CONSOLE, or BOTH, .', required=False)

            # Add the date argument to argparse.
            argParser.add_argument( \
                    '-d', '-D', '--date', type=str, \
                    help='Report date YYYYMMDD format.', required=False)

            # Extract all arguments passed to script into a list
            argsList = argParser.parse_args()

            # Assign args to variable(s)
            verbosityLevel = argsList.verbose
            showUsage = argsList.usage
            reportRunDate = argsList.date
            logType = argsList.logtype

            if verbosityLevel == 1:     # Verbosity level: Debug
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__GetArgs() at Line #: {1}. showUsage = {2}  ' \
                    'verbosityLevel = {3}  reportRunDate = {4}')

                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                                showUsage, \
                                                str(verbosityLevel), \
                                                str(reportRunDate)), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

        except argparse.ArgumentError as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Exception error in Module: {0} __GetArgs() method at ' \
                'Line #: {1}. {2}')

            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                str(exceptError)), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, \
                    break_long_words=False, \
                    break_on_hyphens=False), '\n')
            sys.exit()
        else:
            # Return all variable value(s)
            return showUsage, verbosityLevel, logType, reportRunDate


    #--------------------         GenerateReport()        ---------------------

    def GenerateReport(self):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            GenerateReport()
                Calls a function to extract the command line arguments and
                formats the report start and end dates to be passed on to the
                function that creates the CSV file.

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
            # on and so forth.
            showUsage, verbosityLevel, logType, reportRunDate = \
                                                        self.__GetArgs()

            # Check if you want to print the usage
            if showUsage:
                self.__PrintUsage()
                return

            # Call function to create the logging object and initialize the
            # parameters as necessary.
            if not self.__CreateLogger(verbosityLevel, logType):
                return

            # Now, set the report date.
            if not reportRunDate:
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'GenerateReport() at Line #: {1}. Missing ' \
                    'report date. The date to run the report is ' \
                    'required.{2}')

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

                # Print the end message
                if not self.__loggerObj.LogMessage( \
                        'End Execution: %s %s' % (__file__, \
                        datetime.now().strftime('%Y/%m/%d %H:%M:%S')), 'END'):
                    return

                self.__PrintUsage()
                return

            dateObject = datetime(int(reportRunDate[0:4]), \
                                    int(reportRunDate[4:6]), \
                                    int(reportRunDate[6:8]))
            # print(dateObject.date())

            # Get the day number of the week (0 - Mon, 1 - Tues, 2 - Wed, ....)
            dayNumOfTheWeek = dateObject.date().weekday()
            if verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'GenerateReport() at Line #: {1}. Day Number = {2}{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, \
                                                    dayNumOfTheWeek, ''), \
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
                                    dayNumOfTheWeek, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                    return

            # If the script is called on a Monday, for start date go back three
            # days otherwise go back two days.
            if dayNumOfTheWeek == 0:
                numDaysToGoBack = 3
            else:
                numDaysToGoBack = 2

            reportStartDate = dateObject.date() - timedelta(numDaysToGoBack)
            reportEndDate = dateObject.date() - timedelta(1)

            # Format the report start and end dates with time stamp
            repStartDateTime = ( \
                            '%s181500' % reportStartDate.strftime('%Y%m%d'))
            # print('    GenerateReport(): Report Start Date and Time: ', \
            #               repStartDateTime)
            repEndDateTime = ('%s181500' % reportEndDate.strftime('%Y%m%d'))
            # print('    GenerateReport(): Report Start Date and Time: ', \
            #               repEndDateTime)
            if verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'GenerateReport() at Line #: {1}. Report Start Date ' \
                    'Time: {2}  Report End Date Time: {3}{4}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                                    self.__lineNum, \
                                                    repStartDateTime, \
                                                    repEndDateTime, ''), \
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
                                    repStartDateTime, \
                                    repEndDateTime, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                    return

        except Exception as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                    'Error in Module: {0} GenerateReport() method at '
                    'Line #: {1}. {2}{3}')

            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                str(exceptError), ''), \
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
                            str(exceptError), '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Send an email alert
            emailSubject = ( \
                        'An exception occurred generating OKDMV report ' \
                        'for %s to %s' % (repStartDateTime, repEndDateTime))

            emailBody = self.__formatBuffer.format( \
                            '', __file__, self.__lineNum, '', \
                            str(exceptError), '')

            if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='OKDMV_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
        else:
            # Call function to create the csv file
            if not self.__CreateCsvFile(repStartDateTime, repEndDateTime, \
                                        verbosityLevel):
                self.__lineNum = self.__GetLineNo() - 1
                # Log a warning message
                if not self.__loggerObj.ResetLoggingLevel('warning'):
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        'GenerateReport() at Line #: {1}. Unable to ' \
                        'reset the logging level to WARNING.{2}')

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
                    'GenerateReport() at Line #: {1}. Unable to create ' \
                    'the csv file.{2}')

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

            outputFile = ('%s-OKDMV_report.csv' % repStartDateTime)
            if not self.__loggerObj.LogMessage( \
                'End Execution: %s %s\n           %s%s %s' \
                % (__file__, (datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                    'Successfully created ', outputFile, 'file.'), 'END'):
                self.__lineNum = self.__GetLineNo() - 3
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'GenerateReport() at Line #: {1}. Unable to ' \
                    'log message.')

                self.__lineNum = self.__GetLineNo() + 1
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
                return


# If calling the script standalone add the following code.
if __name__ == '__main__':
    okdmvRepObj = OkdmvReportClass()
    okdmvRepObj.GenerateReport()
