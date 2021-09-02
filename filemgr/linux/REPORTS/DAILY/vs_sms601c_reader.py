#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to read the file containing the Visa transactions and settlement data
and extract the data relevant to the SMS601C portion of the report.
"""


import glob
import os
import configparser
import logging
import inspect
import argparse
import sys
import shutil
import subprocess
import textwrap
from datetime import datetime
from datetime import timedelta
sys.path.append('/clearing/filemgr/MASCLRLIB')
from logger_class import LoggerClass
from enhanced_email_class import EnhancedEmailClass

# Add pylint directives to suppress warnings you don't want it to report
# as warnings. Note they need to have the hash sign as shown below.
# pylint: disable = unbalanced-tuple-unpacking
# pylint: disable = invalid-name
# pylint: disable = line-too-long
# pylint: disable = protected-access
# pylint: disable = bare-except
# pylint: disable = pointless-string-statement
# pylint: disable = too-many-lines

class LocalException(Exception):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A local exception class to post exceptions local to this module.

            The local exception class is derived from the Python base exception
            class. It is used to throw other types of exceptions that are not
            in the standard exception class.

        Author:
            Leonard Mendis

        Date Created:
            May 01, 2018

        Modified By:

        References:
            https://www.geeksforgeeks.org/user-defined-exceptions-python-examples/

    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)


# ****************************************************************************************

    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        GetLineNo():
            Returns the current line number of the executing code.

        Parameters:
            None.

        Returns: Current line number in the code.

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
def GetLineNo():

    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        __GetLineNo():
            Returns the current line number of the executing code.

        Parameters:
            None.

        Returns: Current line number in the code.

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Use the currentframe and get the line number of the excuting code.
    return inspect.currentframe().f_back.f_lineno


# ****************************************************************************************

def PrintUsage():
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        PrintUsage():
            Prints the usage parameters for calling the program.

        Parameters:
            None.

        Returns:
            None.
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    print( \
        ('        Usage is:\n            %s [-u or -U or --usage]\n' \
        '            [-v or -V or --verbose <Verbosity Level>]\n' \
        '            [-t or -T or --test (Optional)]\n' \
        '            [-l or -L or --logtype <LOGFILE/CONSOLE/BOTH> \n' \
        '            [-f or -F or --file <File name to download from dfw-prd-clr-01> ' \
        '(Optional)]\n\n            %s\n                %s\n' \
        '                %s\n                %s\n                ' \
        '%s\n                %s\n') \
        % (__file__, 'Verbosity Levels:', '-v     - Debug', '-vv    ' \
            '- Info', '-vvv   - Warning', '-vvvv  - Error', \
            '-vvvvv - Critical'))

# ****************************************************************************************

def PrintOlderFiles():
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        PrintOlderFiles():
            Prints the SMS601C reader input and associated output redirect files older
            than 3 months from the archive directory.

        Parameters:
            None

        Returns:
            True if successful, False else.
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    searchFilePattern = 'ARCHIVE/INVS.PDCTF01.????.???.????????.asc'

    basePath = os.path.dirname(os.path.abspath(__file__))

    ninetyDaysAgo = datetime.now() - timedelta(days=90)
    print('ninetyDaysAgo: {0}\n'.format(ninetyDaysAgo))

    sourceFilePath = os.path.join(basePath, searchFilePattern)
    print('sourceFilePath: {0}\n'.format(sourceFilePath))

    for fileName in glob.glob(sourceFilePath):
        # print('Files matching file pattern in ARCHIVE: {0}\n.format(fileName))
        # Delete code should go here
        fileTime = datetime.fromtimestamp(os.path.getctime(fileName))

        if fileTime < ninetyDaysAgo:
            # print('fileTime: {0}  fileName: {1}\n'.format(fileTime, fileName))
            if os.path.exists(fileName):
                print('fileTime: {0}\n    File older than 90 days: ' \
                      '{1}\n'.format(fileTime, fileName))
                # In order to delete the files older than 90 days matching the
                # above pattern in the ARCHIVE, add the remove function available
                # in the os library here.


# ****************************************************************************************

def StdDateToJulianDate(stdDate, dateFormat):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        StdDateToJulianDate():
            Converts a standard date into a julian date.

        Parameters:
            stdDate    - Date to convert to Julian date
            dateFormat - Format string of the date being passed

        Returns:
            Julian date.
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    try:
        # sdtDate = datetime.datetime.strptime(stdDate, dateFormat)
        sdtDate = datetime.now().strptime(stdDate, dateFormat)
        # print('1. sdtDate: {0}'.format(sdtDate))

        sdtDate = sdtDate.timetuple()
        # print('2, sdtDate: {0}'.format(sdtDate))

        julianDate = sdtDate.tm_yday
        # Convert it into a 3 character string in the form of 'JDN' where
        # JDN = Zero filled Julian Date Number
        julianDateString = str(julianDate).zfill(3)

        # print('julianDateString: {0}'.format(julianDateString))
        return julianDateString
    except (AttributeError, ValueError) as exceptionError:
        print('An exception occurred in the {0} module StdDateToJulianDate() method. ' \
              'Error: {1}\n'.format(__file__, str(exceptionError)))
        return '000'


# ****************************************************************************************

class sms601cReaderClass(object):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for reading the Visa Reports and extracting the data relevant
            to the Visa SMS601C text file.

        Author:
            Leonard Mendis

        Date Created:
            May 07, 2020

        Modified By:

    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes - General
    __errorMessage = None       # Attribute to hold error messages
    __lineNum = 0
    __formatBuffer = None
    __emailAlertBodyText = None
    __emailAlertSubjectText = None
    __emailConfigFile = None
    __runMode = 'PROD'
    __loggingLevel = 'INFO'     # Initialize it to information logging
    __logType = 'LOGFILE'       # Logging type - LOGFILE/CONSOLE/BOTH

    # Private class attributes - Reader
    __loggerObj = None
    __fieldConfigFile = None
    __reportDate = None
    __outFileName = None
    __inFileName = None
    __verbosityLevel = 0
    __remoteServer = None
    __remoteFilePath = None
    __remoteFileName = None
    __remoteUser = None
    __reportStartColumn = 0
    __reportEndColumn = 0


    def __FormatMessage(self, unwrappedText, **keywordArgs):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                    self.__lineNum = GetLineNo() - 1
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


    # ****************************************************************************************

    def __LogEndMessage(self, endMessage=None):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __LogEndMessage(self):
                Logs the end message to the log file.

            Parameters:
                End message if any.

            Returns:
                None.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # This is an informational message, so set the debug level to INFO
        self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

        if not self.__loggerObj.LogMessage( \
            'End Execution: %s %s\n           %s' \
            % (__file__, (datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                        endMessage), 'END'):
            self.__lineNum = GetLineNo() - 4
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Print message generated in Module: {0} Method: ' \
                '__LogEndMessage() at Line #: {1}. Unable to ' \
                'log message.')

            if self.__logType != 'LOGFILE':
                self.__lineNum = GetLineNo() - 1
                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')


    # ****************************************************************************************

    def __SendAlertMail(self, emailFilesList=None):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __SendAlertMail():
                Called from other parts of the program to send an alert email when an error
                occurs.

            Parameters:
                emailFilesList - Optional email files to attach in list form

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        if self.__runMode == 'PROD':
            emailConfigFile = 'enhanced_email_config.ini'
        else:
            # Reminder that you are running in TEST mode, so use the test email config
            # file
            print('You are running this program as a test. Make a copy of the ' \
                  'enhanced_email_config.ini (Note: this can be found in MASCLRLIB) ' \
                  'and make changes to suit your testing requirements and put a copy ' \
                  'in your local drive to run the program as a test.\n')
            emailConfigFile = '{0}/test_enhanced_email_config.ini'.format(os.getcwd())

        configSection = 'VISA_SMS601C_ALERTS'
        emailFilesPath = os.path.dirname(os.path.abspath(__file__))

        if self.__emailAlertBodyText:
            emailBodyText = self.__emailAlertBodyText
        if self.__emailAlertSubjectText:
            emailSubject = self.__emailAlertSubjectText

        # Create email object
        emailObj = EnhancedEmailClass(READ_FROM_CONFIG_FILE=emailConfigFile, \
                                             CONFIG_SECTION_NAME=configSection, \
                                             EMAIL_SUBJECT=emailSubject, \
                                             EMAIL_BODY=emailBodyText)

        # Attach files if any. You can attach files only after creating the email object
        if emailFilesList:
            emailObj.AttachFiles(ATTACH_FILES_LIST=emailFilesList, \
                        ATTACH_FILES_FOLDER=emailFilesPath)

        self.__lineNum = GetLineNo() + 1
        if not emailObj.SendEmail():
            self.__formatBuffer = ( \
                'Unable to send alert email. Error occurred in __SendAlertMail() ' \
                'method in {0} module at Line #: {1}.{2}')

            # This is an error  message, so set the debug level to ERROR
            self.__loggerObj.ResetLoggingLevel('ERROR')

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, \
                                            self.__lineNum, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
        return True


    # ****************************************************************************************

    def __ParseAndWriteToOutputFile(self, fileName):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ParseAndWriteToOutputFile():
                Invokes methods to parse the data file and extract the data into a dictionary.

            Parameters:
                fileName - File to process

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            localErrorMessage = '{0}. This is an informational message only. Message ' \
                                'generated in the __ParseAndWriteToOutputFile() ' \
                                'method at Line #: {1} of {2} module'
            ioErrorMessage = 'I/O Error occurred in the __ParseAndWriteToOutputFile() ' \
                             'method at Line #: {0} of {1} module. Error Details: {2}{3}'
            otherErrorMessage = 'Error occurred in the __ParseAndWriteToOutputFile() ' \
                                'method at Line #: {0} of {1} module. Error ' \
                                'Details: {2}{3}'

            # print('File Name: {0}\n'.format(fileName))
            if not fileName:
                self.__lineNum = GetLineNo() - 1
                self.__errorMessage = \
                    localErrorMessage.format('There is no file to process', \
                                             self.__lineNum, __file__)
                raise LocalException(self.__errorMessage)

            savedReportID = None
            self.__lineNum = GetLineNo() + 1
            anyDataWritten = False
            with open(fileName, 'r') as fileHandle:
                self.__outFileName = '{0}.out'.format(fileName)
                with open(self.__outFileName, 'w') as outFileHandle:
                    self.__lineNum = GetLineNo() + 1
                    for textLine in fileHandle:
                        # We only want the portion of the text file starting at column 17
                        # and ending at column 149
                        self.__lineNum = GetLineNo() + 1
                        textToWrite = textLine[int(self.__reportStartColumn):\
                                               int(self.__reportEndColumn)]

                        # Add a space at the beginning of the report line to be
                        # consistent with the rest of the data which has a space
                        # in the first position.
                        textToWrite = ' {0}\n'.format(textToWrite)

                        # Check if the report ID is 'SMS601C' type report
                        if 'REPORT ID: SMS601C' in textToWrite:
                            savedReportID = 'REPORT ID: SMS601C'

                        # Process only the text lines relevant to the SMS601C report
                        if not savedReportID:
                            continue

                        # Write to the output file
                        # print('{0}'.format(textToWrite))
                        outFileHandle.write(textToWrite)
                        anyDataWritten = True

                        # This is the part of the report that summarizes a set of
                        # transactionsfor a given affiliate ID
                        if 'NON FINANCIAL :' in textLine:
                            savedReportID = None
                            continue
            # Check if there was any SMS601C data in the file downloaded
            if not anyDataWritten:
                basePath = os.path.dirname(os.path.abspath(__file__))
                sourceFilePath = os.path.join(basePath, self.__outFileName)
                os.remove(sourceFilePath)

                self.__lineNum = GetLineNo() - 1
                tempMessage = 'No SMS601C records found in the downloaded file: ' \
                              '{0}'.format(fileName)
                self.__errorMessage = \
                        localErrorMessage.format(tempMessage, self.__lineNum, __file__)
                raise LocalException(self.__errorMessage)

            return True
        except IOError as exceptError:
            errorNum, errorString = exceptError.args
            self.__errorMessage = \
                    ioErrorMessage.format(self.__lineNum, __file__, errorString, '')
            print(self.__FormatMessage( \
                    self.__errorMessage, width=80, initial_indent='\n    ', \
                    subsequent_indent=' ' * 4, break_long_words=False, \
                    break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            self.__errorMessage = \
                    ioErrorMessage.format(self.__lineNum, __file__, errorString, '\n')
            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__errorMessage, width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before
            # the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailAlertBodyText = str(self.__errorMessage)
            self.__emailAlertSubjectText = 'Exception: Parsing the raw VISA Debit ' \
                                           'Report text file {0}.'.format(fileName)
            self.__SendAlertMail()

            return False
        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(exceptionError.value, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before
            # the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailAlertBodyText = exceptionError.value
            self.__emailAlertSubjectText = 'Exception: reading raw VISA Debit Report '\
                                            'input text file {0}.'.format(fileName)
            self.__SendAlertMail()
            return False
        except (ValueError, TypeError) as valueException:
            self.__errorMessage = \
                    otherErrorMessage.format(self.__lineNum, __file__, \
                                             str(valueException), '')

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            self.__errorMessage = \
                    otherErrorMessage.format(self.__lineNum, __file__, \
                                             str(valueException), '\n')

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__errorMessage, width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailAlertBodyText = str(self.__errorMessage)
            self.__emailAlertSubjectText = 'Exception: Parsing the raw VISA Debit ' \
                                           'Report text file {0}.'.format(fileName)
            self.__SendAlertMail()
            return False
        else:
            return False


    # ****************************************************************************************

    def __CreateLogger(self, verbosityLevel):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateLogger():
                Initialize the logging object for logging messages to the
                log file.

            Parameters:
                verbosityLevel - Level of logging to the file - DEBUG, INFO,
                                 WARNING, ERROR, or CRITiCAL.

            Returns:
                True if logger object was created and initialized, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            handleType = 'LOGFILE'      # Initialize it to logging to a file

            # Create the logging object and set the logging level and the log
            # handle type based the verbosity and the log type passed to the
            # function.
            basePath = os.path.dirname(os.path.abspath(__file__))

            if  verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = GetLineNo() - 1
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
                self.__lineNum = GetLineNo() - 1
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
                self.__lineNum = GetLineNo() - 1
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
                self.__lineNum = GetLineNo() - 1
                raise LocalException('Unable to create the logger object.')

            # Check the verbosity level and set the logging level accordingly.
            # The logging level is the number of -v options passed in the
            # program arguments. Initially the LOG_LEVEL is set to 'info' and
            # LOG_TYPE to 'logfile'. Note that the LOG_LEVEL can be changed by
            # passing the required verbosity level to the ResetLoggingLevel()
            # method in the logger class later.
            if  verbosityLevel == 1:            # called with -v
                self.__loggingLevel = 'DEBUG'
            elif verbosityLevel == 2:           # called with -vv
                self.__loggingLevel = 'INFO'
            elif verbosityLevel == 3:           # called with -vvv
                self.__loggingLevel = 'WARNING'
            elif verbosityLevel == 4:           # called with -vvvv
                self.__loggingLevel = 'ERROR'
            elif verbosityLevel == 5:           # called with -vvvvv
                self.__loggingLevel = 'CRITICAL'

            handleType = self.__logType

            # Set up logging parameters. This is the second step in the logging
            # process.
            if not self.__loggerObj.SetupLogFileParams(backupCount=10):
                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = 'Unable to set up the log file parameters. ' \
                                      'Error occurred in Module: {0} __CreateLogger() ' \
                                      'method at Line #: ' \
                                      '{1}.'.format(__file__, self.__lineNum)

                raise LocalException(self.__formatBuffer)

            # Now set the logging attributes. This is the third step in the
            # logging process. Note that the named parameters in the
            # SetupLoggingAttributes() method is not case sensitive. LOG_TYPE
            # can be 'logfile', 'console' or 'both' ('both' means logging to a
            # log file and the console).
            if not self.__loggerObj.SetupLoggingAttributes( \
                                LOG_LEVEL=self.__loggingLevel, Log_Type=handleType):
                self.__lineNum = GetLineNo() - 2
                self.__formatBuffer = 'An error occurred setting logger attributes in ' \
                                      'Module: {0} __CreateLogger() method at Line #: ' \
                                      '{1}.'.format(__file__, self.__lineNum)

                raise LocalException(self.__formatBuffer)

            # Set up log handlers. This function must be called fourth.
            if not self.__loggerObj.SetupLogHandlers():
                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = 'Unable to set the log file handlers. Error ' \
                                      'occurred in Module: {0} __CreateLogger() method ' \
                                      'at Line #: {1}.{2}'.format(__file__, \
                                                               self.__lineNum, '\n')

                raise LocalException(self.__formatBuffer)

            if not self.__loggerObj.LogMessage( \
                    'Begin Execution: %s %s' % \
                    (__file__, datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                    'BEGIN'):
                if self.__loggerObj.verbosityLevel == logging.DEBUG:
                    self.__lineNum = GetLineNo() - 1
                    self.__formatBuffer = 'Unable to write debug messages to the log ' \
                                          'file. Error occurred in Module: {0} ' \
                                          '__CreateLogger() method at Line #: ' \
                                          '{1}.'.format(__file__, self.__lineNum)
                    raise LocalException(self.__formatBuffer)

                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = 'Unable to write  messages to the log file. ' \
                                      'Error occurred in Module: {0} __CreateLogger() ' \
                                      'method at Line ' \
                                      '#: {1}.'.format(__file__, self.__lineNum)
                raise LocalException(self.__formatBuffer)
            return True
        except LocalException as exceptError:
            # Send an alert email
            self.__emailAlertBodyText = exceptError
            self.__emailAlertSubjectText = \
                'Exception: Unable to Create Logger for Parsing the VISA Debit Report'
            self.__SendAlertMail()
            return False
        else:
            return True


    def __ReadVisaConfigFile(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ReadVisaConfigFile():
                Reads the visa_sms601c_config.cfg file to obtain the section values pertaining
                to the SMS601C reader class.

            Parameters:
                None

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        """

        try:
            self.__formatBuffer = 'Error occurred in {0} module __ReadVisaConfigFile()' \
                                  ' method at Line #: {1}. Error message: {2}.{3}'

            basePath = os.path.dirname(os.path.abspath(__file__))
            if self.__fieldConfigFile:
                configFile = os.path.join(basePath, self.__fieldConfigFile)

            self.__formatBuffer = None

            # Create the ConfigParser object. Use RawConfigParser() with allow_no_value
            # set to True for section attributes with no value.
            if os.path.exists(configFile):
                configObj = configparser.RawConfigParser(allow_no_value=True)
                configObj.read(configFile)

                configSectNames = configObj.sections()

                for eachSection in configSectNames:
                    self.__lineNum = GetLineNo() - 1
                    if eachSection == 'REPORT_LINES':
                        self.__lineNum = GetLineNo() + 1
                        self.__reportStartColumn = configObj[eachSection]['START_COL']
                        self.__lineNum = GetLineNo() + 1
                        self.__reportEndColumn = configObj[eachSection]['END_COL']
                    # Changing code to get the user and server name from the envioronment
                    # if eachSection == 'REMOTE_SERVER':
                        # self.__lineNum = GetLineNo() + 1
                        # self.__remoteServer = \
                            # configObj.get(eachSection, 'remoteServer').strip('\'')
                    # if eachSection == 'REMOTE_USER':
                        # self.__lineNum = GetLineNo() + 1
                        # self.__remoteUser = \
                            # configObj.get(eachSection, 'remoteUser').strip('\'')
                    elif eachSection == 'REMOTE_FILE_PATH':
                        self.__lineNum = GetLineNo() + 1
                        self.__remoteFilePath = \
                            configObj.get(eachSection, 'remoteFilePath').strip('\'')
                    elif eachSection == 'REMOTE_FILE_NAME':
                        self.__lineNum = GetLineNo() + 1
                        self.__remoteFileName = \
                            configObj.get(eachSection, 'remoteFileName').strip('\'')
                    else:
                        continue
            # Get the remote server and user names from the environment variable
            self.__remoteServer = os.environ.get('CLEARING_HOST_NAME')
            self.__remoteUser = os.environ.get('FMGR_USERNAME')
            # print('self.__remoteServer: {0}   self.__remoteUser: {1}\n'.format(\
            #         self.__remoteServer, self.__remoteUser))

            return True
        except (configparser.NoSectionError, configparser.NoOptionError,
                configparser.DuplicateSectionError,
                configparser.MissingSectionHeaderError,
                configparser.ParsingError, configparser.Error) \
                as configException:
            print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                    self.__lineNum, configException.message, ''), \
                        width=80, initial_indent='\n    ', \
                        subsequent_indent=' ' * 4, break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            self.__loggerObj.ResetLoggingLevel('ERROR')

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                        configException.message, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailAlertBodyText = \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                               configException.message, '')
            self.__emailAlertSubjectText = \
                    'Exception: Parsing VISA Debit Report Field Config File'

            self.__lineNum = GetLineNo() + 1
            self.__SendAlertMail()
            return False
        except (ValueError, TypeError, AttributeError) as errorException:
            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                               str(errorException), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                               str(errorException), ''), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            self.__emailAlertBodyText = \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                               configException.message, '')
            self.__emailAlertSubjectText = \
                    'Exception: Parsing VISA Debit Report Field Config File'

            self.__lineNum = GetLineNo() + 1
            self.__SendAlertMail()
            return False
        else:
            return True


    # ****************************************************************************************

    def ProcRawFile(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ProcRawFile(self):
                Calls the __ParseAndWriteToOutputFile() method to read the input data and
                write to a temporary file as an input to the SMS601C Parser program.

            Parameters:
                None.

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Call function to create the logging object and initialize the parameters as necessary.
        if not self.__CreateLogger(self.__verbosityLevel):
            return False

        # Read config file
        if not self.__ReadVisaConfigFile():
            return False
        print('self.__inFileName: {0}\n'.format(self.__inFileName))

        filesToProcess = False
        if self.__inFileName:
            if not self.__ParseAndWriteToOutputFile(self.__inFileName):
                return False
            filesToProcess = True
        # Read the config file to get field remote server and file information
        else:
            # Download The Visa SMS601C raw data file. Note that this is downloaded from
            # dfw-prd-clr-01 box after it is loaded to the following diretory via a Fis
            # process. The file will not be available until and after 10:00 AM every day.
            # Directory: /clearing/apps/clearing/pdir20200123/ositeroot/data/done/
            # File Name: INVS.PDCTF01.0127.001 (Always named the same except the '0127'
            # which is the julian date)

            # Create the scp command to copy the files
            # scp filemgr@dfw-prd-clr-01:/clearing/apps/clearing/pdir/ositeroot/data/done/INVS.PDCTF01.0127.001 /tmp

            julianDate = StdDateToJulianDate(self.__reportDate, '%Y%m%d')

            # print('Standard date [self.__reportDate] {0} to Julian Date {1}\n'.format(\
            #                 self.__reportDate, julianDate))
            if julianDate == '000':
                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = 'Unable to obtain julian date. Error occurred in ' \
                                      '{0} module ProcRawFile() method at Line #: {1}{2}'

                # This is an error  message, so set the debug level to ERROR
                self.__loggerObj.ResetLoggingLevel('ERROR')

                # Log to the log file only if the logger object was created.
                if self.__loggerObj and not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    sys.exit()

                # Reset the logging level to what was originally set before the error
                self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
                return False

            destinationFile = '{0}/{1}.{2}{3}.{4}.' \
                '{5}'.format(os.path.dirname(os.path.abspath(__file__)), \
                             self.__remoteFileName[:12], self.__reportDate[3:4], \
                             julianDate, self.__remoteFileName[15:], self.__reportDate)
            # print('destinationFile: {0}'.format(destinationFile))

            scpCommand = \
                'scp {0}@{1}:{2}{3} {4}'.format(self.__remoteUser, self.__remoteServer, \
                                                self.__remoteFilePath, \
                                                self.__remoteFileName, destinationFile)
            # print('scpCommand: {0}'.format(scpCommand))

            self.__lineNum = GetLineNo() + 1
            procRetValue = subprocess.Popen(scpCommand, shell=True, \
                                            stdout=subprocess.PIPE, \
                                            stderr=subprocess.STDOUT).wait()
            # An error occurred in the call to subprocess
            if procRetValue:
                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = \
                    ('Error occurred in {0} module ProcRawFile() method at Line #: ' \
                     '{1}. Unable to download the Visa SMS601C raw data file. ' \
                     'Subprocess Popen returned a {2} error value.{3}')

                print(self.__FormatMessage( \
                            self.__formatBuffer.format(__file__, self.__lineNum, \
                                                       procRetValue, ''), \
                            width=80, initial_indent='\n    ', \
                            subsequent_indent=' ' * 4, break_long_words=False, \
                            break_on_hyphens=False), '\n')

                # This is an error  message, so set the debug level to ERROR
                self.__loggerObj.ResetLoggingLevel('ERROR')

                # Log to the log file only if the logger object was created.
                if self.__loggerObj and not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                                   procRetValue, '\n'), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, \
                        break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    sys.exit()

                # Reset the logging level to what was originally set before the error
                self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                # Send an alert email
                self.__emailAlertBodyText = \
                                self.__formatBuffer.format(__file__, self.__lineNum, \
                                                           procRetValue, '')
                self.__emailAlertSubjectText = \
                        'IGNORE: Unable to download the Visa SMS601C raw data file. '

                self.__lineNum = GetLineNo() + 1
                self.__SendAlertMail()

                return False

            self.__inFileName = os.path.basename(destinationFile)
            # If the file failed to parse, go ahead and archive the input file
            if not self.__ParseAndWriteToOutputFile(self.__inFileName):
                # If the input file is there encrypt and archive
                print('1. self.__inFileName: {0}\n'.format(self.__inFileName))
                if self.__inFileName:
                    encryptKeyToArchive = os.environ['ARCHIVE_ENCRYPT_KEY']
                    print('encryptKeyToArchive: {0}\n'.format(encryptKeyToArchive))
                    self.__lineNum = GetLineNo() + 1
                    gpgCommand = 'gpg --encrypt --armor --recipient {0} ' \
                                 '{1}'.format(encryptKeyToArchive, self.__inFileName)
                    print('gpgCommand: {0}\n'.format(gpgCommand))

                    basePath = os.path.dirname(os.path.abspath(__file__))
                    sourceFilePath = os.path.join(basePath, self.__inFileName)
                    self.__lineNum = GetLineNo() + 2
                    # No errors encrypting the file, so archive the input file
                    if not os.system(gpgCommand):
                        encryptedFileName = '{0}.asc'.format(self.__inFileName)
                        encryptedFileWithPath = os.path.join(basePath, encryptedFileName)
                        print('encryptedFileWithPath: {0}\n'.format(encryptedFileWithPath))

                        # Archive the encrypted file
                        archiveFileWithPath = \
                            os.path.join(basePath, 'ARCHIVE/{0}'.format(encryptedFileName))
                        print('archiveFileWithPath: {0}\n'.format(archiveFileWithPath))
                        shutil.move(encryptedFileWithPath, archiveFileWithPath)

                        # Now remove the SMS601C report input file
                        os.remove(sourceFilePath)
                    else:
                        self.__formatBuffer = \
                            'Unable to encrypt the file {0} file. Error generated in ' \
                            '{1} module ProcRawFile() method at Line #: {2}{3}'

                        print(self.__FormatMessage( \
                                self.__formatBuffer.format(self.__inFileName, __file__, \
                                                           self.__lineNum, ''), \
                                width=80, initial_indent='\n    ', \
                                subsequent_indent=' ' * 4, \
                                break_long_words=False, break_on_hyphens=False), '\n')

                        # This is an error  message, so set the debug level to ERROR
                        if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                            return False

                        # Log to the log file only if the logger object was created.
                        if self.__loggerObj and not self.__loggerObj.LogMessage( \
                            self.__FormatMessage( \
                                self.__formatBuffer.format(self.__inFileName, __file__, \
                                                           self.__lineNum, ''), \
                                width=80, initial_indent='\n            ', \
                                subsequent_indent=' ' * 12, break_long_words=False, \
                                break_on_hyphens=False), 'BODY'):
                            return False

                        # Reset the logging level to what was originally set before
                        # the error
                        self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                        # Reset the logging level to what was originally set before
                        # the error
                        self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                        # Now remove the SMS601C report input file
                        os.remove(sourceFilePath)

                return False

            filesToProcess = True

        if filesToProcess:
            basePath = os.path.dirname(os.path.abspath(__file__))
            sourceFilePath = os.path.join(basePath, self.__inFileName)

            print('2. self.__inFileName: {0}\n'.format(self.__inFileName))

            if self.__inFileName:
                encryptKeyToArchive = os.environ['ARCHIVE_ENCRYPT_KEY']
                print('encryptKeyToArchive: {0}\n'.format(encryptKeyToArchive))
                gpgCommand = 'gpg --encrypt --armor --recipient {0} ' \
                             '{1}'.format(encryptKeyToArchive, self.__inFileName)
                print('gpgCommand: {0}\n'.format(gpgCommand))

                self.__lineNum = GetLineNo() + 1
                if not os.system(gpgCommand):
                    encryptedFileName = '{0}.asc'.format(self.__inFileName)
                    encryptedFileWithPath = os.path.join(basePath, encryptedFileName)
                    print('encryptedFileWithPath: {0}\n'.format(encryptedFileWithPath))

                    # Archive the encrypted file
                    archiveFileWithPath = \
                        os.path.join(basePath, 'ARCHIVE/{0}'.format(encryptedFileName))
                    print('archiveFileWithPath: {0}\n'.format(archiveFileWithPath))
                    shutil.move(encryptedFileWithPath, archiveFileWithPath)
                else:
                    # Encryption failed, so log an error message
                    self.__formatBuffer = \
                        'Unable to encrypt the file {0} file. Error generated in ' \
                        '{1} module ProcRawFile() method at Line #: {2}{3}'

                    print(self.__FormatMessage( \
                            self.__formatBuffer.format(self.__inFileName, __file__, \
                                                       self.__lineNum, ''), \
                            width=80, initial_indent='\n    ', \
                            subsequent_indent=' ' * 4, \
                            break_long_words=False, break_on_hyphens=False), '\n')

                    # This is an error  message, so set the debug level to ERROR
                    if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                        return False

                    # Log to the log file only if the logger object was created.
                    if self.__loggerObj and not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format(self.__inFileName, __file__, \
                                                       self.__lineNum, ''), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                        return False

                    # Reset the logging level to what was originally set before the error
                    self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                    # Reset the logging level to what was originally set before the error
                    self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
                    return False
            print('Downloaded File to delete: {0}\n'.format(self.__inFileName))
            # Now remove the downloaded SMS601C report input file
            os.remove(sourceFilePath)

        self.__LogEndMessage('Successfuly read {0} input file and created the {1} '\
                             'output file.'.format(self.__inFileName, self.__inFileName))
        return True


    # ****************************************************************************************

    def __GetArgs(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Assign description to the help doc
            self.__lineNum = GetLineNo() + 1
            programDescription = ( \
                'This script parses and returns the command line arguments '
                'for the Visa SMS601C Reader.')

            self.__lineNum = GetLineNo() + 1
            argParser = argparse.ArgumentParser(description=programDescription)

            self.__lineNum = GetLineNo() + 1
            argParser.add_argument( \
                '-u', '-U', '--usage', help='Show how to invoke the script.', \
                required=False, default=False, action='store_true')

            # Add the verbose argument to argparse. Make it not required and
            # let the program handle the required arguments.
            self.__lineNum = GetLineNo() + 1
            argParser.add_argument( \
                    '-v', '-V', '--verbose', action='count', dest='verbose', \
                    help="verbose level... repeat up to five times.")

            # Add the logging level to argparse. Make it not required and let
            # the program handle the required arguments.
            self.__lineNum = GetLineNo() + 1
            argParser.add_argument( \
                    '-l', '-L', '--logtype', type=str,
                    help='One of optional logging flags: LOGFILE, CONSOLE, ' \
                            'or BOTH.', default='LOGFILE', required=False)

            # Add the file optiion to pass a file name to the program
            self.__lineNum = GetLineNo() + 1
            argParser.add_argument( \
                    '-f', '-F', '--file', type=str,
                    help='The visa SMS601C Report file name to read from.', \
                            default=None, required=False)

            # Add the test mode (optional) argument to argparse. Make it not
            # required and let the program handle the required arguments.
            self.__lineNum = GetLineNo() + 1
            argParser.add_argument( \
                    '-t', '-T', '--test', type=str, default='PROD', \
                    help='Run mode indicator (Optional).', required=False)

            # Extract all arguments passed to script into a list
            self.__lineNum = GetLineNo() + 1
            argsList = argParser.parse_args()

            # Assign args to variable(s)
            verbosityLevel = argsList.verbose
            showUsage = argsList.usage
            self.__logType = argsList.logtype
            runMode = argsList.test
            fileName = argsList.file
            # print('In __GetArgs(): fileName <{0}>\n'.format(fileName))

            # Default program run mode
            if runMode != 'PROD':
                runMode = runMode.upper()
            if runMode == 'P':
                runMode = 'PROD'
            elif runMode != 'PROD':     # default set to 'PROD' in argparse
                runMode = 'TEST'

            # Change the email config file to visa_email_config.ini. Otherwise,
            # it is set to email_config.ini in the class __init__() function.
            if  verbosityLevel == 1:     # Verbosity level: Debug
                self.__lineNum = GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__GetArgs() at Line #: {1}. showUsage = {2}  ' \
                    'verbosityLevel = {3}  Run Mode = {4}')

                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                                showUsage, \
                                                str(verbosityLevel), \
                                                str(self.__runMode)), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

        except argparse.ArgumentError as exceptError:
            self.__formatBuffer = 'Unable to set the log file handlers. Error ' \
                                  'occurred in Module: {0} __GetArgs() method at ' \
                                  'Line #: {1}.'.format(__file__, self.__lineNum)
            self.__SendAlertMail()

            if self.__logType != 'LOGFILE':
                self.__lineNum = GetLineNo() - 2
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
            return showUsage, verbosityLevel, runMode, fileName


    # ****************************************************************************************

    def __init__(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the sms601cReaderClass class object.

            Parameters:
                None.

            Returns:
                None.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__lineNum = 0
        self.__formatBuffer = None
        self.__fieldConfigFile = 'visa_sms601c_config.cfg'

        # Get the arguments passed to the program. Note that the verbosityLevel is the number
        # of -v options that the program is called with. For example -v is 1 and -vv is 2 and
        # -vvv is 3 so on and so forth. logType is either LOGFILE or CONSOLE depending on
        # where you want to log the messages.
        showUsage, self.__verbosityLevel, self.__runMode, self.__inFileName = \
                                                                        self.__GetArgs()
        self.__reportDate = datetime.now().strftime('%Y%m%d')

        # Check if you want to print the usage
        if showUsage:
            PrintUsage()
            sys.exit()


# If calling the script standalone add the following code.
if __name__ == '__main__':
    smsReaderObj = sms601cReaderClass()
    smsReaderObj.ProcRawFile()
    # Print the files older than 90 days
    PrintOlderFiles()
