#!/usr/bin/env python

import unicodedata
import re
import sys
import getopt
import datetime
import smtplib
from email.mime.text import MIMEText
import __future__
import os
import cx_Oracle
import configparser
MAIL_TO = 'reports-clearing@jetpay.com'
MAIL_FROM = 'mas@jetpay.com'
PROGRAM_NAME = None
ALERT_TO = 'mas@jetpay.com'

def sendalert(message):
    '''
    Name : sendalert
    Arguments: institution_id and message
    Description : send the alert whenever an error occured during the process
    Returns: Nothing
    '''
    msg = MIMEText(message)
    msg['Subject'] = 'Err in ' + PROGRAM_NAME
    msg['From'] = MAIL_FROM
    msg['To'] = ALERT_TO
    print(msg)
    try:
        mail_obj = smtplib.SMTP('localhost')
        resp = mail_obj.send_message(msg)
        mail_obj.quit()
        print('Successfully sent email', resp)
    except smtplib.SMTPException as err:
        print('Error: unable to send alert email ' + str(err))

def update_mas_code_grp_tier(con, eff_date, config):
    '''
    Name : update_mas_code_grp
    Arguments: connection handler
    Description : Update the mas_code_grp table
    Returns: Nothing
    '''
    try:
        query_str = """
        merge into mas_code_grp mcg
        using (
        select 
            distinct fir.MAS_CODE qualify_mas_code, 
            fir.TEMPLATE_MAS_CODE, mcg.MAS_CODE_GRP_ID, 
            mcg.MAS_CODE, fir.card_scheme
        FROM flmgr_interchange_rates fir
        join MAS_CODE_GRP mcg
            on mcg.QUALIFY_MAS_CODE = fir.TEMPLATE_MAS_CODE
        WHERE 
            fir.usage  = 'DEFAULT_DISCOUNT'
            and fir.CARD_SCHEME in ('03','04','05','08')
            and REGION in ('ALL', :region)
            and mcg.MAS_CODE_GRP_ID = 9
        ) fmcg
        on (mcg.qualify_mas_code = fmcg.qualify_mas_code
        --and mcg.MAS_CODE = fmcg.TEMPLATE_MAS_CODE
        and mcg.MAS_CODE_GRP_ID = fmcg.MAS_CODE_GRP_ID
        and fmcg.MAS_CODE_GRP_ID = 9
        and mcg.INSTITUTION_ID = :inst_id)
        when not matched then
        insert (INSTITUTION_ID,MAS_CODE_GRP_ID,QUALIFY_MAS_CODE,MAS_CODE)
        values(:inst_id, fmcg.MAS_CODE_GRP_ID, fmcg.qualify_mas_code, fmcg.MAS_CODE)
        """
        print(query_str)
        cur = con.cursor()
        for inst in config['Inst_Region']:
            cur.execute(query_str, {'inst_id':inst, 'region': config['Inst_Region'][inst]})
            print("Merge result in update_mas_code_grp_tier for inst", inst, cur.rowcount)
        cur.close()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution in update_mas_code_grp_tier' + str(err)
        print(err_msg)
        con.rollback()
        sendalert(err_msg)
        con.close()
        sys.exit()

def main(argv):
    '''
    Main function
    '''
    global PROGRAM_NAME, MAIL_TO, MAIL_FROM, ALERT_TO

    eff_date = datetime.datetime.now()
    PROGRAM_NAME = sys.argv[0]
    print(PROGRAM_NAME)
    try:
        opts, args = getopt.getopt(argv, "h:d:t:v", ["inst_id=", "date="])
    except getopt.GetoptError:
        print(PROGRAM_NAME, ' -d <date> -t test@jetpay.com')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(PROGRAM_NAME, ' -d <date> -t test@jetpay.com')
            sys.exit()
        elif opt in ("-d", "--date"):
            eff_date = datetime.datetime.strptime(arg, "%Y%m%d").date()
        elif opt == '-t':
            MAIL_TO = arg
            ALERT_TO = arg
        elif opt == '-v':
            verbose = True
        else:
            print('Invalid option. Below is the usage')
            print(PROGRAM_NAME, ' -d <date> -t test@jetpay.com')
            sys.exit()
    try:
        config = configparser.ConfigParser()
        config.read('inst.cfg')
        db_string = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
        db_string = db_string + '@' + os.environ["IST_DB"]
        # db_string = "masclr/masclr@authqa"
        print(db_string)
        con = cx_Oracle.connect(db_string)
        update_mas_code_grp_tier(con, eff_date, config)
        con.commit()
        con.close()
    except cx_Oracle.DatabaseError as err:
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        sendalert(err_msg)
    except Exception as err:
        err_msg = 'Error: During database update ' + str(err)
        print(err_msg)
        sendalert(err_msg)

if __name__ == "__main__":
    main(sys.argv[1:])