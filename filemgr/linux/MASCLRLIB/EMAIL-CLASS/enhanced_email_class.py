#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
A general purpose Python class for creating and sending emails.
    $Id: enhanced_email_class.py 4590 2020-04-05 18:34:17Z lmendis $
"""

# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
import mimetypes
from email.mime.multipart import MIMEMultipart
from email import encoders
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText

import configparser
import sys
import os
import ast
import inspect      # For inspecting the current frame
import textwrap
import socket

# Add pylint directives to suppress warnings you don't want it to report
# as warnings. Note they need to have the hash sign as shown below.
# pylint: disable = unbalanced-tuple-unpacking
# pylint: disable = invalid-name
# pylint: disable = bare-except
# pylint: disable = pointless-string-statement


class LocalException(Exception):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A local exception class to post exceptions local to this module.

            The local exception class is derived from the Python base exception class. It is
            used to throw other types of exceptions that are not in the standard exception
            class.

        Author:
            Leonard Mendis

        Date Created:
            April 05, 2020

        Modified By:

        References:
            https://www.geeksforgeeks.org/user-defined-exceptions-python-examples/

    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)


class EnhancedEmailClass(object):
    """
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Description:
            A general purpose email class for generating and sending email messages.

        Author:
            Leonard Mendis

        Date Created:
            April 05, 2020

        Modified By:

        References:
            https://docs.python.org/3.4/library/email-examples.html
            https://www.blog.pythonlibrary.org/2013/06/26/python-102-how-to-send-an-email-using-smtplib-email/
            https://www.tutorialspoint.com/python/python_sending_email.htm
            https://medium.freecodecamp.org/send-emails-using-code-4fcea9df63f
            https://www.webcodegeeks.com/python/python-send-email-example/
            https://docs.python.org/3.4/library/email-examples.html
            ConfigParser():
                https://docs.python.org/2/library/configparser.html
                https://docs.python.org/3/library/configparser.html#rawconfigparser-objects
            Lists in ConfigParser():
                https://stackoverflow.com/questions/335695/lists-in-configparser
            ConfigParser() items to dictionary:
                https://stackoverflow.com/questions/1773793/convert-configparser-items-to-dictionary
            ConfigParser() Reading Sections and Option values:
                https://www.safaribooksonline.com/library/view/python-cookbook-3rd/9781449357337/ch13s10.html
                https://pymotw.com/2/ConfigParser/
            Creating Email and MIME objects:
                https://docs.python.org/2/library/email.mime.html
                https://stackoverflow.com/questions/23171140/how-do-i-send-an-email-with-a-csv-attachment-using-python
                http://denis.papathanasiou.org/posts/2010.09.04.post.html

    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Private class attributes
    __errorMessage = None       # Attribute to hold error messages
    __emailTextFile = None      # Email Text file name
    __emailMessage = None       # Email message
    __emailTo = []              # List for multiple email to addresses
    __emailToBuffer = None      # String to hold multiple email to addresses
    __emailFrom = []            # List for multiple email from addresses
    __emailFromBuffer = None    # String to hold multiple email from addresses
    __emailCopy = []            # List for multiple email copy addresses
    __emailCcBuffer = None      # String to hold multiple email CC addresses
    __emailBlindCopy = []       # List for multiple email Bcc addresses
    __emailBccBuffer = None     # String to hold multiple email BCC addresses
    __emailSubject = None       # Email subject line
    __emailBody = None          # Email body
    __emailConfig = None        # Config file to read email from
    __configSection = None      # Config section name to read email parameters
    __emailFilesPath = None     # Folder to attach files from
    __emailFilesList = []       # List of file names to attach to the email
    __isEmailObjCreated = False # Flag to check if email is created
    __moduleName = 'enhanced_email_class.py'  # Module name
    __formatBuffer = None       # A buffer to format message strings
    __smtpServerName = None     # SMTP server name
    __useSmtpSsl = None         # Use secure socket layer

    # Error code descriptions
    __errorDesc_1 = None
    __errorDesc_2 = None
    __errorDesc_3 = None
    __errorDesc_4 = None
    __errorDesc_5 = None
    __errorDesc_6 = None
    __errorDesc_7 = None
    __errorDesc_8 = None
    __errorDesc_9 = None
    __errorDesc_10 = None
    __errorDesc_11 = None
    __errorDesc_12 = None
    __errorDesc_13 = None
    __errorDesc_14 = None
    __errorDesc_15 = None
    __errorDesc_16 = None
    __errorDesc_17 = None
    __errorDesc_18 = None
    __errorDesc_19 = None

    # Public class attributes
    errorCode = 0   # Error code for debugging purposes
    lineNum = 0     # Current source code line number where the error occurred


    # ****************************************************************************************
    # ----------------------             GetErrorDescription()           ---------------------
    def GetErrorDescription(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            GetErrorDescription():
                Returns the error description for a given error code in case the calling
                program needs to know what the error is. You can also get the error code
                via the class object and trace back the error to that location in the code.

            Parameters:
                None.

            Returns: Email object error description.

        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        errorList = [self.__errorDesc_1, self.__errorDesc_2, \
                    self.__errorDesc_3, self.__errorDesc_4, \
                    self.__errorDesc_5, self.__errorDesc_6, \
                    self.__errorDesc_7, self.__errorDesc_8, \
                    self.__errorDesc_9, self.__errorDesc_10, \
                    self.__errorDesc_11, self.__errorDesc_12, \
                    self.__errorDesc_13, self.__errorDesc_14, \
                    self.__errorDesc_15, self.__errorDesc_16, \
                    self.__errorDesc_17, self.__errorDesc_18]

        # Make sure there is an error and the error code is within the list boundary
        if self.errorCode and (self.errorCode <= len(errorList)):
            # print('GetErrorDescription(): %d - %s' % \
            #         (self.errorCode, errorList[self.errorCode - 1]))
            return errorList[self.errorCode - 1]

        return None


    # ****************************************************************************************
    # ----------------------                  GetLineNo()                ---------------------
    def GetLineNo(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            GetLineNo():
                Returns the current line number of the executing code.

            Parameters:
                None.

            Returns: Current line number in the code.

        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        # Use the currentframe and get the line number of the excuting code.
        return inspect.currentframe().f_back.f_lineno


    # ****************************************************************************************
    # --------------------               __FormatMessage()                --------------------
    def __FormatMessage(self, unwrappedText, **keywordArgs):
        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __FormatMessage():
                Formats a message string using Python's TextWrapper() built-in function.

            Parameters:
                unwrappedText - Unwrapped text needing formatting.
                keywordArgs   - Text wrapper arguments.
                    width
                        - The line width to wrap the text message at. Default is 70 characters.
                    expand_tabs
                        - Do tabs need to be expanded to spaces. Default is True.
                    replace_whitespace
                        - Do each whitespace character after the tab need to be replaced by a
                          single whitespace. Default is True.
                    drop_whitespace
                        - Do white spaces after wrapping at the beginning and end of a line
                          need to be dropped. Default is True.
                    initial_indent
                        - String that will be prepended to the first line of wrapped output.
                          Default is ''.
                    subsequent_indent
                        - String that will be prepended to all lines of wrapped output except
                          the first. Default is ''.
                    fix_sentence_endings
                        - Attempts to detect sentence endings and ensure that sentences are
                          always separated by exactly two spaces. This is generally desired
                          for text in a mono spaced font. However, the sentence detection
                          algorithm is imperfect. Default is False.
                    break_long_words
                        - Do words longer than width need be broken in order to ensure that
                          no lines are longer than width. Default is True.
                    break_on_hyphens
                        - Does wrapping need to occur on white spaces and right after hyphens
                          in compound words. Default is                           True.
            Returns:
                The wrapped text.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """
        # The following are all the default local variables corresponding to the named
        # arguments in the TextWrapper() function.
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
                        'Invalid keyword passed to the __FormatMessage() method in {0} ' \
                        '{1}{2}module{3}at Line #: {4}.\n')
                    print(self.__formatBuffer.format( \
                            __file__, '', '', '\n', self.lineNum))

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
    # ----------------------              PrintEmailParams()             ---------------------

    def PrintEmailParams(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            PrintEmailParams():
                Prints the email parameters for debugging.

            Parameters:
                None.

            Returns: None.

        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__formatBuffer = ('self.__errorMessage:\n    {0}\n' \
                        'self.__emailTextFile:\n    {1}\n' \
                        'self.__emailMessage:\n    {2}\n' \
                        'self.__emailTo:\n    {3}\n' \
                        'self.__emailToBuffer:\n    {4}\n' \
                        'self.__emailFrom:\n    {5}\n' \
                        'self.__emailFromBuffer:\n    {6}\n' \
                        'self.__emailCopy\n    {7}\n' \
                        'self.__emailCcBuffer:\n    {8}\n' \
                        'self.__emailBlindCopy:\n    {9}\n' \
                        'self.__emailBccBuffer:\n    {10}\n' \
                        'self.__emailSubject:\n    {11}\n' \
                        'self.__emailBody:\n    {12}\n' \
                        'self.__emailConfig:\n    {13}\n' \
                        'self.__configSection:\n    {14}\n' \
                        'self.__emailFilesPath:\n    {15}\n' \
                        'self.__emailFilesList:\n    {16}\n' \
                        'self.__smtpServerName:\n    {17}\n' \
                        'self.__useSmtpSsl:\n    {18}\n' \
                        'self.__isEmailObjCreated:\n    {19}')

        print(self.__formatBuffer.format(self.__errorMessage, self.__emailTextFile, \
                                self.__emailMessage, self.__emailTo, self.__emailToBuffer, \
                                self.__emailFrom, self.__emailFromBuffer, self.__emailCopy, \
                                self.__emailCcBuffer, self.__emailBlindCopy, \
                                self.__emailBccBuffer, self.__emailSubject, \
                                self.__emailBody, self.__emailConfig, self.__configSection, \
                                self.__emailFilesPath, self.__emailFilesList, \
                                self.__smtpServerName, self.__useSmtpSsl, \
                                self.__isEmailObjCreated))


    # ****************************************************************************************
    # ----------------------              ResetEmailParams()            ----------------------

    def ResetEmailParams(self, **keywordArgs):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ResetEmailParams():
                Resets the email parameters based on the parameters passed to the function.
                Note: This method is only intended to re-set the basic email parameters in
                case there is a need to change the email addresses etc. and not intended to
                create a whole different email object.

            Parameters:
                keywordArgs - Keyword arguments:
                                 RESET_EMAIL_TO - Reset the to address.
                                 RESET_EMAIL_FROM - Reset the from address.
                                 RESET_EMAIL_CC - Reset the CC address.
                                 RESET_EMAIL_BCC - Reset the BCC address.
                                 RESET_EMAIL_BODY - Reset the email body text.
                                 RESET_EMAIL_SUBJECT - Reset the email subject
                                                       text.

            Returns: True if email parameters were reset successfully,
                     False else.

        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Make sure the email object is created before any files can be attached
            if not self.__isEmailObjCreated:
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = ( \
                        ('The SMPT email object has not been initialized. Please create ' \
                        'the email object prior to re-setting email parameters. Error ' \
                        'occurred in %s Module ResetEmailParams() method at line #: %d.') \
                        % (self.__moduleName, self.lineNum))
                self.errorCode = 18
                self.__errorDesc_18 = \
                            ('Error occurred in %s module at Line #: %d. The SMPT email ' \
                            'object has not been initialized.' \
                            % (self.__moduleName, self.lineNum))
                raise LocalException(self.__errorMessage)

            if keywordArgs:
                keywordDict = {}
                for keywordParam in keywordArgs:
                    keywordToUpper = keywordParam.upper()
                    # Add to the dictionary
                    keywordDict.update({keywordToUpper : keywordArgs[keywordParam]})

                    if keywordToUpper == 'RESET_EMAIL_TO':
                        self.__emailToBuffer = None
                        # Check the email address and format as necessary.
                        # if type(keywordDict[keywordToUpper]) is list:
                        if isinstance(keywordDict[keywordToUpper], list):
                            for listItems in keywordDict[keywordToUpper]:
                                if not self.__emailToBuffer:
                                    self.__emailToBuffer = listItems
                                else:
                                    self.__emailToBuffer = ('%s; %s' \
                                        % (self.__emailToBuffer, listItems))
                        # elif type(keywordDict[keywordToUpper]) is str:
                        elif isinstance(keywordDict[keywordToUpper], str):
                            self.__emailToBuffer = keywordDict[keywordToUpper]
                    elif keywordToUpper == 'RESET_EMAIL_FROM':
                        self.__emailFromBuffer = None
                        # Check the email address and format as necessary.
                        # if type(keywordDict[keywordToUpper]) is list:
                        if isinstance(keywordDict[keywordToUpper], list):
                            for listItems in keywordDict[keywordToUpper]:
                                if not self.__emailFromBuffer:
                                    self.__emailFromBuffer = listItems
                                else:
                                    self.__emailFromBuffer = ('%s; %s' \
                                        % (self.__emailFromBuffer, listItems))
                        # elif type(keywordDict[keywordToUpper]) is str:
                        elif isinstance(keywordDict[keywordToUpper], str):
                            self.__emailFromBuffer = \
                                                keywordDict[keywordToUpper]
                    elif keywordToUpper == 'RESET_EMAIL_CC':
                        self.__emailCcBuffer = None
                        # Check the email address and format as necessary.
                        # if type(keywordDict[keywordToUpper]) is list:
                        if isinstance(keywordDict[keywordToUpper], list):
                            for listItems in keywordDict[keywordToUpper]:
                                if not self.__emailCcBuffer:
                                    self.__emailCcBuffer = listItems
                                else:
                                    self.__emailCcBuffer = ('%s; %s' \
                                        % (self.__emailCcBuffer, listItems))
                        # elif type(keywordDict[keywordToUpper]) is str:
                        elif isinstance(keywordDict[keywordToUpper], str):
                            self.__emailCcBuffer = keywordDict[keywordToUpper]
                    elif keywordToUpper == 'RESET_EMAIL_BCC':
                        self.__emailBccBuffer = None
                        # Check the email address and format as necessary.
                        # if type(keywordDict[keywordToUpper]) is list:
                        if isinstance(keywordDict[keywordToUpper], list):
                            for listItems in keywordDict[keywordToUpper]:
                                if not self.__emailBccBuffer:
                                    self.__emailBccBuffer = listItems
                                else:
                                    self.__emailBccBuffer = ('%s; %s' \
                                        % (self.__emailBccBuffer, listItems))
                        # elif type(keywordDict[keywordToUpper]) is str:
                        elif isinstance(keywordDict[keywordToUpper], str):
                            self.__emailBccBuffer = keywordDict[keywordToUpper]
                    elif keywordToUpper == 'RESET_EMAIL_BODY':
                        # Make sure to turn off reading the email body text
                        # from a file.
                        if self.__emailTextFile:
                            self.__emailTextFile = None
                        self.__emailBody = keywordDict[keywordToUpper]
                    elif keywordToUpper == 'RESET_EMAIL_SUBJECT':
                        self.__emailSubject = keywordDict[keywordToUpper]
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = \
                        (('No data provided to reset the email parameters. Error occurred ' \
                        'in %s Module ResetEmailParams() method at line #: %d.') \
                        % (self.__moduleName, self.lineNum))
                self.errorCode = 17
                self.__errorDesc_17 = \
                        ('Error occurred in %s module at Line #: %d. No data provided to ' \
                        'reset the email parameters.' % (self.__moduleName, self.lineNum))
                raise LocalException(self.__errorMessage)

        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            return False
        else:
            return True


    # ****************************************************************************************
    # ----------------------                 AttachFiles()               ---------------------

    def AttachFiles(self, **keywordArgs):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            AttachFile():
                Checks the keyword parameters and sets up the directory path and the list of
                files to be attached to the email.

            Parameters:
                keywordArgs - Keyword arguments:
                                ATTACH_FILES_FOLDER - Folder containing the files to attach.
                                ATTACH_FILES_LIST   - List of files to attach.

            Returns: True if files were attached, False else.

        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Make sure the email object is created before any files can be attached
            if not self.__isEmailObjCreated:
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = \
                        (('The SMPT email object has not been initialized. Please create ' \
                        'the email object prior to attaching files. Error occurred in %s ' \
                        'module AttachFiles() method at line #: %d.') \
                        % (self.__moduleName, self.lineNum))
                self.errorCode = 16
                self.__errorDesc_16 = \
                        ('Error occurred in %s module at Line #: %d. The SMPT email ' \
                        'object has not been initialized.' % (self.__moduleName, self.lineNum))
                raise LocalException(self.__errorMessage)

            if keywordArgs:
                keywordDict = {}
                for keywordParam in keywordArgs:
                    keywordToUpper = keywordParam.upper()
                    # Add to the dictionary
                    keywordDict.update({keywordToUpper : \
                                                keywordArgs[keywordParam]})

                    if keywordToUpper == 'ATTACH_FILES_FOLDER':
                        self.__emailFilesPath = keywordDict[keywordToUpper]
                    elif keywordToUpper == 'ATTACH_FILES_LIST':
                        # Make sure the the files to attach are passed as a list
                        # if type(keywordDict[keywordToUpper]) is not list:
                        if not isinstance(keywordDict[keywordToUpper], list):
                            self.lineNum = self.GetLineNo() - 1
                            self.__errorMessage = \
                                (('The files to attach must be a list. Please ensure it is ' \
                                'passed as a list. Error occurred in %s module AttachFiles() ' \
                                'method at line #: %d.') % (self.__moduleName, self.lineNum))

                            self.errorCode = 15
                            self.__errorDesc_15 = \
                                ('Error occurred in %s module at Line #: %d. The files to ' \
                                'attach must be a list.' % (self.__moduleName, self.lineNum))
                            raise LocalException(self.__errorMessage)
                        else:
                            self.__emailFilesList = keywordDict[keywordToUpper]

            else:
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = \
                    (('Insufficient parameter values for attaching files. Please check. Error ' \
                    'occurred in %s Module AttachFiles() method at line #: %d.') \
                    % (self.__moduleName, self.lineNum))
                self.errorCode = 14
                self.__errorDesc_14 = \
                    ('Error occurred in %s module at Line #: %d. Insufficient parameter values ' \
                    'for attaching files.' % (self.__moduleName, self.lineNum))
                raise LocalException(self.__errorMessage)

            # Attach files if any - Note the attachments must be passed as a list to
            # the method even if it is a single file.

            if self.__emailFilesList:
                for fileName in self.__emailFilesList:
                    emailFileWithPath = None
                    # If the email file path is not assume default directory
                    if not self.__emailFilesPath:
                        basePath = os.path.dirname(os.path.abspath(__file__))
                        # emailFileWithPath =
                        #       os.path.join(self.__emailFilesPath, fileName)
                        emailFileWithPath = ('%s/%s' % (basePath, fileName))
                    else:
                        emailFileWithPath = \
                                ('%s/%s' % (self.__emailFilesPath, fileName))

                    mimeEmailType, emailEncoding = \
                                    mimetypes.guess_type(emailFileWithPath)
                    if mimeEmailType is None or emailEncoding is not None:
                        mimeEmailType = 'application/octet-stream'

                    mainType, subType = mimeEmailType.split('/', 1)

                    if mainType == 'text':
                        fileHandle = open(emailFileWithPath)
                        # Note: we should handle calculating the charset
                        emailAttachment = \
                                MIMEText(fileHandle.read(), _subtype=subType)
                        fileHandle.close()
                    elif mainType == 'image':
                        fileHandle = open(emailFileWithPath, 'rb')
                        emailAttachment = \
                                MIMEImage(fileHandle.read(), _subtype=subType)
                        fileHandle.close()
                    elif mainType == 'audio':
                        fileHandle = open(emailFileWithPath, 'rb')
                        emailAttachment = \
                                MIMEAudio(fileHandle.read(), _subtype=subType)
                        fileHandle.close()
                    else:
                        fileHandle = open(emailFileWithPath, 'rb')
                        emailAttachment = MIMEBase(mainType, subType)
                        emailAttachment.set_payload(fileHandle.read())
                        fileHandle.close()
                        encoders.encode_base64(emailAttachment)

                    emailAttachment.add_header( \
                                'Content-Disposition', 'emailAttachment', \
                                filename=fileName)
                    self.__emailMessage.attach(emailAttachment)
            else:
                self.lineNum = self.GetLineNo() - 1
                print('    Email Files list is empty. Error occurred in %s module ' \
                      'AttachFiles() method at line #: %d.\n' \
                      % (self.__moduleName, self.lineNum))

        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
            return False
        except smtplib.SMTPException as exceptionError:
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = ( \
                'Error occurred in {0} module AttachFiles() method at line #: {1}. ' \
                'Error: {2}')
            self.__errorMessage = \
                self.__FormatMessage( \
                        self.__formatBuffer.format( \
                            self.__moduleName, self.lineNum, \
                            str(exceptionError)), \
                width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False)
            print(self.__errorMessage, '\n')
            self.errorCode = 13
            self.__errorDesc_13 = \
                    ('Error occurred in %s module at Line #: %d. SMTP Error: %s.' \
                    % (self.__moduleName, self.lineNum, str(exceptionError)))
            return False
        else:
            return True


    # ****************************************************************************************
    # ----------------------            __ReadEmailTextFile()           ----------------------

    def __ReadEmailTextFile(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __ReadEmailTextFile():
                Reads the email body text from a file.

            Parameters:
                None.

            Returns:
                True if email text was successfully read from the file,
                False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            self.__formatBuffer = None

            # Open a plain text file for reading. Assume the text file
            # contains only ASCII characters.
            with open(self.__emailTextFile, 'r') as fileHandle:
                # Attach the contents of the file to the email object
                self.__emailMessage.attach(MIMEText(fileHandle.read(), 'plain'))

        except IOError as exceptError:
            errorNum, errorString = exceptError.args
            self.lineNum = self.GetLineNo() - 2
            self.__formatBuffer = \
                    ('Error occurred in {0} Module __ReadEmailTextFile() method at line #: ' \
                    '{1}: I/O error reading file: {2} ({3}): {4}')
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum, \
                    self.__emailTextFile, errorNum, errorString)
            self.errorCode = 12
            self.__errorDesc_12 = \
                    ('Error occurred in %s module at Line #: %d. I/O error reading email ' \
                    'text from file.' % (self.__moduleName, self.lineNum))
            return False
        except ValueError:
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                    ('Error occurred in {0} Module __ReadEmailTextFile() method at line #: ' \
                    '{1}: Value error.')
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.errorCode = 11
            self.__errorDesc_11 = \
                    ('Error occurred in %s module at Line #: %d. Value error reading email ' \
                    'text from file.' % (self.__moduleName, self.lineNum))
            return False
        except:
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                    ('Error occurred in {0} Module __ReadEmailTextFile() method at line #: ' \
                    '{1}: Unexpected error: {2}')
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, \
                                        self.lineNum, sys.exc_info()[0])
            self.errorCode = 10
            self.__errorDesc_10 = \
                    ('Error occurred in %s module at Line #: %d. Unexpected error reading ' \
                    'email text from file.' % (self.__moduleName, self.lineNum))
            return False
        else:
            # Close the file.
            fileHandle.close()
            return True


    # ****************************************************************************************
    # -------------------------              SendEmail()             -------------------------

    def SendEmail(self, resendMail=False):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            SendEmail():
                Constructs the email object and sends the mail to the recipients extracted
                from the enhanced_email_config.ini file or as provided at the time of email
                object initialization.

            Parameters:
                resendMail - Flag to indicate if another email needs to be sent. This is
                             required to recreate the email object because the smtp server
                             gets closed once an email is sent out.

            Returns:
                True if successful, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            self.__formatBuffer = None

            # If resending another email, make sure the smtp email object is created. Otherwise,
            # it would not work because the previous email that was sent closes the smtp server
            # when the smtpServer.quit() is called in this function.
            if resendMail is True:
                self.lineNum = self.GetLineNo() + 1
                self.__emailMessage = MIMEMultipart('alternative')

            # Construct the email message
            self.__emailMessage['To'] = self.__emailToBuffer
            self.__emailMessage['From'] = self.__emailFromBuffer
            self.__emailMessage['CC'] = self.__emailCcBuffer
            self.__emailMessage['BCC'] = self.__emailBccBuffer
            self.__emailMessage['Subject'] = self.__emailSubject

            # Check if the email body text comes from a text file.
            # print('File to read email body: {0}\n'.format(self.__emailTextFile))
            if self.__emailTextFile:
                self.lineNum = self.GetLineNo() + 1
                if not self.__ReadEmailTextFile():
                    self.__formatBuffer = None
                    self.__errorMessage = ( \
                        'Unable to read email text file - {%s}. Error occurred in the ' \
                        'SendEmail() method in {%s} module at Line #: {%d}.' \
                        % (self.__emailTextFile, self.__moduleName, self.lineNum))

                    self.errorCode = 9
                    self.__errorDesc_9 = \
                        ('Error occurred in %s module at Line #: %d. Unable to read the ' \
                            'email text file.' % (self.__moduleName, self.lineNum))

                    raise LocalException(self.__errorMessage)
            elif self.__emailBody:
                # This can be 'plain' or 'text' for the email body text to be printed.
                self.lineNum = self.GetLineNo() + 1
                self.__emailMessage.attach(MIMEText(self.__emailBody, 'plain'))
                # self.__emailMessage.attach(MIMEText(str(self.__emailBody), 'text'))

            # If the smtp name is not provided in the config file, use localhost without SSL.
            if not self.__smtpServerName:
                self.lineNum = self.GetLineNo() + 1
                smtpServer = smtplib.SMTP('localhost')
            else:
                # Note: Use the smtp server provided in the enhanced_email_config.ini file.
                #       Ex. SMTP_SERVER_NAME = ['smtp.jetpay.com']
                # Make sure you strip the quotes and other known caracters in the email config
                # file assignment for the SMTP server,
                smtpServerNameText = \
                            self.__smtpServerName.strip('\"\'()[]')
                # Use SSL if user forces the app to send email using SSL
                if self.__useSmtpSsl:
                    self.lineNum = self.GetLineNo() + 1
                    smtpServer = smtplib.SMTP_SSL(smtpServerNameText)
                else:
                    self.lineNum = self.GetLineNo() + 1
                    smtpServer = smtplib.SMTP(smtpServerNameText)

            self.lineNum = self.GetLineNo() + 1
            smtpServer.send_message(self.__emailMessage)

            self.lineNum = self.GetLineNo() + 1
            smtpServer.quit()

        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')

            # An error occurred while ttying to send the email, so print the parameters
            self.PrintEmailParams()
            return False
        except smtplib.SMTPException as exceptionError:
            self.__formatBuffer = \
                    ('Error occurred in {0} Module SendEmail() method at line #: {1}. ' \
                    'Error: {2}')
            self.__errorMessage = \
                self.__FormatMessage( \
                    self.__formatBuffer.format(self.__moduleName, \
                                        self.lineNum, str(exceptionError)), \
                width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False)
            print(self.__errorMessage, '\n')

            self.errorCode = 8
            self.__errorDesc_8 = \
                    ('Error occurred in %s module at Line #: %d. SMTP Error: %s.' \
                    % (self.__moduleName, self.lineNum, str(exceptionError)))

            # An error occurred while ttying to send the email, so print the parameters
            self.PrintEmailParams()

            return False
        else:
            return True


    # ****************************************************************************************
    # -----------------------           __CheckEmailAddresses()         ----------------------

    def __CheckEmailAddresses(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __CheckEmailAddresses():
                Checks if the required as well as non required email addresses are present and
                builds the address strings to include single and multiple email addresses.

            Parameters:
                None.

            Returns:
                True if email addresses are validated and the email address strings are
                formatted accordingly. Flase else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        self.__formatBuffer = None

        # Now construct a string containing all the email to addresses. The email to address
        # is required to send email.
        if not self.__emailTo:
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                    ("Email To: address is required to send emails. Please add it " \
                    "to the 'enhanced_email_config.ini' file or provide it as a " \
                    "to the email object at the time of initializing it and try " \
                    "again. Error occurred in module {0} __CheckEmailAddresses() " \
                    "method at line #: {1}")
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.errorCode = 7
            self.__errorDesc_7 = \
                    ('Error occurred in %s module at Line #: %d. Missing email To " \
                    "address.' % (self.__moduleName, self.lineNum))
            return False
        # elif type(self.__emailTo) is list:
        elif isinstance(self.__emailTo, list):
            for listItems in self.__emailTo:
                if not self.__emailToBuffer:
                    self.__emailToBuffer = listItems
                else:
                    self.__emailToBuffer = \
                            ('%s; %s' % (self.__emailToBuffer, listItems))
        # elif type(self.__emailTo) is str:
        elif isinstance(self.__emailTo, str):
            self.__emailToBuffer = self.__emailTo

        # print(self.__emailToBuffer)

        # Now construct a string containing all the email from addresses. The email from
        # address is required to send email.
        if not self.__emailFrom:
            self.lineNum = self.GetLineNo() - 1
            self.__formatBuffer = \
                    ("Email From: address is required to send emails. Please add it " \
                    "'to the 'enhanced_email_config.ini' file or provide it as a " \
                    "parameter to the email object at the time of initializing it and " \
                    "try again. Error occurred in module {0} __CheckEmailAddresses() " \
                    "at line #: {1}")
            self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
            self.errorCode = 6
            self.__errorDesc_6 = \
                    ('Error occurred in %s module at Line #: %d Missing email From ' \
                    'address.' % (self.__moduleName, self.lineNum))
            return False
        # elif type(self.__emailFrom) is list:
        elif isinstance(self.__emailFrom, list):
            for listItems in self.__emailFrom:
                if not self.__emailFromBuffer:
                    self.__emailFromBuffer = listItems
                else:
                    self.__emailFromBuffer = \
                            ('%s; %s' % (self.__emailFromBuffer, listItems))
        # elif type(self.__emailFrom) is str:
        elif isinstance(self.__emailFrom, str):
            self.__emailFromBuffer = self.__emailFrom

        # print(self.__emailFromBuffer)

        # Now construct a string containing all the email copy addresses. The email copy
        # address is not required to send email. Check if self.__emailCopy is a list
        if self.__emailCopy and isinstance(self.__emailCopy, list):
            for listItems in self.__emailCopy:
                if not self.__emailCcBuffer:
                    self.__emailCcBuffer = listItems
                else:
                    self.__emailCcBuffer = \
                            ('%s; %s' % (self.__emailCcBuffer, listItems))
        # Check if self.__emailCopy is str:
        elif isinstance(self.__emailCopy, str):
            self.__emailCcBuffer = self.__emailCopy

        # print(self.__emailCcBuffer)

        # Now construct a string containing all the email blind copy addresses. The email
        # blind copy address is not required to send email. Check if self.__emailBlindCopy
        # is a list:
        if self.__emailBlindCopy and isinstance(self.__emailBlindCopy, list):
            for listItems in self.__emailBlindCopy:
                if not self.__emailBccBuffer:
                    self.__emailBccBuffer = listItems
                else:
                    self.__emailBccBuffer = \
                            ('%s; %s' % (self.__emailBccBuffer, listItems))
        # elif type(self.__emailBlindCopy) is str:
        elif isinstance(self.__emailBlindCopy, str):
            self.__emailBccBuffer = self.__emailBlindCopy

        # print(self.__emailBccBuffer)

        return True


    # ****************************************************************************************
    # ---------------------          __GetEmailConfigurations()         ----------------------

    def __GetEmailConfigurations(self):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __GetEmailConfigurations():
                Reads the enhanced_email_config.ini file and gets the option values for each
                of the options under the section header provided during the email object
                initialization. Note that if any keyword parameter values are passed at the
                time of  initialization, it is assumed the default values in the email config
                file will NOT override those values. This means that any keyword arguments
                passed to the email object supersedes the default values in the config file.

            Parameters:
                None.

            Returns:
                True if the email configurations were read correctly, False else.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            basePath = os.path.dirname(os.path.abspath(__file__))
            if self.__emailConfig:
                configFile = os.path.join(basePath, self.__emailConfig)
            else:
                configFile = os.path.join(basePath, 'enhanced_email_config.ini')

            # print('ConfigPath: ', configFile, '\n')

            self.__formatBuffer = None

            # Create the ConfigParser object. Use RawConfigParser() with allow_no_value
            # set to True for section attributes with no value.
            if os.path.exists(configFile):
                configParserObj = \
                            configparser.RawConfigParser(allow_no_value=True)
                configParserObj.read(configFile)

                configSectNames = configParserObj.sections()
                sectionFound = False
                for eachSection in configSectNames:
                    if eachSection == self.__configSection:
                        sectionFound = True

                if not sectionFound:
                    self.lineNum = self.GetLineNo() - 1
                    self.__formatBuffer = \
                        ('Config section {0} not found. Please check the arguments ' \
                        'provided for initializing the email object. Error occurred ' \
                        'in {1} module __GetEmailConfigurations() method at Line #: {2}')

                    self.__errorMessage = \
                            self.__formatBuffer.format(self.__configSection, \
                                            self.__moduleName, self.lineNum)

                    self.errorCode = 5
                    self.__errorDesc_5 = \
                            ('Error occurred in %s module at Line #: %d. Unable to find ' \
                            'the specified %s config section.' \
                            % (self.__moduleName, self.lineNum, self.__configSection))
                    raise LocalException(self.__errorMessage)

                configOptions = configParserObj.options(self.__configSection)

                for sectionOptions in configOptions:
                    optionToUpper = sectionOptions.upper()

                    # Read and assign configuration values to the email class attributes.
                    # Note ast.leteral_eval() breaks up the literal values in a multi
                    # value config string like: OPTION = ['Value1', 'Value2', 'Value3']
                    if optionToUpper == 'TO_ADDRESS':
                        # Populate the Email To: address
                        emailToAddress = \
                                configParserObj.get(self.__configSection, \
                                                    'TO_ADDRESS')
                        if not self.__emailTo and emailToAddress \
                                and emailToAddress != '[]':
                            self.__emailTo = ast.literal_eval(emailToAddress)
                        # print('self.__emailTo = {0}\n'.format(self.__emailTo))
                    elif optionToUpper == 'FROM_ADDRESS':
                        # Populate the Email From: address
                        emailFromAddress = \
                                configParserObj.get(self.__configSection, \
                                                    'FROM_ADDRESS')
                        if not self.__emailFrom and emailFromAddress \
                                and emailFromAddress != '[]':
                            self.__emailFrom = ast.literal_eval(emailFromAddress)
                    elif optionToUpper == 'CC_ADDRESS':
                        # Populate the Email CC: address
                        emailCopyAddress = \
                                configParserObj.get(self.__configSection, \
                                                    'CC_ADDRESS')
                        if not self.__emailCopy and emailCopyAddress \
                                and emailCopyAddress != '[]':
                            self.__emailCopy = ast.literal_eval(emailCopyAddress)
                    elif optionToUpper == 'BCC_ADDRESS':
                        # Populate the Email BCC: address
                        emailBccAddress = \
                                configParserObj.get(self.__configSection, \
                                                    'BCC_ADDRESS')
                        if not self.__emailBlindCopy and emailBccAddress \
                                and emailBccAddress != '[]':
                            self.__emailBlindCopy = ast.literal_eval(emailBccAddress)
                    elif optionToUpper == 'EMAIL_SUBJECT':
                        # Populate the Email Subject line. Remove [] if any from string
                        subjectText = \
                            configParserObj.get(self.__configSection, \
                                                    'EMAIL_SUBJECT').translate( \
                                                            {ord(i): None for i in '[]'})
                        if not self.__emailSubject and subjectText:
                            self.__emailSubject = subjectText
                    elif optionToUpper == 'EMAIL_BODY':
                        # Populate the Email Body line. Remove [] if any from string
                        emailBodyText = \
                            configParserObj.get(self.__configSection, \
                                                'EMAIL_BODY').translate( \
                                                            {ord(i): None for i in '[]'})
                        # print('emailBodyText = {0}\n'.format(emailBodyText))
                        if not self.__emailBody and emailBodyText:
                            self.__emailBody = emailBodyText
                    elif optionToUpper == 'READ_EMAIL_TEXT_FROM_FILE':
                        # Populate the Email Text line. Remove [] if any from string
                        emailTextFile = \
                            configParserObj.get(self.__configSection, \
                                                'READ_EMAIL_TEXT_FROM_FILE').translate( \
                                                            {ord(i): None for i in '[]'})
                        if not self.__emailTextFile and emailTextFile:
                            self.__emailTextFile = emailTextFile
                    elif optionToUpper == 'SMTP_SERVER_NAME':
                        # Populate the SMTP Server line. Remove [] if any from string
                        smtpServerText = \
                            configParserObj.get(self.__configSection, \
                                                    'SMTP_SERVER_NAME').translate( \
                                                            {ord(i): None for i in '[]'})
                        if not self.__smtpServerName and smtpServerText:
                            self.__smtpServerName = smtpServerText
                    elif optionToUpper == 'USE_SMTP_SSL':
                        # Populate the SMTP Server library line. Remove [] if any from string
                        smtpSslText = \
                            configParserObj.get(self.__configSection, \
                                                    'USE_SMTP_SSL').translate( \
                                                            {ord(i): None for i in '[]'})
                        if not self.__useSmtpSsl and smtpSslText:
                            self.__useSmtpSsl = smtpSslText
                            # self.__useSmtpSsl is being set to a str value in the line above,
                            # so it needs to be converted into a boolean based on the str it is set to.
                            if self.__useSmtpSsl == 'True':
                                self.__useSmtpSsl = True
                            else:
                                self.__useSmtpSsl = False
                    else:
                        self.lineNum = self.GetLineNo() - 1
                        # Unknown option
                        self.__formatBuffer = \
                                ("Unknown configuration option in the " \
                                "'enhanced_email_config.ini' file. Please check the " \
                                "file option: {0}. Error occurred in {1} module " \
                                " __GetEmailConfigurations() method Line #:{2}")
                        print(self.__FormatMessage( \
                                self.__formatBuffer.format(optionToUpper, \
                                            self.__moduleName, self.lineNum), \
                                width=80, initial_indent='\n    ', \
                                subsequent_indent=' ' * 4, \
                                break_long_words=False, \
                                break_on_hyphens=False), '\n')
            else:
                self.lineNum = self.GetLineNo() - 1
                self.__formatBuffer = \
                        ('Unable to find the specified config file. Please ' \
                        'check the arguments provided for initializing the ' \
                        'email object. Error occurred in {0} module ' \
                        '__GetEmailConfigurations() method at Line #: {1}')
                self.__errorMessage = \
                    self.__formatBuffer.format(self.__moduleName, self.lineNum)
                self.errorCode = 4
                self.__errorDesc_4 = \
                        ('Error occurred in %s module at Line #: %d. ' \
                        'Unable to find the specified %s config file.' \
                        % (self.__moduleName, self.lineNum, configFile))
                raise LocalException(self.__errorMessage)

            if not self.__CheckEmailAddresses():
                raise LocalException(self.__errorMessage)

        except LocalException as exceptionError:
            print(self.__FormatMessage( \
                exceptionError.value, width=80, initial_indent='\n    ', \
                subsequent_indent=' ' * 4, break_long_words=False, \
                break_on_hyphens=False), '\n')
            return False
        except (configparser.NoSectionError, configparser.NoOptionError,
                configparser.DuplicateSectionError,
                configparser.MissingSectionHeaderError,
                configparser.ParsingError, configparser.Error) \
                as exceptionError:
            self.lineNum = self.GetLineNo() - 5
            self.__formatBuffer = \
                ('Error occurred in {0} module __GetEmailConfigurations() ' \
                'method at Line #: {1}. Error message: {2}.')
            print(self.__FormatMessage( \
                        self.__formatBuffer.format(self.__moduleName, \
                                    self.lineNum, exceptionError.message), \
                        width=80, initial_indent='\n    ', \
                        subsequent_indent=' ' * 4, break_long_words=False, \
                        break_on_hyphens=False), '\n')

            # configparser exceptions, so exit the program
            sys.exit()
        else:
            return True


    # ****************************************************************************************
    # ----------------------              __ReadArguments()             ----------------------

    def __ReadArguments(self, **keywordArgs):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ReadArguments():
                Reads the arguments passed and populates the class attributes for the email
                object.

            Parameters:
                keywordArgs  - Email keyword arguments.
                    READ_EMAIL_TEXT_FROM_FILE
                        - Name of file to read the email text from.
                    READ_FROM_CONFIG_FILE
                        - Name of file to read the email configurations.
                    CONFIG_SECTION_NAME
                        - Config section name to read the value from.
                    EMAIL_BODY
                        - Email body if a file containing a message is not provided.
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
                    SMTP_SERVER_NAME
                        - The smtp server name for email client.
                    USE_SMTP_SSL
                        - Use secure socket layer

            Returns:
                True if the arguments were read correctly.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        if keywordArgs:
            keywordDict = {}
            for keywordParam in keywordArgs:
                keywordToUpper = keywordParam.upper()
                # Add to the dictionary
                keywordDict.update({keywordToUpper : \
                                    keywordArgs[keywordParam]})
                if keywordToUpper == 'READ_EMAIL_TEXT_FROM_FILE':
                    self.__emailTextFile = keywordDict[keywordToUpper]
                elif keywordToUpper == 'READ_FROM_CONFIG_FILE':
                    self.__emailConfig = keywordDict[keywordToUpper]
                elif keywordToUpper == 'CONFIG_SECTION_NAME':
                    self.__configSection = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EMAIL_BODY':
                    self.__emailBody = keywordDict[keywordToUpper]
                elif keywordToUpper == 'TO_ADDRESS':
                    self.__emailTo = keywordDict[keywordToUpper]
                elif keywordToUpper == 'FROM_ADDRESS':
                    self.__emailFrom = keywordDict[keywordToUpper]
                elif keywordToUpper == 'CC_ADDRESS':
                    self.__emailCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'BCC_ADDRESS':
                    self.__emailBlindCopy = keywordDict[keywordToUpper]
                elif keywordToUpper == 'EMAIL_SUBJECT':
                    self.__emailSubject = keywordDict[keywordToUpper]
                elif keywordToUpper == 'SMTP_SERVER_NAME':
                    self.__smtpServerName = keywordDict[keywordToUpper]
                elif keywordToUpper == 'USE_SMTP_SSL':
                    self.__useSmtpSsl = keywordDict[keywordToUpper]
                elif keywordToUpper:
                    self.lineNum = self.GetLineNo() - 1
                    self.__formatBuffer = None
                    self.__formatBuffer = \
                            ('Invalid keyword ({0}) passed to the __ReadArguments() ' \
                            'method in {1} at Line #: {2}')
                    print(self.__FormatMessage( \
                                self.__formatBuffer.format(keywordToUpper, \
                                            self.__moduleName, self.lineNum),
                                width=80, initial_indent='\n    ', \
                                subsequent_indent=' ' * 4, \
                                break_long_words=False, \
                                break_on_hyphens=False), '\n')
                    self.errorCode = 3
                    self.__errorDesc_3 = \
                            ('Error occurred in %s module at Line #: %d. Invalid keywords ' \
                            'passed to method.' % (self.__moduleName, self.lineNum))
        else:   # Nothing to email
            return False

        return True


    # ****************************************************************************************
    # ----------------------                 __init__()                -----------------------

    def __init__(self, **keywordArgs):

        """
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            __init__(self):
                Calls a function to initialize the EnhanceEmailClass object attributes.

            Parameters:
                keywordArgs - Named or keyword arguments.

            Returns:
                None.
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        """

        try:
            # Extract the arguments passed at the time of object initialization.
            if not self.__ReadArguments(**keywordArgs):
                self.lineNum = self.GetLineNo() - 1
                self.__errorMessage = \
                    ('Missing keyword arguments during the email object initialization. ' \
                    'Please check and provide the required argrments. Error occurred in %s ' \
                    'module __init__() method at Line #: %d.' \
                                                % (self.__moduleName, self.lineNum))
                self.errorCode = 2
                self.__errorDesc_2 = \
                    ('Error occurred in %s module __init__() method at Line #: %d. ' \
                    'Missing keyword arguments during the email object initialization. ' \
                    % (self.__moduleName, self.lineNum))
                raise LocalException(self.__errorMessage)

            # Check if the email configurations are read from the configuration file.
            # If so, extract the information from there.
            if self.__emailConfig:
                self.lineNum = self.GetLineNo() - 1
                if not self.__GetEmailConfigurations():
                    self.__errorMessage = \
                        ('Unable to read the email configuration file. Please ensure the ' \
                        'file is configured properly. Error occurred in %s module ' \
                        '__init__() method at Line #: %d.' \
                        % (self.__moduleName, self.lineNum))
                    self.errorCode = 1
                    self.__errorDesc_1 = \
                        ('Error occurred in %s module __init__() method at Line #: ' \
                        '%d. Unable to read the email configuration file.' \
                        % (self.__moduleName, self.lineNum))
                    raise LocalException(self.__errorMessage)
            else:
                # Email configurations are not read from the config file, so check the
                # existence of the required email fields.
                if not self.__CheckEmailAddresses():
                    raise LocalException(self.__errorMessage)

        except LocalException as errorException:
            print(self.__FormatMessage( \
                        errorException.value, width=80, \
                        initial_indent='\n    ', subsequent_indent=' ' * 4, \
                        break_long_words=False, break_on_hyphens=False), '\n')

        else:
            # Create email message object. Make it 'alternative' for multi part email. For
            # example you might want to attach a message body and also files, so you need
            # make the smtp email object multipart.
            # self.__emailMessage = MIMEMultipart()
            self.__emailMessage = MIMEMultipart('alternative')

            # Email is created
            self.__isEmailObjCreated = True
