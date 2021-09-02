#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to create and email the Florida COGS  report.
    $Id: florida_cogs_class.py 4693 2018-09-11 15:09:00Z lmendis $
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

import subprocess
import re

import cx_Oracle

# Add the library path. Note that the DbClass, LoggerClass, and EmailClass are
# libraries that reside in the /clearing/filemgr/MASCLRLIB directory. This line
# must be positioned prior to the import of the class libraries. Refer to
# https://www.blog.pythonlibrary.org/2016/03/01/python-101-all-about-imports/
sys.path.append('/clearing/filemgr/MASCLRLIB')
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


class FloridaCogsClass(object):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for creating and mailing the Florida COGS report.

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
    __sqlText = None
    __QUERY_TEXT = \
        """
        SELECT
            mtl.institution_id "Inst",
            substr(mtl.entity_id, 8, 4) "Agent",
            trunc(mtl.gl_date, 'MM') "GL Month",
            '''' || mtl.entity_id "ENTITY ID",
            ae.entity_name,
            ae.entity_dba_name,
            SUM(CASE WHEN mtl.tid_settl_method = 'D'  THEN 1
                     WHEN mtl.tid_settl_method <> 'D' THEN -1 ELSE 0 END *
                mtl.AMT_billing) as "Gross Income",
            SUM(
                CASE WHEN ta.minor_cat = 'INTERCHANGE' THEN
                CASE WHEN mtl.tid_settl_method = 'D'  THEN 1
                     WHEN mtl.tid_settl_method <> 'D' THEN -1 ELSE 0 END END *
                mtl.AMT_billing) as "Interchange",
            SUM(
                CASE WHEN ta.minor_cat not in ('INTERCHANGE', 'DISCOUNT', 'SETTLE', 'AUTH') THEN
                CASE WHEN mtl.tid_settl_method = 'D'  THEN 1
                     WHEN mtl.tid_settl_method <> 'D' THEN -1 ELSE 0 END END *
                mtl.AMT_billing) as "Dues / Assessments",
            SUM(
                CASE WHEN ta.minor_cat in ('DISCOUNT', 'SETTLE', 'AUTH') THEN
                CASE WHEN mtl.tid_settl_method = 'D'  THEN 1
                     WHEN mtl.tid_settl_method <> 'D' THEN -1 ELSE 0 END END *
                mtl.AMT_billing) as "Processing Costs"
        FROM masclr.mas_trans_log mtl
        JOIN acq_entity ae
        ON ae.entity_id = mtl.entity_id
        AND ae.institution_id = mtl.institution_id
        JOIN tid_adn ta
        ON ta.tid = mtl.tid
        WHERE mtl.gl_date >= '{0}' AND mtl.gl_date < '{1}'
          AND ta.major_cat = 'FEES'
          AND ta.minor_cat not in ('ACH')
          AND mtl.institution_id in ({2})
          AND
            (
            regexp_like(mtl.entity_id, '^454045.110[2345]')
            OR
                (regexp_like(mtl.entity_id, '^454045.1100')
                AND
                regexp_like(ae.entity_name, 'COLLECTOR.* SOLUTION')
                )
            )
        GROUP BY rollup(
            mtl.institution_id,
            substr(mtl.entity_id, 8, 4),
            trunc(mtl.gl_date, 'MM'),
            mtl.entity_id,
            ae.entity_name,
            ae.entity_dba_name)
        HAVING ae.entity_dba_name IS NOT null OR mtl.institution_id IS null
        ORDER BY
            mtl.institution_id,
            substr(mtl.entity_id, 8, 4),
            mtl.entity_id
        """


    # --------------------        __UploadFile()           --------------------

    def __UploadFile(self, remoteHost, remoteUser, sourceFile, \
                verbosityLevel, localDirectory=None, remoteFile=None, \
                remoteDirectory=None, uploadFlag='SCP'):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __UploadFile():
                uploads a file to a remote location as specified by the
                argument list.

            Parameters:
                remoteHost      - Remote host name
                remoteUser      - Remote user ID
                sourceFile      - Source file to remote copy
                verbosityLevel  - Verbose level for debugging
                localDirectory  - Local directory where the source file resides
                remoteFile      - File to be renamed at the remote location if
                                  needed. Otherwise, assume the same as source.
                remoteDirectory - Directory at the remote location
                uploadFlag      - Default to SCP, otherwise RSYNC.

            Returns:
                True if upload was successful, False else.

            Source Reference:
                https://ryanveach.com/233/calling-rsync-with-pythons-subprocess-module/
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # Escape all characters in the full file path.
        if remoteDirectory:
            remoteDirectory = re.escape(remoteDirectory)
        if localDirectory:
            localDirectory = re.escape(localDirectory)

        # Format the remote location as 'username@hostname:'location'
        remoteDestination = '%s@%s:%s/%s' \
                % (remoteUser, remoteHost, remoteDirectory, remoteFile)

        # Attach the file path to the source file.
        if localDirectory:
            localFileWithPath = os.path.join(localDirectory, sourceFile)

        if verbosityLevel == 1:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Print message generated in Module: {0} Method: ' \
                '__UploadFile() at Line #: {1}. localDirectory: {2} ' \
                'remoteDirectory: {3} localFileWithPath: {4} ' \
                'remoteDestination: {5}{6}')

            print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                        localDirectory, remoteDirectory, localFileWithPath, \
                        remoteDestination, ''), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, \
                    break_long_words=False, \
                    break_on_hyphens=False), '\n')
            # Log to the log file
            self.__lineNum = self.__GetLineNo() + 1
            if not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                        localDirectory, remoteDirectory, localFileWithPath, \
                        remoteDestination, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

        # Before issuing the rsync command to transfer files, run a mkdir
        # command in case the remote directory does not exist. If the
        # directory exists, then the mkdir command does nothing.
        # Remote directory exists on SFTP server, so don't try to create it
        # again. Leave code in case it needs to go to a different directory.

        # LM - TESTING
        # """
        # mkdirCommand = 'ssh -q %s@%s /bin/mkdir -p %s >> /dev/null' \
                            # % (remoteUser, remoteHost, remoteDirectory)
        # # Now run the commands. shell=True is used to prevent failures caused
        # # by the escaped characters in the file name and path.
        # procRetValue = \
            # subprocess.Popen(mkdirCommand, shell=True, \
                                # stdout=subprocess.PIPE, \
                                # stderr=subprocess.STDOUT).wait()
        # if procRetValue:
            # return False
        # """

        if uploadFlag == 'RSYNC':
            # Create the rsync command to copy files
            rsyncCommand = '/usr/bin/rsync -qa %s %s >> /dev/null' \
                                    % (localFileWithPath, remoteDestination)
            # LM - TESTING
            procRetValue = 0
            print('rsyncCommand : {0}'.format(rsyncCommand))
            # procRetValue = \
                # subprocess.Popen(rsyncCommand, shell=True, \
                                    # stdout=subprocess.PIPE, \
                                    # stderr=subprocess.STDOUT).wait()
        else:
            # Create the scp command to copy the files
            scpCommand = 'scp %s %s' % (localFileWithPath, remoteDestination)
            print('SCP Command: ', scpCommand)
            procRetValue = \
                subprocess.Popen(scpCommand, shell=True, \
                                    stdout=subprocess.PIPE, \
                                    stderr=subprocess.STDOUT).wait()

        if procRetValue:
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
                Initializes the Florida COGS class object.

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
            ('        Usage is:\n            %s [-u or -U or --usage]\n' \
            '            [-b or -B or --begindate <YYYYMMDD> (Optional)]\n' \
            '            [-d or -D or --enddate <YYYYMMDD> (Required)]\n' \
            '            [-i or -I or --inst <Institution ID> (Required)]\n' \
            '            [-v or -V or --verbose <Verbose Level>]\n' \
            '            [-t or -T or --test (Optional)]\n' \
            '            [-l or -L or --logtype <LOGFILE/CONSOLE/BOTH> ' \
            '(Optional)]\n\n            %s\n                %s\n' \
            '                %s\n                %s\n                ' \
            '%s\n                %s\n') \
            % (__file__, 'Verbose Levels:', '-v     - Debug', '-vv    ' \
                '- Info', '-vvv   - Warning', '-vvvv  - Error', \
                '-vvvvv - Critical'))


    #----------------------      __CreateCsvFile()      -----------------------

    def __CreateCsvFile(self, repStartDate, repEndDate, queryEndDate, \
                        institutionId, verbosityLevel, runMode):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateCsvFile():
                This function takes the start and end dates for the report
                and uses them to run an SQL statement to fetch the results.
                Then it creates a CSV file for distribution.

            Parameters:
                repStartDate   - Report Start Date dd-mon-yy format.
                repEndDate     - Report End Date dd-mon-yy format.
                queryEndDate   - End date for query, usually the first of the
                                 following month relative to report end date.
                institutionId  - Institution ID.
                verbosityLevel - Verbosity level
                                    - DEBUG/INFO/WARNING/ERROR/CRITICAL
                runMode        - Option to run as test.

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
                    'Date: {2} Report End Date: {3} Instituition: {4} ' \
                    'Mode: {5}{6}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    repStartDate, repEndDate, institutionId, \
                                    runMode, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    repStartDate, repEndDate, institutionId, \
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
            # the environment.
            # dbObject = DbClass(HOSTNM='dfw-prd-db-09.jetpay.com', \
            #                     ENV_USERID='IST_DB_USERNAME', \
            #                     PORTNO='1521', \
            #                     ENV_PASSWD='IST_DB_PASSWORD', \
            #                     SERVNM='clear1.jetpay.com')
            dbObject = DbClass(ENV_HOSTNM='IST_HOST', \
                                ENV_USERID='IST_DB_USERNAME', \
                                PORTNO='1521', \
                                ENV_PASSWD='IST_DB_PASSWORD', \
                                ENV_SERVNM='IST_SERVERNAME')

            if dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    dbObject.GetErrorDescription(dbObject.errorCode))

            dbObject.Connect(True)

            if dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    dbObject.GetErrorDescription(dbObject.errorCode))

            # Get the pool number assigned by the object for the acquired
            # connection.
            poolIndex = dbObject.AcquireConnection()

            # Check if there are database errors before proceeding
            if dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    dbObject.GetErrorDescription(dbObject.errorCode))

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

            # Check if there are database errors before proceeding
            if dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    dbObject.GetErrorDescription(dbObject.errorCode))

            self.__sqlText = \
                self.__QUERY_TEXT.format(repStartDate, queryEndDate, \
                                            institutionId)

            # Print the sql text to the log file
            if not self.__loggerObj.LogMessage(self.__sqlText, 'BODY'):
                pass

            # Note that the positional parameters 1 - 6 must have values.
            # The rest rest are keyword arguments. It is recommended to make
            # the positional arguments as named for clarity but it is not
            # necessary as long as they hold values.
            csvFileName = ('Florida_COGS_Report_%s_to_%s.csv' \
                                                % (repStartDate, repEndDate))
            dbObject.ExportDataFromTable(cursorNumber, \
                                        outputFile=csvFileName, \
                                        outputFilePath=None, \
                                        includeHeaders=True, \
                                        sqlText=self.__sqlText, \
                                        tableName=None, \
                                        delimiter=',', quotechar=None, \
                                        skipinitialspace=True, \
                                        quoting=csv.QUOTE_NONE)

            # Check if there are database errors before proceeding
            if dbObject.errorCode:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                    dbObject.GetErrorDescription(dbObject.errorCode))

            # Close the second cursor that was opened for the pooled
            # connection.
            dbObject.CloseCursor(cursorNumber)

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'Error in {0} module __CreateCsvFile() method at '
                'Line #: {1}: {2}')
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

            # Now send an email alert
            if runMode == 'PROD':
                emailSubject = ( \
                    'An Error occurred generating Florida COGS report ' \
                    'for %s to %s' % (repStartDate, repEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An Error occurred generating Florida '
                    'COGS report for %s to %s' % (repStartDate, repEndDate))

            emailBody = self.__formatBuffer.format('', '', exceptError.value)

            # If called with -v Debug flag or test mode print the email config
            # file path
            if verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        '__CreateCsvFile() at Line #: {1}. Email config ' \
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
                                CONFIG_SECTION_NAME='FLORIDA_COGS_ALERTS', \
                                EMAIL_SUBJECT=emailSubject, \
                                EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')

            return False
        except RuntimeError as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                'An exception occurred while creating the CSV file in ' \
                'Module: {0} Method: __CreateCsvFile() at Line #: {1}: ' \
                '{2}{3}')

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
            if runMode == 'PROD':
                emailSubject = ( \
                    'An Error occurred generating Florida COGS report ' \
                    'for %s to %s' % (repStartDate, repEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An Error occurred generating Florida '
                    'COGS report for %s to %s' % (repStartDate, repEndDate))

            emailBody = self.__formatBuffer.format('', '', str(exceptError))

            # If called with -v Debug flag or test mode print the email config
            # file path
            if verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        '__CreateCsvFile() at Line #: {1}. Email config ' \
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
                                CONFIG_SECTION_NAME='FLORIDA_COGS_ALERTS', \
                                EMAIL_SUBJECT=emailSubject, \
                                EMAIL_BODY=emailBody):
                print('            Unable to generate Email Alert.\n')

            return False
        else:
            # Format email subject line for use in email messages to follow
            # later
            if runMode == 'PROD':
                emailSubject = ('Florida Cogs Report for %s to %s' \
                                    % (repStartDate, repEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - Florida Cogs Report for %s to %s' \
                    % (repStartDate, repEndDate))
            if not dbObject.errorCode:
                # Release connection back to the pool if you are done.
                dbObject.ReleaseConnection(poolIndex)

                # Disconnect from the database
                dbObject.Disconnect()

                # If called with -v Debug flag or test mode print the email
                # config file path
                if verbosityLevel == 1 or runMode == 'TEST':
                    self.__lineNum = self.__GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                            'Print message generated in Module: {0} Method: ' \
                            '__CreateCsvFile() at Line #: {1}. Email config ' \
                            'file path: {2}.{3}')
                    print(self.__FormatMessage( \
                            self.__formatBuffer.format(__file__, \
                                self.__lineNum, self.__emailConfigFile, ''), \
                            width=80, initial_indent='\n        ', \
                            subsequent_indent=' ' * 8, \
                            break_long_words=False, \
                            break_on_hyphens=False), '\n')

                # Archive the file
                basePath = os.path.dirname(os.path.abspath(__file__))
                archivePath = os.path.join(basePath, 'ARCHIVE')
                sourceFilePath = os.path.join(basePath, csvFileName)
                destFilePath = os.path.join(archivePath, csvFileName)
                # If the run mode is TEST, then do not put it on the SFTP site
                if runMode != 'PROD':
                    remoteHost = os.environ.get('MAS_HOST_NAME')
                    remoteDirectory = \
                            '/clearing/filemgr/JOURNALS/MONTHEND/JP_FL'
                    # 'SCP' for remote copy or 'RSYNC' to use rsync command
                    uploadFlag = 'RSYNC'
                else:
                    remoteHost = os.environ.get('SFTP_HOST')
                    remoteDirectory = '/secure/jetcorp/fl'
                    # remoteDirectory = \
                    #         '/secure/collectorsolutions/reports/accounting'
                    # 'SCP' for remote copy or 'RSYNC' to use rsync command
                    uploadFlag = 'SCP'

                # Send email attachment
                outputFileList = [csvFileName]
                emailBody = 'Successfully created the %s file and uploaded ' \
                            'to the %s directory on the %s server.'\
                            % (csvFileName, remoteDirectory, remoteHost)
                if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='FLORIDA_COGS_REPORTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody, \
                            ATTACH_FILES_LIST=outputFileList, \
                            ATTACH_FILES_FOLDER=\
                                os.path.dirname(os.path.abspath(__file__))):
                    print('            ' \
                        'Unable to generate the Florida COGS report Email.\n')
                    return False

                remoteUser = os.environ.get('USER')
                sourceFile = csvFileName
                remoteFile = csvFileName

                # Copy the file to the SFTP site or any desired directory.
                # dfw-prd-mas-01:/clearing/filemgr/JOURNALS/MONTHEND/JP_FL
                if not self.__UploadFile(remoteHost, remoteUser, sourceFile, \
                                    verbosityLevel, basePath, remoteFile, \
                                    remoteDirectory, uploadFlag):
                    self.__lineNum = self.__GetLineNo() - 3
                    errorMessage = \
                            'Unable to upload file %s to Remote Server: %s ' \
                            %(remoteFile, remoteHost)

                    self.__formatBuffer = None
                    self.__formatBuffer = ( \
                        'Error in {0} module __CreateCsvFile() method at '
                        'Line #: {1}: {2}')
                    print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                    errorMessage), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                    if runMode == 'PROD':
                        emailSubject = \
                            'Failed to upload the Florida Cogs Report'
                    else:
                        emailSubject = \
                            'IGNORE: Testing - Failed to upload the Florida ' \
                            'COGS Report'

                    emailBody = 'Unable to upload the %s file to the %s ' \
                                'remote server' % (csvFileName, remoteHost)

                    if not self.__GenerateEmail( \
                                READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                CONFIG_SECTION_NAME='FLORIDA_COGS_ALERTS', \
                                EMAIL_SUBJECT=emailSubject, \
                                EMAIL_BODY=emailBody):
                        print('            Unable to generate Email Alert.\n')
                        return False

                    # Log to the log file
                    if not self.__loggerObj.LogMessage( \
                            self.__FormatMessage( \
                                self.__formatBuffer.format( \
                                    __file__, self.__lineNum, \
                                    errorMessage), \
                                width=80, initial_indent='\n            ', \
                                subsequent_indent=' ' * 12, \
                                break_long_words=False, \
                                break_on_hyphens=False), 'ERROR'):
                        return False

                if not os.path.exists(archivePath):
                    os.makedirs(archivePath)

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
            # passing the required verbosity level to the ResetLoggingLevel()
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

            # Set up log handlers. This function must be called fourth.
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
                'Line #: {1}: {2}')
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


    #--------------------      __FormatReportDates()      ---------------------

    def __FormatReportDates(self, reportBeginDate, reportEndDate, runMode, \
                            verbosityLevel):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __FormatReportDates():
                Formats the report begin and end dates to be in 'dd-mon-yy'
                format.
            Parameters:
                reportBeginDate - Report begin date - YYYYMMDD format.
                reportEndDate   - Report end date - YYYYMMDD format.
                runMode         - Report run mode PROD/TEST
                verbosityLevel  - Verbosity level

            Returns:
                Formatted (dd-mon-yy) report begin, end, and query end dates.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            queryEndDate = None         # Initialize

            self.__lineNum = self.__GetLineNo() + 1
            dateObject = datetime(int(reportEndDate[0:4]), \
                                int(reportEndDate[4:6]), \
                                int(reportEndDate[6:8]))

            # Note: Begin date is not required, but if both begin and end dates
            # are given, then the report is run for that date range. Otherwise,
            # if only report end date is given, assume that you are running the
            # report for the previous month.

            if reportBeginDate:
                self.__lineNum = self.__GetLineNo() + 2
                # Validate the date to be YYYYMMDD format
                datetime.strptime(reportBeginDate, '%Y%m%d')

                self.__lineNum = self.__GetLineNo() + 2
                # Format date to dd-mon-yy format
                reportBeginDate = \
                        datetime.strptime(reportBeginDate, '%Y%m%d')\
                                .strftime('%d-%b-%y')

                # Now format the report end date
                self.__lineNum = self.__GetLineNo() + 2
                # Validate the date to be YYYYMMDD format
                datetime.strptime(reportEndDate, '%Y%m%d')
                self.__lineNum = self.__GetLineNo() + 2
                # Format date to dd-mon-yy format
                reportEndDate = \
                        datetime.strptime(reportEndDate, '%Y%m%d')\
                                .strftime('%d-%b-%y')

                # Now format the query end date by adding 1 more day
                self.__lineNum = self.__GetLineNo() + 1
                lastDayNumber = dateObject.day
                self.__lineNum = self.__GetLineNo() + 1
                lastDate = dateObject.replace(day=lastDayNumber)
                self.__lineNum = self.__GetLineNo() + 1
                lastDate = lastDate + timedelta(days=1)
                self.__lineNum = self.__GetLineNo() + 1
                queryEndDate = \
                    datetime.strptime(str(lastDate.date()), \
                                        '%Y-%m-%d').strftime('%d-%b-%y')
            else:
                self.__lineNum = self.__GetLineNo() + 1
                currentMonth = dateObject.month
                self.__lineNum = self.__GetLineNo() + 1
                currentYear = dateObject.year
                self.__lineNum = self.__GetLineNo() + 1
                firstDayCurrentMonth = dateObject.replace(day=1)
                self.__lineNum = self.__GetLineNo() + 1
                lastDayPrevMonth = firstDayCurrentMonth - timedelta(days=1)
                self.__lineNum = self.__GetLineNo() + 1
                queryEndDate = \
                    datetime.strptime(str(firstDayCurrentMonth.date()), \
                                            '%Y-%m-%d').strftime('%d-%b-%y')

                if currentMonth > 1:
                    # Current month is Feb - December
                    previousMonth = currentMonth - 1
                    self.__lineNum = self.__GetLineNo() + 1
                    firstDayPrevMonth = \
                            dateObject.replace(month=currentMonth-1, day=1)
                else:
                    # Current month is January, so get the previous month
                    # and year.
                    previousMonth = 12
                    previousYear = currentYear - 1
                    self.__lineNum = self.__GetLineNo() + 1
                    firstDayPrevMonth = dateObject.replace( \
                                year=previousYear, month=previousMonth, day=1)

                self.__lineNum = self.__GetLineNo() + 2
                # Now format the begin and end dates
                reportBeginDate = \
                    datetime.strptime( \
                    str(firstDayPrevMonth.date()), '%Y-%m-%d').strftime( \
                                                                '%d-%b-%y')
                self.__lineNum = self.__GetLineNo() + 1
                reportEndDate = \
                    datetime.strptime(str(lastDayPrevMonth.date()), \
                                        '%Y-%m-%d').strftime('%d-%b-%y')

        except ValueError as valueException:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                    'Error in Module: {0} __FormatReportDates() method at '
                    'Line #: {1}: {2}{3}')

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
                    'An exception occurred generating Florida COGS report ' \
                    'for %s to %s' % (reportBeginDate, reportEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating ' \
                    'Florida COGS report for %s to %s' \
                    % (reportBeginDate, reportEndDate))

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
                            CONFIG_SECTION_NAME='FLORIDA_COGS_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
            # Don't want to proceed, so exit the program.
            sys.exit()
        else:
            return reportBeginDate, reportEndDate, queryEndDate


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
            reportDescription = ( \
                'This script creates a CSV file containing the data for the ' \
                '%s' % 'Florida COGS Report and emails the report to an ' \
                        'email group.')

            argParser = argparse.ArgumentParser(description=reportDescription)

            # argParser.add_argument('-v', '--verbose', metavar=int, nargs='+',
            #                         help='Increase output verbosity.',
            #                         required=False)

            # argParser.add_argument('-v', '--verbose', type=int,
            #               help = 'Increase output verbosity.',
            #               required=False, action='count', default=0)

            # argParser.add_argument('-v', '--verbose', action="count",
            #               help="verbose level... repeat up to five times.")

            # Add usage argument to argparse. Make it not required and let the
            # program handle the required arguments.

            argParser.add_argument( \
                '-u', '-U', '--usage', help='Show how to invoke the script.', \
                # required=False, default=False)
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

            # Add the end date argument to argparse. Make it not required and
            # let the program handle the required arguments.
            argParser.add_argument( \
                    '-d', '-D', '--enddate', type=str, \
                    help='Report end date YYYYMMDD format.', required=False)

            # Add the institution argument to argparse.
            argParser.add_argument( \
                    '-i', '-I', '--inst', type=str, \
                    help='Institution ID.', required=False)

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
            reportBeginDate = argsList.begindate
            reportEndDate = argsList.enddate
            institutionId = argsList.inst
            logType = argsList.logtype
            runMode = argsList.test

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
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    '__GetArgs() at Line #: {1}. showUsage = {2}  ' \
                    'verbosityLevel = {3}  reportBeginDate = {4} ' \
                    'reportEndDate = {5} Institution = {6} Run Mode = {7}')

                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                                showUsage, \
                                                str(verbosityLevel), \
                                                str(reportBeginDate), \
                                                str(reportEndDate), \
                                                str(institutionId), \
                                                str(runMode)), \
                    width=80, initial_indent='\n        ', \
                    subsequent_indent=' ' * 8, break_long_words=False, \
                    break_on_hyphens=False), '\n')

        except argparse.ArgumentError as exceptError:
            self.__lineNum = self.__GetLineNo() - 1
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
            return showUsage, verbosityLevel, logType, reportBeginDate, \
                    reportEndDate, institutionId, runMode


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
            showUsage, verbosityLevel, logType, reportBeginDate, \
                    reportEndDate, institutionId, runMode = self.__GetArgs()

            # Check if you want to print the usage
            if showUsage:
                self.__PrintUsage()
                sys.exit()

            # Set the email configurations based on the runMode
            if runMode == 'PROD':
                self.__emailConfigFile = \
                        '%s/email_config.ini' % os.environ.get('MASCLRLIB_PATH')
            else:
                self.__emailConfigFile = '{0}/test_email_config.ini'.format(os.getcwd())

            # Call function to create the logging object and initialize the
            # parameters as necessary.
            if not self.__CreateLogger(verbosityLevel, logType):
                return

            # Report end date is required
            if not reportEndDate:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                        'Missing report end date. The end date is required ' \
                        'to run this report.')

            # Call a function to set the report begin and end date to
            # dd-mon-yy form.
            reportBeginDate, reportEndDate, queryEndDate = \
                    self.__FormatReportDates(reportBeginDate, \
                                                reportEndDate, runMode, \
                                                verbosityLevel)

            # Make sure the end date (YYYMMDD) is higher than the begin date.
            # Note: Logger object is created, so error can be logged to the
            # log file.
            if reportBeginDate > reportEndDate:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                        'The report begin date must be prior to the end date.')

            # Institution ID is required
            if not institutionId:
                self.__lineNum = self.__GetLineNo() - 1
                raise LocalException( \
                        'Missing institution ID. The ID is required to run '\
                        'this report.')

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
                                                    reportBeginDate, \
                                                    reportEndDate, ''), \
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
                                    reportBeginDate, \
                                    reportEndDate, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'BODY'):
                    return

        except LocalException as exceptError:
            self.__formatBuffer = None
            self.__formatBuffer = ( \
                    'Error in Module: {0} GenerateReport() method at '
                    'Line #: {1}: {2}{3}')

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

            # Send an email alert
            if runMode == 'PROD':
                emailSubject = ( \
                    'An exception occurred generating Florida COGS report ' \
                    'for %s to %s' % (reportBeginDate, reportEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating ' \
                    'Florida COGS report for %s to %s' \
                    % (reportBeginDate, reportEndDate))

            emailBody = self.__formatBuffer.format( \
                            __file__, self.__lineNum, '', \
                            str(exceptError), '')

            # If called with -v Debug flag or test mode print the email config
            # file path
            if verbosityLevel == 1 or runMode == 'TEST':
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                        'Print message generated in Module: {0} Method: ' \
                        'GenerateReport() at Line #: {1}. Email config ' \
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
                            CONFIG_SECTION_NAME='FLORIDA_COGS_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
        else:
            # Call function to create the csv file
            if not self.__CreateCsvFile(reportBeginDate, reportEndDate, \
                        queryEndDate, institutionId, verbosityLevel, runMode):
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

            outputFile = 'Florida_cogs_report_%s_to_%s.csv' \
                                    % (reportBeginDate, reportEndDate)
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
    floridaCogsRepObj = FloridaCogsClass()
    floridaCogsRepObj.GenerateReport()
