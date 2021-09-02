#!/usr/bin/env python3

# Add pylint directives to suppress warnings you don't want it to report
# as warnings. Note they need to have the hash sign as shown below.
# pylint: disable = unbalanced-tuple-unpacking
# pylint: disable = invalid-name
# pylint: disable = line-too-long
# pylint: disable = protected-access
# pylint: disable = bare-except
# pylint: disable = broad-except
# pylint: disable = too-many-locals
# pylint: disable = too-many-instance-attributes
# pylint: disable = too-many-arguments
# pylint: disable = pointless-string-statement
# pylint: disable = too-many-lines

"""
File Name:  GenerateDiscBINLoadFile.py

Description: This script parses the raw IIN file from Discover and generates the SQL script to update the Discover BINs
             in Clearing databse.
             BIN and BIN_SPECIFIC_LINK tables are updated for Discover BINs


Arguments:  -i  - input file


Output:     A SQL file with insert statements to load the Discover BINs into the database is created.
            A file with the original IIN records are parsed and tab delimited is created.


Return:   0 = Success
          !0 = Exit with errors
"""

import argparse
# import cx_Oracle
# import configparser
import datetime
# from datetime import timedelta
# import os
import sys
import traceback
LIB_PATH = "/clearing/filemgr/MASCLRLIB"
sys.path.append(LIB_PATH)
from database_class import DbClass

logFileName = "LOG/GenerateDiscBINLoadFile.log"
logFile = open(logFileName, "a+")
countriesDict = {'000': {'alpha2Code': '--', 'alpha3Code': '---', 'currencyCode': '840'}}
productCodesFundingSrcMap = {'001': 'C', '002': 'C', '003': 'D', '004': 'D', '005': 'P', '006': 'P', '007': 'C',
                             '008': 'C', '009': 'C', '010': 'C', '011': 'C', '012': 'P', '013': 'C', '014': 'C'}


def usage(scriptname):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        usage():
            prints the usage format of the script.

        Parameter:
            scriptname      - Name of the current script - argv[0]

        Returns:
            Returns nothing.
            Exits the program after printing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    print("Example Usage: " + scriptname + " -i JTPAYSO.ACTIVEIIN.J2021055.N14121252895260\n")
    print(
        "Download the latest IIN file from Discover to the location of the script and pass the file name as parameter to the script.")
    print("Exiting!!!\n\n")
    sys.exit(1)


def documentFailure(msg, e):
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        documentFailure():
            Parses the Error message and writes it to the log file.

        Parameter:
            msg - String containing a short description of the error
            e   - Exception Info Object - sys.exc_info()

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """
    # global logFile
    excMsg = msg
    excType, excValue = e[:2]
    excMsg = excMsg + "\nError Type: \t" + str(excType)
    excMsg = excMsg + "\nError Value: \t" + str(excValue)
    print(excMsg)
    logFile.write("\n\nERROR OCCURED:\n##### ########" + excMsg)
    logFile.write("\n\n" + traceback.format_exc() + "\n\n")


def cleanUp():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        cleanUp():
            Cleans up the resources like open file handles, database connections, etc.

        Parameter:
            N/A

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """
    # global logFile
    logFile.write("\n Error Occurred. Exiting the program " + sys.argv[0] + "\n")
    logFile.write(
        "#####################################################################################################")
    logFile.flush()
    # dbObject.CloseCursor(selectCursor)
    # dbObject.CloseCursor(updateCursor)
    # dbObject.Disconnect()
    logFile.close()


def parseArguments():
    """
    Name : parseArguments
    Arguments: none
    Description : Parses the command line arguments
    Returns: arg_parser args
    """
    try:
        arg_parser = argparse.ArgumentParser(description='Generate Discover BIN Load SQL Script')
        arg_parser.add_argument('-i', '-I', '--inputfile', type=str, dest='inputFile', required=True,
                                help='Input File Name')
        args = arg_parser.parse_args()
    except argparse.ArgumentError as err:
        errMsg = 'Error: During parsing command line arguments {}'
        print(errMsg.format(err))
        usage(sys.argv[0])
    else:
        return args


class IIN_Record:
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Class Name: IIN_Record
            Each record in the input file is parsed and loaded into an object of this class type.

        Class Variables:
            -

        Instance Variables:
            rcd_ind, rcd_seq_nbr, iin_length, iin_nbr, min_pan_length, max_pan_length,
            product_id, atm_ind,network_standin_proc_ind, issuing_network, country_ind,
            country_code, alp_ind, reg2_ind, dpwr_ind, rtp_ind, tok_range_ind, reserved

        Methods:
            toString() - Returns a String representation of the object
            getBinSpecificLinkQuery() - generates an insert query for BIN_SPECIFIC_LINK table
            getBinQuery() - generates an insert query for BIN table

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """

    def __init__(self, rcd_ind, rcd_seq_nbr, iin_length, iin_nbr, min_pan_length, max_pan_length, product_id, atm_ind,
                 network_standin_proc_ind, issuing_network, country_ind, country_code, alp_ind, reg2_ind, dpwr_ind,
                 rtp_ind, tok_range_ind, reserved):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: __init__
                Constructs the object using the parameters passed.

            Parameters:
                rcd_ind, rcd_seq_nbr, iin_length, iin_nbr, min_pan_length, max_pan_length,
                product_id, atm_ind,network_standin_proc_ind, issuing_network, country_ind,
                country_code, alp_ind, reg2_ind, dpwr_ind, rtp_ind, tok_range_ind, reserved

            Returns:
                An object of type IIN_Record
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        self.rcd_ind = rcd_ind
        self.rcd_seq_nbr = rcd_seq_nbr
        self.iin_length = iin_length
        self.iin_nbr = iin_nbr
        self.min_pan_length = min_pan_length
        self.max_pan_length = max_pan_length
        self.product_id = product_id
        self.atm_ind = atm_ind
        self.network_standin_proc_ind = network_standin_proc_ind
        self.issuing_network = issuing_network
        self.country_ind = country_ind
        self.country_code = country_code
        self.alp_ind = alp_ind
        self.reg2_ind = reg2_ind
        self.dpwr_ind = dpwr_ind
        self.rtp_ind = rtp_ind
        self.tok_range_ind = tok_range_ind
        self.reserved = reserved

    def toString(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: toString
                Prints the object's instance variables in string format

            Parameters:
                -

            Returns:
                Nothing
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        print(self.rcd_ind, self.rcd_seq_nbr, self.iin_length, self.iin_nbr, self.min_pan_length, self.max_pan_length,
              self.product_id, self.atm_ind, self.network_standin_proc_ind, self.issuing_network, self.country_ind,
              self.country_code, self.alp_ind, self.reg2_ind, self.dpwr_ind, self.rtp_ind, self.tok_range_ind)

    def getBinSpecificLinkQuery(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: getBinSpecificLinkQuery
                Generates an insert query for BIN_SPECIFIC_LINK table.

            Parameters:
                -

            Returns:
                SQL query string for BIN_SPECIFIC_LINK table.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        entity_id_alias = self.iin_nbr[:8]
        query = "INSERT INTO BIN_SPECIFIC_LINK ( ENTITY_ID_ALIAS, CARD_SCHEME ) " \
                "SELECT '" + entity_id_alias + "', '08' FROM DUAL WHERE NOT EXISTS " \
                                               "(SELECT ENTITY_ID_ALIAS FROM BIN_SPECIFIC_LINK WHERE ENTITY_ID_ALIAS = '" + entity_id_alias + "' AND CARD_SCHEME = '08');"
        return query

    def getBinQuery(self):
        """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Method Name: getBinQuery
                Generates an insert query for BIN table.

            Parameters:
                -

            Returns:
                SQL query string for BIN table.
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         """
        global countriesDict
        global productCodesFundingSrcMap
        bin_range_low = "'" + self.iin_nbr[:int(self.iin_length)] + "0" * (
                int(self.min_pan_length) - int(self.iin_length)) + "'"
        bin_range_high = "'" + self.iin_nbr[:int(self.iin_length)] + "9" * (
                int(self.min_pan_length) - int(self.iin_length)) + "'"
        bin_usage = "'X'"
        card_scheme = "'08'"
        bin = "'" + self.iin_nbr[:8] + "'"
        bin_type = "'I'"
        bin_length = "'8'"
        cntry_code_alpha2 = "'" + countriesDict[self.country_code]['alpha2Code'] + "'"
        cntry_code_alpha3 = "'" + countriesDict[self.country_code]['alpha3Code'] + "'"
        cntry_code_num = "'" + self.country_code + "'"
        if int(self.country_ind) == 0:
            region = "'1'"
        else:
            region = "'0'"
        domain = "'3'"
        pan_length = "'" + self.min_pan_length + "'"
        processing_bin = "'" + self.iin_nbr[:6] + "'"
        product_id = "'" + self.product_id + "'"
        entity_id_alias = "'" + self.iin_nbr[:8] + "'"
        if int(self.alp_ind) == 1:
            acct_lvl_part_ind = "'Y'"
            acct_lvl_part_dt = "to_date('20181012000000','YYYYMMDDHH24MISS')"
        else:
            acct_lvl_part_ind = "'N'"
            acct_lvl_part_dt = "null"
        regulated_ind = "'" + self.reg2_ind + "'"
        acct_fund_src = "'" + productCodesFundingSrcMap[self.product_id] + "'"
        dpwr_enabled_ind = self.dpwr_ind
        token_range_ind = "'" + self.tok_range_ind + "'"
        curr_code = "'" + countriesDict[self.country_code]['currencyCode'] + "'"
        atm_ind = "'" + self.atm_ind + "'"

        query = "INSERT INTO BIN(BIN_RANGE_LOW, BIN_RANGE_HIGH, BIN_USAGE, CARD_SCHEME, BIN, BIN_TYPE, BIN_LENGTH, CNTRY_CODE_ALPHA2, " \
                "CNTRY_CODE_ALPHA3, CNTRY_CODE_NUM, REGION, DOMAIN, PAN_LENGTH, PROCESSING_BIN, PRODUCT_ID, ENTITY_ID_ALIAS, " \
                "ACCT_LVL_PART_IND, ACCT_LVL_PART_DT, REGULATED_IND, ACCT_FUND_SRC, DPWR_ENABLED_IND, TOKEN_RANGE_IND, CURR_CODE, ATM_IND)" \
                "values(" + bin_range_low + ", " + bin_range_high + ", " + bin_usage + ", " + card_scheme + ", " + bin + "," \
                + bin_type + ", " + bin_length + ", " + cntry_code_alpha2 + "," + cntry_code_alpha3 + "," + cntry_code_num + "," \
                + region + "," + domain + "," + pan_length + "," + processing_bin + "," + product_id + "," + entity_id_alias + "," \
                + acct_lvl_part_ind + "," + acct_lvl_part_dt + "," + regulated_ind + "," + acct_fund_src + "," + dpwr_enabled_ind \
                + "," + token_range_ind + "," + curr_code + "," + atm_ind + ");"
        return query


def main():
    """
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        main():
            This function holds all the program logic.
            Reads the raw Discover IIN line by line generates insert statements for BIN_SPECIFIC_LINK and BIN tables
            Writes the insert queries to the output file(.sql).
            Writes the parsed, tab delimited IIN records to a raw text file.

        Parameter:
            N/A

        Returns:
            Returns nothing.
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     """

    # global logFile
    # global countriesDict
    clArgs = parseArguments()

    now = datetime.datetime.today().strftime("%Y%m%d%H%M%S")
    inputFileName = clArgs.inputFile
    outputIINFileName = inputFileName + "_SPLIT"
    outputFileName = "Discover_BIN_Load_" + now + ".sql"

    print("Input File Name: " + inputFileName)
    print("Split IIN File Name: " + outputIINFileName)
    print("SQL File Name: " + outputFileName)

    logFile.write("\n\n#################################################################################\n")
    logFile.write("\nBeginning to process DISCOVER IIN file.")
    logFile.write("\nScript Name:" + sys.argv[0])
    logFile.write("\nDate: " + datetime.datetime.today().strftime("%b-%d-%Y"))
    logFile.write("\nTime: " + datetime.datetime.today().strftime("%X"))
    logFile.write("\n")
    logFile.write("\nInput File Name: " + inputFileName)
    logFile.write("\nSplit IIN File Name: " + outputIINFileName)
    logFile.write("\nSQL File Name: " + outputFileName)

    inputFile = open(inputFileName)
    outputIINFile = open(outputIINFileName, "w")
    outputIINFile.write(
        "BIN_RECORD_IND\tRECORD_SEQ_NUM\tIIN_PREFIX_LENGTH\tIIN\tMIN_PAN_LENGTH\tMAX_PAN_LENGTH\tPRODUCT_ID\t"
        "ATM_IND\tNETWORK_STANDIN_PROC_IND\tISSUING_NETWORK\tCOUNTRY_IND\tCOUNTRY_CODE\tALP_IND\tREGULATION_II_IND\t"
        "PAY_WITH_REWARDS_IND\tREAL_TIME_TRANSACTION_PRICING_IND\tTOKEN_RANGE_IND\tRESERVED\n")
    outputSQLFile = open(outputFileName, "w")

    headerRec = inputFile.readline()
    if headerRec.startswith("HDRDiscover NetworkDN Elect IIN Range File"):
        print("\nValid File")
    else:
        print("\nNot a valid Discover BIN file.\nExiting!!")
        sys.exit(2)

    try:
        dbObject = DbClass(ENV_HOSTNM='IST_HOST', ENV_USERID='IST_DB_USERNAME', PORTNO='1521', ENV_PASSWD='IST_DB_PASSWORD', ENV_SERVNM='IST_SERVERNAME')
        # dbObject = DbClass(HOSTNM='authqa.jetpay.com', PORTNO='1521', USERID='*****', PASSWD='*****', SERVNM='authqa.jetpay.com')
        ''' Leaving the above hardcoded line to use when developing /testing the code from local machine'''

        dbObject.Connect()
        countryCursor = dbObject.OpenCursor()

        countryListSQL = "SELECT CNTRY_CODE, CNTRY_CODE_ALPHA2, CNTRY_CODE_ALPHA3, CURR_CODE FROM COUNTRY"
        print("Fetching Countries List")
        logFile.write("\n\nFetching Countries List.")
        logFile.write("\nQuery:" + countryListSQL + "\n")
        dbObject.ExecuteQuery(countryCursor, countryListSQL)
        resultSet = dbObject.FetchResults(countryCursor)
        # global countriesDict
        for result in resultSet:
            # print("Result Row:\t" + str(result))
            countryCode = str(result[0])
            alpha2Code = result[1]
            alpha3Code = result[2]
            currencyCode = str(result[3])
            countriesDict[countryCode] = {'alpha2Code': alpha2Code, 'alpha3Code': alpha3Code,
                                          'currencyCode': currencyCode}

    except Exception:
        failMsg = "Exception occured when performing database operation"
        exc = sys.exc_info()
        documentFailure(failMsg, exc)
        cleanUp()
        sys.exit(0)

    logFile.write("\n\nCountries Dictionary: " + str(countriesDict))
    binQueryString = ""
    bslQueryString = ""

    print("Parsing the IIN file and generating queries")
    for line in inputFile:
        line = line.rstrip()
        if line.startswith("RCD"):
            rcdIndicator = str(line[0:3])
            rcdSeqNbr = str(line[3:9])
            iinLength = str(line[9:11])
            iinNbr = str(line[11:30])
            minPanLength = str(line[30:32])
            maxPanLength = str(line[32:34])
            productID = str(line[34:37])
            atmInd = str(line[37:38])
            ntwrkStndInProcInd = str(line[38:39])
            issuingNetwork = str(line[39:41])
            countryInd = str(line[41:42])
            countryCode = str(line[42:45])
            alpInd = str(line[45:46])
            reg2Ind = str(line[46:47])
            dpwrInd = str(line[47:48])
            rtpInd = str(line[48:49])
            tokRangeInd = str(line[49:50])
            reserved = str(line[50:])

            iinRecord = IIN_Record(rcdIndicator, rcdSeqNbr, iinLength, iinNbr, minPanLength, maxPanLength, productID,
                                   atmInd, ntwrkStndInProcInd, issuingNetwork, countryInd, countryCode, alpInd, reg2Ind,
                                   dpwrInd, rtpInd, tokRangeInd, reserved)

            binQueryString = binQueryString + iinRecord.getBinQuery() + "\n"
            bslQueryString = bslQueryString + iinRecord.getBinSpecificLinkQuery() + "\n"

            # print(rcdIndicator, rcdSeqNbr, iinLength, iinNbr, minPanLength, maxPanLength, productID, atmInd,
            #       ntwrkStndInProcInd, issuingNetwork, countryInd, countryCode, alpInd, reg2Ind, dpwrInd, rtpInd,
            #       tokRangeInd, reserved)

            # logFile.write(
            #     rcdIndicator + "\t" + rcdSeqNbr + "\t" + iinLength + "\t" + iinNbr + "\t" + minPanLength + "\t" +
            #     maxPanLength + "\t" + productID + "\t" + atmInd + "\t" + ntwrkStndInProcInd + "\t" +
            #     issuingNetwork + "\t" + countryInd + "\t" + countryCode + "\t" + alpInd + "\t" +
            #     reg2Ind + "\t" + dpwrInd + "\t" + rtpInd + "\t" + tokRangeInd + "\t" + reserved + "\n")

            outputIINFile.write(
                rcdIndicator + "\t" + rcdSeqNbr + "\t" + iinLength + "\t" + iinNbr + "\t" + minPanLength + "\t" +
                maxPanLength + "\t" + productID + "\t" + atmInd + "\t" + ntwrkStndInProcInd + "\t" +
                issuingNetwork + "\t" + countryInd + "\t" + countryCode + "\t" + alpInd + "\t" +
                reg2Ind + "\t" + dpwrInd + "\t" + rtpInd + "\t" + tokRangeInd + "\t" + reserved + "\n")

    outputSQLFile.write("--Discover_BIN_Load.sql\n")
    outputSQLFile.write("--Date: " + datetime.datetime.today().strftime("%b-%d-%Y") + "\n")
    outputSQLFile.write("--Time: " + datetime.datetime.today().strftime("%X") + "\n")
    outputSQLFile.write("--Source IIN File: " + inputFileName + "\n")

    outputSQLFile.write("DROP TABLE DISCOVER_BIN_BKUP;" + "\n")
    outputSQLFile.write("CREATE TABLE DISCOVER_BIN_BKUP AS SELECT * FROM BIN WHERE CARD_SCHEME = '08';" + "\n")
    outputSQLFile.write("DELETE FROM BIN WHERE CARD_SCHEME = '08';" + "\n")
    outputSQLFile.write("commit;" + "\n")
    outputSQLFile.write("\n\n")
    outputSQLFile.write(bslQueryString)
    outputSQLFile.write("\n\n")
    outputSQLFile.write(binQueryString + "\n")
    outputSQLFile.write("commit;" + "\n")

    logFile.write("\n\nSuccessfully Completed!!")
    print("Successfully Completed!!")
    logFile.write("\n#################################################################################")
    inputFile.close()
    outputSQLFile.close()
    outputIINFile.close()


if __name__ == "__main__":
    main()
