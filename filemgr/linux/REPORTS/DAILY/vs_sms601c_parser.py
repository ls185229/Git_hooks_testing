#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A python script to parse a text file and extract field values from the Visa SMS601C report
"""


import os
import configparser

import logging
import inspect
import argparse
import csv
import sys
import glob
import shutil
import textwrap
from datetime import datetime
from datetime import timedelta
# from collections import defaultdict
from collections import OrderedDict

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
        '            [-f or -F or --file <File to parse> ' \
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
            Prints the SMS601C parser input and associated redirect output log files
            older than 3 months from the archive directory.

        Parameters:
            None

        Returns:
            None
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    filePatternList = ['ARCHIVE/INVS.PDCTF01.????.???.????????.out.asc', \
                       'ARCHIVE/vs_sms601C_*.csv']

    basePath = os.path.dirname(os.path.abspath(__file__))

    ninetyDaysAgo = datetime.now() - timedelta(days=90)
    print('ninetyDaysAgo: {0}\n'.format(ninetyDaysAgo))

    print('File pattern looking for: \n     {0}\n'.format(filePatternList))

    for listItem in filePatternList:
        sourceFilePath = os.path.join(basePath, listItem)
        print('sourceFilePath: {0}\n'.format(sourceFilePath))

        for fileName in glob.glob(sourceFilePath):
            fileTime = datetime.fromtimestamp(os.path.getctime(fileName))
            if fileTime < ninetyDaysAgo:
                if os.path.exists(fileName):
                    print('fileTime: {0}\n    File older than 90 days: ' \
                          '{1}\n'.format(fileTime, fileName))
                    # In order to delete the files older than 90 days matching the
                    # above pattern in the ARCHIVE, add the remove function available
                    # in the os library here.


class sms601cParserClass(object):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A class module for parsing the Visa SMS601C text file

        Author:
            Leonard Mendis

        Date Created:
            March 30, 2020

        Modified By:

    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes - General
    __errorMessage = None       # Attribute to hold error messages
    __lineNum = 0
    __formatBuffer = None
    __emailBodyText = None
    __emailSubjectText = None
    __runMode = 'PROD'
    __loggingLevel = 'INFO'       # Initialize it to information logging

    # Private class attributes - Parser
    __loggerObj = None
    __fieldConfigFile = None
    __listConfigDict = []

    # This is the data dictionary for storing data related to single transaction in the
    # report input file.
    __fieldDataDict = { \
            'REPORT_ID' : '', 'REPORT_PAGE_NBR' : '', 'FUNDS_XFR_NBR' : '', \
            'FUNDS_XFR_NAME' : '', 'SETTLE_DATE' : '', 'PROCESSOR_ID' : '', \
            'PROCESSOR_NETWORK_ID' : '', 'PROCESSOR_BIN_ID' : '', \
            'PROCESSOR_MEMBER' : '', 'REPORT_DATE' : '', 'AFFILIATE_ID' : '', \
            'AFFILIATE_NETWORK_ID' : '', 'AFFILIATE_BIN_ID' : '', \
            'AFFILIATE_MEMBER' : '', 'SRE_ID' : '', 'SRE_BIN_ID' : '', \
            'SRE_MEMBER' : '', 'PROCESSING_DATE' : '', 'XMIT_DATE' : '', \
            'PAN' : '', 'RETRV_REF_NBR' : '', 'TRACE_NBR' : '', 'ISSUER_ID' : '', \
            'TRAN_TYPE' : '', 'PROC_CODE' : '', 'AMT_TRANS' : '', 'TRANS_CURR' : '', \
            'AMT_SETTL' : '', 'SETTL_METHOD' : '', 'CARD_ACCEPT_TERMINAL' : '', \
            'CARD_ACCEPT_ID' : '', 'TERMINAL_ID' : '', 'MERCHANT_NAME' : '', \
            'FEE_PROGRAM_IND' : '', 'TRAN_ID' : ''}

    __nestedFieldDataDict = {}
    __sectionTotalsDict = {}

    __debitCount = 0
    __creditCount = 0
    __nonFinCount = 0

    __savedTransAmt = 0.00
    __transTotal = 0.00
    __debitSettlTotal = 00.00
    __creditSettlTotal = 00.00

    __listDataDict = []
    __listSectionTotals = []
    __lookupReportID = 'SMS601C'
    __savedReportID = None
    __savedAffiliateID = None
    __reportDate = None
    __remoteServerName = None
    __filePattern = None

    __logType = 'LOGFILE'    # Logging type - LOGFILE/CONSOLE/BOTH

    # This is how the report header and the data looks like specific to SMS601C Report. Note that there are other types of reports
    # similar to this in the same file. Not shown here are the sub totals per AFFILIATE ID:

    # REPORT ID: SMS601C                                 VISANET INTEGRATED PAYMENT SYSTEM                 PAGE NUMBER         :        1 \
    # FUNDS XFR: 1000609283 ESQ 422214 DAS                   SINGLECONNECT / INTERLINK                     ONLINE SETTLMNT DATE:  18MAR20 \
    # PROCESSOR: 4222140003 422214 DAS SMS                ACQUIRER TRANSACTION DETAIL                      REPORT DATE         :  18MAR20 \
    # AFFILIATE: 4222140003 422214 DAS SMS                    BY CARDHOLDER NUMBER                         REPORT TIME         : 10:19:51 \
    # SRE      : 1000593882 422214 DAS SMS                                                                 VSS PROCESSING DATE :  18MAR20 \
    #                                                                                                                                     \
    # ----------------------------------------------------------------------------------------------------------------------------------- \
    # BAT XMIT(GMT)/LOCL                     RETRIEVAL    TRACE  ISSUER ID/  TRAN PROCSS ENT REAS CN/ RSP  --TRANSACTION--   SETTLEMENT   \
    # NUM DATE  TIME     CARD NUMBER         REF NUMBER   NUMBER TRMNL/NAME  TYPE CODE   MOD CODE STP CD        AMOUNT CUR   AMOUNT (USD) \
    # ----------------------------------------------------------------------------------------------------------------------------------- \
    #                                                                                                                                     \
     # 10 17MAR 14:52:28 40002xxxxxxx7369    007700020247 020247 400022      0200 004000 051      00  00         57.31 USD        57.31CR \
                       # CA ID: 00010002  676731029242000        75/B & E VARIETY STORE      /US  0000                  FPI: 342          \
                                                        # ATC: 00089                                                                      \
                       # TR ID: 300077535483154                                                                                           \

    # This is the list of column headings that directly ties upto the section names in the
    # visa_sms601c_config.cfg file. Note that the program uses the index from this list to
    # go and get the column or field starting and ending positions from the data dictionary
    # containing the config file information.

    __columnList = ['REPORT_ID', 'REPORT_PAGE_NBR', 'FUNDS_XFR_NBR', 'FUNDS_XFR_NAME', \
                    'SETTLE_DATE', 'PROCESSOR_ID', 'PROCESSOR_NETWORK_ID', \
                    'PROCESSOR_BIN_ID', 'PROCESSOR_MEMBER', 'REPORT_DATE', 'AFFILIATE_ID', \
                    'AFFILIATE_NETWORK_ID', 'AFFILIATE_BIN_ID', 'AFFILIATE_MEMBER', \
                    'SRE_ID', 'SRE_BIN_ID', 'SRE_MEMBER', 'PROCESSING_DATE', \
                    'XMIT_DATE', 'PAN', 'RETRV_REF_NBR', 'TRACE_NBR', 'ISSUER_ID', \
                    'TRAN_TYPE', 'PROC_CODE', 'AMT_TRANS', 'TRANS_CURR', 'AMT_SETTL', \
                    'SETTL_METHOD', 'CARD_ACCEPT_TERMINAL', 'CARD_ACCEPT_ID', 'TERMINAL_ID', \
                    'MERCHANT_NAME', 'FEE_PROGRAM_IND', 'TRAN_ID']

    # IMPORTANT NOTE:
    #     These are the list of keywords to look up when parsing the data. This word list
    #     has a one-to-one relationship to the  __columnList above in order to find the
    #     index to the positional data (start and end columns). For data under specific
    #     columns, use the column list names from above. For data related to a field
    #     name on a row use the field description to get the index to the positional
    #     data. Note that an input data line from the report may not have any field
    #     idetifiers to associate the data to. Also note that some row data may not be
    #     associated with any particular report column.

    __lookupWordList = [' REPORT ID:', 'PAGE NUMBER         :', ' FUNDS XFR:', \
                        'FUNDS_XFR_NAME', 'ONLINE SETTLMNT DATE:', ' PROCESSOR:', \
                        'PROCESSOR_NETWORK_ID', 'PROCESSOR_BIN_ID', 'PROCESSOR_MEMBER', \
                        'REPORT DATE         :', ' AFFILIATE:', 'AFFILIATE_NETWORK_ID', \
                        'AFFILIATE_BIN_ID', 'AFFILIATE_MEMBER', ' SRE      :', \
                        'SRE_BIN_ID', 'SRE_MEMBER', 'VSS PROCESSING DATE :', 'XMIT_DATE', \
                        'PAN', 'RETRV_REF_NBR', 'TRACE_NBR', 'ISSUER_ID', 'TRAN_TYPE', \
                        'PROC_CODE', 'AMT_TRANS', 'TRANS_CURR', 'AMT_SETTL', 'SETTL_METHOD', \
                        ' CA ID: ', 'CARD_ACCEPT_ID', 'TERMINAL_ID', 'MERCHANT_NAME', \
                        ' FPI: ', ' TR ID: ']


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

    def __SendMailMessage(self, isAlert=True, emailFilesList=None):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __SendMailMessage():
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

        if isAlert:
            configSection = 'VISA_SMS601C_ALERTS'
        else:
            configSection = 'VISA_SMS601C_REPORTS'

        emailFilesPath = os.path.dirname(os.path.abspath(__file__))

        if self.__emailBodyText:
            emailBody = self.__emailBodyText
        if self.__emailSubjectText:
            emailSubject = self.__emailSubjectText

        # Create email object
        emailObj = EnhancedEmailClass(READ_FROM_CONFIG_FILE=emailConfigFile, \
                                             CONFIG_SECTION_NAME=configSection, \
                                             EMAIL_SUBJECT=emailSubject, \
                                             EMAIL_BODY=emailBody)

        # Attach files if any. You can attach files only after creating the email object
        if emailFilesList:
            emailObj.AttachFiles(ATTACH_FILES_LIST=emailFilesList, \
                        ATTACH_FILES_FOLDER=emailFilesPath)

        print('emailfilesList: {0}'.format(emailFilesList))
        print('emailFilesPath: {0}'.format(emailFilesPath))
        self.__lineNum = GetLineNo() + 1
        if not emailObj.SendEmail():
            self.__formatBuffer = ( \
                'Unable to send email message. Error occurred in __SendMailMessage() ' \
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

    def __EncryptAndArchive(self, fileName):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __EncryptAndArchive(self):
                Encrypts the input file and archives it. The original input file is deleted
                after that.

            Parameters:
                fileName - File to encrypt and archive

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Encrypt the file
            encryptKeyToArchive = os.environ['ARCHIVE_ENCRYPT_KEY']
            print('encryptKeyToArchive: {0}\n'.format(encryptKeyToArchive))
            gpgCommand = 'gpg --encrypt --armor --recipient {0} ' \
                         '{1}'.format(encryptKeyToArchive, fileName)
            print('gpgCommand: {0}\n'.format(gpgCommand))

            self.__lineNum = GetLineNo() + 2
            # An error occurred in encrypting the sms601c report input file
            if os.system(gpgCommand):
                self.__formatBuffer = \
                    'Unable to encrypt the file {0} file. Error generated in ' \
                    '{1} module __EncryptAndArchive() method at Line #: {2}{3}'

                print(self.__FormatMessage( \
                        self.__formatBuffer.format(fileName, __file__, \
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
                        self.__formatBuffer.format(fileName, __file__, \
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

            basePath = os.path.dirname(os.path.abspath(__file__))
            sourceFilePath = os.path.join(basePath, fileName)

            encryptedFileName = '{0}.asc'.format(fileName)
            encryptedFileWithPath = os.path.join(basePath, encryptedFileName)
            print('encryptedFileWithPath: {0}\n'.format(encryptedFileWithPath))

            # Archive the encrypted file
            archiveFileWithPath = \
                os.path.join(basePath, 'ARCHIVE/{0}'.format(encryptedFileName))
            print('archiveFileWithPath: {0}\n'.format(archiveFileWithPath))
            shutil.move(encryptedFileWithPath, archiveFileWithPath)

            # Remove the downloaded SMS601C report input file
            os.remove(sourceFilePath)

            return True
        except Exception as otherException:
            print(self.__FormatMessage( \
                str(otherException), width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(str(otherException), '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailBodyText = str(otherException)
            self.__emailSubjectText = \
                    'Exception occurred archiving the Visa SMS601C input data File ' \
                                           '{0}'.format(fileName)
            if not self.__SendMailMessage():
                return False
            return False


    # ****************************************************************************************

    def __WriteDataDictToCsvFile(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __WriteDataDictToCsvFile():
                Traverses the data dictionary containing the report data and writes to a
                csv file.

            Parameters:
                None

            Returns:
                True if data is successfully written to the csv file, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        columnNames = \
                ['FUNDS_XFR_NBR', 'FUNDS_XFR_NAME', 'PROCESSOR_ID', \
                 'PROCESSOR_NETWORK_ID', 'PROCESSOR_BIN_ID', 'PROCESSOR_MEMBER', \
                 'AFFILIATE_ID', 'AFFILIATE_NETWORK_ID', 'AFFILIATE_BIN_ID', \
                 'AFFILIATE_MEMBER', 'SRE_ID', 'SRE_BIN_ID', 'SRE_MEMBER', \
                 'SETTLE_DATE', 'REPORT_DATE', 'PROCESSING_DATE', 'XMIT_DATE', \
                 'PAN', 'TRAN_ID', 'RETRV_REF_NBR', 'TRACE_NBR', 'ISSUER_ID', \
                 'TRAN_TYPE', 'PROC_CODE', 'AMT_TRANS', 'AMT_SETTL', 'SETTL_METHOD', \
                 'CARD_ACCEPT_TERMINAL', 'CARD_ACCEPT_ID', 'TERMINAL_ID', \
                 'MERCHANT_NAME', 'FEE_PROGRAM_IND', 'TRANS_REF_DATA']

        columnHeaders = \
                ['FUNDS TRANSFER NBR', 'FUNDS TRANSFER NAME', 'PROCESSOR ID', \
                'PROCESSOR NETWORK ID', 'PROCESSOR BIN ID', 'PROCESSOR MEMBER', \
                'AFFILIATE ID', 'AFFILIATE NETWORK ID', 'AFFILIATE BIN ID', \
                'AFFILIATE MEMBER', 'SRE ID', 'SRE BIN ID', 'SRE MEMBER', \
                'SETTLE DATE', 'REPORT DATE', 'PROCESSING DATE', 'TRANSMIT DATE', \
                'CARD NUMBER', 'TRANSACTION ID', 'RETRIEVAL REFERENCE NBR', 'TRACE NBR', \
                'ISSUER ID', 'TRANSACTION TYPE', 'PROCESS CODE', 'TRANSACTION AMOUNT', \
                'SETTLE AMOUNT', 'SETTLE METHOD', 'CARD ACCEPT TERMINAL', \
                'CARD ACCEPT ID', 'TERMINAL ID', 'MERCHANT NAME', \
                'FEE PROGRAM INDICATOR', 'ARN NUMBER']

        subTotalDebits = \
                ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', \
                 '', '', '', '', '', 'DEBITS:', 'COUNTS', 'AMT_TRANS', 'AMT_SETTL', \
                 '', '', '', '', '', '', '']
        subTotalCredits = \
                ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', \
                 '', '', '', '', '', 'CREDITS:', 'COUNTS', 'AMT_TRANS', 'AMT_SETTL', \
                 '', '', '', '', '', '', '']
        subTotalAmounts = \
                ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', \
                 '', '', '', '', '', 'SUB TOTAL:', 'COUNTS', 'AMT_TRANS', 'AMT_SETTL', \
                 '', '', '', '', '', '', '']
        subTotalNonFin = \
                ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', \
                 '', '', '', '', '', 'NON FINANCIAL:', 'COUNTS', '', '', '', '', '', \
                 '', '', '', '']
        emptyLine = \
                ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', \
                 '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']

        ioExceptionMessage = \
                'Error occurred in {0} Module __WriteDataDictToCsvFile() method ' \
                'at line #: {1}: I/O error writing to file: {2}. ({3}): {4}{5}'
        typeExceptionMessage = \
                'Error occurred in {0} Module __WriteDataDictToCsvFile() method ' \
                'at line #: {1}: Error writing to file: {2}{3}'

        # Name of csv file
        csvFileName = 'vs_sms601C_{0}.csv'.format(self.__reportDate)

        # The dictionary data needs to be in a list
        tempList = []
        try:
            # Write to csv file
            self.__lineNum = GetLineNo() + 1
            with open(csvFileName, 'w') as csvFilePtr:
                # Create a csv dict writer object. Note: Use extrasaction='ignore'
                # if you are not writing all the data elements in your dictionary.
                # Otherwise, the csvWriter object expects them to be matched
                self.__lineNum = GetLineNo() + 1
                csvWriterObj = csv.DictWriter(csvFilePtr, fieldnames=columnNames, \
                                              extrasaction='ignore')

                listIndex = 0
                self.__lineNum = GetLineNo() + 1
                for listItem in self.__listDataDict:
                    # You want to write a meaningful header name, not the column names
                    # defined in the dictionary, so use the DictWriter instance's
                    # underlying 'UnicodeWriter' instance to customize your headers
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(columnHeaders)

                    self.__lineNum = GetLineNo() + 1
                    for dictKey in listItem:
                        # print('Key = {0} : {1}'.format(dictKey, listItem[dictKey]))
                        # print(listItem[dictKey])
                        # Mask and replace the credit card number
                        tempBuf = '{0}XXXXXXX{1}'.format(listItem[dictKey]['PAN'][:5], \
                                                        listItem[dictKey]['PAN'][-4:])
                        self.__lineNum = GetLineNo() + 1
                        tempList.append(listItem[dictKey])
                        self.__lineNum = GetLineNo() + 1
                        tempList[0]['PAN'] = tempBuf
                        # print(tempList)
                        # Write data rows
                        self.__lineNum = GetLineNo() + 1
                        csvWriterObj.writerows(tempList)
                        # Clear the list so that the next data element can be added
                        tempList.clear()
                    self.__lineNum = GetLineNo() + 1
                    debitCount, debitSettlAmt, debitTranAmt = \
                        [dictValue for (dictKey, dictValue) in \
                            sorted(self.__listSectionTotals[listIndex]['DEBITS'].items())]

                    # Write a blank line.
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(emptyLine)

                    # print('DEBITS: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                          # '{2}\n'.format(debitCount, debitSettlAmt, debitTranAmt))
                    # Replace the list values with the counts and amounts. Note the indices
                    # 23, 24 and 25 are column indices matching the PROCESS CODE,
                    # TRANSACTION AMOUNT and SETTLE AMOUNT
                    subTotalDebits[23] = debitCount
                    subTotalDebits[24] = debitTranAmt
                    subTotalDebits[25] = debitSettlAmt
                    csvWriterObj.writer.writerow(subTotalDebits)
                    self.__lineNum = GetLineNo() + 1
                    creditCount, creditSettlAmt, creditTranAmt = \
                        [dictValue for (dictKey, dictValue) in \
                            sorted(self.__listSectionTotals[listIndex]['CREDITS'].items())]
                    # print('CREDITS: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                          # '{2}\n'.format(creditCount, creditSettlAmt, creditTranAmt))
                    # Replace the list values with the counts and amounts
                    subTotalCredits[23] = creditCount
                    subTotalCredits[24] = creditTranAmt
                    subTotalCredits[25] = creditSettlAmt
                    csvWriterObj.writer.writerow(subTotalCredits)
                    self.__lineNum = GetLineNo() + 1
                    subtotCount, subtotSettlAmt, subtotTranAmt = \
                        [dictValue for (dictKey, dictValue) in \
                            sorted(self.__listSectionTotals[listIndex]['SUBTOTAL'].items())]
                    # print('SUBTOTAL: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                          # '{2}\n'.format(subtotCount, subtotSettlAmt, subtotTranAmt))
                    # Replace the list values with the counts and amounts
                    subTotalAmounts[23] = subtotCount
                    subTotalAmounts[24] = subtotTranAmt
                    subTotalAmounts[25] = subtotSettlAmt
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(subTotalAmounts)
                    self.__lineNum = GetLineNo() + 1
                    nonfinCount, nonfinSettlAmt, nonfintTranAmt = \
                        [dictValue for (dictKey, dictValue) in \
                            sorted(self.__listSectionTotals[listIndex]['NONFINANCIAL'].items())]
                    # print('NONFINANCIAL: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                          # '{2}\n'.format(nonfinCount, nonfinSettlAmt, nonfintTranAmt))
                    # Replace the list values with the counts and amounts
                    subTotalNonFin[23] = nonfinCount
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(subTotalNonFin)

                    listIndex = listIndex + 1

                    # Write a blank line.
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(emptyLine)
                    self.__lineNum = GetLineNo() + 1
                    csvWriterObj.writer.writerow(emptyLine)

            # Email the CSV file
            self.__lineNum = GetLineNo() + 1
            reportDate = \
                datetime.strptime(self.__reportDate, '%d%b%y').strftime('%m/%d/%Y')
            print('reportDate = {0}\n'.format(reportDate))
            self.__emailBodyText = \
                    'Attached please find the parsed output of the VISA SMS601C ' \
                    'report for {0}'.format(reportDate)
            # print('self.__emailBodyText: {0}\n'.format(self.__emailBodyText))
            self.__lineNum = GetLineNo() + 1
            self.__emailSubjectText = \
                    'VISA SMS601C Report CSV File for {0}'.format(reportDate)
            # print('self.__emailSubjectText: {0}\n'.format(self.__emailSubjectText))

            filesList = []
            self.__lineNum = GetLineNo() + 1
            filesList.append(csvFileName)
            self.__lineNum = GetLineNo() + 1
            if not self.__SendMailMessage(isAlert=False, emailFilesList=filesList):
                return False

            # Archive the CSV file and delete the input file
            basePath = os.path.dirname(os.path.abspath(__file__))
            archivePath = os.path.join(basePath, 'ARCHIVE')
            sourceFilePath = os.path.join(basePath, csvFileName)
            destFilePath = os.path.join(archivePath, csvFileName)

            if not os.path.exists(archivePath):
                os.makedirs(archivePath)

            shutil.move(sourceFilePath, destFilePath)

            return True

        except IOError as exceptError:
            errorNum, errorString = exceptError.args
            print(self.__FormatMessage( \
                ioExceptionMessage.format(__file__, self.__lineNum, csvFileName, \
                                          errorNum, errorString, ''),
                width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    ioExceptionMessage.format(__file__, self.__lineNum, csvFileName, \
                                               errorNum, errorString, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before
            # the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            return False
        except (TypeError, ValueError, AttributeError) as exceptionError:
            print(self.__FormatMessage( \
                    typeExceptionMessage.format(__file__, self.__lineNum, csvFileName, \
                                                str(exceptionError), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    typeExceptionMessage.format(__file__, self.__lineNum,\
                                                str(exceptionError), ''), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
            return False
        except Exception as otherException:
            print(self.__FormatMessage( \
                str(otherException), width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(str(otherException), '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailBodyText = str(otherException)
            self.__emailSubjectText = 'Exception: Creating the CSV File ' \
                                           '{0}'.format(csvFileName)
            if not self.__SendMailMessage():
                return False
            return False
        else:
            return False


    # ****************************************************************************************

    def __ValidateDataCounts(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ValidateDataCounts():
                Validates the counts and totals for a specific set of transactions associated
                with an Affilitate ID group.

            Parameters:
                None

            Returns:
                True if summary totals and counts match the report totals and counts, False
                else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            exceptionErrorMessage = \
                'An exception occurred validating the report summary totals or counts ' \
                'in __ValidateDataCounts() method at Line #: {0} of {1} module\n. ' \
                'Error Value: {2} {3}'

            listItemCount = 0
            self.__lineNum = GetLineNo() + 1
            for listItem in self.__listDataDict:
                self.__creditCount = 0
                self.__debitCount = 0
                self.__nonFinCount = 0
                self.__transTotal = 0.00
                self.__debitSettlTotal = 00.00
                self.__creditSettlTotal = 00.00

                for dictIndex in listItem:
                    if self.__runMode == 'TEST':
                        print('__ValidateDataCounts(): {0}\n'.format(listItem[dictIndex]))
                    # Assume all transactions are USD. Therefore not checking currency
                    self.__lineNum = GetLineNo() + 1
                    formattedText = listItem[dictIndex]['AMT_TRANS']
                    self.__lineNum = GetLineNo() + 1
                    self.__savedTransAmt = round(float(formattedText), 2)
                    self.__transTotal = self.__transTotal + self.__savedTransAmt

                    # Assume all transactions are USD. Therefore not checking currency
                    self.__lineNum = GetLineNo() + 1
                    formattedText = listItem[dictIndex]['AMT_SETTL']

                    self.__lineNum = GetLineNo() + 1
                    if listItem[dictIndex]['SETTL_METHOD'] == 'DR':
                        self.__debitCount = self.__debitCount + 1
                        self.__debitSettlTotal = self.__debitSettlTotal + \
                                                        round(float(formattedText), 2)
                    elif listItem[dictIndex]['SETTL_METHOD'] == 'CR':
                        formattedText = formattedText.rstrip('CR')
                        self.__creditCount = self.__creditCount + 1
                        self.__creditSettlTotal = self.__creditSettlTotal + \
                                                         round(float(formattedText), 2)
                    else:
                        self.__nonFinCount = self.__nonFinCount + 1
                        # Subtract the non financial amount
                        self.__transTotal = self.__transTotal - self.__savedTransAmt

                    # Re-set saved transaction amount
                    self.__savedTransAmt = 0.00

                print('__ValidateDataCounts(): ' \
                      'self.__nonFinCount = {0}'.format(self.__nonFinCount))
                # Note the dictionary values in the __listSectionTotals list are not
                # sorted at the point of insertion, so use a sort on keys to get the
                # list values in count, settle amount, and trans amount order.
                # [value for (key, value) in sorted(numbers.items())]
                self.__lineNum = GetLineNo() + 1
                debitCount, debitSettlAmt, debitTranAmt = \
                    [dictValue for (dictKey, dictValue) in \
                        sorted(self.__listSectionTotals[listItemCount]['DEBITS'].items())]
                # print('DEBITS: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                      # '{2}\n'.format(debitCount, debitSettlAmt, debitTranAmt))
                self.__lineNum = GetLineNo() + 1
                creditCount, creditSettlAmt, creditTranAmt = \
                    [dictValue for (dictKey, dictValue) in \
                        sorted(self.__listSectionTotals[listItemCount]['CREDITS'].items())]
                # print('CREDITS: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                      # '{2}\n'.format(creditCount, creditSettlAmt, creditTranAmt))
                self.__lineNum = GetLineNo() + 1
                subtotCount, subtotSettlAmt, subtotTranAmt = \
                    [dictValue for (dictKey, dictValue) in \
                        sorted(self.__listSectionTotals[listItemCount]['SUBTOTAL'].items())]
                # print('SUBTOTAL: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                      # '{2}\n'.format(subtotCount, subtotSettlAmt, subtotTranAmt))
                self.__lineNum = GetLineNo() + 1
                nonfinCount, nonfinSettlAmt, nonfintTranAmt = \
                    [dictValue for (dictKey, dictValue) in \
                        sorted(self.__listSectionTotals[listItemCount]['NONFINANCIAL'].items())]
                # print('NONFINANCIAL: Count = {0}  SettlAmt = {1}  TranAmt = ' \
                      # '{2}\n'.format(nonfinCount, nonfinSettlAmt, nonfintTranAmt))

                listItemCount = listItemCount + 1

                # Now Print the calculated counts from the __listDataDict list
                countString = \
                    'listItemCount = {0}\nself.__debitCount = {1}\n' \
                    'self.__creditCount = {2}\nself.__nonFinCount = {3}\n' \
                    'self.__transTotal = {4:.2f}\nself.__debitSettlTotal = {5:.2f}\n' \
                    'self.__creditSettlTotal = {6:.2f}{7}'

                print(countString.format(listItemCount, self.__debitCount, \
                      self.__creditCount, self.__nonFinCount, self.__transTotal, \
                      self.__debitSettlTotal, self.__creditSettlTotal, '\n'))

                # Log to the log file only if the logger object was created.
                if self.__loggerObj and not self.__loggerObj.LogMessage( \
                    self.__FormatMessage( \
                        countString.format(listItemCount, self.__debitCount, \
                                           self.__creditCount, self.__nonFinCount, \
                                           self.__transTotal, self.__debitSettlTotal, \
                                           self.__creditSettlTotal, ''), \
                        width=80, initial_indent='\n            ', \
                        subsequent_indent=' ' * 12, break_long_words=False, \
                        break_on_hyphens=False), 'BODY'):
                    return False

                # Reset the logging level to what was originally set before the error
                self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                # Reset the logging level to what was originally set before the error
                self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                # Set True/False flags to indicate the report summary totals match
                # with the actual calculated totals.
                self.__lineNum = GetLineNo() + 1
                isSubTotal = \
                    (lambda x, y, z: z == x + y)(self.__debitCount, self.__creditCount, \
                                                 subtotCount)
                self.__lineNum = GetLineNo() + 1
                isDebitCount = (lambda x, y: x == y)(debitCount, self.__debitCount)
                self.__lineNum = GetLineNo() + 1
                isCreditCount = (lambda x, y: x == y)(creditCount, self.__creditCount)
                self.__lineNum = GetLineNo() + 1
                isSubSettlAmt = \
                    (lambda x, y, z: round(z, 2) == round(x - y, 2)) \
                        (self.__creditSettlTotal, self.__debitSettlTotal, subtotSettlAmt)
                self.__lineNum = GetLineNo() + 1
                isDebitTranAmt = (lambda x, y: round(x, 2) == round(y, 2)) \
                                    (debitTranAmt, self.__debitSettlTotal)
                self.__lineNum = GetLineNo() + 1
                isCreditTranAmt = (lambda x, y: round(x, 2) == round(y, 2)) \
                                    (creditTranAmt, self.__creditSettlTotal)
                self.__lineNum = GetLineNo() + 1
                isDebitSettlAmt = \
                    (lambda x, y: round(x, 2) == round(y, 2)) \
                                    (debitSettlAmt, self.__debitSettlTotal)
                self.__lineNum = GetLineNo() + 1
                isCreditSettlAmt = \
                    (lambda x, y: round(x, 2) == round(y, 2)) \
                                    (creditSettlAmt, self.__creditSettlTotal)
                self.__lineNum = GetLineNo() + 1
                isNonFinCount = (lambda x, y: x == y) \
                                                (nonfinCount, self.__nonFinCount)

                print('isDebitCount = {0}  isCreditCount = {1}  isSubTotal = {2}\n' \
                      'isDebitSettlAmt = {3}  isCreditSettlAmt = {4}  ' \
                      'isSubSettlAmt = {5}\nisDebitTranAmt = {6}  isCreditTranAmt = ' \
                      '{7}  isNonFinCount = ' \
                      '{8}\n'.format(isDebitCount, isCreditCount, isSubTotal, \
                                     isDebitSettlAmt, isCreditSettlAmt, isSubSettlAmt, \
                                     isDebitTranAmt, isCreditTranAmt, isNonFinCount))
            # elementCount = 0
            # for dataElement in self.__listSectionTotals:
                # print(dataElement)
                # elementCount = elementCount + 1
            # print('elementCount = {0}\n'.format(elementCount))
            # print('\nlistItemCount: {0}'.format(listItemCount))

            self.__lineNum = GetLineNo() + 1
            return (lambda a, b, c, d, e, f, g, h, i: \
                           a and b and c and d and e and f and g and h and i) \
                           (isSubTotal, isDebitCount, isCreditCount, isSubSettlAmt, \
                            isDebitTranAmt, isCreditTranAmt, isDebitSettlAmt, \
                            isCreditSettlAmt, isNonFinCount)
        except (TypeError, ValueError, AttributeError) as exceptionError:
            print(self.__FormatMessage( \
                    exceptionErrorMessage.format(self.__lineNum, __file__, \
                                                 str(exceptionError), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # print the dictionary value at this point for debugging purposes
            print(listItem[dictIndex])

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    exceptionErrorMessage.format(self.__lineNum, __file__, \
                                                 str(exceptionError), ''), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
            return False
        else:
            return False


    # ****************************************************************************************

    def __GetFieldPositions(self, fieldIndex):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GetFieldPositions():
                Traverses the dictionary and gets the field start and end positions.

            Parameters:
                fieldIndex - Index to the list dictionary

            Returns:
                field name, Start and end field positions.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        startPosition = 0
        endPosition = 0
        fieldName = None

        for dictItem in self.__listConfigDict[fieldIndex]:
            if dictItem == 'FIELD_NAME':
                fieldName = self.__listConfigDict[fieldIndex][dictItem]
            if dictItem == 'START_COL':
                startPosition = self.__listConfigDict[fieldIndex][dictItem]
            if dictItem == 'END_COL':
                endPosition = self.__listConfigDict[fieldIndex][dictItem]

        # print('\nFIELD_NAME: {0}  START_COL = {1}  END_COL = ' \
                # '{2}\n'.format(fieldName, startPosition, endPosition))
        return fieldName, int(startPosition), int(endPosition)


    # ****************************************************************************************

    def __UpdateDataElement(self, listIndex, fileName, textLine, isReportHeader=False):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __UpdateDataElement():
                Parses the data file and extracts the relevant data in to a dictionary.

            Parameters:
                listIndex      - Index to the list containing field start and end positions
                fileName       - Visa input file name
                textLine       - Text line read from the file
                isReportHeader - True if report header line
            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        fieldName, startPos, endPos = self.__GetFieldPositions(listIndex)

        # print('fieldName {0} start = {1} end = {2} listIndex = ' \
              # '{3}'.format(fieldName, startPos, endPos, listIndex))
        # Check if the end position is greater than the start position
        self.__lineNum = GetLineNo() + 1
        if startPos >= endPos:
            print('Start position {0} cannot be greater than end ' \
                    'position {1}'.format(startPos, endPos))
            self.__formatBuffer = '{0} Start position {1} cannot be greater than end ' \
                                  'position {2}. Error occurred in module {3} at ' \
                                  'Line #: {4}{5}'

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(fieldName, startPos, endPos, __file__, \
                                               self.__lineNum, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Send an alert email
            self.__emailBodyText = \
                self.__formatBuffer.format(fieldName, startPos, endPos, __file__, \
                                           self.__lineNum, '')
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report {0} '\
                                           'File'.format(fileName)

            if not self.__SendMailMessage():
                return False
            # Reset the logging level to what was originally set before the error
            if not self.__loggerObj.ResetLoggingLevel(self.__loggingLevel):
                return False
            return False

        # print('startPos = {0}  endPos = {1}  Length {2}\n ' \
                # 'textLine: <{3}>'.format(startPos, endPos, len(textLine), textLine))
        # Remove leading and ending spaces
        self.__lineNum = GetLineNo() + 1
        formattedText = textLine[int(startPos) : int(endPos)].strip()

        # Save the report ID if the text is a report header text line
        if isReportHeader:
            self.__savedReportID = formattedText
        # print('Field value: <{0}>  '.format(formattedText))
        # print('self.__columnList[listIndex]: ' \
                # '{0}\n'.format(self.__columnList[listIndex]))

        # Update the data dictionary only if the data is related to the SMS601C report
        if self.__savedReportID == self.__lookupReportID:
            self.__fieldDataDict.update( \
                                    {self.__columnList[listIndex] : formattedText})
            # print(self.__fieldDataDict)

        # If this is the report date field, save it. It is part of the CSV file name
        if listIndex == self.__columnList.index('REPORT_DATE'):
            self.__reportDate = formattedText
        return True


    # ****************************************************************************************

    def __ProcessCountLines(self, fileName, textLine, infileLineNum):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ProcessCountLines():
                Parses the summary count text lines and extracts the relevant data elements
                into a dictionary.

            Parameters:
                fileName      - File to process
                textLine      - Data text line being processed
                infileLineNum - text line number being parsed

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            exceptionErrorMessage = \
                'An exception occurred processing text line # {0} in {1} text file. ' \
                'Error generated in the __ProcessCountLines() method at Line # ' \
                '{2} of {3} module\n. Error Value: {4} {5}'
            localErrorMessage = \
                'An error occurred processing text line # {0} in {1} text file. \'{2}\' ' \
                'not in wordSearchList. Error generated in the __ProcessCountLines() ' \
                'method at Line # {3} of {4} module'
            # Note that the DEBITS, CREDITS, SUBTOTAL, and NON FINANCIAL elements in the
            # list below are ordered in the same order as what's shown on the report
            wordSearchList = ['DEBITS        :', 'CREDITS       :', 'SUBTOTAL      :', \
                              'NON FINANCIAL :']
            # Make it an ordered dictionary so that the data inserted can be extracted in
            # the same order that they were inserted. However, this will only work on
            # Python 3.6 and above. Does not work on Python 3.4 which is what currently
            # installed on Sybil
            tempDict = OrderedDict()

            itemFound = False
            for listItemValue in wordSearchList:
                if listItemValue in textLine:
                    # Discard other data and only process the count and totals from the
                    # text line
                    countText = textLine[83:]
                    # print('countText <{0}>\n'.format(countText))

                    if itemFound:
                        continue

                    if listItemValue != 'NON FINANCIAL :':
                        self.__lineNum = GetLineNo() + 1
                        transCount, transTotal, settlTotal = countText.split()
                    else:
                        self.__lineNum = GetLineNo() + 1
                        transCount = countText.split()[0]
                        # print('transCount = {0}\n'.format(transCount))
                        transTotal = '0.00'
                        settlTotal = '0.00'

                    # print('listItemValue <{0}> transCount <{1}> transTotal <{2}> ' \
                          # 'settlTotal <{3}>\n'.format(listItemValue, transCount, \
                                                      # transTotal, settlTotal))

                    # Remove commas from texts
                    self.__lineNum = GetLineNo() + 1
                    transCount = transCount.replace(',', '')
                    self.__lineNum = GetLineNo() + 1
                    transTotal = transTotal.replace(',', '')
                    self.__lineNum = GetLineNo() + 1
                    settlTotal = settlTotal.replace(',', '')

                    # Convert to int and float values
                    self.__lineNum = GetLineNo() + 1
                    transCount = int(transCount)
                    self.__lineNum = GetLineNo() + 1
                    transTotal = round(float(transTotal), 2)
                    self.__lineNum = GetLineNo() + 1
                    settlTotal = round(float(settlTotal[:-2]), 2)

                    self.__lineNum = GetLineNo() + 1
                    tempDict = {'COUNT' : transCount, 'TRAN_TOT' : transTotal, \
                                'SETTL_TOT' : settlTotal}

                    # print(tempDict)

                    if listItemValue == 'DEBITS        :':
                        self.__lineNum = GetLineNo() + 1
                        self.__sectionTotalsDict.update({'DEBITS' : tempDict.copy()})
                    elif listItemValue == 'CREDITS       :':
                        self.__lineNum = GetLineNo() + 1
                        self.__sectionTotalsDict.update({'CREDITS' : tempDict.copy()})
                    elif listItemValue == 'SUBTOTAL      :':
                        self.__lineNum = GetLineNo() + 1
                        self.__sectionTotalsDict.update({'SUBTOTAL' : tempDict.copy()})
                    elif listItemValue == 'NON FINANCIAL :':
                        self.__lineNum = GetLineNo() + 1
                        self.__sectionTotalsDict.update({'NONFINANCIAL' : tempDict.copy()})

                        # Now add to the totals list
                        self.__lineNum = GetLineNo() + 1
                        self.__listSectionTotals.append(self.__sectionTotalsDict.copy())
                        self.__lineNum = GetLineNo() + 1
                        self.__sectionTotalsDict.clear()

                    self.__lineNum = GetLineNo() + 1
                    tempDict.clear()
                    itemFound = True
                else:
                    continue

            # If item not found, a wrong text string is passed to this method
            if not itemFound:
                self.__lineNum = GetLineNo() - 1
                self.__errorMessage = \
                    localErrorMessage.format(infileLineNum, fileName, listItemValue, \
                                             self.__lineNum, __file__)
                raise LocalException(self.__errorMessage)

            return True
        except LocalException as exceptionError:
            print(self.__FormatMessage('{0}{1}'.format(exceptionError.value, ''), \
                   width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                   break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(exceptionError.value, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            return False
        except (ValueError, TypeError, AttributeError) as valueException:
            print(self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
            return False
        else:
            return False


    def __ClearDataFields(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ClearDataFields():
                Clear the data fields in the data dictionary leaving only the report header
                information. Note that the header information is common for a data set.

            Parameters:
                None

            Returns:
                None
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__fieldDataDict['PAN'] = ''
        self.__fieldDataDict['RETRV_REF_NBR'] = ''
        self.__fieldDataDict['TRACE_NBR'] = ''
        self.__fieldDataDict['ISSUER_ID'] = ''
        self.__fieldDataDict['TRAN_TYPE'] = ''
        self.__fieldDataDict['PROC_CODE'] = ''
        self.__fieldDataDict['AMT_TRANS'] = ''
        self.__fieldDataDict['TRANS_CURR'] = ''
        self.__fieldDataDict['AMT_SETTL'] = ''
        self.__fieldDataDict['SETTL_METHOD'] = ''
        self.__fieldDataDict['CARD_ACCEPT_TERMINAL'] = ''
        self.__fieldDataDict['CARD_ACCEPT_ID'] = ''
        self.__fieldDataDict['TERMINAL_ID'] = ''
        self.__fieldDataDict['MERCHANT_NAME'] = ''
        self.__fieldDataDict['FEE_PROGRAM_IND'] = ''
        self.__fieldDataDict['TRAN_ID'] = ''


    # ****************************************************************************************

    def __ProcessReportTextLine(self, fileName, textLine, infileLineNum, dataDetailLineNum):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ProcessReportTextLine():
                Parses a text line and extracts the relevant data elements into a dictionary.

            Parameters:
                fileName          - File to process
                textLine          - Data text line being processed
                infileLineNum     - text line number being parsed
                dataDetailLineNum - The text detail line number being processed

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            localErrorMessageOne = \
                'An error occurred processing text line # {0} in {1} text file. Error ' \
                'generated in the __ProcessReportTextLine() method at Line # {2} ' \
                'of {3} module'
            localErrorMessageTwo = \
                'An error occurred processing text line # {0} in {1} text file. \'{2}\' ' \
                'not in lookupWordList. Error generated in the __ProcessReportTextLine() ' \
                'method at Line # {3} of {4} module'
            exceptionErrorMessage = \
                'An exception occurred processing text line # {0} in {1} text file. ' \
                'Error generated in the __ProcessReportTextLine() method at Line # ' \
                '{2} of {3} module\n. Error Value: {4} {5}'

            wordElementListOne = ['XMIT_DATE', 'PAN', 'RETRV_REF_NBR', 'TRACE_NBR', \
                                  'ISSUER_ID', 'TRAN_TYPE', 'PROC_CODE', 'AMT_TRANS', \
                                  'TRANS_CURR', 'AMT_SETTL', 'SETTL_METHOD']
            wordElementListTwo = [' CA ID: ', 'CARD_ACCEPT_ID', 'TERMINAL_ID', \
                                  'MERCHANT_NAME', ' FPI: ']
            wordElementListThree = [' TR ID: ']

            if dataDetailLineNum == 1:
                wordSearchList = wordElementListOne
            elif dataDetailLineNum == 2:
                wordSearchList = wordElementListTwo
            elif dataDetailLineNum == 3:
                wordSearchList = wordElementListThree

            for listItemValue in wordSearchList:
                if listItemValue in self.__lookupWordList:
                    self.__lineNum = GetLineNo() + 1
                    indexToColList = self.__lookupWordList.index(listItemValue)
                    # print('Index {0}: = {1}\n'.format(listItemValue, indexToColList))
                    if not self.__UpdateDataElement(indexToColList, fileName, textLine):
                        self.__lineNum = GetLineNo() - 1
                        self.__errorMessage = \
                                localErrorMessageOne.format(infileLineNum, fileName, \
                                                            self.__lineNum, __file__)
                        raise LocalException(self.__errorMessage)

                    # If it is 'AMT_TRANS', just extract the dollar portion of the
                    # the string and update the data dictionary value
                    if listItemValue == 'AMT_TRANS':
                        formattedText = self.__fieldDataDict['AMT_TRANS'][:-4]
                        # Remove commas from string
                        formattedText = formattedText.replace(',', '')
                        self.__fieldDataDict.update({'AMT_TRANS' : formattedText})

                    # If it is 'TRANS_CURR', just extract the currency portion of the
                    # the string and update the data dictionary value
                    if listItemValue == 'TRANS_CURR':
                        formattedText = self.__fieldDataDict['TRANS_CURR'][-3:]
                        self.__fieldDataDict.update({'TRANS_CURR' : formattedText})

                    # If it is 'AMT_SETTL', just extract the dollar portion of the
                    # string and update the data dictionary value
                    if listItemValue == 'AMT_SETTL':
                        tranType = self.__fieldDataDict['AMT_SETTL'][-2:]
                        if tranType in ('DR', 'CR'):
                            formattedText = self.__fieldDataDict['AMT_SETTL'][:-2]
                        else:
                            formattedText = self.__fieldDataDict['AMT_SETTL']
                        # Remove commas from string
                        formattedText = formattedText.replace(',', '')
                        # Remove the DR/CR portion at the end of the string if any
                        formattedText = formattedText.rstrip('DCR')
                        self.__fieldDataDict.update({'AMT_SETTL' : formattedText})

                    # If it is 'SETTL_METHOD', just extract the DR/CR portion of the
                    # string and update the data dictionary value
                    if listItemValue == 'SETTL_METHOD':
                        tranType = self.__fieldDataDict['SETTL_METHOD'][-2:]
                        formattedText = None
                        if tranType in ('DR', 'CR'):
                            formattedText = self.__fieldDataDict['SETTL_METHOD'][-2:]
                        self.__fieldDataDict.update({'SETTL_METHOD' : formattedText})
                else:
                    self.__lineNum = GetLineNo() - 1
                    self.__errorMessage = \
                            localErrorMessageTwo.format(infileLineNum, fileName, \
                                                        listItemValue, self.__lineNum, \
                                                        __file__)
                    raise LocalException(self.__errorMessage)
            return True
        except LocalException as exceptionError:
            print(self.__FormatMessage('{0}{1}'.format(exceptionError.value, ''), \
                   width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                   break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(exceptionError.value, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            return False
        except ValueError as valueException:
            print(self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
            return False
        else:
            return False


    # ****************************************************************************************

    def __ProcReportHeaderLines(self, fileName, textLine, infileLineNum, headerLineNum, \
                                isReportHeader=False):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ProcReportHeaderLines():
                Parses a text line and extracts the relevant data elements into a dictionary.

            Parameters:
                fileName       - File to process
                textLine       - Data text line being processed
                infileLineNum  - Text line number being parsed
                headerLineNum  - Which header line is being processed
                isReportHeader - Flag to indicate if it is the first line of the report
                                 header

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            localErrorMessageOne = \
                'An error occurred processing text line # {0} in {1} text file. Error ' \
                'generated in the __ProcReportHeaderLines() method at Line # {2} ' \
                'of {3} module'
            localErrorMessageTwo = \
                'An error occurred processing text line # {0} in {1} text file. \'{2}\' ' \
                'not in lookupWordList. Error generated in the __ProcReportHeaderLines() ' \
                'method at Line # {3} of {4} module'
            exceptionErrorMessage = \
                'An exception occurred processing text line # {0} in {1} text file. ' \
                'Error generated in the __ProcReportHeaderLines() method at Line # ' \
                '{2} of {3} module\n. Error Value: {4} {5}'

            headerOneWordList = [' REPORT ID:', 'PAGE NUMBER         :']
            headerTwoWordList = [' FUNDS XFR:', 'FUNDS_XFR_NAME', 'ONLINE SETTLMNT DATE:']
            headerThreeWordList = [' PROCESSOR:', 'PROCESSOR_NETWORK_ID', \
                                   'PROCESSOR_BIN_ID', 'PROCESSOR_MEMBER', \
                                   'REPORT DATE         :']
            headerFourWordList = [' AFFILIATE:', 'AFFILIATE_NETWORK_ID', \
                                  'AFFILIATE_BIN_ID', 'AFFILIATE_MEMBER']
            headerFiveWordList = [' SRE      :', 'SRE_BIN_ID', 'SRE_MEMBER', \
                                  'VSS PROCESSING DATE :']

            if headerLineNum == 1:
                searchWordList = headerOneWordList
            elif headerLineNum == 2:
                searchWordList = headerTwoWordList
            elif headerLineNum == 3:
                searchWordList = headerThreeWordList
            elif headerLineNum == 4:
                searchWordList = headerFourWordList
            elif headerLineNum == 5:
                searchWordList = headerFiveWordList

            for listElement in searchWordList:
                self.__lineNum = GetLineNo() + 1
                if listElement in self.__lookupWordList:
                    self.__lineNum = GetLineNo() + 1
                    indexToColList = self.__lookupWordList.index(listElement)
                    # print('Index {0} = {1}\n'.format(listElement, indexToColList))
                    if not self.__UpdateDataElement(indexToColList, fileName, textLine, \
                                                    isReportHeader):
                        self.__lineNum = GetLineNo() - 1
                        self.__errorMessage = \
                            localErrorMessageOne.format(infileLineNum, fileName, \
                                                        self.__lineNum, __file__)
                        raise LocalException(self.__errorMessage)
                    # now set the flag to False since you are not processing the 'REPORT ID'
                    # portion in the next iterations of the different lists.
                    if isReportHeader:
                        isReportHeader = False
                else:
                    self.__lineNum = GetLineNo() - 1
                    self.__errorMessage = \
                        localErrorMessageTwo.format(infileLineNum, fileName, listElement, \
                                                    self.__lineNum, __file__)
                    raise LocalException(self.__errorMessage)
            return True
        except LocalException as exceptionError:
            print(self.__FormatMessage('{0}{1}'.format(exceptionError.value, ''), \
                   width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                   break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(exceptionError.value, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            return False
        except ValueError as valueException:
            print(self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n    ', subsequent_indent=' ' * 4, \
                    break_long_words=False, break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    exceptionErrorMessage.format(infileLineNum, fileName, self.__lineNum, \
                                                 __file__, str(valueException), ''), \
                    width=80, initial_indent='\n            ', subsequent_indent=' ' * 12, \
                    break_long_words=False, break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)
            return False

        else:
            return False


    # ****************************************************************************************

    def __ParseFile(self, fileName):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ParseFile():
                Invokes methods to parse the data file and extract the data into a dictionary.

            Parameters:
                fileName - File to process

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            localErrorMessageOne = \
                'An error occurred processing text line # {0} in {1} text file. Error ' \
                'generated in the __ParseFile() method at Line # {2} of {3} module'

            monthList = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', \
                         'OCT', 'NOV', 'DEC']

            formFeedStripped = False
            dataHeaderLines = 0
            dataTextLines = 0
            dataReportLines = 0
            dictKeyNumber = 0
            totalInnerDictionariesAdded = 0
            totalNestedDictionariesAdded = 0
            totalListItemsAdded = 0
            infileLineNum = 0
            isFirstRecord = True

            if fileName:
                listIndex = 0
                with open(fileName, 'r') as fileHandle:
                    for lineData in fileHandle:
                        infileLineNum = infileLineNum + 1

                        # Strip form feed, carriage and line feeds
                        if '\f' in lineData:
                            textLine = lineData.lstrip('\f').rstrip('\r\n')
                            formFeedStripped = True
                        else:
                            textLine = lineData.rstrip('\r\n')

                        # Check if the report ID is 'SMS601C' type report
                        if 'REPORT ID:' in textLine:
                            if formFeedStripped:
                                # Add a space at the beginning of the report line to be
                                # consistent with the rest of the data which has a space
                                # in the first position.
                                textLine = '{0}{1}'.format(' ', textLine)
                                # print('<{0}>\n'.format(textLine))
                                formFeedStripped = False

                            if not self.__ProcReportHeaderLines(fileName, textLine, \
                                                                infileLineNum, 1, True):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        # Process only the text lines relevant to the SMS601C report
                        if self.__savedReportID != self.__lookupReportID:
                            continue
                        else:
                            dataReportLines = dataReportLines + 1

                        if ' FUNDS XFR:' in textLine:
                            dataHeaderLines = dataHeaderLines + 1
                            if not self.__ProcReportHeaderLines(fileName, textLine, \
                                                                infileLineNum, 2, False):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        if ' PROCESSOR:' in textLine:
                            dataHeaderLines = dataHeaderLines + 1
                            if not self.__ProcReportHeaderLines(fileName, textLine, \
                                                               infileLineNum, 3, False):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        if ' AFFILIATE:' in textLine:
                            dataHeaderLines = dataHeaderLines + 1
                            if not self.__ProcReportHeaderLines(fileName, textLine, \
                                                               infileLineNum, 4, False):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        if ' SRE      :' in textLine:
                            dataHeaderLines = dataHeaderLines + 1
                            if not self.__ProcReportHeaderLines(fileName, textLine, \
                                                                infileLineNum, 5, False):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        # Now process the line containing card and other information
                        if textLine[7:10].strip() in monthList:
                            dataLineNum = 1   # A flag to indicate data type on this line
                            # print('-- search {0}\n{1}'.format(textLine[7:10], textLine))

                            # Ensure this is the line with the Batch Number.
                            # NOTE: The line with the batch number is where you get the
                            # credit card number and a bunch of data including the
                            # transaction and settle amounts
                            batchId = textLine[1:4].strip()
                            if batchId.isnumeric():
                                if not isFirstRecord:
                                    # At this point we have data of a transaction in the
                                    # grouped data set, so add the row dictionary data
                                    # into a list. This is the beginning of another data
                                    # set. Make sure the TRAN_ID was captured, Otherwise,
                                    # set it to blank
                                    if not tranIdExist:
                                        self.__fieldDataDict['TRAN_ID'] = ''
                                    dictKeyNumber = dictKeyNumber + 1
                                    self.__nestedFieldDataDict[dictKeyNumber] = \
                                                            self.__fieldDataDict.copy()

                                    # Now clear the data fields in the dictionary leaving
                                    # only the report header information which is common
                                    # to all the data sets for a given affiliate.
                                    self.__ClearDataFields()

                                else:
                                    isFirstRecord = False

                                # This is the beginning of a transaction line, so there
                                # is no TRAN_ID read yet. Set the flag to false.
                                tranIdExist = False

                                # print('Batch ID is Numeric {0}'.format(batchId))
                                dataTextLines = dataTextLines + 1
                                if not self.__ProcessReportTextLine(fileName, textLine, \
                                                                    infileLineNum, dataLineNum):
                                    self.__lineNum = GetLineNo() - 2
                                    self.__errorMessage = \
                                        localErrorMessageOne.format(infileLineNum, fileName, \
                                                                    self.__lineNum, __file__)
                                    raise LocalException(self.__errorMessage)
                                # print(self.__fieldDataDict)
                                continue

                        if ' CA ID: ' in textLine:
                            dataLineNum = 2    # A flag to indicate data type on this line
                            dataTextLines = dataTextLines + 1
                            # print('-- search {0}\n{1}'.format(textLine[7:10], textLine))
                            if not self.__ProcessReportTextLine(fileName, textLine, \
                                                                infileLineNum, dataLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            # print(self.__fieldDataDict)
                            continue

                        if ' TR ID: ' in textLine:
                            # Note: Not all transactions have a transaction ID
                            dataLineNum = 3    # A flag to indicate data type on this line
                            dataTextLines = dataTextLines + 1
                            # print('-- search {0}\n{1}'.format(textLine[7:10], textLine))
                            if not self.__ProcessReportTextLine(fileName, textLine, \
                                                                infileLineNum, dataLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)

                            # Set the flag to indicate the transaction ID was captured
                            # Not all transactions have the TRAN_ID, so in cases where it
                            # is not there we need to add it to the data dictionary.
                            tranIdExist = True
                            # print(self.__fieldDataDict)
                            continue

                        # This is the part of the report that summarizes a set of
                        # transactionsfor a given affiliate ID
                        if ' AFFILIATE ID: ' in textLine:
                            # At this point we have data of the last transaction in the
                            # grouped data set, so add the row dictionary data into a
                            # list. Make sure the TRAN_ID was captured, Otherwise, set
                            # it to blank.
                            if not tranIdExist:
                                self.__fieldDataDict['TRAN_ID'] = ''

                            dictKeyNumber = dictKeyNumber + 1
                            self.__nestedFieldDataDict[dictKeyNumber] = \
                                                    self.__fieldDataDict.copy()
                            # Set the flag for the next first record
                            isFirstRecord = True

                            dataTextLines = dataTextLines + 1
                            self.__listDataDict.insert(listIndex, \
                                                       self.__nestedFieldDataDict.copy())
                            listIndex = listIndex + 1
                            totalInnerDictionariesAdded = totalInnerDictionariesAdded + \
                                                          dictKeyNumber
                            totalNestedDictionariesAdded = totalNestedDictionariesAdded + 1
                            totalListItemsAdded = totalListItemsAdded + 1
                            # Set the dictionary key number to zero and clear the
                            # dictionaries.
                            dictKeyNumber = 0
                            self.__fieldDataDict.clear()
                            self.__nestedFieldDataDict.clear()

                            if not self.__ProcessCountLines(fileName, textLine, \
                                                            infileLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)

                            continue

                        if 'CREDITS       :' in textLine:
                            if not self.__ProcessCountLines(fileName, textLine, \
                                                            infileLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            continue

                        if 'SUBTOTAL      :' in textLine:
                            if not self.__ProcessCountLines(fileName, textLine, \
                                                            infileLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            continue

                        if 'NON FINANCIAL :' in textLine:
                            if not self.__ProcessCountLines(fileName, textLine, \
                                                            infileLineNum):
                                self.__lineNum = GetLineNo() - 2
                                self.__errorMessage = \
                                    localErrorMessageOne.format(infileLineNum, fileName, \
                                                                self.__lineNum, __file__)
                                raise LocalException(self.__errorMessage)
                            continue

                    # Validate the data counts
                    if not self.__ValidateDataCounts():
                        self.__lineNum = GetLineNo() - 1
                        self.__errorMessage = \
                            'An error occurred validating the Visa debit report summary ' \
                            'counts and totals in __ParseFile() method at Line # {0} in ' \
                            'Module: {1}. '.format(self.__lineNum, __file__)
                        raise LocalException(self.__errorMessage)

                    # Write the data to the csv file
                    if not self.__WriteDataDictToCsvFile():
                        self.__lineNum = GetLineNo() - 1
                        self.__errorMessage = \
                            'An error occurred writing the data to a CSV file in ' \
                            '__ParseFile() method at Line # {0} in ' \
                            'Module: {1}. '.format(self.__lineNum, __file__)
                        raise LocalException(self.__errorMessage)

                # for listItem in self.__listDataDict:
                    # for dictKey in listItem:
                        # print('Key = {0} : {1}'.format(dictKey, listItem[dictKey]))

                # This is an info  message, so set the debug level to INFO
                if not self.__loggerObj.ResetLoggingLevel('INFO'):
                    return False

                self.__formatBuffer = \
                    '            REPORT STATS:\n            ' \
                    '     Total Number of Text Lines in File        : {0}\n            ' \
                    '     Report Lines Processed                    : {1}\n            ' \
                    '     Header Lines Processed                    : {2}\n            ' \
                    '     Data Text Lines Processed                 : {3}\n            ' \
                    '     Total Number of Inner Dictionaries Added  : {4}\n            ' \
                    '     Total Number of Nested Dictionaries Added : {5}\n            ' \
                    '     Total Number of List Items Added          : ' \
                    '{6}'.format(infileLineNum, dataReportLines, dataHeaderLines, \
                                 dataTextLines, totalInnerDictionariesAdded, \
                                 totalNestedDictionariesAdded, totalListItemsAdded)
                print(self.__formatBuffer)

                if self.__loggerObj and not self.__loggerObj.LogMessage( \
                        '\n{0}\n'.format(self.__formatBuffer), 'BODY'):
                    return False

                # Reset the logging level to what was originally set before
                # the error
                self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            return True
        except IOError as exceptError:
            errorNum, errorString = exceptError.args
            self.__lineNum = GetLineNo() - 2
            self.__formatBuffer = \
                    ('Error occurred in {0} Module __ParseFile() method at line #: ' \
                    '{1}: I/O error reading file: {2}. ({3}): {4}{5}')
            self.__errorMessage = \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                    fileName, errorNum, errorString, '')

            print(self.__FormatMessage( \
                self.__errorMessage, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, fileName, \
                                               errorNum, errorString, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before
            # the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

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
            self.__emailBodyText = exceptionError.value
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report '\
                                            'text file {0}'.format(fileName)
            if not self.__SendMailMessage():
                return False
            return False
        except ValueError as valueException:
            print(self.__FormatMessage( \
                str(valueException), width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                return False

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage('{0}{1}'.format(str(valueException), '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                return False

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailBodyText = str(valueException)
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report ' \
                                           'text file {0}'.format(fileName)
            if not self.__SendMailMessage():
                return False
            return False
        else:
            return False


    # ****************************************************************************************

    def __ReadVisaConfigFile(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ReadVisaConfigFile():
                Reads the visa_sms601c_config.cfg file to obtain the starting and ending
                columns for the data extract and populates a dictionary with the values.

            Parameters:
                None

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        """

        try:
            basePath = os.path.dirname(os.path.abspath(__file__))
            if self.__fieldConfigFile:
                configFile = os.path.join(basePath, self.__fieldConfigFile)

            # print('ConfigPath: ', configFile, '\n')

            self.__formatBuffer = None
            # Get the remote server name from the environment variable
            self.__remoteServerName = os.environ.get('CLEARING_HOST_NAME')
            # Create the ConfigParser object. Use RawConfigParser() with allow_no_value
            # set to True for section attributes with no value.
            if os.path.exists(configFile):
                configObj = configparser.RawConfigParser(allow_no_value=True)
                configObj.read(configFile)

                configSectNames = configObj.sections()

                for eachSection in configSectNames:
                    self.__lineNum = GetLineNo() - 1
                    # By pass sections not related to column information
                    if eachSection in ('REMOTE_FILE_PATH', \
                                       'REMOTE_FILE_NAME', 'REPORT_LINES', \
                                       'OUT_FILE_PATTERN'):
                        if eachSection == 'OUT_FILE_PATTERN':
                            self.__filePattern = \
                                configObj[eachSection]['outFilePattern'].replace('\'', '')
                        continue
                    self.__lineNum = GetLineNo() - 1
                    if eachSection not in self.__columnList:
                        # print('eachSection: {0}'.format(eachSection))
                        self.__formatBuffer = \
                            ('Config section {0} not found. Please check the ' \
                            'arguments provided for initializing the config object. ' \
                            'Error occurred in {1} module __ReadVisaConfigFile() ' \
                            'method at Line #: {2}.{3}')

                        self.__errorMessage = \
                                self.__formatBuffer.format(eachSection, \
                                                __file__, self.__lineNum, '')

                        # This is an error  message, so set the debug level to ERROR
                        if not self.__loggerObj.ResetLoggingLevel('ERROR'):
                            return False

                        # Log to the log file only if the logger object was created.
                        self.__lineNum = GetLineNo() + 1
                        if self.__loggerObj and not self.__loggerObj.LogMessage( \
                            self.__FormatMessage( \
                                self.__formatBuffer.format(eachSection, __file__, \
                                                        self.__lineNum, '\n'), \
                                width=80, initial_indent='\n            ', \
                                subsequent_indent=' ' * 12, \
                                break_long_words=False, \
                                break_on_hyphens=False), 'BODY'):
                            return False

                        # Reset the logging level to what was originally set before
                        # the error
                        self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

                        raise LocalException(self.__errorMessage)

                    # print('eachSection: {0}'.format(eachSection))
                    tempDict = {}
                    # tempDict.update({'START_COL': configObj[eachSection]['START_COL'], \
                                        # 'END_COL': configObj[eachSection]['END_COL']})
                    tempDict.update({'FIELD_NAME': eachSection, \
                                     'START_COL': configObj[eachSection]['START_COL'], \
                                     'END_COL': configObj[eachSection]['END_COL']})

                    # print('tempDict: {0}'.format(tempDict))
                    self.__listConfigDict.append(tempDict)

                # Print dictionary elements. Leave the code, it will be handy to debug
                # for listItem in self.__listConfigDict:
                    # for dictItem in listItem:
                        # if dictItem == 'FIELD_NAME':
                            # fieldName = listItem[dictItem]
                        # if dictItem == 'START_COL':
                            # startPos = listItem[dictItem]
                        # if dictItem == 'END_COL':
                            # endPos = listItem[dictItem]
                    # print('FIELD_NAME {0}: START_COL = {1}  END_COL = ' \
                          # '{2}'.format(fieldName, startPos, endPos))
            return True
        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # Send an alert email
            self.__emailBodyText = self.__errorMessage
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report '\
                                           'Field Config File in ' \
                                           '{0} module'.format(__file__)
            if not self.__SendMailMessage():
                return False
            return False
        except (configparser.NoSectionError, configparser.NoOptionError,
                configparser.DuplicateSectionError,
                configparser.MissingSectionHeaderError,
                configparser.ParsingError, configparser.Error) \
                as exceptionError:
            self.__lineNum = GetLineNo() - 5
            self.__formatBuffer = \
                ('Error occurred in {0} module __ReadVisaConfigFile() ' \
                 'method at Line #: {1}. Error message: {2}.{3}')
            print(self.__FormatMessage( \
                        self.__formatBuffer.format(__file__, \
                                    self.__lineNum, exceptionError.message, ''), \
                        width=80, initial_indent='\n    ', \
                        subsequent_indent=' ' * 4, break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # This is an error  message, so set the debug level to ERROR
            self.__loggerObj.ResetLoggingLevel('ERROR')

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage( \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                        exceptionError.message, '\n'), \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailBodyText = \
                    self.__formatBuffer.format(__file__, self.__lineNum, \
                                               exceptionError.message, '')
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report '\
                                           'Field Config File in ' \
                                           '{0} module'.format(__file__)

            self.__lineNum = GetLineNo() + 1
            if not self.__SendMailMessage():
                sys.exit()

            # configparser exceptions, so exit the program
            sys.exit()
        else:
            return True


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
            self.__emailBodyText = exceptError
            self.__emailSubjectText = 'Exception: Parsing VISA Debit Report '\
                                            'Field Config File module - ' \
                                            '{0}'.format(__file__)
            if not self.__SendMailMessage():
                return False
            return False
        else:
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
                'for the Visa SMS601C Parser.')

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
                    help='The visa SMS601C file name to parse.', \
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
            # print('fileName <{0}>'.format(fileName))

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
            self.__emailBodyText = self.__formatBuffer
            self.__emailSubjectText = 'Exception: Setting log file handlers'

            if not self.__SendMailMessage():
                return False

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

    def ProcFile(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ProcFile(self):
                Calls the __ReadVisaConfigFile() method to read the config file to get the
                field starting and ending column positions and calls the __ParseFile()
                method to extract data from the file.

            Parameters:
                None.

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Get the arguments passed to the program. Note that the verbosityLevel is the number
        # of -v options that the program is called with. For example -v is 1 and -vv is 2 and
        # -vvv is 3 so on and so forth. logType is either LOGFILE or CONSOLE depending on
        # where you want to log the messages.
        showUsage, verbosityLevel, self.__runMode, fileName = self.__GetArgs()

        # Check if you want to print the usage
        if showUsage:
            PrintUsage()
            sys.exit()

        # Call function to create the logging object and initialize the parameters as necessary.
        if not self.__CreateLogger(verbosityLevel):
            return False

        filesToParse = False
        print('\n\nReport Run Date: ' \
              '{0}\n'.format(datetime.now().strftime('%Y/%m/%d %H:%M:%S')))

        print('1. ProcFile(): fileName: {0}\n'.format(fileName))
        # Read the config file to get field start and end column positions
        if self.__ReadVisaConfigFile():
            if fileName:
                # Call a method to parse the visa debit transactions file
                if not self.__ParseFile(fileName):
                    # Archive and remove the input file eventhough it is an error
                    if not self.__EncryptAndArchive(fileName):
                        return False
                    return False

                # Archive and remove the input file
                if not self.__EncryptAndArchive(fileName):
                    return False

                self.__LogEndMessage('Successfully parsed file: {}.'.format(fileName))
            else:
                # Look for file patterns with INVS.PDCTF01.????.001.????????.out and
                # process them (INVS.PDCTF01.0132.001.20200511.out)
                print('self.__filePattern: {0}\n'.format(self.__filePattern))
                for fileName in glob.glob(self.__filePattern):
                    print('Input File: {0}\n'.format(fileName))
                    # Clear the common data dictionaries prior to processing file(s)
                    self.__nestedFieldDataDict.clear()
                    self.__sectionTotalsDict.clear()
                    self.__listDataDict.clear()
                    self.__listSectionTotals.clear()
                    # Call a method to parse the visa debit transactions file
                    if not self.__ParseFile(fileName):
                        # Archive and remove the input file eventhough it is an error
                        if not self.__EncryptAndArchive(fileName):
                            return False
                        return False

                    # Archive and remove the input file
                    if not self.__EncryptAndArchive(fileName):
                        return False

                    self.__LogEndMessage('Successfully parsed file: {}.'.format(fileName))
                    filesToParse = True
        else:
            return False

        # Check to see if any files were parsed
        if not filesToParse:
            self.__formatBuffer = 'No SMS601C input files to process today. Please ' \
                                  'verify if any files were downloaded from the ' \
                                  'clearing ({0}) server.'.format(self.__remoteServerName)
            print(self.__FormatMessage(str(self.__formatBuffer), \
                        width=80, initial_indent='\n    ', \
                        subsequent_indent=' ' * 4, break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # This is not an error  message, so set the debug level to INFO
            self.__loggerObj.ResetLoggingLevel('INFO')

            # Log to the log file only if the logger object was created.
            if self.__loggerObj and not self.__loggerObj.LogMessage( \
                self.__FormatMessage(self.__formatBuffer, \
                    width=80, initial_indent='\n            ', \
                    subsequent_indent=' ' * 12, \
                    break_long_words=False, \
                    break_on_hyphens=False), 'BODY'):
                sys.exit()

            # Reset the logging level to what was originally set before the error
            self.__loggerObj.ResetLoggingLevel(self.__loggingLevel)

            # Send an alert email
            self.__emailBodyText = self.__formatBuffer
            self.__emailSubjectText = \
                    str('Warning: No VISA Debit Report files to process today')
            if not self.__SendMailMessage(isAlert=False):
                sys.exit()

        return True


    # ****************************************************************************************

    def __init__(self):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Initializes the sms601cParserClass class object.

            Parameters:
                None.

            Returns:
                None.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__lineNum = 0
        self.__fieldConfigFile = 'visa_sms601c_config.cfg'
        self.__formatBuffer = None


# If calling the script standalone add the following code.
if __name__ == '__main__':
    smsParserObj = sms601cParserClass()
    smsParserObj.ProcFile()
    # Print the files older than 90 days
    PrintOlderFiles()
