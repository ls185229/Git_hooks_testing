#!/usr/bin/env python
'''
$Id: revert_back_reserve_setup.py 4661 2018-08-15 15:49:06Z lmendis $
$Rev: 4661 $
File Name:  revert_back_reserve_setup.py

Description:  This script revert back the reserve setup after 

Running options:

Shell Arguments:
                   -e = Entity ID (Required)
                   -a = Amount (Required)
                   -t = TEST MODE (Optional)

Output:       mail is sent to accounting

Return:   0 = Success
          !0 = Exit with errors
'''
import sys
import argparse
import getopt
import datetime
import smtplib
from email.mime.text import MIMEText
import os
import cx_Oracle
mail_from = 'mas@jetpay.com'
program_name = None
alert_to = 'mas@jetpay.com'

def sendalert(message):
    '''
    Name : sendalert
    Arguments: institution_id and message
    Description : send the alert whenever an error occured during the process
    Returns: Nothing
    '''
    msg = MIMEText(message)
    msg['Subject'] = 'Err in ' + program_name
    msg['From'] = mail_from
    msg['To'] = alert_to
    print(msg)
    try:
        mail_obj = smtplib.SMTP('localhost')
        resp = mail_obj.send_message(msg)
        mail_obj.quit()
        print('Successfully sent email', resp)
    except smtplib.SMTPException as err:
        print('Error: unable to send alert email ' + str(err))


def revertSetup(con, mode):
    '''
    Name : revertSetup
    Arguments: connection handler
    Description : Revert the reserve setup after the reserve amount
                  is released. update the payment status to null and
    Returns: Nothing
    '''
    try:
        print('Inside revertSetup')
        query_str = """
            SELECT 
                 DISTINCT aad.INSTITUTION_ID,
                 aad.ENTITY_ACCT_ID,
                 aad.PAYMENT_SEQ_NBR
            FROM ACCT_ACCUM_DET aad
            join entity_acct ea 
                 on ea.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID
                 AND ea.INSTITUTION_ID = aad.INSTITUTION_ID
            join acq_entity ae
                 on aad.INSTITUTION_ID = ae.INSTITUTION_ID
                 and ea.OWNER_ENTITY_ID = ae.ENTITY_ID
            WHERE
            aad.PAYMENT_STATUS = 'X'
            and ea.ACCT_POSTING_TYPE = 'R'
            and ae.ENTITY_STATUS = 'A'
            and ae.TERMINATION_DATE is null
            and ae.entity_level = '70'
            """
        cur = con.cursor()
        cur.execute(query_str)
        #query_str += ";\n"
        print(query_str)
        query_result = cur.fetchall()
        cur.close()

        query_str1 = """
             update ACCT_ACCUM_DET aad
             set aad.PAYMENT_STATUS = ''
             WHERE aad.INSTITUTION_ID = :inst_id
             and aad.ENTITY_ACCT_ID = :entity_acct_id
             and aad.PAYMENT_STATUS = 'X'
             and aad.PAYMENT_SEQ_NBR = :seq_nbr
             """
        print(query_str1)
        cur1 = con.cursor()
        for element in query_result:
            result = cur1.execute(query_str1, {'inst_id':element[0], \
                          'entity_acct_id':element[1], 'seq_nbr': element[2]})
        cur1.close()
        # query_str2 = """
             # update ENTITY_ACCT ea
             # set ea.STOP_PAY_FLAG = 'Y'
             # WHERE ea.INSTITUTION_ID = :inst_id
             # and ea.ENTITY_ACCT_ID = :entity_acct_id
             # and ea.ACCT_POSTING_TYPE = 'R'
             # and ea.STOP_PAY_FLAG = ''
             # """

        query_str2 = """
             update ENTITY_ACCT ea
             set ea.STOP_PAY_FLAG = 'Y'
             WHERE ea.INSTITUTION_ID = :inst_id
             and ea.ENTITY_ACCT_ID = :entity_acct_id
             and ea.ACCT_POSTING_TYPE = 'R'
             and ea.STOP_PAY_FLAG IS NULL
             """
        cur2 = con.cursor()
        print(query_str2)
        for element in query_result:
            result = cur2.execute(query_str2, {'inst_id':element[0], \
                          'entity_acct_id':element[1]})
        #query_str += ";\n"
        cur2.close()
        if mode == 'PROD':
            con.commit()
            print('Committed updates in production.')
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: In revertSetup function - During database connection or execution ' + str(err)
        print(err_msg)
        sendalert( err_msg)

def main(argv):
    '''
    Main function
    '''
    inst_id = None
    global program_name, mail_from, alert_to

    cur_day = datetime.datetime.now()
    program_name = sys.argv[0]
    #print(program_name)
    try:
        arg_parser = argparse.ArgumentParser(description='Revert the reserve \
                         setup after the reserve amount is released.')
        arg_parser.add_argument( '-v', '-V', '--verbose', \
                    action='count', dest='verbose',  required=False, \
                    help='verbose level... repeat up to five times.')
        arg_parser.add_argument('-t', '-T', '--test', type=str, required=False, \
                    default='TEST', help='Run mode indicator (Optional).')
        arg_list = arg_parser.parse_args()

    except argparse.ArgumentError as err:
        err_msg = 'Error: During parsing command line arguements' + str(err)
        print(err_msg)
    try:
        db_string = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
        db_string = db_string + '@' + os.environ["IST_DB"]
        #print(db_string)
        con = cx_Oracle.connect(db_string)
        revertSetup(con, arg_list.test)
        con.close()
    except Exception as err:
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        sendalert(err_msg)

if __name__ == "__main__":
    main(sys.argv[1:])