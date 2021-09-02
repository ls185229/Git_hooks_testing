#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
'''
$Id: monthend_report.py 4897 2019-09-24 21:01:06Z skumar $
$Rev: 4897 $
File Name:  monthend_report.py

Description:  This class generates the monthend report for a given institution id.

Arguments:   -d - Date in YYYYMM format(Optional)
             -i - Institution ID
             -v - Verbosity level
                -v    = logging.WARNING
                -vv   = logging.INFO
                -vvv  = logging.DEBUG
             -t - Test option
                  mail configuration is read from the test email
                  file in testing phase
Output:       Monthend report

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
# Probably returning errors due to not being connected to the server
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

class MonthEndReportClass():
    """
    Name : MonthEndReportClass
    Description : MonthEndReportClass is used to generate the monthend report
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
                                  CONFIG_SECTION_NAME='MONTHEND_ALERTS', \
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
            # Deleted the previous sql command and replaced it with the sql command
            # from esquire_monthend.tcl
            sql_query = """
                SELECT '8847'                                          AS Bank,
                mtv.institution_id,
                '''' || mtv.ENTITY_ID AS EntityID,   
                replace(ae.ENTITY_DBA_NAME,',',' ')            AS ENTITYDBANAME,
                replace(ae.ENTITY_NAME,',',' ')                   AS ENTITYNAME,
                ae.DEFAULT_MCC                                           AS MCC,
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                THEN 1 ELSE  0 END * mtv.AMOUNT)                AS VisaSalesAmount,
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                THEN 1 ELSE  0 END)                             AS VisaSalesCount,            
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                THEN 1 ELSE  0 END  * mtv.AMOUNT)               AS VisaReturnsAmount,
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04'
                THEN 1 ELSE  0 END)                             AS VisaReturnsCount,
                
                SUM(
                CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                THEN 1 ELSE  0 END * mtv.AMOUNT)                 AS MCSalesAmount,           
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                THEN 1 ELSE  0 END)                              AS MCSalesCount,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                THEN 1 ELSE  0 END * mtv.AMOUNT)                AS MCReturnsAmount,
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                THEN 1 ELSE  0 END)                             AS MCReturnsCount,               
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND UPPER(mc.MAS_DESC) like '%INTL%'
                THEN 1 ELSE  0 END * mtv.AMOUNT)                AS MCIntSales,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND UPPER(mc.MAS_DESC) like '%INTL%'
                THEN 1 ELSE  0 END * mtv.AMOUNT)                AS MCIntReturns,
                            
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'SALES' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND UPPER(mc.MAS_DESC) like '%INTL%'
                THEN 1 ELSE  0 END)                            AS MCIntSalesCount,            
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND UPPER(mc.MAS_DESC) like '%INTL%'
                THEN 1 ELSE  0 END) AS MCIntReturnsCount,
                            
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'DISPUTES' 
                AND mtv.CARD_SCHEME = '04'
                THEN 1 ELSE  0 END * mtv.AMOUNT)               AS VisaDisputesAmount,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'DISPUTES' 
                AND mtv.CARD_SCHEME = '04'
                THEN 1 ELSE  0 END)                            AS VisamonthendsCount,            
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'DISPUTES' 
                AND mtv.CARD_SCHEME = '05'
                THEN 1 ELSE  0 END * mtv.AMOUNT)               AS MCDisputesAmount,
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'DISPUTES' 
                AND mtv.CARD_SCHEME = '05'
                THEN 1 ELSE  0 END)                            AS MCDisputesCount,               
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT IN ('SALES', 'REFUNDS') 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                AND mcg.mas_code in ('VSDB', 'VSPP')
                THEN 1 ELSE  0 END)                            AS VisaDebitCounts,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT IN ('SALES', 'REFUNDS') 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                AND mcg.mas_code in ('VSDB', 'VSPP')
                THEN 1 ELSE  0 END * mtv.AMOUNT)              AS VisaDebitSalesAmount,
                            
                SUM(CASE 
                WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                AND mcg.mas_code in ('VSDB','VSPP')
                THEN 1 ELSE  0 END)                           AS VisaDebitReturnsCount, 
                            
                SUM(CASE WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '04' 
                AND mcg.mas_code in ('VSDB','VSPP')
                THEN 1 ELSE  0 END * mtv.AMOUNT)              AS VisaDebitReturnsAmount,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT IN ('SALES', 'REFUNDS') 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND mcg.mas_code in ('MCDB','MCPP')
                THEN 1 ELSE  0 END )                           AS MCDebitCounts,
                
                SUM(CASE 
                WHEN mtv.MAJOR_CAT IN ('SALES', 'REFUNDS') 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND mcg.mas_code in ('MCDB','MCPP')
                THEN 1 ELSE  0 END * mtv.AMOUNT)               AS MCDebitSalesAmount,
                
                SUM(CASE WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND mcg.mas_code in ('MCDB','MCPP')
                THEN 1 ELSE  0 END)                            AS MCDebitReturnsCount,   
                
                SUM(CASE WHEN mtv.MAJOR_CAT = 'REFUNDS' 
                AND mtv.minor_cat is null 
                AND mtv.CARD_SCHEME = '05' 
                AND mcg.mas_code in ('MCDB','MCPP')
                THEN 1 ELSE  0 END * mtv.AMOUNT)               AS MCDebitReturnsAmount
                    
                FROM   
                masclr.MAS_TRANS_VIEW mtv
                JOIN masclr.MAS_CODE mc 
                ON (mtv.mAS_code = mc.mAS_code AND mtv.card_scheme = mc.card_scheme)                                             
                JOIN masclr.ACQ_ENTITY ae 
                ON ( mtv.INSTITUTION_ID = ae.INSTITUTION_ID AND mtv.ENTITY_ID = ae.ENTITY_ID)  
                left outer JOIN masclr.MAS_CODE_GRP mcg 
                ON (mtv.INSTITUTION_ID = mcg.INSTITUTION_ID AND 
                    mtv.mAS_code = mcg.qualify_mas_code and mcg.mas_code_grp_id = '60')
                
                WHERE  
                    mtv.TID like '010003%' AND  
                    mtv.card_scheme in ('04', '05') AND  
                    mtv.gl_date >= to_date(:report_date,'YYYYMM') AND        
                    mtv.gl_date <  last_day(to_date(:report_date, 'YYYYMM'))+1 AND
                    mtv.SETTL_FLAG = 'Y' AND  
                    mtv.INSTITUTION_ID in (:inst_id) 
                GROUP BY  
                    mtv.INSTITUTION_ID,
                    mtv.ENTITY_ID,   
                    ae.ENTITY_DBA_NAME,   
                    ae.ENTITY_NAME,   
                    ae.DEFAULT_MCC  
                ORDER BY   
                    mtv.ENTITY_ID
                        """

            # End of query
            self.logger.debug(sql_query)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                      db_obj.GetErrorDescription(db_obj.errorCode))

            bind_str = {'report_date':run_date, 'inst_id':inst_id}
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

            self.logger.info(inst_id)
            outFileName = '{}.Monthly_Report.{}.csv'.format(inst_id, run_date)
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
                            ('MonthEnd Report: %s' % outFileName)
                else:
                    email_sub = \
                        ('IGNORE: Testing MonthEnd Report : %s' \
                            % outFileName)

                # Email the file
                email_body = 'Attached MonthEnd report %s' % outFileName

                email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                        CONFIG_SECTION_NAME='MONTHEND_REPORTS', \
                                        EMAIL_BODY=email_body, \
                                        EMAIL_SUBJECT=email_sub)
                if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                              ATTACH_FILES_LIST=[outFileName]):
                    self.logger.error('Unable to send the Month end report attachment')
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
                log_level = logging.ERROR


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
        Description : Initializes the monthend report class object.
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
        monthend_object = MonthEndReportClass('Monthend')

        #Parse the command line arguments
        arg_list = monthend_object.parse_arguments()

        #test mode override the default mail id
        if arg_list.test:
            monthend_object.email_config_file = arg_list.test
            monthend_object.mode = 'TEST'
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

        #set logger object verbose level
        log_res = monthend_object.set_logger_level(arg_list.verbose)
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

        outFileName = monthend_object.generate_report(db_object, \
                                                     arg_list.inst_id, \
                                                     report_date)
        print('outFileName:', outFileName)
        if outFileName is None:
            raise Exception('generate_report didnt make a file')


        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of monthend {}'.format(err)
        print(err_msg)
        monthend_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of monthend inside main function {}'.format(err)
        print(err_msg)
        monthend_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
