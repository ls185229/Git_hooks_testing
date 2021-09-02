#!/usr/bin/env python3
'''
#Author: EDanahy & HWarsi
#CRONJOB CREATED IN CRONTAB IN THE DAILY SECTION. THIS WILL RUN AT 8AM EVERYDAY
#00 08 * * * env python3 /clearing/filemgr/REPORTS/DAILY/tc57_monitoring_report.py

$Id: tc57_monitoring_report.py 2021-08-04 12:14:00 EDanahy $
$Rev: 1 $
File Name: tc57_monitoring_report.py
Description: This class generates the daily TC57 monitoring report.
Arguments:   -t - Test Option
                  mail configuration is read from the test email
                  file in the testing phase.
                  Example Format: tc57_monitoring_report.py -t TEST
             -d - Date Option
                  report_date default is yesterday if no date is
                  passed. 
                  Example Format: tc57_monitoring_report.py -d YYYY/MM/DD
             -i - Institution ID Option
                  defaults to all institution ids if nothing is 
                  entered.
                  Example Format: tc57_monitoring_report.py -i ###

Output:      tc57 monitoring report
Return:      0 = Success
             !0 = Exit with errors
'''
import argparse
import csv
import os
import sys
import logging
import smtplib
import dateutil.relativedelta
import cx_Oracle
import xlsxwriter
from datetime import datetime as datetime
from datetime import datetime, date, timedelta
from database_class import DbClass
from email_class import EmailClass

class LocalException(Exception):
    """
    Name : LocalException
    Description: A local exception class to post exceptions local to this module.
                 The local exception class is derived from the Python base exception
                 class. It is used to throw other types of excetpions that are not
                 in the standard exception class.
    """
    #CONSTRUCTOR OR INITIALIZER
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ IS TO PRINT() THE VALUE
    def __str__(self):
        return repr(self.value)

class MonitoringReportClass():
    """
    Name : MonitoringReportClass
    Description : MonitoringReportClass is used to generate the TC57 monitoring report
    Arguments: None
    """
    #PRIVATE CLASS ATTRIBUTES
    program_name = None
    mode = None
    logger = None

    def send_alert(self, message):
        """
        Name : send_alert
        Arguments: message
        Description : send the alert if an error occurs during the process
        Returns: Nothing
        """
        email_sub = os.environ["HOSTNAME"] + ' - Err in ' + self.program_name
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                  CONFIG_SECTION_NAME='TC57_MONITOR', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def generate_report(self, db_obj, report_date, inst_id):
        """
        Name : generate_report
        Arguments: date
        Description : Executes the query and generates the report
        Returns: Nothing
        """
        try:
            #DECLARE FILEPATH & FORMAT DATE
            FILE_PATH = '/clearing/filemgr/REPORTS/DAILY/'
            file_date = str(report_date.upper())

            #CREATE XLSX WORKBOOK & UNIQULEY NAME THE FILE WITH THE DATE THAT THE REPORT RAN
            workbook = xlsxwriter.Workbook(FILE_PATH+'tc57_monitoring_report_'+file_date+'.xlsx', {'in_memory': True})
            bold = workbook.add_format({'bold':True})
            background = workbook.add_format({'bg_color':'#BBBBBB', 'bold':True})

            #SET REPORT START DATE FOR SQL QUERY {0} CONSTRAINT
            #REPORT DATE IS USED FOR SQL QUERY {1} CONSTRAINT
            report_date_start = report_date.upper()
            print('Report Date Start Before SQL QUERY: ', report_date_start)

            #INSTITUTION FOR SQL QUERY {2} CONSTRAINT
            print('Institution ID Before SQL QUERY: ', inst_id)

            #CREATE FIRST TAB FOR XLSX WORKBOOK
            mas_import_sheet = workbook.add_worksheet('TC57_IMPORT')
            mas_import_sheet.freeze_panes(1,0)
            mas_import_sheet.set_row(0,None, background)
            mas_import_sheet.set_column(0,12,22)
            mas_import_sheet.write('A1','INST ID')
            mas_import_sheet.write('B1','FILE NUMBER')
            mas_import_sheet.write('C1','FILE NAME')
            mas_import_sheet.write('D1','FILE STATUS')
            mas_import_sheet.write('E1','PROCESS TIME')
            mas_import_sheet.write('F1','DEST FILE TYPE')
            mas_import_sheet.write('G1','SALES COUNT')
            mas_import_sheet.write('H1','SALES AMOUNT')
            mas_import_sheet.write('I1','REFUNDS COUNT')
            mas_import_sheet.write('J1','REFUNDS AMOUNT')
            mas_import_sheet.write('K1','SUSPEND COUNT')

            mas_import_statement = """
            SELECT DISTINCT
            ifl.institution_id AS institution_id,
            ifl.in_file_nbr AS in_file_number,
            ifl.external_file_name AS file_name,
            ifl.in_file_status AS in_file_status,
            ifl.end_dt AS process_time,
            cb.dest_file_type AS destination_file_type,
            SUM(CASE WHEN idm.major_cat = 'SALES' AND idm.trans_clr_status IS NULL THEN 1 END) AS sales_count,
            SUM(CASE WHEN idm.major_cat = 'SALES' AND idm.trans_clr_status IS NULL THEN idm.trans_amount END) sales_amount,
            SUM(CASE WHEN idm.major_cat = 'REFUNDS' AND idm.trans_clr_status IS NULL THEN 1 END) refunds_count,
            SUM(CASE WHEN idm.major_cat = 'REFUNDS' AND idm.trans_clr_status IS NULL THEN idm.trans_amount END) refunds_amount,
            SUM(CASE WHEN idm.trans_clr_status IS NOT NULL THEN 1 END) suspend_count
            FROM in_file_log ifl
            JOIN in_draft_view idm
                    ON ifl.in_file_nbr = idm.in_file_nbr
            JOIN cutoff_batch cb
                    ON idm.in_file_nbr = cb.in_file_nbr
                            AND idm.in_batch_nbr = cb.in_batch_nbr
            WHERE ifl.file_type = '01'
                    AND ifl.incoming_dt >= TRUNC(TO_DATE('{0}','DD-MON-YY'))
                    AND incoming_dt < (TRUNC(TO_DATE('{1}','DD-MON-YY')+1))
                    AND ifl.institution_id IN ({2})
            GROUP BY ifl.institution_id,
                    ifl.in_file_nbr,
                    ifl.external_file_name,
                    ifl.in_file_status,
                    ifl.end_dt,
                    cb.dest_file_type,
                    cb.cutoff_status
            ORDER BY ifl.institution_id,
                    ifl.in_file_nbr
            """.format(report_date, report_date_start, inst_id)

            #MAKE A DICTIONARY FOR FILE TYPE CONVERSION (DEFINING THE MERCHANT)
            file_type_dict = {
            '21': 'MAS',
            '31': 'Amex',
            '41': 'Visa',
            '55': 'MasterCard',
            '83': 'Discover'}
            
            #OPEN DB CONNECTION
            self.logger.debug(mas_import_statement)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                    db_obj.GetErrorDescription(db_obj.errorCode))

            #FORMAT DATE RANGE FOR LOGGER
            run_date = datetime.now().strftime('%d-%B-%y')
            temp_date = datetime.now().strftime('%d-%b-%Y')
            log_msg = 'Start Date: {}'.format(run_date)
            self.logger.info(log_msg)
            end_date = run_date
            log_msg = 'End Date: {}'.format(end_date)
            self.logger.info(log_msg)
            
            #EXECUTE THE SQL QUERY WITH THE OPEN DB CONNECTION
            db_obj.ExecuteQuery(cur, mas_import_statement)

            if db_obj.errorCode:
                raise LocalException( \
                     db_obj.GetErrorDescription(db_obj.errorCode))

            query_result = db_obj.FetchResults(cur)
            log_msg = 'Total number of rows fetched:{}'.format(str(db_obj.dbCursor[cur].rowcount))
            self.logger.debug(log_msg)

            if db_obj.errorCode:
                raise LocalException( \
                    db_obj.GetErrorDescription(db_obj.errorCode))

            #UNIQULEY NAME THE FILE WITH THE DATE THAT THE REPORT RAN
            file_date = str(report_date.upper())
            log_msg = 'File date:{}'.format(file_date)
            self.logger.info(log_msg)
            outFileName = 'tc57_monitoring_report_'+file_date+'.xlsx'
            log_msg = 'Output file name: {}'.format(outFileName)
            self.logger.info(log_msg)

            #SET STARTING POSITION TO WRITE TO THE .XLSX FILE
            row = 1

            #WRITE TO FIRST TAB FOR XLSX WORKBOOK
            for i in query_result:
                INST_ID = i[0]
                FILE_NUMBER = i[1]
                FILE_NAME = i[2]
                FILE_STATUS = i[3]
                Non_String_Process_Time = i[4]
                PROCESS_TIME = datetime.strptime(str(Non_String_Process_Time), '%Y-%m-%d %H:%M:%S').strftime('%d-%b-%Y %H:%M').upper()
                Dest_File_Type_Number = i[5]
                if Dest_File_Type_Number in file_type_dict.keys():
                        DEST_FILE_TYPE = file_type_dict[Dest_File_Type_Number]
                SALES_COUNT = i[6]
                SALES_AMOUNT = i[7]
                REFUNDS_COUNT = i[8]
                REFUNDS_AMOUNT = i[9]
                SUSPEND_COUNT = i[10]
                mas_import_sheet.write(row, 0,INST_ID)
                mas_import_sheet.write(row, 1, FILE_NUMBER)
                mas_import_sheet.write(row, 2, FILE_NAME)
                mas_import_sheet.write(row, 3, FILE_STATUS)
                mas_import_sheet.write(row, 4, PROCESS_TIME)
                mas_import_sheet.write(row, 5, DEST_FILE_TYPE)
                mas_import_sheet.write(row, 6, SALES_COUNT)
                mas_import_sheet.write(row, 7, SALES_AMOUNT)
                mas_import_sheet.write(row, 8, REFUNDS_COUNT)
                mas_import_sheet.write(row, 9, REFUNDS_AMOUNT)
                mas_import_sheet.write(row, 10, SUSPEND_COUNT)
                #RETURNS TO WRITE TO THE NEXT ROW OF THE .XLSX FILE
                row += 1

            #CREATE SECOND TAB FOR XLSX WORKBOOK
            export_sheet = workbook.add_worksheet('TC57_EXPORT')
            export_sheet.freeze_panes(1,0)
            export_sheet.set_row(0,None, background)
            export_sheet.set_column(0,7,22)
            export_sheet.write('A1','DEST FILE TYPE')
            export_sheet.write('B1','OUT FILE NUMBER')
            export_sheet.write('C1','IN FILE NUMBER')
            export_sheet.write('D1','TC57 FILE NAME')
            export_sheet.write('E1','COUNT')
            export_sheet.write('F1','AMOUNT')
            export_sheet.write('G1','OUT FILE NAME')
            export_sheet.write('H1','OUT FILE DATE')

            export_statement = """
            SELECT DISTINCT obl.dest_file_type AS "dest file type",
            obl.out_file_nbr AS "out file number",
            obl.in_file_nbr AS "in file number",
            ifl.external_file_name AS "tc57 file name",
            to_char(SUM(obl.cleared_cnt), '999,999') AS "batch count",
            to_char(SUM(obl.cleared_amt)/100, '999,999,999.00') AS "amount",
            ofl.external_file_name AS "out file name",
            ofl.file_creation_dt out_file_date
            FROM out_batch_log obl
            JOIN out_file_log ofl
                    ON obl.out_file_nbr = ofl.out_file_nbr
            JOIN in_file_log ifl
                    ON obl.in_file_nbr = ifl.in_file_nbr
            WHERE file_type = '01'
                    AND incoming_dt >= TRUNC(TO_DATE('{0}','DD-MON-YY'))
                    AND incoming_dt < (TRUNC(TO_DATE('{1}','DD-MON-YY')+1))
                    AND ifl.institution_id IN ({2})
            GROUP BY obl.dest_file_type,
                    obl.out_file_nbr,
                    obl.in_file_nbr,
                    ofl.external_file_name,
                    ofl.file_creation_dt,
                    ifl.external_file_name
            ORDER BY ifl.external_file_name,
                    ofl.external_file_name
            """.format(report_date, report_date_start, inst_id)

            #MAKE A DICTIONARY FOR THE FILE TYPE CONVERSION(DEFINING THE MERCHANT)
            file_type_dict = {
            '21': 'MAS',
            '31': 'Amex',
            '41': 'Visa',
            '55': 'MasterCard',
            '83': 'Discover'}

            self.logger.debug(export_statement)
            cur = db_obj.OpenCursor()

            if db_obj.errorCode:
                raise LocalException( \
                    db_obj.GetErrorDescription(db_obj.errorCode))

            #FORMAT DATE RANGE FOR LOGGER
            run_date = datetime.now().strftime('%d-%B-%y')
            temp_date = datetime.now().strftime('%d-%b-%Y')
            log_msg = 'Start Date: {}'.format(run_date)
            self.logger.info(log_msg)
            end_date = run_date
            log_msg = 'End Date: {}'.format(end_date)
            self.logger.info(log_msg)
            
            #EXECUTE THE SQL QUERY WITH THE OPEN DB CONNECTION
            db_obj.ExecuteQuery(cur, export_statement)

            if db_obj.errorCode:
                raise LocalException( \
                     db_obj.GetErrorDescription(db_obj.errorCode))

            query_result = db_obj.FetchResults(cur)
            log_msg = 'Total number of rows fetched:{}'.format(str(db_obj.dbCursor[cur].rowcount))
            self.logger.debug(log_msg)

            if db_obj.errorCode:
                raise LocalException( \
                    db_obj.GetErrorDescription(db_obj.errorCode))
            
            #UNIQULEY NAME THE FILE WITH THE DATE THAT THE REPORT RAN
            file_date = str(report_date.upper())
            log_msg = 'File date:{}'.format(file_date)
            self.logger.info(log_msg)
            outFileName = 'tc57_monitoring_report_'+file_date+'.xlsx'
            log_msg = 'Output file name: {}'.format(outFileName)
            self.logger.info(log_msg)

            #SET STARTING POSITION TO WRITE TO THE .XLSX FILE
            row = 1

            #WRITE TO SECOND TAB FOR XLSX WORKBOOK
            for i in query_result:
                Dest_File_Type_Number = i[0]
                if Dest_File_Type_Number in file_type_dict.keys():
                    DEST_FILE_TYPE = file_type_dict[Dest_File_Type_Number]
                OUT_FILE_NUMBER = i[1]
                IN_FILE_NUMBER = i[2]
                TC57_FILE_NAME = i[3]
                BATCH_COUNT = i[4]
                AMOUNT = i[5]
                OUT_FILE_NAME = i[6]
                Non_String_Process_Time = i[7]
                OUT_FILE_DATE = datetime.strptime(str(Non_String_Process_Time), '%Y-%m-%d %H:%M:%S').strftime('%d-%b-%Y %H:%M').upper()
                export_sheet.write(row, 0, DEST_FILE_TYPE)
                export_sheet.write(row, 1, OUT_FILE_NUMBER)
                export_sheet.write(row, 2, IN_FILE_NUMBER)
                export_sheet.write(row, 3, TC57_FILE_NAME)
                export_sheet.write(row, 4, BATCH_COUNT)
                export_sheet.write(row, 5, AMOUNT)
                export_sheet.write(row, 6, OUT_FILE_NAME)
                export_sheet.write(row, 7, OUT_FILE_DATE)
                #RETURNS TO WRITE TO THE NEXT ROW OF THE .XLSX FILE
                row += 1

            workbook.close()

            #EMAIL THE FILE
            email_sub = ('TC57 Monitoring Report: %s' % file_date.upper())
            email_body = 'Successfully created the %s file.' % outFileName

            email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                    CONFIG_SECTION_NAME='TC57_MONITOR', \
                                    EMAIL_BODY=email_body, \
                                    EMAIL_SUBJECT=email_sub)
            if not email_obj.AttachFiles(ATTACH_FILES_FOLDER='/clearing/filemgr/REPORTS/DAILY', \
                                          ATTACH_FILES_LIST=[outFileName]):
                self.logger.error('Unable to send the monitoring report attachment')
            if not email_obj.SendEmail():
                self.logger.error('An error occurred while sending email.\n')
            else:
                self.logger.debug('Email sent successfully.\n')
            
            #MOVE THE .XLSX FILE THAT WAS CREATED FROM CURRENT WORKING DIRECTORY TO ARCHIVE
            dir = '/clearing/filemgr/REPORTS/DAILY/'
            ach = '/clearing/filemgr/REPORTS/DAILY/ARCHIVE/'
            mv_cmd = "mv {} {}"
            os.system(mv_cmd.format(dir+outFileName,ach+outFileName))

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
            if verbosity_level == 1:           #called with -v
                log_level = logging.WARNING
            elif verbosity_level ==2:            # called with -vv
                log_level = logging.INFO
            elif verbosity_level == 3:              # called with -vvv
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
        Description : Initializes the monitoring report class object.
        Parameters  : Process name.
        Returns     : None.
        """
        self.program_name = __file__
        print('In init function, script name:', os.path.basename(__file__),\
               'program_name', self.program_name)
        
        #SET DEFAULT RUN MODE TO PROD UNLESS SPECIFIED TEST BY PASSING -t ARGUMENT
        self.mode = "PROD"
        
        #FILE PATH FOR EMAIL TO, CC, FROM & SUBJECT
        self.email_config_file = '/clearing/filemgr/MASCLRLIB/email_config.ini'

        #CREATE THE LOGGER
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.ERROR)

        #CREATE THE HANDLER FOR LOGGING DATA TO A FILE
        FILEPATH = '/clearing/filemgr/REPORTS/DAILY/'
        log_file_name = FILEPATH+'LOG/{0}.log'.format(process_name)
        print('log_file_name ', log_file_name)
        logger_handler = logging.FileHandler(log_file_name)
        logger_handler.setLevel(logging.ERROR)

        #CREATE A FORMATTER FOR FORMATTING THE LOG MESSAGES
        log_format = '%(filename)s = %(levelname)s - %(asctime)s - ' + \
                 'In %(funcName)s method ' + \
                 '- Line no %(lineno)d - %(message)s'
        logger_formatter = logging.Formatter(log_format)

        #ADD THE FORMATTER TO THE LOGGER
        logger_handler.setFormatter(logger_formatter)

        #ADD THE HANDLER TO THE LOGGER
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
            arg_parser.add_argument('-i', '-I', '--institution', \
                        type=str, \
                        required=False, help='Institution to run report for.')
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
    Description: This script creates the daily TC57 monitoring report
    Arguments: input file, mode, verbosity level and cycle
    """

    try:
        report_date = datetime.now().strftime('%d-%b-%Y')
        monitoring_report_object = MonitoringReportClass('TC57 MONITORING REPORT')

        #PARSE THE COMMAND LINE ARGUMENTS
        arg_list = monitoring_report_object.parse_arguments()

        #TEST MODE OVERRIDE THE DEFAULT MAIL ID
        if arg_list.test:
            monitoring_report_object.email_config_file = arg_list.test
            monitoring_report_object.mode = 'TEST'
            print('email config file name: ', arg_list.test)

        #DATA IS NOT PASSSED ASSIGN CURRENT DATE
        if arg_list.date is None:
            today = datetime.today()
            print(today)
            yesterday_date = today-timedelta(days=1)
            report_date = yesterday_date.strftime('%d-%b-%Y')
            monitoring_report_object.date = report_date
            print('Date to run monitoring report:', report_date)
        else:
            temp_date = (arg_list.date)
            temp_date_date = datetime.strptime(str(temp_date), '%Y/%m/%d')
            report_date = temp_date_date.strftime('%d-%b-%Y')
            monitoring_report_object.date = report_date
            print('Date to run monitoring report:', report_date)

        #SET LOGGER OBJECT VERBOSE LEVEL
        log_res = monitoring_report_object.set_logger_level(arg_list.verbose)
        print('set_logger_level result = ', log_res)

        #DATA IS NOT PASSSED ASSIGN INSTITUTION ID
        if arg_list.institution is None:
            first_inst = '101'
            second_inst = '105'
            third_inst = '107'
            fourth_inst = '117'
            fifth_inst = '121'
            sixth_inst = '122'
            seventh_inst = '130'
            eighth_inst = '808'
            inst_dict = "'"+first_inst+"','"+second_inst+"','"+third_inst+"','"+fourth_inst+ \
                        "','"+fifth_inst+"','"+sixth_inst+"','"+seventh_inst+"','"+eighth_inst+ \
                        "'"
            inst_id = str(inst_dict)
            monitoring_report_object.institution = inst_id
            print('Institution to run monitoring report:', inst_id)
        else:
            temp_inst = (arg_list.institution)
            inst_id = str(temp_inst)
            monitoring_report_object.institution = inst_id
            print('Institution to run monitoring report:', inst_id)

        #OPEN DATABASE CONNECTION
        #CREDENTIALS IMPORTED FROM email_class.py
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
        
        #PASS ARGUMENTS TO BE USED FOR FORMATTED SQL CONSTRAINTS
        monitoring_report_object.generate_report(db_object, report_date, inst_id)

        db_object.Disconnect()
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription(db_object.errorCode))

    except LocalException as err:
        err_msg = 'Error: During database connection or execution of monitoring report {}'.format(err)
        print(err_msg)
        monitoring_report_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of report generation inside main function {}'.format(err)
        print(err_msg)
        monitoring_report_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
