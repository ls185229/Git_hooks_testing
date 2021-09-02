#!/usr/bin/env python
'''
$Id: sch_exp_reprocessed_tc57.py 4792 2019-01-02 21:07:58Z skumar $
$Rev: 4792 $
File Name:  sch_exp_reprocessed_tc57.py

Description:  This class is used to schedule export tasks for
              reprocessed TC57 suspends
Arguments:   -d - Date in YYYYMMDD format(Optional)
             -v - Verbosity level
                -v = logging.DEBUG
                -vv = logging.INFO
                -vvv = logging.WARNING
                -vvvv = logging.ERROR
                -vvvvv = logging.CRITICAL
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       Schedule the export task for MC and MAS in database

Return:   0 = Success
          !0 = Exit with errors
'''
# The following are pylint directives to suppress some pylint warnings that you
# do not care about.
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = no-self-use

import argparse
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
    Description: A local exception class to post exceptions local to this
                 module. The local exception class is derived from the Python
                 base exception class. It is used to throw other types of
                 exceptions that are not in the standard exception class.
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)

class ExportTC57Reprocessed():
    """
    Name : ExportTC57Reprocessed
    Description : ExportTC57Reprocessed is used to schedule the
                  Mastercard and MAS export task for the
                  reprocessed TC57 suspends
    Arguments: module name
               eg: ExportTC57Reprocessed('sch_exp_reprocessed_tc57')
    """
    # Private class attributes
    program_name = None
    mode = None
    logger = None
    inst_list = []

    def send_alert(self, message):
        """
        Name : send_alert
        Arguments: message
        Description : send the alert whenever an error occurred
                      during the process
        Returns: Nothing
        """

        email_sub = os.environ["HOSTNAME"] + ' - Err in ' + self.program_name
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                  CONFIG_SECTION_NAME='EXP_TC57_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

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
            else:
                log_level = logging.WARNING

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
        self.inst_list = "101,105,107,121,122,130,134".split(',')
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
                        'Export reprocessed suspends.')
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

    def get_dest_file_type(self, db_object, date_to_run):
        """
        Name : get_dest_file_type
        Arguments: Database connection handler and data to run
        Description : Get the institution_id and dest_file_type
                      which are ready to be reprocessed
        Returns: None
        """
        try:
            msg = 'Function parameters date_to_run : {}'.format(date_to_run)
            self.logger.info(msg)
            select_query = """
            SELECT DISTINCT
                ifl.institution_id     inst_id, 
                cb.dest_file_type      file_type,
                cb.clr_date_j          jul_date
            FROM
                in_file_log ifl
                join cutoff_batch cb
                on ifl.in_file_nbr = cb.in_file_nbr
            WHERE
                ifl.file_type = '01'
                and trunc(ifl.incoming_dt) = :file_date
                and ifl.external_file_name NOT LIKE '%tc57%'
                and cb.cutoff_status = 'R'
                and cb.dest_file_type in ('55','21')
            ORDER BY
                ifl.institution_id, cb.dest_file_type
            """
            self.logger.info(select_query)
            cur = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            select_query_bind = {'file_date': date_to_run}
            msg = 'Bind variables : {}'.format(select_query_bind)
            self.logger.info(msg)
            db_object.ExecuteQuery(cur, select_query, select_query_bind)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            #msg = 'ExecuteQuery result : {}'.format(res)
            #self.logger.info(msg)
            query_result = db_object.FetchResults(cur)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            msg = 'query_result: {}'.format(query_result)
            self.logger.info(msg)
            if query_result:
                cnt = 0
                for result in query_result:
                    inst_id = result[0]
                    file_type = result[1]
                    jul_date = result[2]
                    cnt = cnt + 1
                    msg = 'query_result inst_id:{}, file_type:{}, jul_date:{}'\
                          .format(inst_id, file_type, jul_date)
                    self.logger.info(msg)
                    if self.inst_list.count(inst_id) > 0:
                        msg = 'Inst:{} found in inst_list:'.format(inst_id)
                        self.logger.info(msg)
                        self.schedule_task(db_object, inst_id, file_type, cnt)
                    else:
                        msg = 'Inst:{} not found in inst_list:'.format(inst_id)
                        self.logger.info(msg)
            else:
                self.logger.info('No results returned from select_query \n')

            db_object.CloseCursor(cur)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

        except LocalException as err:
            err_msg = 'During database query execution {}'.format(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
            db_object.Disconnect()
            sys.exit()

    def schedule_task(self, db_object, inst_id, file_type, cnt):
        """
        Name : schedule_task
        Arguments: Database connection handler, institution_id, file_type, timer counter
        Description : Schedule the export task based on the input arguments
        Returns: None
        """
        try:
            msg = 'In schedule_task function args inst_id:{}, file_type:{}'\
                   .format(inst_id, file_type)
            self.logger.info(msg)
            timer = cnt * 2
            run_time = datetime.now() + timedelta(minutes=timer)
            run_hour = run_time.strftime("%H")
            run_min = run_time.strftime("%M")
            task_nbr = '3'+file_type
            update_query = """
            update tasks
                set run_hour = :run_hour,
                run_min  = :run_min
            where institution_id = :inst_id
            and task_nbr = :task_nbr
            and usage = 'CLEARING'
            """
            self.logger.info(update_query)
            upd_cur = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            update_query_bind = {'run_hour':run_hour, 'run_min':run_min, \
                                 'inst_id':inst_id, 'task_nbr':task_nbr}
            msg = 'Bind variables : {}'.format(update_query_bind)
            self.logger.info(msg)

            result = db_object.ExecuteQuery(upd_cur, update_query, update_query_bind)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            msg = 'Update query result:{}'.format(result)

            db_object.CloseCursor(upd_cur)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            if self.mode == 'PROD':
                db_object.Commit()
            else:
                db_object.Rollback()

        except LocalException as err:
            err_msg = 'During database schedule_task execution {}'.format(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
            db_object.Rollback()
            db_object.Disconnect()
            sys.exit()


if __name__ == "__main__":
    """
    Name : main
    Description: This script schedule export task for reprocessed suspends
    Arguments: mode, verbosity level and date to run
    """
    try:
        export_object = ExportTC57Reprocessed('sch_exp_reprocessed_tc57')

        #Parse the command line arguments
        arg_list = export_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            export_object.email_config_file = arg_list.test
            export_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #data is not passed assign current date
        if arg_list.date is None:
            run_date = datetime.now().strftime('%d-%b-%Y')
            print('Date to run sch_exp_reprocessed_tc57 report:', run_date)
        else:
            run_date = datetime.strptime(arg_list.date, '%Y%m%d')
            run_date = run_date.strftime('%d-%b-%Y')
            print('Date to run sch_exp_reprocessed_tc57 report:', run_date)

        #set logger object verbose level
        log_res = export_object.set_logger_level(arg_list.verbose)
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

        config = configparser.ConfigParser()
        config.read('sch_exp_reprocessed_tc57.cfg')
        export_object.inst_list = config['EDIT_16']['INST_LIST'].split(',')

        export_object.get_dest_file_type(db_object, run_date)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of \
                   sch_exp_reprocessed_tc57 {}'.format(err)
        print(err_msg)
        export_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of sch_exp_reprocessed_tc57 \
                   inside main function {}'.format(err)
        print(err_msg)
        export_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
