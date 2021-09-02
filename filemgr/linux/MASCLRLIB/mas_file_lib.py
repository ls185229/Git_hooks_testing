#!/usr/bin/env python
'''
$Id: mas_file_lib.py 4698 2018-09-11 22:39:25Z bjones $
$Rev: 4698 $
File Name      :  mas_file_lib.py

Description    :  This library define or create MAS file

Running options:   None

Shell Arguments:   None
Input          :   None
Output         :   MAS file

Return         :   None

'''

class MasFileClass():
    # MAS File Header Record
    fh_struct = (
        ['fhtrans_type', '2', 'a', 'File Header Transmission Type'],\
        ['file_type', '2', 'a', 'File Type'],\
        ['file_date_time', '16', 'x', 'File Date and Time'],\
        ['activity_source', '16', 'a', 'Activity Source'],\
        ['activity_job_name', '8', 'a', 'Activity Job name'],\
        ['suspend_level', '1', 'a', 'Suspend Level']\
        )

    # MAS Batch Header Record
    bh_struct = (
        ['bhtrans_type', '2', 'a', 'Batch Header Transmission Type'],\
        ['batch_curr', '3', 'a', 'Currency of the batch'],\
        ['activity_date_time_bh', '16', 'x', 'System date and time'],\
        ['merchant_id', '30', 'a', 'ID of the merchant'],\
        ['in_batch_nbr', '9', 'n', 'Batch number'],\
        ['in_file_nbr', '9', 'n', 'File number'],\
        ['bill_ind', '1', 'a', 'Non Activity Batch Header Fee'],\
        ['orig_batch_id', '9', 'a', 'Original Batch ID'],\
        ['orig_file_id', '9', 'a', 'Original File ID'],\
        ['ext_batch_id', '25', 'a', 'External Batch ID'],\
        ['ext_file_id', '25', 'a', 'External File ID'],\
        ['sender_id', '25', 'a', 'Merchant ID for the batch'],\
        ['microfilm_nbr', '30', 'a', 'Microfilm Locator number'],\
        ['institution_id', '10', 'a', 'Institution ID'],\
        ['batch_capture_dt', '16', 'a', 'Batch Capture Date and Time']\
       )

    # Mas Batch Trailer Record
    bt_struct = (
        ['bttrans_type', '2', 'a', 'Batch Trailer Transmission Type'],\
        ['batch_amt', '12', 'n', 'Total Transaction Amount in a Batch'],\
        ['batch_cnt', '10', 'n', 'Total Transaction count in a Batch'],\
        ['batch_add_amt1', '12', 'n', 'Total additional1 amount in a Batch'],\
        ['batch_add_cnt1', '10', 'n', 'Total additional1 count in a Batch'],\
        ['batch_add_amt2', '12', 'n', 'Total additional2 amount in a Batch'],\
        ['batch_add_cnt2', '10', 'n', 'Total additional2 count in a Batch']\
        )

    # Mas File Trailer Record
    ft_struct = (
        ['fttrans_type', '2', 'a', 'File Trailer Transmission Type'],\
        ['file_amt', '12', 'n', 'Total Transaction Amount in a File'],\
        ['file_cnt', '10', 'n', 'Total Transaction count in a File'],\
        ['file_add_amt1', '12', 'n', 'Total additional1 amount in a File'],\
        ['file_add_cnt1', '10', 'n', 'Total additional1 count in a File'],\
        ['file_add_amt2', '12', 'n', 'Total additional2 amount in a File'],\
        ['file_add_cnt2', '10', 'n', 'Total additional2 count in a File']\
        )

    # Mas Message Detail Record

    dt_struct = (
        ['mgtrans_type', '2', 'a', 'Message Detail Transmission Type'],\
        ['tid', '12', 'a', 'Unique Transmission identifier'],\
        ['merchant_id', '18', 'a', 'Internal entity id'],\
        ['card_scheme', '2', 'a', 'Card Scheme identifier'],\
        ['mas_code', '25', 'a', 'Mas Code'],\
        ['mas_code_downgrade', '25', 'a', 'Mas codes for Downgraded Transaction'],\
        ['nbr_of_items', '10', 'n', 'Number of items in the transaction record'],\
        ['amt_original', '12', 'n', 'Original amount of a Transaction'],\
        ['add_cnt1', '10', 'n', 'Number of items included in add_amt1'],\
        ['add_amt1', '12', 'n', 'Additional Amount 1'],\
        ['add_cnt2', '10', 'n', 'Number of items included in add_amt2'],\
        ['add_amt2', '12', 'n', 'Additional Amount 2'],\
        ['external_trans_id', '25', 'a', 'The external transaction id'],\
        ['trans_ref_data', '23', 'a', 'Reference Data'],\
        ['suspend_reason', '2', 'a', 'The Suspend reason code']\
        )

    def __init__(self):
        tmp = ''

    def write_fh_rec(self, file_id, val):
        '''
        Name        : write_fh_rec
        Arguments   : file pointer, data structure
        Description : Creates the file header using the data structure
        Returns     : Nothing
        '''
        rec = {}
        rec['rec_type'] = "FH"
        rec['fhtrans_type'] = "FH"
        rec['file_type'] = "01"
        rec['file_date_time'] = val['file_date_time']
        rec['activity_source'] = "JETPAYLLC"
        rec['activity_job_name'] = "MAS"
        rec['suspend_level'] = "T"
        self.write_rec(file_id, rec)

    def write_bh_rec(self, file_id, val):
        '''
        Name        : write_bh_rec
        Arguments   : file pointer, data structure
        Description : Creates the batch header using the data structure
        Returns     : Nothing
        '''
        nine_spaces = '         '
        tw_five_spaces = '                    '
        th_spaces = '                              '
        rec = {}
        rec['rec_type'] = 'BH'
        rec['bhtrans_type'] = 'BH'
        rec['batch_curr'] = val['batch_curr']
        rec['activity_date_time_bh'] = val['activity_date_time_bh']
        rec['merchant_id'] = val['merchant_id']
        rec['in_batch_nbr'] = val['in_batch_nbr']
        rec['in_file_nbr'] = val['in_file_nbr']
        rec['bill_ind'] = 'N'
        rec['orig_batch_id'] = nine_spaces
        rec['orig_file_id'] = nine_spaces
        rec['ext_batch_id'] = tw_five_spaces
        rec['ext_file_id'] = tw_five_spaces
        rec['sender_id'] = val['sender_id']
        rec['microfilm_nbr'] = th_spaces
        rec['institution_id'] = val['institution_id']
        rec['batch_capture_dt'] = val['batch_capture_dt']
        self.write_rec(file_id, rec)

    def write_det_rec(self, file_id, val):
        '''
        Name        : write_det_rec
        Arguments   : file pointer, data structure
        Description : Creates the detail record using the data structure
        Returns     : Nothing
        '''
        ten_zero = '0000000000'
        tw_zero = '000000000000'
        rec = {}
        rec['rec_type'] = 'DT'
        rec['mgtrans_type'] = '01'
        rec['tid'] = val['tid']
        rec['merchant_id'] = val['merchant_id']
        rec['card_scheme'] = val['card_scheme']
        rec['mas_code'] = val['mas_code']
        rec['mas_code_downgrade'] = val['mas_code_downgrade']
        rec['nbr_of_items'] = val['nbr_of_items']
        rec['amt_original'] = val['amt_original']
        rec['add_cnt1'] = ten_zero
        rec['add_amt1'] = tw_zero
        rec['add_cnt2'] = ten_zero
        rec['add_amt2'] = tw_zero
        rec['external_trans_id'] = val['external_trans_id']
        rec['trans_ref_data'] = val['trans_ref_data']
        rec['suspend_reason'] = '  '
        self.write_rec(file_id, rec)

    def write_bt_rec(self, file_id, val):
        '''
        Name        : write_bt_rec
        Arguments   : file pointer, data structure
        Description : Creates the batch trailer record using the data structure
        Returns     : Nothing
        '''
        ten_zero = '0000000000'
        tw_zero = '000000000000'
        rec = {}
        rec['rec_type'] = 'BT'
        rec['bttrans_type'] = 'BT'
        rec['batch_amt'] = val['batch_amt']
        rec['batch_cnt'] = val['batch_cnt']
        rec['batch_add_amt1'] = tw_zero
        rec['batch_add_cnt1'] = ten_zero
        rec['batch_add_amt2'] = tw_zero
        rec['batch_add_cnt2'] = ten_zero
        self.write_rec(file_id, rec)

    def write_ft_rec(self, file_id, val):
        '''
        Name        : write_ft_rec
        Arguments   : file pointer, data structure
        Description : Creates the file trailer record using the data structure
        Returns     : Nothing
        '''
        ten_zero = '0000000000'
        tw_zero = '000000000000'
        rec = {}
        rec['rec_type'] = 'FT'
        rec['fttrans_type'] = 'FT'
        rec['file_amt'] = val['file_amt']
        rec['file_cnt'] = val['file_cnt']
        rec['file_add_amt1'] = tw_zero
        rec['file_add_cnt1'] = ten_zero
        rec['file_add_amt2'] = tw_zero
        rec['file_add_cnt2'] = ten_zero
        self.write_rec(file_id, rec)

    def write_rec(self, file_id, rec):
        '''
        Name        : write_bh_rec
        Arguments   : file pointer, data structure
        Description : Creates the record based on the record type passed
                      using the data structure, fills spaces or zeros
                      based on the type of the field
        Returns     : Nothing
        '''
        if rec['rec_type'] == 'FH':
            struct_type = self.fh_struct
        elif rec['rec_type'] == 'FT':
            struct_type = self.ft_struct
        elif rec['rec_type'] == 'BH':
            struct_type = self.bh_struct
        elif rec['rec_type'] == 'BT':
            struct_type = self.bt_struct
        elif rec['rec_type'] == 'DT':
            struct_type = self.dt_struct
        line = ""
        for (name, leng, typ, desc) in struct_type:
            #print(name, leng)
            #line += rec[name]
            if typ == 'n':
                line += rec[name].zfill(int(leng))
            elif typ == 'a':
                line += '{:{leng}}'.format(rec[name], leng=leng)
            elif typ == 'x':
                line += '{:{leng}}'.format(rec[name], leng=leng)
                #line += rec[name]
        #print(line)
        line += '\n'
        file_id.write(line)
