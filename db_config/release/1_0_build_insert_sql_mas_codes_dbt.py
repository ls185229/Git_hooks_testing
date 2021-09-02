#!/usr/bin/env python2
"""
    Build insert statements for the pin debit
    $Id: $

"""

import unicodedata
import re
import sys
import __future__

from xlrd import open_workbook
import xlrd

MAS_CODE_COL = 38
MAS_DESC_COL = 39
MAS_PROG_COL = 14
DEFAULT_TIER = 37

def is_number(val):
    """Determines if a value is a number"""
    try:
        float(val)
        return True
    except ValueError:
        return False

def format_value(val):
    """Remove unicode characters and round numbers."""
    # print
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
        TEMPLATE_MAS_CODE, NOTES, PER_TRANS_MIN, USAGE, REGION)
    values
        ('0105UBCSUPMKT', null, null, null, null, null, null, null,
        null, null, null, null, null, null, null, null, 'INTERCHANGE', null);

    """

    front_insert = """Insert into FLMGR_ICHG_RATES_TEMPLATE (
        MAS_CODE, MAS_DESC, TIER, RATE_PERCENT, RATE_PER_ITEM, PER_TRANS_MAX,
        FPI_IRD, PROGRAM_DESC, CARD_SCHEME, TEMPLATE_MAS_CODE, USAGE, REGION)
    values (
        """

    print( "rem gathering mas_codes from spreadsheet")
    print('')
    print( "delete FLMGR_ICHG_RATES_TEMPLATE;")
    print('')

    fee_types = {                                                 \
        "NETWORK"              : (15, 16, 17, "010004720010"), \
        "PRE_AUTH"             : (18, 19, 20, "010004720030"), \
        "SWITCH_COMPLETION"    : (21, 22, 23, "010004720001"), \
        "ACTIVITY_ADMIN"       : (24, 25, 26, "010004720040"), \
        "INFRASTRUCT_SECURITY" : (27, 28, 29, "010004720050"), \
        "VISA_SWITCH"          : ("", 35, "", "010004720060"), \
        "DEFAULT_DISCOUNT"     : ("", "", "", "")}


    book = open_workbook(filename)
    for mysheet in book.sheets():

        print('')
        print("rem " + mysheet.name)
        if   mysheet.name == "All debit fees":
            card_scheme = "'02'"
        elif mysheet.name == "Debit":
            card_scheme = "'02'"
        elif mysheet.name == "Discover":
            card_scheme = "'08'"
        elif mysheet.name == "Visa":
            card_scheme = "'04'"
        elif mysheet.name == "MasterCard":
            card_scheme = "'05'"
        elif mysheet.name == "AMEX":
            card_scheme = "'03'"
        else:
            card_scheme = '  '

        rows_found = 0
        rows_skipped = 0
        print('')
        #print(front_insert)
        #print(mods)
        print('')
        mas_codes = dict()
    #    for row_index in range(1, mysheet.nrows):
        for row_index in range(1, mysheet.nrows):

            # pylint: disable=line-too-long

            # curr_mas_code = mysheet.cell_value(row_index, MAS_CODE_COL).strip()
            # print(mas_codes, curr_mas_code, curr_mas_code in mas_codes)
            # print("column 8 type:" , mysheet.cell_type(row_index, 8) , " value:", mysheet.cell_value(row_index, 8))
            # if ( mysheet.cell_value(row_index, MAS_CODE_COL).strip() == "0104USHNWFUELCAP" ):
            #     print(mysheet.cell_value(row_index, MAS_CODE_COL), mysheet.cell_value(row_index, 8),)
            #     print(mysheet.cell_type(row_index, 8),)
            #     print(xlrd.XL_CELL_EMPTY, xlrd.XL_CELL_BLANK, xlrd.XL_CELL_TEXT, xlrd.XL_CELL_NUMBER)
            #     print((mysheet.cell_type(row_index, 8) !=  xlrd.XL_CELL_EMPTY) and \
            #                 (mysheet.cell_type(row_index, 8) !=  xlrd.XL_CELL_BLANK) and \
            #                 (mysheet.cell_type(row_index, 8) ==  xlrd.XL_CELL_TEXT and \
            #                 mysheet.cell_value(row_index, 8).strip() !=  u'') and \
            #                 (mysheet.cell_type(row_index, 8) ==  xlrd.XL_CELL_NUMBER and \
            #                 mysheet.cell_value(row_index, 8) !=  0))
            #     print(mysheet.cell_type(row_index, 8) !=  xlrd.XL_CELL_EMPTY)
            #     print(mysheet.cell_type(row_index, 8) !=  xlrd.XL_CELL_BLANK)
            #     print(mysheet.cell_type(row_index, 8) ==  xlrd.XL_CELL_TEXT and \
            #            mysheet.cell_value(row_index, 8).strip() !=  u'')
            #     print(mysheet.cell_type(row_index, 8) ==  xlrd.XL_CELL_NUMBER and \
            #            mysheet.cell_value(row_index, 8) !=  0)

            # pylint: disable=bad-whitespace
            if  (mysheet.cell_type(row_index, MAS_CODE_COL)  !=  xlrd.XL_CELL_EMPTY) and \
                (mysheet.cell_type(row_index, MAS_CODE_COL)  !=  xlrd.XL_CELL_BLANK) and \
                (mysheet.cell_value(row_index, MAS_CODE_COL) !=  "(not supported)")  and \
                (mysheet.cell_value(row_index, MAS_DESC_COL) !=  "(not supported)")  and \
                (                                                               \
                    (                                                           \
                    mods is None                                            and \
                    mysheet.cell_type(row_index, 40) != xlrd.XL_CELL_EMPTY      \
                    )                                                       or  \
                    mods == 'ALL'                                           or  \
                    mods == mysheet.cell_value(row_index, 40)                   \
                ):

                # pylint: enable=bad-whitespace

                curr_mas_code = mysheet.cell_value(row_index, MAS_CODE_COL).strip()

                rows_found = rows_found + 1
                mas_codes[curr_mas_code] = rows_found
                # if rows_found > 3:
                #     continue
                for usage, fee_columns in fee_types.iteritems():
                    print front_insert,
                    print  "'" + mysheet.cell_value(row_index, MAS_CODE_COL).strip()  + "'",  # mas_code

                    # pylint disable=anomalous-backslash-in-string

                    mas_desc = re.sub(r'[\%\&]', '/', mysheet.cell_value(row_index, MAS_DESC_COL)[:30].strip())

                    prog_desc = re.sub(u'\u2013', '-', mas_desc[:70].strip())

                    print ',', "'" + mas_desc + "'",  # mas_desc

                    dflt_tier = int(mysheet.cell_value(row_index, DEFAULT_TIER))
                    print ',', dflt_tier,  # tier
                    pct_col, per_item, max_col, fee_tid = fee_columns
                    if pct_col != "":
                        print ',', mysheet.cell_value(row_index, pct_col),  # percent
                    else:
                        print ", null",
                    if per_item != "":
                        print ',', mysheet.cell_value(row_index, per_item),  # per item
                    else:
                        print ", null",
                    if max_col != "":
                        if  mysheet.cell_type(row_index, max_col) == xlrd.XL_CELL_NUMBER and \
                            mysheet.cell_value(row_index, max_col) != 0:
                            print ', ', (mysheet.cell_value(row_index, max_col)),  # max
                        else:
                            print ", null",
                    else:
                        print ", null",
                    if fee_tid != "":
                        print ',', "'" + fee_tid + "'",  # program (tid)
                    else:
                        print ", null",

                    # print(',', mysheet.cell_value(row_index, 12) ,
                    # print(',', "\n    '" + mysheet.cell_value(row_index, 0).strip()  + "'" , # ird / psl / fpi

                    #re.sub('[.!,;]', '', a)
                    prog_desc = re.sub('[\%\&]', '/', mysheet.cell_value(row_index, MAS_PROG_COL)[:70].strip())
                    prog_desc = re.sub(u'\u2013', '-', prog_desc[:70].strip())
                    print ',', "'" + prog_desc + "'",  # program desc

                    # print(',', "'" + mysheet.cell_value(row_index, 2)[:35].strip() + "'", # assoc card types
                    print ',', card_scheme,  # card scheme
                    # card_abbr_pos = dflt_tier.find("_")
                    print ',', "'DBT_JP_BASE_TIER" + str(dflt_tier) + "'",  # template mas_code
                    print ",", "'" + usage + "'",   # usage
                    region = mysheet.cell_value(row_index, 41)
                    if region != None and region != "" and \
                        mysheet.cell_type(row_index, 41) == xlrd.XL_CELL_TEXT:
                        print ",", "'" + region + "'", # region
                    else:
                        print ", null",
                    print ");"

# end of build_inserts(filename)

# main routine

#build_inserts('US_Interchange_fees_Spring_2014.xls')
#build_inserts('US_Interchange_Fees_April_2014_04-11-2014.xls')
#build_inserts('U_S_Intrchg_Fees_2014_10_14.xls')

#build_inserts('../US_AMEX_Wholesale-11-25-2014.xls')

if __name__ == "__main__":
    print '-- Number of arguments:', len(sys.argv), 'arguments.'
    print '-- Argument List:', str(sys.argv)
    # print('Number of arguments:', len(sys.argv), 'arguments.')
    # print('Argument List:', str(sys.argv))
    # build_inserts('US_Interchange_Fees_for_April_2015.xls')
    if len(sys.argv) >= 3:
        build_inserts(sys.argv[1], sys.argv[2])
    elif len(sys.argv) >= 2:
        build_inserts(sys.argv[1])
