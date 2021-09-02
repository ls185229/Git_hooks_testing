#!/usr/bin/env python3
"""
    Test connection
"""

# import os
import sys

import logging
from logging.config import fileConfig

from optparse import OptionParser

import cx_Oracle

def main(tnsname=None, host=None, port=None, srvc_name=None, user=None, pw=None):
    """
    Main routine for connecting to database & logging results.
    """
    # >>> import platform; print(platform.node())
    # s01-prd-cm-fmgr-m01

    fileConfig('logging_config.ini')
    logger = logging.getLogger()

    # dsn_tns = cx_Oracle.makedsn('Host Name', 'Port Number', service_name='Service Name')
    # if needed, place an 'r' before any parameter in order to address any special
    # character such as '\'.

    # conn = cx_Oracle.connect(user=r'User Name', password='Personal Password', dsn=dsn_tns)
    # if needed, place an 'r' before any parameter in order to address any special
    # character such as '\'. For example, if your user name contains '\', you'll need to
    # place 'r' before the user name: user=r'User Name'

    logger.debug('before connect')
    try:
        dsn_tns = cx_Oracle.makedsn('s02-prd-clr-db-m01.jetpay.com', '1521',
                                    service_name='clear2.jetpay.com')
        # con = cx_Oracle.connect('masclr/masclr@clear2')
        con = cx_Oracle.connect(user=r'masclr', password='masclr', dsn=dsn_tns)
    except cx_Oracle.DatabaseError as error:
        logger.error('connect to clear2 error: ' + str(error))
        sys.exit()

    cur = con.cursor()
    query_str = """select sysdate from dual """

    logger.debug('before execute')
    cur.execute(query_str)

    logger.debug('before fetch')
    for result in cur:
        logger.info('clear2 at ' + str(result[0]))

    logger.debug('before cursor close')
    cur.close()

    logger.debug('before connection close')
    con.close()

if __name__ == "__main__":
    main()
