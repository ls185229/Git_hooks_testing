#!/usr/bin/env python3
'''
File Name:  import_tqr4.py

Description:  Import the TSYS provided TQR4 spreadsheet into MASCLR.MDR.

Output:       Results are loaded into MASCLR.MDR and pushed into MASCLR.IN_DRAFT_MAIN

Return:   0 = Success
          !0 = Exit with errors
'''

import sys, getopt
import datetime
import cx_Oracle
import os
import configparser
import traceback

Config = configparser.ConfigParser()
Config.read('mast_tqr4_import.cfg')

# Production (os.environ["IST_HOST"])
# dbHostname=os.environ["CLEARING_HOST_NAME"]
# dbUsername=os.environ["IST_DB_USERNAME"]
# dbPassword=os.environ["IST_DB_PASSWORD"]
# dbServiceName=os.environ["IST_SERVERNAME"]

libraryPath = Config['DEFAULT']['LIB_PATH']

emailFrom = Config['EMAIL']['EMAIL_FROM']
emailToAlert = Config['EMAIL']['EMAIL_TO_ALERT']
emailToStatus = Config['EMAIL']['EMAIL_TO_STATUS']
emailSubjectAlert = Config['EMAIL']['EMAIL_SUBJECT_ALERT']
emailSubjectStatus = Config['EMAIL']['EMAIL_SUBJECT_STATUS']


sys.path.append(libraryPath)

from database_class import DbClass
from email_class import EmailClass

output = ""
pathName = ""
singleFile = ""

FILE_DT = ""
FILE_ID = ''
MESSAGE_NBR = ''
ignoreDuplicates = False
inserted = []
errors = []

# read_spreadsheet - process spreadsheet and insert results into MASCLR.MDR
def processTQR4(dbObj, filename):
    """
    read_spreadsheet() read the contents of the "Recon_Report_MM-DD-YYYY_MM-DD-YYYY.xls"
    spreadsheet for import into MASCLR.MDR
    """
    lineNo = 0
    global FILE_DT
    name = os.path.basename(filename)
    FILE_DT = name[8:12] + name[13:15] + name[16:18] + name[19:21] + name[22:24] + name[25:27]
    mdr_cursor = dbObj.OpenCursor()

    print('Processing {filename} FILE_DT={FILE_DT}'.format(filename=filename, FILE_DT=FILE_DT))

    inputFile = open(filename, 'r')
    lineNo += 1
    line = inputFile.readline()
    while line:
        if line == "" or len(line) < 805:
            line = inputFile.readline()
            continue
        # line = inputFile.readline()
        # print('Line = {line}'.format(line=line))
        FILE_ID = line[0:25]
        MESSAGE_NBR = line[25:33]
        CLAIM_ID = line[33:52]
        EVENT_ID = line[52:71]
        CYCLE_ID = line[71:81]
        ARN = line[81:104]
        MTI = line[104:108]
        PAN = line[108:127]
        PROCESSING_CD = line[127:133]
        FUNCTION_CD = line[133:136]
        MESSAGE = line[136:140]
        AMOUNT_TRANS = line[140:152]
        AMOUNT_RECON = line[152:164]
        AMOUNT_BILLING = line[164:176]
        TRAN_CURR_CD = line[176:179]
        RECON_CURR_CD = line[179:182]
        CH_BILLING_CURR_CD = line[182:185]
        # AMOUNT_REQ_ISS_CURR = line[190:194]
        CURRENCY_EXP = line[188:189] # line[185:189]
        CH_BILLING_CURR_EXP = line[196:197]
        RETRIEVAL_REF_NBR = line[197:209]
        CARD_ACCEPTOR_BUS_CD = line[209:213]
        CARD_ACCEPTOR_ID = line[213:228]
        CARD_ACCEPTOR_NAME = line[228:250]
        TRANSACTION_DT = line[250:262]
        TRANSACTION_ORIG_INST_ID_CD = line[262:273]
        TRANSACTION_DEST_INST_ID_CD = line[273:284]
        STATUS = line[284:291]
        REJECTION_REASON = line[291:803]
        REVERSAL_FLAG = line[803:804]
        
 
        try:
            mdr_sql = """
            INSERT INTO MASCLR.MDR(FILE_ID, MESSAGE_NBR, CLAIM_ID, EVENT_ID, CYCLE_ID, ARN, MTI, PAN, PROCESSING_CD, FUNCTION_CD, MESSAGE, AMOUNT_REG, AMOUNT_RECON, AMOUNT_REQ_ISS_CURR, RECON_CURR_CD, CH_BILLING_CURR_CD, CURRENCY_EXP, RETRIEVAL_REF_NBR, CARD_ACCEPTOR_BUS_CD, CARD_ACCEPTOR_ID, CARD_ACCEPTOR_NAME, TRANSACTION_DT, TRANSACTION_ORIG_INST_ID_CD, TRANSACTION_DEST_INST_ID_CD, STATUS, REJECTION_REASON, REVERSAL_FLAG, FILE_DT) 
            VALUES 
            (:FILE_ID, :MESSAGE_NBR, :CLAIM_ID, :EVENT_ID, :CYCLE_ID, :ARN, :MTI, :PAN, :PROCESSING_CD, :FUNCTION_CD, :MESSAGE, :AMOUNT_REG, :AMOUNT_RECON, :AMOUNT_REQ_ISS_CURR, :RECON_CURR_CD, :CH_BILLING_CURR_CD, :CURRENCY_EXP, :RETRIEVAL_REF_NBR, :CARD_ACCEPTOR_BUS_CD, :CARD_ACCEPTOR_ID, :CARD_ACCEPTOR_NAME, :TRANSACTION_DT, :TRANSACTION_ORIG_INST_ID_CD, :TRANSACTION_DEST_INST_ID_CD, :STATUS, :REJECTION_REASON, :REVERSAL_FLAG, :FILE_DT)
            """
            mdr_vars = {
                'FILE_ID': FILE_ID,
                'MESSAGE_NBR': MESSAGE_NBR,
                'CLAIM_ID': CLAIM_ID,
                'EVENT_ID': EVENT_ID,
                'CYCLE_ID': CYCLE_ID,
                'ARN': ARN,
                'MTI': MTI,
                'PAN': PAN,
                'PROCESSING_CD': PROCESSING_CD,
                'FUNCTION_CD': FUNCTION_CD,
                'MESSAGE': MESSAGE,
                'AMOUNT_REG': AMOUNT_TRANS,
                'AMOUNT_RECON': AMOUNT_RECON,
                'AMOUNT_REQ_ISS_CURR': TRAN_CURR_CD,
                'RECON_CURR_CD': RECON_CURR_CD,
                'CH_BILLING_CURR_CD': CH_BILLING_CURR_CD,
                'CURRENCY_EXP': CURRENCY_EXP,
                'RETRIEVAL_REF_NBR': RETRIEVAL_REF_NBR,
                'CARD_ACCEPTOR_BUS_CD': CARD_ACCEPTOR_BUS_CD,
                'CARD_ACCEPTOR_ID': CARD_ACCEPTOR_ID,
                'CARD_ACCEPTOR_NAME': CARD_ACCEPTOR_NAME,
                'TRANSACTION_DT': TRANSACTION_DT,
                'TRANSACTION_DEST_INST_ID_CD': TRANSACTION_DEST_INST_ID_CD,
                'TRANSACTION_ORIG_INST_ID_CD': TRANSACTION_ORIG_INST_ID_CD,
                'STATUS': STATUS,
                'REJECTION_REASON': REJECTION_REASON.rstrip(),
                'REVERSAL_FLAG': REVERSAL_FLAG,
                'FILE_DT': FILE_DT 
            }
            dbObj.dbCursor[mdr_cursor].execute(mdr_sql, mdr_vars)
            # dbObj.ExecuteQuery(mdr_cursor, mdr_sql, mdr_vars)
            inserted.append("FILE_DT={FILE_DT} FILE_ID={FILE_ID} MESSAGE_NBR={MESSAGE_NBR}".format(FILE_DT=FILE_DT, FILE_ID=FILE_ID, MESSAGE_NBR=MESSAGE_NBR))
        except cx_Oracle.DatabaseError as dbException:
            # error, = dbObj._DbClass__errorMessage
            error, = dbException.args
            if ignoreDuplicates and "ORA-00001" in error.message:                
                errors.append("Duplicate: FILE_DT={FILE_DT} FILE_ID={FILE_ID} MESSAGE_NBR={MESSAGE_NBR}".format(FILE_DT=FILE_DT, FILE_ID=FILE_ID, MESSAGE_NBR=MESSAGE_NBR))
            else:
                print("Error while processing:")
                print("FILE_DT={FILE_DT} FILE_ID={FILE_ID} MESSAGE_NBR={MESSAGE_NBR}".format(FILE_DT=FILE_DT, FILE_ID=FILE_ID, MESSAGE_NBR=MESSAGE_NBR))
                print("DB ERROR: code={code}, offset={offset}, message={msg}".format(code=error.code, offset=error.offset, msg=error.message))
                dbObj.Rollback()
                raise(error)

        line = inputFile.readline()
        lineNo += 1

    dbObj.Commit()
    dbObj.CloseCursor(mdr_cursor)


def dateTransformDMY(dt):
    return dt[6:10] + dt[3:5] + dt[0:2] + dt[11:13] + dt[14:16] + dt[17:19]

def dateTransformMDY(dt):
    return dt[6:10] + dt[0:2] + dt[3:5] + dt[11:13] + dt[14:16] + dt[17:19]

def insert_representments(dbObj, file_dt):
    """
    insert_representments will run the stored procedure insert_representments 
    on MASCLR and retrieve the number of rows inserted into IN_DRAFT_MAIN.
    """    
    try:
        print('Running stored procedure "insert_representments" on {file_dt}'.format(file_dt=file_dt))
        cur = dbObj.dbConnection.cursor()
        inserted_records = cur.var(cx_Oracle.NUMBER)
        cur.callproc('insert_representments', [file_dt, inserted_records])
        print("{inserted_records} Records inserted into IN_DRAFT_MAIN".format(inserted_records=inserted_records.getvalue()))
    except Exception:
        raise
    finally:
        cur.close()

def sendAlertEmail(msg):
    emailObj = EmailClass(TO_ADDRESS=(emailToAlert),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=emailSubjectAlert)
    emailObj.SendEmail()


def sendStatusEmail(msg):
    emailObj = EmailClass(TO_ADDRESS=(emailToStatus),
                          EMAIL_BODY=msg,
                          FROM_ADDRESS=emailFrom,
                          EMAIL_SUBJECT=emailSubjectStatus + " " + datetime.datetime.today().strftime(
                              "%Y-%m-%d %H:%M:%S"))
    emailObj.SendEmail()


if __name__ == "__main__":
    opts, args = getopt.getopt(sys.argv[1:], "f:h:i")
    for opt, a in opts:
        if opt in ('-f'):
            singleFile = a
        elif opt in ('-i'):
            ignoreDuplicates = True
        else:
            print("import_tqr4.py -f <filename to import>")
            print("  Import TQR4 spreadsheet into MASCLR.MDR ")
            print("  -f = Filename")
            print("           python import_tqr4.py -f \"TTQR4T0.2020-02-11-21-05-03.001\"")
            exit(0)
    
    print("")
    try:
        # *** TESTING: Enable the line below to connect to authqa
        # dbObj = DbClass(HOSTNM="dfw-qa-db-01.jetpay.com", PORTNO="1521", USERID="masclr", PASSWD="masclr", SERVNM="authqa.jetpay.com")
        # *** PRODUCTION: Enable the line below to connect using environment variables
        dbObj = DbClass(ENV_HOSTNM='IST_HOST', \
        ENV_USERID='IST_DB_USERNAME', \
        ENV_PASSWD='IST_DB_PASSWORD', \
        PORTNO='1521', \
        ENV_SERVNM='IST_SERVERNAME' \
        )
        dbObj.Connect()       
    except Exception as e:
        print('*** ERROR: {e}'.format(e=e))
        exit(1)
    
    try:
        errors.clear()
        inserted.clear()
        processTQR4(dbObj, singleFile)
        basename = os.path.basename(singleFile)
        FILE_DT = basename[8:12] + basename[13:15] + basename[16:18] + basename[19:21] + basename[22:24] + basename[25:27]
        insert_representments(dbObj, FILE_DT)   
        message_text = "The following occurred while processing {basename}\n\n".format(basename=basename)
        message_text += "Records inserted:\n"
        message_text += '\n'.join([str(x) for x in inserted])
        message_text += "\n\n"
        message_text += "The following errors occured while updating:\n"
        message_text += '\n'.join([str(x) for x in errors])
        print(message_text)
        sendStatusEmail(message_text)
        print('The following file {FILE_DT} has been imported'.format(FILE_DT=FILE_DT))
        print("Done")    
    except Exception as e:
        print('*** ERROR: {e}'.format(e=e))
        sendAlertEmail('The following file {basename} failed to import.\n\nError={error}'.format(basename=basename,error=e.args))
        for line in traceback.format_stack():
            print(line.strip())
        exit(1)
    finally:
        dbObj.Disconnect()


    dbObj.Disconnect()
    print("------------------------------------------------------------------------------")
    print("Import complete")
    exit(0)


