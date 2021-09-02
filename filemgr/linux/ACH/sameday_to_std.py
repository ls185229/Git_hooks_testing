#!/usr/bin/env python3
"""
  Same day to standard class
  converts a merchant from same day funding to standard funding
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
import cx_Oracle
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

# Environment variables.......
# CONNECTION = os.environ['IST_DB_CONNECTION_URI']
CONNECTION = 'oracle://' + os.environ['CLR2_DB_USERNAME'] + ':'\
             + os.environ['CLR2_DB_PASSWORD'] +'@'\
             + os.environ['CLR2_SERVERNAME'] + '/'\
             + os.environ['CLR2_DB']

CXORACLE   = os.environ['CLR2_DB_USERNAME'] + '/'\
             +os.environ['CLR2_DB_PASSWORD'] + '@'\
             +os.environ['CLR2_DB']


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


class sd_to_std:
    """
       class to convert same day funding merchant to standard funding
    """
    program_name = None
    mode = None
    logger = None

    def send_mail_msg(self, message):
        """
        Name : send_mail_msg
        Arguments: message
        Description : send a message during the process if a merchant exceeds
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

    def calc_new_plan(self, over_rec):
        """
          calculate new payment plan
        """
        new_pp = over_rec['acct_pplan_id']
        new_pp = int(new_pp[:-2])
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

    def get_overlimit_sql(self):
        """
           retrieve the proper sql select query
        """
        sql_select = f"""
            SELECT aad.institution_id, aad.entity_acct_id,
                ea.owner_entity_id, ea.customer_name, ae.entity_name,
                to_char(aad.settl_date,'DD-MON-YY')   settl_date,
                aad.payment_proc_dt   payment_proc_dt,
                SUM(aad.amt_pay - aad.amt_fee) transfer_amt,
                abs(SUM(aad.amt_pay - aad.amt_fee)) ach_amt,
                aad.payment_status    payment_status, ae.acct_pplan_id,
                aad.payment_cycle
            FROM
                acct_accum_det   aad
            JOIN
                entity_acct ea ON ea.entity_acct_id = aad.entity_acct_id
                AND ea.institution_id = aad.institution_id
            JOIN
                acq_entity ae ON ea.institution_id = ae.institution_id
                AND ea.owner_entity_id = ae.entity_id
            WHERE
                aad.institution_id = '{self.inst_id}'
                AND aad.payment_status IS NULL
                AND aad.payment_cycle = '8'
                AND aad.settl_date < trunc(sysdate) + 1
                AND ae.acct_pplan_id LIKE '%00'
                AND length(ae.acct_pplan_id) >= 3
            GROUP BY
                ae.acct_pplan_id, aad.institution_id, aad.entity_acct_id,
                ea.owner_entity_id, ae.entity_name, ea.customer_name,
                aad.settl_date, aad.payment_proc_dt, aad.payment_status,
                aad.payment_cycle
            HAVING
                abs(SUM(aad.amt_pay - aad.amt_fee)) >= 100000
            ORDER BY
                ae.acct_pplan_id, aad.entity_acct_id, ach_amt desc,
                ae.entity_name
            """
        return sql_select

    def get_data_overlimit(self):
        """
            select records exceeding limit from DB  and store into a DataFrame
        """
        try:
            sql_select = self.get_overlimit_sql()
            df_from_query = pd.read_sql_query(sql_select, self.db_engine)
            return df_from_query
        except Exception as err:
            print("No Records returned from query from database", err)

    def update_pp(self, pplan_id, over_rec):
        """
          update payment plan
        """

        inst_id = over_rec['institution_id']
        ent_id = over_rec['owner_entity_id']
        try:

            con = self.db_engine.connect()

            query_str = f"""
                UPDATE acq_entity \
                SET acct_pplan_id = '{pplan_id}'
                WHERE INSTITUTION_ID = '{inst_id}'
                    AND ENTITY_ID = '{ent_id}'
                    AND ENTITY_STATUS = 'A'
                """
            if self.mode == 'TEST':
                print('SQL Update: Payment Plan ' + query_str)
            else:
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

            if self.mode == 'TEST':
                print('SQL Update: ' + query_str)
            else:
                con.execute(query_str)
            con.close()
        except DatabaseError as err:
            err_msg = 'Error: During database connection or execution '\
                     + str(err)
            print(err_msg)
        except Exception as err:
            err_msg = 'Error: During database update ' + str(err)
            print(err_msg)

    def log_fund_chg_history(self, new_pp, over_rec):
        """
           logs the changes of the same day to std funding
        """
        auth_str = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
        auth_str = auth_str + "@" + os.environ["IST_DB"]
        conOracle = cx_Oracle.connect(CXORACLE)
        curOracle = conOracle.cursor()

        inst_id = over_rec['institution_id']
        ent_id = over_rec['owner_entity_id']
        pplan_id = over_rec['acct_pplan_id']
        ach_amt = over_rec['ach_amt']

        update_str = f"""
            MERGE INTO acct_pplan_hist aph
            USING ( SELECT '{inst_id}' as institution_id,
                    '{ent_id}' as entity_id,
                    sysdate as creation_date,
                    '{pplan_id}' as prev_acct_pplan_id,
                    '{new_pp}' as curr_acct_pplan_id,
                    {ach_amt} as payment_amt,
                    -1 as payment_seq_nbr from dual ) src
            ON (aph.institution_id = src.institution_id
                   and aph.entity_id = src.entity_id
                   and to_char(aph.creation_date,'DD-MON-YYYY')
                   = to_char( src.creation_date,'DD-MON-YYYY' ) )
            WHEN NOT MATCHED THEN
            INSERT  (institution_id, entity_id, creation_date,
                     prev_acct_pplan_id, curr_acct_pplan_id,
                     payment_amt, payment_seq_nbr)
            VALUES (src.institution_id, src.entity_id, src.creation_date,
                    src.prev_acct_pplan_id, src.curr_acct_pplan_id,
                    src.payment_amt, src.payment_seq_nbr)
            """
        print("Update SQL:", update_str)
        try:
            if self.mode == 'TEST':
                print( 'Update ', update_str)
            else:
                curOracle.execute(update_str)
                conOracle.commit()
        except cx_Oracle.DatabaseError as err:
            err_msg = 'Error: During database connection or exec history '\
                     + str(err)
            print(err_msg)
        except Exception as err:
            err_msg = 'Error: During database update ' + str(err)
            print(err_msg)
            conOracle.rollback()
            conOracle.close()

        conOracle.close()

    def assemble_mail_msg(self, rpt_data):
        """
          builds string message that is the contents of the email
        """
        assy_msg = 'These Merchants have transactions that are greater than '\
                   'or equal to $100,000.  Transactions of this magnitude '\
                   'will be process via the Standard Funding Process.  If '\
                   'any of these Merchants need to be switched back to a '\
                   'SameDay Funding Posting Plan, it will need to be done via'\
                   ' a requested manual process.\n \n'
        for index, rpt_rec in rpt_data.iterrows():
            assy_msg = assy_msg + 'Merchant: {} ID: {} funding amount: {} has'\
                  ' been moved from Same Day to STD. funding Plan: {} Plan: '\
                  '{} Settle Date: {}. \n'.format(
                       rpt_rec['customer_name'], rpt_rec['owner_entity_id'],
                       rpt_rec['ach_amt'], rpt_rec['acct_pplan_id'],
                       rpt_rec['new_pplan_id'], str(rpt_rec['settl_date']))

        return assy_msg

    def __init__(self, institution_id):
        self.inst_id = institution_id
        self.db_engine = self.get_engine()
        # Create the Handler for logging data to a file
        self.logger = logging.getLogger(__name__)
        log_file_name = 'LOG/{0}.log'.format('sameday_to_std')
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
        self.mode = 'PROD'


def main():
    """
    main routine parse arguments look for institution_id and execute
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("institution_id",
                        help="institution_id the institution_id is a required"
                        " parameter")
    args = parser.parse_args()

    # db_engine = get_engine()
    institution_id = args.institution_id
    sd_to_std_object = sd_to_std(institution_id)
    sd_to_std_object.set_logger_level(2)
    list_data = sd_to_std_object.get_data_overlimit()
    if len(list_data) > 0:
        rpt_data = list_data.iloc[0:0]
        rpt_data['new_pplan_id'], rpt_data['new_cycle'] = None, None
    for index, over_rec in list_data.iterrows():
        new_pp, pay_cycle = sd_to_std_object.calc_new_plan(over_rec)
        if new_pp != '-1':
            new_plan = new_pp
        else:
            new_plan = 'Error'
        print(' new pp: ', new_pp)
        if new_pp > -1:
            sd_to_std_object.update_pp(new_pp, over_rec)
            sd_to_std_object.update_pay_cycle(pay_cycle, over_rec)
        sd_to_std_object.log_fund_chg_history(new_pp, over_rec)
        df_insert = {'institution_id': over_rec['institution_id'],
                     'entity_acct_id': over_rec['entity_acct_id'],
                     'owner_entity_id': over_rec['owner_entity_id'],
                     'customer_name': over_rec['customer_name'],
                     'ach_amt': over_rec['ach_amt'],
                     'payment_cycle': over_rec['payment_cycle'],
                     'acct_pplan_id': over_rec['acct_pplan_id'],
                     'settl_date': over_rec['settl_date'],
                     'new_pplan_id': new_plan,
                     'new_cycle': pay_cycle}
        rpt_data = rpt_data.append(df_insert, ignore_index=True)
    if len(list_data) > 0:
        list_msg = sd_to_std_object.assemble_mail_msg(rpt_data)
        try:
            sd_to_std_object.send_mail_msg(list_msg)
        except Exception as exc:
            print('Mail Exception ' + exc)

if __name__ == "__main__":

    main()
