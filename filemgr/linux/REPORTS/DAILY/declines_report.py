#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: declines_report.py  2020-03-02 12:01:06Z bjones $
$Rev: 4897 $
File Name:  declines_report.py

Description:  This class generates the declines report for a given institution id.

Arguments:   -d - Date in YYYYMMDD format(Optional)
             -i - Institution ID
             -v - Verbosity level
                -v    = logging.WARNING
                -vv   = logging.INFO
                -vvv  = logging.DEBUG
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       declines report

Return:    0 = Success
          !0 = Exit with errors
'''

#TO DO  change verbosity level, attach file date,
#add readme file show how to run in test mode with diff variations
import argparse
import csv
import configparser
from datetime import datetime
#from datetime import timedelta
import os
import sys
# import cx_Oracle
from subprocess import call

import logging

sys.path.append('/clearing/filemgr/MASCLRLIB')

from database_class import DbClass
from email_class import EmailClass

class LocalException(Exception):
    """
    Name : LocalException
    Description: A local exception class to post exceptions local to this module.
                 The local exception class is derived from the Python base exception
                 class. It is used to throw other types of exceptions that are not
                 in the standard exception class.
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)

class DeclineReportClass():
    """
    Name : DeclineReportClass
    Description : DeclineReportClass is used to generate the declines report
    Arguments: None
    """
    # Private class attributes
    program_name = None
    mode = None
    logger = None

    def send_alert(self, message):
        """
        Name : send_alert
        Arguments: message
        Description : send the alert whenever an error occurred during the process
        Returns: Nothing
        """

        email_sub = os.environ["HOSTNAME"] + ' - Err in ' + self.program_name
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                  CONFIG_SECTION_NAME='DECLINE_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, inst_id, cfg_obj, run_date):
        """
        Name : generate_report
        Arguments: database object, institution id, configparser object and date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
                SELECT distinct
                    '202001'                                        as "JetPay Version Number",
                    null                                            as "Aquirer Reference Number",
                    case when m.VISA_ID is null
                         then m.debit_id
                         else m.visa_id
                    end                                             as "Merchant Number",
                    t.ticket_no                                     as "ORDER_NUMBER",
                    null                                            as "BLANK",
                    substr(t.CARDNUM, 1, 6) ||
                               'xxxxxx' ||
                               substr(t.CARDNUM, -4, 4)             as "Cardholder Account Number",
                    t.CARD_TYPE                                     as "CARDTYPE",
                    t.EXP_DATE                                      as "CARDEXP",
                    t.POS_ENTRY                                     as "POSENTRYMODE",
                    t.AMOUNT                                        as "AUTHAMOUNT",
                    t.CURRENCY_CODE                                 as "CURRENCYCODE",
                    t.CARD_LEVEL_RESULTS                            as "RESULTCODE",
                    case when t.CARD_LEVEL_RESULTS = '123' then '123'
                         when t.CARD_LEVEL_RESULTS = '456' then '456'
                         else t.CARD_LEVEL_RESULTS
                    end                                             as "RESULTCODEDESC",
                    t.REQUEST_TYPE                                  as "TRANSTYPE",
                    eaa.PHONE                                       as "PHONE",
                    eaa.EMAIL                                       as "EMAIL",
                    t.AUTHDATETIME                                  as "TRANSDATE",
                    t.AUTH_CODE                                     as "AUTHCODE/ERRORCODE",
                    null                                            as "MAS Code",
                    t.CVV                                           as "CVV RESP",
                    t.AVS_RESPONSE                                  as "AVS RESP",
                    eaa.ADDRESS                                     as "ADDRESS",
                    eaa.CARDHOLDERNAME                              as "CARDHOLDERNAME",
                    eaa.ORDERNUMBER                                 as "ORDERNUMBER",
                    null                                            as "REFERENCE",
                    null                                            as "EXTERNAL REFERENCE",
                    t.SHIPDATETIME                                  as "BATCHDATE",
                    null                                            as "TRANSMODE",
                    t.AUTHDATETIME                                  as "AUTHDATE",
                    case when t.ACTION_CODE in ('000')
                         then t.SHIPDATETIME
                         else null
                    end                                             as "CAPTUREDATE",
                    t.settle_date                                   as "SETTLEDATE",
                    null                                            as "INTERCHANGE QUAL %",
                    null                                            as "INTERCHANGE PER ITEM",
                    eaa.COUNTRY                                     as "CARDIDENTIFIER",
                    null                                            as "CARDISSUE",
                    t.TID                                           as "TERMINALID",
                    t.BATCH_NO                                      as "BATCHID",
                    t.AUTHORIZATION_AUTHORITY                       as "AUTH_AUTHORITY",
                    t.NETWORK_ID                                    as "NETWORK_ID",
                    m.VISA_ID                                       as "ENTITY_ID",
                    t.ACTION_CODE                                   as "ACTION_CODE",
                    sc.value                                        as "APPROVAL_STATUS_DESC",
                    scr.value                                       as "Request_Type_Desc"
                FROM transaction t
                    inner JOIN merchant m
                    ON m.mid = t.mid
                    left JOIN tei_merchant_addenda_rt mar --teihost.merchant_addenda_rt mar
                    ON mar.mid = m.mid
                    left JOIN ecomm_addendum_auth eaa  -- teihost.ecomm_addendum_auth eaa
                    ON eaa.unique_id = t.other_data3
                    left join status_code sc
                    on sc.type = 'ACT'
                    and sc.code = t.action_code
                    left join status_code scr
                    on scr.type = 'REQ'
                    and scr.code = t.REQUEST_TYPE
                WHERE 1=1
                AND t.shipdatetime >= to_char(to_date(:run_file_date,'YYYYMMDD') - 1, 'YYYYMMDD')
                AND t.shipdatetime <  :run_file_date
                and rownum < 250
                and mar.institution_id = :inst_id
                and t.ACTION_CODE not in ('000')
            """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()
            # cur = db_obj.cursor()

            #if db_obj.errorCode:
            #    raise LocalException( \
            #          db_obj.GetErrorDescription(db_obj.errorCode))

            bind_str = {'run_file_date':run_date, 'inst_id':inst_id}
            self.logger.info(bind_str)
            db_obj.ExecuteQuery(cur, sql_query, bind_str)
            #cur.execute(sql_query, bind_str)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            query_result = db_obj.FetchResults(cur)
            log_msg = 'Total number of rows fetched:{}'.format(str(db_obj.dbCursor[cur].rowcount))
            self.logger.debug(log_msg)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            self.logger.info(cfg_obj[inst_id])
            file_name = cfg_obj[inst_id]['file_name']
            outFileName = '{}{}.csv'.format(file_name, run_date)
            log_msg = 'Output file name: {}'.format(outFileName)
            self.logger.info(log_msg)

            #Retrieve Column names
            col_names = []
            for row in db_obj.dbCursor[cur].description:
                col_names .append(row[0])
            tup_col_names = tuple(col_names)
            self.logger.info(tup_col_names)

            # Open the output csv file
            with open(outFileName, mode='w+', newline='') as csv_file:
                file_open = True
                csv_writer_obj = \
                        csv.writer(csv_file, dialect='excel', \
                                        delimiter=',', \
                                        quotechar=None, \
                                        skipinitialspace=True, \
                                        quoting=csv.QUOTE_NONE, \
                                        escapechar='')
                csv_writer_obj.writerow(tup_col_names)


                #Now write the extracted data to the csv file
                cnt = 1
                for row_data in query_result:
                    csv_writer_obj.writerow(row_data)
                    cnt = cnt + 1

            if file_open:
                csv_file.close()

            db_obj.CloseCursor(cur)
            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))
            self.logger.info(log_msg)
            return outFileName

        except LocalException as err:
            err_mesg = 'During database query execution {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            db_obj.CloseCursor(cur)
            db_obj.Disconnect()
            sys.exit()
        except IOError as err:
            err_mesg = 'IOError error is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            db_obj.CloseCursor(cur)
            db_obj.Disconnect()
            sys.exit()
        except Exception as err:
            err_mesg = 'Exception error is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            db_obj.CloseCursor(cur)
            db_obj.Disconnect()
            sys.exit()
    def encrypt_file(self, inst_id, cfg_obj, outFileName):
        """
        Name : encrypt_file
        Arguments: institution id, configparser object and Output file name
        Description : Encrypt the output file
        Returns: None
        """
        try:
            self.logger.info(cfg_obj[inst_id])
            arc_key = os.environ['ARCHIVE_ENCRYPT_KEY']
            encrypt_key = cfg_obj[inst_id]['encrypt_key']
            enc_key = os.getenv(encrypt_key)
            log_msg = 'archive_key:{}'.format(arc_key)
            self.logger.info(log_msg)
            log_msg = 'encrypt_key:{}'.format(enc_key)
            self.logger.info(log_msg)
            gpg_cmd = 'gpg --encrypt --armor --recipient'
            gpg_cmd = '{} {} --recipient {} {}'.format(gpg_cmd, arc_key, enc_key, outFileName)
            self.logger.info(gpg_cmd)
            os.system(gpg_cmd)
            self.logger.info('output file encrypted')
        except IOError as err:
            err_mesg = 'IOError error in encrypt_file function is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            sys.exit()
        except Exception as err:
            err_mesg = 'Exception error in encrypt_file function is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            sys.exit()

    def transfer_file(self, inst_id, cfg_obj, outFileName):
        """
        Name : transfer_file
        Arguments: institution id, configparser object and output file name
        Description : Transfer the file to the desired destination
        Returns: None
        """
        try:
            encFileName = '{}.asc'.format(outFileName)
            log_msg = 'Encrypted File Name:{}'.format(encFileName)
            #dest_path = '/secure/b2payments/reports/'
            dest_path = cfg_obj[inst_id]['dest_path']
            server_name = 'sftp.jetpay.com'
            scp_cmd = 'scp -q {} {}:{}.'.format(encFileName, server_name, dest_path)
            self.logger.info(scp_cmd)
            
            ret = call(scp_cmd.split(" "))
            if ret == 0:
                mv_cmd = "mv {} ARCHIVE/"
                self.logger.info(log_msg)
                os.system(mv_cmd.format(outFileName))
                os.system(mv_cmd.format(encFileName))
            else:
                self.logger.error('Unable to transfer file')

        except IOError as err:
            err_mesg = 'IOError error is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            sys.exit()
        except Exception as err:
            err_mesg = 'Exception error is {}'.format(err)
            self.logger.error(err_mesg)
            self.send_alert(err_mesg)
            sys.exit()
    def set_logger_level(self, verbosity_level):
        """
        Name : set_logger_level
        Arguments: verbosity level
        Description : Set the logger class object based on the verbosity level
        Returns: None
        """
        try:
            if verbosity_level == 1:           # called with -v
                log_level = logging.WARNING
            elif verbosity_level == 2:           # called with -vv
                log_level = logging.INFO
            elif verbosity_level == 3:             # called with -vvv
                log_level = logging.DEBUG
            else:
                log_level = logging.DEBUG


            self.logger.setLevel(log_level)
            self.logger.handlers[0].setLevel(log_level)
            print('Logger object level : ', self.logger.getEffectiveLevel())
        except Exception as err:
            print('Unable to create logger object', str(err))
            return False
        else:
            return True

    def __init__(self, process_name):
        """
        Name        : __init__
        Description : Initializes the decline report class object.
        Parameters  : Process name.
        Returns     : None.
        """
        self.program_name = __file__
        print('In init function, script name:', os.path.basename(__file__),\
              'program_name', self.program_name)
        self.mode = "PROD"
        self.email_config_file = 'email_config.ini'
        
        # Create the Logger
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.ERROR)

        # Create the Handler for logging data to a file
        log_file_name = 'LOG/{0}.log'.format(process_name)
        print('log_file_name ', log_file_name)
        logger_handler = logging.FileHandler(log_file_name)
        logger_handler.setLevel(logging.ERROR)

        # Create a Formatter for formatting the log messages
        log_format = '%(filename)s - %(levelname)s - %(asctime)s - ' + \
                 'In %(funcName)s method ' + \
                 '- Line no %(lineno)d - %(message)s'
        logger_formatter = logging.Formatter(log_format)

        # Add the Formatter to the Handler
        logger_handler.setFormatter(logger_formatter)

        # Add the Handler to the Logger
        self.logger.addHandler(logger_handler)
        self.logger.debug('Completed configuring logger()!')

    def parse_arguments(self):
        """
        Name : parse_arguments
        Arguments: none
        Description : Parses the command line arguments
        Returns: arg_parser args
        """
        try:
            arg_parser = argparse.ArgumentParser(description= \
                        'Release reserve amount held by a merchant.')
            arg_parser.add_argument('-v', '-V', '--verbose', \
                        action='count', dest='verbose', required=False, \
                        help='verbose level  repeat up to five times.')
            arg_parser.add_argument('-i', '-I', '--inst_id', \
                        type=str, \
                        required=True, help='Institution ID')
            arg_parser.add_argument('-d', '-D', '--date', \
                        type=str, \
                        required=False, help='Date to run')
            arg_parser.add_argument('-t', '-T', '--test', required=False, \
                        help='mail configuration is read from the test email file in testing phase')
            args = arg_parser.parse_args()

        except argparse.ArgumentError as err:
            err_mesg = 'Error: During parsing command line arguments {}'
            print(err_mesg.format(err))
            sys.exit()
        else:
            return args

if __name__ == "__main__":
    """
    Name : main
    Description: This script release reserve amount from the merchant
    Arguments: input file, mode, verbosity level and cycle
    """
    try:
        decline_object = DeclineReportClass('Declines')

        #Parse the command line arguments
        arg_list = decline_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            decline_object.email_config_file = arg_list.test
            decline_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%Y%m%d')
            print('Date to run decline report:', report_date)
        else:
            report_date = datetime.strptime(arg_list.date, '%Y%m%d')
            print('Date to run decline report:', report_date)

        #set logger object verbose level
        log_res = decline_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result - ', log_res)

        cfg_obj = configparser.ConfigParser()

        if not cfg_obj.read('declines_report.cfg'):
            raise LocalException('Unable to read declines_report.cfg file')

        print(cfg_obj.sections())
        print(list(cfg_obj[arg_list.inst_id].keys()))
        print(cfg_obj[arg_list.inst_id]['encrypt_key'], cfg_obj[arg_list.inst_id]['dest_path'])
        #Open database connection
        connection_string  = os.environ.get('PORT_DB_USERNAME') + '/' 
        connection_string += os.environ.get('PORT_DB_PASSWORD')  + '@'
        connection_string += os.environ.get('PORT_HOST')

        # connection = cx_Oracle.connect(connection_string)
        db_object = DbClass(ENV_HOSTNM='PORT_HOST', \
                            ENV_USERID='PORT_DB_USERNAME', \
                            PORTNO='1521', \
                            ENV_PASSWD='PORT_DB_PASSWORD', \
                            ENV_SERVNM='PORT_SERVERNAME')
        print('Database credentials', db_object._DbClass__dbCredentials)
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        # print('Database credentials', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
           raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        outFileName = decline_object.generate_report(db_object, \
                                                     arg_list.inst_id, \
                                                     cfg_obj, report_date)
        print('outFileName:', outFileName)
        if outFileName is None:
            raise Exception('generate_report didnt make a file')

        decline_object.encrypt_file(arg_list.inst_id, cfg_obj, outFileName)
        decline_object.transfer_file(arg_list.inst_id, cfg_obj, outFileName)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except configparser.Error as err:
        err_msg = 'Error: while reading or parsing the config file {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except LocalException as err:
        err_msg = 'Error: During database connection or execution of decline {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of decline inside main function {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
