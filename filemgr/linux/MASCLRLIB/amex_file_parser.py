#!/usr/bin/env python
'''
$Id: amex_file_parser.py 4698 2018-09-11 22:39:25Z bjones $
$Rev: 4698 $
File Name      :  amex_tilr_file.py

Description    :  This library parses AMEX TILR file

Running options:   None

Shell Arguments:   None
Input          :   AMEX TILR File
Output         :   If non compliance fee is present, list is created
                   with institution id , entity id and the amount to charge

Return         :   None

'''
import os
import configparser
import cx_Oracle
#config = None

class AmexTilrClass():

    #amount conversion list
    amt_dict = {
        'A':['1', 100], 'B':['2', 100], 'C':['3', 100], 'D':['4', 100], 'E':['5', 100],\
        'F':['6', 100], 'G':['7', 100], 'H':['8', 100], 'I':['9', 100], '{':['0', 100],\
        'J':['1', -100], 'K':['2', -100], 'L':['3', -100], 'M':['4', -100],\
        'N':['5', -100], 'O':['6', -100], 'P':['7', -100], 'Q':['8', -100],\
        'R':['9', -100], '}':['0', -100]
    }

    #record type mapping dictionary set
    rec_type_dict = {
        'DFHDR':'Data_File_Header_Record', 'DFTRL':'Data_File_Trailer_Record',\
        '100':'Summary_Record', '210':'SOC_Detail_Record',\
        '212':'SOC_Level_Pricing_Record', '311':'ROC_Detail_Record',\
        '313':'ROC_Level_Pricing_Record', '220':'Chargeback_Detail_Record',\
        '230':'Adjustment_Detail_Record', '240':'Other_Fees_Record',\
        '241':'Other_Fees_Record', '250':'Other_Fees_Record'
    }

    def __init__(self):
        self.fee_list = []

    def display_record(self, test_dict, data):
        '''
        Name        : display_record
        Arguments   : AMEX data structure and the value record
        Description : Display the field name and its value
        Returns     : Nothing
        '''
        #print(data)
        start_pos = 0
        for key, val in test_dict.items():
            end_pos = int(val)
            end_pos = start_pos + end_pos
            print(key, val, data[start_pos:end_pos])
            start_pos = end_pos

    def convert_amount(self, amt):
        '''
        Name        : convert_amount
        Arguments   : Amount
        Description : convert the amount using the amt_dict structure
        Returns     : Nothing
        '''
        amt = amt.strip('0')
    #amt = int(amt[:-1] + self.amt_dict[amt[-1]][0])/self.amt_dict[amt[-1]][1]
        amt = int(amt[:-1] + self.amt_dict[amt[-1]][0])
        #print(amt)
        return amt

    def parse_rec(self, test_dict, data):
        '''
        Name        : parse_rec
        Arguments   : Amex file record structure and the TILR file record
        Description : Parse Amex file using the amex file structure
        Returns     : Nothing
        '''
        start_pos = 0
        for key, val in test_dict.items():
            end_pos = int(val)
            end_pos = start_pos + end_pos
            if key == 'other_fee_amount':
                other_amt = data[start_pos:end_pos]
                amt = self.convert_amount(other_amt)
                #print('Amt:', amt)
            elif key == 'seller_id':
                sell_id = data[start_pos:end_pos]
                #print('Seller id:', sell_id)
            elif key == 'other_fee_description':
                fee_desc = data[start_pos:end_pos]
                #print('Fee Description:', fee_desc)
            #print(key, val, data[start_pos:end_pos])
            start_pos = end_pos
        #print(fee_desc[:13])
        if fee_desc[:13] == 'NONCOMPLIANCE':
            self.check_seller_id(sell_id, amt)
        else:
            print('Other_Fees_Record contains different fee other than NONCOMPLIANCE')

    def check_seller_id(self, sell_id, amt):
        '''
        Name        : checkSellerID
        Arguments   : Amex seller id and the amount
        Description : Retrieve the institution id and entity id using
                      the amex seller id
        Returns     : Nothing
        '''
        db_string = os.environ["IST_DB_USERNAME"] + '/'
        db_string = db_string + os.environ["IST_DB_PASSWORD"]
        db_string = db_string + '@' + os.environ["IST_DB"]
        con = cx_Oracle.connect(db_string)
        query_str = """
             select 
                  INSTITUTION_ID, ENTITY_ID 
             from ALT_MERCHANT_ID 
             where 
                  CARD_SCHEME = '03' and 
                  CS_MERCHANT_ID = :id"""
        cur = con.cursor()
        cur.execute(query_str, {'id':sell_id})
        query_str += ";\n"
        #print(query_str)
        query_result = cur.fetchone()
        if cur.rowcount != 0:
            inst_id = query_result[0]
            entity_id = query_result[1]
        else:
            print('NO ROWS FOUND')
        #print('Inst ID:', inst_id, 'Entity ID:', entity_id)
        if inst_id == '117' or inst_id == '122':
            print('Seller id belongs to either 117 or 122 instituton so ignored',\
                   sell_id, inst_id, entity_id)
        else:
            self.fee_list.append([inst_id, entity_id, amt])
        cur.close()
        con.close()

    def parse_amex_config_file(self, file_name):
        '''
        Name        : parseAmexConfigFile
        Arguments   : Amex TILR file
        Description : Parse Amex TILR file using Amex config file
        Returns     : Nothing
        '''
        config = configparser.ConfigParser()
        config.read('amex.cfg')
        #print(config.sections())
        with open(file_name) as file_pointer:
            for line in file_pointer:
                line = line.rstrip()
                #print(line[:5], line[42:45])
                val = self.rec_type_dict.get(line[:5], "NONE")
                if val != 'NONE':
                    data_dict = config[val]
                elif self.rec_type_dict.get(line[42:45], "NONE") != 'NONE':
                    val = self.rec_type_dict.get(line[42:45], "NONE")
                    #print('record name:', val)
                    data_dict = config[val]
                else:
                    print('Undefined Record')

                if val == 'Other_Fees_Record':
                    #self.display_record(data_dict, line)
                    self.parse_rec(data_dict, line)
