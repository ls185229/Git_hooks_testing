#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A general purpose Python class for writing log messages to a log file.
    $Id: logger_class.py 4550 2018-04-30 16:48:19Z lmendis $
"""

import os
import logging
import logging.handlers
import inspect
import textwrap

# pylint: disable = invalid-name

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
            February 12, 2018

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


class LoggerClass(object):

    """
        Description:
            A general purpose class designed to add logging to a log file or
            the console from a calling program. This class was adapted from
            Python's built-in logging framework. Though the Python logging
            facility allows you to log messages to many different destinations
            such as Files, HTTP GET/POST locations, Emails (via SMTP), generic
            Sockets or OS specific logging mechanisms, this class was designed
            to log basic application level logging to either a file or the
            console. It also uses only two forms of file types - one of
            RotatingFileHandler or TimedRotatingFileHandler that needs to be
            specified at the time an instance of a class object is instantiated.
            These two file types ensures the log files are archived and rotated
            at specified intervals without you having to manually delete them
            once a certain size threshold is reached.

            The class is designed to set/re-set different verbosity levels so
            that different types of log messages can be logged within a single
            application.

            Creating the class object and using it for logging involves the
            following five steps:
                1. Creating a logger class object.
                2. Setting up log file parameters.
                3. Setting up logging attributes.
                4. Setting up logging handles.
                5. Setting up formatters and logging levels. Logging levels
                   can be changed within the program. Formatters are internal
                   to the class but controlled via the message types that are
                   logged.

        Author:
            Leonard Mendis

        Date Created:
            February 12, 2018

        Modified By:

        References:
            Verbosity logging examples:
                https://gist.github.com/aptxna/3635f73e79e14e67ec6dd080c263de8b
                https://gist.github.com/olooney/8155400
                https://docs.python.org/2.6/library/logging.html
                https://docs.python.org/2/library/logging.handlers.html
                https://gist.github.com/n8henrie/33eebb2b43753e247854
                https://pymotw.com/3/logging/
            Good articles about the pitfalls of module level logging:
                http://www.patricksoftwareblog.com/python-logging-tutorial/
                https://fangpenlin.com/posts/2012/08/26/good-logging-practice-in-python/
                http://pythonsweetness.tumblr.com/post/67394619015/use-of-logging-package-from-within-a-library
            Configuring/Customizing formatters:
                https://docs.python.org/3/library/logging.html
                https://opensource.com/article/17/9/python-logging
                https://helpful.knobs-dials.com/index.php/Python_notes_-_logging
    """

    # Default private log file attributes for logging to a file
    __logFileName = None
    __logFilePath = None
    __logFileMode = 'a'         # Append to the existing file
    __logFileMaxBytes = 0
    __logFileBackupCount = 5    # Default to 5 backup files
    __logFileEncoding = None
    __logFileDelay = False
    __logFileInterval = 1
    __logFileWhen = 'W0'        # Default to first day of the week (Monday)
    __logFileUtc = False
    __logFileAtTime = None

    # Private class attributes
    __invokingModuleName = None     # Module name invoking the class object
    __logfileType = None            # File type - Rotating or TimedRotating
    __logfileHandleType = None      # Log file handle type - LOGFILE/CONSOLE/BOTH
    __errorMessage = None           # Attribute to hold error messages
    __isAttributeSet = False        # Is the log attribute set up?
    __isFileParamsSet = False       # Is the log file parameters set up?
    __isFileHandlersSet = False     # Is the log file handlers set up?
    __fileLoggerObj = None          # Attribute to hold the log file logger object
    __consoleLoggerObj = None       # Attribute to hold the console logger object
    __moduleName = 'logger_class.py'   # Logger class module name
    __formatBuffer = None           # A buffer to format message strings

    # Error message displayed when the class members are called out of
    # order. For example the SetupLogHandlers() method cannot be called
    # prior to invoking the SetupLogFileParams() method for setting up
    # log file parameters or SetupLoggingAttributes() method for setting
    # logging attributes. The class object must be invoked as indicated below.
    __outOfOrderError = ('Class methods invoked out of order. Please invoke ' \
                            'them in the following order:\n' \
                            '        1. SetupLogFileParams()\n' \
                            '        2. SetupLoggingAttributes()\n' \
                            '        3. SetupLogHandlers()\n')

    # Public class attributes
    errorCode = 0           # Error code for debugging purposes
    verbosityLevel = 0      # Level of depth for logging
    logfileHandler = None   # Log file handler
    consoleHandler = None   # Console log handler
    lineNum = 0             # Source code line number where the error occurred

    # Verbosity level definitions
    DEBUG_LEVEL = 10        # Verbosity level for Debug message logging
    INFO_LEVEL = 20         # Verbosity level for Informational message logging
    WARNING_LEVEL = 30      # Verbosity level for Warning message logging
    ERROR_LEVEL = 40        # Verbosity level for Error message logging
    CRITICAL_LEVEL = 50     # Verbosity level for Critical message logging


    # -----------------------         GetLineNo()        ----------------------

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


    # -----------------------      PrintArguments()     -----------------------

    def PrintArguments(self, **keywordArgs):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            PrintArguments():
                A generic function for printing all of the class attributes
                from the calling program for debugging purposes.

            Parameters:
                displayLevel - Optional keyword parameter to control what
                               type of argument values to print. Following
                               are valid keywords and their values.

                                  Keyword: DISPLAY_LEVEL
                                     APP_LEVEL_ARGS   - App level attributes
                                     FILE_LEVEL_ARGS  - Log file attributes
                                     ERROR_LEVEL_ARGS - Error attributes

                                  Keyword: CALLING_METHODn
                                     Calling method.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        displayLevel = None
        displayMethod = None

        if keywordArgs:
            keywordDict = {}
            for keywordParam in keywordArgs:
                keywordToUpper = keywordParam.upper()

                if keywordToUpper == 'DISPLAY_LEVEL':
                    # Convert the argument value to uppercase.
                    keywordDict.update({keywordToUpper : \
                                        keywordArgs[keywordParam].upper()})
                    displayLevel = keywordDict[keywordToUpper]
                elif keywordToUpper == 'CALLING_METHOD':
                    # Dont change the case of the argument value.
                    keywordDict.update({keywordToUpper : \
                                        keywordArgs[keywordParam]})
                    displayMethod = keywordDict[keywordToUpper]
        else:   # Nothing to display
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = ( \
                'PrintArguments() method called from the {0} module at ' \
                'Line #: {1}. You must provide the display level in order ' \
                'to check the argument values.{2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, \
                                            self.lineNum, ''), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, \
                break_long_words=False, \
                break_on_hyphens=False), '\n')

            return

        # Check to see what level of messages to display.
        if not displayLevel:
            self.lineNum = self.GetLineNo() - 1

            self.__formatBuffer = ( \
                'PrintArguments() method called from the {0} module at ' \
                'Line #: {1}. You must provide the display level in order ' \
                'to check the argument values.{2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, \
                                            self.lineNum, ''), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, \
                break_long_words=False, \
                break_on_hyphens=False), '\n')

            return

        # Print the calling method.
        if displayMethod:
            print('\nCalled from Method -', displayMethod, '\n')

        if displayLevel == 'APP_LEVEL_ARGS':
            # Various parameters to determine their settings when an error
            # occurs.
            print('     __invokingModuleName: ', self.__invokingModuleName)
            print('     __logFileName: ', self.__logFileName)
            print('     __logFilePath: ', self.__logFilePath)
            print('     __logfileType: ', self.__logfileType)
            print('     __logfileHandleType: ', self.__logfileHandleType)
            print('     verbosityLevel: ', self.verbosityLevel)
            print('     logfileHandler: ', self.logfileHandler)
            print('     consoleHandler: ', self.consoleHandler)
            print('     __fileLoggerObj: ', self.__fileLoggerObj)
            print('     __consoleLoggerObj: ', self.__consoleLoggerObj)
            print('     __isAttributeSet: ', self.__isAttributeSet)
            print('     __isFileParamsSet: ', self.__isFileParamsSet)
            print('     __isFileHandlersSet: ', self.__isFileHandlersSet)
        elif displayLevel == 'FILE_LEVEL_ARGS':
            # Log file parameter settings.
            print('     __logFileMode: ', self.__logFileMode)
            print('     __logFileMaxBytes: ', self.__logFileMaxBytes)
            print('     __logFileBackupCount: ', self.__logFileBackupCount)
            print('     __logFileEncoding: ', self.__logFileEncoding)
            print('     __logFileDelay: ', self.__logFileDelay)
            print('     __logFileInterval: ', self.__logFileInterval)
            print('     __logFileWhen: ', self.__logFileWhen)
            print('     __logFileUtc: ', self.__logFileUtc)
            print('     __logFileAtTime: ', self.__logFileAtTime, '\n')
        elif displayLevel == 'ERROR_LEVEL_ARGS':
            # Error codes and messages.
            print('     errorCode: ', self.errorCode)
            print('     __errorMessage: ', self.__errorMessage, '\n')
            print('     lineNum: ', self.lineNum)
        else:
            # Print all the arguments
            # Various parameters to determine their settings when an error
            # occurs.
            print('     __invokingModuleName: ', self.__invokingModuleName)
            print('     __logFileName: ', self.__logFileName)
            print('     __logFilePath: ', self.__logFilePath)
            print('     __logfileType: ', self.__logfileType)
            print('     __logfileHandleType: ', self.__logfileHandleType)
            print('     verbosityLevel: ', self.verbosityLevel)
            print('     logfileHandler: ', self.logfileHandler)
            print('     consoleHandler: ', self.consoleHandler)
            print('     __fileLoggerObj: ', self.__fileLoggerObj)
            print('     __consoleLoggerObj: ', self.__consoleLoggerObj)
            print('     __isAttributeSet: ', self.__isAttributeSet)
            print('     __isFileParamsSet: ', self.__isFileParamsSet)
            print('     __isFileHandlersSet: ', self.__isFileHandlersSet)
            print('     __moduleName: ', self.__moduleName)
            print('     __formatBuffer: ', self.__formatBuffer)

            # Log file parameter settings.
            print('     __logFileMode: ', self.__logFileMode)
            print('     __logFileMaxBytes: ', self.__logFileMaxBytes)
            print('     __logFileBackupCount: ', self.__logFileBackupCount)
            print('     __logFileEncoding: ', self.__logFileEncoding)
            print('     __logFileDelay: ', self.__logFileDelay)
            print('     __logFileInterval: ', self.__logFileInterval)
            print('     __logFileWhen: ', self.__logFileWhen)
            print('     __logFileUtc: ', self.__logFileUtc)
            print('     __logFileAtTime: ', self.__logFileAtTime, '\n')

            # Error codes and messages.
            print('     errorCode: ', self.errorCode)
            print('     __errorMessage: ', self.__errorMessage, '\n')


    # -----------------------    __SetupFormatters()    -----------------------

    def __SetupFormatters(self, messageType=None):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __SetupFormatters():
                Creates the appropriate formatting string based on the message
                type and initializes the log handler with the correct log
                formatter.

            Parameters:
                messageType - The type of message passed - BEGIN, END, BODY,
                              INFO, DEBUG, WARNING, ERROR, CRITICAL

            Returns:
                True if the formatter string was set. False if the wrong
                handle name was passed..
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        if messageType:
            messageType = messageType.upper()

        # Check the type of message and construct the formatter string
        if messageType == 'BEGIN':
            logFormatString = ( \
                '\n[%(asctime)s] [%(levelname)s]\n    [BEGIN]: %(message)s')
            consFormatString = ( \
                '\n[%(asctime)s] [%(levelname)s]\n    [BEGIN]: %(message)s')
        elif messageType == 'END':
            logFormatString = ('    [END]: %(message)s\n')
            consFormatString = ('%(message)s')
        elif messageType == 'BODY' or messageType == 'ERROR' or \
                messageType == 'WARNING' or messageType == 'ALERT' or \
                messageType == 'CRITICAL':
            logFormatString = ( \
                    '        [LOGGER MODULE: %(module)s.py] [LINE# ' \
                    '%(lineno)s] [FUNCTION: %(funcName)s()]\n' \
                    '        [INVOKING MODULE: %(name)s] [LINE# ' \
                    '%(LINE_NUMBER)s] [FUNCTION: %(FUNCTION_NAME)s()]' \
                    '\n        [MESSAGE][%(levelname)s]: %(message)s\n')
            consFormatString = ( \
                    '        [LOGGER MODULE: %(module)s.py] [LINE# ' \
                    '%(lineno)s] [FUNCTION: %(funcName)s()]\n' \
                    '        [INVOKING MODULE: %(name)s] [LINE# ' \
                    '%(LINE_NUMBER)s] [FUNCTION: %(FUNCTION_NAME)s()]' \
                    '\n        [MESSAGE][%(levelname)s]: %(message)s\n')
        else:   # No type provided
            logFormatString = ( \
                    '        [LOGGER MODULE: %(module)s.py] [LINE# ' \
                    '%(lineno)s] [FUNCTION: %(funcName)s()]\n' \
                    '        [INVOKING MODULE: %(name)s] [LINE# ' \
                    '%(LINE_NUMBER)s] [FUNCTION: %(FUNCTION_NAME)s()]' \
                    '\n        [MESSAGE][%(levelname)s]: %(message)s\n')
            consFormatString = ( \
                    '        [LOGGER MODULE: %(module)s.py] [LINE# ' \
                    '%(lineno)s] [FUNCTION: %(funcName)s()]\n' \
                    '        [INVOKING MODULE: %(name)s] [LINE# ' \
                    '%(LINE_NUMBER)s] [FUNCTION: %(FUNCTION_NAME)s()]' \
                    '\n        [MESSAGE][%(levelname)s]: %(message)s\n')

        # Add the formatter to the log file or console handler
        if self.__logfileHandleType == 'LOGFILE':
            self.logfileHandler.setFormatter( \
                                    logging.Formatter(logFormatString))
        elif self.__logfileHandleType == 'CONSOLE':
            self.consoleHandler.setFormatter( \
                                    logging.Formatter(logFormatString))
        elif self.__logfileHandleType == 'BOTH':
            # Set up log file formatters for both file and console
            self.logfileHandler.setFormatter( \
                                    logging.Formatter(logFormatString))
            self.consoleHandler.setFormatter( \
                                    logging.Formatter(logFormatString))
        else:
            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                         CALLING_METHOD='__SetupFormatters():')
            return False

        return True


    # -----------------------        LogMessage()       -----------------------

    def LogMessage(self, messageText, messageType=None):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            LogMessage():
                Checks the verbosity level and logs the message to the log
                file or to the console.

            Parameters:
                messageText - The message to be logged to the log file or
                              console.
                messageType - Optional message type - BEGIN/BODY/END/ERROR/
                              WARNING/ALERT. The line feeds and tabs vary for
                              each of the above types. The make logging more
                              readable when there are a large number of
                              messages in the file.

            Returns:
                True if the message was logged, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            self.__SetupFormatters(messageType)

            # Get the call stack values
            (frameName, invokingFileName, invokingLineNumber, \
                invokingFunction, lineValues, indexValue) = inspect.stack()[1]

            if self.verbosityLevel == self.DEBUG_LEVEL:
                print('        inspect.stack()[1] returned the following ' \
                        'values:\n            frameName - {0}\n            ' \
                        'invokingFileName - {1}\n            ' \
                        'invokingLineNumber - {2}\n            ' \
                        'invokingFunction - {3}\n            ' \
                        'lineValues - {4}\n            ' \
                        'indexValue - {5}\n'.format( \
                        str(frameName), str(invokingFileName), \
                        str(invokingLineNumber), str(invokingFunction), \
                        str(lineValues), str(indexValue)))

            # Create a dictionary and populate the values that the custom
            # log formatter requires for logging messages.
            formatDict = {'LINE_NUMBER': invokingLineNumber, \
                            'FUNCTION_NAME': invokingFunction}

            # Log only if the file handlers and formatters are set up
            if self.__isFileHandlersSet is True:
                if self.verbosityLevel == self.DEBUG_LEVEL:      # DEBUG
                    self.__fileLoggerObj.debug(messageText, extra=formatDict)
                elif self.verbosityLevel == self.INFO_LEVEL:     # INFO
                    self.__fileLoggerObj.info(messageText, extra=formatDict)
                elif self.verbosityLevel == self.WARNING_LEVEL:  # WARNING
                    self.__fileLoggerObj.warning(messageText, extra=formatDict)
                elif self.verbosityLevel == self.ERROR_LEVEL:    # ERROR
                    self.__fileLoggerObj.error(messageText, extra=formatDict)
                elif self.verbosityLevel == self.CRITICAL_LEVEL: # CRITICAL
                    self.__fileLoggerObj.critical(messageText, extra=formatDict)
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = ( \
                            'Cannot log messages. Please ensure the file ' \
                            'handlers are initialized before writing ' \
                            'the log messages to the log file.')
                self.errorCode = 1
                raise LocalException(self.__errorMessage)

        except LocalException as error:
            self.__formatBuffer = ( \
                'Error occurred in {0} module LogMessage() method ' \
                'at Line #: {1}. {2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                            error.value), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                         CALLING_METHOD='LogMessage():')
            return False
        else:
            return True


    # ----------------------     ResetLoggingLevel()     ----------------------

    def ResetLoggingLevel(self, levelName):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ResetLoggingLevel():
                Resets the logging level originally setup in the
                SetupLoggingAttributes() function. This feature gives the
                flexibility to change the logging level to something else
                after the initial setup.

            Parameters:
                logLevel - Depth of logging. The only acceptable values are
                           any of 'DEBUG', 'INFO', 'WARNING', 'ERROR', or
                           'CRITICAL'. The case does not matter.

            Returns:
                True if log level was setup successfully, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Make sure the file parameters and attributes are setup prior
            # to calling this method.
            if not self.__isFileParamsSet or not self.__isAttributeSet:
                self.lineNum = self.GetLineNo() - 1
                self.errorCode = 2
                self.__errorMessage = ( \
                        'Cannot re-set the logging level. Initial logging ' \
                        'level has not been established.')
                raise LocalException(self.__errorMessage)

            # Dictionary of valid log levels for the python logger class
            LogLevel = ( \
                    {'DEBUG': logging.DEBUG, 'INFO': logging.INFO, \
                    'WARNING': logging.WARNING, 'ERROR': logging.ERROR, \
                    'CRITICAL': logging.CRITICAL, 'NOTSET': logging.NOTSET})

            # Get/Set the logging level based on the levelName passed to the
            # function.
            self.verbosityLevel = \
                            LogLevel.get(levelName.upper(), logging.NOTSET)

            # Set logging level for the log file and console
            if self.__logfileHandleType == 'LOGFILE' or \
                                self.__logfileHandleType == 'BOTH':
                # Reset the log file logging level
                self.logfileHandler.setLevel(self.verbosityLevel)
            if self.__logfileHandleType == 'CONSOLE' or \
                                self.__logfileHandleType == 'BOTH':
                # Reset the console logging level
                self.consoleHandler.setLevel(self.verbosityLevel)

            self.__fileLoggerObj.setLevel(self.verbosityLevel)

        except LocalException as error:
            self.__formatBuffer = ( \
                'Error occurred in {0} module ResetLoggingLevel() method ' \
                'at Line #: {1}. {2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                            error.value), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                         CALLING_METHOD='ResetLoggingLevel():')
            return False
        else:
            return True


    # ----------------------      __AddLogHandlers()     ----------------------

    def __AddLogHandlers(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __AddLogHandlers():
                Sets up the log handlers for the log file and/or console
                based on the global log handle type (set prior to calling
                this function).

            Parameters:
                None.

            Returns:
                True if no issues setting up the handlers. False if the
                wrong handle name was passed.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        if self.__invokingModuleName:
            # __fileLoggerObj is the logger object for logging to a file
            # or console
            self.__fileLoggerObj = logging.getLogger(self.__invokingModuleName)
        else:
            self.__fileLoggerObj = logging.getLogger(__name__)

        # Now setup the log configurations
        if self.__logfileHandleType == 'LOGFILE':
            # Add the log handler
            self.__fileLoggerObj.addHandler(self.logfileHandler)

            # Set the log level for log file logging
            self.logfileHandler.setLevel(self.verbosityLevel)
        elif self.__logfileHandleType == 'CONSOLE':
            # Add the console handler
            self.__fileLoggerObj.addHandler(self.consoleHandler)

            # Set the console log level
            self.consoleHandler.setLevel(self.verbosityLevel)
        elif self.__logfileHandleType == 'BOTH':
            # Add the file and console handlers
            self.__fileLoggerObj.addHandler(self.logfileHandler)
            self.__fileLoggerObj.addHandler(self.consoleHandler)

            # Set the log level for log file logging
            self.logfileHandler.setLevel(self.verbosityLevel)
            self.consoleHandler.setLevel(self.verbosityLevel)
        else:
            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                         CALLING_METHOD='__AddLogHandlers():')
            return False

        self.__fileLoggerObj.setLevel(self.verbosityLevel)

        return True


    # ----------------------   __InitializeHandlers()    ----------------------

    def __InitializeHandlers(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __InitializeHandlers():
                Checks the type of handle and initializes the appropriate
                file handle for logging messages to. If the logging is to
                a file, then the type of file is determined by the log file
                type passed at the time the logging parameters were setup.
                The type of file is either RotatingFileHandler or
                TimedRotatingFileHandler.

            Parameters:
                None.

            Returns:
                True if log handles were created, False if the wrong handle
                name was passed to the function.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # If the self.__logfileHandleType defaulted to the LOGFILE, then make
        # sure the file handle also defaults to 'TimedRotatingFileHandler.
        if self.__logfileHandleType == 'LOGFILE' and not self.__logfileType:
            self.__logfileType = 'TIMEDROTATINGFILEHANDLER'

        if self.__logfileHandleType == 'LOGFILE':
            # Set the log file handler
            if self.__logfileType == 'ROTATINGFILEHANDLER':
                self.logfileHandler = \
                                logging.handlers.RotatingFileHandler( \
                                self.__logFileName, \
                                mode=self.__logFileMode, \
                                maxBytes=self.__logFileMaxBytes, \
                                backupCount=self.__logFileBackupCount, \
                                encoding=self.__logFileEncoding, \
                                delay=self.__logFileDelay)
            elif self.__logfileType == 'TIMEDROTATINGFILEHANDLER':
                self.logfileHandler = \
                                logging.handlers.TimedRotatingFileHandler( \
                                self.__logFileName, \
                                when=self.__logFileWhen, \
                                interval=self.__logFileInterval, \
                                backupCount=self.__logFileBackupCount, \
                                encoding=self.__logFileEncoding, \
                                delay=self.__logFileDelay, \
                                utc=self.__logFileUtc)
            else:
                self.__formatBuffer = ( \
                    "You have chosen 'LOG_TYPE' as LOGFILE but no " \
                    "'LOG_FILE_TYPE'. Make sure the 'LOG_FILE_TYPE' is set " \
                    "to either 'RotatingFileHandler' or " \
                    "'TimedRotatingFileHandler' in the class object " \
                    "initialization.")

                print(self.__FormatMessage( \
                    self.__formatBuffer, width=80, \
                    initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

                # If you are in Debug mode, print the application level
                # variables
                if self.verbosityLevel == self.DEBUG_LEVEL:
                    self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                     CALLING_METHOD='__InitializeHandlers():')
                return False
        elif self.__logfileHandleType == 'CONSOLE':
            # Set handler for the console
            self.consoleHandler = logging.StreamHandler()
        elif self.__logfileHandleType == 'BOTH':
            # Set the handler for the log file
            if self.__logfileType == 'ROTATINGFILEHANDLER':
                self.logfileHandler = \
                                logging.handlers.RotatingFileHandler( \
                                self.__logFileName, \
                                mode=self.__logFileMode, \
                                maxBytes=self.__logFileMaxBytes, \
                                backupCount=self.__logFileBackupCount, \
                                encoding=self.__logFileEncoding, \
                                delay=self.__logFileDelay)
            elif self.__logfileType == 'TIMEDROTATINGFILEHANDLER':
                self.logfileHandler = \
                                logging.handlers.TimedRotatingFileHandler( \
                                self.__logFileName, \
                                when=self.__logFileWhen, \
                                interval=self.__logFileInterval, \
                                backupCount=self.__logFileBackupCount, \
                                encoding=self.__logFileEncoding, \
                                delay=self.__logFileDelay, \
                                utc=self.__logFileUtc)
            else:
                self.__formatBuffer = ( \
                    "You have chosen 'LOG_TYPE' as BOTH but no " \
                    "'LOG_FILE_TYPE'. Make sure the 'LOG_FILE_TYPE' is set " \
                    "to either 'RotatingFileHandler' or " \
                    "'TimedRotatingFileHandler' in the class object " \
                    "initialization.")

                print(self.__FormatMessage( \
                    self.__formatBuffer, width=80, \
                    initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

                # If you are in Debug mode, print the application level
                # variables
                if self.verbosityLevel == self.DEBUG_LEVEL:
                    self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                     CALLING_METHOD='__InitializeHandlers():')
                return False

            # Set the handler for the console
            self.consoleHandler = logging.StreamHandler()
        elif not self.__logfileHandleType:
            # If log handle type is not specified, default to console.
            self.__logfileHandleType = 'CONSOLE'
            # Set handler for the console
            self.consoleHandler = logging.StreamHandler()
        else:
            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments(DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                     CALLING_METHOD='__InitializeHandlers():')
            return False

        return True


    # ----------------------      SetupLogHandlers()     ----------------------

    def SetupLogHandlers(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            SetupLogHandlers():
                Calls functions to initialize the log file handlers and add
                the handlers to the logger.

            Parameters:
                None.

            Returns:
                True if log file handlers were setup successfully, False
                else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Ensure this function is not called out of order
            if not self.__isAttributeSet or not self.__isFileParamsSet:
                self.lineNum = self.GetLineNo() - 1
                self.errorCode = 3
                raise LocalException(self.__outOfOrderError)

            # Call a function to add file, console or both handlers
            if not self.__InitializeHandlers():
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = ( \
                    'Incorrect Log Type. The valid values are LOGFILE, ' \
                    'CONSOLE, or BOTH. It must be set up in the ' \
                    'SetupLoggingAttributes() function.')
                self.errorCode = 4
                raise LocalException(self.__errorMessage)

            # Call a function to add logging handler
            if not self.__AddLogHandlers():
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = 'Unable to add the logging handlers.'
                self.errorCode = 5
                raise LocalException(self.__errorMessage)

        except LocalException as error:
            self.__formatBuffer = ( \
                'Error occurred in {0} module SetupLogHandlers() ' \
                'method at Line #: {1}. {2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                            error.value), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, break_long_words=False, \
                break_on_hyphens=False), '\n')

            return False
        else:
            self.__isFileHandlersSet = True
            return True


    # ---------------------   SetupLoggingAttributes()   ----------------------

    def SetupLoggingAttributes(self, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            SetupLoggingAttributes():
                Sets the logging level and the log file type based on the
                parameters passed to the function. The log file type is
                either LOGFILE, CONSOLE, or BOTH. This is required to
                identify the handlers when the handlers are created.

            Parameters:
                keywordArgs - Keyword arguments.
                              LOG_LEVEL
                                 - Depth of logging. The only acceptable
                                   values are any of the following keywords:
                                   DEBUG, INFO, WARNING, ERROR, CRITICAL
                                   Case does not matter.
                              LOG_TYPE
                                 - File or Console handler. Valid values
                                   are: LOGFILE, CONSOLE, or BOTH. Case does
                                   not matter.

            Returns:
                True if log level was setup successfully, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Note this function must be invoked first after instantiating
            # the class object. So, check if other functions have been called
            # out of order and throw an error.
            if not self.__isFileParamsSet or self.__isFileHandlersSet:
                self.lineNum = self.GetLineNo() - 1
                self.errorCode = 6
                raise LocalException(self.__outOfOrderError)

            levelName = None    # Initialize logging level name

            # Dictionary of valid log levels for the python logger class
            LogLevel = ( \
                    {'DEBUG': logging.DEBUG, 'INFO': logging.INFO, \
                    'WARNING': logging.WARNING, 'ERROR': logging.ERROR, \
                    'CRITICAL': logging.CRITICAL, 'NOTSET': logging.NOTSET})

            if keywordArgs:
                keywordDict = {}
                iCount = 1
                for keyWord in keywordArgs:
                    keyWordToUpper = keyWord.upper()
                    keywordDict.update({keyWordToUpper : \
                                                keywordArgs[keyWord].upper()})

                    iCount += 1
                    if keyWordToUpper == 'LOG_LEVEL':
                        levelName = keywordDict[keyWordToUpper]
                    elif keyWordToUpper == 'LOG_TYPE':
                        # Note that self.__logfileHandleType is set at the
                        # time of object initialization but if the LOG_HANDLE
                        # is passed as a keyword parameter, then use that to
                        # setup the logging file handles.
                        if keywordDict[keyWordToUpper] == 'LOGFILE':
                            # In order to do logging to a file, the file name
                            # should have been established by now. This is
                            # done at the time of the object initialization.
                            # If the name is None, set the logging to go to
                            # the console.
                            if not self.__logFileName:
                                self.__logfileHandleType = 'CONSOLE'

                                self.__formatBuffer = ( \
                                    'No log file name provided at the time ' \
                                    'the class object was initialized. ' \
                                    'Therefore, it will default to CONSOLE ' \
                                    'logging.')
                                print(self.__FormatMessage( \
                                    self.__formatBuffer, width=80, \
                                    initial_indent='\n        ', \
                                    subsequent_indent=' ' * 8, \
                                    break_long_words=False, \
                                    break_on_hyphens=False), '\n')

                                self.PrintArguments( \
                                    DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                    CALLING_METHOD='SetupLoggingAttributes():')
                            else:
                                self.__logfileHandleType = ( \
                                    keywordDict[keyWordToUpper])    # LOGFILE
                        elif keywordDict[keyWordToUpper] == 'CONSOLE':
                            self.__logfileHandleType = ( \
                                    keywordDict[keyWordToUpper])    # CONSOLE
                        elif keywordDict[keyWordToUpper] == 'BOTH':
                            if not self.__logFileName:
                                self.__logfileHandleType = 'CONSOLE'

                                self.__formatBuffer = ( \
                                    'No log file name provided at the time ' \
                                    'the class object was initialized. ' \
                                    'Therefore, it will default to ' \
                                        'to CONSOLE logging.')
                                print(self.__FormatMessage( \
                                    self.__formatBuffer, width=80, \
                                    initial_indent='\n        ', \
                                    subsequent_indent=' ' * 8, \
                                    break_long_words=False, \
                                    break_on_hyphens=False), '\n')

                                self.PrintArguments( \
                                    DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                    CALLING_METHOD='SetupLoggingAttributes():')
                            else:
                                self.__logfileHandleType = ( \
                                        keywordDict[keyWordToUpper])    # BOTH
                        else:
                            self.lineNum = self.GetLineNo() - 1
                            self.__errorMessage = \
                                            'Not a valid value for LOG_TYPE.'
                            self.errorCode = 7
                            raise LocalException(self.__errorMessage)

            # Check if the logging level was passed to the function or no
            # keyword arguments were passed at all.
            if not keywordArgs or not levelName:
                self.lineNum = self.GetLineNo() - 1
                levelName = 'DEBUG'
                self.__errorMessage = ( \
                    'Missing keyword argument for setting logging level. ' \
                    'Defaulting to Debug or you can \nprovide one of the ' \
                    'following logging levels.\n'
                    '       DEBUG    - Log Debug level messages\n'
                    '       INFO     - Log Informational level messages\n'
                    '       WARNING  - Log Warning level messages\n'
                    '       ERROR    - Log Error level messages\n'
                    '       CRITICAL - Log Critical level messages\n')
                print(self.__errorMessage)

        except LocalException as error:
            self.__formatBuffer = ( \
                'Error occurred in {0} module SetupLoggingAttributes() ' \
                'method at Line #: {1}. {2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                            error.value), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments( \
                                DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                CALLING_METHOD='SetupLoggingAttributes():')
            return False
        else:
            # Get/Set the logging level based on the levelName passed to the
            # function. Below are the numerical values of the different levels
            # of logging:
            #   CRITICAL    50  -   usage: <program name> -vvvvv
            #   ERROR       40  -   usage: <program name> -vvvv
            #   WARNING     30  -   usage: <program name> -vvv
            #   INFO        20  -   usage: <program name> -vv
            #   DEBUG       10  -   usage: <program name> -v
            #   NOTSET      0   -   usage: <program name>
            self.verbosityLevel = LogLevel.get(levelName, logging.NOTSET)
            self.__isAttributeSet = True
            return True


    # ----------------------     __CheckLogFileArgs()    ----------------------

    def __CheckLogFileArgs(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CheckLogFileArgs():
                Checks to see if the log file name and the directory path
                were provided as part of the class object initialization.
                If the file name was not provided, the module name passed
                at the time of object instantiation is used to formulate
                the log file name. Also appends the directory path if
                provided.

            Parameters:
                None

            Returns:
                True if the log file name was created, False else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Check if the log file name was passed when the SetupLogFileParams()
        # was called. Note that currently nothing is required. If the
        # logFileName is not provided, it will default to the base name of
        # the module.
        if not self.__logFileName:
            if self.__invokingModuleName:
                tempFileName = os.path.basename(self.__invokingModuleName)
                indexOfDot = tempFileName.index('.')
                self.__logFileName = \
                        ('%s%s' % (tempFileName[:indexOfDot], '.log'))
            else:
                # If you are in Debug mode, print the application level
                # variables
                if self.verbosityLevel == self.DEBUG_LEVEL:
                    self.PrintArguments( \
                                    DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                    CALLING_METHOD='__CheckLogFileArgs():')
                return False

        # If the log file path is given, then append it. Check if the path
        # has a ending '/'.
        if self.__logFilePath:
            if self.__logFilePath[-1:] in ['/']:
                self.__logFileName = \
                        ('%s%s' % (self.__logFilePath, self.__logFileName))
            else:
                self.__logFileName = \
                        ('%s/%s' % (self.__logFilePath, self.__logFileName))

        return True


    # ----------------------     SetupLogFileParams()    ----------------------

    def SetupLogFileParams(self, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            SetupLogFileParams():
                Evaluates the keyword arguments and sets up the log file
                parameters.

            Parameters:
                keywordArgs - File attributes for the log file. If not
                              provided, it defaults to the values set by
                              the class object initialization. Recommend
                              these default settings unless there is an
                              absolute necessity to change them.

            Returns:
                True if log file parameters were setup successfully, False
                else.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Check to see if the logging attributes were set prior to calling
            # this method.
            if self.__isAttributeSet:
                self.lineNum = self.GetLineNo() - 1
                self.errorCode = 8
                raise LocalException(self.__outOfOrderError)

            if self.__logfileType == 'ROTATINGFILEHANDLER':
                # Get the keyword values (if any) for rotating file handler.
                for keywordVal in keywordArgs:
                    if keywordVal.upper() == 'MODE':
                        self.__logFileMode = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'MAXBYTES':
                        self.__logFileMaxBytes = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'BACKUPCOUNT':
                        self.__logFileBackupCount = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'ENCODING':
                        self.__logFileEncoding = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'DELAY':
                        self.__logFileDelay = keywordArgs[keywordVal]
            elif self.__logfileType == 'TIMEDROTATINGFILEHANDLER':
                # Get the keyword values (if any) for timed rotating file
                # handler
                for keywordVal in keywordArgs:
                    if keywordVal.upper() == 'WHEN':
                        self.__logFileWhen = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'INTERVAL':
                        self.__logFileInterval = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'BACKUPCOUNT':
                        self.__logFileBackupCount = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'ENCODING':
                        self.__logFileEncoding = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'DELAY':
                        self.__logFileDelay = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'UTC':
                        self.__logFileUtc = keywordArgs[keywordVal]
                    elif keywordVal.upper() == 'ATTIME':
                        self.__logFileAtTime = keywordArgs[keywordVal]

            # Now check if all the required arguments are present for the log
            # file creation.
            if self.__invokingModuleName or self.__logFileName:
                if not self.__CheckLogFileArgs():
                    self.lineNum = self.GetLineNo() - 1
                    self.__errorMessage = 'Missing Log file name.'
                    self.errorCode = 9
                    raise LocalException(self.__errorMessage)

        except LocalException as error:
            print('        Error occurred in %s module SetupLogFileParams() ' \
                'method at Line #: %d.\n        %s' \
                % (self.__moduleName, self.lineNum, error.value))
            # If you are in Debug mode, print the application level variables
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments( \
                                DISPLAY_LEVEL='APP_LEVEL_ARGS', \
                                CALLING_METHOD='SetupLogFileParams():')
            # Also print the FILE_LEVEL parameters
            if self.verbosityLevel == self.DEBUG_LEVEL:
                self.PrintArguments( \
                                DISPLAY_LEVEL='FILE_LEVEL_ARGS', \
                                CALLING_METHOD='SetupLogFileParams():')
            return False
        else:
            self.__isFileParamsSet = True
            return True


    # -----------------------        __init__()         -----------------------

    def __init__(self, **keywordArgs):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the LoggerClass class object.

            Parameters:
                keywordArgs - Named or keyword arguments.
                              MODULE_NAME:
                                 Calling Module Name. If not provided it is
                                 assumed logging is to the console.
                              LOG_FILE_TYPE:
                                 One of file types either RotatingFileHandler
                                 or TimedRotatingFileHandler. If not provided,
                                 assume the file type is
                                 TimedRotatingFileHandler.
                              LOG_FILE_NAME:
                                 Name of the log file you want the logging to
                                 happen.
                              LOG_FILE_PATH:
                                 Log file path where the file needs to reside.

            Returns:
                None.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Evaluate positional arguments
            if keywordArgs:
                for keyWord in keywordArgs:
                    argsToUpper = keyWord.upper()
                    if argsToUpper == 'MODULE_NAME':
                        self.__invokingModuleName = keywordArgs[keyWord]
                    elif argsToUpper == 'LOG_FILE_TYPE':
                        # Make sure the argument is RotatingFileHandler or
                        # TimedRotatingFileHandler. Case does not matter.
                        tempArg = keywordArgs[keyWord].upper()
                        if (tempArg != 'ROTATINGFILEHANDLER' and
                                tempArg != 'TIMEDROTATINGFILEHANDLER'):
                            self.lineNum = self.GetLineNo() - 1
                            self.__errorMessage = \
                                    ("The file type must me one of " \
                                    "'RotatingFileHandler' or " \
                                    "'TimedRotatingFileHandler'")
                            self.errorCode = 10
                            raise LocalException(self.__errorMessage)
                        else:
                            self.__logfileType = tempArg
                    elif argsToUpper == 'LOG_FILE_NAME':
                        self.__logFileName = keywordArgs[keyWord]
                    elif argsToUpper == 'LOG_FILE_PATH':
                        self.__logFilePath = keywordArgs[keyWord]

        except LocalException as error:
            self.__formatBuffer = ( \
                'Error occurred in {0} module __init__() method at ' \
                    'Line #: {1}. {2}')

            print(self.__FormatMessage( \
                self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                                            error.value), \
                width=80, initial_indent='\n        ', \
                subsequent_indent=' ' * 8, break_long_words=False, \
                break_on_hyphens=False), '\n')
