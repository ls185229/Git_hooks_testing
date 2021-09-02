#!/usr/local/bin python
import sys


"""
 FileName : GenerateAmexBINLoadFiles.py
 
 Description : Take AMEXBIN file as input and create BinSpecificLink Queries and BIN Queries 
 
 Arguments : -i   - input file
 
 
 Output :  A SQL File with insert statements to load the AMEX BINs into database is created . 
  

"""


"""
  Global List Variables 
"""
bins = []
product_IDs = []




def parseTextFile():
    """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        Args:
            pass AMEX Bins File as Input
        Returns:
            Lists containing AMEX Bins and Product_IDs

        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    """

    infile = sys.argv[1]   #Input Bin file
    print(infile)
    count = 0
    with open(infile,"r") as a_file:
        for line in a_file:
            if count != 0:
                strippedline = line.strip()
                bins.append(str(strippedline[0:6]))
                product_IDs.append(str(strippedline[-2:]))
                count = count + 1
            else:
                count = count + 1
                continue

    bins.pop()
    product_IDs.pop()

    #print(len(bins))
    #print(len(product_IDs))



def getBinSpecificLinkQuery():
    """
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        MethodName : getBinSpecificLinkQuery
            Generates an insert query for BIN_SPECIFIC_LINK Table.
        Args:
            self:

        Returns:
            SQL query string for BIN_SPECIFIC_LINK table .

        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    """


    file_obj = open('AMEX_BIN_FILES.sql' , 'w')

    file_obj.write("DELETE FROM BIN WHERE CARD_SCHEME = '08';")

    file_obj.write("\n\n")

    query_param1= "INSERT INTO BIN_SPECIFIC_LINK ( ENTITY_ID_ALIAS, CARD_SCHEME ) SELECT '"

    query_param2 = "'03' FROM DUAL WHERE NOT EXISTS (SELECT ENTITY_ID_ALIAS FROM BIN_SPECIFIC_LINK WHERE ENTITY_ID_ALIAS = '"

    query_param3 = "' AND CARD_SCHEME = '03');"



    for bin in bins:

        query = query_param1 + '{}'.format(bin) + "', " + query_param2 + '{}'.format(bin) + query_param3
        file_obj.write(query)
        file_obj.write("\n")


    file_obj.write("\n\n")

    file_obj.write("COMMIT;")

    file_obj.write("\n\n")

    file_obj.write("--###############################################################################################################")

    file_obj.write("\n\n")

    file_obj.close()




def getBinQuery():
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

    query_param1 = "Insert into BIN (BIN_RANGE_LOW,BIN_RANGE_HIGH,BIN,PROCESSING_BIN,ENTITY_ID_ALIAS,PRODUCT_ID,REGION,ACCT_FUND_SRC,BIN_USAGE,CARD_SCHEME,BIN_TYPE,BIN_LENGTH,CNTRY_CODE_ALPHA2,CNTRY_CODE_ALPHA3,CNTRY_CODE_NUM,DOMAIN,PAN_LENGTH,ACCT_LVL_PART_DT) values ('"

    query_param3 = "1','C','X','03','I',6,'AX','AXI','840','0','15',to_date('20171013000000','YYYYMMDDHH24MISS'));"

    length = len(bins)

    file_obj = open('AMEX_BIN_FILES.sql', 'a+')


    for bin in range(length):
        query_param2 = str(bins[bin]) + "000000000'" + "," + "'" + str(bins[bin]) + "999999999'," + "'" + str(bins[bin]) + "'," + "'" +str(bins[bin]) + "'," + "'" +str(bins[bin]) + "'," +"'"+ str(product_IDs[bin]) +"'," + "'"
        query = query_param1 + query_param2 + query_param3
        file_obj.write(query)
        file_obj.write("\n")


    file_obj.write("\n\n")

    file_obj.write("COMMIT;")

    file_obj.write("\n\n")

    file_obj.write("--###############################################################################################################")

    file_obj.write("\n\n")


    file_obj.close()



def updateProductIdsRegions():
    """

    Returns:
        Add Update queries for setting Region and ProductIds

    """
    file_obj = open('AMEX_BIN_FILES.sql', 'a+')

    file_obj.write("UPDATE BIN SET REGION = '2', ACCT_FUND_SRC = 'C' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'IB';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '2', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'IR';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '2', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'IS';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'RP';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'C' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'SV';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'C' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'VP';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '2', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'DB';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'UC';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'RC';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'SU';")
    file_obj.write("\n")
    file_obj.write("UPDATE BIN SET REGION = '1', ACCT_FUND_SRC = 'D' WHERE CARD_SCHEME = '03' AND PRODUCT_ID = 'SR';")
    file_obj.write("\n")

    file_obj.write("\n\n")

    file_obj.write("COMMIT;")

    file_obj.write("\n\n")

    file_obj.write("--###############################################################################################################")

    file_obj.close()

def main():
    """

    Description:
       Main fucntion calling each functions

    """
    parseTextFile()
    getBinSpecificLinkQuery()
    getBinQuery()
    updateProductIdsRegions()

if __name__ == '__main__':
    main()