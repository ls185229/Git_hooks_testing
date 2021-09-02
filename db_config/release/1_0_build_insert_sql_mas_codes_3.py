#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
$Id: 1_0_build_insert_sql_mas_codes.py 39 2019-10-22 21:09:36Z bjones $

Read the Spring or Fall Release interchange spreadsheet, generating insert
statements to start the interchange rate update process.
"""

from __future__ import print_function

import unicodedata
import re
import os
import sys

from xlrd import open_workbook
import xlrd

def is_number(val):
    """Determines if a value is a number"""

    try:
        float(val)
        return True
    except ValueError:
        return False

def format_value(val):
    """If value is a number, truncate the non-signifigant digits."""
    print(val)
    val = unicodedata.normalize('NFKD', val).encode('ascii', 'ignore')
    if is_number(val):
        return '{:02.3f}'.format(val)
    else:
        return val.zfill(6)


def build_inserts(filename, mods=None):
    """
    Build insert statements for all mas_codes in the spreadsheet  using
    the form below.

    REM INSERTING into FLMGR_ICHG_RATES_TEMPLATE
    SET DEFINE OFF;
    Insert into FLMGR_ICHG_RATES_TEMPLATE
        (MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM,
        PER_TRANS_MAX, FPI_IRD, PROGRAM, PROGRAM_DESC,
        ASSOCIATION_UPDATED, RETIRE, DATABASE_UPDATED, CARD_SCHEME,
        TEMPLATE_MAS_CODE, NOTES, PER_TRANS_MIN, USAGE, REGION,
        ASSOCIATION_UPDATED)
    values
        ('0105UBCSUPMKT', null, null, null, null, null, null, null,
        null, null, null, null, null, null, null, null, 'INTERCHANGE', null,
        trunc(sysdate));

    """

    front_insert = \
        """Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION,
        ASSOCIATION_UPDATED)
    values (
        """

    print('rem gathering mas_codes from spreadsheet')
    print('')
    print('delete FLMGR_ICHG_RATES_TEMPLATE;')
    print('')

    book = open_workbook(filename)
    for mysheet in book.sheets():

        print('')
        print('rem ' + mysheet.name)
        if mysheet.name.upper() == 'Discover'.upper():
            card_scheme = "'08'"
        elif mysheet.name.upper() == 'MasterCard'.upper():
            card_scheme = "'05'"
        elif mysheet.name.upper() == 'Visa'.upper():
            card_scheme = "'04'"
        elif mysheet.name.upper() == 'Amex'.upper():
            card_scheme = "'03'"
        else:
            card_scheme = '  '

        rows_found = 0
        print('')

        print('')
        mas_codes = dict()

        # pylint: disable=line-too-long

        for row_index in range(1, mysheet.nrows):

            curr_mas_code = mysheet.cell_value(row_index, 3).strip()

            if  mysheet.cell_type(row_index, 3) != xlrd.XL_CELL_EMPTY       and \
                mysheet.cell_type(row_index, 3) != xlrd.XL_CELL_BLANK       and \
                mysheet.cell_value(row_index, 6) != 'variable'              and \
                (                                                               \
                    (                                                           \
                    mods is None                                            and \
                    mysheet.cell_type(row_index, 13) != xlrd.XL_CELL_EMPTY      \
                    )                                                       or  \
                    mods == 'ALL'                                           or  \
                    mods == mysheet.cell_value(row_index, 13)                   \
                ):

                # pylint: enable=bad-whitespace

                rows_found = rows_found + 1
                mas_codes[curr_mas_code] = rows_found

                # if rows_found > 3:
                #     continue

                for usage in ('INTERCHANGE', 'DEFAULT_DISCOUNT'):
                    print(front_insert, end="")
                    print("'" + mysheet.cell_value(row_index, 3).strip() + "'", end="")  # mas_code

                    # pylint disable=anomalous-backslash-in-string
                    mas_desc = re.sub('[\\%\\&]', '/', mysheet.cell_value(row_index, 4)[:30].strip())
                    mas_desc = re.sub(u'\u2013', '-', mas_desc)
                    mas_desc = re.sub(u'\u2014', '-', mas_desc)
                    mas_desc = re.sub(u'\u2019', '', mas_desc)
                    print(',', "'" + mas_desc + "'", end="")  # mas_desc

                    dflt_tier = mysheet.cell_value(row_index, 5).strip()
                    print(',', dflt_tier[-1:], end="")  # tier
                    if usage == 'DEFAULT_DISCOUNT':
                        print(', null, null, null', end="")
                    else:
                        if mysheet.cell_type(row_index, 6) \
                            == xlrd.XL_CELL_NUMBER :
                            print(',', mysheet.cell_value(row_index, 6), end="")  # percent
                        else:
                            print(', null', end="")
                        if mysheet.cell_type(row_index, 7) \
                            == xlrd.XL_CELL_NUMBER :
                            print(',', mysheet.cell_value(row_index, 7), end="")  # per item
                        else:
                            print(', null', end="")
                        if mysheet.cell_type(row_index, 8) \
                            == xlrd.XL_CELL_NUMBER \
                            and mysheet.cell_value(row_index, 8) != 0:
                            print(', ', mysheet.cell_value(row_index, 8), end="")  # max
                        else:
                            print(', null', end="")

                    # print(',', mysheet.cell_value(row_index, 12) , end="")

                    print(',', "\n        '"
                          + str(mysheet.cell_value(row_index, 0)).strip()
                          + "'", end="")  # ird / psl / fpi

                    # re.sub('[.!,;]', '', a)

                    prog_desc = re.sub('[\\%\\&]', '/', mysheet.cell_value(row_index, 1)[:70].strip())
                    prog_desc = re.sub(u'\u2019', '', prog_desc)
                    prog_desc = re.sub(u'\u2013', '-', prog_desc)
                    prog_desc = re.sub(u'\u2014', '-', prog_desc)
                    print(',', "'" + prog_desc + "'", end="")  # program desc

                    # print ',', "'" + mysheet.cell_value(row_index, 2)[:35].strip() + "'", # assoc card types

                    print(',', card_scheme, end="")  # card scheme
                    card_abbr_pos = dflt_tier.find('_')
                    card_abbr = dflt_tier[:card_abbr_pos]
                    tier = dflt_tier[-1:]
                    print(',', "'" + card_abbr + '_JP_BASE_TIER' + tier
                          + "'", end="")  # template mas_code
                    print(',', "'" + usage + "'", end="")  # usage
                    try:
                        region = mysheet.cell_value(row_index, 14)
                    except IndexError:
                        region = None
                    if region != None and region != '':
                        print(',', "'" + region + "'", end="")  # region
                    else:
                        print(', null', end="")
                    print(", \n        trunc(sysdate));")
    print(' ')

# end of build_inserts(filename)

if __name__ == '__main__':
    print('-- Number of arguments:', len(sys.argv), 'arguments.')
    print('-- Argument List:', str(sys.argv))
    print('-- Working directory:', str(os.getcwd()))

    # os.chdir('c:\\jpll-02\\Documents_upper\\Clearing\\Release\\2019_10\\')
    print('-- Working directory:', str(os.getcwd()))
    if len(sys.argv) >= 3:
        build_inserts(sys.argv[1], sys.argv[2])
    elif len(sys.argv) >= 2:
        build_inserts(sys.argv[1])
