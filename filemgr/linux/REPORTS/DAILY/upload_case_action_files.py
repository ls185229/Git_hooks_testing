#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
A python script to search for the daily case action files TSYS places on the clearing server, unzip
them, and transfer them to the SFTP server in the /secure/jetcorp/tx directory.
"""
import os
import logging
import inspect
import argparse
import textwrap
import sys
from datetime import datetime
import subprocess


#pylint: disable = wrong-import-position
#pylint: disable = invalid-name

# Add the library path. Note that the DbClass, LoggerClass, and EmailClass are
# libraries that reside in the /clearing/filemgr/MASCLRLIB directory. This line
# must be positioned prior to the import of the class libraries. Refer to
# https://www.blog.pythonlibrary.org/2016/03/01/python-101-all-about-imports/


sys.path.append('/clearing/filemgr/MASCLRLIB')
from logger_class import LoggerClass
from enhanced_email_class import EnhancedEmailClass

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


class UploadCaseActionFiles():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module that transfers daily TSYS case action files between servers.

        Author:
            Mira Fazzah

        Date Created:
            15 April 2021

        References:
            florida_cogs_class.py by Leonard Mendis
                https://github.com/ncr-payment-solutions/NPP-SETTLEMENT-MAS/blob/
                0217739c2729a2dafd4b1c6d02e04e8679247a60/filemgr/linux/REPORTS/
                MONTHLY/COGS-FL/florida_cogs_class.py

            The methods __GenerateEmail, __FormatMessage, __PrintUsage, __CreateLogger,
            __GetArgs, and __LoadFile were used and adapted for this script.

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    #private class attributes
    __loggerObj = None
    __lineNum = 0
    __emailConfigFile = None
    __formatBuffer = None
    __verbosityLevel = None
    __runMode = None

    # -----------------------        __init__()         -----------------------

    def __init__(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the TSYS send class object.

            Parameters:
                None.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__lineNum = 0
        self.__formatBuffer = None


    # -----------------------        __GetLineNo()         -----------------------
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
                    CC_ADDRESS
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

        if keywordArgs:
            keywordDict = {}
            for keywordParam in keywordArgs:
                keywordToUpper = keywordParam.upper()
                # Add to the dictionary
                keywordDict.update({keywordToUpper : keywordArgs[keywordParam]})

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
                elif keywordToUpper == 'CC_ADDRESS':
                    emailCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'BCC_ADDRESS':
                    emailBlindCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EMAIL_SUBJECT':
                    emailSubject = keywordDict[keywordToUpper]
                else:
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ('Invalid keyword passed to the __GenerateEmail() '
                                           'method in {0} module at Line #: {1}.{2}')
                    print(self.__FormatMessage(\
                            self.__formatBuffer.format(__file__, self.__lineNum, ''), \
                            width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                            break_long_words=False, break_on_hyphens=False), '\n')
                    # Log to the log file
                    self.__lineNum = self.__GetLineNo() + 1
                    if not self.__loggerObj.LogMessage(\
                        self.__FormatMessage(\
                            self.__formatBuffer.format(__file__, self.__lineNum, '\n'), width=80, \
                            initial_indent='\n            ', subsequent_indent=' ' * 12, \
                            break_long_words=False, break_on_hyphens=False), 'BODY'):
                        return False

        # Two modes depending on whether script is in: production or testing.
            if self.__runMode == 'TEST':
                # configSectionName determines which section from enhanced_email_config.ini to use.
                configSectionName = 'TEST_ALERTS'

                # Adds flag to emails sent when the script is run in test mode
                emailSubject = 'IGNORE: Testing - {0}'.format(emailSubject)
            else:
                configSectionName = 'CASEACTION_ALERTS'


        # Create the email object and initialize email addresses from email
        # config file.
        emailObj = EnhancedEmailClass(READ_EMAIL_TEXT_FROM_FILE=emailTextFile, \
                                      READ_FROM_CONFIG_FILE=emailConfig, EMAIL_BODY=emailBody, \
                                      CONFIG_SECTION_NAME=configSectionName, TO_ADDRESS=emailTo, \
                                      FROM_ADDRESS=emailFrom, CC_ADDRESS=emailCopy, \
                                      BCC_ADDRESS=emailBlindCopy, EMAIL_SUBJECT=emailSubject)

        # Check if there is an issue creating the email object prior to
        # sending the email.
        self.__lineNum = self.__GetLineNo() - 1
        if emailObj.errorCode:
            if not self.__loggerObj.LogMessage(\
                    self.__FormatMessage(emailObj.GetErrorDescription(), width=80, \
                                         initial_indent='\n            ', \
                                         subsequent_indent=' ' * 12, break_long_words=False, \
                                         break_on_hyphens=False), 'ERROR'):
                return False
            return False

        # Send the email
        if not emailObj.SendEmail():
            return False

        return True


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
                          is 100 characters.
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
                keywordDict.update({keywordToUpper : keywordArgs[keywordParam]})

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
                    self.__formatBuffer = (
                        'Invalid keyword passed to the __FormatMessage() '
                        'method in {0} {1}{2} module {3} at Line #: {4}.\n')
                    print(self.__formatBuffer.format(__file__, '', '', '\n', self.__lineNum))

        wrapperFormat = \
            textwrap.TextWrapper(width=lineWidth, \
                                 expand_tabs=expandTabs, \
                                 replace_whitespace=replaceWhitespace, \
                                 drop_whitespace=dropWhitespace, \
                                 initial_indent=initialIndent, \
                                 subsequent_indent=subsequentIndent, \
                                 fix_sentence_endings=fixSentenceEndings, \
                                 break_long_words=breakLongWords, \
                                 break_on_hyphens=breakOnHyphens)

        return wrapperFormat.fill(unwrappedText)


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

        print(\
              '        Usage is:n            {0} [-u or -U or --usage]n'
              '            [-d or -D or --reportDate <YYYY_MM_DD> (Optional)]n'
              '            [-v or -V or --verbose <Verbose Level>]n'
              '            [-t or -T or --test (Optional)]n'
              '            [-l or -L or --logtype <LOGFILE/CONSOLE/BOTH> '
              '(Optional)]nn            {1}n                {2}n'
              '                {3}n                {4}n                '
              '{5}n                {6}n'.format(\
                __file__, 'Verbose Levels:', '-v     - Debug', '-vv    ' \
                '- Info', '-vvv   - Warning', '-vvvv  - Error', \
                '-vvvvv - Critical'))


    #--------------------         __CreateLogger()        ---------------------
    def __CreateLogger(self, logType):

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
            if self.__verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ('Print message generated in Module: {0} Method: '
                                       '__CreateLogger() at Line #: {1}. Base file path: {2}{3}')
                print(self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, basePath, ''), \
                        width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                        break_long_words=False, break_on_hyphens=False), '\n')

            logfilePath = os.path.join(basePath, 'LOG')
            if self.__verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ('Print message generated in Module: {0} Method: '
                                       '__CreateLogger() at Line #: {1}. Log file path: {2}{3}')
                print(self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, logfilePath, ''), \
                        width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                        break_long_words=False, break_on_hyphens=False), '\n')

            getPath = lambda logfilePath, basePath: logfilePath if logfilePath else basePath

            if self.__verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = (\
                    'Print message generated in Module: {0} Method: __CreateLogger() at Line #:'
                    '{1}. From Lambda getPath Value: {2}{3}')

                print(self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                                    getPath(logfilePath, basePath), ''),
                        width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                        break_long_words=False, break_on_hyphens=False), '\n')

            # Initialize the logger object.
            self.__loggerObj = LoggerClass(\
                                MODULE_NAME=__file__, \
                                LOG_FILE_PATH=getPath(logfilePath, basePath), \
                                LOG_FILE_TYPE='TimedRotatingFileHandler')

            # An error occurred during logger object initialization
            if self.__loggerObj.errorCode:
                raise LocalException('Unable to create the logger object.')

            # Check the verbosity level and set the logging level accordingly.
            # The logging level is the number of -v options passed in the
            # program arguments. Initially the LOG_LEVEL is set to 'info' and
            # LOG_TYPE to 'logfile'. Note that the LOG_LEVEL can be changed by
            # passing the required verbosity level to the ResetLoggingLevel()
            # method in the logger class later.
            if self.__verbosityLevel == 1:             # called with -v
                loggingLevel = 'DEBUG'
            elif self.__verbosityLevel == 2:           # called with -vv
                loggingLevel = 'INFO'
            elif self.__verbosityLevel == 3:           # called with -vvv
                loggingLevel = 'WARNING'
            elif self.__verbosityLevel == 4:           # called with -vvvv
                loggingLevel = 'ERROR'
            elif self.__verbosityLevel == 5:           # called with -vvvvv
                loggingLevel = 'CRITICAL'

            if logType:
                handleType = logType

            # Set up logging parameters. This is the second step in the logging
            # process.
            if not self.__loggerObj.SetupLogFileParams():
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException('Unable to set up the log file parameters.')

            # Now set the logging attributes. This is the third step in the
            # logging process. Note that the named parameters in the
            # SetupLoggingAttributes() method is not case sensitive. LOG_TYPE
            # can be 'logfile', 'console' or 'both' ('both' means logging to a
            # log file and the console).
            if not self.__loggerObj.SetupLoggingAttributes(
                                LOG_LEVEL=loggingLevel, Log_Type=handleType):
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException('Error occurred setting logger attributes.')

            # Set up log handlers. This function must be called fourth.
            if not self.__loggerObj.SetupLogHandlers():
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException('Unable to set the log file handlers.')

            if not self.__loggerObj.LogMessage('Begin Execution: {0} {1}'.format(__file__, \
                                          datetime.now().strftime('%Y/%m/%d %H:%M:%S')), 'BEGIN'):
                if self.__loggerObj.verbosityLevel == logging.DEBUG:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException('Unable to write debug messages to the log file.')
                else:
                    self.__lineNum = self.__GetLineNo() - 1
                    raise LocalException('Unable to write messages to the log file.')

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = 'Error in {0} module _CreateLogger() method at Line #: {1}: {2}'
            print(self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, exceptError.value), \
                    width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                    break_long_words=False, \
                    break_on_hyphens=False), '\n')
            return False
        else:
            return True


    #----------------------         __ListFiles()         -----------------------

    def __ListFiles(self, directory, extension):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ListFiles():
                Searches a given directory for all files with the given file extension.
            Parameters:
                directory   - Directory in which to search.
                extension   - File extension for which to search.

            Returns:
                List of file names with given extension.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        fileList = []
        for files in os.listdir(directory):
            if files.endswith(extension):
                fileList.append(files)
        return fileList


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
                The report start and end dates passed to the script in
                dd-mon-yy format, the institution ID, verbosity level,
                logging type, and usage True/False flag.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Assign description to the help doc
            reportDescription = (
                'This script transfers the unzipped case action files to the sftp '
                'folder and sends an email alert to the relevant parties upon completion.')

            argParser = argparse.ArgumentParser(description=reportDescription)

            # Add usage argument to argparse. Make it not required and let the
            # program handle the required arguments.
            argParser.add_argument(
                '-u', '-U', '--usage', help='Show how to invoke the script.', \
                # required=False, default=False)
                required=False, default=False, action='store_true')

            # Add the verbose argument to argparse. Make it not required and
            # let the program handle the required arguments.
            argParser.add_argument(
                '-v', '-V', '--verbose', action='count', dest='verbose', \
                help="verbose level... repeat up to five times.")

            # Add the logging level to argparse. Make it not required and let
            # the program handle the required arguments.
            argParser.add_argument(
                '-l', '-L', '--logtype', type=str, \
                help='One of optional logging flags: LOGFILE, CONSOLE, ' \
                     'or BOTH.', default='LOGFILE', required=False)

            # Add the date argument to argparse. Make it not required and
            # let the program handle the required arguments.
            argParser.add_argument(
                '-d', '-D', '--date', type=str, \
                help='Report date YYYY_MM_DD format.', required=False)

            # Add the test mode (optional) argument to argparse. Make it not
            # required and let the program handle the required arguments.
            argParser.add_argument(
                '-t', '-T', '--test', type=str, default='PROD', \
                help='Run mode indicator (Optional).', required=False)

            # Extract all arguments passed to script into a list
            argsList = argParser.parse_args()

            # Assign args to variables
            verbosityLevel = argsList.verbose
            showUsage = argsList.usage
            logType = argsList.logtype
            runMode = argsList.test

            # If no date was input, get date from the system in YYYY_MM_DD format. The date
            # is put in format YYYY_MM_DD to make searching for the right TSYS reports easier.
            if argsList.date is not None:
                reportDate = argsList.date
            else:
                reportDate = datetime.today().strftime("%Y_%m_%d")

            # Default program run mode
            if runMode != 'PROD':
                runMode = runMode.upper()
            if runMode == 'P':
                runMode = 'PROD'
            elif runMode != 'PROD':     # default set to 'PROD' in argparse
                runMode = 'TEST'

            if verbosityLevel == 1:     # Verbosity level: Debug
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = (
                    'Print message generated in Module: {0} Method: __GetArgs() at Line #: {1}.'
                    'showUsage = {2} verbosityLevel = {3}  reportDate = {4} Run Mode = {5}')

                print(self.__FormatMessage(
                    self.__formatBuffer.format(__file__, self.__lineNum, showUsage, \
                                               str(verbosityLevel), str(reportDate), str(runMode)),
                    width=80, initial_indent='\n        ',
                    subsequent_indent=' ' * 8, break_long_words=False,
                    break_on_hyphens=False), '\n')

        except argparse.ArgumentError as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = \
                    'Exception error in Module: {0} __GetArgs() method at Line #: {1}: {2}'

            print(self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, str(exceptError)), \
                    width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                    break_long_words=False, break_on_hyphens=False), '\n')
            sys.exit()
        else:
            # Return all variable values
            return showUsage, verbosityLevel, logType, reportDate, runMode


    #----------------------         __LoadFile()         -----------------------
    def __LoadFile(self, remoteHost, remoteUser, sourceFile, \
                   localDirectory=None, remoteDirectory=None, isDownload=False):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __LoadFile():
                Uploads or downloads a file to or from a remote server via scp.

            Parameters:
                remoteHost      - Remote host name
                remoteUser      - Remote user ID
                sourceFile      - Source file to remote copy
                localDirectory  - Local directory where the source file resides
                remoteDirectory - Directory at the remote location
                isDownload      - Boolean value that signifies if file is being
                                  uploaded or downloaded in relation to the local
                                  server. A download is copying file to the local
                                  server. An upload is copying a file from the
                                  local server to a remote server. Flag adjusts
                                  scp syntax. Default is False.

            Returns:
                True if upload was successful, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # Format the remote location as 'username@hostname:'location'
        remoteFileWithPath = '{0}@{1}:{2}/{3}'.format(
            remoteUser, remoteHost, remoteDirectory, sourceFile)

        # Attach the file path to the source file.
        if localDirectory:
            localFileWithPath = os.path.join(localDirectory, sourceFile)

        if self.__verbosityLevel == 1:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ('Print message generated in Module: {0} Method: __LoadFile() '
                                   'at Line #: {1}. localDirectory: {2} remoteDirectory: {3} '
                                   'localFileWithPath: {4} remoteFileWithPath: {5}{6}')

            print(self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, localDirectory, \
                                               remoteDirectory, localFileWithPath, \
                                               remoteFileWithPath, ''), \
                    width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                    break_long_words=False, break_on_hyphens=False), '\n')
            # Log to the log file
            self.__lineNum = self.__GetLineNo() - 1
            if not self.__loggerObj.LogMessage(\
                self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, localDirectory, \
                                               remoteDirectory, localFileWithPath, \
                                               remoteFileWithPath, '\n'), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

        # The script downloads the files from clearng2 (a remote host) to sybil2 (the local host),
        # then it uploads the script from sybil2 to sftp.jetpay.com (a remote host). The syntax for
        # scp is: scp [SOURCE] [DESTINATION].

        if isDownload: # Downloading from remote host to local host
            scpCommand = 'scp {0} {1}'.format(remoteFileWithPath, localFileWithPath)
        else: # Uploading to from local host to remote host
            scpCommand = 'scp {0} {1}'.format(localFileWithPath, remoteFileWithPath)

        # Create the scp command to copy the files
        procRetValue = subprocess.Popen(scpCommand, shell=True, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT).wait()

        #if command didn't execute properly return false
        if procRetValue:
            return False

        return True


    #----------------------         __Transfer()         -----------------------
    def __Transfer(self, remoteHost, remoteUser, sourceFile, localDirectory, \
                   remoteDirectory, reportDate, isDownload=False):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __Transfer():
                Function associated with exception handling and alerts for the transfer of
                files between two servers.

            Parameters:
                remoteHost      - Remote host name
                remoteUser      - Remote user ID
                sourceFile      - Source file to remote copy
                localDirectory  - Local directory where the source file resides
                remoteDirectory - Directory at the remote location
                reportDate      - Date of case action reports

            Returns:
                True if upload was successful, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        if not self.__LoadFile(remoteHost, remoteUser, sourceFile, localDirectory, \
                               remoteDirectory, isDownload):
            self.__lineNum = self.__GetLineNo() - 3
            errorMessage = 'Unable to upload file {0} to Remote Server: {1} '.format(\
                sourceFile, remoteHost)

            self.__formatBuffer = None
            self.__formatBuffer = ('Error in {0} module __Transfer() method at Line #: {1}: {2}')
            print(self.__FormatMessage(
                self.__formatBuffer.format(__file__, self.__lineNum, errorMessage),
                width=80, initial_indent='\n        ',
                subsequent_indent=' ' * 8,
                break_long_words=False,
                break_on_hyphens=False), '\n')

            # Configure emails as necessary
            if remoteHost == 'stfp.jetpay.com':
                emailSubject = 'Failed to upload the unzipped case action files {0} for {1}'\
                    .format(sourceFile, reportDate)

                emailBody = 'Unable to upload the {0} file to the {1} remote server'\
                    .format(sourceFile, remoteHost)
            else:
                emailSubject = 'Failed to download the zipped case action file {0} for {1}'\
                    .format(sourceFile, reportDate)

                emailBody = 'Unable to download the {0} file to the {1} remote server'\
                    .format(sourceFile, remoteHost)

            if not self.__GenerateEmail(\
                        READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                        EMAIL_SUBJECT=emailSubject, \
                        EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')
                return False

            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage(
                    self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                        width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                        break_long_words=False, break_on_hyphens=False), 'ERROR'):
                return False
        return True


    #----------------------     __SendFilesErrorHandling()         --------------------
    def __SendFilesErrorHandling(self, error, reportDate):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __SendFilesErrorHandling():
                Handles exceptions that may occur when initializing the components
                of the script needed to send the files between servers.

            Parameters:
                error      - Type of error raised within try/catch in SendFiles()
                reportDate - date of case action report

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        self.__formatBuffer = None
        self.__formatBuffer = ('Error in Module: {0} __SendFilesErrorHandling() method at '
                               'Line #{1}: {2} {3}')

        print(self.__FormatMessage(\
                self.__formatBuffer.format(__file__, self.__lineNum, str(error), ''), \
                width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                break_long_words=False, break_on_hyphens=False), '\n')

        # Print usage parameters
        self.__PrintUsage()

        # Log error to log file
        if not self.__loggerObj.LogMessage(\
                self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, str(error), '\n'), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
            sys.exit()

        # Send email alert
        emailSubject = ('An exception occurred sending the daily case action files for {0}'\
                .format(reportDate))

        emailBody = self.__formatBuffer.format(__file__, self.__lineNum, '', str(error), '')

        # If -v debug flag or test mode are called, print the email config file path
        if self.__verbosityLevel == 1 or self.__runMode == 'TEST':
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = \
                'Print message generated in Module: {0} Method: __SendFilesErrorHandling() at ' \
                'Line #: {1}. Email config file path: {2}.{3}'
            print(self.__FormatMessage(\
                self.__formatBuffer.format(__file__, self.__lineNum, self.__emailConfigFile, ''), \
                width=80, initial_indent='\n        ', subsequent_indent=' ' * 8,
                break_long_words=False, break_on_hyphens=False), '\n')

        if not self.__GenerateEmail(READ_FROM_CONFIG_FILE=self.__emailConfigFile,
                                    EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
            sys.exit()


    #----------------------         __CheckForFile()         ----------------------
    def __CheckForFile(self, remoteDirectory, remoteHost, remoteUser, reportDate):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CheckForFile():
                Searches the remote download directory to determine if there exists a case action
                file to download. If there is no such file, sends alert to the appropriate parties
                to expect no case action file upload that day.

            Parameters:
                remoteDirectory - Directory at the remote location
                remoteHost      - Remote host name
                remoteUser      - Remote user ID
                reportDate      - Date of case action report

            Returns:
                If case action file is found, full name of zipped file is returned.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # Ssh to clearing2 and check if there is a case action file to transfer
        # All zipped case action files fit the format JETPAY_A_{reportDate}_{TSYS_id}.tar.gz, where
        # TSYS id is unknown. Output returned form search is trimmed so that the full name of the
        # case action file is known.
        searchString = 'JETPAY_A_{0}_*'.format(reportDate)
        checkCommand = 'ssh {0}@{1} "clear; cd {2}; ls {3}"'\
            .format(remoteUser, remoteHost, remoteDirectory, searchString)

        process = subprocess.Popen(checkCommand, shell=True, stdout=subprocess.PIPE, \
                                   stderr=subprocess.PIPE)

        #remove any potential extraneous characters
        searchResults = str(process.stdout.read())

        idxStart = searchResults.find('JETPAY_A_')
        idxEnd = searchResults.find('.gz') + 3
        searchResults = searchResults[idxStart:idxEnd]

        # If string is empty, then there was so zipped case action file to download for clearing
        # Send email to relevant parties that there is no file for the day.
        if not searchResults:
            self.__lineNum = self.__GetLineNo() - 1
            errorMessage = 'There is no daily case action report to download for {0}'\
                .format(reportDate)

            self.__formatBuffer = None
            self.__formatBuffer = 'Error in {0} module _SendFiles() method at Line #: {1}: {2}'
            print(self.__FormatMessage(\
                self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                break_long_words=False, break_on_hyphens=False), '\n')

            emailSubject = 'No case action reports for {0}'\
                .format(reportDate.replace('_', '/'))
            emailBody = 'There are no case action report files to be placed on the SFTP site '\
                        'for {0}/'.format(reportDate.replace('_', '/'))

            if not self.__GenerateEmail(READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                        EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')

            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage(\
                    self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                        width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                        break_long_words=False, break_on_hyphens=False), 'ERROR'):
                sys.exit()

        return searchResults

    def __UnzipFiles(self, remoteDirectory, unzipDirectory, zipFile):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __UnzipFiles():
                Unzips downloaded case action file and unzips its contents into a temporary
                directory

            Parameters:
                remoteDirectory - Directory at the remote location
                unzipDirectory  - Directory files will be unzipped to
                zipFile         - name of compressed file

            Returns:
                True if successful.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # The command 'mkdir -p unzipped_tsys' is run first to create a subdirectory unzipped_tsys
        # in /tmp where the unzipped files will go for collection. The -p flag prevents an error
        # if the directory already exists and the directory's contents will remain unchanged.
        unzipCommand = 'mkdir -p {0} && tar -xvzf {1} -C {0}'.format(unzipDirectory, zipFile)

        process = subprocess.Popen(unzipCommand, shell=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT).wait()

        # Variable process returns a value of 0 if command was completed successfully
        if process != 0:
            self.__lineNum = self.__GetLineNo() - 1
            errorMessage = 'Unable to unzip file {0} in {1} '.format(zipFile, remoteDirectory)

            self.__formatBuffer = None
            self.__formatBuffer = 'Error in {0} module _SendFiles() method at Line #: {1}: {2}'
            print(self.__FormatMessage(\
                self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                break_long_words=False, break_on_hyphens=False), '\n')

            # Send email warning of the failure
            emailSubject = 'Failed to upzip case action report {0} in {1}'\
                .format(zipFile, unzipDirectory)
            emailBody = \
                'Unable to unzip the file {0} to the directory {1} '.format(zipFile, \
                                                                            unzipDirectory)

            if not self.__GenerateEmail(READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                        EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')
                return False

            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage(\
                    self.__FormatMessage(\
                        self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, break_long_words=False, \
                        break_on_hyphens=False), 'ERROR'):
                return False
        return True

    #----------------------         __ChangePermissions()         ----------------------
    def __ChangePermissions(self, remoteDirectory, remoteHost, remoteUser, fileList):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ChangePermissions():
                Uses SSH to change permissions of uploaded case action files on SFTP server.

            Parameters:
                remoteDirectory - Directory at the remote location
                remoteHost      - Remote host name
                remoteUser      - Remote user ID
                fileList        - List of unzipped case action files

            Returns:
                Returns True if all commands ran successfully.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        for txtFile in fileList:
            chmodCommand = 'ssh {0}@{1} "chmod 644 {2}/{3}"'\
                .format(remoteUser, remoteHost, remoteDirectory, txtFile)

            process = subprocess.Popen(chmodCommand, shell=True, stdout=subprocess.PIPE, \
                                        stderr=subprocess.STDOUT).wait()

            #Process has value of 0 if command is successful
            if process != 0:
                self.__lineNum = self.__GetLineNo() - 1
                errorMessage = 'Unable to change permissions for case action files on SFTP server.'

                self.__formatBuffer = None
                self.__formatBuffer = 'Error in {0} module _SendFiles() method at Line #: {1}: {2}'
                print(self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                    width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                    break_long_words=False, break_on_hyphens=False), '\n')

                # Send email notifying of failure to change permissions
                emailSubject = 'Failed to change file permissions on SFTP server'

                emailBody = '{0}@{1} failed to change file permissions for case action files in '\
                            'the directory {2}'.format(remoteUser, remoteHost, remoteDirectory)

                if not self.__GenerateEmail(READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                            EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
                    print('            Unable to generate Email Alert.\n')
                    return False

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage(\
                        self.__FormatMessage(\
                            self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, break_long_words=False, \
                            break_on_hyphens=False), 'ERROR'):
                    return False

        return True
    #----------------------         __SendFiles()         ----------------------
    def __DeleteFiles(self, fileList, unzipDirectory, reportDate):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __DelteFiles():
                Delete unzipped files from sybil server.

            Parameters:
                fileList        - List of unzipped case action files
                unzipDirectory  - Directory at the remote location
                reportDate      - Date report is run

            Returns:
                Returns True if all commands ran successfully.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        for txtFile in fileList:
            deleteCommand = 'rm {0}/{1}'.format(unzipDirectory, txtFile)

            process = subprocess.Popen(deleteCommand, shell=True, stdout=subprocess.PIPE, \
                                    stderr=subprocess.STDOUT).wait()

            # Variable process returns a value of 0 if command was completed successfully
            if process != 0:
                self.__lineNum = self.__GetLineNo() - 1
                errorMessage = \
                    'Unable to delete file {0} in {1}'.format(txtFile, unzipDirectory)

                self.__formatBuffer = None
                self.__formatBuffer = \
                    'Error in {0} module _SendFiles() method at Line #: {1}: {2}'
                print(self.__FormatMessage(\
                    self.__formatBuffer.format(__file__, self.__lineNum, errorMessage), \
                    width=80, initial_indent='\n        ', subsequent_indent=' ' * 8, \
                    break_long_words=False, break_on_hyphens=False), '\n')

                # Send email notifying of failure to delete
                emailSubject = \
                    'Failed to delete .txt file {0} of the case action report for {1} in {2}'\
                    .format(txtFile, reportDate.replace('_', '/'), unzipDirectory)
                emailBody = \
                    'Unable to delete the .txt files in the directory {0}'\
                    .format(unzipDirectory)

                if not self.__GenerateEmail(READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                            EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
                    print('            Unable to generate Email Alert.\n')
                    return False

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage(\
                        self.__FormatMessage(\
                            self.__formatBuffer.format(__file__, self.__lineNum, \
                                                        errorMessage), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, break_long_words=False, \
                            break_on_hyphens=False), 'ERROR'):
                    return False
        return True
    #----------------------         __SendFiles()         ----------------------
    def SendFiles(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __SendFiles():
                This functions initializes the nececcary parameters needed to
                transfer and unzip the files between servers, performs the transfer,
                and sends an email upon successful completion.

            Parameters:
                None.
            Returns:
                Returns True if successful, else False.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        try:
            # Get the arguments that were passed to the program.
            showUsage, verbosityLevel, logType, reportDate, runMode = self.__GetArgs()

            #set verbosityLevel and runMode for current object instance
            self.__verbosityLevel = verbosityLevel
            self.__runMode = runMode

            # Call funcion to create the logging object and initialize necessary parameters
            if not self.__CreateLogger(logType):
                return False

            # Set email configurations based on email config file
            self.__emailConfigFile = '{0}/enhanced_email_config.ini'\
                .format(os.environ.get('MASCLRLIB_PATH'))

        except LocalException as exceptError:
            self.__SendFilesErrorHandling(exceptError, reportDate)
        else:
            # Check if there is a case action file to be downloaded from remote server clearing2
            remoteHost = '{0}.jetpay.com'.format(os.environ.get('CLEARING_HOST_NAME'))
            remoteUser = os.environ.get('USER')
            remoteDirectory = '{0}/MERLIN/ARCHIVE'.format(os.environ.get('HOME'))

            sourceFile = self.__CheckForFile(remoteDirectory, remoteHost, remoteUser, reportDate)

            # Download zipped case action file from clearing
            localDirectory = '/tmp'
            isDownload = True

            self.__Transfer(remoteHost, remoteUser, sourceFile, localDirectory,
                            remoteDirectory, reportDate, isDownload)

            # Unzip .tar.gz file to a temporary directory.
            zipFile = '{0}/{1}'.format(localDirectory, sourceFile)
            unzipDirectory = '{0}/unzipped_tsys'.format(localDirectory)

            self.__UnzipFiles(remoteDirectory, unzipDirectory, zipFile)

            # Get list of all txt files that were unzipped in the directory.
            fileList = self.__ListFiles(unzipDirectory, '.txt')

            # Initialize necessary variables to send unzipped files to SFTP server.
            remoteHost = os.environ.get('SFTP_HOST')
            remoteUser = os.environ.get('USER')
            localDirectory = unzipDirectory #this is /tmp/unzipped_t
            remoteDirectory = '/secure/jetcorp/tx'

            # Iteratively upload each .txt file to sftp server. isDownload set to false by default
            for txtFile in fileList:
                self.__Transfer(remoteHost, remoteUser, txtFile, localDirectory,
                                remoteDirectory, reportDate)

            # Change file permissions on unzipped files so they can be accessed by the right users.
            self.__ChangePermissions(remoteDirectory, remoteHost, remoteUser, fileList)

            #Delete the unzipped files from the sybil server
            self.__DeleteFiles(fileList, unzipDirectory, reportDate)

            #Log list of transferred files to the log file
            self.__formatBuffer = None
            self.__formatBuffer = 'Files uploaded to SFTP server on {0}: {1}'
            self.__lineNum = self.__GetLineNo() - 1
            if not self.__loggerObj.LogMessage(\
                self.__FormatMessage(\
                    self.__formatBuffer.format(reportDate.replace('_', '/'), \
                                                '\n\t\t'.join(map(str, fileList))), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Send email alerting successful upload
            emailSubject = 'Case Action Report for {0}'.format(reportDate.replace('_', '/'))
            emailBody = 'Successfully unzipped the file {0} and uploaded its contents '\
                        'to the directory {1} on the server {2}.'\
                        .format(sourceFile, remoteDirectory, remoteHost)

            if not self.__GenerateEmail(\
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile,
                            EMAIL_SUBJECT=emailSubject, EMAIL_BODY=emailBody):
                print('            Unable to generate the case action report e-mail.\n')
                return False

            # LM Added for Logging end message
            if not self.__loggerObj.LogMessage('End Execution: {0} {1}'\
                .format(__file__, datetime.now().strftime('%Y/%m/%d %H:%M:%S')), 'END'):
                if self.__loggerObj.verbosityLevel == logging.DEBUG:
                    print('            Unable to write debug messages to the log file.\n')
                else:
                    print('            Unable to write messages to the log file.\n')
            return True


# Main method
if __name__ == '__main__':
    print('\nBeginning TSYS Case Action file transfer: {0}\n'.format(datetime.now()))

    caseaction_obj = UploadCaseActionFiles()
    caseaction_obj.SendFiles()

    print('\nEnd TSYS Case Action file transfer: {0}\n'.format(datetime.now()))
