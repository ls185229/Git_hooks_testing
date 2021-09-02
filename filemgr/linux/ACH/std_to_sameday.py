#!/usr/bin/env python3
# -*- coding: Windows-1252 -*-
"""
  Standard to Sameday class
  converts a merchant from standard funding to same day funding
"""
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = broad-except
# pylint: disable = wrong-import-position
import os
import argparse
import logging

import sys


import sqlalchemy as sa
# from sqlalchemy import MetaData, Table, Column
# from sqlalchemy.types import String, Float, Date
# from sqlalchemy.sql import select, and_
from sqlalchemy.exc import DatabaseError
sys.path.append('/clearing/filemgr/MASCLRLIB')
from email_class import EmailClass
import pandas as pd

try:
    from dateutil.parser import parse
except ImportError:
    pass

try:
    basestring
except NameError:
    basestring = str


def is_date(string, fuzzy=False, dayfirst=False):
    """
    Return whether the string can be interpreted as a date.

    :param string: str, string to check for date
    :param fuzzy: bool, ignore unknown tokens in string if True
    """
    try:
        parse(string, fuzzy=fuzzy, dayfirst=dayfirst)
        return True

    except ValueError:
        return False


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


class std_to_sd:
    """
       class to convert standard to sameday funding merchant
    """
    program_name = None
    mode = None
    logger = None

    def send_mail_msg(self, message):
        """
            Name : send_mail_msg
            Arguments: message
            Description : send a message during the process if merchant exceeds
                      the limit
            Returns: Nothing
        """

        # email_sub = os.environ["HOSTNAME"] + ' - Err in ' + self.program_name
        email_obj = EmailClass(READ_FROM_CONFIG_FILE=self.email_config_file,
                               CONFIG_SECTION_NAME='SDTOSTD_REPORT',
                               EMAIL_BODY=message)
        # EMAIL_SUBJECT=email_sub)
        if not email_obj.SendEmail():
            self.logger.error('An error occurred while sending email.\n')
        else:
            self.logger.info('Alert Email sent successfully.\n')

    def assemble_mail_msg(self, rpt_data):
        """
            builds string message that is the contents of the email
        """
        head_msg = 'These Merchants had a High Transaction ACH greater '\
            + 'or equal to $100,000).� Transactions of this magnitude '\
            + 'are processed via the Standard Funding Process.� These '\
            + 'Merchants were switched back to a Next Day Funding '\
            + 'Posting Plan after being temporarily moved to a Standard '\
            + 'Funding Posting Plan due to the High Transaction ACH. '\
            + '\n\n'

        assy_msg = ''
        for index, rpt_rec in rpt_data.iterrows():
            assy_msg = assy_msg + 'Merchant ID: {} '\
                  'been moved from STD to Same Day. funding Plan: {} Plan: '\
                  '{}. \n'.format(
                       rpt_rec['entity_id'],
                       rpt_rec['curr_acct_pplan_id'],
                       rpt_rec['prev_acct_pplan_id'])

        assy_msg = head_msg + assy_msg
        return assy_msg

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

    def get_connection(self):
        """
            Establishing Connection to datbase server.
        """
        con = None
        try:
            # oracle_db = sa.create_engine(self.CONNECTION, echo=False)
            con = self.db_engine.Connect()
        except DatabaseError as dberr:
            print("DatabaseError occured while connecting to MAS database",
                  dberr)
        except Exception as exc:
            print("Exception occured while connecting to MAS database ", exc)
        return con

    def get_dbengine(self):
        """
            Establishing Engine datbase server.
        """
        oracle_db = None
        try:
            oracle_db = sa.create_engine(self.CONNECTION, echo=False)
        except DatabaseError as dberr:
            print("DatabaseError occured while connecting to MAS database",
                  dberr)
        except Exception as exc:
            print("Exception occured while connecting to MAS database ", exc)
        return oracle_db

    def get_engine(self):
        """
          return current dbengine
        """
        db_engine = self.get_dbengine()
        return db_engine

    def get_sameday_plan(self, over_rec):
        """
          calculate new payment plan
        """
        new_pp = over_rec["prev_acct_pplan_id"]
        inst_id = over_rec["institution_id"]
        # select the posting record and payment cycle
        sql_text = f"""
            select distinct apm.acct_pplan_id, app.payment_cycle
            from
                acct_pplan_master apm
            join acct_posting_plan app
                on apm.institution_id = app.institution_id
                and apm.acct_pplan_id = app.acct_pplan_id
            where
                apm.institution_id = '{inst_id}'
                and apm.acct_pplan_id = '{new_pp}'
                and app.card_sch_to_post = '04'
            """

        df_from_query = pd.read_sql_query(sql_text, self.db_engine)

        if len(df_from_query.index) > 0:
            payment_cycle = df_from_query['payment_cycle']
            payment_cycle = int(payment_cycle)
        else:
            new_pp = "-1"
            payment_cycle = -1

        return new_pp, payment_cycle

    def get_data_to_switch(self, inst_id):
        """
            select records exceeding limit from DB  and store into a DataFrame
        """
        sql_select = """
                SELECT institution_id, entity_id, creation_date,
                    prev_acct_pplan_id, curr_acct_pplan_id, payment_amt,
                    payment_seq_nbr
                FROM acct_pplan_hist
                WHERE creation_date >= trunc(sysdate)
                """
        if inst_id != 'ALL':
            sql_select = sql_select + f" and institution_id = '{inst_id}'"
        try:
            df_from_query = pd.read_sql_query(sql_select, self.db_engine)
            return df_from_query
        except Exception as err:
            print("Exception occured while reading from database", err)

    def valid_entity_plan(self, over_rec):
        """
           validate the Institution, Merchant ID and payment plan value
        """
        inst_id = over_rec['institution_id']
        ent_id = over_rec['entity_id']
        pplan_id = over_rec['curr_acct_pplan_id']
        sql_select = f"""
            SELECT distinct institution_id, entity_id, acct_pplan_id
            FROM acq_entity
            WHERE INSTITUTION_ID = '{inst_id}'
                    AND ENTITY_ID = '{ent_id}'
                    AND ACCT_PPLAN_ID = '{pplan_id}'
                    AND ENTITY_STATUS = 'A'
            """
        df_from_query = pd.read_sql_query(sql_select, self.db_engine)

        result = len(df_from_query.index) > 0
        return result

    def update_pp(self, pplan_id, over_rec):
        """
          update payment plan
        """

        inst_id = over_rec['institution_id']
        ent_id = over_rec['entity_id']
        try:

            con = self.db_engine.connect()

            query_str = f"""
                UPDATE acq_entity \
                SET acct_pplan_id = '{pplan_id}'
                WHERE INSTITUTION_ID = '{inst_id}'
                    AND ENTITY_ID = '{ent_id}'
                    AND ENTITY_STATUS = 'A'
                """
            con.execute(query_str)
            con.close()
        except DatabaseError as err:
            err_msg = 'Error: During database connection or execution '\
                      + str(err)
            print(err_msg)
        except Exception as err:
            err_msg = 'Error: During database update ' + str(err)
            print(err_msg)

    def update_pay_cycle(self, pay_cycle, over_rec):
        """
           update payment plan
        """
        inst_id = over_rec['institution_id']
        ent_id = over_rec['entity_acct_id']
        settle_date = over_rec['settl_date']

        try:
            con = self.db_engine.connect()
            query_str = f"""
                Update acct_accum_det aad set payment_cycle = '{pay_cycle}'
                WHERE
                    aad.institution_id = '{inst_id}'
                    AND aad.payment_status IS NULL
                    AND aad.settl_date = to_date('{settle_date}','DD-MON-YY')
                    AND aad.payment_cycle = '8'
                    AND entity_acct_id = '{ent_id}'
             """

            con.execute(query_str)
            con.close()
        except DatabaseError as err:
            err_msg = 'Error: During database connection or execution '\
                     + str(err)
            print(err_msg)
        except Exception as err:
            err_msg = 'Error: During database update ' + str(err)
            print(err_msg)

    def assign_connection(self):
        """
           # Environment variables.......
        """
        self.CONNECTION = 'oracle://' + os.environ['CLR2_DB_USERNAME'] \
            + ':' + os.environ['CLR2_DB_PASSWORD'] + '@'\
            + os.environ['CLR2_SERVERNAME'] + '/'\
            + os.environ['CLR2_DB']

    def __init__(self, institution_id, mode):
        self.inst_id = institution_id
        self.CONNECTON = ''
        # Create the Handler for logging data to a file
        self.logger = logging.getLogger(__name__)
        log_file_name = 'LOG/{0}.log'.format('std_to_sameday')
        print('log_file_name ', log_file_name)
        logger_handler = logging.FileHandler(log_file_name)
        logger_handler.setLevel(logging.WARNING)
        # Create a Formatter for formatting the log messages
        msgformat = '%(filename)s - %(levelname)s - %(asctime)s - ' + \
            'In %(funcName)s method ' + \
            '- Line no %(lineno)d - %(message)s'
        logger_formatter = logging.Formatter(msgformat)
        # Add the Formatter to the Handler
        logger_handler.setFormatter(logger_formatter)
        # Add the Handler to the Logger
        self.logger.addHandler(logger_handler)
        self.logger.info('Completed configuring logger()!')
        self.email_config_file = "email_config.ini"
        self.mode = mode
        self.assign_connection()
        self.db_engine = self.get_engine()


def main():
    """
    main routine parse arguments look for institution_id and execute
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("-i",
                        dest="institution_id",
                        default="ALL",
                        help="Must specify Institution ID VIA -i parameter.",
                        required=False
                        )

    parser.add_argument("-mode",
                        dest="mode",
                        default="PROD",
                        choices=["TEST", "PROD"],
                        help="Specify Mode as TEST or PROD",
                        required=False
                        )
    args = parser.parse_args()

    # db_engine = get_engine()
    institution_id = args.institution_id
    mode = args.mode
    sd_to_std_object = std_to_sd(institution_id, mode)
    sd_to_std_object.set_logger_level(2)
    list_data = sd_to_std_object.get_data_to_switch(institution_id)
    if len(list_data.index) > 0:
        for index, over_rec in list_data.iterrows():
            if sd_to_std_object.valid_entity_plan(over_rec):
                new_pp, pay_cycle = sd_to_std_object.get_sameday_plan(over_rec)
                if new_pp != '-1':
                    new_plan = new_pp
                else:
                    new_plan = 'Error'
                if new_pp != '-1':
                    sd_to_std_object.update_pp(new_plan, over_rec)
                    # sd_to_std_object.update_pay_cycle(pay_cycle, over_rec)
    if len(list_data.index) > 0:
        list_msg = sd_to_std_object.assemble_mail_msg(list_data)
        try:
            sd_to_std_object.send_mail_msg(list_msg)
        except Exception as exc:
            print('Mail Exception ' + exc)

if __name__ == "__main__":

    main()
