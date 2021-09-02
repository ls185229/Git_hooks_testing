from email_class import EmailClass
import os
import sys

print('This is a test of the Email Class:\n')

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Notes:
#   1. A single email address can be a straight forward string or contained in a list.
#   2. Multiple email addresses must be contained in a list.
#   3. There is a ResetEmailParams() function if you need to reset the email parameters
#      to send another email different from the previous.
#   4. The email class object can be initialized with the appropriate parameters at the
#      time of instantiating the object or can be configured to read from a config file.
#      If the parameters are to be read from the config file, it should also provide a
#      config section name to read the parameters. See example below.
#   5. The email class object attributes are keyword attributes, so the order in which
#      they are passed to the function and the case does not matter as long as they
#      match the expected names.
#   6. It can  also be configured to read the email body text from a text file. See 
#      example below.
#   7. The email class object can be used to attach a single or multiple attachments
#      to the email. See example below.
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# TO_ADDRESS    = 'Leonard.Mendis@jetpay.com'
# FROM_ADDRESS  = ['Leonard.Mendis@jetpay.com', 'Sangeetha.Kumar@jetpay.com'] 
# CC_ADDRESS    = ['Leonard.Mendis@jetpay.com']
# BCC_ADDRESS   = 'Leonard.Mendis@jetpay.com'
# EMAIL_SUBJECT = 'IGNORE: This is a Test email to test the class for sending out error emails.'


# Email class object initialization using a config file.
emailObj = EmailClass(READ_email_text_FROM_FILE = 'EmailFile.txt', 
                        read_from_config_FILE = 'email_config.ini', 
                        CONFIG_SECTION_NAME = 'OKDMV_REPORTS')
emailObj.GetErrorDescription()

# sys.exit()

emailSubject = ('IGNORE: This is a Test email for testing the email class.')

# Email class object initialization using the keyword arguments not using the config file.
# emailObj = EmailClass(TO_ADDRESS = (['Leonard.Mendis@jetpay.com', 
#                   'Sangeetha.Kumar@jetpay.com']),
#                    EMAIL_BODY = 'TEST email. Please disregard.',
#                    FROM_ADDRESS = 'Leonard.Mendis@jetpay.com', 
#                    EMAIL_SUBJECT = emailSubject,
#                    read_from_config_FILE = 'email_config.ini',
#                    config_section_Name = 'OKDMV_ALERTS)

# emailObj = EmailClass(TO_ADDRESS = 'Leonard.Mendis@jetpay.com', 
#                    EMAIL_BODY = 'TEST email. Please disregard.',
#                    FROM_ADDRESS = 'Leonard.Mendis@jetpay.com', 
#                    EMAIL_SUBJECT = emailSubject,
#                    read_from_config_FILE = 'email_config.ini',
#                    config_section_Name = 'OKDMV_ALERTS')

basePath = os.path.dirname(os.path.abspath(__file__))

if not (emailObj.AttachFiles(ATTACH_FILES_FOLDER = basePath, 
        ATTACH_FILES_LIST = ['ABC.txt', 'Xyz.txt'])):
    sys.exit()

if not emailObj.SendEmail():
    print('1. An error occurred while sending email.\n')
else:
    print('1. First email sent successfully.\n')

# Print parameters for debugging if needed.
# emailObj.PrintEmailParams()

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Test for resetting email parameters after the first email was sent and sending another
# email using the same smtp email object.
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ResetEmailTo    = 'Leonard.Mendis@jetpay.com'
ResetEmailFrom  = ['Ali.Babba@jetpay.com'] 
ResetEmailCc    = ['Sangeetha.Kumar@jetpay.com', 'Leonard.Mendis@jetpay.com']
ResetEmailBcc   = ['Broadus.Jones@jetpay.com']
ResetEmailSubject = 'IGNORE: This is a Test for checking ResetEmailParam()' 
ResetEmailBody = 'This is the email body after resetting the email parameters.'

# This is how to send another email using the same smpt email object but with different
# email parameters. Uncomment the following code to test this functionality.

emailObj.ResetEmailParams(RESET_EMAIL_TO = ResetEmailTo,
                RESET_EMAIL_SUBJECT = ResetEmailSubject,
                RESET_EMAIL_CC = None,
                RESET_EMAIL_BCC = None,
                RESET_EMAIL_BODY = ResetEmailBody)

# print('Line number of the calling program: ', emailObj.GetLineNo())

# emailObj.ResetEmailParams(
#                 RESET_EMAIL_TO    = ResetEmailTo,
#                 RESET_EMAIL_FROM  = ResetEmailFrom,
#                 RESET_EMAIL_CC    = ResetEmailCc,
#                 RESET_EMAIL_BCC   = ResetEmailBcc,
#                 RESET_EMAIL_SUBJECT = ResetEmailSubject,
#                 RESET_EMAIL_BODY = ResetEmailBody)


# Note that the SendEmail() function is called after the Reset, so the smtp email 
# object has been close by the previous call to the function. Therefore, you must 
# recreate the smtp email object for this to work. So, the function needs to be 
# called with the resend parameter set to True. Uncomment the code below to test
# for resending an email.

if not emailObj.SendEmail(True):
    print('2. An error occurred while sending email.\n')
else:
    print('2. Second email sent successfully.\n')

