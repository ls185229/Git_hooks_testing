#!/usr/bin/env python
'''
$Id: amex_mas_fee_from_tilr.py 4455 2017-12-21 18:32:34Z skumar $
$Rev: 4455 $
File Name      :  amex_mas_fee_from_tilr.py

Description    :  This script creates MAS file from Amex TILR file 

Running options:

Shell Arguments:
                   -d = date (Optional)
                   -t = TEST MODE (Optional)
                   -v = verbose level
Input          :   Amex TILR file
Output         :   MAS fee file

Return         :   0 = Success
                  !0 = Exit with errors
'''
import os
import sys
import getopt
import datetime
import smtplib
from email.mime.text import MIMEText
import configparser
import cx_Oracle
from subprocess import call
import glob
from random import randint

import sys
import os.path

sys.path.append(os.path.join(os.path.dirname(__file__), '/clearing/filemgr/MASCLRLIB'))

from amex_file_parser import AmexTilrClass
from mas_file_lib import MasFileClass
from build_file_name import BuildFileNameClass

def sendalert(message):
    '''
    Name : sendalert
    Arguments:  message
    Description : send the alert whenever an error occurred during the process
    Returns: Nothing
    '''
    msg = MIMEText(message)
    msg['Subject'] = 'Err in ' + program_name 
    msg['From'] = mail_from
    msg['To'] = alert_to
    print(msg)
    try:
        mail_obj = smtplib.SMTP('localhost')
        resp = mail_obj.send_message(msg)
        mail_obj.quit()
        print('Successfully sent email', resp)
    except smtplib.SMTPException as err:
        print('Error: unable to send alert email ' + str(err))
        
        
def parseAmexMakeMas(src_file_name, dest_cmd, cur_day):
    '''
    Name        : parseAmexMakeMas
    Arguments   : Amex TILR file name, Destination command and the date
    Description : Parse the Amex TILR file and create a MAS file
                  if non compliance fee is present.
    Returns     : Nothing
    '''
    try:
        day = cur_day.strftime("%Y%m%d%H%M%S00")
        j_date = cur_day.strftime('%y%j')
        file_name = glob.glob(src_file_name)
        #print(file_name[0])
        amexObj = AmexTilrClass()
        amexObj.parseAmexConfigFile(file_name[0])
        fee_list = sorted(amexObj.fee_list, key=lambda x: x[0])
        cnt = len(fee_list)
        cur_inst_id = ''
        cur_merch_id = ''
        file_ptr = None
        fileName = BuildFileNameClass()
        f_type = 'AMXNONCM'
        if cnt == 0:
            print('In Amex TILR file, there is no non compliance fees')
        else:
            for x in range(cnt):
                tmp_fee_list = fee_list[x]
                inst_id = tmp_fee_list[0]
                merch_id = tmp_fee_list[1]
                amt = tmp_fee_list[2]
        
                if inst_id != cur_inst_id:
                    if file_ptr != None:
                        record = {}
                        record['batch_amt'] = str(batch_amt)
                        record['batch_cnt'] = str(batch_cnt)
                        masFileObj.write_bt_rec(file_ptr, record)
                         
                        record = {}          
                        record['file_amt'] = str(file_amt)
                        record['file_cnt'] = str(file_cnt)
                        masFileObj.write_ft_rec(file_ptr, record)
                        file_ptr.close()
                        dest_cmd = "scp -q " + mas_f_name + dest_cmd
                        mv_cmd = "mv " + mas_f_name + " ARCHIVE/"
                        ret = call(dest_cmd.split(" "))
                        if ret == 0:
                            os.system(mv_cmd)
                        else:
                            print('MAS file failed to transfer ', server_name)
                    
                    mas_f_name = fileName.getFileName(inst_id, f_type, j_date)
                    print('Output file name', mas_f_name)
                    file_ptr = open(mas_f_name, "w")
                    masFileObj = MasFileClass()
                    record = {}
                    file_cnt = 0
                    file_amt = 0
                    record['file_date_time'] = day
                    masFileObj.write_fh_rec(file_ptr, record)
            
                #print(f[0], f[1], f[2])
                if merch_id != cur_merch_id:
                    if file_cnt != 0:
                        record = {}
                        record['batch_amt'] = str(batch_amt)
                        record['batch_cnt'] = str(batch_cnt)
                        masFileObj.write_bt_rec(file_ptr, record)
                    
                    record = {}
                    batch_cnt = 0
                    batch_amt = 0
                    record['batch_curr'] = '840'
                    record['activity_date_time_bh'] = day
                    record['merchant_id'] = merch_id
                    record['in_batch_nbr'] = str(randint(0,999999))
                    record['in_file_nbr'] = str(randint(0,999999))
                    record['institution_id'] = inst_id
                    record['batch_capture_dt'] = day
                    record['sender_id'] = merch_id
                    masFileObj.write_bh_rec(file_ptr, record)
                
                record = {}
                batch_amt += int(amt)
                batch_cnt += 1
                record['merchant_id'] = merch_id
                record['card_scheme'] = '03'
                record['tid'] = '010070020001'
                record['mas_code'] = 'AMX_NON_COMP'
                record['mas_code_downgrade'] = ''
                record['nbr_of_items'] = str(1)
                record['amt_original'] = str(amt)
                record['external_trans_id'] = str(randint(0,999999))
                record['trans_ref_data'] = ''
                masFileObj.write_det_rec(file_ptr, record)
                
                file_amt += batch_amt
                file_cnt += 1
                cur_inst_id = inst_id
                cur_merch_id = merch_id
        
        if file_ptr != None:
            record = {}
            record['batch_amt'] = str(batch_amt)
            record['batch_cnt'] = str(batch_cnt)
            masFileObj.write_bt_rec(file_ptr, record)
        
            record = {}          
            record['file_amt'] = str(file_amt)
            record['file_cnt'] = str(file_cnt)
            masFileObj.write_ft_rec(file_ptr, record)
            file_ptr.close()
            dest_cmd = "scp -q " + mas_f_name + dest_cmd
            ret = call(dest_cmd.split(" "))
            mv_cmd = "mv " + mas_f_name + " ARCHIVE/"
            if ret == 0:
                os.system(mv_cmd)
            else:
                print('Unable to transfer the MAS file to ', server_name)
    except Exception as err:
        err_msg = 'Error: During parsing Amex TILR file or making MAS file in '
        err_msg = err_msg + str(err)
        print(err_msg)
        sendalert(err_msg)                

                
def main(argv):
    '''
    Main function
    '''
    global program_name, mail_to, mail_from, alert_to
    src_file_path = "/clearing/filemgr/AMEX/SETTLEMENT/TILR/ARCHIVE/"
    dest_file_path = "/clearing/filemgr/MAS/TEMP/MAS_FILES/"
    server_name = "filemgr@dfw-prd-mas-01.jetpay.com"
    cur_day = datetime.datetime.now()
    program_name = sys.argv[0]
    print(program_name)
    dest_file_path = "/clearing/filemgr/MAS/MAS_FILES/"
    try:
        opts, args = getopt.getopt(argv, "hi:d:tv", ["inst_id=", "date="])
    except getopt.GetoptError:
        print(program_name, ' -d <date> -t test@jetpay.com')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(program_name, ' -d <date> -t test@jetpay.com')
            sys.exit()
        elif opt in ("-d", "--date"):
            cur_day = datetime.datetime.strptime(arg, "%Y%m%d").date()
        elif opt == '-t':
            mail_to = arg
            alert_to = arg
            dest_file_path = "/clearing/filemgr/MAS/TEMP/MAS_FILES/"
        elif opt == '-v':
            verbose = True
        else:
            print('Invalid option. Below is the usage')
            print(program_name, ' -d <date> -t test@jetpay.com')
            sys.exit()

    try:
        f_date = cur_day.strftime("%Y%m%d")
        #print('date: ', f_date)
        src_file_name = "JETPAYPRD.EPTRN*." + f_date
        
        cmd = "scp -q " + server_name + ":" + src_file_path + src_file_name + " ."  
        ret = call(cmd.split(" "))
        
        dest_cmd = " " + server_name + ":" + dest_file_path
        
        if ret == 0:
            parseAmexMakeMas(src_file_name, dest_cmd, cur_day)
            mv_cmd = "mv " + src_file_name + " ARCHIVE/"
            os.system(mv_cmd)                
        else:
            print('No Amex TILR File Found')
            
    except Exception as err:
        err_msg = 'Error: During parsing Amex TILR file or making MAS file '
        err_msg = err_msg + str(err)
        print(err_msg)
        sendalert(err_msg)
        
if __name__ == "__main__":
    main(sys.argv[1:])