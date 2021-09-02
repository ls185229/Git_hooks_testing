#!/usr/bin/env python3
'''
NPP-4161
File Name: Interchange_rate_parser.py
Description: NPP-4161, Interchange Rate Sheet Parser.
'''

import argparse
import logging
import os
import sys
import numpy as np
import pandas as pd
import sqlalchemy as sa
from sqlalchemy import Date, Float, String


class InterchangeRate():
    """
    Name : Interchange_rate
    Description: Parses, formats and injects data from Interchange rate sheets to database.
    """
    global DATE
    Date_time = pd.to_datetime('now')
    DATE = Date_time.strftime("%d-%b-%y")
    logger = None

    def __init__(self, mods=None):
        self.args = mods
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.ERROR)

    def set_logger_level(self, verbosity_level):
        """
        Name: set_logger_level
        Arguments: verbosity level
        Description: Set the logger class object based on the verbosity level
        Returns: None
        """
        try:
            if verbosity_level == 1: # -v
                log_level = logging.WARNING
            elif verbosity_level == 2: # -vv
                log_level = logging.INFO
            elif verbosity_level == 3: # -vvv
                log_level = logging.DEBUG
            else:
                log_level = logging.ERROR

            self.logger.setLevel(log_level)
            self.logger.handlers[0].setLevel(log_level)
            print('Logger object level : ',self.logger.getEggectiveLevel())
        except Exception as err:
            print('Unable to create logger', str(err))
            return False
        else:
            return True

    def parse_arguments(self):
        """
        Name: parse_arguments
        Arguments: -i, -m, -v
        Description : Parses the command line arguments
        Returns: args
        """
        try:
            arg_parser = argparse.ArgumentParser(description= 'Select filename')
            arg_parser.add_argument("-i", "-input",
                                    dest="filename",
                                    type=argparse.FileType('r'),
                                    help="Specify filename",
                                    metavar="FILE",
                                    required=True
                    )
            arg_parser.add_argument("-m", "-mods",
                                    dest="mods",
                                    help="Select 'A' 'D' 'U' 'AD' 'AU' 'DU' 'ADU' or 'ALL'",
                                    nargs = '+',
                                    required=True
                                    )
            arg_parser.add_argument("-v", "-verbose",
                                    dest="verbose",
                                    help = "Verbose level repeat up to three times.",
                                    nargs = '+',
                                    required=True
                                    )

            args = arg_parser.parse_args()

        except argparse.ArgumentError:
            err_mesg = 'parse_arguments invalid input'
            self.logger.error(err_mesg)
            sys.exit()
        return args

    def get_filepath(self, args):
        """
        Name : get_filepath
        Arguments: args
        Description : Extracts filename from user input and assigns it
        Returns: file
        """
        filepath = args.filename.name
        try:
            file = pd.ExcelFile(filepath)
        except KeyError:
            self.logger.error("Invalid filepath")

        return file


    def parser(self, file):
        """
        Name : parser
        Arguments: file
        Description : Pulls each sheet as a dataframe, makes modifications, concat all
        Returns: sheets
        """
        visa_sheet = None
        mastercard_sheet = None
        discover_sheet = None
        amex_sheet = None
        for sheet in file.sheet_names:
            if sheet.upper() == 'VISA':
                print(sheet.upper())
                visa_sheet = pd.read_excel(file, sheet_name=sheet,
                                           usecols="A, B, D, E, F, G, H, I, J, N, O, P")
                visa_sheet.rename(columns={'FPI': 'FPI_IRD',
                                           'VISA FEE PROGRAM': 'PROGRAM_DESC',
                                           'DEFAULT TIER': 'TEMPLATE_MAS_CODE'},
                                            inplace=True
                                            )
                visa_sheet.insert(loc=5, column='TIER', value='')
                visa_sheet['TIER'] = visa_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                visa_sheet['TEMPLATE_MAS_CODE'] = 'VISA_JP_BASE_TIER' \
                + visa_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                visa_sheet.insert(loc=2, column='CARD_SCHEME', value='04')
            elif sheet.upper() == 'MASTERCARD':
                print(sheet.upper())
                mastercard_sheet = pd.read_excel(file, sheet_name=sheet,
                                                 usecols="A, B, D, E, F, G, H, I, J, N, O, P")
                mastercard_sheet.rename(
                    columns={'IRD': 'FPI_IRD',
                             'MASTERCARD FEE PROGRAM': 'PROGRAM_DESC',
                             'DEFAULT TIER': 'TEMPLATE_MAS_CODE'},
                              inplace=True
                )
                mastercard_sheet.insert(loc=2, column='TIER', value='')
                mastercard_sheet['TIER'] = mastercard_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                mastercard_sheet['TEMPLATE_MAS_CODE'] = "MC_JP_BASE_TIER" \
                + mastercard_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                mastercard_sheet.insert(loc=2, column='CARD_SCHEME', value='05')
            elif sheet.upper() == 'DISCOVER':
                print(sheet.upper())
                discover_sheet = pd.read_excel(file, sheet_name=sheet,
                                           usecols="A, B, D, E, F, G, H, I, J, N, O, P")
                discover_sheet.rename(
                    columns={'PSL': 'FPI_IRD',
                             'DISCOVER FEE PROGRAM': 'PROGRAM_DESC',
                             'DEFAULT TIER': 'TEMPLATE_MAS_CODE'},
                              inplace=True
                )
                discover_sheet.insert(loc=5, column='TIER', value='')
                discover_sheet['TIER'] = discover_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                discover_sheet['TEMPLATE_MAS_CODE'] = "DIS_JP_BASE_TIER" \
                + discover_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                discover_sheet.insert(loc=2, column='CARD_SCHEME', value='08')
            elif sheet.upper() == 'AMEX':
                print(sheet.upper())
                amex_sheet = pd.read_excel(file, sheet_name=sheet,
                                           usecols="A, B, D, E, F, G, H, I, J, M, N, P")
                amex_sheet.rename(
                    columns={'FPI': 'FPI_IRD',
                             'AMEX FEE PROGRAM': 'PROGRAM_DESC',
                             'DEFAULT TIER': 'TEMPLATE_MAS_CODE',
                             'JetPay Only (add/delete/update)': 'JetPay Only\n(adu)',
                             'Region': 'REGION'},
                              inplace=True
                )
                amex_sheet.insert(loc=5, column='TIER', value='')
                amex_sheet['TIER'] = amex_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                amex_sheet['TEMPLATE_MAS_CODE'] = "AMEX_JP_BASE_TIER" \
                + amex_sheet['TEMPLATE_MAS_CODE'].astype(str).str[-1]
                amex_sheet.insert(loc=2, column='CARD_SCHEME', value='03')
            combined = [visa_sheet, mastercard_sheet, discover_sheet, amex_sheet]
            sheets = pd.concat(combined)
        return sheets

    def format_table(self, sheets, args):
        """
            Name : format_table
            Arguments: sheets
            Description : Formats table in order to make compatible with database
            Returns: table
        """
        table = sheets
        print(table)
        table.rename(columns={'MAS CODE': 'MAS_CODE',
            'MAS DESCRIPTION': 'MAS_DESC',
            'RATE PERCENT': 'RATE_PERCENT',
            'RATE PER ITEM': 'RATE_PER_ITEM',
            'MAXIMUM INTERCHANGE FEE': 'PER_TRANS_MAX',
            'MINIMUM INTERCHANGE FEE': 'PER_TRANS_MIN',
            'RETURN_PCT': 'RETURN_PERCENT',
            'JetPay Only\n(adu)': 'MODS',
            'DEFAULT TIER': 'TEMPLATE_MAS_CODE'}, inplace=True)
        table = table.astype(str)
        table = table.replace('nan', np.nan)
        table['RATE_PERCENT'] = pd.to_numeric(table['RATE_PERCENT'], errors = 'coerce').ffill()
        table['PROGRAM_DESC'] = table['PROGRAM_DESC'].str.replace('(\u2013)', '-', regex=True)
        table.insert(loc=12, column='USAGE', value='INTERCHANGE')
        table.insert(loc=13, column='ASSOCIATION_UPDATED', value=DATE)
        table.dropna(subset=['MAS_CODE'], inplace=True)
        if  args.mods[0] == 'ALL':
            table = table[(table['MODS'] == 'A') |
                (table['MODS'] == 'D') |
                (table['MODS'] == 'U') |
                (table['MODS'] == 'ALL')]
        else:
            if args.mods[0] == 'A':
                table = table[(table['MODS'] == 'A')]
            elif args.mods[0] == 'D':
                table = table[(table['MODS'] == 'D')]
            elif args.mods[0] == 'U':
                table = table[(table['MODS'] == 'U')]
            elif args.mods[0] == 'AD':
                table = table[(table['MODS'] == 'A') |
                    (table['MODS'] == 'D')]
            elif args.mods[0] == 'AU':
                table = table[(table['MODS'] == 'A') |
                    (table['MODS'] == 'U')]
            elif args.mods[0] == 'DU':
                table = table[(table['MODS'] == 'D') |
                    (table['MODS'] == 'U')]
            elif args.mods[0] == 'ADU':
                table = table[(table['MODS'] == 'A') |
                    (table['MODS'] == 'D') |
                    (table['MODS'] == 'U')]
            else:
                print("format_table invalid filepath")
        table = table.drop(['MODS'], axis=1)
        print(table)
        return table


    def write_to_sql(self, table):
        """
            Name : write_to_sql
            Arguments: sheets
            Description : Pulls each sheet as a dataframe and makes modifications to each as needed
            Returns: nothing
        """
        upload = table
        connection = os.environ["IST_DB_CONNECTION_URI"]
        oracle_db = sa.create_engine(connection,echo=False)
        table_name = "flmgr_ichg_rates_template"
        con = oracle_db.connect()
        # print(upload)
        upload.to_sql(
            table_name,
            con,
            index=False,
            if_exists='replace',
            dtype={'FPI_IRD': String(20),
                   'PROGRAM_DESC': String(70),
                   'CARD_SCHEME': String(3),
                   'MAS_CODE': String(25),
                   'MAS_DESC': String(30),
                   'TEMPLATE_MAS_CODE': String(25),
                   'RATE_PERCENT': Float,
                   'RATE_PER_ITEM': Float,
                   'PER_TRANS_MAX': Float,
                   'PER_TRANS_MIN': Float,
                   'REGION': String(10),
                   'CR_DB_PP_IND': String(3),
                   'ASSOCIATION_UPDATED': Date,
                   'USAGE': String(20)
                   }
                    )

if __name__ == "__main__":
    ir_object = InterchangeRate()
    arg_list = ir_object.parse_arguments()
    file_path = ir_object.get_filepath(arg_list)
    parse = ir_object.parser(file_path)
    format = ir_object.format_table(parse, arg_list)
    database = ir_object.write_to_sql(format)