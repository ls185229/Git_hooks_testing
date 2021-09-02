#!/usr/bin/env python
'''
$Id: release_reserve_fund.py 4792 2019-01-02 21:07:58Z skumar $
$Rev: 4792 $
File Name:  release_reserve_fund.py

Description:  This class has the modules to hold and release reserve amount.

Output:       File which has the institution_id, Merchant ID,
              amount requested to release,
              actual amount planned or released and
              cycle

Return:   0 = Success
          !0 = Exit with errors
'''

# The following are pylint directives to suppress some pylint warnings that you
# do not care about.
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = no-self-use

import argparse
import csv
import datetime
import os
import sys

import fnmatch
import logging

sys.path.append('/clearing/filemgr/MASCLRLIB')
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

class ReserveClass():
    """
    Name : ReserveClass
    Description : ReserveClass is used to release the reserve amount for a
           merchant if they have sufficient funds to release
           Revert the held reserve after the planned reserve amount is released
    Arguments: module name
               eg: ReserveClass('release_reserve_fund') or
                   ReserveClass('revert_back_reserve_setup')
    """
    # Private class attributes
    program_name = None
    mode = None
    logger = None

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
                                  CONFIG_SECTION_NAME='RESERVE_ALERTS', \
                                  EMAIL_BODY=message, \
                                  EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def check_merchant_fund(self, db_object, inst_id, merch_id, amt):
        """
        Name : check_merchant_fund
        Arguments: Database Connection object, Merchant ID and Reserve Amount
        Description : Check whether the normal reserve merchant has sufficient
                      funds to release
        Returns: Nothing
        """
        try:
            msg = 'Function parameters inst_id : {} merch_id : {} \
                   amount: {} pay cycle: {}'.format(inst_id, merch_id, \
                   amt, self.cycle)
            self.logger.debug(msg)
            chk_merch_query = """
                select distinct
                    ae.entity_id,
                    ea.POST_PAY_AMT,
                    ea.POST_FEE_AMT,
                    trim(app.PAYMENT_CYCLE)
                from  ACQ_ENTITY ae
                join ENTITY_ACCT ea
                    on ae.INSTITUTION_ID = ea.INSTITUTION_ID
                    and ae.ENTITY_ID = ea.OWNER_ENTITY_ID
                join ACQ_ENTITY_ADD_ON aea
                    on ea.INSTITUTION_ID = aea.INSTITUTION_ID
                    AND ea.OWNER_ENTITY_ID = aea.ENTITY_ID
                join ACCT_POSTING_PLAN app
                    on app.INSTITUTION_ID = ae.INSTITUTION_ID
                    and app.ACCT_PPLAN_ID = ae.ACCT_PPLAN_ID
                    and app.ACCT_POSTING_TYPE = ea.acct_posting_type
                WHERE
                    ea.INSTITUTION_ID = :inst_id
                    and ea.OWNER_ENTITY_ID    = :entity_id
                    and ea.ACCT_POSTING_TYPE = 'R'
                    and ae.RSRV_FUND_STATUS in ('R','F')
                    and ea.POST_PAY_AMT >= :amount
                    and aea.USER_DEFINED_1 != 'ROLLING-180'
                    and (
                        trim(app.PAYMENT_CYCLE) = :pay_cycle
                        or
                        :pay_cycle = 'ALL')
                """
            #chk_merch_query += ";\n"
            self.logger.info(chk_merch_query)
            cur = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            cycle = None
            chk_merch_bind = {'inst_id': inst_id, 'entity_id': merch_id, \
                              'amount': float(amt), 'pay_cycle': self.cycle}
            msg = 'Bind variables : {}'.format(chk_merch_bind)
            self.logger.info(msg)
            db_object.ExecuteQuery(cur, chk_merch_query, chk_merch_bind)

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
                for result in query_result:
                    cycle = result[3]
                msg = 'From query result cycle : {}'.format(cycle)
                self.logger.info(msg)
            else:
                self.logger.info('No results returned from chk_merch_query \n')

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
        else:
            return cycle

    def get_reserve_rows(self, db_object, inst_id, merch_id, amt, pay_cycle):
        """
        Name : get_reserve_rows
        Arguments: Database connection handler, institution_id,Merchant ID ,
                    Amount and payment cycle
        Description : Retrieve the payment sequence number
                      whose amount matches to the release reserve amount
                      update other payment sequence number to hold and
                      remove the STOP_PAY_FLAG
        Returns: Nothing
        """
        try:
            msg = 'Function parameters inst_id :{} merch_id: {} \
                        Amount: {} Payment cycle: {} mode:{}'\
                        .format(inst_id, merch_id, amt, pay_cycle, self.mode)
            self.logger.debug(msg)

            get_seq_query = """
                select distinct
                    aad.INSTITUTION_ID,
                    aad.ENTITY_ACCT_ID,
                    aad.PAYMENT_SEQ_NBR,
                    aad.AMT_PAY, aad.AMT_FEE
                from ACCT_ACCUM_DET aad
                JOIN ENTITY_ACCT ea
                    ON ea.INSTITUTION_ID = aad.INSTITUTION_ID
                    AND ea.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID
                    AND ea.ACCT_POSTING_TYPE = 'R'
                WHERE
                    ea.INSTITUTION_ID = :inst_id
                    and ea.OWNER_ENTITY_ID = :entity_id
                    and aad.PAYMENT_STATUS is null
                ORDER BY aad.AMT_PAY desc
                """
            cur = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            get_seq_bind = {'inst_id':inst_id, 'entity_id':merch_id}
            db_object.ExecuteQuery(cur, get_seq_query, get_seq_bind)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            #get_seq_query += ";\n"
            self.logger.info(get_seq_query)
            query_result = db_object.FetchResults(cur)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            #self.logger.info(query_result)
            total = amt
            seq_list = []
            amt_to_rel = 0

            #Below algorithm to retrieve the rows that matches the requested
            #reserve amount
            for element in query_result:
                institution_id = element[0]
                acct_id = element[1]
                temp_amt = 0
                temp_amt = float(element[3]) + float(element[4])
                #self.logger.info('Inside for loop', element[0], element[1], \
                   # temp_amt)
                if (float(temp_amt) != 0.0) and \
                         float(total) / float(temp_amt) > 1:
                    seq_list.append(int(element[2]))
                    total = float(total) - float(temp_amt)
                    amt_to_rel = amt_to_rel + float(temp_amt)
                    #self.logger.info('total:', total, 'temp_amt:', temp_amt)
                if float(total) <= 0.0:
                    #self.logger.info('payment sequence number list from the \
                        #query:', seq_list)
                    break

            #Retrieved payment sequence numbers are stored as a list
            pay_seq_nbr_list = ",".join(map(str, seq_list))
            msg = 'Payment sequence number string list:{}'\
                 .format(pay_seq_nbr_list)
            self.logger.info(msg)
            msg = 'Inst Id:{} Entity_id:{} Amount Requested:{} Amount Planned \
                   to Release:{}'.format(institution_id, merch_id, amt, \
                   amt_to_rel)
            self.logger.debug(msg)

            #Details are stored in a list to print in the output file
            self.ent_list.append((institution_id, merch_id, amt, amt_to_rel, \
                                  pay_cycle))
            db_object.CloseCursor(cur)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            return acct_id, pay_seq_nbr_list
        except LocalException as err:
            err_msg = 'During database query execution ' + str(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
            db_object.Disconnect()
            sys.exit()
        except Exception as err:
            err_msg = 'Exception error is ' + str(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)

    def update_reserve_fund(self, db_object, institution_id, merch_id, \
                            acct_id, pay_seq_nbr_list):
        """
        Name : update_reserve_fund
        Arguments: Database connection object, institution_id, merchant id,
                    entity acct_id, payment seq number list
        Description : Retrieve the payment sequence number
                      whose amount matches to the release reserve amount
                      update other payment sequence number to hold and
                      remove the STOP_PAY_FLAG
        Returns: Nothing
        """
        try:
            self.logger.debug('In update_reserve_fund function')

            #if the payment_seq_nbr list to be released is greater than 1000
            #below update query will fail but its very rare scenario
            upd_aad_query = """
                update ACCT_ACCUM_DET aad set PAYMENT_STATUS = 'X'
                WHERE aad.INSTITUTION_ID = :inst_id
                and aad.ENTITY_ACCT_ID = :entity_acct_id
                and aad.PAYMENT_STATUS is null
                """
            upd_aad_query += """and aad.PAYMENT_SEQ_NBR not in ( """
            upd_aad_query = upd_aad_query + pay_seq_nbr_list + " )"

            cur1 = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            self.logger.info(upd_aad_query)
            upd_aad_bind = {'inst_id':institution_id, 'entity_acct_id':acct_id}
            result = db_object.ExecuteQuery(cur1, upd_aad_query, upd_aad_bind)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            msg = 'Update query result:{}'.format(result)
            self.logger.info(msg)
            db_object.CloseCursor(cur1)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            upd_ea_query = """
                update ENTITY_ACCT ea set ea.STOP_PAY_FLAG = null
                WHERE ea.INSTITUTION_ID = :inst_id
                and ea.OWNER_ENTITY_ID    = :entity_id
                and ea.ACCT_POSTING_TYPE = 'R'
                and ea.STOP_PAY_FLAG = 'Y'
                """
            cur2 = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            self.logger.info(upd_ea_query)
            upd_ea_bind = {'inst_id':institution_id, 'entity_id':merch_id}
            result = db_object.ExecuteQuery(cur2, upd_ea_query, upd_ea_bind)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))


            msg = 'Update query result:{}'.format(result)
            #self.logger.info(msg)
            db_object.CloseCursor(cur2)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            if self.mode == 'PROD':
                db_object.Commit()
        except LocalException as err:
            err_msg = 'During database query execution ' + str(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
            db_object.Rollback()
            db_object.Disconnect()
            sys.exit()
            ##DOUBT do we need to exit and rollback
        except Exception as err:
            err_msg = 'Exception error is ' + str(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)

    def update_reserve_held(self, db_object, inst_id, merch_id):
        """
        Name : update_reserve_held
        Arguments: Database connection object, institution_id and merchant id
        Description : Revert the reserve setup after the reserve amount
                      is released. update the payment status to null and
                      add enable the STOP_FLAG.
        Returns: Nothing
        """
        try:
            msg = 'In update_reserve_held inst_id {} merch_id {}'\
                       .format(inst_id, merch_id)
            self.logger.debug(msg)
            aad_upd_query = """
                update ACCT_ACCUM_DET aad set aad.PAYMENT_STATUS = NULL
                where 
                (aad.INSTITUTION_ID, aad.ENTITY_ACCT_ID, aad.PAYMENT_SEQ_NBR)
                 IN (
                SELECT 
                     DISTINCT ad.INSTITUTION_ID,
                     ad.ENTITY_ACCT_ID,
                     ad.PAYMENT_SEQ_NBR
                FROM ACCT_ACCUM_DET ad
                JOIN ENTITY_ACCT ea 
                     on ea.ENTITY_ACCT_ID = ad.ENTITY_ACCT_ID
                     AND ea.INSTITUTION_ID = ad.INSTITUTION_ID
                JOIN ACQ_ENTITY ae
                     on ad.INSTITUTION_ID = ae.INSTITUTION_ID
                     and ea.OWNER_ENTITY_ID = ae.ENTITY_ID
                JOIN ACCT_POSTING_PLAN app
                    on app.INSTITUTION_ID = ae.INSTITUTION_ID
                    and app.ACCT_PPLAN_ID = ae.ACCT_PPLAN_ID
                    and app.ACCT_POSTING_TYPE = ea.acct_posting_type
                WHERE
                    ea.INSTITUTION_ID = :institution_id
                    and ea.OWNER_ENTITY_ID = :entity_id
                    and ad.PAYMENT_STATUS = 'X'
                    and ea.ACCT_POSTING_TYPE = 'R'
                    and ae.ENTITY_STATUS = 'A'
                    and ae.TERMINATION_DATE is null
                    and ae.ENTITY_LEVEL = '70'
                    and (
                        trim(app.PAYMENT_CYCLE) = :pay_cycle
                        or
                        :pay_cycle = 'ALL')
                )
                AND aad.PAYMENT_STATUS = 'X'
                """

            self.logger.info(aad_upd_query)
            aad_bind_var = {'institution_id':inst_id, 'entity_id':merch_id, \
                            'pay_cycle':self.cycle}
            aad_cursor = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            db_object.ExecuteQuery(aad_cursor, aad_upd_query, aad_bind_var)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            #msg = 'Number of rows updated in ACCT_ACCUM_DET {}'\
            #        .format(aad_cursor.rowcount)
            #self.logger.info(msg)
            db_object.CloseCursor(aad_cursor)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            ea_upd_query = """
                 update ENTITY_ACCT ea
                 set ea.STOP_PAY_FLAG = 'Y'
                 WHERE ea.INSTITUTION_ID = :inst_id
                 and ea.OWNER_ENTITY_ID = :entity_id
                 and ea.ACCT_POSTING_TYPE = 'R'
                 and ea.STOP_PAY_FLAG is null
                 """
            ea_cursor = db_object.OpenCursor()

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            self.logger.info(ea_upd_query)
            ea_bind_var = {'inst_id':inst_id, 'entity_id':merch_id}
            db_object.ExecuteQuery(ea_cursor, ea_upd_query, ea_bind_var)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

            #msg = 'Number of rows updated in ENTITY_ACCT {}'\
            #        .format(ea_cursor.rowcount)
            #self.logger.info(msg)
            db_object.CloseCursor(ea_cursor)

            if db_object.errorCode:
                raise LocalException( \
                      db_object.GetErrorDescription(db_object.errorCode))

        except LocalException as err:
            err_msg = 'During database query execution {}'.format(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
            db_object.Rollback()
            db_object.Disconnect()
            sys.exit()

    def make_output_file(self):
        """
        Name        : make_output_file
        Description : Create output file from the ent_list structure
        Parameters  : None.
        Returns     : None.
        """
        try:
            self.logger.debug('In make_output_file function')
            cur_day = datetime.datetime.now()
            if self.mode == 'PROD':
                output_file_name = "reserve_output_" + \
                                   cur_day.strftime("%Y%m%d%H%M%S") +".csv"
            else:
                output_file_name = "reserve_input_" + \
                                   cur_day.strftime("%Y%m%d%H%M%S") +".csv"
            msg = 'output_file_name : {}'.format(output_file_name)
            self.logger.debug(msg)
            fieldnames = ['INST_ID', 'MERCHANT_ID', 'RESERVE_REL_AMT', \
                          'PLANNED_REL_AMT', 'PAY_CYCLE']
            msg = 'OutputFile field names: {}'.format(fieldnames)
            self.logger.info(msg)
            with open(output_file_name, 'w') as fptr:
                csv_object = csv.writer(fptr, delimiter=',', \
                                         quoting=csv.QUOTE_MINIMAL)
                csv_object.writerow(fieldnames)
                csv_object.writerows(self.ent_list)
        except Exception as err:
            err_msg = 'Error: In make_output_file - {}'.format(err)
            self.logger.error(err_msg)
            fptr.close()
            sys.exit()
        else:
            fptr.close()
            return output_file_name

    def send_output_file(self, file_name):
        """
        Name        : send_output_file
        Description : Email the output file
        Parameters  : None.
        Returns     : None.
        """

        self.logger.debug('In send_output_file function')
        email_sub = os.environ["HOSTNAME"] + " - Attached the reserve report"
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file, \
                                CONFIG_SECTION_NAME='RESERVE_ALERTS', \
                                EMAIL_BODY='Attached reserve output file.', \
                                EMAIL_SUBJECT=email_sub)
        if not email_obj.AttachFiles(ATTACH_FILES_FOLDER=os.getcwd(), \
                                      ATTACH_FILES_LIST=[file_name]):
            self.logger.error('Unable to send the reserve report attachment')
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Email sent successfully.\n')


    def __init__(self, process_name):
        """
        Name        : __init__
        Description : Initializes the release reserve class object.
        Parameters  : Process name.
        Returns     : None.
        """
        self.program_name = __file__
        print('In init function, script name:', os.path.basename(__file__),\
              'program_name', self.program_name)
        self.ent_list = []
        self.cycle = "ALL"
        self.mode = "PREVIEW"
        self.email_config_file = 'email_config.ini'
        # Create the Logger
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.WARNING)

        # Create the Handler for logging data to a file
        log_file_name = 'LOG/{0}.log'.format(process_name)
        print('log_file_name ', log_file_name)
        logger_handler = logging.FileHandler(log_file_name)
        logger_handler.setLevel(logging.WARNING)

        # Create a Formatter for formatting the log messages
        format_msg = '%(filename)s - %(levelname)s - %(asctime)s - ' + \
                  'In %(funcName)s method ' + \
                  '- Line no %(lineno)d - %(message)s'
        logger_formatter = logging.Formatter(format_msg)

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
            arg_parser.add_argument('-f', '-F', '--input_file', \
                        type=str, default=False, required=False, \
                        help='File with Merchant ID and amount to release. \
                        In PREVIEW mode Merchant ID and Amount fields.\
                        In PROD mode, input file has Institution ID Merchant \
                        ID Amount and Payment Cycle fields')
            arg_parser.add_argument('-v', '-V', '--verbose', \
                        action='count', dest='verbose', required=False, \
                        help='verbose level  repeat up to five times.')
            arg_parser.add_argument('-m', '-M', '--mode', type=str, \
                        required=True, default='PREVIEW', \
                        help='Run mode indicator (Optional). Mode can be \
                        either TEST or PROD. Database changes will be saved \
                        only in PROD mode')
            arg_parser.add_argument('-c', '-C', '--cycle', type=str, \
                        required=False, default='ALL', \
                        help='Cycle number For normal funding merchant has \
                        cycle number 1. Next day funding merchant has cycle \
                        number 5. In PREVIEW mode both cycle 1 and 5 are \
                        considered')
            arg_parser.add_argument('-t', '-T', '--test', required=False, \
                        help='mail configuration is read from the test \
                        email file in testing phase')
            args = arg_parser.parse_args()

        except argparse.ArgumentError as err:
            err_msg = 'Error: During parsing command line arguments '+str(err)
            print(err_msg)
            sys.exit()
        else:
            return args

    def get_reserve_file_name(self):
        """
        Name : get_reserve_file_name
        Arguments: none
        Description : Retrieves the input file from IN directory
                      for the current date
        Returns: File Name list
        """
        try:
            self.logger.debug('In get_reserve_file_name function')
            cur_day = datetime.datetime.now()
            in_directory = os.getcwd() + "/IN/"
            file_pattern = "reserve_input_" + cur_day.strftime("%Y%m%d") + \
                            "*.csv"
            in_file_list = []
            for root, dirs, files in os.walk(in_directory):
                for name in files:
                    if fnmatch.fnmatch(name, file_pattern):
                        in_file_list.append(os.path.join(root, name))
            msg = 'File list in IN directory : ' + str(in_file_list)
            self.logger.debug(msg)

        except IOError as strerror:
            err_msg = 'Unable to open or read the input file: '+ str(strerror)
            self.logger.error(err_msg)
        else:
            return in_file_list

    def get_revert_file_name(self):
        """
        Name : get_revert_file_name
        Arguments: none
        Description : Retrieves the input file from IN directory
                      for the current date
        Returns: File Name list
        """
        try:
            self.logger.debug('In get_revert_file_name function')
            cur_day = datetime.datetime.now()
            in_directory = os.getcwd() + "/OUT/"
            file_pattern = "reserve_output_" + cur_day.strftime("%Y%m%d") + \
                            "*.csv"
            in_file_list = []
            for root, dirs, files in os.walk(in_directory):
                for name in files:
                    if fnmatch.fnmatch(name, file_pattern):
                        in_file_list.append(os.path.join(root, name))
            msg = 'File list in OUT directory : ' + str(in_file_list)
            self.logger.debug(msg)

        except IOError as strerror:
            err_msg = 'Unable to open or read the input file: '+ str(strerror)
            self.logger.error(err_msg)
        else:
            return in_file_list

    def set_logger_level(self, verbosity_level):
        """
        Name : set_logger_level
        Arguments: Module name and verbosity level
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

    def process_reserve(self, db_object, file_name):
        """
        Name : process_reserve
        Arguments: Database connection object and input file
        Description : Retrieves the entity id and the amount to release
                      from the input file.Check whether the merchant falls
                      under normal reserve or rolling reserve and
                      has enough funds to release
        Returns: None
        """
        self.logger.debug('In process_reserve function')
        with open(file_name, "r") as in_file_ptr:
            #SKIP HEADERS
            next(in_file_ptr)
            for line in in_file_ptr:
                data = line.rstrip().split(',')
                if data:
                    inst_id = data[0]
                    entity_id = data[1]
                    amount = data[2]

                    #None is returned by check_merchant_fund function when the
                    #merchant falls under rolling reserve
                    #or insufficient funds to release
                    cycle = self.check_merchant_fund(db_object, inst_id, \
                                                     entity_id, amount)
                    msg = 'Return of check_merchant_fund:{}'.format(cycle)
                    self.logger.info(msg)
                    if cycle:
                        acct_id = None
                        pay_seq_nbr_list = None
                        acct_id, pay_seq_nbr_list = \
                         self.get_reserve_rows(db_object, inst_id, entity_id, \
                                             amount, cycle)
                        if self.mode == "PROD":
                            self.update_reserve_fund(db_object, inst_id, \
                                                   entity_id, acct_id, \
                                                   pay_seq_nbr_list)
                        else:
                            self.logger.info('update_reserve_fund is not '\
                                              'called for PREVIEW mode')
                    else:
                        self.logger.error('Merchant either is not under '\
                                          'normal reserve or does not have '\
                                           'sufficient amount to release')

            #Create output file only when there is some records in the ent_list
            msg = 'Number of merchant in the list: {}'\
                     .format(len(self.ent_list))
            self.logger.info(msg)
            if self.ent_list:
                file_name = self.make_output_file()
                self.send_output_file(file_name)
                if self.mode == "PROD":
                    mv_cmd = "mv {} OUT/"
                    os.system(mv_cmd.format(file_name))
        in_file_ptr.close()

    def process_revert(self, db_object, file_name):
        """
        Name : process_revert
        Arguments: Database connection object and input file
        Description : Retrieves the institution_id and entity id to revert
                      back the reserve from the input file
        Returns: None
        """
        try:
            with open(file_name, "r") as in_file_ptr:
                #SKIP HEADERS
                next(in_file_ptr)

                #Institution id and Merchant id read from the file
                for line in in_file_ptr:
                    data = line.rstrip().split(',')
                    if data:
                        inst_id = data[0]
                        entity_id = data[1]
                        msg = 'Inst_id: {} Entity_id: {}'.format(inst_id, \
                               entity_id)
                        self.logger.info(msg)
                        #if the list is empty don't call the Update function
                        if self.mode == "PROD":
                            self.update_reserve_held(db_object, inst_id, \
                                                     entity_id)
                        else:
                            self.logger.info('update_reserve_held wont be' + \
                                               ' called in PREVIEW mode')
                if self.mode == 'PROD':
                    db_object.Commit()
                else:
                    db_object.Rollback()

                if db_object.errorCode:
                    in_file_ptr.close()
                    raise LocalException( \
                          db_object.GetErrorDescription(db_object.errorCode))

            in_file_ptr.close()
        except LocalException as err:
            err_msg = 'In process_revert function, LocalException is \
                       ' + str(err)
            self.logger.error(err_msg)
            self.send_alert(err_msg)
