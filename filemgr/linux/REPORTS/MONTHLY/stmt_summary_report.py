#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: stmt_summary_report.py 4897 2021-08-11 21:01:06Z pmaheswari $
$Rev: 4897 $
File Name:  stmt_summary_report.py

Description:  This class generates the statement summary report.

Arguments:  -i - Institution ID
            -d - Date in YYYYMMDD format(Optional)
            -v - Verbosity level
            -v    = logging.WARNING
            -vv   = logging.INFO
            -vvv  = logging.DEBUG                
            -t - Test option
                mail configuration is read from the test email
                file in testing phase
Output:     statement summary report

Return:     0 = Success
            !0 = Exit with errors
'''

#TO DO  change verbosity level, attach file date,
#add readme file show how to run in test mode with diff variations
import argparse
import csv
from datetime import datetime
from datetime import timedelta
import os
import sys

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

class StatementSummaryReportClass():
    """
    Name : StatementSummaryReportClass
    Description : StatementSummaryReportClass is used to generate the Statement Summary report
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
                                  CONFIG_SECTION_NAME='STATEMENT_SUMMARY_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, run_date, inst_id):
        """
        Name : generate_report
        Arguments: date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
                SELECT
                    substr(mtl.institution_id, 1, 4)                    AS  Inst,
                    substr(mtl.posting_entity_id, 1, 15)                AS  Entity,
                    ae.entity_dba_name                                  AS  name,
                    CASE when t.trans_class  = '07'
                        THEN  to_char(mtl.date_to_settle, 'YYYY-MM')
                        ELSE  to_char(mtl.gl_date, 'YYYY-MM') end       AS  "Stmt",
                    --mtl.gl_date                                       AS  gl_date,
                    --aad.payment_proc_dt,
                    COUNT(1)                                            AS  "Cnt",
                    SUM(mtl.nbr_of_items)                               AS  "Items",
                    SUM(
                        CASE WHEN mtl.tid_settl_method ='C'
                            THEN mtl.amt_original
                            ELSE -mtl.amt_original END)                AS "Amt Orig",
                    SUM(
                        CASE WHEN mtl.tid_settl_method ='C'
                            THEN mtl.amt_billing
                            ELSE -mtl.amt_billing END)                 AS "Amt Billing",
                    CASE WHEN mtl.tid LIKE '010004%'
                        THEN
                            CASE WHEN mtl.tid LIKE '01000428%'
                                THEN '010004280000'
                                ELSE '010004000000'
                            END
                        ELSE mtl.tid END                                AS TID ,
                    CASE
                        WHEN t.trans_class = '03' THEN 'Sales Refunds Chargebacks'
                        WHEN t.trans_class = '04' THEN 'Interchange and other Fees'
                        WHEN t.trans_class = '05' THEN 'Reserve Held'
                        WHEN t.trans_class = '07' THEN 'Reserve Paid'
                        ELSE 'Other'
                    END                                                 AS "Category",
                    CASE WHEN mtl.tid LIKE '010004%'
                        THEN
                            CASE WHEN mtl.tid LIKE '01000428%'
                                THEN 'ACH FEES'
                                ELSE 'FEES'
                            END
                        ELSE t.description END                  AS "TID Description"
                FROM mas_trans_log mtl
                join acq_entity ae
                on mtl.institution_id = ae.institution_id
                and mtl.posting_entity_id = ae.entity_id
                JOIN tid t
                ON t.tid = mtl.tid
                join acct_accum_det aad
                on mtl.institution_id = aad.institution_id
                and mtl.payment_seq_nbr = aad.payment_seq_nbr
                WHERE ( 
                ( mtl.date_to_settle >= to_date(:run_date,'YYYYMM') 
                  AND mtl.date_to_settle < last_day(to_date(:run_date, 'YYYYMM'))+1  
                  and t.trans_class  = '07' )
                OR (  mtl.gl_date >=  to_date(:run_date,'YYYYMM') AND            
                   mtl.gl_date  <last_day(to_date(:run_date, 'YYYYMM'))+1
                        and t.trans_class != '07' ) 
                 )      
                 AND mtl.institution_id in (:inst_id)
                group by
                    substr(mtl.institution_id, 1, 4),
                    substr(mtl.posting_entity_id, 1, 15),
                    ae.entity_dba_name,
                    CASE   when t.trans_class  = '07'
                        then  to_char(mtl.date_to_settle, 'YYYY-MM')
                        else  to_char(mtl.gl_date, 'YYYY-MM')           end,
                    CASE WHEN mtl.tid LIKE '010004%'
                        THEN
                            CASE WHEN mtl.tid LIKE '01000428%'
                                then '010004280000'
                                else '010004000000'
                            end
                        ELSE mtl.tid END,
                    CASE    WHEN t.trans_class = '03'   THEN 'Sales Refunds Chargebacks'
                        WHEN t.trans_class = '04'   THEN 'Interchange and other Fees'
                        WHEN t.trans_class = '05'   THEN 'Reserve Held'
                        WHEN t.trans_class = '07'   THEN 'Reserve Paid'
                        ELSE 'Other'        END,
                    CASE WHEN mtl.tid LIKE '010004%'
                        THEN
                            CASE WHEN mtl.tid LIKE '01000428%'
                                then 'ACH FEES'
                                else 'FEES'
                                end
                        ELSE t.description END
                ORDER BY
                    substr(mtl.institution_id, 1, 4),
                    substr(mtl.posting_entity_id, 1, 15),
                    TID
        """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            log_msg = 'Current_Date: {}'.format(datetime.now().strftime('%Y-%b-%d'))
            self.logger.info(log_msg)
            bind_str = {'run_date':run_date,'inst_id':inst_id}
            self.logger.info(bind_str)
            db_obj.ExecuteQuery(cur, sql_query, bind_str)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            query_result = db_obj.FetchResults(cur)
            log_msg = 'Total number of rows fetched:{}'.format(str(db_obj.dbCursor[cur].rowcount))
            self.logger.debug(log_msg)

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

           
            log_msg = 'File date:{}'.format(run_date)
            self.logger.info(log_msg)
            outFileName = '{}.stmt_summary_report.{}.csv'.format(inst_id,run_date)
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
                if self.mode == 'PROD':
                    email_sub = \
                            ('Statement Summary Report: %s' % outFileName)
                else:
                    email_sub = \
                        ('IGNORE: Testing Statement Summary Report : %s' \
                            % outFileName)

                # Email the file
                email_body = 'Successfully created the %s file.' % outFileName

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='STATEMENT_SUMMARY_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[outFileName]):
                    self.logger.error('Unable to send the Statement Summary report attachment')
                if not email_obj.SendEmail():
                    self.logger.error('An error occurred while sending email.\n')
                else:
                    self.logger.debug('Email sent successfully.\n')

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
        Description : Initializes the Statement Summary report class object.
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
            arg_parser.add_argument('-d', '-D', '--date', \
                        type=str, \
                        required=False, help='Date to run')
            arg_parser.add_argument('-i', '-I', '--inst_id', \
                        type=str, \
                        required=True, help='Inst ID to run')
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
        statement_summary_object = StatementSummaryReportClass('StatementSummary')

        #Parse the command line arguments
        arg_list = statement_summary_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            statement_summary_object.email_config_file = arg_list.test
            statement_summary_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            today = datetime.now()
            first = today.replace(day=1)
            last_month = first - timedelta(days=1)
            report_date = last_month.strftime('%Y%m')
            print('Date to run monthend report:', report_date)
        else:
            temp_report_date = datetime.strptime(arg_list.date, '%Y%m')
            report_date = temp_report_date.strftime('%Y%m')
            print('Date to run monthend report:', report_date)

        if arg_list.inst_id:
            inst_id = arg_list.inst_id
            print('Inst_ID: ', arg_list.inst_id)

        #set logger object verbose level
        log_res = statement_summary_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result - ', log_res)


        #Open database connection
        db_object = DbClass(ENV_HOSTNM='IST_HOST', \
                            ENV_USERID='IST_DB_USERNAME', \
                            PORTNO='1521', \
                            ENV_PASSWD='IST_DB_PASSWORD', \
                            ENV_SERVNM='IST_SERVERNAME')
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        print('Database credentials', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

        statement_summary_object.generate_report(db_object, report_date,inst_id)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of statement summary {}'.format(err)
        print(err_msg)
        statement_summary_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of statement summary inside main function {}'.format(err)
        print(err_msg)
        statement_summary_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
