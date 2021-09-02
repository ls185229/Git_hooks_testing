#!/usr/bin/env python
'''
$Id: pin_debit_report.py 4455 2017-12-21 18:32:34Z skumar $
$Rev: 4455 $
File Name:  pin_debit_report.py

Description:  This script send the debit activity happened in a day
              processed or not.

Running options:

Shell Arguments:
                   -d = date (Optional)
                   -t = TEST MODE (Optional)
                   -v = verbose level

Output:       mail is sent to accouting

Return:   0 = Success
          !0 = Exit with errors
'''
import sys
import getopt
import datetime
import smtplib
from email.mime.text import MIMEText
import os
import cx_Oracle
mail_to = 'reports-clearing@jetpay.com'
mail_from = 'mas@jetpay.com'
program_name = None
alert_to = 'assist@jetpay.com, mas@jetpay.com'

def sendalert(inst_id, message):
    '''
    Name : sendalert
    Arguments: institution_id and message
    Description : send the alert whenever an error occured during the process
    Returns: Nothing
    '''
    msg = MIMEText(message)
    msg['Subject'] = 'Err in ' + program_name + ' : for INST ' + inst_id
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

def sendemail(inst_id, message, cur_day):
    '''
    Name : sendemail
    Arguments: institution_id and message
    Description : send the Debit activity in a day to the accouting and clearing group
    Returns: Nothing
    '''
    msg = MIMEText(message)
    msg['Subject'] = 'INST ' +inst_id + ' Debit Activity for ' + cur_day
    msg['From'] = mail_from
    msg['To'] = mail_to
    print(msg)
    try:
        mail_obj = smtplib.SMTP('localhost')
        resp = mail_obj.send_message(msg)
        mail_obj.quit()
        print('Successfully sent email', resp)
    except smtplib.SMTPException as err:
        print('Error: unable to send email ' + str(err))

def sendreport(con, inst_id, cur_day,prev_day):
    '''
    Name : sendreport
    Arguments: connection handler, institution_id and message
    Description : Retrieve the Debit activity in a day for a particular institution
    Returns: Nothing
    '''
    try:
        curr_day = cur_day.strftime("%Y%m%d") + '175959'
        pre_day = prev_day.strftime("%Y%m%d") + '180000'
        print('inside sendreport, cur_day : ', curr_day ,' prev_day: ', pre_day)
        query_str = """
            select
                substr(idpd.src_inst_id,1,4) Inst,
                substr(idpd.activity_dt,1,9) Activity_Date,
                count(idpd.pin_debit_trans_seq_nbr) Cnt,
                sum(idpd.amt_trans/100) as Amt,
                substr(t.description,1,30) Tran_Type
            from in_draft_pin_debit idpd
                join mas_code mc on idpd.mas_code = mc.mas_code
                join tid t on idpd.tid = t.tid
            where idpd.src_inst_id = '"""
        query_str += inst_id
        query_str += """'
            AND idpd.activity_dt >= to_date("""
        query_str += pre_day
        query_str += """,'YYYYMMDDHH24MISS')"""
        query_str += """
            AND idpd.activity_dt < to_date("""
        query_str += curr_day
        query_str += """,'YYYYMMDDHH24MISS')"""
        query_str += """
            group by substr(idpd.src_inst_id,1,4),
                     substr(idpd.activity_dt,1,9),
                     substr(t.description,1,30)
            order by substr(idpd.src_inst_id,1,4),
                     substr(idpd.activity_dt,1,9),
                     substr(t.description,1,30)"""
        cur = con.cursor()
        cur.execute(query_str)
        query_str += ";\n"
        print(query_str)
        query_result = cur.fetchall()
        #print(query_result[0])
        data = """
        Inst    Date                Count      Amount               Tran Type
        -----------------------------------------------------------------------
        """
        for element in query_result:
            for item in element:
                data = data + str(item) + "\t"
            data += "\n        "
        #print(data)
        cur_day = cur_day.strftime("%d-%b-%Y")
        sendemail(inst_id, data, cur_day)
        cur.close()
    except cx_Oracle.DatabaseError as err:
        error, = err.args
        if error.code == 1403:
            print('No rows returned', error.code)
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        sendalert(inst_id, err_msg)

def main(argv):
    '''
    Main function
    '''
    inst_id = None
    global program_name, mail_to, mail_from, alert_to

    cur_day = datetime.datetime.now()
    program_name = sys.argv[0]
    print(program_name)
    try:
        opts, args = getopt.getopt(argv, "hi:d:t:v", ["inst_id=", "date="])
    except getopt.GetoptError:
        print(program_name, ' -i <inst_id> -d <date> -t test@jetpay.com')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(program_name, ' -i <inst_id> -d <date> -t test@jetpay.com')
            sys.exit()
        elif opt in ("-i", "--inst_id"):
            inst_id = arg
        elif opt in ("-d", "--date"):
            cur_day = datetime.datetime.strptime(arg, "%Y%m%d").date()
        elif opt == '-t':
            mail_to = arg
            alert_to = arg
        elif opt == '-v':
            verbose = True
        else:
            print('Invalid option. Below is the usage')
            print(program_name, ' -i <inst_id> -d <date> -t test@jetpay.com')
            sys.exit()

    if not inst_id:
        print('Instituion ID is a required argument')
        print('pin_debit_report.py -i <inst_id> -d <date> -t -v')
        sys.exit()
    try:
        dt = datetime.timedelta (days=1)
        prev_day = cur_day - dt
        print('Current date: ', cur_day.strftime("%d-%b-%Y") + ' 175959 ' )
        print('Previous date: ', prev_day.strftime("%d-%b-%Y") + ' 180000 ')
        db_string = os.environ["IST_DB_USERNAME"] + '/' + os.environ["IST_DB_PASSWORD"]
        db_string = db_string + '@' + os.environ["IST_DB"]
        #print(db_string)
        con = cx_Oracle.connect(db_string)
        sendreport(con, inst_id, cur_day,prev_day)
        con.close()
    except Exception as err:
        err_msg = 'Error: During database connection or execution ' + str(err)
        print(err_msg)
        sendalert(inst_id, err_msg)


if __name__ == "__main__":
    main(sys.argv[1:])
