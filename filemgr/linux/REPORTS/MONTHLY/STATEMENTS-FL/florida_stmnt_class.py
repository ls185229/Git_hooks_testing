#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to create and email/SCP the Florida Fee Summary statement
reports.
    $Id: florida_stmnt_class.py 4622 2018-06-20 18:40:11Z lmendis $
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
import gzip

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
# pylint: disable = line-too-long


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
            May 01, 2018

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


class FloridaStatementsClass(object):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for creating and mailing the Florida Statement
            reports.

        Author:
            Leonard Mendis

        Date Created:
            May 01, 2018

        Modified By:

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes
    __loggerObj = None
    __lineNum = 0
    __emailConfigFile = None
    __formatBuffer = None
    __reportType = None
    __reportName = None
    __sqlText = None
    __zipFileName = None
    __FEE_SUM_SQL = \
        """
            SELECT
                mtl.institution_id                              AS Inst,
                substr(mtl.entity_id, 8, 4) agent,
                entity_id entity_id,
                mtl.posting_entity_id                   AS statement_id,
                /*
                --:start_dt strt_dt,
                --:end_dt   end_dt,
                */
                TO_CHAR({0}, 'YYYYMMDD')  strt_dt,
                TO_CHAR({1}, 'YYYYMMDD')   end_dt,
                CASE WHEN substr(mtl.tid, 1, 8) IN ('01000402', '01000472')
                     THEN 'I' ELSE 'O' END                      AS "Fee_Type",
                mtl.card_scheme                                 AS card_scheme,
                sum(mtl.principal_amt)                          AS principal_amt,
                SUM(mtl.nbr_of_items)                           AS num_items,
                mtl.per_item_rate                               AS per_item_rate,
                mtl.percent_rate                                AS percent_rate,
                SUM(mtl.amt_billing *
                    CASE WHEN mtl.tid_settl_method = 'D'
                         THEN 1 ELSE -1 END)                    AS fee_amount,
                mtl.tid                                         AS tid ,
                mtl.mas_code                                    AS mas_code,
                CASE
                    WHEN mtl.tid LIKE '01000472%' THEN
                        mc.mas_desc || ' - ' || t.description
                    ELSE
                        mc.mas_desc
                END                                             AS mas_desc
            FROM mas_trans_log mtl
                JOIN tid t
                ON t.tid = mtl.tid
                JOIN mas_code mc
                ON mc.mas_code = mtl.mas_code
            WHERE mtl.settl_flag        = 'Y'
                AND mtl.tid LIKE '010004%'
                AND mtl.amt_billing != 0
                AND institution_id = '107'
                --AND gl_date        BETWEEN TO_DATE(:start_dt, 'YYYYMMDD')
                --                       AND TO_DATE(:end_dt  , 'YYYYMMDD')
                AND gl_date BETWEEN {0}
                            AND     {1}
                --AND entity_id         LIKE '454045_1102%'
                --AND posting_entity_id like '454045_1102%'
                AND regexp_like(entity_id        , '^454045.110[24]')
                AND regexp_like(posting_entity_id, '^454045.110[24]')
            GROUP BY
                mtl.institution_id,
                substr(mtl.entity_id, 8, 4) ,
                mtl.entity_id ,
                mtl.posting_entity_id,
                CASE WHEN substr(mtl.tid, 1, 8) IN ('01000402', '01000472')
                     THEN 'I' ELSE 'O' END,
                mtl.card_scheme,
                mtl.tid,
                mtl.mas_code,
                CASE
                    WHEN mtl.tid LIKE '01000472%' THEN
                        mc.mas_desc || ' - ' || t.description
                    ELSE
                        mc.mas_desc
                END,
                mtl.per_item_rate,
                mtl.percent_rate
            HAVING SUM(mtl.amt_billing *
                    CASE WHEN mtl.tid_settl_method = 'D'
                         THEN 1 ELSE -1 END)  != 0
            ORDER BY mtl.posting_entity_id, mtl.card_scheme, mas_desc
        """
    __CARD_SUM_SQL = \
        """
            SELECT
                institution_id Inst,
                substr(mtl.entity_id, 8, 4) agent,
                entity_id entity_id,
                posting_entity_id statement_id,
                to_char({0}, 'YYYYMMDD')  strt_dt,
                to_char({1}, 'YYYYMMDD')   end_dt,
                card_scheme,
                CASE
                    WHEN TID IN (
                        '010003005101', '010003005103', '010003005104', '010003005105',
                        '010003005106', '010003005107', '010003005109', '010003005121',
                        '010003005141', '010003005142', '010003005202', '010008000001',
                        '010008000102', '010103005101', '010103005103', '010103005104',
                        '010103005105', '010103005106', '010103005107', '010103005109',
                        '010103005202'  )                                               THEN '1_SALES'
                    WHEN TID IN (
                        '010003005102', '010003005108', '010003005143', '010003005144',
                        '010003005201', '010003005202', '010003005203', '010003005204',
                        '010003005205', '010003005207', '010003005208', '010003005209',
                        '010003005221', '010008000002', '010008000101', '010103005102',
                        '010103005108', '010123005101', '010123005102', '010123005103',
                        '010123005104', '010123005105', '010123005106', '010123005107',
                        '010123005108', '010123005109', '010123005121')                 THEN '2_RETURNS'
                    WHEN TID IN (
                        '010003005301', '010003005401', '010003005402', '010003010101',
                        '010003010102', '010003015101', '010003015102', '010003015106',
                        '010003015201', '010003015202', '010003015210', '010003015301',
                        '010008010001', '010008010101', '010008010101')                 THEN '3_DISPUTES'
                    WHEN TID LIKE '01000428%'                                           THEN '4_ACH_FEES'
                    WHEN TID LIKE '010004%'                                             THEN '4_FEES'
                    WHEN tid LIKE '01000705%'                                           THEN '5_RESERVES_CR'
                    WHEN tid LIKE '01000505%'                                           THEN '5_RESERVES_DB'
                    WHEN tid LIKE '01000709%'                                           THEN '6_SPLIT_FUND_CR'
                    WHEN tid LIKE '01000509%'                                           THEN '6_SPLIT_FUND_DB'
                                                                                        ELSE '9_OTHER-' || tid
                END tran_type,
                    SUM(nbr_of_items) cnt,
                    -- SUM(amt_original * DECODE(tid_settl_method, 'C', 1, -1)) orig,
                    SUM(amt_billing  * DECODE(tid_settl_method, 'C', 1, -1)) bill
                    --,
                    --MIN(gl_date)        min_gl , max(gl_date)        max_gl ,
                    --MIN(date_to_settle) min_stl, max(date_to_settle) max_stl
            FROM mas_trans_log mtl
            WHERE   ( (tid NOT LIKE '01000705%' AND
                                institution_id = '107'
                            AND
                                gl_date        BETWEEN {0}
                                               AND     {1}
                             --AND entity_id like '454045_1102%'
                             AND regexp_like(entity_id, '^454045.110[24]')
                             ) OR
                      (tid     LIKE '01000705%' AND
                                institution_id = '107'
                            AND
                                date_to_settle BETWEEN {0}
                                               AND     {1}
                             --AND entity_id LIKE '454045_1102%'
                             AND regexp_like(entity_id, '^454045.110[24]')
                             ) )
                    AND settl_flag = 'Y'
                    AND amt_billing != 0
                    AND tid not LIKE '01000509%'
                    AND tid not LIKE '01000709%'
            GROUP  BY
                institution_id,
                entity_id,
                posting_entity_id,
                CASE
                    WHEN TID IN (
                        '010003005101', '010003005103', '010003005104', '010003005105',
                        '010003005106', '010003005107', '010003005109', '010003005121',
                        '010003005141', '010003005142', '010003005202', '010008000001',
                        '010008000102', '010103005101', '010103005103', '010103005104',
                        '010103005105', '010103005106', '010103005107', '010103005109',
                        '010103005202'  )                                               THEN '1_SALES'
                    WHEN TID IN (
                        '010003005102', '010003005108', '010003005143', '010003005144',
                        '010003005201', '010003005202', '010003005203', '010003005204',
                        '010003005205', '010003005207', '010003005208', '010003005209',
                        '010003005221', '010008000002', '010008000101', '010103005102',
                        '010103005108', '010123005101', '010123005102', '010123005103',
                        '010123005104', '010123005105', '010123005106', '010123005107',
                        '010123005108', '010123005109', '010123005121')                 THEN '2_RETURNS'
                    WHEN TID IN (
                        '010003005301', '010003005401', '010003005402', '010003010101',
                        '010003010102', '010003015101', '010003015102', '010003015106',
                        '010003015201', '010003015202', '010003015210', '010003015301',
                        '010008010001', '010008010101', '010008010101')                 THEN '3_DISPUTES'
                    WHEN TID LIKE '01000428%'                                           THEN '4_ACH_FEES'
                    WHEN TID LIKE '010004%'                                             THEN '4_FEES'
                    WHEN tid LIKE '01000705%'                                           THEN '5_RESERVES_CR'
                    WHEN tid LIKE '01000505%'                                           THEN '5_RESERVES_DB'
                    WHEN tid LIKE '01000709%'                                           THEN '6_SPLIT_FUND_CR'
                    WHEN tid LIKE '01000509%'                                           THEN '6_SPLIT_FUND_DB'
                                                                                        ELSE '9_OTHER-' || tid
                END,
                card_scheme
            ORDER BY entity_id, tran_type
        """

    __firstDayPrevMonth = \
            "LAST_DAY(ADD_MONTHS(TO_DATE('{0}', 'YYYYMMDD'), - 2)) + 1"
    __lastDayPrevMonth = \
            "LAST_DAY(ADD_MONTHS(TO_DATE('{0}', 'YYYYMMDD'), - 1))"


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
                remoteDirectory - Directory at the remote location.
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
        # print('remoteDestination = ', remoteDestination)

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
            print('rsyncCommand: {0}'.format(rsyncCommand))
            # procRetValue = \
                # subprocess.Popen(rsyncCommand, shell=True, \
                                    # stdout=subprocess.PIPE, \
                                    # stderr=subprocess.STDOUT).wait()
        else:
            # Create the scp command to copy the files
            scpCommand = 'scp %s %s' % (localFileWithPath, remoteDestination)

            print('scpCommand: {0}'.format(scpCommand))
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
                Initializes the Florida Statements class object.

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
            '            [-d or -D or --date <YYYYMMDD Report Run Date> ' \
            '(Optional)]\n' \
            '            [-r or -R or --reporttype <Report Type - FEE/CARD> '\
            '(Required)]\n' \
            '            [-v or -V or --verbose <Verbose Level>]\n' \
            '            [-m or -M or --mode <TEST/PROD> (Optional)]\n' \
            '            [-l or -L or --logtype <LOGFILE/CONSOLE/BOTH> ' \
            '(Optional)]\n\n            %s\n                %s\n' \
            '                %s\n                %s\n                ' \
            '%s\n                %s\n') \
            % (__file__, 'Verbose Levels:', '-v     - Debug', '-vv    ' \
                '- Info', '-vvv   - Warning', '-vvvv  - Error', \
                '-vvvvv - Critical'))


    #----------------------      __CreateCsvFile()      -----------------------

    def __CreateCsvFile(self, reportBeginDate, reportEndDate, verbosityLevel, \
                        runMode):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CreateCsvFile():
                This function takes the begin and end dates for the report
                and uses them to run an SQL statement to fetch the results.
                Then it creates a CSV file for distribution.

            Parameters:
                reportBeginDate - Report Begin Date dd-mon-yy format.
                reportEndDate   - Report End Date dd-mon-yy format.
                verbosityLevel  - Verbosity level
                                    - DEBUG/INFO/WARNING/ERROR/CRITICAL
                runMode         - Option to run as test.

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
                    '__CreateCsvFile() at Line #: {1}. Report Begin ' \
                    'Date: {2} Report End Date: {3} Mode: {4}{5}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                reportBeginDate, reportEndDate, runMode, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')
                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                            reportBeginDate, reportEndDate, runMode, '\n'), \
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
            dbObject = DbClass(ENV_HOSTNM='CLR2_HOST', \
                                ENV_USERID='CLR2_DB_USERNAME', \
                                PORTNO='1521', \
                                ENV_PASSWD='CLR2_DB_PASSWORD', \
                                ENV_SERVNM='CLR2_SERVERNAME')

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

            if self.__reportType == 'FEE':
                self.__sqlText = \
                    self.__FEE_SUM_SQL.format( \
                            self.__firstDayPrevMonth, self.__lastDayPrevMonth)
            elif self.__reportType == 'CARD':
                self.__sqlText = \
                    self.__CARD_SUM_SQL.format( \
                            self.__firstDayPrevMonth, self.__lastDayPrevMonth)

            # Print the sql text to the log file
            if not self.__loggerObj.LogMessage(self.__sqlText, 'BODY'):
                pass

            if self.__reportType == 'FEE':
                csvFileName = 'jp_fl_fee_summary_%s.csv' % reportEndDate
            else:
                csvFileName = 'jp_fl_card_type_summary_%s.csv' % reportEndDate

            # Note that the positional parameters 1 - 6 must have values.
            # The rest rest are keyword arguments. It is recommended to make
            # the positional arguments as named for clarity but it is not
            # necessary as long as they hold values.
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
                    'An Error occurred generating %s report for %s to %s' % \
                    (self.__reportName, reportBeginDate, reportEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An Error occurred generating ' \
                    '%s report for %s to %s' % \
                    (self.__reportName, reportBeginDate, reportEndDate))

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
                                CONFIG_SECTION_NAME='FLORIDA_STMNTS_ALERTS', \
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
                    'An Error occurred generating %s report for %s to %s' % \
                    (self.__reportName, reportBeginDate, reportEndDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An Error occurred generating ' \
                    '%s report for %s to %s' % \
                    (self.__reportName, reportBeginDate, reportEndDate))

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
                                CONFIG_SECTION_NAME='FLORIDA_STMNTS_ALERTS', \
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

                # Zip the file and send as an email attachment
                self.__zipFileName = '%s.gz' % csvFileName
                with open(csvFileName, 'rb') as fileIn:
                    with gzip.open(self.__zipFileName, 'wb') as fileOut:
                        shutil.copyfileobj(fileIn, fileOut)

                outputFileList = [self.__zipFileName]

                if runMode == 'PROD':
                    emailSubject = ('%s Report for %s to %s' \
                                    % (self.__reportName, reportBeginDate, \
                                        reportEndDate))
                else:
                    emailSubject = ( \
                        'IGNORE: Testing - %s Report for %s to %s' \
                        % (self.__reportName, reportBeginDate, reportEndDate))

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

                emailBody = \
                    'Successfully created the %s file.' % self.__zipFileName
                if not self.__GenerateEmail( \
                            READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                            CONFIG_SECTION_NAME='FLORIDA_STMNTS_REPORTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody, \
                            ATTACH_FILES_LIST=outputFileList, \
                            ATTACH_FILES_FOLDER=\
                                os.path.dirname(os.path.abspath(__file__))):
                    print('            ' \
                        'Unable to generate the Florida Statement report ' \
                        'Email.\n')
                    return False

                # Archive the file
                basePath = os.path.dirname(os.path.abspath(__file__))
                archivePath = os.path.join(basePath, 'ARCHIVE')
                sourceFilePath = os.path.join(basePath, self.__zipFileName)
                destFilePath = os.path.join(archivePath, self.__zipFileName)
                # If the run mode is TEST, then do not put it on the SFTP site
                if runMode != 'PROD':
                    remoteHost = os.environ.get('MAS_HOST_NAME')
                    remoteDirectory = \
                            '/clearing/filemgr/JOURNALS/MONTHEND/JP_FL'
                    # 'SCP' for remote copy or 'RSYNC' to use rsync command
                    uploadFlag = 'RSYNC'
                else:
                    remoteHost = os.environ.get('SFTP_HOST')
                    remoteDirectory = '/secure/collectorsolutions/statements'
                    # 'SCP' for remote copy or 'RSYNC' to use rsync command
                    uploadFlag = 'SCP'
                remoteUser = os.environ.get('USER')
                sourceFile = self.__zipFileName
                remoteFile = self.__zipFileName

                # Copy the file to the SFTP site or any desired directory.
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
                            'Failed to upload the Florida Statement Report'
                    else:
                        emailSubject = \
                            'IGNORE: Testing - Failed to upload the Florida ' \
                            'Statement Report'

                    emailBody = 'Unable to upload the %s file to the %s ' \
                                'remote server' \
                                % (self.__zipFileName, remoteHost)

                    if not self.__GenerateEmail( \
                                READ_FROM_CONFIG_FILE=self.__emailConfigFile, \
                                CONFIG_SECTION_NAME='FLORIDA_STMNTS_ALERTS', \
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

                # Now remove the unzipped csv file
                if os.path.isfile(csvFileName):
                    os.remove(csvFileName)

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

    def __FormatReportDates(self, reportRunDate, runMode, verbosityLevel):

        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __FormatReportDates():
                If report run date is passed to the program, verifies the date
                is YYYYMMDD format. Else defaults it to the system date. Then,
                takes the report run date and formats the report begin and end
                dates in MM-DD-YYYY format.
            Parameters:
                reportRunDate  - Report run date
                runMode        - Report run mode PROD/TEST
                verbosityLevel - Verbosity Level
            Returns:
                Formatted (YYYYMMDD) report run date and the formatted
                (MM-DD-YYYY) report begin and end dates.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            reportBeginDate = None
            reportEndDate = None

            # Note: Report run date is not required, but if the run date is
            # not given, assume that you are running the report for the
            # previous month from the system date.
            if not reportRunDate:
                self.__lineNum = self.__GetLineNo() + 1
                reportRunDate = datetime.now().strftime("%Y%m%d")
            else:       # Validate the date is YYYYMMDD form
                self.__lineNum = self.__GetLineNo() + 1
                datetime.strptime(reportRunDate, '%Y%m%d')

            # Get the report begin and end dates based on report run date
            self.__lineNum = self.__GetLineNo() + 1
            currentMonthFirstDate = \
                    datetime(year=int(reportRunDate[0:4]), \
                                month=int(reportRunDate[4:6]), day=1)

            self.__lineNum = self.__GetLineNo() + 1
            previousMonthEndDate = \
                        currentMonthFirstDate - timedelta(days=1)

            self.__lineNum = self.__GetLineNo() + 1
            reportEndDate = previousMonthEndDate.strftime('%Y%m%d')

            self.__lineNum = self.__GetLineNo() + 1
            previousMonthStartDate = \
                    datetime(day=1, month=previousMonthEndDate.month, \
                                    year=previousMonthEndDate.year)

            self.__lineNum = self.__GetLineNo() + 1
            reportBeginDate = previousMonthStartDate.strftime('%Y%m%d')

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
                    'An exception occurred generating %s for statement ' \
                    'run date: %s.' % (self.__reportName, reportRunDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating %s' \
                    % self.__reportName)

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
                            CONFIG_SECTION_NAME='FLORIDA_STMNTS_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
            # Don't want to proceed, so exit the program.
            sys.exit()
        else:
            self.__firstDayPrevMonth = \
                    self.__firstDayPrevMonth.format(reportRunDate)
            self.__lastDayPrevMonth = \
                    self.__lastDayPrevMonth.format(reportRunDate)
            # print('reportRunDate: ', reportRunDate, 'reportBeginDate: ', \
            #         reportBeginDate, 'reportEndDate: ', reportEndDate)

            return reportRunDate, reportBeginDate, reportEndDate


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
                dd-mon-yy format, verbosity level, logging type, and usage
                True/False flag.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Assign description to the help doc
            reportDescription = ( \
                'This script creates a CSV file containing the data for the ' \
                '%s' % 'Florida Statement Reports and emails the report ' \
                'to an email group and/or SFTP the file to a server.')

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

            # Add the report run date argument to argparse. Make it not
            # required.
            argParser.add_argument( \
                    '-d', '-D', '--date', type=str, \
                    help='Report run date YYYYMMDD format.', required=False)

            # Add the report run date argument to argparse. Make it not
            # required and let the program handle the required arguments.
            argParser.add_argument( \
                    '-r', '-R', '--reporttype', type=str, \
                    help='Report type FEE/CARD', required=False)

            # Add the test mode (optional) argument to argparse. Make it not
            # required.
            argParser.add_argument( \
                    '-m', '-M', '--mode', type=str, default='PROD', \
                    help='Run mode indicator (Optional).', required=False)

            # Extract all arguments passed to script into a list
            argsList = argParser.parse_args()

            # Assign args to variable(s)
            verbosityLevel = argsList.verbose
            showUsage = argsList.usage
            reportRunDate = argsList.date

            logType = argsList.logtype
            self.__reportType = argsList.reporttype
            runMode = argsList.mode

            if self.__reportType:
                self.__reportType = self.__reportType.upper()

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
                    'verbosityLevel = {3}  reportRunDate = {4} ' \
                    'Run Mode = {5}')

                print(self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                                showUsage, \
                                                str(verbosityLevel), \
                                                str(reportRunDate), \
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
            return showUsage, verbosityLevel, logType, reportRunDate, runMode


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
            # Initialize report date attributes
            reportRunDate = None
            reportBeginDate = None
            reportEndDate = None

            # Get the arguments passed to the program. Note that the
            # verbosityLevel is the number of -v options that the program is
            # called with. For example -v is 1 and -vv is 2 and -vvv is 3 so
            # on and so forth.
            showUsage, verbosityLevel, logType, reportRunDate, \
                    runMode = self.__GetArgs()

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

            # Validate Report type (FEE/CARD) is required
            if not self.__reportType:
                self.__lineNum = self.__GetLineNo() - 1
                self.__reportName = 'Florida Fee/CARD Summary Statement'
                raise LocalException( \
                        'Missing report type. The type must be FEE or CARD ' \
                        'type and is required to run this report.')

            # Call a function to set the report run date to YYYYMMDD form and
            # the report begin and end dates in MM-DD-YYYY format.
            reportRunDate, reportBeginDate, reportEndDate = \
                self.__FormatReportDates(reportRunDate, runMode, verbosityLevel)

            outputFile = None   # Initialize output file name

            if self.__reportType == 'FEE':
                self.__reportName = 'Florida Fee Summary Statement'
                outputFile = ('FL_Fee_Summary_Statement_%s_to_%s.csv' \
                                % (reportBeginDate, reportEndDate))
            else:
                self.__reportName = 'Florida Card Type Summary Statement'
                outputFile = ('FL_Card_Type_Summary_Statement_%s_to_%s.csv' \
                                % (reportBeginDate, reportEndDate))

            if verbosityLevel == 1:             # Called with -v Debug flag
                self.__lineNum = self.__GetLineNo() - 1
                self.__formatBuffer = None
                self.__formatBuffer = ( \
                    'Print message generated in Module: {0} Method: ' \
                    'GenerateReport() at Line #: {1}. Report Run Date: {2}{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
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
                    'An exception occurred generating %s for date: %s.' \
                    % (self.__reportName, reportRunDate))
            else:
                emailSubject = ( \
                    'IGNORE: Testing - An exception occurred generating %s ' \
                    'for date: %s.' % (self.__reportName, reportRunDate))

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
                            CONFIG_SECTION_NAME='FLORIDA_STMNTS_ALERTS', \
                            EMAIL_SUBJECT=emailSubject, \
                            EMAIL_BODY=emailBody):
                sys.exit()
        else:
            # Call function to create the csv file
            if not self.__CreateCsvFile(reportBeginDate, reportEndDate, \
                                        verbosityLevel, runMode):
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
                    'the {2} csv file.{3}')

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, self.__lineNum, \
                                                    self.__reportName, ''), \
                        width=80, initial_indent='\n        ', \
                        subsequent_indent=' ' * 8, \
                        break_long_words=False, \
                        break_on_hyphens=False), '\n')

                # Log to the log file
                self.__lineNum = self.__GetLineNo() + 1
                if not self.__loggerObj.LogMessage( \
                        self.__FormatMessage( \
                            self.__formatBuffer.format(__file__, \
                                    self.__lineNum, self.__reportName, '\n'), \
                            width=80, initial_indent='\n            ', \
                            subsequent_indent=' ' * 12, \
                            break_long_words=False, \
                            break_on_hyphens=False), 'ERROR'):
                    return
                return

            if not self.__loggerObj.LogMessage( \
                'End Execution: %s %s\n           %s%s %s' \
                % (__file__, (datetime.now().strftime('%Y/%m/%d %H:%M:%S')), \
                    'Successfully created ', self.__zipFileName, 'file.'), \
                    'END'):
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
    floridaStmntsRepObj = FloridaStatementsClass()
    floridaStmntsRepObj.GenerateReport()
