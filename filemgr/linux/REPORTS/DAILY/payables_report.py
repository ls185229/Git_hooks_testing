#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: payables_report.py 4846 2019-04-24 20:35:16Z skumar $
$Rev: 4846 $
File Name:  payables_report.py

Description:  This class generates the payables report.

Arguments:   -d - Date in YYYYMMDD format(Optional)
             -i - Institution ID (Optional)
             -f - Funding type (Required)
                  NORMAL_FUNDING or NEXTDAY_FUNDING
             -v - Verbosity level
                -v = logging.DEBUG
                -vv = logging.INFO
                -vvv = logging.WARNING
                -vvvv = logging.ERROR
                -vvvvv = logging.CRITICAL
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       payables report

Return:   0 = Success
          !0 = Exit with errors
'''
import argparse
import csv
from datetime import datetime
from datetime import timedelta
import os
import sys

import configparser
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

class PayablesClass():
    """
    Name : PayablesClass
    Description : PayablesClass is used to generate the payables report
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
                                  CONFIG_SECTION_NAME='PAYABLES_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, inst_id, run_date, pay_clause):
        """
        Name : generate_report
        Arguments: institution_id, date and payment cycle condition
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
                select 
                    aad.institution_id,
                    to_char(aad.SETTL_DATE, 'DD-MON-YYYY') SETTL_DATE,
                    nvl(ae.entity_id, 'Subtotal') ENTITY_ID,
                    ae.entity_dba_name entity_name,
                    SUM(
                        CASE WHEN ea.acct_posting_type in ('A', 'D')
                             THEN aag.amt_pay - aag.amt_fee ELSE 0 END ) SALES,
                    SUM(
                        CASE WHEN ea.acct_posting_type = 'C'
                             THEN aag.amt_pay - aag.amt_fee ELSE 0 END ) DISPUTES
                    FROM acct_accum_gldate  aag
                    JOIN acct_accum_det aad
                       on aag.INSTITUTION_ID = aad.INSTITUTION_ID
                       AND aag.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID 
                       and aag.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR
                    JOIN entity_acct ea
                       on ea.institution_id = aag.INSTITUTION_ID
                       and ea.ENTITY_ACCT_ID = aag.ENTITY_ACCT_ID
                    JOIN acq_entity ae
                        on ea.INSTITUTION_ID = ae.INSTITUTION_ID 
                        AND ea.owner_entity_id = ae.ENTITY_ID
                    WHERE
                        aad.institution_id in (:inst_id)
                        and ea.acct_posting_type in ('A', 'C', 'D')
                        AND aag.gl_date < :tomorrow
                        AND (aad.payment_status is null 
                             or aad.payment_status != 'P' 
                             or trunc(payment_proc_dt) > :today)
                        AND
                           (
                              aag.gl_date < :tomorrow
                              and (aad.payment_status is null
                                or aad.payment_status != 'P'
                                or trunc(payment_proc_dt) > :yesterday)
                          )
                        AND (aag.amt_pay != 0 or aag.amt_fee != 0)
                        AND """
            sql_query += pay_clause

            sql_query += """
                    GROUP BY
                        aad.institution_id,
                        rollup(aad.SETTL_DATE,ae.entity_id,ae.ENTITY_DBA_NAME)
                    HAVING ae.ENTITY_DBA_NAME is not null or  ae.entity_id is null
                    ORDER BY
                         aad.institution_id,
                         aad.SETTL_DATE,
                          nvl(ae.entity_id, 'Subtotal')
            """
            self.logger.info(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            temp_date = datetime.strptime(run_date, '%d-%b-%Y')
            yesterday = (temp_date + timedelta(days=-1)).strftime('%d-%b-%Y')
            log_msg = 'Start Date: {}'.format(yesterday)
            self.logger.info(log_msg)
            tomorrow = (temp_date + timedelta(days=1)).strftime('%d-%b-%Y')
            log_msg = 'End Date: {}'.format(tomorrow)
            self.logger.info(log_msg)
            bind_str = {'inst_id':inst_id, 'today':run_date, \
                        'tomorrow':tomorrow, 'yesterday':yesterday}
            self.logger.info(bind_str)
            db_obj.ExecuteQuery(cur, sql_query, bind_str)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            query_result = db_obj.FetchResults(cur)
            print('Total number of rows fetched:', str(db_obj.dbCursor[cur].rowcount))

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            #Create the header rows
            header_row = ('Institution:', inst_id, '', '', '', '')
            self.logger.info(header_row)
            cur_day = datetime.now().strftime("%d-%b-%Y")
            gen_row = ('Date Generated:', cur_day, '', '', '', '')
            self.logger.info(gen_row)
            req_row = ('Requested Date:', run_date, '', '', '', '')
            self.logger.info(req_row)
            if self.funding_type == 'NEXTDAY_FUNDING':
                outFileName = '{}_payables_report_{}_{}.csv'\
                                    .format(inst_id, self.funding_type, run_date)
            else:
                outFileName = '{}_payables_report_{}.csv'.format(inst_id, run_date)
            log_msg = 'Output file name: {}'.format(outFileName)
            self.logger.info(log_msg)
            empty_line = ('', '', '', '', '', '')

            #Retrieve Column names
            col_names = []
            for row in db_obj.dbCursor[cur].description:
                col_names .append(row[0])
            tup_col_names = tuple(col_names)
            print(tup_col_names)
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
                csv_writer_obj.writerow(header_row)
                csv_writer_obj.writerow(gen_row)
                csv_writer_obj.writerow(req_row)
                csv_writer_obj.writerow(empty_line)
                csv_writer_obj.writerow(tup_col_names)


                #Now write the extracted data to the csv file
                cnt = 1
                for row_data in query_result:
                    if cnt < db_obj.dbCursor[cur].rowcount:
                        if row_data[2] == "Subtotal":
                            csv_writer_obj.writerow(row_data)
                            csv_writer_obj.writerow(empty_line)
                        else:
                            csv_writer_obj.writerow(row_data)
                    else:
                        lst = list(row_data)
                        lst[0] = lst[1] = lst[2] = ''
                        lst[3] = 'Total'
                        temp_row = tuple(lst)
                        print('temp_row', temp_row)
                        csv_writer_obj.writerow(temp_row)
                    cnt = cnt + 1

            if file_open:
                csv_file.close()
                if self.mode == 'PROD':
                    email_sub = \
                            ('Payables Report: %s' % outFileName)
                else:
                    email_sub = \
                        ('IGNORE: Testing Payables Report : %s' \
                            % outFileName)

                # Email the file
                email_body = 'Successfully created the %s file.' % outFileName

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='PAYABLES_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[outFileName]):
                    self.logger.error('Unable to send the payables report attachment')
                if not email_obj.SendEmail():
                    self.logger.error('An error occurred while sending email.\n')
                else:
                    self.logger.info('Email sent successfully.\n')

                mv_cmd = "mv {} ARCHIVE/"
                os.system(mv_cmd.format(outFileName))

            db_obj.CloseCursor(cur)
            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

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

    def set_logger_level(self, verbosity_level):
        """
        Name : set_logger_level
        Arguments: verbosity level
        Description : Set the logger class object based on the verbosity level
        Returns: None
        """
        try:
            if verbosity_level == 1:             # called with -v
                log_level = logging.DEBUG
            elif verbosity_level == 2:           # called with -vv
                log_level = logging.INFO
            elif verbosity_level == 3:           # called with -vvv
                log_level = logging.WARNING
            elif verbosity_level == 4:           # called with -vvvv
                log_level = logging.ERROR
            elif verbosity_level == 5:           # called with -vvvvv
                log_level = logging.CRITICAL

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
        Description : Initializes the payables report class object.
        Parameters  : Process name.
        Returns     : None.
        """
        self.program_name = __file__
        print('In init function, script name:', os.path.basename(__file__),\
              'program_name', self.program_name)
        self.mode = "PROD"
        self.email_config_file = 'email_config.ini'
        self.funding_type = 'NORMAL_FUNDING'
        # Create the Logger
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.WARNING)

        # Create the Handler for logging data to a file
        log_file_name = 'LOG/{0}.log'.format(process_name)
        print('log_file_name ', log_file_name)
        logger_handler = logging.FileHandler(log_file_name)
        logger_handler.setLevel(logging.WARNING)

        # Create a Formatter for formatting the log messages
        format = '%(filename)s - %(levelname)s - %(asctime)s - ' + \
                 'In %(funcName)s method ' + \
                 '- Line no %(lineno)d - %(message)s'
        logger_formatter = logging.Formatter(format)

        # Add the Formatter to the Handler
        logger_handler.setFormatter(logger_formatter)

        # Add the Handler to the Logger
        self.logger.addHandler(logger_handler)
        self.logger.info('Completed configuring logger()!')

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
                        required=False, help='Institution ID')
            arg_parser.add_argument('-d', '-D', '--date', \
                        type=str, \
                        required=False, help='Date to run')
            arg_parser.add_argument('-f', '-F', '--funding_type', \
                        type=str, \
                        required=False, \
                        help='Funding Type either NORMAL or NEXTDAY FUNDING')
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
        payables_object = PayablesClass('payables')

        #Parse the command line arguments
        arg_list = payables_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            payables_object.email_config_file = arg_list.test
            payables_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%d-%b-%Y')
            print('Date to run payables report:', report_date)
        else:
            report_date = datetime.strptime(arg_list.date, '%Y%m%d')
            report_date = report_date.strftime('%d-%b-%Y')
            print('Date to run payables report:', report_date)

        #set logger object verbose level
        log_res = payables_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result - ', log_res)

        #set the funding type
        payables_object.funding_type = arg_list.funding_type

        #Open database connection
        db_object = DbClass(ENV_HOSTNM='IST_HOST', \
                            ENV_USERID='IST_DB_USERNAME', \
                            PORTNO='1521', \
                            ENV_PASSWD='IST_DB_PASSWORD', \
                            ENV_SERVNM='IST_SERVERNAME')
                            #SERVNM='clear3.jetpay.com')
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        print('Database credentials', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        config = configparser.ConfigParser()
        config.read('payables_report.cfg')

        if payables_object.funding_type == 'NORMAL_FUNDING':
            pay_clause = 'aad.payment_cycle != 5'
            inst_list = config['NORMAL_FUNDING']['INST_LIST']
        else:
            pay_clause = 'aad.payment_cycle = 5'
            inst_list = config['NEXTDAY_FUNDING']['INST_LIST']

        if arg_list.inst_id is None:
            for institution_id in inst_list.split(","):
                print('Inst: ', institution_id)
                payables_object.generate_report(db_object, institution_id,
                                                report_date, pay_clause)
        else:
            print('Inst: ', arg_list.inst_id)
            payables_object.generate_report(db_object, arg_list.inst_id,
                                            report_date, pay_clause)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of payables {}'.format(err)
        print(err_msg)
        payables_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of payables inside main function {}'.format(err)
        print(err_msg)
        payables_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
