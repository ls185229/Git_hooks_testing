#!/usr/bin/env python
# -*- coding: utf-8 -*-

from logger_class import LoggerClass
# from datetime import datetime
import sys
# import logging

"""
    Verbosity logging examles:
        https://gist.github.com/aptxna/3635f73e79e14e67ec6dd080c263de8b
        https://gist.github.com/olooney/8155400
        https://docs.python.org/2.6/library/logging.html
        https://docs.python.org/2/library/logging.handlers.html
        https://gist.github.com/n8henrie/33eebb2b43753e247854
        A good articles about the pitfalls of module level logging:
            http://www.patricksoftwareblog.com/python-logging-tutorial/
            https://fangpenlin.com/posts/2012/08/26/good-logging-practice-in-python/
            http://pythonsweetness.tumblr.com/post/67394619015/use-of-logging-package-from-withi    n-a-library
"""


if __name__ == '__main__':
    print('Calling from testLogger.py - Checking __name__ == __main__')
    # print('1. Calling from testLogger.py: Argsv: ', sys.argv[0:])

    iCount = 0
    for args in sys.argv:
        print('%d. Calling from testLogger.py - Main(): args = %s' % (iCount + 1, args))
        iCount += 1

    #     TESTING     TESTING     TESTING     TESTING     TESTING     TESTING     #
    # loggerObj = LoggerClass(*sys.argv[0:])
    # loggerObj = LoggerClass() 
    # loggerObj = LoggerClass(MODULE_NAME = 'testLogger.py') 

    # loggerObj = LoggerClass(MODULE_NAME = 'testLogger.py', 
    #                  LOG_FILE_NAME = 'mylogger.log',
    #                  LOG_FILE_TYPE = 'timedrotatingFileHandleR', 
    #                  LOG_FILE_PATH = '/clearing/filemgr/Leonard/OKDMV_TESTING/LOGTESTING/')

    # LOG_LEVEL is not a parameter in the initialization process, so it is redundant. This 
    # is a test to make sure the class does not fail.
    # loggerObj = LoggerClass(MODULE_NAME = 'testLogger.py', 
    #                    LOG_FILE_TYPE = 'timedrotatingFileHandleR', 
    #                    LOG_FILE_PATH = '/clearing/filemgr/REPORTS/DAILYLOG',
    #                    LOG_LEVEL = 'debug')

    # Log to the local directory. The named parameters need not be capitalized.
    loggerObj = LoggerClass(MODULE_NAME = 'testLogger.py', 
                     log_file_name = 'mylogger.log',
                     LOG_FILE_TYPE = 'timedrotatingFileHandleR') 


    #********************************************************************************
    #  Setting up the class logger involves the following steps and must be invoked *
    #  in the same order as below.                                                  * 
    #                                                                               *
    #     1. Creating the logger class object. The named parameters are optional.   *
    #        based on how you want to set up the log file.                          *
    #           MODULE_NAME   - Name of the module instantiating the class object.  *
    #                           In the event the LOG_FILE_NAME is not provided, the *
    #                           class will use the module name to log the messages. *
    #                           It is recommended that you provide module name or   *
    #                           file name to log to.                                * 
    #           LOG_FILE_NAME - Name of the log file to log messages to. If given   *
    #                           will log to this file. See the above note on        *
    #                           MODULE_NAME.                                        *
    #           LOG_FILE_PATH - The path where the log file should reside.          *
    #           LOG_FILE_TYPE - The type of log file. 'RotatingFileHandler' or      *
    #                           'TimedRotatingFileHandler'.                         *
    #                                                                               *
    #     2. Setting up log file parameters. This is the second step in the         *
    #        process. Refer to the documentation on the above file types. It is     *
    #        recommended you let the class object default these parameters to the   *
    #        attributes set in there.                                               *
    #                                                                               *
    #     3. Setting up logging attributes. This is the third step in the process.  *
    #        It involves setting up the logging level and the logging method like   *
    #        logging to a console, a file, or both. If any of these arguments are   *
    #        not provided, they default to DEBUG and CONSOLE logging.               *
    #                                                                               *
    #     4. Setting up logging handlers, formatters and logging levels.            *
    #********************************************************************************

    # Set up file parameters so that the file can be created later. The only arguments
    # you can pass to this function are the respective file attributes for creating a
    # RotatingFileHandler or a TimedRotatingFileHandler. Below are the different keyword
    # parameters for the two types of files ('ROTATINGFILEHANDLER', 'TIMEDROTATINGFILEHANDLER')
    
        # 'ROTATINGFILEHANDLER':
            # 'MODE'
            # 'MAXBYTES'
            # 'BACKUPCOUNT'
            # 'ENCODING'
            # 'DELAY'
        # 'TIMEDROTATINGFILEHANDLER':
            # 'WHEN'
            # 'INTERVAL'
            # 'BACKUPCOUNT'
            # 'ENCODING'
            # 'DELAY'
            # 'UTC'
            # 'ATTIME'
                        
    if not loggerObj.SetupLogFileParams():
        sys.exit()

    #     TESTING     TESTING     TESTING     TESTING     TESTING     TESTING     #
    # Set up logging level and logging type (FILE/CONSOLE/BOTH logging types)
    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'warNing', Log_Type = 'console'):
    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'Debug', Log_Type = 'LOGFILE'):
    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'Debug'):
    # if not loggerObj.SetupLoggingAttributes(log_TYPE = 'BOTH', LOG_LEVEL = 'Critical'):
    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'Debug', Log_Type = 'LOGFILE'):
    #     sys.exit()

    # Assume default values in SetupLoggingAttributes()
    # if not loggerObj.SetupLoggingAttributes():
    #     sys.exit()

    # if not loggerObj.SetupLoggingAttributes():
    if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'warning', Log_Type = 'BOTH'):
        sys.exit()

    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'DEBUG', LOG_TYPE = 'CONSOLE'):
    # if not loggerObj.SetupLoggingAttributes(LOG_LEVEL = 'info'):
    # Note that inorder to log to a file the file name must be specified in the object 
    # initialization, otherwise it will only log to the console.
    # if not loggerObj.SetupLoggingAttributes(LOG_TYPE = 'LOGFILE'):

    if not loggerObj.SetupLogHandlers():
        sys.exit()
    
    # Test the logger object attributes passed.
    loggerObj.PrintArguments(DISPLAY_LEVEL = 'APP_LEVEL_ARGS', CALLING_METHOD = 'testLogger.py')

    # loggerObj.PrintArguments(DISPLAY_LEVEL = 'APP_LEVEL_ARGS', 
    #                               CALLING_METHOD = 'testmethod()')

    #     TESTING     TESTING     TESTING     TESTING     TESTING     TESTING     #
    # Logging different types of messages to CONSOLE, LOG FEILE or BOTH.

    if not loggerObj.LogMessage('Begin testLogger.py Execution:', 'BEGIN'):
        sys.exit()
    if not loggerObj.LogMessage('<----- This is the first log message ----->'):
        sys.exit()
    if not loggerObj.LogMessage('<----- This is the second log message ----->'):
        sys.exit()
    if not loggerObj.LogMessage('<----- This is the third log message ----->'):
        sys.exit()
    if not loggerObj.LogMessage('End testLogger.py Execution:', 'END'):
        sys.exit()

    # Reset logging level
    if not loggerObj.ResetLoggingLevel('ERROR'):
        sys.exit()
    else:
        if not loggerObj.LogMessage('Begin testLogger.py Execution:', 'BEGIN'):
            sys.exit()
        if not loggerObj.LogMessage('<----- RESET  ERROR  ERROR  RESET    ----->', 'BODY'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This the reset for ERROR message 1 ----->'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This the reset for ERROR message 2 ----->'):
            sys.exit()
        if not loggerObj.LogMessage('End testLogger.py Execution:', 'END'):
            sys.exit()
        
    # Reset logging level
    if not loggerObj.ResetLoggingLevel('info'):
        sys.exit()
    else:
        print("Should print the messages after resetting the log level to 'info'")
        if not loggerObj.LogMessage('Begin testLogger.py Execution:', 'BEGIN'):
            sys.exit()
        if not loggerObj.LogMessage('<----- RESET  INFO  INFO  RESET    ----->'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This is the INFO reset log message ----->'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This is the second INFO reset log message ----->'):
            sys.exit()
        if not loggerObj.LogMessage('End testLogger.py Execution:', 'END'):
            sys.exit()

    # Reset logging level
    if not loggerObj.ResetLoggingLevel('DEBUG'):
        sys.exit()
    else:
        print("Should print the messages after resetting the log level to 'DEBUG'")
        if not loggerObj.LogMessage('Begin testLogger.py Execution:', 'BEGIN'):
            sys.exit()
        if not loggerObj.LogMessage('<----- RESET  DEBUG  DEBUG  RESET    ----->'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This the reset for DEBUG message 1 ----->'):
            sys.exit()
        if not loggerObj.LogMessage('<----- This the reset for DEBUG message 2 ----->'):
            sys.exit()
        if not loggerObj.LogMessage('End testLogger.py Execution:', 'END'):
            sys.exit()
        


    # Note this message is sent to the logger using the logger class private variable
    # __fileLoggerObject. This is a violation of object oriented programming but python
    # does allow you to access private attributes from a module instantiating the class
    # object. I would not recommend doing it this way. 
    loggerObj._LoggerClass__fileLoggerObj.warning('This is a Test from the calling program')


