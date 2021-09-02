#!/usr/bin/env python
'''
$Id: release_reserve_fund.py 4455 2017-12-21 18:32:34Z skumar $
$Rev: 4455 $
File Name:  release_reserve_fund.py

Description:  This script release reserve amount from the merchant

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
mail_to = 'reports-clearing@jetpay.com'
mail_from = 'mas@jetpay.com'
program_name = None
alert_to = 'mas@jetpay.com'

def sendalert(message):
    '''
    Name : sendalert
    Arguments: message
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

def checkMerchant(con, merch_id, amt):
    '''
    Name : checkMerchant
    Arguments: Database connection handler, Merchant ID and Reserve Amount
    Description : Check whether the normal reserve merchant has sufficient funds to release
    Returns: Nothing
    '''
    try:
        print('Inside checkMerchant', merch_id, amt)
        query_str = """
            select ae.entity_id, ea.POST_PAY_AMT, ea.POST_FEE_AMT 
            from  ACQ_ENTITY ae
            join ENTITY_ACCT ea
            on ae.INSTITUTION_ID = ea.INSTITUTION_ID 
            and ae.ENTITY_ID = ea.OWNER_ENTITY_ID
            join ACQ_ENTITY_ADD_ON aea
            on ea.INSTITUTION_ID = aea.INSTITUTION_ID 
            AND ea.OWNER_ENTITY_ID = aea.ENTITY_ID
            WHERE ea.OWNER_ENTITY_ID    = :entity_id
            and ea.ACCT_POSTING_TYPE = 'R'
            and ae.RSRV_FUND_STATUS = 'R'
            and ea.POST_PAY_AMT >= :amount
            and aea.user_defined_1 != 'ROLLING-180'
            """
        cur = con.cursor()
        cur.execute(query_str, {'entity_id':merch_id, 'amount':amt})
        #query_str += ";\n"
        print(query_str)
        query_result = cur.fetchone()
        print('Inside checkMerchant query_result', query_result)
        cur.close()
        return query_result
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: In checkMerchant - During database connection or execution ' + str(err)
        print(err_msg)
        sendalert( err_msg)
        sys.exit()

def getSeqNbr(con, merch_id, amt, mode):
    '''
    Name : sendreport
    Arguments: Database connection handler, institution_id and message
    Description : Retrieve the payment sequence number whose amount matches to the release amount
    Returns: Nothing
    '''
    try:
        print('Inside getSeqNbr', merch_id, amt)
        print('test mode:',mode)
        query_str = """
            select distinct aad.INSTITUTION_ID, aad.ENTITY_ACCT_ID,
            aad.PAYMENT_SEQ_NBR, aad.AMT_PAY, aad.AMT_FEE
            from ACCT_ACCUM_DET aad
            join entity_acct ea
            on ea.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID 
            AND ea.INSTITUTION_ID = aad.INSTITUTION_ID
            and ea.ACCT_POSTING_TYPE = 'R'
            WHERE ea.OWNER_ENTITY_ID = :entity_id
            and aad.PAYMENT_STATUS is null
            order by aad.AMT_PAY desc
            """
        cur = con.cursor()
        cur.execute(query_str, {'entity_id':merch_id})
        #query_str += ";\n"
        print(query_str)
        query_result = cur.fetchall()
        #print(query_result)
        total = amt
        seq_list = []
        for element in query_result:
            insti_id = element[0]
            acct_id = element[1]
            temp_amt = 0
            temp_amt = element[3] + element[4]
            if total / temp_amt > 1 :
                #seq_list = seq_list + ', ' + int(element[2])
                seq_list.append(element[2])
                total = total - temp_amt
                print('total:', total, 'temp_amt:', temp_amt)
            if total <= 0:
               break
        s_list = ",".join(str(x) for x in seq_list)
        print('payment sequence number list:', s_list)
        cur.close()
        query_str1 = """
             update ACCT_ACCUM_DET aad set PAYMENT_STATUS = 'X'
             WHERE aad.INSTITUTION_ID = :inst_id
             and aad.ENTITY_ACCT_ID = :entity_acct_id
             and aad.PAYMENT_STATUS is null
             """
        query_str1 += """and aad.PAYMENT_SEQ_NBR not in ( """
        query_str1 = query_str1 + s_list + " )"

        cur1 = con.cursor()
        print(query_str1)
        result = cur1.execute(query_str1, {'inst_id':insti_id, 'entity_acct_id':acct_id })
        #query_str += ";\n"
        print('Update query result:', result)
        cur1.close()
        query_str2 = """
             update ENTITY_ACCT ea set ea.STOP_PAY_FLAG = ''
             WHERE ea.INSTITUTION_ID = :inst_id
             and ea.OWNER_ENTITY_ID    = :entity_id
             and ea.ACCT_POSTING_TYPE = 'R'
             and ea.STOP_PAY_FLAG = 'Y'
             """
        cur2 = con.cursor()
        print(query_str2)
        result = cur2.execute(query_str2, {'inst_id':insti_id, 'entity_id':merch_id })
        #query_str += ";\n"
        print('Update query result:', result)
        cur2.close()
        if mode == 'PROD':
            con.commit()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: In getSeqNbr function - During database connection or execution ' + str(err)
        print(err_msg)
        sendalert( err_msg)

def main(argv):
    '''
    Main function
    '''
    inst_id = None
    global program_name, mail_to, mail_from, alert_to

    cur_day = datetime.datetime.now()
    program_name = sys.argv[0]
    #print(program_name)
    try:
        arg_parser = argparse.ArgumentParser(description= \
                    'Release reserve amount held by a merchant.')
        arg_parser.add_argument('-e', '-E', '--entity_id', type=int, \
                    default=False, help='Merchant ID (Required).', required=True)
        arg_parser.add_argument('-a', '-A', '--amount', type=float, \
                    default=False, help='Reserve Amount to release (Required)' \
                    , required=True)
        arg_parser.add_argument( '-v', '-V', '--verbose', \
                    action='count', dest='verbose',  required=False, \
                    help='verbose level... repeat up to five times.')
        arg_parser.add_argument('-t', '-T', '--test', type=str, \
                    required=False, default='TEST', \
                    help='Run mode indicator (Optional). Mode can be either TEST or PROD')
        arg_list = arg_parser.parse_args()

    except argparse.ArgumentError as err:
        err_msg = 'Error: During parsing command line arguements' + str(err)
        print(err_msg)
    try:
        print(arg_list.test)
        db_string = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
        db_string = db_string + '@' + os.environ["IST_DB"]
        #print(db_string)
        con = cx_Oracle.connect(db_string)
        res = checkMerchant(con, arg_list.entity_id, arg_list.amount)
        print('Return of checkMerchant:', res)
        if res is None:
            print('Merchant either is not under normal reserve or doesnt have sufficient amount to release')
        else:
            getSeqNbr(con, arg_list.entity_id, arg_list.amount, arg_list.test)
        con.close()
    except Exception as err:
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        sendalert(err_msg)

if __name__ == "__main__":
    main(sys.argv[1:])