#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: mon_min_fanf_refund_fix.py 4897 2019-09-24 21:01:06Z skumar $
$Rev: 4897 $
File Name:  mon_min_fanf_refund_fix.py

Description:  This class generates the monthly minimum and FANF refund fees.

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

class MonMinFanfClass():
    """
    Name : MonMinFanfClass
    Description : MonMinFanfClass is used to generate the monthly minimum
                  and FANF refund fee file
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
                                  CONFIG_SECTION_NAME='MONMIN_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_fanf_refund_report(self, db_obj, run_date):
        """
        Name : generate_fanf_refund_report
        Arguments: date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
            select
                mtl.ENTITY_ID ENTITY_ID,
                '04' "Card Type",
                '010004350005' "TID",
                substr(  mtl.mas_code, 0, length( mtl.mas_code)-3)  "Fee Code",
                to_char(trunc(sysdate),'DD-MON-YY')   "Date",
                mtl.AMT_BILLING "Fee Amt",
                'ONE-TIME',
                mtl.ENTITY_ID || ' for total of ' || mtl.AMT_BILLING  description
            from mas_trans_log mtl
            join acq_entity ae
                on ae.INSTITUTION_ID = mtl.INSTITUTION_ID
                and ae.entity_id = mtl.entity_id
            join mas_code mc
                on mc.mas_code = mtl.mas_code
            where
               trunc(mtl.gl_date) = :report_date
               and mtl.mas_code like 'FANF%'
               and ae.DEFAULT_MCC = '8398'
               and mtl.AMT_BILLING != 0
               and tid not like '01000435000%'
            order by 1,2            
        """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            #temp_date = datetime.strptime(run_date, '%d-%b-%Y')
            temp_date = datetime.strptime(run_date, '%Y%m%d').strftime('%d-%b-%Y')
            print('temp_date: {0}'.format(temp_date))

            # bind_str = {'report_date':run_date}
            bind_str = {'report_date':temp_date}

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

            # file_date = run_date.strftime('%Y%m%d')
            file_date = datetime.strptime(run_date, '%Y%m%d')
            log_msg = 'File date:{}'.format(file_date)
            self.logger.info(log_msg)
            fanffile = 'fanf_refund_feefile_{}.csv'.format(file_date.strftime('%Y%m%d'))
            log_msg = 'Output file name: {}'.format(fanffile)
            self.logger.info(log_msg)

            #Retrieve Column names
            col_names = []
            for row in db_obj.dbCursor[cur].description:
                col_names .append(row[0])
            tup_col_names = tuple(col_names)
            self.logger.info(tup_col_names)

            # Open the output csv file
            with open(fanffile, mode='w+', newline='') as csv_file:
                file_open = True
                csv_writer_obj = \
                        csv.writer(csv_file, dialect='excel', \
                                        delimiter=',', \
                                        quotechar=None, \
                                        skipinitialspace=True, \
                                        quoting=csv.QUOTE_NONE, \
                                        escapechar='')
                #csv_writer_obj.writerow(tup_col_names)


                #Now write the extracted data to the csv file
                cnt = 1
                for row_data in query_result:
                    csv_writer_obj.writerow(row_data)
                    cnt = cnt + 1

            if file_open:
                csv_file.close()
                fanf_query_file_name = 'fanf_query_{}.txt'.format(file_date)
                query_file = open(fanf_query_file_name, 'w')
                query_file.write(sql_query)
                query_file.close()
                if self.mode == 'PROD':
                    email_sub = \
                            ('FANF Refund Fee file Report: %s' % fanffile)
                else:
                    email_sub = \
                        ('IGNORE: Testing FANF Refund Fee file Report : %s' \
                            % fanffile)

                # Email the file
                email_body = 'Attached the %s file.' % fanffile

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='MONMIN_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[fanffile, fanf_query_file_name]):
                    self.logger.error('Unable to send the FANF Refund Fee file attachment')
                if not email_obj.SendEmail():
                    self.logger.error('An error occurred while sending email.\n')
                else:
                    self.logger.debug('Email sent successfully.\n')

                mv_cmd = "mv {} ARCHIVE/"
                os.system(mv_cmd.format(fanffile))
                os.system(mv_cmd.format(fanf_query_file_name))

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

    def generate_mon_min_report(self, db_obj, run_date):
        """
        Name : generate_mon_min_report
        Arguments: date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            sql_query = """
            Select distinct
                    entity_id                                       "Entity Id",
                   '00'                                             "Card Scheme",
                    case when ((CASE 
                         WHEN mas_code in ('00MONMIN')    then "Min_Fee"
            	           WHEN mas_code in ('00ACHPRC')    then "ACH_Fee_Sum"
            	           WHEN mas_code in ('00ACHMONMIN') then "ACH_Min_Fee"
                     END) -
                        case when fee_rate <= Appl_Fees then 0
                             when Appl_Fees < 0 then fee_rate
                             else fee_rate - Appl_Fees end) > 0
                      then '010004350005' 
                      else '010004350000' end                       "tid",
                    mas_code                                        "Mas Code",
                    to_char(trunc(sysdate),'DD-MON-YY')             "Date",
                    abs((CASE 
                         WHEN mas_code in ('00MONMIN')    then "Min_Fee"
            	           WHEN mas_code in ('00ACHPRC')    then "ACH_Fee_Sum"
            	           WHEN mas_code in ('00ACHMONMIN') then "ACH_Min_Fee"
                     END) -
                        case when fee_rate <= Appl_Fees then 0
                             when Appl_Fees < 0 then fee_rate
                             else fee_rate - Appl_Fees end)
                                                                    "Fee Amount",
                    'ONE-TIME' ,
                  ENTITY_ID || ' for total of ' ||        abs((CASE 
                         WHEN mas_code in ('00MONMIN')    then "Min_Fee"
            	           WHEN mas_code in ('00ACHPRC')    then "ACH_Fee_Sum"
            	           WHEN mas_code in ('00ACHMONMIN') then "ACH_Min_Fee"
                     END) -
                        case when fee_rate <= Appl_Fees then 0
                             when Appl_Fees < 0 then fee_rate
                             else fee_rate - Appl_Fees end) as "Description" 
                from (
                    select
                        mtl.institution_id,
                        trunc(gl_date, 'MM') gl_mnth,
                        mtl.entity_id, ae.ENTITY_DBA_NAME,
                        naf.mas_code,
                        -- mtl.tid,
                        naf.fee_amt fee_rate,
                        SUM(CASE WHEN mtl.tid in ('010004130000', '010004730000') THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "Auth_Sum",
                        SUM(CASE WHEN mtl.tid in ('010004120000', '010004720000') THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "Stl_Sum",
                        SUM(CASE WHEN mtl.TID like '01000472%'
                                  and mtl.tid !=  '010004720000'                  THEN (mtl.AMT_BILLING - mtl.AMT_ORIGINAL) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "Dbt_Ntw",
                        SUM(CASE WHEN mtl.tid =   '010004010000'                  THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "401_Sum",
                        SUM(CASE WHEN mtl.tid in ('010004020000','010004030000')  THEN (mtl.AMT_BILLING - mtl.AMT_ORIGINAL) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "402_3_Sum",
                        sum(CASE WHEN mtl.mas_code in ('00MONMIN')                THEN (mtl.AMT_billing                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "Min_Fee",
                        SUM(CASE WHEN mtl.mas_code in ('00ACHPRC')                THEN (mtl.AMT_billing                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "ACH_Fee_Sum",
                        sum(CASE WHEN mtl.mas_code in ('00ACHMONMIN')             THEN (mtl.AMT_billing                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) AS "ACH_Min_Fee",
                        (
                        SUM(CASE WHEN mtl.tid in ('010004130000', '010004730000') THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) +
                        SUM(CASE WHEN mtl.tid in ('010004120000', '010004720000') THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) +
                        SUM(CASE WHEN mtl.TID like '01000472%'
                                  and mtl.tid != '010004720000'                   THEN (mtl.AMT_BILLING - mtl.AMT_ORIGINAL) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) +
                        SUM(CASE WHEN mtl.tid =   '010004010000'                  THEN (mtl.AMT_BILLING                   ) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END) +
                        SUM(CASE WHEN mtl.tid in ('010004020000','010004030000')  THEN (mtl.AMT_BILLING - mtl.AMT_ORIGINAL) * case when mtl.tid_settl_method = 'D' then 1 else -1 end ELSE 0 END)
                        ) Appl_fees,
                        count(*) cnt,
                        min(gl_date) min_gl,
                        max(gl_date) max_gl
                    from mas_trans_log mtl
                    join acq_entity ae
                    on  mtl.ENTITY_ID      = ae.ENTITY_ID
                    AND mtl.INSTITUTION_ID = ae.INSTITUTION_ID
                    join ENT_NONACT_FEE_PKG enfp
                    on  enfp.institution_id = mtl.institution_id
                    and enfp.entity_id      = mtl.entity_id
                    join NON_ACTIVITY_FEES naf
                    on  naf.INSTITUTION_ID      = enfp.INSTITUTION_ID
                    AND naf.NON_ACT_FEE_PKG_ID  = enfp.NON_ACT_FEE_PKG_ID
                    where (
                        mtl.gl_date BETWEEN trunc(:report_date, 'MM') AND LAST_DAY(:report_date)
                    AND (
                        mtl.TID IN (
                            '010004010000', '010004020000', '010004030000', '010004280004', '010004280000',
                            '010004720000', '010004730000', '010004130000', '010004120000', '010004720000'
                        )
                        or  (mtl.mas_code in ('00MONMIN', '00ACHMONMIN', '00ACHPRC')
                            and mtl.tid not like '01000435%'
                            )
                        or mtl.TID like '01000472%'
                    )
                    and mtl.tid not like '01007%'
                    )
                    and naf.mas_code in ('00MONMIN', '00ACHMONMIN')
                    and enfp.END_DATE is null
                     and mtl.institution_id in ('101', '105', '107', '121' )
            and (
                 naf.mas_code in ('00MONMIN') and mtl.tid not like '01000428%'
            	  or naf.mas_code in ('00ACHPRC') and mtl.tid like '01000428%'
            	  or naf.mas_code in ('00ACHMONMIN') and mtl.tid like '01000428%'
             )
                     and mtl.institution_id in ('101', '105', '107', '121' )
                    group by mtl.institution_id, mtl.ENTITY_ID, ae.ENTITY_DBA_NAME,
                        naf.mas_code,
                        --mtl.tid,
                        naf.fee_amt,
                        trunc(gl_date, 'MM')
                )
                where
                            abs((CASE 
                         WHEN mas_code in ('00MONMIN')    then "Min_Fee"
            	           WHEN mas_code in ('00ACHPRC')    then "ACH_Fee_Sum"
            	           WHEN mas_code in ('00ACHMONMIN') then "ACH_Min_Fee"
                     END) -
                        case when fee_rate <= Appl_Fees then 0
                             when Appl_Fees < 0 then fee_rate
                             else fee_rate - Appl_Fees end) != 0
            order by entity_id
        """

            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            #temp_date = datetime.strptime(run_date, '%d-%b-%Y')
            temp_date = datetime.strptime(run_date, '%Y%m%d')
            print('temp_date: {0}'.format(temp_date))

            # bind_str = {'report_date':run_date}
            bind_str = {'report_date':temp_date}
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

            # file_date = run_date.strftime('%Y%m%d')
            file_date = datetime.strptime(run_date, '%Y%m%d').strftime('%Y%m%d')
            log_msg = 'File date:{}'.format(file_date)
            self.logger.info(log_msg)
            monminfile = 'mon_min_fixup_feefile{}.csv'.format(file_date)
            log_msg = 'Output file name: {}'.format(monminfile)
            self.logger.info(log_msg)

            #Retrieve Column names
            col_names = []
            for row in db_obj.dbCursor[cur].description:
                col_names .append(row[0])
            tup_col_names = tuple(col_names)
            self.logger.info(tup_col_names)

            # Open the output csv file
            with open(monminfile, mode='w+', newline='') as csv_file:
                file_open = True
                csv_writer_obj = \
                        csv.writer(csv_file, dialect='excel', \
                                        delimiter=',', \
                                        quotechar=None, \
                                        skipinitialspace=True, \
                                        quoting=csv.QUOTE_NONE, \
                                        escapechar='')
                #csv_writer_obj.writerow(tup_col_names)


                #Now write the extracted data to the csv file
                cnt = 1
                for row_data in query_result:
                    csv_writer_obj.writerow(row_data)
                    cnt = cnt + 1

            if file_open:
                csv_file.close()
                mon_query_file_name = 'mon_min_query_{}.txt'.format(file_date)
                query_file = open(mon_query_file_name, 'w')
                query_file.write(sql_query)
                query_file.close()
                if self.mode == 'PROD':
                    email_sub = \
                            ('Monthly Minimum Fixup Fee file Report: %s' % monminfile)
                else:
                    email_sub = \
                        ('IGNORE: Testing Monthly Minimum Fixup Fee file Report : %s' \
                            % monminfile)

                # Email the file
                email_body = 'Attached the %s file.' % monminfile

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='MONMIN_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[monminfile, mon_query_file_name]):
                    self.logger.error('Unable to send the Monthly Minimum FANF Refund Fee file attachment')
                if not email_obj.SendEmail():
                    self.logger.error('An error occurred while sending email.\n')
                else:
                    self.logger.debug('Email sent successfully.\n')

                mv_cmd = "mv {} ARCHIVE/"
                os.system(mv_cmd.format(monminfile))
                os.system(mv_cmd.format(mon_query_file_name))

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
        self.mode = None
        self.email_config_file = None

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
                        'Generate monthly min and FANF refund fee file')
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
        mon_min_fanf_object = MonMinFanfClass('mon_min_fanf')

        #Parse the command line arguments
        arg_list = mon_min_fanf_object.parse_arguments()

        # test mode override the default mail id
        if arg_list.test.upper() == 'TEST':
            mon_min_fanf_object.email_config_file = '{0}/test_email_config.ini'.format(os.getcwd())
            mon_min_fanf_object.mode = 'TEST'
            print('email config file name: ', mon_min_fanf_object.email_config_file)
        else:
            mon_min_fanf_object.email_config_file = 'email_config.ini'
            mon_min_fanf_object.mode = 'PROD'

        # data is not passed assign current date
        if arg_list.date is None:
            report_date = datetime.now().strftime('%Y%m%d')
            print('Date to run mon_min_fanf report:', report_date)
        else:
            report_date = datetime.strptime(arg_list.date, '%Y%m%d')
            print('Date to run mon_min_fanf report:', report_date)

        # set logger object verbose level
        log_res = mon_min_fanf_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result - ', log_res)

        # Open database connection
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

        mon_min_fanf_object.generate_fanf_refund_report(db_object, report_date)
        mon_min_fanf_object.generate_mon_min_report(db_object, report_date)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of mon_min_fanf {}'.format(err)
        print(err_msg)
        mon_min_fanf_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of mon_min_fanf inside main function {}'.format(err)
        print(err_msg)
        mon_min_fanf_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
