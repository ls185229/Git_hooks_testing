#!/usr/bin/env python3
'''
Created on Jul 02, 2021
@author: Lakshya, Supraja

#######################################################################################
# File Name:  update_eom_files_count.py
#
# Description: Update the FILE_COUNT column in table MAS_TYPE_FILE_COUNT
#              using the table MAS_FILE_LOG
#
# Script Arguments:  -d, --date Month_END Date in the string format [YYYYMMDD] (Required)
#
# example : python update_eom_files_count.py -d 20210731
#
# Results:  The FILE_COUNT in table MAS_TYPE_FILE_COUNT gets updated
#           Any new record is also added to the table
#
# Notes:  This script will work correctly from 2020-01-31 to 2029-12-31
#         INSTITION_ID length should be = 3
#         FILE_TYPE lenght should be = 8
#
#######################################################################################
'''

import argparse
import sys
import logging
import os
import datetime
import calendar
import cx_Oracle

#######################################################################################

def scriptclose(message):
    '''
    Name : scriptclose
    Arguments: Error Message
    Description : Display error message and end the script
    Returns: Nothing
    '''
    print(message)
    logging.info(message)
    sys.exit()

def dbconnection():
    '''
    Name : dbconnection
    Arguments: Nothing
    Description : To establish db connection
    Returns: Connection object
    '''
    db_string = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
    db_string = db_string + '@' + os.environ["IST_DB"]

    try:
        con = cx_Oracle.connect(db_string)
        logging.info("DB name - " + os.environ["IST_DB"] + " : COnnected")
        logging.info("Version : "+ str(con.version))
    except cx_Oracle.Error as error:
        scriptclose(error)

    return con

def datestdtojd(stddate):
    '''
    Name : datestdtojd
    Arguments:  Month_END Date in the string format [YYYYMMDD]
    Description : Convert Gregorian date to Julian date
    Returns: Julian date
    '''
    try:
        fmt = '%Y%m%d'
        sdtdate = datetime.datetime.strptime(stddate, fmt)
    except ValueError:
        scriptclose("This is the incorrect date string format. It should be YYYYMMDD")


    sdtdate = sdtdate.timetuple()
    if sdtdate.tm_mday != calendar.monthrange(sdtdate.tm_year, sdtdate.tm_mon)[1]:
        scriptclose("It is not a monthend date")

    logging.info("Input monthend date : "+ str(stddate)+"\n")
    jdate = sdtdate.tm_yday
    jdate = str(jdate).zfill(3)
    jdate = stddate[3]+jdate
    return jdate

#######################################################################################

def main(argv):
    '''
    Main function
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '-D', '--date', required=False, help='Date to run')
    args = parser.parse_args()
    # make a log file to  store outputs
    logging.basicConfig(filename='update_eom_files_count_draft.log', filemode='w', format='%(message)s', level='INFO')
    logging.info("Script Execution Date : " + str(datetime.datetime.now()))
    # Establishing DB CONNECTIONS
    con =  dbconnection()
    # Julian format EOM Date
    julian_date = datestdtojd(args.date)

    ###################################################################################

    # Query for fetching all the records of input Monthend date
    try:
        query_str = """
        select substr(FILE_NAME,1,3), substr(FILE_NAME,5,8), count(1) from mas_file_log 
        where FILE_NAME like '%""" + julian_date + """%'
        group by substr(FILE_NAME,1,3) , substr(FILE_NAME,5,8) 
        order by substr(FILE_NAME,1,3) , substr(FILE_NAME,5,8)    
        """
        cur = con.cursor()
        cur.execute(query_str)
        mas_file_log_table = cur.fetchall()
        cur.close()
    except cx_Oracle.DatabaseError as err:
        con.rollback()
        con.close()
        scriptclose(err)

    # Query for fetching all the records from MAS_FILE_TYPE_COUNT where FREQUENCY="EOM"
    try:
        query_str = """
        select INSTITUTION_ID||FILE_TYPE from mas_file_type_count 
        where FREQUENCY='EOM' 
        order by INSTITUTION_ID, FILE_TYPE
        """
        cur = con.cursor()
        cur.execute(query_str)
        mas_file_type_count_table = cur.fetchall()
        cur.close()
    except cx_Oracle.DatabaseError as err:
        con.rollback()
        con.close()
        scriptclose(err)

    ###################################################################################

    logging.info("Institution_ID  File_Type  \t\tCount  \t\tStatus")
    for current_row in mas_file_log_table:
        if (current_row[0]+current_row[1],) in mas_file_type_count_table:
            # Record already exists in MAS_FILE_TYPE_COUNT
            try:
                query_str = """
                update mas_file_type_count
                set FILE_COUNT='""" + str(current_row[2]) + """'
                where INSTITUTION_ID='""" + current_row[0] + """'
                AND FILE_TYPE='""" + current_row[1] + """' AND FREQUENCY='EOM'
                """
                cur = con.cursor()
                cur.execute(query_str)
                cur.close()
                logging.info(current_row[0]+"\t\t"+current_row[1]+"\t\t"+str(current_row[2])+"\t\tOld row updated")
            except cx_Oracle.DatabaseError as err:
                con.rollback()
                con.close()
                scriptclose(err)

        else:
            # Record missing in MAS_FILE_TYPE_COUNT
            try:
                query_str = """
                select count(SEQ) from mas_file_type_count where INSTITUTION_ID=
                '""" + current_row[0] + """' and FILE_TYPE='""" + current_row[1] + """'
                """
                cur = con.cursor()
                cur.execute(query_str)
                seq=cur.fetchone()
                cur.close()
                query_str = """
                insert into mas_file_type_count (INSTITUTION_ID, FILE_TYPE, FREQUENCY, FILE_COUNT, SEQ)
                values ('""" + current_row[0] + "','" + current_row[1] + """','EOM',
                '""" + str(current_row[2]) + "','" + str(seq[0]) + """')
                """
                cur = con.cursor()
                cur.execute(query_str)
                cur.close()
                logging.info(current_row[0]+"\t\t"+current_row[1]+"\t\t"+str(current_row[2])+"\t\tNew row added")
            except cx_Oracle.DatabaseError as err:
                con.rollback()
                con.close()
                scriptclose(err)



    con.commit()
    con.close()
    print("File executed and data loaded successfully")
    logging.info("\nFile executed and data loaded successfully")

if __name__=="__main__":
    main(sys.argv[1:])
