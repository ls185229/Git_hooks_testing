#!/usr/bin/env python
'''
$Id: nacha_parser_quick.py 4741 2018-10-12 19:55:23Z bjones $
$Rev: 4741 $
File Name      :  nacha_parser.py

Description    :  This library parses NACHA files.

Running options:   None

Shell Arguments:   None
Input          :   NACHA File
Output         :   Another NACHA File or a report

Return         :   None

'''
import os
import sys
import csv

if sys.version[0] == '2':
    import ConfigParser
else:
    import configparser

# import cx_Oracle
#config = None

"""
for line in file:
    record_type = line[0].strip()
    print(line)
    if record_type == '1':
        # file header
        file_id   = line[13:23].strip()
        as_of_date = line[23:29].strip()
        dest_name = line[40:63].strip()
        orig_name = line[63:86].strip()
        print("file header",(file_id, as_of_date, dest_name, orig_name) )
    elif record_type == 5:
        # company / batch header
        service_class   = line[2:4].strip()
        company_name    = line[5:29].strip()
    elif record_type == 6:
        pass
    elif record_type == 7:
        pass
    elif record_type == 8:
        pass
    elif record_type == 9:
        pass
"""

def try_parse(filename):
    file = open(filename)
    rpt_buffer = []
    settl_bank = '071000288'
    settl_acct = '0001829357'
    return_code = ''
    return_desc = ''
    acct_type = ''
    curr = '840'

    if sys.version[0] == '2':
        config = ConfigParser.ConfigParser()
    else:
        config = configparser.ConfigParser()
    config.read('ach_reason_code.cfg')
    code_list = 'ach_reason_code'

    line_to_print = [
        'As of Date',
        'File ID',
        'Company ID',
        'Company Name',

        'Settlement Bank ID',
        'Settlement Account',
        'Return Type Code',
        'Return Type Desc',
        'Currency',

        'Credit Amount',
        'Debit Amount',
        'Recipient ID',
        'Recipient Name',
        'Effective Date',
        'Descriptive Date',
        'Receiving Bank ID',
        #'check digit',
        'Receiving Account',
        'Company Entry Description',
        'Return Trace Number',

        'Account Type',

        'Return Reason Code',
        'Return Reason Description',
        'Original Trace Number', 'Search Result', 'Sequence #',
        'Addenda', 'Comments/Corrections',
        'As of Time'
        # ,
        #
        # 'Company data',
        # 'Std entry',
        # 'Orig dfi',
        # 'Tran code',
        # 'Amount',
        # 'Adn type code',
        # 'Dest name',
        # 'Orig name',
        # 'Service class',
        # 'Date of death',
        # 'Adn orig dfi'
        ]
    rpt_buffer.append(line_to_print)

    for line in file:
        record_type = line[0].strip()
        #print(line)
        if record_type == '1':
            # file header
            file_id         = line[13:23].strip()
            file_date       = line[23:29].strip()
            as_of_date      = file_date[2:4] + '/' + file_date[4:6] + '/20' + file_date[0:2]
            as_of_time      = line[29:31] + ':' + line[31:33]
            dest_name       = line[40:63].strip()
            orig_name       = line[63:86].strip()
            # print("file header",(file_id, as_of_date, dest_name, orig_name) )
        elif record_type == '5':
            # company / batch header
            service_class   = line[1:4].strip()
            company_name    = line[4:20].strip()
            company_data    = line[21:40].strip()
            company_id      = line[40:50].strip()
            std_entry       = line[50:53].strip()
            company_desc    = line[53:63].strip()
            company_date    = line[63:69].strip()
            descr_date      = company_date[2:4] + '/' + company_date[4:6] + '/20' + company_date[0:2]
            eff_date  = line[69:75].strip()
            effective_date      = eff_date[2:4] + '/' + eff_date[4:6] + '/20' + eff_date[0:2]
            orig_dfi        = line[79:87].strip()
            # print("batch_header", (service_class, company_name, company_data, company_id))
            # print("batch_header", (std_entry, company_desc, descr_date, effective_date, orig_dfi))

        elif record_type == '6':
            # entry detail
            adn_type_code   = ''
            return_reason   = ''
            return_descr    = ''
            orig_trace_nbr  = ''
            date_of_death   = ''
            adn_orig_dfi    = ''
            adn_info        = ''
            rtrn_trace_nbr  = ''




            tran_code       = line[ 1: 3].strip()
            receiving_dfi   = line[ 3:11].strip()
            check_digit     = line[11:12].strip()
            acct_nbr        = line[12:29].strip()
            amount          = line[29:37].strip() + "." + line[37:39].strip()
            recipient_id    = line[39:54].strip()
            recipient_name  = line[54:76].strip()
            discretionary   = line[76:78].strip()
            addenda_ind     = line[78:79]
            rtrn_trace_nbr  = line[79:94].strip()

            if tran_code[1] == '1':
                credit_amount = amount
                debit_amount = 0
            else:
                credit_amount = 0
                debit_amount = amount

            # print(tran_code, receiving_dfi, check_digit, acct_nbr, amount)
            # print(recipient_id, recipient_name)
            # print(discretionary, addenda_ind, rtrn_trace_nbr)
            if addenda_ind == '1':
                continue
            else:
                line_to_print = [
                    as_of_date,
                    "'" + file_id,
                    company_id,
                    company_name,

                    "'" + settl_bank,
                    "'" + settl_acct,
                    return_code,
                    return_desc,
                    curr,

                    credit_amount,
                    debit_amount,
                    recipient_id,
                    recipient_name,
                    effective_date,
                    descr_date,
                    "'" + receiving_dfi + check_digit,

                    "'" + acct_nbr,
                    company_desc,
                    rtrn_trace_nbr,

                    acct_type,

                    return_reason,
                    return_descr,
                    orig_trace_nbr, '', '',
                    "'" + adn_info, '',
                    as_of_time
                    # ,
                    #
                    # company_data,
                    # std_entry,
                    # "'" + orig_dfi,
                    # tran_code,
                    # amount,
                    # adn_type_code,
                    # dest_name,
                    # orig_name,
                    # service_class,
                    # date_of_death,
                    # "'" + adn_orig_dfi
                    ]
                rpt_buffer.append(line_to_print)

                #print(line_to_print)

        elif record_type == '7':
            adn_type_code   = line[ 1: 3].strip()
            return_reason   = line[ 3: 6].strip()
            orig_trace_nbr  = line[ 6:21].strip()
            date_of_death   = line[21:27].strip()
            adn_orig_dfi    = line[27:35].strip()
            adn_info        = line[35:79].strip()
            rtrn_trace_nbr  = line[79:94].strip()

            return_code     = return_reason[0]
            if return_code == 'C':
                return_desc = 'NOC'
            elif return_code == 'R':
                return_desc = 'Return'
            else:
                return_desc = 'Invalid'

            if config.has_option(code_list, return_reason):
               return_descr = config.get(code_list, return_reason)
            else:
                return_descr  = ''
            # print(adn_type_code, return_reason, orig_trace_nbr, date_of_death, adn_orig_dfi, adn_info)
            # print(rtrn_trace_nbr)

            line_to_print = [
                as_of_date,
                "'" + file_id,
                company_id,
                company_name,

                "'" + settl_bank,
                "'" + settl_acct,
                return_code,
                return_desc,
                curr,

                credit_amount,
                debit_amount,
                recipient_id,
                recipient_name,
                effective_date,
                descr_date,
                "'" + receiving_dfi + check_digit,

                "'" + acct_nbr,
                company_desc,
                rtrn_trace_nbr,

                acct_type,

                return_reason,
                return_descr,
                orig_trace_nbr, '', '',
                "'" + adn_info, '',
                as_of_time
                # ,
                #
                # company_data,
                # std_entry,
                # "'" + orig_dfi,
                # tran_code,
                # amount,
                # adn_type_code,
                # dest_name,
                # orig_name,
                # service_class,
                # date_of_death,
                # "'" + adn_orig_dfi
                ]

            rpt_buffer.append(line_to_print)

            #print(line_to_print)


        elif record_type == '8':
            service_class   = line[ 1: 4].strip()
            entry_count     = line[ 4:10].strip()
            entry_hash      = line[10:20].strip()
            debit_total_b   = line[20:32].strip()
            credit_total_b  = line[32:44].strip()
            tax_id          = line[44:54].strip()

            orig_dfi        = line[79:87].strip()
            batch_nbr       = line[87:94].strip()
            # print(service_class, entry_count, entry_hash, debit_total_b)
            # print(credit_total_b, tax_id, orig_dfi, batch_nbr)


        elif record_type == '9':
            # file control record
            batch_count     = line[ 2: 7].strip()
            block_count     = line[ 7:13].strip()
            entry_count     = line[13:21].strip()
            entry_hash      = line[21:31].strip()
            debit_total_f   = line[31:43].strip()
            credit_total_f  = line[43:55].strip()
            # print(batch_count, block_count, entry_count, entry_hash, debit_total_f)
            # print(credit_total_f)



    file.close()

    if sys.version[0] == '2':
        csvfile = open(filename + '.csv', 'w')
    else:
        csvfile = open(filename + '.csv', 'w', newline='')
    with csvfile:

        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerows(rpt_buffer)

if __name__ == "__main__":
    print( sys.argv[1] )
    try_parse(sys.argv[1])
