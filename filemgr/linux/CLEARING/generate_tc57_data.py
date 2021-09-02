#!/usr/bin/env python3
import pandas as pd
import sqlalchemy as sa
import re
import os
import configparser as cp
from datetime import datetime as dt
from luhn import generate

def generate_settlement_records(fp, oracle_db, where_cond):
    settl_query = '''
    SELECT th.MID, th.TID, th.TRANSACTION_ID, th.REQUEST_TYPE, th.TRANSACTION_TYPE,
    CASE
       WHEN LENGTH(th.CARDNUM) = 14 THEN SUBSTR(th.CARDNUM,1,6)||'9999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 15 THEN SUBSTR(th.CARDNUM,1,6)||'99999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 16 THEN SUBSTR(th.CARDNUM,1,8)||'9999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 17 THEN SUBSTR(th.CARDNUM,1,8)||'99999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 18 THEN SUBSTR(th.CARDNUM,1,8)||'999999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 19 THEN SUBSTR(th.CARDNUM,1,8)||'9999999'||SUBSTR(th.CARDNUM,-4)
    END AS CARDNUM,
    th.EXP_DATE, th.AMOUNT, th.ORIG_AMOUNT, th.INCR_AMOUNT, th.FEE_AMOUNT, th.TAX_AMOUNT, th.PROCESS_CODE, th.STATUS,
    th.AUTHDATETIME, th.AUTH_TIMER, th.AUTH_CODE, th.AUTH_SOURCE, th.ACTION_CODE, th.SHIPDATETIME, th.TICKET_NO,
    th.NETWORK_ID, '' as ADDENDUM_BITMAP, th.CAPTURE, th.POS_ENTRY, th.CARD_ID_METHOD, th.RETRIEVAL_NO,
    th.AVS_RESPONSE, th.ACI, th.CPS_AUTH_ID, th.CPS_TRAN_ID, th.CPS_VALIDATION_CODE, th.CURRENCY_CODE,
    th.CLERK_ID, th.SHIFT, th.HUB_FLAG, th.BILLING_TYPE, th.BATCH_NO, th.ITEM_NO, th.OTHER_DATA, th.SETTLE_DATE,
    th.CARD_TYPE, th.CVV, th.PC_TYPE, th.CURRENCY_RATE, th.OTHER_DATA2, th.OTHER_DATA3, th.OTHER_DATA4,
    th.ARN, th.MARKET_TYPE, th.VV_RESULT, th.CARD_PRESENT, th.CARD_PROGRAM, th.ADDENDA_PRESENT,
    th.AUTHORIZATION_AUTHORITY, th.ORIGINATION_IP, th.SUBSCRIBER, th.EXTERNAL_TRANSACTION_ID,
    th.CARDHOLDER_VERIF_METH, th.CARD_LEVEL_RESULTS, th.TOKEN_USED, th.TOKEN_REQUESTED, th.SYSTEM_TRACE_NUMBER, th.ACI_REQUESTED
    ,m.sic_code
    FROM TRANHISTORY th
    join merchant m
    on th.mid = m.mid
    left join merchant_addenda_rt mar
    on mar.mid = m.mid
    join master_merchant mm
    on m.mmid = mm.mmid
    '''
    settl_query = settl_query + where_cond
    print(settl_query)

    df = pd.read_sql_query(settl_query,oracle_db)
    df.fillna(value='', inplace=True)
    print(df['cardnum'])
    df['cardnum'] = df['cardnum'].str[:-1]
    c_num = []
    for line in df['cardnum']:
        print(line)
        checkDigit = generate(line)
        print(checkDigit)
        c_num.append(line + str(checkDigit))
    print(c_num)
    df['cardnum'] = c_num

    #print(df.columns.values.tolist())

    columns_string = str(list(df.columns))[1:-1]
    columns_string = re.sub(r'\'', '', columns_string)

    #print(df.values)
    insert_settl = '\n INSERT INTO SETTLEMENT ('

    for row in df.itertuples(index=False,name=None):
        values_string = ''
        values_string += re.sub(r'nan', 'NULL', str(row))
        values_string += ',\n'
        print_str = insert_settl + columns_string + ')\n     VALUES\n' + values_string[:-2] + ';'
        fp.write(print_str)

def generate_transaction_records(fp, oracle_db, where_cond):
    txn_query = '''
    SELECT th.MID, th.TID, th.TRANSACTION_ID, th.REQUEST_TYPE, th.TRANSACTION_TYPE,
    CASE
       WHEN LENGTH(th.CARDNUM) = 14 THEN SUBSTR(th.CARDNUM,1,6)||'9999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 15 THEN SUBSTR(th.CARDNUM,1,6)||'99999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 16 THEN SUBSTR(th.CARDNUM,1,8)||'9999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 17 THEN SUBSTR(th.CARDNUM,1,8)||'99999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 18 THEN SUBSTR(th.CARDNUM,1,8)||'999999'||SUBSTR(th.CARDNUM,-4)
       WHEN LENGTH(th.CARDNUM) = 19 THEN SUBSTR(th.CARDNUM,1,8)||'9999999'||SUBSTR(th.CARDNUM,-4)
    END AS CARDNUM,
    th.EXP_DATE, th.AMOUNT, th.ORIG_AMOUNT, th.INCR_AMOUNT, th.FEE_AMOUNT, th.TAX_AMOUNT, th.PROCESS_CODE, th.STATUS,
    th.AUTHDATETIME, th.AUTH_TIMER, th.AUTH_CODE, th.AUTH_SOURCE, th.ACTION_CODE, th.SHIPDATETIME, th.TICKET_NO,
    th.NETWORK_ID, '' as ADDENDUM_BITMAP, th.CAPTURE, th.POS_ENTRY, th.CARD_ID_METHOD, th.RETRIEVAL_NO,
    th.AVS_RESPONSE, th.ACI, th.CPS_AUTH_ID, th.CPS_TRAN_ID, th.CPS_VALIDATION_CODE, th.CURRENCY_CODE,
    th.CLERK_ID, th.SHIFT, th.HUB_FLAG, th.BILLING_TYPE, th.BATCH_NO, th.ITEM_NO, th.OTHER_DATA, th.SETTLE_DATE,
    th.CARD_TYPE, th.CVV, th.PC_TYPE, th.CURRENCY_RATE, th.OTHER_DATA2, th.OTHER_DATA3, th.OTHER_DATA4,
    th.MARKET_TYPE, th.VV_RESULT, th.CARD_PRESENT, th.CARD_PROGRAM, th.ADDENDA_PRESENT,
    th.AUTHORIZATION_AUTHORITY, th.ORIGINATION_IP, th.SUBSCRIBER, th.EXTERNAL_TRANSACTION_ID,
    th.CARDHOLDER_VERIF_METH, th.CARD_LEVEL_RESULTS, th.TOKEN_USED, th.TOKEN_REQUESTED, th.SYSTEM_TRACE_NUMBER, th.ACI_REQUESTED
    ,m.sic_code
    FROM TRANHISTORY th
    join merchant m
    on th.mid = m.mid
    left join merchant_addenda_rt mar
    on mar.mid = m.mid
    join master_merchant mm
    on m.mmid = mm.mmid
    '''

    txn_query = txn_query + where_cond
    print(txn_query)

    txn_df = pd.read_sql_query(txn_query,oracle_db)
    txn_df.fillna(value='', inplace=True)
    print(txn_df['cardnum'])
    txn_df['cardnum'] = txn_df['cardnum'].str[:-1]
    c_num = []
    for line in txn_df['cardnum']:
        print(line)
        checkDigit = generate(line)
        print(checkDigit)
        c_num.append(line + str(checkDigit))
    print(c_num)
    txn_df['cardnum'] = c_num
    #print(txn_df.columns.values.tolist())

    columns_string = str(list(txn_df.columns))[1:-1]
    columns_string = re.sub(r'\'', '', columns_string)
    insert_txn = '\n INSERT INTO TRANSACTION ('

    for row in txn_df.itertuples(index=False,name=None):
        values_string = ''
        values_string += re.sub(r'nan', 'NULL', str(row))
        values_string += ',\n'
        print_str = insert_txn + columns_string + ')\n     VALUES\n' + values_string[:-2] + ';'
        fp.write(print_str)

def generate_icc_addenda_records(fp, oracle_db, where_cond):
    table_name = 'ICC_ADDENDA'
    print('Generating records for ', table_name)
    query_str = '''
        SELECT 
        READER_FAILED_KEYPAD, READER_FAILED_MAG_STRIPE, READER_FAILED_CHIP, 
        READER_FAILED_CONTACTLESS_MS, READER_FAILED_CONTACTLESS_CHIP, 
        READER_FAILED_MOBILE, READER_CAN_KEYPAD, READER_CAN_MAG_STRIPE, 
        READER_CAN_CHIP, READER_CAN_CONTACTLESS_MS, READER_CAN_CONTACTLESS_CHIP, 
        READER_CAN_MOBILE, AIP, AMOUNT, APP_TRANSACTION_COUNTER, CASHBACK_AMOUNT, 
        CRYPT_INFORMATION_DATA, CRYPTOGRAM, CARD_SEQUENCE_NUMBER, 
        CUST_EXCLUSIVE_DATA, CVM_RESULTS, FORM_FACTOR, ISSUER_APPLICATION_DATA, 
        IFD_SERIAL_NUMBER, ISSUER_AUTH_DATA, ISSUER_SCRIPT_RESULTS, 
        TERMINAL_CAPABILITIES, TERMINAL_COUNTRY_CODE, TERMINAL_CURRENCY_CODE, 
        '' as TRANS_DATETIME, 
        TRANS_TYPE, TVR, UNPREDICTABLE_NUMBER, 
        UNIQUE_ID, READER_USED, DEDICATED_FILE_NAME, APP_USAGE_CONTROL, 
        TERM_APP_VER, TERMINAL_TYPE, TRANS_SEQ_NUM, TRANS_CATEGORY_CODE, 
        AID, AUTHDATETIME, STORAGE_DATA 
        FROM ICC_ADDENDA 
        where unique_id in (select th.other_data3 from tranhistory th
                                   join merchant m
                                   on th.mid = m.mid
                                   left join merchant_addenda_rt mar
                                   on mar.mid = m.mid
                                   join master_merchant mm
                                   on m.mmid = mm.mmid
    '''
    query_str = query_str + where_cond + ' )'
    print('Query:', query_str)
    insert_str = '\n INSERT INTO {}  ('.format(table_name)
    add_df = pd.read_sql_query(query_str, oracle_db)
    add_df.fillna(value='', inplace=True)
    #print(add_df.columns.values.tolist())
    columns_string = str(list(add_df.columns))[1:-1]
    columns_string = re.sub(r'\'', '', columns_string)
    for row in add_df.itertuples(index=False, name=None):
        values_string = ''
        values_string += re.sub(r'nan', 'NULL', str(row))
        values_string += ',\n'
        print_str = insert_str + columns_string + ')\n     VALUES\n' + values_string[:-2] + ';'
        fp.write(print_str)

def generate_addenda_records(fp, table_name, oracle_db, where_cond):

    print('Generating records for ', table_name)
    query_str = 'select * from {} where unique_id in (select th.other_data3 from tranhistory th '.format(table_name)
    query_str = query_str + 'join merchant m on th.mid = m.mid left join merchant_addenda_rt mar on mar.mid = m.mid join master_merchant mm on m.mmid = mm.mmid '
    query_str = query_str + where_cond + ' )'
    print('Query:', query_str)
    insert_str = '\n INSERT INTO {}  ('.format(table_name)
    add_df = pd.read_sql_query(query_str, oracle_db)
    add_df.fillna(value='', inplace=True)
    #print(add_df.columns.values.tolist())
    columns_string = str(list(add_df.columns))[1:-1]
    columns_string = re.sub(r'\'', '', columns_string)
    for row in add_df.itertuples(index=False, name=None):
        values_string = ''
        values_string += re.sub(r'nan', 'NULL', str(row))
        values_string += ',\n'
        print_str = insert_str + columns_string + ')\n     VALUES\n' + values_string[:-2] + ';'
        fp.write(print_str)

if __name__ == "__main__":
    """
    Name : main
    Description: This script makes the test data
    Arguments: None
    """
    try:
        cfg_obj = cp.ConfigParser()
        if not cfg_obj.read('generate_tc57_data.cfg'):
            raise LocalException('Unable to read cfg file')

        print(cfg_obj['TC57']['where_cond'])
        where_cond = cfg_obj.get('TC57', 'where_cond')
        connection = 'oracle://'+os.environ["ATH_DB_USERNAME"] + ':' + os.environ["ATH_DB_PASSWORD"] + '@' + os.environ["ATH2_HOST"]+':1521/'+os.environ["TSP4_DB"]
        oracle_db = sa.create_engine(connection, echo=False)
        timestamp = dt.now().strftime('%Y%m%d_%H%M%S')
        outfile = 'load_auth_data_' + timestamp + '.sql'
        fp = open(outfile, 'w')
        print('outfile:', outfile)

        generate_settlement_records(fp, oracle_db, where_cond)
        generate_transaction_records(fp, oracle_db, where_cond)
        generate_addenda_records(fp, 'AUTH_ADDENDA', oracle_db, where_cond)
        generate_addenda_records(fp, 'ECOMM_ADDENDUM_AUTH', oracle_db, where_cond)
        generate_icc_addenda_records(fp, oracle_db, where_cond)
        generate_addenda_records(fp, 'ENCRYPTION_ADDENDA', oracle_db, where_cond)
        generate_addenda_records(fp, 'EXTENSION_LODGING', oracle_db, where_cond)
        fp.close()

    except configparser.Error as err:
        err_msg = 'Error: while reading or parsing the config file {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except LocalException as err:
        err_msg = 'Error: During database connection or execution of decline {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of decline inside main function {}'.format(err)
        print(err_msg)
        decline_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
