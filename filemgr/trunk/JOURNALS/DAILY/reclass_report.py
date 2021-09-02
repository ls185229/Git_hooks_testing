#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: reclass_report.py 4897 2019-09-24 21:01:06Z skumar $
$Rev: 4897 $
File Name:  reclass_report.py

Description:  This class generates the reclass report for Visa and MC.

Arguments:   -d - Date in YYYYMMDD format(Optional)
             -v - Verbosity level
                -v    = logging.WARNING
                -vv   = logging.INFO
                -vvv  = logging.DEBUG                
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       reclass report

Return:   0 = Success
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

class ReclassReportClass():
    """
    Name : ReclassReportClass
    Description : ReclassReportClass is used to generate the reclass report
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

        email_sub = os.environ["MAS_BOX"] + ' - Err in ' + self.program_name
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                  CONFIG_SECTION_NAME='RECLASS_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, run_date):
        """
        Name : generate_report
        Arguments: date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
                select 
                    distinct ae.INSTITUTION_ID inst_id,
                    idm.merch_id MERCHANT_ID,
                    ae.entity_dba_name  MERCHANT_NAME,
                    --vrra.submt_fee_prog_ind ,
                    min(firs.MAS_DESC) REQUESTED_FPI_DESC,
                    --vrra.ASSES_FEE_PROG_IND,
                    min(fir.mas_desc) RECLASSED_FPI_DESC,
                    case idm.card_scheme 
                      when '04' then vrra.FEE_RECLASS_REASON
                      when '05' then idm.MSG_TEXT_BLOCK
                    end reclass_reason,
                    substr(idm.pan,1,6)||'xxxxxx'|| substr(idm.pan,13,4)    PAN,
                    idm.CARD_SCHEME,
                    count(distinct idm.arn) count,
                    sum(idm.amt_trans * power(10, -idm.TRANS_EXP)) AMOUNT
                from in_draft_view idm
                left outer join visa_rtn_rclas_adn vrra
                on vrra.trans_seq_nbr = idm.trans_seq_nbr
                join acq_entity ae
                on idm.merch_id = ae.entity_id
                left outer join flmgr_interchange_rates fir
                on ((vrra.asses_fee_prog_ind = fir.fpi_ird
                and fir.card_scheme = '04')
                or (idm.MAS_CODE_DOWNGRADE = fir.MAS_CODE
                and fir.card_scheme = '05'))
                and fir.usage = 'INTERCHANGE'
                left outer join flmgr_interchange_rates firs
                on ((vrra.submt_fee_prog_ind = firs.fpi_ird
                and firs.card_scheme = '04')
                or (idm.MAS_CODE = firs.MAS_CODE
                and firs.card_scheme = '05'))
                and firs.usage = 'INTERCHANGE'    
                where 
                idm.activity_dt between :start_date and :end_date
                and idm.card_scheme in ('04','05')
                and idm.major_cat = 'RECLASS'
                group by ae.INSTITUTION_ID ,
                    idm.merch_id ,
                    ae.entity_dba_name  ,
                  case idm.card_scheme 
                       when '04' then vrra.FEE_RECLASS_REASON
                       when '05' then idm.MSG_TEXT_BLOCK
                  end,
                    substr(idm.pan,1,6)||'xxxxxx'|| substr(idm.pan,13,4)    ,
                    idm.CARD_SCHEME
                order by idm.merch_id,
                    ae.entity_dba_name
        """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            #temp_date = datetime.strptime(run_date, '%d-%b-%Y')
            log_msg = 'Start Date: {}'.format(run_date.strftime('%d-%b-%Y'))
            self.logger.info(log_msg)
            end_date = (run_date + timedelta(days=1))
            log_msg = 'End Date: {}'.format(end_date.strftime('%d-%b-%Y'))
            self.logger.info(log_msg)
            bind_str = {'start_date':run_date, 'end_date':end_date}
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

            file_date = run_date.strftime('%Y%m%d')
            log_msg = 'File date:{}'.format(file_date)
            self.logger.info(log_msg)
            outFileName = 'reclass_report_{}.csv'.format(file_date)
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
                            ('Reclass Report: %s' % outFileName)
                else:
                    email_sub = \
                        ('IGNORE: Testing Reclass Report : %s' \
                            % outFileName)

                # Email the file
                email_body = 'Successfully created the %s file.' % outFileName

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='RECLASS_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[outFileName]):
                    self.logger.error('Unable to send the reclass report attachment')
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
        Description : Initializes the reclass report class object.
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
        reclass_object = ReclassReportClass('reclass')

        #Parse the command line arguments
        arg_list = reclass_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            reclass_object.email_config_file = arg_list.test
            reclass_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%Y%m%d')
            print('Date to run reclass report:', report_date)
        else:
            report_date = datetime.strptime(arg_list.date, '%Y%m%d')
            print('Date to run reclass report:', report_date)

        #set logger object verbose level
        log_res = reclass_object.set_logger_level(arg_list.verbose)
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

        reclass_object.generate_report(db_object, report_date)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of reclass {}'.format(err)
        print(err_msg)
        reclass_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of reclass inside main function {}'.format(err)
        print(err_msg)
        reclass_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
