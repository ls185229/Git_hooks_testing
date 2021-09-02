#!/usr/bin/env python
"""

$Id: update_mas_rates.py 4726 2018-10-08 11:40:47Z skumar $
"""

# import unicodedata
# import re
import sys
import getopt
import datetime
import smtplib
from email.mime.text import MIMEText
# import __future__
import os
import configparser
import cx_Oracle

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

def update_mascode(con, eff_date):
    '''
    Name : update_mascode
    Arguments: connection handler
    Description : Update the mas_code table
    Returns: Nothing
    '''
    try:
        query_str = """
             merge into mas_code mc
             using (
                 select MAS_CODE, CARD_SCHEME, MAS_DESC
                 from flmgr_interchange_rates
                 where usage = 'INTERCHANGE'
                 and trunc(ASSOCIATION_UPDATED) = :eff_date
                 and CARD_SCHEME in ('03', '04', '05', '08')
             ) fir
             on
                 (mc.mas_code = fir.mas_code)
             when matched then
                 update set card_scheme = fir.card_scheme,
                 mas_desc = fir.mas_desc
                 where mas_code = fir.mas_code
                 and card_scheme != fir.card_scheme
                 and mas_desc != fir.mas_desc
             when not matched then
                 insert (MAS_CODE, CARD_SCHEME, MAS_DESC, IRF_PROG_IND_DESC)
                 values (fir.mas_code, fir.card_scheme, fir.mas_desc, null)
        """
        cur = con.cursor()
        cur.execute(query_str, {'eff_date': eff_date})
        query_str += ";\n"
        #print(query_str)
        print("Merge result in update_mascode", cur.rowcount)
        cur.close()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        con.rollback()
        sendalert(err_msg)
        con.close()
        sys.exit()

def update_fee_pkg_mascode(con, eff_date, config):
    '''
    Name : update_fee_pkg_mascode
    Arguments: connection handler
    Description : Update the fee_pkg_mas_code table
    Returns: Nothing
    '''
    try:
        cur = con.cursor()
        query_str = """
        merge into FEE_PKG_MAS_CODE fpmc
        using (
            select MAS_CODE, CARD_SCHEME
            from flmgr_interchange_rates
            where usage = 'INTERCHANGE'
            and trunc(ASSOCIATION_UPDATED) = :eff_date
            and REGION in ('ALL', :region)
            and CARD_SCHEME in ('03', '04', '05', '08')
        ) fir
        on
            (fpmc.mas_code = fir.mas_code
            and fpmc.INSTITUTION_ID = :inst_id
            and fpmc.fee_pkg_id = :fee_pkg_id)
        when not matched then
            insert (INSTITUTION_ID, FEE_PKG_ID, MAS_CODE, CARD_SCHEME, MAS_EXPECTED_FLAG)
            values (:inst_id, :fee_pkg_id, fir.mas_code, fir.card_scheme, null)
        """
        #print(query_str)
        for inst in config['Inst_Region']:
            if config['Inst_Region'][inst] == 'USA':
                fee_pkg_list = [33, 34]
            else:
                fee_pkg_list = [33]

            for fpkg_id in fee_pkg_list:
                cur.execute(query_str, {'inst_id':inst, 'fee_pkg_id':fpkg_id, \
                  'eff_date': eff_date, 'region': config['Inst_Region'][inst]})
                #print(inst, fpkg_id)
                print("Merge result in update_fee_pkg_mascode for inst fpkg_id", inst, fpkg_id, cur.rowcount)
        cur.close()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        con.rollback()
        sendalert(err_msg)
        con.close()
        sys.exit()

def update_mas_fees(con, eff_date, config):
    '''
    Name : update_mas_fees
    Arguments: connection handler, and effective date
    Description : Update the mas_fees table
    Returns: Nothing
    '''
    try:
        query_str = """
            select
                t.tid,
                t.TID_SETTL_METHOD,
                case
                when t.TID_SETTL_METHOD = 'C' then '010004020000' else '010004020005'
                end fee_tid,
                '+' symbol
            from tid_adn ta
            join tid t
                on t.tid = ta.tid
            where
                (ta.major_cat = 'SALES'
                or (ta.major_cat = 'DISPUTES' and ta.minor_cat = 'REPRESENTMENT')
                or ta.major_cat = 'REFUNDS')
                and ta.usage = 'MAS'
                and upper(t.description) not like '%REVERSAL%'
                and upper(t.description) not like '%RETURNED%'
                and upper(t.description) not like '%SVP%'
                and upper(t.description) not like '%3RD%'
                and (ta.minor_cat not in ('CONVENIENCE_FEE') or ta.minor_cat is null)
            order by ta.tid
            """
        cur = con.cursor()
        cur.execute(query_str)
        #query_str += ";\n"
        #print(query_str)
        tid_list = cur.fetchall()
        cur.close()
        #print(tid_list)

    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
        err_msg += ' for query: ' + query_str
        print(err_msg)
        con.rollback()
        sendalert(err_msg)
        con.close()
        sys.exit()

    try:
        query_str1 = """
         merge into mas_fees mf
         using (
             select MAS_CODE, CARD_SCHEME, RATE_PERCENT,
             RATE_PER_ITEM, PER_TRANS_MAX
             from flmgr_interchange_rates
             where usage = 'INTERCHANGE'
             and trunc(ASSOCIATION_UPDATED) = :eff_date
             and REGION in ('ALL', :region)
             and CARD_SCHEME in ('03', '04', '05', '08')
         ) fir
         on
             (mf.MAS_CODE = fir.MAS_CODE
             and mf.INSTITUTION_ID = :inst_id
             and mf.FEE_PKG_ID = :fee_pkg_id
             and mf.TID_ACTIVITY = :src_tid
             and mf.TID_FEE = :fee_tid
             and mf.EFFECTIVE_DATE = :eff_date
             and mf.FEE_STATUS in ('C', 'F'))
         when matched then
         update set
             mf.RATE_PERCENT = fir.RATE_PERCENT   ,
             mf.RATE_PER_ITEM = fir.RATE_PER_ITEM ,
             mf.PER_TRANS_MAX = fir.PER_TRANS_MAX ,
             mf.CARD_SCHEME = fir.CARD_SCHEME     ,
             mf.FEE_STATUS = 'F'

         when not matched then
         insert (
             INSTITUTION_ID, FEE_PKG_ID, TID_ACTIVITY, MAS_CODE,
             TID_FEE, EFFECTIVE_DATE, FEE_STATUS, RATE_PER_ITEM,
             RATE_PERCENT, FEE_CURR, CARD_SCHEME, AMT_METHOD,
             CNT_METHOD, ADD_AMT1_METHOD, ADD_CNT1_METHOD,
             ADD_AMT2_METHOD, ADD_CNT2_METHOD, PER_TRANS_MAX,
             PER_TRANS_MIN, FEE_GRP_ID, ITEM_CNT_PLAN_ID, TIER_ID,
             TIER_FREQ, TIER_DATE_LIST_ID, TIER_ASSM_DAY,
             TIER_NXT_ASSM_DATE, TIER_LASTASSM_DATE,
             VARIABLE_PRICE_FLG, SLIDING_PRICE_FLG)
         values (
             :inst_id, :fee_pkg_id, :src_tid , fir.MAS_CODE,
             :fee_tid, :eff_date, 'F', fir.RATE_PER_ITEM,
             fir.rate_percent, :curr_code, fir.CARD_SCHEME,
             :symbol, :symbol, :symbol, :symbol, 'I', 'I',
             null, null, null, null, null, null,
             null, null, null, null, null, null)
        """

        for inst in config['Inst_Region']:
            if config['Inst_Region'][inst] == 'USA':
                fee_pkg_list = [33, 34]
            else:
                fee_pkg_list = [33]

            for fpkg_id in fee_pkg_list:
                for element in tid_list:
                    cur1 = con.cursor()
                    cur1.execute(query_str1, {'inst_id':inst, \
                    'fee_pkg_id':fpkg_id, 'src_tid':str(element[0]), \
                    'fee_tid':str(element[2]), 'eff_date': eff_date, \
                    'curr_code':config['Inst_Currency'][inst], \
                    'symbol':str(element[3]), \
                    'region': config['Inst_Region'][inst]})
                    print(inst, fpkg_id, str(element[0]), str(element[2]), str(element[3]))
                    print("Merge result in update_mas_fees", cur1.rowcount)
                    cur1.close()

    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
        err_msg += ' for query: ' + query_str1
        print(err_msg)
        con.rollback()
        sendalert(err_msg)
        con.close()
        sys.exit()

def update_mas_code_grp(con, eff_date, config):
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
            and trunc(ASSOCIATION_UPDATED) = :eff_date
            and fir.CARD_SCHEME in ('03', '04', '05', '08')
            and REGION in ('ALL', :region)
            order by mcg.MAS_CODE_GRP_ID
        ) fmcg
        on (mcg.qualify_mas_code = fmcg.qualify_mas_code
        --and mcg.MAS_CODE = fmcg.TEMPLATE_MAS_CODE
        and mcg.MAS_CODE_GRP_ID = fmcg.MAS_CODE_GRP_ID
        and mcg.INSTITUTION_ID = :inst_id)
        when not matched then
        insert (INSTITUTION_ID, MAS_CODE_GRP_ID, QUALIFY_MAS_CODE, MAS_CODE)
        values(:inst_id, fmcg.MAS_CODE_GRP_ID, fmcg.qualify_mas_code, fmcg.MAS_CODE)
        """
        #print(query_str)
        cur = con.cursor()
        for inst in config['Inst_Region']:
            cur.execute(query_str, {'inst_id':inst, 'eff_date': eff_date, \
                        'region': config['Inst_Region'][inst]})
            print("Merge result in update_mas_code_grp for inst", inst, cur.rowcount)
        cur.close()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
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
    MODE = "PROD"
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
            MODE = 'TEST'
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
        # if MODE == 'TEST':
        #     db_string = "masclr/masclr@authqa"
        print(db_string)
        con = cx_Oracle.connect(db_string)
        update_mascode(con, eff_date)
        update_fee_pkg_mascode(con, eff_date, config)
        update_mas_fees(con, eff_date, config)
        update_mas_code_grp(con, eff_date, config)
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
