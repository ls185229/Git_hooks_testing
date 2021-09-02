#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: onetime_report.py 4897 2020-09=07-24 21:01:06Z smiller $
$Rev: 4897 $
File Name:  onetime_report.py

Description:  This class generates the onetime report for a given institution id.

Arguments:   -d - Date in YYYYMMDD format(Optional)
             -i - Institution ID
             -v - Verbosity level
                -v    = logging.WARNING
                -vv   = logging.INFO
                -vvv  = logging.DEBUG
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       Onetime report

Return:   0 = Success
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

class ReportClass():
    """
    Name : ReportClass
    Description : ReportClass is used to generate the onetime report
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
                                  CONFIG_SECTION_NAME='ONETIME_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, inst_id, run_date):
        """
        Name : generate_report
        Arguments: database object, institution id, configparser object and date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
                select
                    substr(enfp.institution_id,1,4) Inst,
                    substr(enfp.entity_id, 1, 15) entity_id,
                    substr(ae.entity_dba_name,1,25) entity_dba_name,
                    naf.fee_amt Amt_planned,
                    CASE WHEN t.tid_settl_method like 'C'  THEN 'Cr'
                                                           else 'Db'
                    END   DbCr,
                    to_char(
                    CASE WHEN mtl.tid is null THEN naf.next_generate_date
                                              else mtl.gl_date
                    END, 'DD-MON-YY')   gen_date,
                    --naf.tid,
                    --naf.mas_code,
                    --naf.last_generate_date,
                    --naf.next_generate_date,
                    --mtl.entity_id,
                    --mtl.tid,
                    substr(naf.mas_code,1,12) m_c,
                    substr(mc.mas_desc,1,29) descr,
                    mtl.amt_billing  amt,
                    mtl.tid_settl_method DbCr,
                    mtl.date_to_settle settle,
                    --mtl.gl_date GL,
                    enfp.non_act_fee_pkg_id n_a_f_p
                from ent_nonact_fee_pkg enfp

                join  non_activity_fees naf
                on enfp.institution_id = naf.institution_id
                and enfp.non_act_fee_pkg_id = naf.non_act_fee_pkg_id

                join mas_code mc
                on naf.mas_code = mc.mas_code

                join tid t
                on t.tid = naf.tid

                join acq_entity ae
                on enfp.institution_id = ae.institution_id
                and enfp.entity_id = ae.entity_id

                left outer join mas_trans_log mtl
                on enfp.institution_id = mtl.institution_id
                and enfp.non_act_fee_pkg_id = mtl.non_act_fee_pkg_id
                and (enfp.entity_id = mtl.posting_entity_id or enfp.entity_id = mtl.entity_id)

                where


                mtl.gl_date = to_date(:run_file_date,'YYYYMMDD')
                and mtl.tid LIKE '01000435%'
                and mtl.institution_id = :inst_id
                
        """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            bind_str = {'run_file_date':run_date, 'inst_id':inst_id}
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

            outFileName = '{}.one_time.{}.csv'.format(inst_id, run_date)
            log_msg = 'Output file name: {}'.format(outFileName)
            self.logger.info(log_msg)
            fullFilePath = '/clearing/filemgr/REPORTS/DAILY/ARCHIVE/{}'.format(outFileName)

            #Retrieve Column names
            col_names = []
            for row in db_obj.dbCursor[cur].description:
                col_names .append(row[0])
            tup_col_names = tuple(col_names)
            self.logger.info(tup_col_names)

            # Open the output csv file
            with open(fullFilePath, mode='w+', newline='') as csv_file:
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


    def send_file(self, inst_id, report_date, outFileName, db_obj):
        """
        Name : send_email
        Arguments: outFileName
        Description : sends file to relevant party
        Returns: Nothing
        """

        try:
            message = 'Attached are the one time fees report for {} on {}'.format(inst_id, report_date)
            email_sub = 'One Time fees for {} {}'.format(inst_id, report_date)
            fileList = [outFileName]

            cfg_obj = configparser.ConfigParser()
            if not cfg_obj.read('onetime_report.cfg'):
                raise LocalException('Unable to read onetime_report.cfg file')

            email_obj = EmailClass(FROM_ADDRESS=cfg_obj['email']['fromaddress'], \
                                      TO_ADDRESS=cfg_obj['email']['toaddress'], \
                                      EMAIL_BODY=message, \
                                      EMAIL_SUBJECT=email_sub)
            if fileList:
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER="/clearing/filemgr/REPORTS/DAILY/ARCHIVE", \
                             ATTACH_FILES_LIST=fileList):
                    self.logger.info('Report Email Failed')
            if not email_obj.SendEmail():
                self.logger.error('An error occurred while sending email.\n')
            else:
                self.logger.info('Report Email sent successfully.\n')
        except LocalException as err:
            err_mesg = 'Unable to read the onetime_report.cfg file: {}'.format(err)
            self.logger.error(err_mesg)
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
        Description : Initializes the onetime report class object.
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
                        'Produce report of onetime fees.')
            arg_parser.add_argument('-v', '-V', '--verbose', \
                        action='count', dest='verbose', required=False, \
                        help='verbose level  repeat up to five times.')
            arg_parser.add_argument('-i', '-I', '--inst_id', dest='inst_id', \
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
    Description: This script produces a report of onetime fees
    Arguments: input file, mode, verbosity level and cycle
    """
    try:
        report_object = ReportClass('OneTime')

        #Parse the command line arguments
        arg_list = report_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            report_object.email_config_file = arg_list.test
            report_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)


        if arg_list.inst_id is None:

            print('Institution ID: None')
        else:
            inst_id = arg_list.inst_id
            print('Institution ID:', inst_id)

        #data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%Y%m%d')
            print('Date to run onetime report:', report_date)
        else:
            report_date = arg_list.date
            print('Date to run onetime report:', report_date)

        #set logger object verbose level
        log_res = report_object.set_logger_level(arg_list.verbose)
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

        outFileName = report_object.generate_report(db_object, \
                                                     inst_id, \
                                                      report_date)
        print('outFileName:', outFileName)
        if outFileName is None:
            raise Exception('generate_report didnt make a file')

        report_object.send_file(inst_id, report_date, outFileName, db_object)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except configparser.Error as err:
        err_msg = 'Error: while reading or parsing the config file {}'.format(err)
        print(err_msg)
        report_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except LocalException as err:
        err_msg = 'Error: During database connection or execution of onetime {}'.format(err)
        print(err_msg)
        report_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of onetime inside main function {}'.format(err)
        print(err_msg)
        report_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
