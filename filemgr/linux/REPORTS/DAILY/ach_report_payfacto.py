#!/usr/bin/env python
'''
$Id: ach_report_payfacto.py 2020-03-17 21:01:06Z bjones $

File Name:  ach_report_payfacto.py

Description:    This class generates the ach report for Payfacto for a given
                institution id.

Arguments:   -d - Date in YYYYMMDD format(Optional)
             -i - Institution ID
             -v - Verbosity level
                -v    = logging.WARNING
                -vv   = logging.INFO
                -vvv  = logging.DEBUG
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       ACH_Payfacto report

Return:   0 = Success
          !0 = Exit with errors
'''

# The following are pylint directives to suppress some pylint warnings that you
# do not care about.
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = broad-except

#TO DO  change verbosity level, attach file date,
#add readme file show how to run in test mode with diff variations
import argparse
import csv
import configparser
from datetime import datetime
#from datetime import timedelta
import os
import sys
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

class AchPayfactoReportClass():
    """
    Name : AchPayfactoReportClass
    Description : AchPayfactoReportClass is used to generate the Ach Payfacto report
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
                                  CONFIG_SECTION_NAME='ACH_PAYFACTO_ALERTS', \
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
                select 
                    pl.INSTITUTION_ID                       "Inst",
                    eta.VISA_BIN                            VISA_BIN,
                    ea.OWNER_ENTITY_ID                      Merchant_ID,
                    ae.entity_dba_name                      Merchant_name,
                    ea.CUSTOMER_NAME                        CUSTOMER_NAME,
                    case when pl.PAYMENT_AMT < 0    
                         then 'D' else 'C' end              "Db/Cr",
                    pl.PAYMENT_PROC_DT                      PAYMENT_DT,
                    pl.TRANS_ROUTING_NBR                    ROUTING_NBR,
                    '****' || substr(pl.ACCT_NBR, -4, 4)    ACCT_NBR,
                    ea.ENTITY_ACCT_DESC                     ACCT_DESC,
                    pl.PAYMENT_AMT                          PAYMENT_AMT
                from payment_log pl
                join entity_acct ea
                    on pl.entity_acct_id = ea.entity_acct_id 
                    AND pl.institution_id = ea.institution_id
                join entity_to_auth eta
                    on eta.entity_id = ea.owner_entity_id 
                    AND eta.institution_id = ea.institution_id
                join acq_entity ae
                    on ae.entity_id = ea.owner_entity_id 
                    AND ae.institution_id = ea.institution_id
                where 
                    pl.payment_proc_dt >= to_date(:run_file_date,'YYYYMMDD')
                and pl.payment_proc_dt <  to_date(:run_file_date,'YYYYMMDD') + 1
                and pl.institution_id = :inst_id
                --and rownum < 50
                order by 1,2,3,4
                """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            self.logger.debug('Cursor opened successfully\n')

            bind_str = {'run_file_date':run_date, 'inst_id':inst_id}

            self.logger.debug('bind_str: run_file_date <{0}>\n'.format(bind_str['run_file_date']))
            self.logger.debug('bind_str: inst_id <{0}>\n'.format(bind_str['inst_id']))

            self.logger.info(bind_str)
            db_obj.ExecuteQuery(cur, sql_query, bind_str)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            self.logger.debug('Query executed successfully\n')

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
            # LM - Corrected for traceback error
            # self.logger.debug('Logger object level : ', self.logger.getEffectiveLevel())
            self.logger.debug('Logger object level : {0}'.format(self.logger.getEffectiveLevel()))
        except Exception as err:
            # LM - Corrected for string formatting issue.
            # self.logger.debug('Unable to create logger object', str(err))
            self.logger.debug('Unable to create logger object {0}'.format(str(err)))
            return False
        else:
            return True

    def __init__(self, process_name):
        """
        Name        : __init__
        Description : Initializes the ach pf report class object.
        Parameters  : Process name.
        Returns     : None.
        """
        self.program_name = __file__
        self.mode = "PROD"

        self.email_config_file = 'email_config.ini'
        # Create the Logger
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.DEBUG)
        # LM - Corrected for formatting error
        # self.logger.debug('In init function, script name:', os.path.basename(__file__),\
                          # 'program_name', self.program_name)
        self.logger.debug('In init function, script name: {0} program_name {1}'.format(\
                            os.path.basename(__file__), self.program_name))

        # Create the Handler for logging data to a file
        log_file_name = 'LOG/{0}.log'.format(process_name)
        # LM - Corrected for formatting error
        # self.logger.debug('log_file_name ', log_file_name)
        self.logger.debug('log_file_name {0}'.format(log_file_name))

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
                        'Payfacto ACH Report.')
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
                        help='mail configuration in test email file')
            args = arg_parser.parse_args()

        except argparse.ArgumentError as err:
            # LM - Corrected for formatting errors
            # err_mesg = 'Error: During parsing command line arguments {}'
            # self.logger.debug(err_mesg.format(err))
            self.logger.debug('Unable to create logger object {0}'.format(str(err)))
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
        ach_pf_object = AchPayfactoReportClass('AchPayfacto')

        #Parse the command line arguments
        arg_list = ach_pf_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            ach_pf_object.email_config_file = arg_list.test
            ach_pf_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%Y%m%d')
            print('Date to run ach pf report: ', report_date)
        else:
            print('arg_list.date <{0}>'.format(arg_list.date))
            report_date = datetime.strptime(arg_list.date, '%Y%m%d')
            print('1. Date to run ach pf report: ', report_date)

            report_date = datetime.strptime(arg_list.date, '%Y%m%d').strftime('%Y%m%d')
            print('2. Date to run ach pf report: ', report_date)

        #set logger object verbose level
        log_res = ach_pf_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result - ', log_res)

        cfg_obj = configparser.ConfigParser()

        if not cfg_obj.read('ach_report_payfacto.cfg'):
            raise LocalException('Unable to read ach_report_payfacto.cfg file')

        print(cfg_obj.sections())
        print(list(cfg_obj[arg_list.inst_id].keys()))
        print(cfg_obj[arg_list.inst_id]['encrypt_key'], cfg_obj[arg_list.inst_id]['dest_path'])
        #Open database connection
        db_object = DbClass(ENV_HOSTNM='IST_HOST', \
                            ENV_USERID='IST_DB_USERNAME', \
                            PORTNO='1521', \
                            ENV_PASSWD='IST_DB_PASSWORD', \
                            ENV_SERVNM='IST_SERVERNAME')
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        print('Database credentials ', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        outFileName = ach_pf_object.generate_report(db_object, \
                                                     arg_list.inst_id, \
                                                     cfg_obj, report_date)
        print('outFileName: ', outFileName)
        if outFileName is None:
            raise Exception('generate_report didnt make a file')

        ach_pf_object.encrypt_file(arg_list.inst_id, cfg_obj, outFileName)
        ach_pf_object.transfer_file(arg_list.inst_id, cfg_obj, outFileName)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except configparser.Error as err:
        err_msg = 'Error: while reading or parsing the config file {}'.format(err)
        print(err_msg)
        ach_pf_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except LocalException as err:
        err_msg = 'Error: During database connection or execution of ach pf {}'.format(err)
        print(err_msg)
        ach_pf_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of ach pf inside main function {}'.format(err)
        print(err_msg)
        ach_pf_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
