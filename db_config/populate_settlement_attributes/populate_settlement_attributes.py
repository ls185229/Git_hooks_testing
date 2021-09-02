#!/usr/bin/env python

"""
$Id: NPP-4805 $
$Rev: 4805 $
Author         :  Derek Armstrong (da250326)
File Name      :  populate_settlement_attributes_table.py

Description    :  This script takes input from the
                  settlement attributes CSV and populates
                  the settlement_attributes table in the
                  authqa database

Running options:  DEV, PROD
Shell Arguments:  -s
                    Determines running options
                  -csv
                    csv file: Must be full path
                    file contains settlement
                    attributes by shortname
                    example csv included below
Input           :  Settlement Attributes CSV File
Output          :  Performs SQL Insert on
                   SETTLEMENT_ATTRIBUTES table
Return          :  None
"""
import csv
from datetime import datetime
import sys
import os
import configparser
import argparse
import pandas as pd
import cx_Oracle


# Parse Arguments
ARG_PARSER = argparse.ArgumentParser(
    description='Populate Settlement Attributes')
ARG_PARSER.add_argument(
    'stage',
    help='Stage must be DEV or PROD')
ARG_PARSER.add_argument(
    'csv',
    help='full path of settlment attributes csv file \
        for shortname attributes')
ARGS = ARG_PARSER.parse_args()

# Stage Status
STAGE = ARGS.stage
LIST_VALID_STAGES = ['DEV', 'PROD']
if STAGE not in LIST_VALID_STAGES:
    raise ValueError(f"stage arguement must be one of: {LIST_VALID_STAGES}")

# Check CSV File Path
CSV_FILE = ARGS.csv
if os.path.isfile(CSV_FILE) is not True:
    raise FileNotFoundError(f"{CSV_FILE} Not Found, must be full file path")

# Get Current Working Directory
CWD = os.getcwd()

# Set File Names
DEV_TEST_RUN_FILENAME = 'dev-test_run_results.csv'
ATTRIB_ERROR_LOG_NAME = 'log_attrib_errors.txt'
DB_ERROR_LOG_NAME = 'log_database_errors.txt'
DB_INI_FILE = 'pop_set_attribs_db_config.ini'

# Set File Paths
ATTRIBUTES_CONFIG_CSV_PATH = CSV_FILE
DEV_TESTING_CSV_PATH = CWD + '/' + DEV_TEST_RUN_FILENAME
ATTRIB_ERRORS_LOG = CWD + '/' + ATTRIB_ERROR_LOG_NAME
DATABASE_ERRORS_LOG = CWD + '/' + DB_ERROR_LOG_NAME
DATABASE_INI_PATH = CWD + '/' + DB_INI_FILE

# Read in Database configuration file
if os.path.isfile(DATABASE_INI_PATH) is not True:
    raise FileNotFoundError(f"Database ini file Not Found \
        {DATABASE_INI_PATH}")

DB_CONFIG = configparser.ConfigParser()
DB_CONFIG.sections()
DB_CONFIG.read(DATABASE_INI_PATH)
DB_CONFIG.sections()

DB_URL = str(DB_CONFIG['database']['url'])
DB_PORT = str(DB_CONFIG['database']['port'])
DB_SID = str(DB_CONFIG['database']['sid'])
DSN_STR = cx_Oracle.makedsn(DB_URL, DB_PORT, DB_SID)
DB_USER = str(DB_CONFIG['database']['user'])
DB_PASS = str(DB_CONFIG['database']['pass'])

# Example Settlement Attributes CSV
EXAMPLE_CSV_FORMAT = '''
====================================
            Example CSV
====================================
    Shortname  institution attribute_1 attrib_value_1  attribute_2 \
     attrib_value_2 attribute_3 attrib_value_3    attribute_4 attrib_value_4
0       JETPAY          101      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
1     JETPAYSQ          105      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
2   0400CLS107          107      CUTOFF          04:00          NaN \
                NaN         NaN            NaN            NaN            NaN
3   CNV1500107          107      CUTOFF          15:30  CONV_CHARGE \
                  C         NaN            NaN            NaN            NaN
4   CNVNEXT107          107      CUTOFF          19:00  CONV_CHARGE \
                  C     FUNDING        NEXTDAY            NaN            NaN
5   CNVNORM107          107      CUTOFF          01:00  CONV_CHARGE \
                  C         NaN            NaN            NaN            NaN
6     JETPAYIS          107      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
7   NEXTDAY107          107      CUTOFF          19:00          NaN \
                NaN     FUNDING        NEXTDAY            NaN            NaN
8        OKDMV          107      CUTOFF          19:00  CONV_CHARGE \
                  C     FUNDING        NEXTDAY  AMEX_PRE_FUND              Y
9        OKTAX          107      CUTOFF          19:00          NaN \
                NaN     FUNDING        NEXTDAY            NaN            NaN
10    JETPAYMD          117      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
11    SECUREBC          117      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
12   JETPAYESQ          121      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
13  NEXTDAY121          121      CUTOFF          19:00          NaN \
                NaN     FUNDING        NEXTDAY            NaN            NaN
14         DAS          122      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
15  NEXTDAY122          122      CUTOFF          19:00          NaN \
                NaN     FUNDING        NEXTDAY            NaN            NaN
16     WEPAYCA          127      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
17     PTCMDCA          129      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
18    B2BILLCA          130      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
19  CNVNORM130          130      CUTOFF          01:00  CONV_CHARGE \
                  C         NaN            NaN            NaN            NaN
20    JETPAYCA          132      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
21    JETPAYUS          133      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
22     PTCMDUS          134      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
23     EXPEDIA          808      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
24    DYNMTEST          808      CUTOFF          01:00          NaN \
                NaN         NaN            NaN            NaN            NaN
====================================
'''


def query_database():
    '''
    Name        : query_database
    Arguments   : None
    Description : SQL Query to find missing entries in the settlement
                  attributes table using the entity id when compared
                  to the entity_to_auth table
    Return      : Query Results
    '''

    query_entity_to_auth = '''select
      institution_id,
      entity_id,
      file_group_id
    from
      entity_to_auth
    where
      not exists (
        select
          *
        from
          settlement_attributes
        where
          settlement_attributes.entity_id = entity_to_auth.entity_id
      )'''
    # OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY'''
    # Add "OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY"
    # for testing to reduce row returns

    # Make Connection
    print('Making Database Connection...')
    con_db = cx_Oracle.connect(user=DB_USER, password=DB_PASS, dsn=DSN_STR)
    cur = con_db.cursor()
    # Pull Comparision Query
    missing_records = []
    print('Performing Database Query...')
    for row in cur.execute(query_entity_to_auth):
        missing_records.append(row)
        print("Record Found: ", row)
    con_db.close()
    return missing_records


def get_attributes(shortname):
    '''
    Name        : get_attributes
    Arguments   : shortname
    Description : matches shortname from csv and parses attributes
    Return      : List of settlement attributes for shortname
    Return Error:
                  (0) - shortname not found
                  (2) - Duplicate shortnames found
                  (3) - An attribute is not paired properly (name,value)
    '''
    attrib_csv = pd.read_csv(ATTRIBUTES_CONFIG_CSV_PATH)
    shortname_attributes = attrib_csv[attrib_csv['Shortname'] == shortname]
    # Error Check for no shortname Match
    len_shortname_attributes = len(shortname_attributes)
    if len_shortname_attributes == 0:
        return 0
    # Error Check for duplicate shortname in CSV
    elif len_shortname_attributes > 1:
        return 2
    else:
        attributes = shortname_attributes.iloc[0, 2:]
        attrib_list = list(attributes)
        cleaned_attributes = [
            item for item in attrib_list if str(item) != 'nan']
        # Error Check to make sure attributes are paired
        len_cleaned_attributes = len(cleaned_attributes)
        if (len_cleaned_attributes % 2) != 0:
            return 3
        else:
            return cleaned_attributes


def create_new_sql_records(missing_records):
    '''
    Name        : create_new_sql_records
    Arguments   : missing_records -
                      SQL Query Result containing columns
                      institution_id, entity_id, file_group_id
                      from entity_to_auth table
    Description : Uses get_attributes function to get settlement
                  attributes for each entity_id provided
                  in missing_records. For each record
                  generate a new tuple and append it to
                  new_sql_entries. Returning the list.
    Return      : List of new tuple sql records created
    '''
    new_record = []
    new_sql_entries = []
    entity_errors = []
    today = datetime.today()
    cur_date = today.strftime('%d-%b-%y').upper()
    print('Processing Records to get Attributes...')
    for record in missing_records:
        attributes = get_attributes(record[2])
        # Check for Error Returns from get_attributes
        if attributes == 0:
            attrib_error = f"ERROR: shortname not found \
                for record (instituion, entity_id, shortname): {record}"
            print(attrib_error)
            entity_errors.append(attrib_error)
        elif attributes == 2:
            attrib_error = f'''
            ERROR:
            Duplicate shortname Found in Settlment Attributes CSV
            path:{ATTRIBUTES_CONFIG_CSV_PATH}
            Make sure the CSV does not have duplicate \
                shortnames listed in the First Column
            {EXAMPLE_CSV_FORMAT}
            '''
            sys.exit(attrib_error)
        elif attributes == 3:
            attrib_error = f'''
            ERROR:
            Attributes not paired in Settlment Attributes CSV
            path:{ATTRIBUTES_CONFIG_CSV_PATH}
            Make sure each attribute has a value
            {EXAMPLE_CSV_FORMAT}
            '''
            sys.exit(attrib_error)
        else:
            # Interate through attributes and append each attribute
            # row entry to the new sql entries
            max_attributes = len(attributes)
            for indx in range(0, max_attributes, 2):
                new_record = (
                    record[0], record[1], attributes[indx],
                    attributes[indx+1], None, cur_date, None)
                new_sql_entries.append(new_record)
                print("NEW RECORD: ", new_record)
    # Write Attributes Error Log
    with open(ATTRIB_ERRORS_LOG, mode='w', encoding='utf-8') as attrib_err_log:
        attrib_err_log.write('\n'.join(entity_errors))
    return new_sql_entries


def write_csv_output(new_sql_entries):
    '''
    Name        : write_csv_output
    Arguments   : new_sql_entries -
                      SQL records in the form of
                      a tuple list
    Description : Creates a CSV output of expected
                  new SQL records to be inserted
                  into settlement_attributes table
                  in authqa
    Return      : None
    '''
    print('Writing DEV Results CSV...')
    with open(DEV_TESTING_CSV_PATH, 'w', newline='') as dev_out_file:
        csv_out = csv.writer(dev_out_file)
        csv_out.writerow(
            ['INSTITUTION_ID', 'ENTITY_ID', 'ATTRIBUTE_NAME',
             'ATTRIB_VALUE', 'NOTE', 'START_DATE', 'END_DATE'])
        for row in new_sql_entries:
            print(f'Writing Row: {row}')
            csv_out.writerow(row)
    print(f'''DEV TEST RUN COMPLETE
    Output of new records written to {DEV_TESTING_CSV_PATH}''')


def insert_sql_batch(new_sql_entries):
    '''
    Name        : insert_sql_batch
    Arguments   : new_sql_entries -
                      SQL records in the form of
                      a tuple list
    Description : Inserts new SQL records to
                  settlement_attributes table
                  in authqa
    Return      : None
    '''
    print("Performing SQL Insert for new records...")
    database_errors = []
    # Connect to Database
    con_db = cx_Oracle.connect(user=DB_USER, password=DB_PASS, dsn=DSN_STR)
    cur = con_db.cursor()
    # Write Records
    insert_statement = "insert into SETTLEMENT_ATTRIBUTES \
        values(:1, :2, :3, :4, :5, :6, :7)"
    cur.executemany(insert_statement, new_sql_entries, batcherrors=True)
    for error in cur.getbatcherrors():
        batch_error = f"ERROR: {error.message} at row offset {error.offset}"
        print(batch_error)
        database_errors.append(batch_error)
    # Write DB Error Log
    with open(
            DATABASE_ERRORS_LOG,
            mode='a',
            encoding='utf-8') as db_err_log:
        db_err_log.write('\n'.join(database_errors))
    con_db.commit()
    con_db.close()


def main():
    '''
    Name : main
           Uses a csv file to determine settlment
           attributes.  Find all missing merchants
           in the settlement_attributes table
           using the entity_to_auth table as
           a comparision.  Creates all settlement
           attributes records for any missing merchants.
           PROD run inserts those records into the settlement
           attributes table.
           DEV run creates CSV of new records for testing
           purposes before PROD run.
    '''
    sql_query_results = query_database()
    new_records = create_new_sql_records(sql_query_results)
    if STAGE == "DEV":
        write_csv_output(new_records)
    elif STAGE == "PROD":
        insert_sql_batch(new_records)
    else:
        raise ValueError(f"stage arguement must be \
            one of: {LIST_VALID_STAGES}")


if __name__ == "__main__":
    main()
