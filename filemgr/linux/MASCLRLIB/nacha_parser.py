#!/usr/bin/env python
'''
$Id: nacha_parser.py 4698 2018-09-11 22:39:25Z bjones $
$Rev: 4698 $
File Name      :  nacha_parser.py

Description    :  This library parses NACHA files.

Running options:   None

Shell Arguments:   None
Input          :   NACHA File
Output         :   Another NACHA File or a report

Return         :   None

'''
import os
import configparser
import cx_Oracle
#config = None

class AchFileClass():
    # Ach File Header Record
    fh_struct = (
        ['record_type'          , '1' , 'a', 'Record Type Code']    , \
        ['priority_code'        , '2' , 'a', 'Priority Code']       , \
        ['odfi'                 , '10', 'x', 'Destination RDFI']    , \
        ['company_id'           , '10', 'a', 'ACH Identification']  , \
        ['file_date'            , '6' , 'a', 'File Date']           , \
        ['file_time'            , '4' , 'a', 'File Time']           , \
        ['file_id_mod'          , '1' , 'a', 'File Date']           , \
        ['record_size'          , '3' , 'a', 'File Date']           , \
        ['blocking_factor'      , '2' , 'a', 'File Date']           , \
        ['format_code'          , '1' , 'a', 'File Date']           , \
        ['dest_name'            , '23', 'a', 'File Date']           , \
        ['orig_name'            , '23', 'a', 'File Date']           , \
        ['ref_code'             , '8' , 'a', 'Suspend Level']         \
        )

    # Ach Batch Header Record
    bh_struct = (
        ['record_type'          , '2' , 'a', 'Record Type Code']      , \
        ['service_class'        , '2' , 'a', 'Service Class Code']                          , \
        ['company_name'         , '16', 'x', 'File Date and Time']                 , \
        ['company_data'         , '16', 'a', 'Activity Source']                    , \
        ['company_id'           , '8' , 'a', 'Activity Job name']                  , \
        ['entry_class'          , '1' , 'a', 'Suspend Level']                        \
        ['entry_desc'           , '2' , 'a', 'Batch Header Transmission Type']     , \
        ['file_date'            , '3' , 'a', 'Currency of the batch']              , \
        ['effective_date'       , '16', 'x', 'System date and time']               , \
        ['reserved_01'          , '30', 'a', 'ID of the merchant']                 , \
        ['orig_status'          , '9' , 'n', 'Batch number']                       , \
        ['orig_dfi'             , '9' , 'n', 'File number']                        , \
        ['batch_nbr'            , '1' , 'a', 'Non Activity Batch Header Fee']      , \
        ['orig_batch_id'        , '9' , 'a', 'Original Batch ID']                  , \
        ['orig_file_id'         , '9' , 'a', 'Original File ID']                   , \
        ['ext_batch_id'         , '25', 'a', 'External Batch ID']                  , \
        ['ext_file_id'          , '25', 'a', 'External File ID']                   , \
        ['sender_id'            , '25', 'a', 'Merchant ID for the batch']          , \
        ['microfilm_nbr'        , '30', 'a', 'Microfilm Locator number']           , \
        ['institution_id'       , '10', 'a', 'Institution ID']                     , \
        ['batch_capture_dt'     , '16', 'a', 'Batch Capture Date and Time']          \
       )

    # Ach Batch Trailer Record
    bt_struct = (
        ['bttrans_type'         , '2' , 'a', 'Batch Trailer Transmission Type']    , \
        ['batch_amt'            , '12', 'n', 'Total Transaction Amount Batch']     , \
        ['batch_cnt'            , '10', 'n', 'Total Transaction count Batch']      , \
        ['batch_add_amt1'       , '12', 'n', 'Total additional1 amount Batch']     , \
        ['batch_add_cnt1'       , '10', 'n', 'Total additional1 count Batch']      , \
        ['batch_add_amt2'       , '12', 'n', 'Total additional2 amount Batch']     , \
        ['batch_add_cnt2'       , '10', 'n', 'Total additional2 count Batch']        \
        )

    # Ach File Trailer Record
    ft_struct = (
        ['fttrans_type'         , '2' , 'a', 'File Trailer Transmission Type']     , \
        ['file_amt'             , '12', 'n', 'Total Transaction Amount File']      , \
        ['file_cnt'             , '10', 'n', 'Total Transaction count File']       , \
        ['file_add_amt1'        , '12', 'n', 'Total additional1 amount File']      , \
        ['file_add_cnt1'        , '10', 'n', 'Total additional1 count File']       , \
        ['file_add_amt2'        , '12', 'n', 'Total additional2 amount File']      , \
        ['file_add_cnt2'        , '10', 'n', 'Total additional2 count File']         \
        )



for line in file:
